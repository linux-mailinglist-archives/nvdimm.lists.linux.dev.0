Return-Path: <nvdimm+bounces-660-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF583DADA4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 29 Jul 2021 22:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0AF0A3E143C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 29 Jul 2021 20:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE66A3485;
	Thu, 29 Jul 2021 20:33:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168E3481
	for <nvdimm@lists.linux.dev>; Thu, 29 Jul 2021 20:33:16 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5F960F4A;
	Thu, 29 Jul 2021 20:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1627590796;
	bh=GTe1YaWlZ3f8sinXX6wYwfDdFtcugLHScE88pGkRVC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rYZJ+S4lX0VUutKB2sA2VoK5v6J7gyvPu3LQIBktomqb7U0z4KKIpRLkR8bRNEHxX
	 E706+T9JV9eGDe8m0c2eZHB8QrMERLUdlgPJOm318SyWZ1QBwocP0+wJ2QwozY9I28
	 8cjOP0TlhwDf3bj3D3W+bOBvTJ8JHoKYP0jJzGI2xquxbSfs8mlJIvfpG6d8oLsiYA
	 HiJ5PdLyBUEk1iR4jqmFZ00iXyEuLUv7VE58pa5IVLvqKtZZCZ8VrVVrZWbF99tJR7
	 myljnOHGA6odf5JByOMg7MzhujiGyzop26Fu9p/7ptcM64LRIDWI8dvSExOH6rPuYE
	 O/U92+T++nB4w==
Date: Thu, 29 Jul 2021 13:33:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com,
	Jan Kara <jack@suse.cz>
Subject: Re: RFC: switch iomap to an iterator model
Message-ID: <20210729203316.GF3601466@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-1-hch@lst.de>

On Mon, Jul 19, 2021 at 12:34:53PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series replies the existing callback-based iomap_apply to an iter based
> model.  The prime aim here is to simply the DAX reflink support, which

Jan Kara pointed out that recent gcc and clang support a magic attribute
that causes a cleanup function to be called when an automatic variable
goes out of scope.  I've ported the XFS for_each_perag* macros to use
it, but I think this would be roughly (totally untested) what you'd do
for iomap iterators:

/* automatic iteration cleanup via macro hell */
struct iomap_iter_cleanup {
	struct iomap_ops	*ops;
	struct iomap_iter	*iter;
	loff_t			*ret;
};

static inline void iomap_iter_cleanup(struct iomap_iter_cleanup *ic)
{
	struct iomap_iter *iter = ic->iter;
	int ret2 = 0;

	if (!iter->iomap.length || !ic->ops->iomap_end)
		return;

	ret2 = ops->iomap_end(iter->inode, iter->pos,
			iomap_length(iter), 0, iter->flags,
			&iter->iomap);

	if (ret2 && *ic->ret == 0)
		*ic->ret = ret2;

	iter->iomap.length = 0;
}

#define IOMAP_ITER_CLEANUP(pag)	\
	struct iomap_iter_cleanup __iomap_iter_cleanup \
			__attribute__((__cleanup__(iomap_iter_cleanup))) = \
			{ .iter = (iter), .ops = (ops), .ret = &(ret) }

#define for_each_iomap(iter, ops, ret) \
	(ret) = iomap_iter((iter), (ops)); \
	for (IOMAP_ITER_CLEANUP(iter, ops, ret); \
		(ret) > 0; \
		(ret) = iomap_iter((iter), (ops)) \

Then we actually /can/ write our iteration loops in the normal C style:

	struct iomap_iter iter = {
		.inode = ...,
		.pos = 0,
		.length = 32768,
	};
	loff_t ret = 0;

	for_each_iomap(&iter, ops, ret) {
		if (iter.iomap.type != WHAT_I_WANT)
                        break;

		ret = am_i_pissed_off(...);
		if (ret)
			return ret;
	}

	return ret;

and ->iomap_end will always get called.  There are a few sharp edges:

I can't figure out how far back clang and gcc support this attribute.
The gcc docs mention it at least far back as 3.3.6.  clang (afaict) docs
don't reference it directly, but the clang 4 docs claim that it can be
as pedantic as gcc w.r.t. attribute use.  That's more than new enough
for upstream, which requires gcc 4.9 or clang 10.

The /other/ problem is that gcc gets fussy about defining variables
inside the for loop parentheses, which means that any code using it has
to compile with -std=gnu99, which is /not/ the usual c89 that the kernel
uses.  OTOH, it's been 22 years since C99 was ratified, c'mon...

--D

