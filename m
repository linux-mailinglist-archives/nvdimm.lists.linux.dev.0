Return-Path: <nvdimm+bounces-950-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332543F4B4F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 15:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 9D6853E1027
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 13:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AA83FCA;
	Mon, 23 Aug 2021 13:02:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8703FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 13:02:51 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9BD9767357; Mon, 23 Aug 2021 15:02:48 +0200 (CEST)
Date: Mon, 23 Aug 2021 15:02:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "ruansy.fnst" <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of
 reflink
Message-ID: <20210823130248.GC15536@lst.de>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-8-ruansy.fnst@fujitsu.com> <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com> <c7e68dc8-5a43-f727-c262-58dcf244c711@fujitsu.com> <CAPcyv4jM86gy-T5EEZf6M2m44v4MiGqYDhxisX59M5QJii6DVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jM86gy-T5EEZf6M2m44v4MiGqYDhxisX59M5QJii6DVg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 20, 2021 at 08:18:44AM -0700, Dan Williams wrote:
> I notice that the @iomap argument to ->iomap_end() is reliably coming
> from @iter. So you could do the following in your iomap_end()
> callback:
> 
>         struct iomap_iter *iter = container_of(iomap, typeof(*iter), iomap);
>         struct xfs_inode *ip = XFS_I(inode);
>         ssize_t written = iter->processed;
>         bool cow = xfs_is_cow_inode(ip);
> 
>         if (cow) {
>                 if (written <= 0)
>                         xfs_reflink_cancel_cow_range(ip, pos, length, true)
>         }

I think this might be ok for now (with a big comment).  Willy's original
iomap iter series replaced the iomap_begin and iomap_end with a single
next callback that takes the iomap_iter, which would solve this issue.
My plan is to look into a series that implements this and sees if this
is indeed a net win.

