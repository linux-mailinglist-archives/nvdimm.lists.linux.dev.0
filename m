Return-Path: <nvdimm+bounces-1736-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8697C43F65F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 Oct 2021 06:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 28EDF1C067A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 Oct 2021 04:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8092C89;
	Fri, 29 Oct 2021 04:57:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343672
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 04:57:38 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230540203"
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="230540203"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 21:57:38 -0700
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="665692765"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 21:57:38 -0700
Date: Thu, 28 Oct 2021 21:57:37 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 03/11] dax: simplify the dax_device <-> gendisk
 association
Message-ID: <20211029045737.GJ3538886@iweiny-DESK2.sc.intel.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018044054.1779424-4-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Oct 18, 2021 at 06:40:46AM +0200, Christoph Hellwig wrote:
> Replace the dax_host_hash with an xarray indexed by the pointer value
> of the gendisk, and require explicitl calls from the block drivers that
> want to associate their gendisk with a dax_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/bus.c            |   2 +-
>  drivers/dax/super.c          | 106 +++++++++--------------------------
>  drivers/md/dm.c              |   6 +-
>  drivers/nvdimm/pmem.c        |   8 ++-
>  drivers/s390/block/dcssblk.c |  11 +++-
>  fs/fuse/virtio_fs.c          |   2 +-
>  include/linux/dax.h          |  19 +++++--
>  7 files changed, 60 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 6cc4da4c713d9..6d91b0186e3be 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1326,7 +1326,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	 * No 'host' or dax_operations since there is no access to this
>  	 * device outside of mmap of the resulting character device.
>  	 */

NIT: this comment needs to be updated as well.

Ira

> -	dax_dev = alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
> +	dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
>  	if (IS_ERR(dax_dev)) {
>  		rc = PTR_ERR(dax_dev);
>  		goto err_alloc_dax;

[snip]


