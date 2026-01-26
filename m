Return-Path: <nvdimm+bounces-12870-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGjvHdSmd2lrjwEAu9opvQ
	(envelope-from <nvdimm+bounces-12870-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 18:39:32 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5CA8B942
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 18:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A142A3013ED8
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 17:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB97234A790;
	Mon, 26 Jan 2026 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GUm28pzD"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434762D73A0
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769449166; cv=none; b=AIGmwY1NiyrNeWM8LpUHNcJ3ZO1wqv0Mjmh+ZeGFDvtjjEVp7bLIPEypEP3JtKNzU5gIJe2gfQZyfHWK5BQkbBNi2xDX72BZNQA8V6D3adb/+PbgTnSGt2zi0fdlGkQnKNrZXRfOFwSX51gPmDOvUqF5uxHPhTsnTY2DuItadds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769449166; c=relaxed/simple;
	bh=GdnZo3Rj1E274mSOr6kQT1Mo74Gj5afcrFjTg2gwmPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W/4pTA7lFmEDRiGlc7qV4yNoCg8vMOv85U+ab8nlWd5KCOm7HiDJkxLxYp00MuIGJLsVRwnbinK2iinsezAwuRDy9eZVdO/0hPLVMH5zwUAa6JtHhWVDW9TfDZnW7j1ngl5O6CyNiV0ciVMKe1khlUjKVSsildN9luqJl1MUq+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GUm28pzD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769449164; x=1800985164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GdnZo3Rj1E274mSOr6kQT1Mo74Gj5afcrFjTg2gwmPc=;
  b=GUm28pzDGtv3APIan4RNMSvR6OAniIVnZJoE2q2ZjcsK/6lJVkyyKjTA
   lxCnDdvpDt9Vd7EW//+LTYJBMnH/u3yvbo5sE052+SmxQiaQ1qf294qpJ
   w6iIx6ahsoIFZVTtA6ZvAaJn5W6kDiAbrqoi0Fi41u2FZegG2v6bzVGDl
   yZGk81udNJQvquSWPcjlorq2Gt/ovGO3CfqNPz9XTsb58R+0Qvk5VFGG9
   Fh4VnifDtumbe9u2ry3qdve6eHB1qDYg5Za5C6evrmCknXiWy4eaS9iJT
   8JdZvQ/+FQEW5/cs+yLrakNJzYablb6X4eWkGlrPK2J453HT3e8I4CigH
   A==;
X-CSE-ConnectionGUID: F93fX4k4Tx2FZJ+HJL6o/A==
X-CSE-MsgGUID: X0UkzarRT4Ony7Cf97964Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="69829952"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="69829952"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 09:39:23 -0800
X-CSE-ConnectionGUID: UF1mO/ErSi+y/4yV8T4R3A==
X-CSE-MsgGUID: 8I44nzNlRe6Tc4p4KxnfXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="211839338"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.74]) ([10.125.109.74])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 09:39:22 -0800
Message-ID: <c198f1fa-5a42-42d9-a5f0-713ffbabd4ee@intel.com>
Date: Mon, 26 Jan 2026 10:39:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Add check for devm_kmalloc() and fix NULL pointer
 dereference in nd_pfn_probe() and nd_dax_probe()
To: Zhaoyang Yu <2426767509@qq.com>, dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gszhai@bjtu.edu.cn
References: <tencent_A06C2B14D0B5B3FEF2379914F5EF8AD61D07@qq.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <tencent_A06C2B14D0B5B3FEF2379914F5EF8AD61D07@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12870-lists,linux-nvdimm=lfdr.de];
	FREEMAIL_TO(0.00)[qq.com,intel.com];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,qq.com:email,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 9C5CA8B942
X-Rspamd-Action: no action



On 1/26/26 6:04 AM, Zhaoyang Yu wrote:
> The devm_kmalloc() function may return NULL when memory allocation fails.
> In nd_pfn_probe() and nd_dax_probe(), the return values of devm_kmalloc()
> are not checked. If pfn_sb is NULL, it will cause a NULL pointer
> dereference in the subsequent calls to nd_pfn_validate().
> 
> Additionally, if the allocation fails, the devices initialized by
> nd_pfn_devinit() or nd_dax_devinit() are not properly released, leading
> to memory leaks.
> 
> Fix this by checking the return value of devm_kmalloc() in both functions.
> If the allocation fails, use put_device() to release the initialized device
> and return -ENOMEM.
> 
> Signed-off-by: Zhaoyang Yu <2426767509@qq.com>

Please provide a Fixes tag. Otherwise LGTM.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/dax_devs.c | 4 ++++
>  drivers/nvdimm/pfn_devs.c | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index ba4c409ede65..aa51a9022d12 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -111,6 +111,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  			return -ENOMEM;
>  	}
>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	if (!pfn_sb) {
> +		put_device(dax_dev);
> +		return -ENOMEM;
> +	}
>  	nd_pfn = &nd_dax->nd_pfn;
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 42b172fc5576..6a69d8bfeb7c 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -635,6 +635,10 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
>  	if (!pfn_dev)
>  		return -ENOMEM;
>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	if (!pfn_sb) {
> +		put_device(pfn_dev);
> +		return -ENOMEM;
> +	}
>  	nd_pfn = to_nd_pfn(pfn_dev);
>  	nd_pfn->pfn_sb = pfn_sb;
>  	rc = nd_pfn_validate(nd_pfn, PFN_SIG);


