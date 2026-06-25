Return-Path: <nvdimm+bounces-14537-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NR2zGj3cPGrqtQgAu9opvQ
	(envelope-from <nvdimm+bounces-14537-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 09:43:57 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD28D6C3755
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 09:43:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNY0gmJI;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14537-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14537-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 730DE307B35D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 07:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C37D3A9014;
	Thu, 25 Jun 2026 07:40:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDEB3815ED;
	Thu, 25 Jun 2026 07:40:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782373213; cv=none; b=tsVTWkbyzYubbvTxujdbm5JYkFlaa8IXdq0Juz3rhCK3ZK8ieHczjwm5lnRp/ccFMy6sRcFY+yep3E63AX5DfmNcdF9PSa6BgliePE98zSM0H8yznEF3EhaBnaZ3ZG24+GiHBHKJIyAAuBu8dm0q8rCcEjr5VzwjjFZy9IjMHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782373213; c=relaxed/simple;
	bh=wLp3MaGuBaurQfyTF7tq7PviXwXQ+F8xCjPM7/OW12s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nazyw8nMIVeYlRG2dPAM26TAxPt0TDTAWjKeEI8ZbzplwD8ObGj0DpdikYPDgGmIuf24aV3npMr/+u4YLigPe3qZHg7WLTD3nKvez0ndXqOQZ9iXebeaYEbD1xRqabZPAiiVLDcVdiWjXPgSDvZWrBo/bZG1icLvq2gwvbFATsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNY0gmJI; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E00A1F00A3A;
	Thu, 25 Jun 2026 07:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373211;
	bh=D0yxXYlC+6ZzOInCXh8esiMObDCmFa28JgIqXqu60pE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNY0gmJIRd8aAsNgBLSo9uATdut1LoqElrTqsbgNwRX34c4pz0dA2LXltTCm5J2jd
	 GCKHbC/0HGMiLrrlgZ7sJgoYk/hvOlx2FQsSzSGbHdvEvi2Y6fHGEOv+6errkLxuyN
	 FEG4hWpDHHl+2/TbXpxcGR+W7rPBRxmUm7UluzvbnL7Pv9Fc+0i8btgnVJEZnCPSTT
	 oXx/29zepKkQnx7lLBxYJuk4hVstAm3j549aahwWIoI7j+zXF7pE6/py3rP9S4IaX/
	 hYNwq2jhob3kh6PbUWCnnIc6d0oNUzlfu7kXxyZ4x5BAf9EGrZ6nJLQ+SU/c15xN9o
	 IVgh763KB88WQ==
Message-ID: <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>
Date: Thu, 25 Jun 2026 09:40:02 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260624145744.3532049-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14537-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:alison.schofield@intel.com,m:Smita.KoralahalliChannabasappa@amd.com,m:ira.weiny@intel.com,m:apopple@nvidia.com,m:hare@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[david@kernel.org,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[28];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CD28D6C3755

On 6/24/26 16:57, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>     1. offline all
>     2. remove all).
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>   - [offline, online, online_kernel, online_movable]
>   - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>   - "unplugged":      memory blocks are not present
>   - "online":         memory is online, zone chosen by the kernel
>   - "online_kernel":  memory is online in ZONE_NORMAL
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged                -> online[_kernel|_movable]
>   - online[_kernel|_movable] -> unplugged
>   - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>   An offline dax device memory is removed on unbind as before.
> 
>   If online at unbind, the resources are leaked (as before), but now
>   we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>  drivers/base/memory.c                   |   9 +

Can we have this ...

>  drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
>  include/linux/memory_hotplug.h          |   1 +
> 

... and this as a separate patch, please?

Nothing else jumped at me.

-- 
Cheers,

David

