Return-Path: <nvdimm+bounces-2805-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB5B4A7130
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 14:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 33D7B1C0DD5
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 13:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587B12F2C;
	Wed,  2 Feb 2022 13:03:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A32F21
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uNf3Kf4hoy55VBNw3wt44AdzBNehHt9KaUoihC4mBrw=; b=W8q5WAMDiFJsaQjVwzcQNYhbFB
	TUhEzkTsfxRSEKGdxNARH2VlcVdcDdmFCApVXE9/uC4L1PKTd/4fDCVqDlGkYFs7klpelGPcvudIJ
	NEgSsM8r4n/YaIyXsDAGkOHaZ7tQwwjKTOvOR47fupgUC8GEiYmGWhp8TGEZeE1FNXpEMCCAMpnbN
	N2XuOsGW3/8gzyPMEyQ+qS/aLLq0rg7FtFaei4DUI040ACtXkXQbyPXYvgaC6aYcHjsue/OEJjwkc
	ie50CMyIAVekefGX5lBW/LEbynfRsGGMK7nXRLjyC6DZYwKaY2N50/9G4sf9VdU2OSOCoPYUH+Iao
	F+JpOpdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFFIV-00FIEL-Kt; Wed, 02 Feb 2022 13:03:43 +0000
Date: Wed, 2 Feb 2022 05:03:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v10 1/9] dax: Introduce holder for dax_device
Message-ID: <YfqBLxjr5zz1TU91@infradead.org>
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-2-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127124058.1172422-2-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 27, 2022 at 08:40:50PM +0800, Shiyang Ruan wrote:
> +void dax_register_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +	if (!dax_alive(dax_dev))
> +		return;
> +
> +	dax_dev->holder_data = holder;
> +	dax_dev->holder_ops = ops;

This needs to return an error if there is another holder already.  And
some kind of locking to prevent concurrent registrations.

Also please add kerneldoc comments for the new exported functions.

> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +	if (!dax_alive(dax_dev))
> +		return NULL;
> +
> +	return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);

get tends to imply getting a reference.  Maybe just dax_holder()?
That being said I can't see where we'd even want to use the holder
outside of this file.

