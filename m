Return-Path: <nvdimm+bounces-1328-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98CF540D329
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Sep 2021 08:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 276CA3E10C6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Sep 2021 06:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE363FC9;
	Thu, 16 Sep 2021 06:24:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF52FAE
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 06:24:00 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D143267357; Thu, 16 Sep 2021 08:23:57 +0200 (CEST)
Date: Thu, 16 Sep 2021 08:23:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v9 7/8] xfs: support CoW in fsdax mode
Message-ID: <20210916062357.GD13306@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-8-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-8-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 15, 2021 at 06:45:00PM +0800, Shiyang Ruan wrote:
> +static int
> +xfs_dax_write_iomap_end(
> +	struct inode 		*inode,
> +	loff_t 			pos,
> +	loff_t 			length,
> +	ssize_t 		written,
> +	unsigned 		flags,
> +	struct iomap 		*iomap)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	/*
> +	 * Usually we use @written to indicate whether the operation was
> +	 * successful.  But it is always positive or zero.  The CoW needs the
> +	 * actual error code from actor().  So, get it from
> +	 * iomap_iter->processed.
> +	 */
> +	const struct iomap_iter *iter =
> +				container_of(iomap, typeof(*iter), iomap);
> +
> +	if (!xfs_is_cow_inode(ip))
> +		return 0;
> +
> +	if (iter->processed <= 0) {
> +		xfs_reflink_cancel_cow_range(ip, pos, length, true);
> +		return 0;
> +	}
> +
> +	return xfs_reflink_end_cow(ip, pos, iter->processed);

Didn't we come to the conflusion last time that we don't actually
need to poke into the iomap_iter here as the written argument is equal
to iter->processed if it is > 0:

	if (iter->iomap.length && ops->iomap_end) {
		ret = ops->iomap_end(iter->inode, iter->pos, iomap_length(iter),
				iter->processed > 0 ? iter->processed : 0,
				iter->flags, &iter->iomap);
		..

So should be able to just do:

static int
xfs_dax_write_iomap_end(
	struct inode 		*inode,
	loff_t 			pos,
	loff_t 			length,
	ssize_t 		written,
	unsigned 		flags,
	struct iomap 		*iomap)
{
	struct xfs_inode	*ip = XFS_I(inode);

	if (!xfs_is_cow_inode(ip))
		return 0;

	if (!written) {
		xfs_reflink_cancel_cow_range(ip, pos, length, true);
		return 0;
	}

	return xfs_reflink_end_cow(ip, pos, written);
}

