Return-Path: <nvdimm+bounces-3451-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C9D44F6B82
	for <lists+linux-nvdimm@lfdr.de>; Wed,  6 Apr 2022 22:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 5595B1C0B4A
	for <lists+linux-nvdimm@lfdr.de>; Wed,  6 Apr 2022 20:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0CB33FA;
	Wed,  6 Apr 2022 20:39:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DB23226
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757FFC385A5;
	Wed,  6 Apr 2022 20:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649277541;
	bh=PXUDYE1r6Gil/o9m5rfjYKx/BFUoyr1dI3rq+0GFdOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cd9d3yNYx5ueGCXvizdmPbLOeNrVL6KS5C9ulrFKncWNwuw/eFoj4ZgXMdrIGjDxv
	 a7fjB7+wNcj4jiIBOJK35xYyIsj6e+NpbqJQinyrR1FNlX3ZgTWjHUksIBI7YC3Omx
	 gGwXlXFrEFw+DdU48Ubs3JzmiTAVW17j0Naaa8et4nrA9ezYZlBmQvEKN9N6GxDyrt
	 V4EgEOqknmuYSsUSXN9oA2iX4BkcxxQbiFkg6SphOxCEbIr2ml5/lLBC4yKrLZ0z/f
	 UCHO7hgqZ6LQ5zOaQ7/07RWJJxT5VxoUEIQq2NGtk6k/McpEorw6y0xTMPEc3f1MqM
	 71yCvdJd8NJqQ==
Date: Wed, 6 Apr 2022 13:39:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	david <david@fromorbit.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
Message-ID: <20220406203900.GR27690@magnolia>
References: <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
 <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
 <YkQtOO/Z3SZ2Pksg@infradead.org>
 <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com>
 <YkR8CUdkScEjMte2@infradead.org>
 <20220330161812.GA27649@magnolia>
 <fd37cde6-318a-9faf-9bff-70bb8e5d3241@oracle.com>
 <CAPcyv4gqBmGCQM_u40cR6GVror6NjhxV5Xd7pdHedE2kHwueoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gqBmGCQM_u40cR6GVror6NjhxV5Xd7pdHedE2kHwueoQ@mail.gmail.com>

On Tue, Apr 05, 2022 at 06:22:48PM -0700, Dan Williams wrote:
> On Tue, Apr 5, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
> >
> > On 3/30/2022 9:18 AM, Darrick J. Wong wrote:
> > > On Wed, Mar 30, 2022 at 08:49:29AM -0700, Christoph Hellwig wrote:
> > >> On Wed, Mar 30, 2022 at 06:58:21PM +0800, Shiyang Ruan wrote:
> > >>> As the code I pasted before, pmem driver will subtract its ->data_offset,
> > >>> which is byte-based. And the filesystem who implements ->notify_failure()
> > >>> will calculate the offset in unit of byte again.
> > >>>
> > >>> So, leave its function signature byte-based, to avoid repeated conversions.
> > >>
> > >> I'm actually fine either way, so I'll wait for Dan to comment.
> > >
> > > FWIW I'd convinced myself that the reason for using byte units is to
> > > make it possible to reduce the pmem failure blast radius to subpage
> > > units... but then I've also been distracted for months. :/
> > >
> >
> > Yes, thanks Darrick!  I recall that.
> > Maybe just add a comment about why byte unit is used?
> 
> I think we start with page failure notification and then figure out
> how to get finer grained through the dax interface in follow-on
> changes. Otherwise, for finer grained error handling support,
> memory_failure() would also need to be converted to stop upcasting
> cache-line granularity to page granularity failures. The native MCE
> notification communicates a 'struct mce' that can be in terms of
> sub-page bytes, but the memory management implications are all page
> based. I assume the FS implications are all FS-block-size based?

I wouldn't necessarily make that assumption -- for regular files, the
user program is in a better position to figure out how to reset the file
contents.

For fs metadata, it really depends.  In principle, if (say) we could get
byte granularity poison info, we could look up the space usage within
the block to decide if the poisoned part was actually free space, in
which case we can correct the problem by (re)zeroing the affected bytes
to clear the poison.

Obviously, if the blast radius hits the internal space info or something
that was storing useful data, then you'd have to rebuild the whole block
(or the whole data structure), but that's not necessarily a given.

--D


