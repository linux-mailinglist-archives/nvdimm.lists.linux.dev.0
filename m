Return-Path: <nvdimm+bounces-14771-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ve4DD5AtTGo7hQEAu9opvQ
	(envelope-from <nvdimm+bounces-14771-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 00:34:56 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87638715FBA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 07 Jul 2026 00:34:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=HHe7z5Qc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14771-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14771-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B90D300D14E
	for <lists+linux-nvdimm@lfdr.de>; Mon,  6 Jul 2026 22:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED812435AAC;
	Mon,  6 Jul 2026 22:33:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EF434E50
	for <nvdimm@lists.linux.dev>; Mon,  6 Jul 2026 22:33:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377233; cv=none; b=gYHg8Hv9Thiom/yrSehKxInOcZlOSRR8u7Pft4ppu+D0wBRD7tQHLQUFRsY+lxWJbQQaNAq8qwxh1dNgg4ctRx0H1noroYClr9R2JM9Snycm4SJk1u+r9IajcaVDAo6Rw5aCMU0pQCEnIEXTObMEx40xrRI17PkBtHy2hGdMVf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377233; c=relaxed/simple;
	bh=XVcl6BRwP7RrU/ox9Ml72dHb0MOHCEwPiu3RHFD6tmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5dDYqQA+NxZ/qwZMD9C9ZfBG18/6B9bRjba3YzniaZn943/eVQPCyXjf8qVBdHAmid2MamfIqqejDZlc4aAM5qKbDv6h0D+ixnNDhxs1s5WhCzPQlEQWpw8UvmnBWCTz4Qhr0VMvFwcnvvQzTUL77UAAdYeBlJYxQFQ0kwt3EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHe7z5Qc; arc=none smtp.client-ip=198.175.65.15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783377232; x=1814913232;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XVcl6BRwP7RrU/ox9Ml72dHb0MOHCEwPiu3RHFD6tmw=;
  b=HHe7z5QcwOw4vVkA3gp3HaM2N5GdbMElfRyZcAjOinI0DsW5/0nygt67
   4XHrm0hGY8/tAZw48dGyV4R6edT/mR5FBnkHjAJnsn8GFs6a/Kua2Abex
   vTPaki82bEzwapDtZOV9fQhtl0hZo1l3qwPlOPstCLzcz2XxMTU+Lm52N
   +dpJ5Pp7qYt3t4qqqiUzopD0jXCPJ28GbT0YQiEmoFVsUdBwBO+UxRw+y
   zpRUsGOlRPloYQ7FWSfp6fSh2/367gprhCdjrnvA7qh+0XiN/lfNRC5Gs
   uRbgsdd41Dt/UFcrNnVQUjT81v9PRbgZ2YU+FCn/Y8k7WOUvRg+lEZJvq
   w==;
X-CSE-ConnectionGUID: PLnv/ONFTvaS0pkBnB7htw==
X-CSE-MsgGUID: aqW5pY6YQtykzS3o8maf6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="87700873"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="87700873"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:33:52 -0700
X-CSE-ConnectionGUID: bJDXbE9CSfOMTYa9ViaHJg==
X-CSE-MsgGUID: yeNGLJTkRw62Ph0Y1jUSBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="278179608"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.202]) ([10.125.110.202])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:33:50 -0700
Message-ID: <ef94638b-3a79-4cf6-ad72-835899a6e640@intel.com>
Date: Mon, 6 Jul 2026 15:33:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: ndtest: remove redundant NULL check before
 vfree()
To: mdshahid03@gmail.com, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260703135513.75840-1-mdshahid03@gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260703135513.75840-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14771-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:mdshahid03@gmail.com,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,intel.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ifnullfree.cocci:url,intel.com:from_mime,intel.com:email,intel.com:mid,intel.com:dkim,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 87638715FBA



On 7/3/26 6:55 AM, mdshahid03@gmail.com wrote:
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
>  tools/testing/nvdimm/test/ndtest.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 8e3b6be53839..2051ad5d4882 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -376,8 +376,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv *p, size_t size,
>  buf_err:
>  	if (__dma && size >= DIMM_SIZE)
>  		gen_pool_free(ndtest_pool, __dma, size);
> -	if (buf)
> -		vfree(buf);
> +	vfree(buf);
>  	kfree(res);
>  
>  	return NULL;


