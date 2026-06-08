Return-Path: <nvdimm+bounces-14343-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id cxc9GbBNJ2ppugIAu9opvQ
	(envelope-from <nvdimm+bounces-14343-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 01:18:08 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB29A65B256
	for <lists+linux-nvdimm@lfdr.de>; Tue, 09 Jun 2026 01:18:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=MgEN3H5A;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14343-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14343-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62CF03026F11
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Jun 2026 23:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E323E32B13F;
	Mon,  8 Jun 2026 23:18:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF352F5313
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 23:18:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960685; cv=none; b=FqFmw+zfQ91Z4HsAmAZsarsOGIISFqRaQghLb87we3Yj71WV0IGZ2ChjNLuq13APHTwnSAD7omiI9+hG1Xq2YVLDxfj+yXnumNHsBTw7wdQB8zLK1OJ/PD8ajkLGwrkJAltDIf1u9q0C7GPKujylJ2sXtjM5XWvrYHKYeAQtX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960685; c=relaxed/simple;
	bh=5ylPIsMklYen/0GNNM4NaqqCpIPlXonB5UhyBxWjFeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEl09hlIJs7HL/3wrKlSyd+1g0mWU+kKitmMV8R9ffylnuKEM61jPqinlNomCUrjTdN3uWpM5K7Iwu8PZBHMgBqANBIwdsHQewaOJHDYzgdPJ7/fmUnJB/FaATRLSatNr+6GZhnSw89U4gsVyiMDL7CTBsEdELA6pqAjYUcYKmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgEN3H5A; arc=none smtp.client-ip=192.198.163.18
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960685; x=1812496685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5ylPIsMklYen/0GNNM4NaqqCpIPlXonB5UhyBxWjFeI=;
  b=MgEN3H5A3lQbQiX95pARPhYq9KzeT2CLEvaOMjQHO9v2u4XQyoXuAlkm
   K73r03Yq0Ky3+zKgmgUTAu2lSlba2RRTU5SRkyuiHwfPaP0OYrCnBvQPU
   ghSrrc8Urx7d8QkymuhP7pICn8YRZUE4C4v7w4tGIDEtGU2i4db4l4NkQ
   GpnfJCks/KVpUQ9Zv5jSPclcjOJM0jqt2GOozHgNynkUGn4ieiwU1+/fd
   oRkE1COVZ2uFFs9NM6juJQ/vVYAKRjgNb0tE6JcIGWoarLkIH98bO/hwl
   c07xutXfqy1b1N7HSPHMDcBAcBU5qU6Edi7lpLcthJYGyYnIRbLB5GLh+
   A==;
X-CSE-ConnectionGUID: n0TuH08BR1eeSuPF7hTWUQ==
X-CSE-MsgGUID: Fuba3Uu7RwieH7/m8DV+bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="80845200"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="80845200"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:04 -0700
X-CSE-ConnectionGUID: oR5/CAqsQd62nS9MHlizIQ==
X-CSE-MsgGUID: 3snTDnR8QAm4AiQHmobVtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="249606888"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:03 -0700
Message-ID: <e4e51537-73f8-4a41-a7bc-b0b72b817b7b@intel.com>
Date: Mon, 8 Jun 2026 16:18:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/7] ndctl: Dynamic Capacity additions for cxl-cli
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Sushant1 Kumar <sushant1.kumar@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-2-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-2-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14343-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:anisa.su887@gmail.com,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@Groves.net,m:gourry@gourry.net,m:ira.weiny@intel.com,m:vishal.l.verma@intel.com,m:jonathan.cameron@Huawei.com,m:fan.ni@samsung.com,m:sushant1.kumar@intel.com,m:dan.j.williams@intel.com,m:anisasu887@gmail.com,s:lists@lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.dev:email,huawei.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: AB29A65B256



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> This series can be found here:
> 
> 	https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13
> 
> CXL Dynamic Capacity Device (DCD) support is being discussed in the
> upstream kernel.  cxl-cli requires modifications to interact with those
> devices.
> 
> A new partition type 'dynamic_ram_a' has been added which cxl-cli
> needs to know about.  Add support for the new decoder type.
> 
> With DCD regions may, or may not, have capacity.  The capacity is
> communicated via extents.  Add region extent query capabilities.
> 
> Add cxl-test support.  cxl-testing allows for quick regression testing
> as well as helping to design the cxl-cli interfaces.
> 
> 
> To: "Alison Schofield" <alison.schofield@intel.com>
> Cc: "Vishal Verma" <vishal.l.verma@intel.com>
> Cc: "Jonathan Cameron" <jonathan.cameron@Huawei.com>
> Cc: "Fan Ni" <fan.ni@samsung.com>
> Cc: "Sushant1 Kumar" <sushant1.kumar@intel.com>
> Cc: "Dan Williams" <dan.j.williams@intel.com>
> Cc: "Dave Jiang" <dave.jiang@intel.com>
> Cc: <linux-cxl@vger.kernel.org>
> Cc: <nvdimm@lists.linux.dev>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Drop this? Seems b4 metadata and not a patch.


> 
> ---
> Changes in v5:
> - iweiny: Adjust all code to view only the dynamic RAM A partition
> - Alison: s/tag/uuid/ in region query extent output
> - Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com
> 
> --- b4-submit-tracking ---
> # This section is used internally by b4 prep for tracking purposes.
> {
>   "series": {
>     "revision": 5,
>     "change-id": "20241030-dcd-region2-2d0149eb8efd",
>     "prefixes": [],
>     "history": {
>       "v1": [
>         "20241030-dcd-region2-v1-0-04600ba2b48e@intel.com"
>       ],
>       "v2": [
>         "20241104-dcd-region2-v2-0-be057b479eeb@intel.com"
>       ],
>       "v3": [
>         "20241115-dcd-region2-v3-0-585d480ccdab@intel.com"
>       ],
>       "v4": [
>         "20241214-dcd-region2-v4-0-36550a97f8e2@intel.com"
>       ]
>     }
>   }
> }


