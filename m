Return-Path: <nvdimm+bounces-1089-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AACE63FA099
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 22:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9653D1C1074
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 20:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EB53FCD;
	Fri, 27 Aug 2021 20:29:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CB2FAE
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 20:29:36 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977CB60FD8;
	Fri, 27 Aug 2021 20:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630096176;
	bh=88bih5eGKB9i2ESLsafMWzYIwyGke7MVW8Rm8LZaCJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VqgAkXLSFQ2s8YBhV0/BkRbyvjYS7iN8wS3+vPnrfYwjeVZbT3EcOkpsbz+6iOIIg
	 K59JPqJADG5mnk2BZMwXfm+2K/QX3GabYmGmJMq75CAhfxkg4e7sYb4W90iqXt4wjY
	 CCBcmFMkK/fitfaaSpE06RYuhbvQkR1xSjgZLyqV+ldHSk85VfL/sYK3yuWYBDlle0
	 4C9yBY22Kb164kHW1308QMn1cbMYjo7ekT+NZW9nIbbZyeN7dvOl3QZ8uGzlQBiwYO
	 xvNRlNxn6B/Q+DSji3QgnHGBcKriUM+BPc6qVP1hIdIo6lvljcLrqIlc4i6mgmBrgk
	 KvuManA4RC1Fw==
Date: Fri, 27 Aug 2021 13:29:32 -0700
From: Keith Busch <kbusch@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
	sagi@grimberg.me, vishal.l.verma@intel.com,
	dan.j.williams@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
	konrad.wilk@oracle.com, roger.pau@citrix.com,
	boris.ostrovsky@oracle.com, jgross@suse.com, sstabellini@kernel.org,
	minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
	xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20210827202932.GA82376@dhcp-10-100-145-180.wdc.com>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
 <20210827191809.3118103-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827191809.3118103-4-mcgrof@kernel.org>

On Fri, Aug 27, 2021 at 12:18:02PM -0700, Luis Chamberlain wrote:
> @@ -479,13 +479,17 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
>  static void nvme_mpath_set_live(struct nvme_ns *ns)
>  {
>  	struct nvme_ns_head *head = ns->head;
> +	int rc;
>  
>  	if (!head->disk)
>  		return;
>  
> -	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
> -		device_add_disk(&head->subsys->dev, head->disk,
> -				nvme_ns_id_attr_groups);
> +	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {

This should still be test_and_set_bit() because it is protecting against
two nvme paths simultaneously calling device_add_disk() on the same
namespace head.

> +		rc = device_add_disk(&head->subsys->dev, head->disk,
> +				     nvme_ns_id_attr_groups);
> +		if (rc)
> +			return;
> +		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
>  		nvme_add_ns_head_cdev(head);
>  	}

