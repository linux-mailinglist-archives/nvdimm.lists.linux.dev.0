Return-Path: <nvdimm+bounces-14173-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id RnZZF2aGF2quIAgAu9opvQ
	(envelope-from <nvdimm+bounces-14173-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 May 2026 02:03:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D225EB1B4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 May 2026 02:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6424B30A55A6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 May 2026 00:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FECFDF76;
	Thu, 28 May 2026 00:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIwmCyhP"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54ED33EC
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 00:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779926508; cv=none; b=DrKwXHt7krtRP0HHSTZHVZkQ/WuC8adfdYlF4tGWgLQYLanBBnVrgN906AeomQ8dSXj7eVGTGJpXy5qvxjrE9LqtLfe32qy45VSGpEORcfamLzM4F0qM7HOVVFxGNUZ/MJaWuO4mIq8WjuxrubuhrEX5p/+VXQ992DVmSJhDal4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779926508; c=relaxed/simple;
	bh=pqCOiUztg6z/xf/W3b+UYSaCiLUC+36YhkeJWSrC4aI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QljpFKzIuxeIMJX2TsmrdA4j08iy/58f7slKUkXdIH+bOAkG3Kee6SN3n6y0Iiglpmo/DdolynE5tL9vt1UbNfsRtySycVip9lpLoFhe6szYBW40BTAqDY9nNwqQOyIiY5JEPODjv9Ke5NlyLdeVBpruPtGuSth4mcS9Rc+OXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIwmCyhP; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779926507; x=1811462507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pqCOiUztg6z/xf/W3b+UYSaCiLUC+36YhkeJWSrC4aI=;
  b=BIwmCyhPxXMarv0djLFeNbFpZGBcUMH1AvLAFVK5ChB04qxo6dixV7b8
   y6nVtbpFjbepsO6PhSLx9auvnKyNXjmcItRWstBV7Rzso8xRy7r3t1vLz
   C8Gtq/wdPFhPrLP2tvVkICLpQSWK6JR51K3qu1cmQFLJWlA5I4VRVFxnK
   G6pXcfnfVXSeB5gtzDqaRAVT+B5nbfjpskm9S95OmWs2TzaiEDBOCBQAo
   Jv2icKydCrvtk/XzWcFF3jnVHfrIY8uu5NhuALxPt0MSqWlNFdKiHquk+
   vx364bRrkwnQ4QDF+uBQ18Jlf/8yeTqjfF3NHASvg3E7kXnByk6IPRDea
   w==;
X-CSE-ConnectionGUID: aIvyU3CCSsu8C1f/L91K5w==
X-CSE-MsgGUID: hu3Tk8+gSFqIneBfOQ+0JQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="106220030"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="106220030"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 17:01:46 -0700
X-CSE-ConnectionGUID: IK4moRaERcGsvA2YPS8RPA==
X-CSE-MsgGUID: b5d3NqVlSnqczFtM7DR6lw==
X-ExtLoop1: 1
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 17:01:45 -0700
Message-ID: <e504359a-ff13-4ad1-a74c-337ede7f11c6@intel.com>
Date: Wed, 27 May 2026 17:01:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/31] cxl/port: Add 'dynamic_ram_a' to endpoint
 decoder mode
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <58e5e5007cd11e0b8e65016f126144f187badb39.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <58e5e5007cd11e0b8e65016f126144f187badb39.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14173-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 96D225EB1B4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/23/26 2:43 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Endpoints can now support a single dynamic ram partition following the
> persistent memory partition.
> 
> Expand the mode to allow a decoder to point to the first dynamic ram
> partition.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Need Anisa sign off

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Just update kver and dates below.

> 
> ---
> Changes:
> [anisa: rebase]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 18 +++++++++---------
>  drivers/cxl/core/port.c                 |  4 ++++
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 3d95c325f6e0..c604c7ca6432 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -358,22 +358,22 @@ Description:
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/mode
> -Date:		May, 2022
> -KernelVersion:	v6.0
> +Date:		May, 2022, May 2025

A later date

> +KernelVersion:	v6.0, v6.16 (dynamic_ram_a)

7.3 maybe?

DJ

>  Contact:	linux-cxl@vger.kernel.org
>  Description:
>  		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
>  		translates from a host physical address range, to a device
>  		local address range. Device-local address ranges are further
> -		split into a 'ram' (volatile memory) range and 'pmem'
> -		(persistent memory) range. The 'mode' attribute emits one of
> -		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
> -		not actively decoding, or no DPA allocation policy has been
> -		set.
> +		split into a 'ram' (volatile memory) range, 'pmem' (persistent
> +		memory), and 'dynamic_ram_a' (first Dynamic RAM) range. The
> +		'mode' attribute emits one of 'ram', 'pmem', 'dynamic_ram_a' or
> +		'none'. The 'none' indicates the decoder is not actively
> +		decoding, or no DPA allocation policy has been set.
>  
>  		'mode' can be written, when the decoder is in the 'disabled'
> -		state, with either 'ram' or 'pmem' to set the boundaries for the
> -		next allocation.
> +		state, with either 'ram', 'pmem', or 'dynamic_ram_a' to set the
> +		boundaries for the next allocation.
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 0c5957d1d329..a7f71f36531f 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -128,6 +128,7 @@ static DEVICE_ATTR_RO(name)
>  
>  CXL_DECODER_FLAG_ATTR(cap_pmem, CXL_DECODER_F_PMEM);
>  CXL_DECODER_FLAG_ATTR(cap_ram, CXL_DECODER_F_RAM);
> +CXL_DECODER_FLAG_ATTR(cap_dynamic_ram_a, CXL_DECODER_F_RAM);
>  CXL_DECODER_FLAG_ATTR(cap_type2, CXL_DECODER_F_TYPE2);
>  CXL_DECODER_FLAG_ATTR(cap_type3, CXL_DECODER_F_TYPE3);
>  CXL_DECODER_FLAG_ATTR(locked, CXL_DECODER_F_LOCK);
> @@ -222,6 +223,8 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
>  		mode = CXL_PARTMODE_PMEM;
>  	else if (sysfs_streq(buf, "ram"))
>  		mode = CXL_PARTMODE_RAM;
> +	else if (sysfs_streq(buf, "dynamic_ram_a"))
> +		mode = CXL_PARTMODE_DYNAMIC_RAM_A;
>  	else
>  		return -EINVAL;
>  
> @@ -327,6 +330,7 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
>  static struct attribute *cxl_decoder_root_attrs[] = {
>  	&dev_attr_cap_pmem.attr,
>  	&dev_attr_cap_ram.attr,
> +	&dev_attr_cap_dynamic_ram_a.attr,
>  	&dev_attr_cap_type2.attr,
>  	&dev_attr_cap_type3.attr,
>  	&dev_attr_target_list.attr,


