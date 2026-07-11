Return-Path: <nvdimm+bounces-14893-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id nShQNxSSUWpDGQMAu9opvQ
	(envelope-from <nvdimm+bounces-14893-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 11 Jul 2026 02:45:08 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B09873FDAF
	for <lists+linux-nvdimm@lfdr.de>; Sat, 11 Jul 2026 02:45:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTpii3ZT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14893-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14893-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 55DAE302ADBB
	for <lists+linux-nvdimm@lfdr.de>; Sat, 11 Jul 2026 00:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF001A238F;
	Sat, 11 Jul 2026 00:45:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6331DED5C
	for <nvdimm@lists.linux.dev>; Sat, 11 Jul 2026 00:45:02 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783730703; cv=none; b=ux5LHY5RNH19ahocCNzkSKzVBrkyjKgVYukTISEeU30Wp/ZvkUH8rXmb8hmn4125G7cKENw9bzSNUV6ln7OiIYTvu2MAdfZ/EvaRB2GprOIXe4nug/UMDYYRFNk80Qpa3gXX3hR60R0DJidvNurVaQJrC2YnJH5BRpQ0KUSgFn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783730703; c=relaxed/simple;
	bh=GRGathIQPJDGY81vbSSFInPKSN8SwR8AZqBYKQchyi8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=vBoSd04bPKB0acc+YTe0MwJtf0rvCpNWnJJkOF2MYfVtEkmlABm96MqCPGe+3mhfkRJqtWZbu9LWBIgPWEU2cAN5+C2CSMuywTsXk30uCNGNu6VpZQ2YLTtWLwnXWgxmkm54jzXR3XTT/ASnnY+uJKjNTEmqGB0dqliVZw4vBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTpii3ZT; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB4D1F00A3A;
	Sat, 11 Jul 2026 00:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783730702;
	bh=KIlT+GTV4WhhrNy4N/2keFT3wGvoTbsHteN+Z3WZskc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=UTpii3ZTDjIqVdqCN3Y7JfG8857lWe/8ShEDy/EdfU3y/XMnyR+G1cxIkOL4O+39U
	 DhJyWR41oHjppG+ui0PPQ4f06lLHkzHP5JETmOobXocWuKLRdZ4XRZ2qM01xe6gGFs
	 TUOBaN/2ZcbgNJ7OdTpd0LDccKTM0pD+uMugDiJmAe5wcEll+CVo8U4xyouB4gbKXR
	 LJGPccgGwIoMJGU0hcB8CCrfZ/9m3pF5ef46DuTkdn57vH6bhuljSDDgkXng5mlRaX
	 cqnDsFAKwQajYYT3g8dp1yzEmqxojWvcOBpnPKAKnfVnZVBkblRry+ZIqYqzfiM3al
	 OyKh72u6/dtUA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C3820F40213;
	Fri, 10 Jul 2026 20:45:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 10 Jul 2026 20:45:00 -0400
X-ME-Sender: <xms:DJJRahdIAQytT5U6Nr9NADrFKI5X32Ef6eIeXrnSsVS-uAfPEHNo5g>
    <xme:DJJRaoZlNfqciEJoJGQHyC_74CCjXfgmfHMQpSVehkbOSM9vXB3PzU1_ELaXWb8sN
    GK26JE0CYKmXxGmjRMt60VU5-M3aMuPIaMO-HagBlwHpJ6hsCEJkQ>
X-ME-Received: <xmr:DJJRakp_KEuh8p92LpbvK9AG7ALSylMrpwmSY3OqkrCToAG4Er5h-j40BPWEdh-OqqigdjJDXJifaCilJGOAeezcPxJiGZR5B9E>
X-ME-Proxy-Cause: dmFkZTF2lv/BTmJtmx58UCBnX4LYuS/hSPolWJtMhIC6n0miZhX4RDMWuAT1Cl4GARjHte
    lqEr6OARdwjx3wovv+JqFFm48+pvz4Zx4EQgeWrHiwpat62fKOUYIDPSrStJXAVJdwqAxx
    1VEqZJrIf0stTWrfvXtzf0i7jWSJNy8uf/jMXDtx7Ywygxat1p6MeXmPc0lsZiFUkLa3sn
    qa6w0Xk6djDcgTGYwGlBlj0VErXEEYhYZKCiUyzXOxRQ/T3BtU3+nzlNyVrmTVdMzrm/96
    wcvb3aTmxG5/VfGOD77r/GAytqa5b3EPaQD9Vf4C29SbV+quV+TOBZUtmCKPnndUNJDSRZ
    +ToTW+SzNgQPekcbdtuVHSCZJfTWEvui+ohy6FWXQGTH1WxWfOkyT5SfiV0QmnNv9YTVyW
    Az3C/jQXQ4aeolLcpVA+KSPE8sQ/+V81F48UYQyA6+hB3F5Tcft4haEs5wdocS7yCVLRmM
    eSiI1bmkYAGgHgFPZbPfSjjX7xTDURKGauaHAqJAUKmeWcQOaIbRLhfpOBpXDtRQUr4SiG
    51D5Yz83d+midz8y+A0C1ngj1l5eqsImNnder4kQrBTBEBTa0W2jRC0Bk7wTpgyAL8NADc
    UEb/7ghPKpmuk6TFsfN4MhANBLmxJZlqzMh+KiUGp/hqzMkKRBDuput0FGOQ
X-ME-Proxy: <xmx:DJJRar0B9iN8wAOFCHuPaFQbJb8V8saeOyXydt1pXldNWq5erw9Yaw>
    <xmx:DJJRapp1RbqjinFk8me3sngyUaRw2_y5e6QtzTp_k_cSm22LLuphaA>
    <xmx:DJJRalTyfinINTP6H7IfX-AARPsLe8FiwAF8iHR8kaKh6oW9h24D0g>
    <xmx:DJJRapoNmiKSZjaNy8ogBdajJy32RFp9tqhPPoJ7V2wugW-DP9cCoQ>
    <xmx:DJJRarwG0Kc32_-9CRKv0pWv_Eu4zCEifedKZPHpwBNqYnreLAv8agHk>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jul 2026 20:44:59 -0400 (EDT)
Date: Fri, 10 Jul 2026 17:44:58 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com
Message-ID: <6a51920acece6_35cf3310061@djbw-dev.notmuch>
In-Reply-To: <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14893-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:djbw@kernel.org,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FORGED_SENDER(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4B09873FDAF

Gregory Price wrote:
> On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > 
> > This was more a matter of having the DEFAULT set consistently across
> > the dax driver variant probe() functions to make the behavior explicit.
> > I didn't want an un-set value bug to creep in here somehow.
> > 
> > Happy to drop them if you think that's unneeded.
> > 
> 
> Ah
> 
> Not setting the value in each of those places is equivalent to setting
> MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> 
> So unless you have strong feelings i will keep them as-is.

Right, the mild feelings are only coming from the changelog mismatch
which says "Oh no, device-dax drivers can not specify their online type
besides the default" and all this series does is keep the status quo.

That can be had by just having unconditional:

     online_type = mhp_get_default_online_type();

...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
first user arrives. If you are respinning the series and that patch
drops, yay. If not, oh well.

