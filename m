Return-Path: <nvdimm+bounces-14377-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JZ2vAX2bKWpZagMAu9opvQ
	(envelope-from <nvdimm+bounces-14377-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Jun 2026 19:14:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D36F766BE70
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Jun 2026 19:14:35 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=XUWTrPML;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14377-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14377-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 71EA530DB8C4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Jun 2026 16:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0873034405B;
	Wed, 10 Jun 2026 16:55:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD1332EBB
	for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 16:55:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110553; cv=none; b=TPhva1r2q/jPlyE6UH6urst3sU8JqsYdW1cYP/b216ZChX2OTq3HQ2gJZSdz0XK2K69YA98tFFfXsytOFyJI2hTzmRxyBWNFjnQ2iGzT7wb3FE7ivgkGshIjitEUgwjqsK0QCcfnKmXjutI37NVXuluYBPoJTbbHE4dn4Pa+wAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110553; c=relaxed/simple;
	bh=s5ITXrYBZuuIMrxSZGI2VrUQx3GqktyTS1YvO5WU/38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P73gydirwoJQuItyWx9tLg8LFUsHXhqdBx305IBVZDDdSrJWUB/NmBQq/1eqVeTO0YfdS2bC5Wlm3bCG/LNpSbRD2hvDeWBNP15vhyZP4pxX2PjAN4RuxzT+s8M8yN22ISM0SuFHxBKdD4ZH5l9eti4AQzCLf8VYnMTzw7oe69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XUWTrPML; arc=none smtp.client-ip=192.198.163.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781110553; x=1812646553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s5ITXrYBZuuIMrxSZGI2VrUQx3GqktyTS1YvO5WU/38=;
  b=XUWTrPMLDkIwvJM9nt0pd+rOXTneEQjFEnmhPAhX5dxr6xl5YE8mxZ2Q
   hm5bM26qWCXQoGOjMJ7ntUEqBHzTK+dFPiSuUE3impYYnZ/Mb+edq2+5V
   0FbuP4e/EnVSQ/2//XnqoEyHTZjkj2u5qbr2H9OO4i1L7fsYB++8/rHnU
   iEQRrVb3nhFkJwB/LwJCzCfczrM6ygyaYg37nuSgziH8S5CdliiHFyPYE
   FadiT5jAjLUE7kw8/x3+bAyW6Q1Ksg4VpVf5Ah0rHsj1pp72V6+xRG1gf
   k1grbwE4kqa/oGVRf+3NC62wgN8eDuEyunN6dkSo0yucQq77tbs8sxRQK
   Q==;
X-CSE-ConnectionGUID: 3wZSMA/cTVeCchwu0dJoWA==
X-CSE-MsgGUID: sQoZtdgfQoe2tHdUpmoQqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="92476983"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="92476983"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:55:52 -0700
X-CSE-ConnectionGUID: HzAnaYx6SzaULncc5T8h9w==
X-CSE-MsgGUID: RunScNijSwOkypS6Cecmtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="243765877"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.25]) ([10.125.110.25])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:55:50 -0700
Message-ID: <8656e29c-79ff-4b96-87ba-7919ad32a6a2@intel.com>
Date: Wed, 10 Jun 2026 09:55:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
To: Richard Cheng <icheng@nvidia.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
 <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
 <aijefVjI2x6hgxH8@MWDK4CY14F>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aijefVjI2x6hgxH8@MWDK4CY14F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14377-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:icheng@nvidia.com,m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@groves.net,m:gourry@gourry.net,m:ira.weiny@intel.com,m:anisasu887@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lists.linux.dev,kernel.org,stgolabs.net,intel.com,groves.net,gourry.net];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D36F766BE70



On 6/9/26 8:51 PM, Richard Cheng wrote:
> On Mon, Jun 08, 2026 at 04:19:47PM +0800, Dave Jiang wrote:
>>
>>
>> On 5/23/26 2:50 AM, Anisa Su wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>

<-- snip -->

>>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>>> index ed4429f..258bdd3 100644
>>> --- a/cxl/lib/libcxl.sym
>>> +++ b/cxl/lib/libcxl.sym
>>> @@ -294,6 +294,10 @@ global:
>>>  	cxl_memdev_get_fwctl;
>>>  	cxl_fwctl_get_major;
>>>  	cxl_fwctl_get_minor;
>>> +	cxl_memdev_get_dynamic_ram_a_size;
>>> +	cxl_memdev_get_dynamic_ram_a_qos_class;
>>> +	cxl_decoder_is_dynamic_ram_a_capable;
>>> +	cxl_decoder_create_dynamic_ram_a_region;
>>>  } LIBECXL_8;
>>>  
>>>  LIBCXL_10 {
> 
> Shouldn't new exported symbols go in a fresh top-level node ?
> Something like LIBCXL_12 ? please note that Patch 4 has the same
> issue.
> 
> Please let me know if I'm wrong or misunderstand anything.
You are correct. These need to be moved to a new block for a new release. 

