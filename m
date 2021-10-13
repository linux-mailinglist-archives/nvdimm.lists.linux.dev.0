Return-Path: <nvdimm+bounces-1519-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEADD42C135
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Oct 2021 15:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id E49A61C0D08
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Oct 2021 13:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73B12C94;
	Wed, 13 Oct 2021 13:16:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A2A2C81
	for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634130993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3UweUBspHinuJSQhguEdx6WU40R4nh4wg670z3EQDCs=;
	b=N9DOpLi6ciGUwBrxKQ9ffOhc5mGMwOI3tkVi5n7Wnt101pu2mf6nRDse+lTnviWvJ77Gtm
	BUkSyFQdDSFqg6EKfj+ifNOS4dVdzHFtQJNBN2kv/ZipH9hhhvNvJTcYyXsAyHLhwLnd2u
	0BwmIpNaoMZu6+GATu1hON/hRB1f9CA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-lYDb9o67Mf-rDMq57zxd3g-1; Wed, 13 Oct 2021 09:16:31 -0400
X-MC-Unique: lYDb9o67Mf-rDMq57zxd3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41EC3100CCC0;
	Wed, 13 Oct 2021 13:16:24 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.33.167])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9599DADD0;
	Wed, 13 Oct 2021 13:16:20 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id DEFAB22023A; Wed, 13 Oct 2021 09:16:19 -0400 (EDT)
Date: Wed, 13 Oct 2021 09:16:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@linux.ie>, Gerd Hoffmann <kraxel@redhat.com>,
	Daniel Vetter <daniel@ffwll.ch>, Jie Deng <jie.deng@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-um@lists.infradead.org,
	virtualization@lists.linux-foundation.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, kvm@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH RFC] virtio: wrap config->reset calls
Message-ID: <YWbcI15YOkhnPh5x@redhat.com>
References: <20211013105226.20225-1-mst@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20211013105226.20225-1-mst@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=vgoyal@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 13, 2021 at 06:55:31AM -0400, Michael S. Tsirkin wrote:
> This will enable cleanups down the road.
> The idea is to disable cbs, then add "flush_queued_cbs" callback
> as a parameter, this way drivers can flush any work
> queued after callbacks have been disabled.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/um/drivers/virt-pci.c                 | 2 +-
>  drivers/block/virtio_blk.c                 | 4 ++--
>  drivers/bluetooth/virtio_bt.c              | 2 +-
>  drivers/char/hw_random/virtio-rng.c        | 2 +-
>  drivers/char/virtio_console.c              | 4 ++--
>  drivers/crypto/virtio/virtio_crypto_core.c | 8 ++++----
>  drivers/firmware/arm_scmi/virtio.c         | 2 +-
>  drivers/gpio/gpio-virtio.c                 | 2 +-
>  drivers/gpu/drm/virtio/virtgpu_kms.c       | 2 +-
>  drivers/i2c/busses/i2c-virtio.c            | 2 +-
>  drivers/iommu/virtio-iommu.c               | 2 +-
>  drivers/net/caif/caif_virtio.c             | 2 +-
>  drivers/net/virtio_net.c                   | 4 ++--
>  drivers/net/wireless/mac80211_hwsim.c      | 2 +-
>  drivers/nvdimm/virtio_pmem.c               | 2 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c           | 2 +-
>  drivers/scsi/virtio_scsi.c                 | 2 +-
>  drivers/virtio/virtio.c                    | 5 +++++
>  drivers/virtio/virtio_balloon.c            | 2 +-
>  drivers/virtio/virtio_input.c              | 2 +-
>  drivers/virtio/virtio_mem.c                | 2 +-
>  fs/fuse/virtio_fs.c                        | 4 ++--

fs/fuse/virtio_fs.c changes look good to me.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

[..]
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 0ad89c6629d7..27c3b74070a2 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -895,7 +895,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
>  	return 0;
>  
>  out_vqs:
> -	vdev->config->reset(vdev);
> +	virtio_reset_device(vdev);
>  	virtio_fs_cleanup_vqs(vdev, fs);
>  	kfree(fs->vqs);
>  
> @@ -927,7 +927,7 @@ static void virtio_fs_remove(struct virtio_device *vdev)
>  	list_del_init(&fs->list);
>  	virtio_fs_stop_all_queues(fs);
>  	virtio_fs_drain_all_queues_locked(fs);
> -	vdev->config->reset(vdev);
> +	virtio_reset_device(vdev);
>  	virtio_fs_cleanup_vqs(vdev, fs);
>  
>  	vdev->priv = NULL;


Thanks
Vivek


