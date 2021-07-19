Return-Path: <nvdimm+bounces-562-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C763CDB88
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 17:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 790E61C0F44
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 15:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE662FB3;
	Mon, 19 Jul 2021 15:28:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57A170
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 15:28:02 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6FF767373; Mon, 19 Jul 2021 17:17:44 +0200 (CEST)
Date: Mon, 19 Jul 2021 17:17:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	darrick.wong@oracle.com, dan.j.williams@intel.com,
	david@fromorbit.com, hch@lst.de, agk@redhat.com, snitzer@redhat.com,
	rgoldwyn@suse.de
Subject: Re: [PATCH v5 2/9] dax: Introduce holder for dax_device
Message-ID: <20210719151744.GA22718@lst.de>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com> <20210628000218.387833-3-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628000218.387833-3-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 28, 2021 at 08:02:11AM +0800, Shiyang Ruan wrote:
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +			      size_t size, void *data)
> +{
> +	int rc = -ENXIO;
> +	if (!dax_dev)
> +		return rc;
> +
> +	if (dax_dev->holder_data) {
> +		rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
> +							 size, data);
> +		if (rc == -ENODEV)
> +			rc = -ENXIO;
> +	} else
> +		rc = -EOPNOTSUPP;

The style looks a little odd.  Why not:

	if (!dax_dev)
		return -ENXIO
	if (!dax_dev->holder_data)
		return -EOPNOTSUPP;
	return dax_dev->holder_ops->notify_failure(dax_dev, offset, size, data);

and let everyone deal with the same errno codes?

Also why do we even need the dax_dev NULL check?

> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +	if (!dax_dev)
> +		return;

I don't think we really need that check here.

> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +	void *holder_data;
> +
> +	if (!dax_dev)
> +		return NULL;

Same here.

> +
> +	down_read(&dax_dev->holder_rwsem);
> +	holder_data = dax_dev->holder_data;
> +	up_read(&dax_dev->holder_rwsem);
> +
> +	return holder_data;

That lock won't protect anything.  I think we simply must have
synchronization to prevent unregistration while the ->notify_failure
call is in progress.

