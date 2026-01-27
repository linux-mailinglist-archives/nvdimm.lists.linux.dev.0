Return-Path: <nvdimm+bounces-12909-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMExFMcueWlOvwEAu9opvQ
	(envelope-from <nvdimm+bounces-12909-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 22:31:51 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 919119AB6F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 22:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECAB23019F0C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 21:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61BF285C9F;
	Tue, 27 Jan 2026 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMX008b9"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DA22129B;
	Tue, 27 Jan 2026 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769549503; cv=none; b=UKWH9Ex8ik6S22C2BM8lA/cGWHYZhm9c5p59cgeNSrW+5seOLypC0rp0WMmwnp8jet8cn903Fx+LbNGzt5EwWAwm/OAfW4MWCmFjAoJ+FD/RvWseTsOUGkZLtMrfycSeti7Vd50O8y1pJ9omWtgvWxtTIJHEAUT/OkAyAPggWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769549503; c=relaxed/simple;
	bh=lAGlrUrQZRj2Ye7WvWgIO3rlnqhph8gyR5+gVz8PIAg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=at78dUbQb1OgRd+kz2Yf0i3wmWjFsXoyK0kIsDSB5kPddzqGiTpF/tGPLaCEBzArWSbrOT70Ul1BwG+516Cxv8UoZBT8ES6gZH6n6iSCTjNnc7CpNMysPQCzQSBQTN7Qa30A7XLeyeQ3Du1HyGnoBB7tUpQG1Gc794lp7UkfdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMX008b9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB09C116C6;
	Tue, 27 Jan 2026 21:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769549502;
	bh=lAGlrUrQZRj2Ye7WvWgIO3rlnqhph8gyR5+gVz8PIAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fMX008b9lw+lbMqmbQE4akntt0GM/CYCqEfsQlRN5xZOuTFbgIuiPOZ7SpC5nWCII
	 4e6HQxyvFYex00qHzi1FBCgLioZLzus1wJM2kZ7Bxmhz80iHDXUb0USzNGgfcQHLDD
	 BuJ1VJ2BqPH7YpsXYabWuD+/1/XKE6evKQK0+X6Y=
Date: Tue, 27 Jan 2026 13:31:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, david@kernel.org, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 osalvador@suse.de, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/5] dax/kmem: add sysfs interface for runtime
 hotplug state control
Message-Id: <20260127133141.5f7aa3cd01f4eee4055f075f@linux-foundation.org>
In-Reply-To: <20260114235022.3437787-5-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
	<20260114235022.3437787-5-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux-foundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12909-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux-foundation.org:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[akpm@linux-foundation.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux-foundation.org:mid,linux-foundation.org:dkim,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gourry.net:email]
X-Rspamd-Queue-Id: 919119AB6F
X-Rspamd-Action: no action

On Wed, 14 Jan 2026 18:50:20 -0500 Gregory Price <gourry@gourry.net> wrote:

> The dax kmem driver currently onlines memory automatically during
> probe using the system's default online policy but provides no way
> to control or query the entire region state at runtime.
> 
> There is no atomic to offline and remove memory blocks together.
> 
> Add a new 'hotplug' sysfs attribute that allows userspace to control
> and query the entire memory region state.
> 
> The interface supports the following states:
>   - "unplug": memory is offline and blocks are not present
>   - "online": memory is online as normal system RAM
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged -> online
>   - unplugged -> online_movable
>   - online    -> unplugged
>   - online_movable -> unplugged
> 
> "offline" (memory blocks exist but are offline by default) is not
> supported because it's functionally equivalent to "unplugged" and
> entices races between offlining and unplugging.
> 
> The initial state after probe uses mhp_get_default_online_type() to
> preserve backwards compatibility - existing systems with auto-online
> policies will continue to work as before.
> 
> As with any hot-remove mechanism, the removal can fail and if rollback
> fails the system can be left in an inconsistent state.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED.
> 
>   The resources are still leaked but this prevents deadlock on unbind
>   if a memory region happens to be impossible to hotremove.
> 
> ...
>
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -151,3 +151,20 @@ Description:
>  		memmap_on_memory parameter for memory_hotplug. This is
>  		typically set on the kernel command line -
>  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> +
> +What:		/sys/bus/dax/devices/daxX.Y/hotplug
> +Date:		January, 2026
> +KernelVersion:	v6.21
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Controls what hotplug state of the memory region.

s/what// ?

Maybe "Controls hotplug state of a dax memory region".

> +		Applies to all memory blocks associated with the device.
> +		Only applies to dax_kmem devices.
> +
> +                States: [unplugged, online, online_movable]
> +                Arguments:
> +		  "unplug": memory is offline and blocks are not present
> +		  "online": memory is online as normal system RAM
> +		  "online_movable": memory is online in ZONE_MOVABLE
> +

This is perhaps a little brief?  Is there more we can tell users about
what this is and how it behaves and why they might want to use it?

