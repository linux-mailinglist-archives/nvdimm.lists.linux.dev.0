Return-Path: <nvdimm+bounces-14713-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id skACHtM0RGojqgoAu9opvQ
	(envelope-from <nvdimm+bounces-14713-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 23:27:47 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D126E824B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 23:27:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=CC+OLlOD;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14713-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14713-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C34283055DF9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 21:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48792ECD32;
	Tue, 30 Jun 2026 21:23:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2A2DCF74
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:23:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854593; cv=none; b=CwkYnPeruWglbocKkQ6wTJNDbAWxMF9Q8ZzPYWOdqxIngNUfrYLMh0gmRzQxpsOsrkNfp8I+P+vyRBk5UpFGTja9JJ+f7ChN1D5pycj6anVHy3mBLYYybMqlCvl3yT7qRmLKeLvOu5RMEqw9kG7LbN7r7jAlo0juVeFmGhN45Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854593; c=relaxed/simple;
	bh=UxrBiwALydWVxG8zygKYB4HBSy3QYf62fVVbbVNR2tE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lH11ok3ynqDQT8S3JC8Cq1Ofv8OTJnjWOOKoMEcDWtTfznYYNUPxEzfV/vNh1AijI2KHr692nfj4aUztF+S7h3yypKPlhwN7/my9d+pzUEuYHDxvGX479UTv++M+wtbuiOlLw5EmrOHi3zzQPsBi9g4r3m6sFCcqG4CLaZZa6w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CC+OLlOD; arc=none smtp.client-ip=198.175.65.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782854592; x=1814390592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UxrBiwALydWVxG8zygKYB4HBSy3QYf62fVVbbVNR2tE=;
  b=CC+OLlOD13iFApF6o2A1vuSR39Fzm8vPw488RruCiMsUBLjBntJFFrNv
   QVWNSUYibgXI87rP9bjkZZCHpYVJKi7kSV/2r30GCIF1kyKWhzgc90587
   lB/Xar7NYOO6HfPiHHroVwnGcQsOwoYWe/rmDMHZtUZi87+4GORD7tKi6
   PNRcZBRymcCAut1mdSPGswiMCZqv4CQrN05tZ7547jqmdu1Dk4hCcvjMg
   u64bOE8t+5T7pDaA0BDb4e3yZ8Z/MPXNAUR27G+pUHqFV+onkET9T/6xb
   n65A1FfDwj5Ew3M50Qw5eGHXZjsNJDyWSO2nFJFyfNqLmzB8Czi4WVzp+
   Q==;
X-CSE-ConnectionGUID: bGdNPHNBRlOWHa7HL8J+fQ==
X-CSE-MsgGUID: h1kLbPe3SmaiiZ5rfJ/SiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="93935820"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="93935820"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:23:11 -0700
X-CSE-ConnectionGUID: fo9Nx0imRA2iqtX/37SKEQ==
X-CSE-MsgGUID: 3XeXBdMMTnWVwplROVGFLQ==
X-ExtLoop1: 1
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.254]) ([10.125.109.254])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 14:23:10 -0700
Message-ID: <d3f24949-aaec-4dc2-adf7-bca3cbd86a9c@intel.com>
Date: Tue, 30 Jun 2026 14:23:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 15/31] cxl/mem: Drop misaligned DCD extent groups
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-16-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-16-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14713-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:vishal.l.verma@intel.com,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@Groves.net,m:gourry@gourry.net,m:anisa.su@samsung.com,m:anisasu887@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[intel.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,samsung.com:email,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 53D126E824B



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Add an alignment gate to cxl_add_pending(): every extent in a tag group
> must have its start_dpa and length aligned to the dax region's mapping
> granularity.  A misaligned extent makes the resulting dax device unusable,
> so drop the whole group rather than accept a partial allocation that would
> surface a broken dax_resource.
> 
> Based on patches by John Groves.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: John Groves <John@Groves.net>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> 
> ---
> Changes:
> [anisa: gate on the dax region's actual mapping alignment (PMD_SIZE)
> 	instead of a hardcoded SZ_2M]
> ---
>  drivers/cxl/core/mbox.c | 51 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 08f51b8807c0..14ba263044f0 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -7,6 +7,8 @@
>  #include <linux/unaligned.h>
>  #include <linux/list.h>
>  #include <linux/list_sort.h>
> +#include <linux/pgtable.h>
> +#include <linux/sizes.h>
>  #include <cxlpci.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
> @@ -1295,6 +1297,19 @@ static int add_to_pending_list(struct list_head *pending_list,
>  	return 0;
>  }
>  
> +/*
> + * Extents need to be aligned to dax region's mapping granularity.
> + * Use PMD_SIZE, since cxl_dax_region_probe() calls alloc_dax_region with
> + * PMD_SIZE for the 'align' parameter.
> + */
> +static bool cxl_extent_dcd_aligned(const struct cxl_extent *extent)
> +{
> +	u64 start = le64_to_cpu(extent->start_dpa);
> +	u64 len = le64_to_cpu(extent->length);
> +
> +	return IS_ALIGNED(start, PMD_SIZE) && IS_ALIGNED(len, PMD_SIZE);
> +}
> +
>  /*
>   * Compare two extents by shared_extn_seq (ascending).  list_sort is
>   * stable, so extents with equal keys keep their arrival order from
> @@ -1395,11 +1410,38 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
>  	return group_cnt;
>  }
>  
> +/*
> + * Validate a tag @group before realizing it.  Returns 0 if the group may be
> + * added, or a negative errno if it must be dropped.  Further gates layer in
> + * here in later commits.
> + */
> +static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> +			      struct list_head *group)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct cxl_extent_list_node *pos;
> +
> +	/* Alignment gate — drop the group if any member fails */
> +	list_for_each_entry(pos, group, list) {
> +		if (!cxl_extent_dcd_aligned(pos->extent)) {
> +			dev_warn(dev,
> +				 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %#llx-aligned\n",
> +				 tag,
> +				 le64_to_cpu(pos->extent->start_dpa),
> +				 le64_to_cpu(pos->extent->length),
> +				 (u64)PMD_SIZE);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Drive the pending Add-Capacity records through cxl_realize_group(),
>   * grouped by tag.  Per group: extract from pending, stable-sort by
> - * shared_extn_seq, realize the group, and on success move it onto the
> - * accepted list.  Validation gates layer onto this loop in later commits.
> + * shared_extn_seq, validate, realize the group, and on success move it onto
> + * the accepted list.
>   */
>  static int cxl_add_pending(struct cxl_memdev_state *mds, bool existing)
>  {
> @@ -1425,6 +1467,11 @@ static int cxl_add_pending(struct cxl_memdev_state *mds, bool existing)
>  		 */
>  		list_sort(NULL, &group, extent_seq_compare);
>  
> +		if (cxl_validate_group(mds, &tag, &group)) {
> +			drop_extent_group(&group);
> +			continue;
> +		}
> +
>  		cnt = cxl_realize_group(mds, &tag, &group, existing);
>  		if (cnt < 0) {
>  			drop_extent_group(&group);


