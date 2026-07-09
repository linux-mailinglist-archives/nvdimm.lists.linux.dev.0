Return-Path: <nvdimm+bounces-14812-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id en6pNLQOUGrasgIAu9opvQ
	(envelope-from <nvdimm+bounces-14812-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 23:12:20 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BB8735C51
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 23:12:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=EIBeEhe0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14812-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14812-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 689293046C0D
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 21:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DACA3AE6E9;
	Thu,  9 Jul 2026 21:08:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44643A2549;
	Thu,  9 Jul 2026 21:08:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783631329; cv=none; b=ftyIfXugqJL8RKtoFQgCWpSCo+V8Pj8OjfC1RddsFiNc3t14Hn15cSLzlSg0Yv5nLIrG3plhObIMnfrTDTgAg+XzYDeXgYVhOASdXCc5X+sKr6B+b9/Ak5tDqLUWtbKnLpWaZ28sZLksCqaII+VR1ysR2aRxOw/IIdZ6HPLWW/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783631329; c=relaxed/simple;
	bh=3SV4lrq6dVZ9n9ZqVkK5eNZjHSMb6uBLOemepmuqFw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y32OCyY056Ggd5UEv+f16YOFBT8lVzB0Q3kE7/Nyg0jheG6kLCWn+zLdI94a3vaLuoq66DKY52sAJ5/s31d0aLMkc5R8ajx0DPto0mF9XmvPt/R2P7bYuXIVA47dPxbBK+6SN9hhSBFF9xSzTSRZFGB1QAev9hqulDb6lUWVyR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EIBeEhe0; arc=none smtp.client-ip=192.198.163.16
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783631328; x=1815167328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3SV4lrq6dVZ9n9ZqVkK5eNZjHSMb6uBLOemepmuqFw8=;
  b=EIBeEhe05c7TSEqbusDY7RMFOTuk3VT1hccoPBr3WCkoeJLpBPWMD7F8
   0uMzknyzuNuqu0H4gKOFNO1kvPwflFsQFy1VJ1qpoiwEw4/MIyfVeaZ1O
   c2SN1Xi1ZAgYm4a+JKi4gQMlwFFkUTzxy/M7hL4A6t47hkaHbir9oXuxE
   gt2keI0tEFRbwjVkN0aZcn745RDjZvITqgOVwFMsGwWzqfQuZl9opYk+y
   OIu/mDducrOZz7Ao1GedbWXVUJrYKIMEY+V51c1mK5p5cbsiUp5plDuLd
   lgCl38ibbnWc8LlnJ+aKfQk9d+b5EJXyw/jKUB69JS9r3wN03Y68Uvikv
   w==;
X-CSE-ConnectionGUID: 12QZvM6CRXuQTNMfamdpGw==
X-CSE-MsgGUID: Zg7WUa74ST2osGNlEdxWFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71854506"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71854506"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:08:47 -0700
X-CSE-ConnectionGUID: tylC+NrwTFaXq228GvGp9Q==
X-CSE-MsgGUID: XmQDIsM8ScqT30l8CVHh2g==
X-ExtLoop1: 1
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:08:44 -0700
Message-ID: <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
Date: Thu, 9 Jul 2026 14:08:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14812-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:from_smtp,gourry.net:email,intel.com:from_mime,intel.com:dkim,intel.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 31BB8735C51



On 6/30/26 2:18 PM, Gregory Price wrote:
> Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
> and export both so a driver can render and parse the memory online type
> through its own sysfs interface.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  drivers/base/memory.c          | 9 +++++++++
>  include/linux/memory_hotplug.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index b318344426fa..3a2f69d3af7b 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
>  	}
>  	return -EINVAL;
>  }
> +EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
> +
> +const char *mhp_online_type_to_str(int online_type)
> +{
> +	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
> +		return NULL;
> +	return online_type_to_str[online_type];
> +}
> +EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
>  
>  #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
>  
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7c9d66729c60..5d4b628c4a1f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
>  extern u64 max_mem_size;
>  
>  extern int mhp_online_type_from_str(const char *str);
> +const char *mhp_online_type_to_str(int online_type);

Does this need to also be 'extern'?

DJ

>  
>  /* If movable_node boot option specified */
>  extern bool movable_node_enabled;


