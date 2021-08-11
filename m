Return-Path: <nvdimm+bounces-851-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7763E97EF
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 20:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 703AB1C0FC0
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Aug 2021 18:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3292FB2;
	Wed, 11 Aug 2021 18:49:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EE772
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:49:38 +0000 (UTC)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJkh5YtWz6G9JB;
	Thu, 12 Aug 2021 02:49:00 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:49:36 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:49:35 +0100
Date: Wed, 11 Aug 2021 19:49:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 09/23] libnvdimm/labels: Add address-abstraction uuid
 definitions
Message-ID: <20210811194905.000034f6@Huawei.com>
In-Reply-To: <162854811511.1980150.3921515741758120378.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854811511.1980150.3921515741758120378.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.52.123.85]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 9 Aug 2021 15:28:35 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The EFI definition of the labels represents the Linux "claim class" with
> a GUID. The CXL definition of the labels stores the same identifier in
> UUID byte order. In preparation for adding CXL label support, enable the
> claim class to optionally handle uuids.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've already commented on 10 and 11 so this was backfilling tags
for the ones I'd looked at earlier but looked good to me.

I'm not all that familiar with this code yet, so all my checking was off the
"does it look locally correct?" variety.

Out of time for today, and not sure when I'll get to looking at the remainder.

Jonathan

> ---
>  drivers/nvdimm/label.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 7f473f9db300..2ba31b883b28 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -17,6 +17,11 @@ static guid_t nvdimm_btt2_guid;
>  static guid_t nvdimm_pfn_guid;
>  static guid_t nvdimm_dax_guid;
>  
> +static uuid_t nvdimm_btt_uuid;
> +static uuid_t nvdimm_btt2_uuid;
> +static uuid_t nvdimm_pfn_uuid;
> +static uuid_t nvdimm_dax_uuid;
> +
>  static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
>  
>  static u32 best_seq(u32 a, u32 b)
> @@ -724,7 +729,7 @@ static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  }
>  
> -static enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
> +static enum nvdimm_claim_class guid_to_nvdimm_cclass(guid_t *guid)
>  {
>  	if (guid_equal(guid, &nvdimm_btt_guid))
>  		return NVDIMM_CCLASS_BTT;
> @@ -740,6 +745,23 @@ static enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
>  	return NVDIMM_CCLASS_UNKNOWN;
>  }
>  
> +/* CXL labels store UUIDs instead of GUIDs for the same data */
> +enum nvdimm_claim_class uuid_to_nvdimm_cclass(uuid_t *uuid)
> +{
> +	if (uuid_equal(uuid, &nvdimm_btt_uuid))
> +		return NVDIMM_CCLASS_BTT;
> +	else if (uuid_equal(uuid, &nvdimm_btt2_uuid))
> +		return NVDIMM_CCLASS_BTT2;
> +	else if (uuid_equal(uuid, &nvdimm_pfn_uuid))
> +		return NVDIMM_CCLASS_PFN;
> +	else if (uuid_equal(uuid, &nvdimm_dax_uuid))
> +		return NVDIMM_CCLASS_DAX;
> +	else if (uuid_equal(uuid, &uuid_null))
> +		return NVDIMM_CCLASS_NONE;
> +
> +	return NVDIMM_CCLASS_UNKNOWN;
> +}
> +
>  static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
>  	guid_t *target)
>  {
> @@ -761,6 +783,29 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
>  		return &guid_null;
>  }
>  
> +/* CXL labels store UUIDs instead of GUIDs for the same data */
> +__maybe_unused
> +static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
> +					 uuid_t *target)
> +{
> +	if (claim_class == NVDIMM_CCLASS_BTT)
> +		return &nvdimm_btt_uuid;
> +	else if (claim_class == NVDIMM_CCLASS_BTT2)
> +		return &nvdimm_btt2_uuid;
> +	else if (claim_class == NVDIMM_CCLASS_PFN)
> +		return &nvdimm_pfn_uuid;
> +	else if (claim_class == NVDIMM_CCLASS_DAX)
> +		return &nvdimm_dax_uuid;
> +	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> +		/*
> +		 * If we're modifying a namespace for which we don't
> +		 * know the claim_class, don't touch the existing uuid.
> +		 */
> +		return target;
> +	} else
> +		return &uuid_null;
> +}
> +
>  static void reap_victim(struct nd_mapping *nd_mapping,
>  		struct nd_label_ent *victim)
>  {
> @@ -808,7 +853,7 @@ enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
>  {
>  	if (!namespace_label_has(ndd, abstraction_guid))
>  		return NVDIMM_CCLASS_NONE;
> -	return to_nvdimm_cclass(&nd_label->abstraction_guid);
> +	return guid_to_nvdimm_cclass(&nd_label->abstraction_guid);
>  }
>  
>  static int __pmem_label_update(struct nd_region *nd_region,
> @@ -1395,5 +1440,10 @@ int __init nd_label_init(void)
>  	WARN_ON(guid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_guid));
>  	WARN_ON(guid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_guid));
>  
> +	WARN_ON(uuid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_uuid));
> +	WARN_ON(uuid_parse(NVDIMM_BTT2_GUID, &nvdimm_btt2_uuid));
> +	WARN_ON(uuid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_uuid));
> +	WARN_ON(uuid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_uuid));
> +
>  	return 0;
>  }
> 


