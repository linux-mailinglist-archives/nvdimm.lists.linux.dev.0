Return-Path: <nvdimm+bounces-14770-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vhFtBDMtTGoghQEAu9opvQ
	(envelope-from <nvdimm+bounces-14770-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 00:33:23 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60389715F89
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 00:33:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=MyJg+Jag;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14770-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14770-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2BBB30453A7
	for <lists+linux-nvdimm@lfdr.de>; Mon,  6 Jul 2026 22:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20354435AAB;
	Mon,  6 Jul 2026 22:32:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DA4435AB2
	for <nvdimm@lists.linux.dev>; Mon,  6 Jul 2026 22:32:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377157; cv=none; b=vFePMfh5oEYl2/47DOSt8AxWaVMGtc5Fg7EHF6CSruouuOA2NxXu2ro56ZUgCTTjsAwvPI48XXR60RHUmaM6xmzwY5JsA96fWrhfqKw12EfE03VEu+/O433x2KGm4h2dfFTMG/Mt1WaB8tcjVyFVsVJnqfJ28oWoXr9a11xfzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377157; c=relaxed/simple;
	bh=qOrM4sw46CtOSY6MbIlGeIi8vjVlDXaJDTKbaYWzzZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/OGcLKmIHKRlw3B2en9Au3rv8dsJvwn64eDIN0UnhE7DrPUE5NudmCnA4QIfJxg5bl+hVxP4Ssq5z4a/tyxjJY0C3NdXle8B5TgsIJlCUrtcLrx6qumZYDgUyfgzAn9Br9/Bo9Q/WoRNK5LshHh54Uzpv5PCsZ/8kadmqGU1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MyJg+Jag; arc=none smtp.client-ip=198.175.65.15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783377156; x=1814913156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qOrM4sw46CtOSY6MbIlGeIi8vjVlDXaJDTKbaYWzzZg=;
  b=MyJg+JagIWQ/HgVf+LDLE5AlU+SNvWm+sPwz9ZZd+SDlH7ASEXUxi8Ho
   zEMtE0wcH5NiB4o3s931EEtV746JZzvUlsGQktj/aMXDbnbfNs8Ve2Qvi
   b8oFfdlD4waP33KYxUHAFzbSv1P2D7jvndJ44I3Emu9bjXvSU6CBfDz/C
   du8blxAE6Z19tSiGe+PmlFoJnEFCmLPOI9BkAW31D6kEsBdxp7QdcRY5B
   cMrmvG0MRVZFhyvolLLPVaPK0KPDHXxHnzUIDRAPLTa4RfCiXC/zDPGg7
   s1RaPQ1jjp5wJyrXVszYm48cpwlcbzuBWsWTa1fOOd37O7T+nTbTBD21y
   g==;
X-CSE-ConnectionGUID: C9tWa3VSSjS2T1L8o+eRng==
X-CSE-MsgGUID: fF6aXgKdTAie63PM9vxS0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="87700790"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="87700790"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:32:36 -0700
X-CSE-ConnectionGUID: 0JT2CG9AQvyKFfFgICUafg==
X-CSE-MsgGUID: 1bRP+e2NTa29gDhtFLACQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="278179415"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.202]) ([10.125.110.202])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:32:35 -0700
Message-ID: <05e4d5aa-ece4-4f43-89d2-23471f1edbbd@intel.com>
Date: Mon, 6 Jul 2026 15:32:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: nfit: remove redundant NULL check before vfree()
To: mdshahid03@gmail.com, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260703144851.80309-1-mdshahid03@gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260703144851.80309-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14770-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:mdshahid03@gmail.com,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,intel.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:from_mime,intel.com:email,intel.com:mid,intel.com:dkim,ifnullfree.cocci:url,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 60389715F89



On 7/3/26 7:48 AM, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> vfree() safely handles NULL pointers, so the explicit NULL check
> before calling vfree() is unnecessary.
> 
> This issue was reported by ifnullfree.cocci.
> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  tools/testing/nvdimm/test/nfit.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index f87e9f251d13..009fe107b0d7 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1644,8 +1644,7 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
>   err:
>  	if (*dma && size >= DIMM_SIZE)
>  		gen_pool_free(nfit_pool, *dma, size);
> -	if (buf)
> -		vfree(buf);
> +	vfree(buf);
>  	kfree(nfit_res);
>  	return NULL;
>  }


