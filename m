Return-Path: <nvdimm+bounces-14306-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bQGDDK20IGrZ6wAAu9opvQ
	(envelope-from <nvdimm+bounces-14306-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 04 Jun 2026 01:11:41 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE4A63BC85
	for <lists+linux-nvdimm@lfdr.de>; Thu, 04 Jun 2026 01:11:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=PH01pWna;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14306-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14306-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6289E304EDA4
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Jun 2026 23:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAFD4DC551;
	Wed,  3 Jun 2026 23:07:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C633B3BE7
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 23:07:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528060; cv=none; b=Dt5ggidElqk6kgm1yQWYmPV+LYt0ygxtvgz0o1gi5Vc6oMzKAuWDwGlRjLPwmLRmzB2ZlzbHbfIM1U17JvbTxeY15ASJtdAqJe1aZYKswEwtyoGlyNGVORxqx+/iva3FwluXwyjEuDBKnwQaPv1Eq1umNNEFsGZ/LR6WIotCIsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528060; c=relaxed/simple;
	bh=bhyl+Ajbr28WxhXEGBrhy4nFysfcdjKDurnstTUhQTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aApCSsg6HPmdMO/HBMs1yGQ0UpmmcAfZZl3Xq6bS9vpsR3vaGjKxkgtP2iDODSJTf75rGVyAkIIKEjNWP9X5Suhd3MfHs295wm3L1RscyyAeBkTR0xbJc2yd/u7WloXF41GzBxoCowozEHlh0NJ7csUEDthqth9pLFeGQQC4C4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PH01pWna; arc=none smtp.client-ip=198.175.65.12
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780528060; x=1812064060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bhyl+Ajbr28WxhXEGBrhy4nFysfcdjKDurnstTUhQTg=;
  b=PH01pWnaF4LA21/1Vp0lMOKHu+7TWvTznXo56Zay51VmEtkjkicleb1S
   wjGXc9y4+L+U/vk22+XxnRr/LJThc4R1CQ8PyIsbds1qXPlfMEQiAHNj2
   pf+fHK+QPMAgJJNbkPykk/kzQmBbtev04Zctp2u7Hx1yRbRiqJftYQHyJ
   F0BOF4tStKIw1SagSF1O+qa8Feew9Sb4hbGCd63nhN4G+0Jv3cSEkMUdH
   BluukQkgDjDwRFsVteQS58zG3/MRhNKKoaEmu+AbT3G0SET1fmcdMW1WI
   J7lsbDcC2kwf31YONp6KmHXBGHkrFw6wb3PP3/BT1ke52XMUanD1ZilJ3
   Q==;
X-CSE-ConnectionGUID: 8YUFbkz3Tv2m4/C4WnlSJA==
X-CSE-MsgGUID: EQGcVWt3RzKbcrxK+31ZAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="92835031"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="92835031"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:07:40 -0700
X-CSE-ConnectionGUID: YYKj5LuERKKKBTqU/vayWg==
X-CSE-MsgGUID: GI7BVHURQRKkZmFD9aizDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="244457813"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.116]) ([10.125.108.116])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:07:37 -0700
Message-ID: <1909af0f-8f06-4555-a5f5-f309ee60fcfa@intel.com>
Date: Wed, 3 Jun 2026 16:07:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] ACPI: NFIT: core: Eliminate redundant local
 variable
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
 <14028918.uLZWGnKmhe@rafael.j.wysocki>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <14028918.uLZWGnKmhe@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14306-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:rafael@kernel.org,m:linux-acpi@vger.kernel.org,m:djbw@kernel.org,m:linux-kernel@vger.kernel.org,m:vishal.l.verma@intel.com,m:nvdimm@lists.linux.dev,m:alison.schofield@intel.com,m:chenxiang66@hisilicon.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:from_mime,intel.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2FE4A63BC85



On 6/3/26 10:57 AM, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Eliminate local variable acpi_desc from __acpi_nvdimm_notify() because it
> is redundant (its value is only checked against NULL once and the value
> assigned to it may be checked directly instead) and update the subsequent
> comment to reflect the code change.
> 
> No functional impact.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/acpi/nfit/core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 01c73be0bd00..aaa84ae7a20e 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1680,7 +1680,6 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
>  void __acpi_nvdimm_notify(struct device *dev, u32 event)
>  {
>  	struct nfit_mem *nfit_mem;
> -	struct acpi_nfit_desc *acpi_desc;
>  
>  	dev_dbg(dev->parent, "%s: event: %d\n", dev_name(dev),
>  			event);
> @@ -1691,12 +1690,11 @@ void __acpi_nvdimm_notify(struct device *dev, u32 event)
>  		return;
>  	}
>  
> -	acpi_desc = dev_get_drvdata(dev->parent);
> -	if (!acpi_desc)
> +	if (!dev_get_drvdata(dev->parent))
>  		return;
>  
>  	/*
> -	 * If we successfully retrieved acpi_desc, then we know nfit_mem data
> +	 * If the parent's driver data pointer is not NULL, then nfit_mem data
>  	 * is still valid.
>  	 */
>  	nfit_mem = dev_get_drvdata(dev);


