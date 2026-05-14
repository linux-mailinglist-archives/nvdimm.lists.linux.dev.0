Return-Path: <nvdimm+bounces-14022-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NYoOlMEBmq1eAIAu9opvQ
	(envelope-from <nvdimm+bounces-14022-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 19:20:19 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5213354528B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 19:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFCDB30A8088
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 May 2026 17:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3316438D413;
	Thu, 14 May 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ang3TSqr"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A4633F5BF
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778779008; cv=none; b=rK2GvB0Tm0/QauMGwrSGwgqe8EpnNR6fgvdHFr3kOt9l5cDgtviveUrZuH/erOefC+5ObDGn7b/waNwg0xd9saS73QIpsjYAMuKYB2hr7mXt8Iw0h8DdNu53afMkyxPdj0636fkXaDWngyD60ujrv94EDLqAcoWo6KPUti3o35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778779008; c=relaxed/simple;
	bh=hnC/lfNqpctTim9a6fu/j27gRyLG1LO3+0tYOQi/H4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TT93bsCi8OKU92IxiG7U/Mk9n0Ls+QLa5I9xuCtwNtU7nxicuNx7f3PZam57tsH1nEuv/MxTQ2JzignBnqRK88qADr7bkGbuqNDgpj8XqgnazMpXsUu/9efo0xIRPZpanPCW+P2dYjoNgT54dBLq8HWQZvx9WxgdPmPv4mulMbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ang3TSqr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778779007; x=1810315007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hnC/lfNqpctTim9a6fu/j27gRyLG1LO3+0tYOQi/H4c=;
  b=ang3TSqrfXOBMs00Y6dqdvSEdrcTR+X58hD2d3c1SlfD00m4IDIsdLsH
   Z3DR/9UrqCbvBM3u1m0H22a/Dx8frCTkxYe5ePTiZr2qmQUNvSXh+Ed3L
   fTEj8lz8csFjUOvJ4Gm4JMJx9fAMBUqTdyfk5g6JXq1LggGws542tDhi2
   dxeaH6KpSxFio4u87E0hL9Oh1PXb62jajKqoFm6Vk1lKJk15TYYmW8aKU
   JA0QMsvUM2QkbloeI02pdg+h2xcl2pGCIIlOoTHUvzYxO25PdF9oO0ERo
   p3uSFLYz9wwRkTeN4/oNSapQqST08gzzq7beHmnl5DLl2gKZ7f9l7Ox7D
   g==;
X-CSE-ConnectionGUID: iN3sqfpnS762qpfeWFoOoQ==
X-CSE-MsgGUID: 2K//KYUcQHKRabeMJZLrLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="79585378"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="79585378"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 10:16:46 -0700
X-CSE-ConnectionGUID: ghn6Rx2dRDyBhEadq53Wug==
X-CSE-MsgGUID: M62kff7vTaOIUPCrEYHkdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="238544279"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.108.122]) ([10.125.108.122])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 10:16:46 -0700
Message-ID: <bedcd7ec-b73e-470a-8d53-c77d28f33b31@intel.com>
Date: Thu, 14 May 2026 10:16:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/2] daxctl: fix kmod reference leak on probe-insert
 failure
To: Chen Pei <cp0613@linux.alibaba.com>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, guoren@kernel.org
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
 <20260514063234.86439-2-cp0613@linux.alibaba.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260514063234.86439-2-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5213354528B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-14022-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:mid,intel.com:dkim,alibaba.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action



On 5/13/26 11:32 PM, Chen Pei wrote:
> daxctl_insert_kmod_for_mode() obtains a kmod reference via
> kmod_module_new_from_name() and only stores it in dev->module after a
> successful kmod_module_probe_insert_module() call. On the failure path
> the local reference was returned without being released, leaking one
> reference per failed enable attempt.
> 
> Drop the reference before returning the error code.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  daxctl/lib/libdaxctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 02ae7e5..ffc81eb 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -927,6 +927,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
>  			NULL, NULL, NULL, NULL);
>  	if (rc < 0) {
>  		err(ctx, "%s: insert failure: %d\n", devname, rc);
> +		kmod_module_unref(kmod);
>  		return rc;
>  	}
>  	dev->module = kmod;


