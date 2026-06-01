Return-Path: <nvdimm+bounces-14261-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJiBFrUUHmrugwkAu9opvQ
	(envelope-from <nvdimm+bounces-14261-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 01:24:37 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F3E626527
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 01:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F9603025D15
	for <lists+linux-nvdimm@lfdr.de>; Mon,  1 Jun 2026 23:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4870364029;
	Mon,  1 Jun 2026 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PBgE/eqJ"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0734437F724
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780356267; cv=none; b=HCUJOy7TuBW8vAkpBwoYRZhrKy7QlCX+9YHBSFrUW//6Z25hOV4xVcTWCQsd1hvZ5nuh9LEKl1TlQtYV4djCdCb9BlVm6f1/CDUeCIZSl7Yswh8H5BejI59LJrOuswMpQOvfFAUif+yfMFEeoWLwdpQY5+NfmLg/QpIctKlNENo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780356267; c=relaxed/simple;
	bh=DfLQHO9ZEMPWPBpxjYs4hLwQre4GHwtiqeK4Tww/mv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/Q9kCAxKYAcN/Fdef2fbc7grZlxg/QTgi67LeQCfMlSKXYDFpxTWlBGs67lvnBgToRCU8q5luMCvBKO47lHHONENHUyYf/fhh/EdWYz3w/BJE9IzY2OTWNZ/U8w9BdAY8yjKUDdG46qSyZPKAbEk7fgcbGr16kA3qvikZaauGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PBgE/eqJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780356265; x=1811892265;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DfLQHO9ZEMPWPBpxjYs4hLwQre4GHwtiqeK4Tww/mv0=;
  b=PBgE/eqJgF2ypvE3rRlD9e54Qq41mclGQUl8fA6Zu7GXJmR1fMIS6oI3
   JgvnJYWMvD1gO45M0Y0qgoBR8t5A7XNuEVzbbnJOiUSkRcMR/KaMOM2+v
   VjE3G1NcSejXUSMkBTUFonDxatPzqgCnYarYk6qH23rf/RMtrLmd4d+jR
   P4Nf4FQ7kqaMt/8SI7STiPXqSBExkXc++TKjQG6wMaqtD7LyiK6LRaPUq
   niGTXWc4SUxvKawIlcYxA2AqW3G+4ryhY581KSiym44p4rpWw/uQdcr9B
   haGeU3Yl6DY0sPmbhUsm3DtrcdIpgo25Kd+5FOKGUWfcu2EjWrrSjtuUQ
   Q==;
X-CSE-ConnectionGUID: FKZ24cdrRzqldOKu2eW6KA==
X-CSE-MsgGUID: 7w4evfQvRdKz6L2nlKfNZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81026237"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="81026237"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:24:24 -0700
X-CSE-ConnectionGUID: g8uOSbJtTQyK+i2f3tMqwQ==
X-CSE-MsgGUID: qgmFUOBGQzCuG/+DUJ3SKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242680950"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 16:24:23 -0700
Message-ID: <39570927-b4f8-41e2-816b-e8a0a30abf2b@intel.com>
Date: Mon, 1 Jun 2026 16:24:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/9] dax/fsdev: use __va(phys) for kaddr in
 direct_access
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165100.6670-1-john@jagalactic.com>
 <0100019e79cbe087-d11f77a7-379f-4355-b65c-52b3090e9ddd-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cbe087-d11f77a7-379f-4355-b65c-52b3090e9ddd-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-14261-lists,linux-nvdimm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:mid,intel.com:dkim,groves.net:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: B0F3E626527
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/30/26 9:51 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Use __va(phys) instead of virt_addr + linear_offset for the kaddr
> return in __fsdev_dax_direct_access(). The previous code added a
> device-linear byte offset to virt_addr (which is __va of ranges[0]),
> but for multi-range devices with physical gaps between ranges, this
> linear arithmetic crosses the gap and produces a wrong kernel virtual
> address. Using __va(phys) where phys comes from dax_pgoff_to_phys()
> is correct for any range layout because the direct map translates
> each physical address independently.
> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

one comment below

> ---
>  drivers/dax/fsdev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 42aac7e952516..a2d2eb20fb4d0 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -51,9 +51,7 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	struct dev_dax *dev_dax = dax_get_private(dax_dev);
>  	size_t size = nr_pages << PAGE_SHIFT;
>  	size_t offset = pgoff << PAGE_SHIFT;
> -	void *virt_addr = dev_dax->virt_addr + offset;

With this change, there's no more dev_dax->virt_addr usage? Should that be removed?

DJ

>  	phys_addr_t phys;
> -	unsigned long local_pfn;
>  
>  	phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
>  	if (phys == -1) {
> @@ -63,11 +61,10 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	}
>  
>  	if (kaddr)
> -		*kaddr = virt_addr;
> +		*kaddr = __va(phys);
>  
> -	local_pfn = PHYS_PFN(phys);
>  	if (pfn)
> -		*pfn = local_pfn;
> +		*pfn = PHYS_PFN(phys);
>  
>  	/*
>  	 * Use cached_size which was computed at probe time. The size cannot


