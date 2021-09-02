Return-Path: <nvdimm+bounces-1125-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B95E33FF1D6
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 18:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6B9AB3E0F6F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Sep 2021 16:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253862F80;
	Thu,  2 Sep 2021 16:53:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11B72
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 16:53:52 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0mj44192z67kXv;
	Fri,  3 Sep 2021 00:34:16 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 2 Sep 2021 18:36:01 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 17:36:01 +0100
Date: Thu, 2 Sep 2021 17:36:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<ira.weiny@intel.com>, <ben.widawsky@intel.com>
Subject: Re: [PATCH v3 13/28] libnvdimm/label: Define CXL region labels
Message-ID: <20210902173602.00000272@Huawei.com>
In-Reply-To: <162982119604.1124374.8364301519543316156.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982119604.1124374.8364301519543316156.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.127.69]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:06:36 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Add a definition of the CXL 2.0 region label format. Note this is done
> as a separate patch to make the next patch that adds namespace label
> support easier to read.
> 
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
FWIW
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.h |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 31f94fad7b92..76ecd0347dc2 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -65,6 +65,36 @@ struct nd_namespace_index {
>  	u8 free[];
>  };
>  
> +/**
> + * struct cxl_region_label - CXL 2.0 Table 211
> + * @type: uuid identifying this label format (region)
> + * @uuid: uuid for the region this label describes
> + * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
> + * @position: this label's position in the set
> + * @dpa: start address in device-local capacity for this label
> + * @rawsize: size of this label's contribution to region
> + * @hpa: mandatory system physical address to map this region
> + * @slot: slot id of this label in label area
> + * @ig: interleave granularity (1 << @ig) * 256 bytes
> + * @align: alignment in SZ_256M blocks
> + * @checksum: fletcher64 sum of this label
> + */
> +struct cxl_region_label {
> +	u8 type[NSLABEL_UUID_LEN];
> +	u8 uuid[NSLABEL_UUID_LEN];
> +	__le32 flags;
> +	__le16 nlabel;
> +	__le16 position;
> +	__le64 dpa;
> +	__le64 rawsize;
> +	__le64 hpa;
> +	__le32 slot;
> +	__le32 ig;
> +	__le32 align;
> +	u8 reserved[0xac];
> +	__le64 checksum;
> +};
> +
>  /**
>   * struct nd_namespace_label - namespace superblock
>   * @uuid: UUID per RFC 4122
> 


