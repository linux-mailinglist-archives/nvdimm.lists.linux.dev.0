Return-Path: <nvdimm+bounces-14814-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6bY2KcYWUGp9tAIAu9opvQ
	(envelope-from <nvdimm+bounces-14814-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 23:46:46 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05ED4735E04
	for <lists+linux-nvdimm@lfdr.de>; Thu, 09 Jul 2026 23:46:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVKnh4K7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14814-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14814-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC9973018282
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 21:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321D93CE4B1;
	Thu,  9 Jul 2026 21:46:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C253C10AE
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 21:46:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783633604; cv=none; b=WQQwcXpA9yDB7G04NjUOthEA1Pe5SusX+cWzaQAG61zoDzck+LAwH2P/y6Pf1tzAyCW3cHHOEhyqeGl0rdWUmymv6SgcqK7gzQP80245EvhiheNktNMKpuchFUS3z5IaGoUKjJ9AfNsRGnqjNaLPu32PEePyCncnXRKg+Eo2cPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783633604; c=relaxed/simple;
	bh=+HUMhj2jNwddM2JyOEMYiYL+KJDhiLET5Lh+METKU8M=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=kwuQmv3T2G6Bsbg11R1mBhXuTgtDbp3Vs2aN7ayVzSWn9/R7Rd/W4SU8BX/pOPsbSst+7IVqir6oLzvqG/gazMRFbA+MXDtYUOm1BuOL2+fbNC5H3mTmIFOXQRnfpWTGmCuQ0l3LNfUHzxcfFtSYxj7JiEv8ZqFt1WW25h0N+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVKnh4K7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A0A1F000E9;
	Thu,  9 Jul 2026 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783633602;
	bh=xvUpE9WcYp8vTdTGEYoEnE1EtejEUIbK/UADepyuNY0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iVKnh4K7ybLEzV7Rvctk0w0CuSaR2MOl8/3BZm6M0v7bnOxOMambRqn1EKITgQWFW
	 7gN8gNVAyYGj33OEgKV/PPPabOSUCb8o0ss0+Zb0JTjZsPHKeFNvRksMG414Uk7K9s
	 QvUUCEqM4904/do3Y67NO0UxVFZStOFTkvaNIrkh0qSLpd7whmzIF/EGeOW7Fg+C3U
	 2bGg1fR0VVCOqSrw8UrQQgDWOICdQvgnCyxQXdOSDTvUxKsjfu3rqrUr4nlhrv6mkq
	 2f5l7HVJ/UpB3iw1O8LMn2HcQZpPtcFOVzw6KQAnzZMN6RSP/dgSFESeZy9RalaJYM
	 d4sYXgeSH+RWw==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 36203F40074;
	Thu,  9 Jul 2026 17:46:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 09 Jul 2026 17:46:41 -0400
X-ME-Sender: <xms:wRZQatvFWtrTwr1EjET3SY_trkFv5ByXFvxwuRdoxp5nZNvdH5owQg>
    <xme:wRZQamngVETnvwD8NBa-XtvQpVx4724Zay6MVM63n_6ymuey3wfOgySL08LLsooog
    UX-chX-4R6sELh15ZgWdlWqPRhtWCNR2SS_SccjFUcsJISlBQW0Jg>
X-ME-Received: <xmr:wRZQaulAZEPtxDDKpaH_YbkptlPFAMbWXlA7EE85RV-Ons1W6zy6jsk9pC4kEn3uk7t8zBNGPLJp6Q5UyrA4U-G2iQ6f_GlG3-g>
X-ME-Proxy-Cause: dmFkZTE6pGaGaXtiuJOhuGCWlZoBx9j2X3a8VM6fEMYo0GgLn9Toq0lK5LM0v7iRTsbBsV
    qlrEvEtCLS1HyECWCw3IhgieUQHf/LHM2k0r319GerFiWVnYyf1YK+sX/8GKpHbeEDkqtn
    HDG3mhPN5PblOtwUozJ//wR1tQjsfmPDOvoxX5Te1glFqzecABmTR2Zh8nu80wxuLaB9Zq
    2zHMg9W+crhZwO/iasCAkbhbQkiZL/DfjYQadxfklfe3HABtE+ynOGyGbRkgDasbfKe5xO
    VfWC4UbTVVlwtY8KKGNtYMIYw9XkDx/17fWR9Y/a3y7cL3gnrzhViVaOvAGjNANzJ0ugdZ
    5PhTVw9Ns0QhhLKD1lQlPKK1qDIBABInureQW4ET1HapHww8srucCfs+rrvwAVPVpc1PfA
    HYIcCN+U+A5av5qS7mt9cziBggX16xCsoo8ISOQX2m5s/bLHlIFqjSrysZbJ3A8UTjLlcH
    L3uk/yJObKMM5E62Z1vetG3TPwFWzYElHlH/N7CdygvxX0xaTfR0R+ijFpTgtO+dGDZyAd
    yJMUKn+V4nGoInZb4lgPPMBhn6Bw9ObzrTWFW1dVXsVErLJiF5Kp789djPKp0Plu417fRL
    ltx20K8SztGbd39K8VVdFQHFiete1nLG1dIxa8J8RKKm0TJR3JNksl1/9+3w
X-ME-Proxy: <xmx:wRZQaoc4wjzaNgvryg5NN70-1Vatf2xzep1RWYAbyMMVv1jU6GuGUw>
    <xmx:wRZQasIJCeYXn13SMsIuUbkJJctlWeYlyIgEnBRLtc4d-vVKYSLz2g>
    <xmx:wRZQaj5n-_r_R1jtCcxgv8VUDHEvYWm-UIKRMsfxYAmrfmcJ5P0Ibg>
    <xmx:wRZQarTPZpDwzCgul_GWo1SBKOdkWO7HWCqep__MKJzfdeGX2A3UtA>
    <xmx:wRZQajsp5WUuI2CXr6WdWNwkXcx1AADWI-zKxT0Fq1uz1hG6ukfLy3xS>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 17:46:40 -0400 (EDT)
Date: Thu, 09 Jul 2026 14:46:39 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, 
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
 djbw@kernel.org, 
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
 gourry@gourry.net, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com
Message-ID: <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
In-Reply-To: <20260630211842.2252800-8-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
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
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14814-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,s:lists@lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lists.linux.dev:from_smtp,djbw-dev.notmuch:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FORGED_SENDER(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 05ED4735E04

Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Capturing the system default would otherwise break the ABI, because
> the system default can change - but we would be statically assigning
> the value at device creation time.
> 
> To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> the current behavior, while providing a clean way to override it.
> 
> No behavioural change for existing callers (still the system default).

So I know you have some future usage for this ability, but it is not
present in this set. The only piece that *is* used is that the
online-type from the new sysfs interface gets plumbed through to
__add_memory_driver_managed().

Are these touches:

>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/hmem/hmem.c   |  1 +
>  drivers/dax/pmem.c        |  1 +

...premature until the first user arrives that with the background story
about how it knows to set the policy?

If DAX_ONLINE_DEFAULT is a sentinel for "default" should
DAX_KMEM_UNPLUGGED be a different sentinel than (-1)?

Feel free to add:

Reviewed-by: Dan Williams <djbw@kernel.org>

...to this and the previous patches when that is fixed up.

