Return-Path: <nvdimm+bounces-2222-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE488470293
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Dec 2021 15:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D16D51C0B17
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Dec 2021 14:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A8BA2CA5;
	Fri, 10 Dec 2021 14:17:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5B68
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639145840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAS8YtaRzDwTBft61hF97SlcoBkaxxqGmF+wyCNWJ8A=;
	b=MMsxpmQBHOBvdVO1iDi97cMIEN07m2MDUo8nNjRKDACOZ66OuT7FA6IOYP9mPORJKouBCD
	Yt29CF7KSCjJy0oEXvo2A/RxVBFpIVCV/gx78Dyez3SMAeAoeg+QzEh7zFLSEtK9ew7ZAF
	O3a1hFkTmKc/oRyK5tL9WOrHBPARKrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-eeZyP13LOWiAd_cdWjWvAA-1; Fri, 10 Dec 2021 09:17:09 -0500
X-MC-Unique: eeZyP13LOWiAd_cdWjWvAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 249C7835E20;
	Fri, 10 Dec 2021 14:17:07 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.17.42])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12ED719C59;
	Fri, 10 Dec 2021 14:16:30 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id 967302209DD; Fri, 10 Dec 2021 09:16:29 -0500 (EST)
Date: Fri, 10 Dec 2021 09:16:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>, dm-devel@redhat.com,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter
 methods
Message-ID: <YbNhPXBg7G/ridkV@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
 <20211209063828.18944-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209063828.18944-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Thu, Dec 09, 2021 at 07:38:27AM +0100, Christoph Hellwig wrote:
> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
> 
> Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> special variants, then use them everywhere as they fall back to the plain
> ones on s390 anyway and remove an indirect call from the read/write path
> as well as a lot of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c           | 36 ++++++++++++++--
>  drivers/md/dm-linear.c        | 20 ---------
>  drivers/md/dm-log-writes.c    | 80 -----------------------------------
>  drivers/md/dm-stripe.c        | 20 ---------
>  drivers/md/dm.c               | 50 ----------------------
>  drivers/nvdimm/pmem.c         | 20 ---------
>  drivers/s390/block/dcssblk.c  | 14 ------
>  fs/dax.c                      |  5 ---
>  fs/fuse/virtio_fs.c           | 19 +--------
>  include/linux/dax.h           |  9 ++--
>  include/linux/device-mapper.h |  4 --
>  11 files changed, 37 insertions(+), 240 deletions(-)
> 

[..]
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 5c03a0364a9bb..754319ce2a29b 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
>  }
>  
> -static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
> -				       pgoff_t pgoff, void *addr,
> -				       size_t bytes, struct iov_iter *i)
> -{
> -	return copy_from_iter(addr, bytes, i);
> -}
> -
> -static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
> -				       pgoff_t pgoff, void *addr,
> -				       size_t bytes, struct iov_iter *i)
> -{
> -	return copy_to_iter(addr, bytes, i);
> -}
> -
>  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
>  				     pgoff_t pgoff, size_t nr_pages)
>  {
> @@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
>  
>  static const struct dax_operations virtio_fs_dax_ops = {
>  	.direct_access = virtio_fs_direct_access,
> -	.copy_from_iter = virtio_fs_copy_from_iter,
> -	.copy_to_iter = virtio_fs_copy_to_iter,
>  	.zero_page_range = virtio_fs_zero_page_range,
>  };
>  
> @@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>  	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
>  	if (IS_ERR(fs->dax_dev))
>  		return PTR_ERR(fs->dax_dev);
> -
> +	set_dax_cached(fs->dax_dev);

Looks good to me from virtiofs point of view.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Going forward, I am wondering should virtiofs use flushcache version as
well. What if host filesystem is using DAX and mapping persistent memory
pfn directly into qemu address space. I have never tested that.

Right now we are relying on applications to do fsync/msync on virtiofs
for data persistence.

> +	set_dax_nomcsafe(fs->dax_dev);
>  	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
>  					fs->dax_dev);
>  }

Thanks
Vivek


