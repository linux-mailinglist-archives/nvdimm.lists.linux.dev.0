Return-Path: <nvdimm+bounces-1866-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 1496244A799
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4F0AF3E1060
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 07:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920712C9A;
	Tue,  9 Nov 2021 07:27:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E382C80
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 07:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QyYw+d4t66E4FwgbFsWiA0CB429+JCmxgcFifHWAMbE=; b=CnADimQBuYrn4XpRgus7F2e+Pw
	ZRb/HvO7yy4h5Px2ux4xXe5Ui9f9Iw/g7XYfUvVQCQIv+s0h+utqsmLCbQJ3jGCbr5i9UE/oeL5AX
	oSagJ5LOVawHyI4FmMkwQ6BpRa9nDjx5Vah04OTIX7vA5C8L4Odzk8Hl5xvwgsrufvHa5gfvz3PyJ
	rMnZ24hfsT1EmdZbYyoUj+8iuJ9fHNasxFz8X3iNKlKpDH8ymexy4WUsPmz9+yLlDH5MPKTD4QF2z
	rmRE6OI3x9ZBGyfLN70YFWofO04ujsoSnGkl/GpJFM8pvSGRpuXiVaaBdfMfS3zEzIGCR0gxdel/e
	kznU0wbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkLXM-000sHh-6h; Tue, 09 Nov 2021 07:27:20 +0000
Date: Mon, 8 Nov 2021 23:27:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Message-ID: <YYoi2JiwTtmxONvB@infradead.org>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
 <20211106011638.2613039-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106011638.2613039-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>  static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  		void *addr, size_t bytes, struct iov_iter *i, int mode)
>  {
> +	phys_addr_t pmem_off;
> +	size_t len, lead_off;
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	struct device *dev = pmem->bb.dev;
> +
> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
> +		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> +			if (lead_off || !(PAGE_ALIGNED(bytes))) {
> +				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
> +					addr, bytes);
> +				return (size_t) -EIO;
> +			}
> +			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
> +						BLK_STS_OK)
> +				return (size_t) -EIO;
> +		}
> +	}

This is in the wrong spot.  As seen in my WIP series individual drivers
really should not hook into copying to and from the iter, because it
really is just one way to write to a nvdimm.  How would dm-writecache
clear the errors with this scheme?

So IMHO going back to the separate recovery method as in your previous
patch really is the way to go.  If/when the 64-bit store happens we
need to figure out a good way to clear the bad block list for that.

