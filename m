Return-Path: <nvdimm+bounces-14165-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LdpKDg9F2qg9wcAu9opvQ
	(envelope-from <nvdimm+bounces-14165-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 20:51:36 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2825E93B8
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 20:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5ECC03022928
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 18:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9F92FD7BE;
	Wed, 27 May 2026 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhp84lBy"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804E1A262D
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779907876; cv=none; b=qHV0T3BiBfVFdogTaGhHln8z9amWwOsJWNG7XEgLVH4NYx5kMjXZqHub+qNZzfrph6obTmcKj6oiXi8M4v1Zm+PWHV23mZV6QuoYpzQt0ZqLX2UXNUlWYX8/+P/9RfN2fikvyVLtHQFjamzO3oxT7PYA24pt9yqeRonxygkmk5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779907876; c=relaxed/simple;
	bh=Fp7JCvfOR4okNHQ6mgssZJpR83qnUXn7+A9aV6bedNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDaF5b3R87kF25Ypp0qSeZwJLK6cbyYzDqgvuC9R015uSFJQdge1BKjBJXfIU6NrPN6Tsbv00O10LH/VrGTxIPEKBzMj7yUzBcS96dKnZIOWGVsjDCcmXCWeUdQzBakpkNCthZABfJ6rskh/Y75oRwSYH9PEKv/i0v3YgAdPx9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhp84lBy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779907876; x=1811443876;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fp7JCvfOR4okNHQ6mgssZJpR83qnUXn7+A9aV6bedNk=;
  b=dhp84lByp6OzTk8BnLn1h60YOXWfcXSUKpaZFqo2bdsbboqyxEVveQTe
   FC405oENNqaif+Do+f9DMajQ4XoDDsoMWeR2iaETPxjARN8j5zdqVJx1O
   0HyQXwaIMfQCD8N60qU8FF4ThfNTKFUyGFLVoBfp90XN4iPLlV5f+iy2H
   9iZ9z1XuMoGzeMsIu31R2l+HHPHnoFKYmXza1eOvu6o4DUU3BkwUCYeol
   ODzmo3wpTMQmljx1wnXOPlx6EOrhi86r8P2H/sz3ViaKfUORRRlabxbIJ
   D4GTWBRdhAxHGXi93F6FwdXo562wrgYYwSMzc9t1v8JF5rfdAC7dPXmo8
   g==;
X-CSE-ConnectionGUID: GLWfOODXRWashyEdcUFmGA==
X-CSE-MsgGUID: 5Nl+MGsgQlWHGc5NSRt7kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="92224144"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="92224144"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:51:15 -0700
X-CSE-ConnectionGUID: 6PIoLYNASYa3PymA/c08AQ==
X-CSE-MsgGUID: ordUriqiS6OcnJ2lxzoJuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247272949"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 11:51:15 -0700
Message-ID: <3b1b2486-d09e-4bfe-8c64-224df8048d44@intel.com>
Date: Wed, 27 May 2026 11:51:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14165-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 1E2825E93B8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/23/26 2:42 AM, Anisa Su wrote:

<-- snip -->

> Series Info
>   =============
>   The series builds on top of cxl-next with the famfs-v9 patchset
>   applied.

Hi Anisa,
Just for future reference, I would prefer that you base off of latest Linus tags for future patch submissions. i.e. for this week it should be v7.1-rc5. I would prefer that it does not base on cxl/next unless instructed otherwise. Thankfully this series applies cleanly to v7.1-rc5 so it's not a concern. Thanks!

DJ



