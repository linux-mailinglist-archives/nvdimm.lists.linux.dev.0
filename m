Return-Path: <nvdimm+bounces-14720-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vylqHJCwRGoyzAoAu9opvQ
	(envelope-from <nvdimm+bounces-14720-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 01 Jul 2026 08:15:44 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C72956EA257
	for <lists+linux-nvdimm@lfdr.de>; Wed, 01 Jul 2026 08:15:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nVkPquKq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgLbW7hT;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14720-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14720-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A6633022F4E
	for <lists+linux-nvdimm@lfdr.de>; Wed,  1 Jul 2026 06:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854B1376481;
	Wed,  1 Jul 2026 06:13:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88437FF7B
	for <nvdimm@lists.linux.dev>; Wed,  1 Jul 2026 06:13:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782886412; cv=none; b=Xj8vFJYc1hOGckzp3m6V6bLOAsHNyT6g/ncfKSYyspB2lzPqrpu7THuHxDX2JRv6pN7upy4U+WmZ99f9zp6YMPEtfFalpNFu6dnU0osr7RJedTALypj2MOaNuqREkcMNOA1hKzChbGnMBG6TUTK88HXg+uM56KI4gurn9bTJJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782886412; c=relaxed/simple;
	bh=5IugnX6ei1qX95xqi+Dab5Sz2YMHXwt1aK+XcCyrIao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRMWh3OpAYCDaQsKVA3GuZirqidCSWnDy7O77vHKv+e9okv2TaKA+0nkLq9R5/nsbSHZ7S7TS2EXR/YEO1L1yRMjcDM7bTCxqRC2U6ERMK1zEFsKgSfEu19FdXBoBIDmp9EB95pv9Ne3BxVAxqeA3dpxFF77ESYcfpI1sDv0abA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVkPquKq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IgLbW7hT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVkPquKq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IgLbW7hT; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 386CC75FA2;
	Wed,  1 Jul 2026 06:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88874779AA;
	Wed,  1 Jul 2026 06:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9virHwiwRGoNTQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 01 Jul 2026 06:13:28 +0000
Message-ID: <abde41f0-7d40-42ba-a232-cc0538cd0e4b@suse.de>
Date: Wed, 1 Jul 2026 08:13:28 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, alison.schofield@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14720-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[28];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[hare@suse.de,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[suse.de:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hare@suse.de,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp,suse.de:dkim,suse.de:email,suse.de:mid,suse.de:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C72956EA257

On 7/1/26 12:14 AM, Gregory Price wrote:
> On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
>> There is no atomic mechanism to offline and remove an entire
>> multi-block DAX kmem device.  This is presently done in two steps:
> 
> ... snip snip snip ...
> 
> Sashiko pointed out a false-positive, but adding a fixup patch
> here that adds additional consistency.
> 
> On total failure - release all resources.  This makes the sysfs
> interface consistent with the probe failure path.
> 

Speaking of which ...
With this patch we now have _two_ interfaces to do the same thing.
And both will be generating uevents.
Which is far from ideal (one could easily envision _conflicting_
udev rules, one set doing an 'online' on the old interface,
and another set doing an 'offline' on the new interface...)
Is there a way to not sending uevents for the old interface
or to make it configurable?
The old interface had the nasty side effect of generating
_tons_ of uevents during booting, and on larger machines we
even had seen udev acting as a fork-bomb during booting,
taking down the entire machine (we had to restrict udev
to 512 threads max to avoid that from happening).
So if we could disable uevents for the old interface
things would be _so_ much easier ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

