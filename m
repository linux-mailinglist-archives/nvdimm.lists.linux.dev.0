Return-Path: <nvdimm+bounces-867-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F5C3EAA23
	for <lists+linux-nvdimm@lfdr.de>; Thu, 12 Aug 2021 20:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 47D001C0F97
	for <lists+linux-nvdimm@lfdr.de>; Thu, 12 Aug 2021 18:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3437229D6;
	Thu, 12 Aug 2021 18:20:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E161168
	for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 18:20:18 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF3C6101E;
	Thu, 12 Aug 2021 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628792418;
	bh=JybdGtheLHN3Mj/Zwakwlx9WQpCJZ2NuJAvWParHJto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFH2rvwIoIIyxoMUpG0SEHMNKtZWT90znpawNzy+LcqrnnvxZyloXVsddWvzunBNe
	 lRLQfbTu5pA3ON6dfVoaAwUtL4wu5CL3YQlGIlcuJ1guXlLKmGjl4mg/YTJZDa9CO2
	 rCQQ7A/ip6oZM912DmWf8QPms534KD6KUMzPulUlrBvkf2ZbFYuruORMVPpL4soor3
	 kw3tkhe/17TY17pmISITlT99RBuVV1CkAF/Yu1KYOu4F00/Io8kj763H9E/4Pe9oaH
	 J2nt4EYV091LTCNdXMhE5xEA1r/vmUAMYx/6P3FIwDqkuVkewpcVEI4qjOgUmTpJGY
	 jYYHMyXNRMn+A==
Date: Thu, 12 Aug 2021 11:20:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210812182017.GX3601466@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-12-hch@lst.de>
 <20210811003118.GT3601466@magnolia>
 <20210811053856.GA1934@lst.de>
 <20210811191708.GF3601443@magnolia>
 <20210812064914.GA27145@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812064914.GA27145@lst.de>

On Thu, Aug 12, 2021 at 08:49:14AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 12:17:08PM -0700, Darrick J. Wong wrote:
> > > iter.c is also my preference, but in the end I don't care too much.
> > 
> > Ok.  My plan for this is to change this patch to add the new iter code
> > to apply.c, and change patch 24 to remove iomap_apply.  I'll add a patch
> > on the end to rename apply.c to iter.c, which will avoid breaking the
> > history.
> 
> What history?  There is no shared code, so no shared history and.

The history of the gluecode that enables us to walk a bunch of extent
mappings.  In the beginning it was the _apply function, but now in our
spectre-weary world, you've switched it to a direct loop to reduce the
number of indirect calls in the hot path by 30-50%.

As you correctly point out, there's no /code/ shared by the two
implementations, but Dave and I would like to preserve the continuity
from one to the next.

> > I'll send the updated patches as replies to this series to avoid
> > spamming the list, since I also have a patchset of bugfixes to send out
> > and don't want to overwhelm everyone.
> 
> Just as a clear statement:  I think this dance is obsfucation and doesn't
> help in any way.  But if that's what it takes..

I /would/ appreciate it if you'd rvb (or at least ack) patch 31 so I can
get the 5.15 iomap changes finalized next week.  Pretty please? :)

--D

