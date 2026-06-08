Return-Path: <nvdimm+bounces-14345-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MHxYO0ZXJ2rruwIAu9opvQ
	(envelope-from <nvdimm+bounces-14345-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 01:59:03 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC3965B3DF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 01:59:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=jtqZmKFk;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14345-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14345-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2BDDE301A4E6
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Jun 2026 23:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCD62F746D;
	Mon,  8 Jun 2026 23:58:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54225283FDD
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 23:58:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780963137; cv=none; b=sDCJQRRuJ8s+Z6GGIudR6rwh5RybhIXL79KHYfmJSPXgJRnqUurZ1m3IQrhLnjOGGLRFpinsG0A2FuqZNjGZKGm+3KR0Wkcy9NDobwN3spEJjJgJawaxEBwy7Xy36zS65Oty8FE2S90qY7zfF6SeLC8ZTgjn9j6QgGrU+QEt1FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780963137; c=relaxed/simple;
	bh=iOwiEGEw2/YXkguc/GGTBE7FL9tD3MWk2Q3V8JChipU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSCh0A+6YViDXz4O92oGbQD1jAeSz+tfr4jrmIfOeVyc3XvfN2hvG844QEv7sTREqOCcBjBccxnkeCps4Ryr9UnR+YPSmqUNUVhCOk3X9E+3YuAbpsWLPTC1UipqJ+ZLpBmz0SX/aLkBYIoOfgQNQIPY/egUk0TKt9fujWX4Awg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtqZmKFk; arc=none smtp.client-ip=198.175.65.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780963137; x=1812499137;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iOwiEGEw2/YXkguc/GGTBE7FL9tD3MWk2Q3V8JChipU=;
  b=jtqZmKFkLL7n8sk7aL2fOQA4cjGrxxiVkPYcNg+1kasj91kZkrsDNKLQ
   Hi12Ucf10T+5zCYcOvgfg3eIq89syE4XQZK6lpOQxmZLxzaLluDU1lhe0
   tzuitri3Dg/+DkWnb1KbqTh/yEmNJB55iBfAmDplJOS6bERpt7a5a5hmL
   NkpW/nQgxD4q1AWGNslarFtrbRUjN8uA9lL4cd+dCcvZ7c1rqVdZXgYuT
   SQSY6r7N0Usam6JfQBLjnNMuSaNzNXqtr7Tr7aHp9x4hUjYRF/IC2KWCA
   CeT+VhRaGHyONldqNxJIGBhXXjfebZ0jy18ibjceloBV69VV1sewm9r9Y
   g==;
X-CSE-ConnectionGUID: xz/n1qxzT/WEcL31QTcSGA==
X-CSE-MsgGUID: NA9fmG8IQKidcfYqjbd4SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="92036357"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="92036357"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:58:56 -0700
X-CSE-ConnectionGUID: PDdFy7byT6u4sCrXWbZ5UA==
X-CSE-MsgGUID: 5EUHh6+aRxmYv5vcP3t1VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="245790847"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:58:55 -0700
Message-ID: <e6821b4f-a67a-4894-bc57-afff307e1ba1@intel.com>
Date: Mon, 8 Jun 2026 16:58:54 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] cxl/region: Add cxl-cli support for dynamic RAM A
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-4-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-4-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14345-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@Groves.net,m:gourry@gourry.net,m:ira.weiny@intel.com,m:anisasu887@gmail.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EDC3965B3DF



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> A singular Dynamic RAM partition is exposed via the kernel.
> 
> Use this partition in cxl-cli.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Missing Anisa sign off

Reviewed-by: Dave Jiang <dave.jiang@intel.com>



> 
> ---
> Changes:
> [iweiny: New patch for decoder_ram_a]
> ---
>  cxl/json.c   | 20 ++++++++++++++++++++
>  cxl/memdev.c |  4 +++-
>  cxl/region.c | 27 ++++++++++++++++++++++++---
>  3 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index a925488..e94c809 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -620,6 +620,20 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		}
>  	}
>  
> +	size = cxl_memdev_get_dynamic_ram_a_size(memdev);
> +	if (size) {
> +		jobj = util_json_object_size(size, flags);
> +		if (jobj)
> +			json_object_object_add(jdev, "dynamic_ram_a_size", jobj);
> +
> +		qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
> +		if (qos_class != CXL_QOS_CLASS_NONE) {
> +			jobj = json_object_new_int(qos_class);
> +			if (jobj)
> +				json_object_object_add(jdev, "dynamic_ram_a_qos_class", jobj);
> +		}
> +	}
> +
>  	if (flags & UTIL_JSON_HEALTH) {
>  		jobj = util_cxl_memdev_health_to_json(memdev, flags);
>  		if (jobj)
> @@ -917,6 +931,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  				json_object_object_add(
>  					jdecoder, "volatile_capable", jobj);
>  		}
> +		if (cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
> +			jobj = json_object_new_boolean(true);
> +			if (jobj)
> +				json_object_object_add(
> +					jdecoder, "dynamic_ram_a_capable", jobj);
> +		}
>  	}
>  
>  	if (cxl_port_is_root(port) &&
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 6e44d15..bdcb008 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -269,8 +269,10 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
>  
>  	if (mode == CXL_DECODER_MODE_RAM)
>  		avail_dpa = cxl_memdev_get_ram_size(memdev);
> -	else
> +	else if (mode == CXL_DECODER_MODE_PMEM)
>  		avail_dpa = cxl_memdev_get_pmem_size(memdev);
> +	else
> +		avail_dpa = cxl_memdev_get_dynamic_ram_a_size(memdev);
>  
>  	cxl_decoder_foreach(port, decoder) {
>  		size = cxl_decoder_get_dpa_size(decoder);
> diff --git a/cxl/region.c b/cxl/region.c
> index 85d4d9b..3c935bf 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -303,7 +303,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  
>  	if (param.type) {
>  		p->mode = cxl_decoder_mode_from_ident(param.type);
> -		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
> +		if ((p->mode == CXL_DECODER_MODE_RAM ||
> +		     p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) && param.uuid) {
>  			log_err(&rl,
>  				"can't set UUID for ram / volatile regions");
>  			goto err;
> @@ -417,6 +418,9 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
>  		case CXL_DECODER_MODE_PMEM:
>  			size = cxl_memdev_get_pmem_size(memdev);
>  			break;
> +		case CXL_DECODER_MODE_DYNAMIC_RAM_A:
> +			size = cxl_memdev_get_dynamic_ram_a_size(memdev);
> +			break;
>  		default:
>  			/* Shouldn't ever get here */ ;
>  		}
> @@ -448,8 +452,10 @@ static int create_region_validate_qos_class(struct parsed_params *p)
>  
>  		if (p->mode == CXL_DECODER_MODE_RAM)
>  			qos_class = cxl_memdev_get_ram_qos_class(memdev);
> -		else
> +		else if (p->mode == CXL_DECODER_MODE_PMEM)
>  			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
> +		else
> +			qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
>  
>  		/* No qos_class entries. Possibly no kernel support */
>  		if (qos_class == CXL_QOS_CLASS_NONE)
> @@ -488,6 +494,12 @@ static int validate_decoder(struct cxl_decoder *decoder,
>  			return -EINVAL;
>  		}
>  		break;
> +	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
> +		if (!cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
> +			log_err(&rl, "%s is not dynamic_ram_a capable\n", devname);
> +			return -EINVAL;
> +		}
> +		break;
>  	default:
>  		log_err(&rl, "unknown type: %s\n", param.type);
>  		return -EINVAL;
> @@ -509,9 +521,11 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>  		return;
>  
>  	/*
> -	 * default to pmem if both types are set, otherwise the single
> +	 * default to pmem if all types are set, otherwise the single
>  	 * capability dominates.
>  	 */
> +	if (cxl_decoder_is_dynamic_ram_a_capable(p->root_decoder))
> +		p->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
>  	if (cxl_decoder_is_volatile_capable(p->root_decoder))
>  		p->mode = CXL_DECODER_MODE_RAM;
>  	if (cxl_decoder_is_pmem_capable(p->root_decoder))
> @@ -699,6 +713,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  				param.root_decoder);
>  			return -ENXIO;
>  		}
> +	} else if (p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
> +		region = cxl_decoder_create_dynamic_ram_a_region(p->root_decoder);
> +		if (!region) {
> +			log_err(&rl, "failed to create region under %s\n",
> +				param.root_decoder);
> +			return -ENXIO;
> +		}
>  	} else {
>  		log_err(&rl, "region type '%s' is not supported\n",
>  			param.type);


