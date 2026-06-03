Return-Path: <nvdimm+bounces-14304-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0s9JGdqrIGop6gAAu9opvQ
	(envelope-from <nvdimm+bounces-14304-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 04 Jun 2026 00:34:02 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CE60763B9B4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 04 Jun 2026 00:34:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=MTWx7lia;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14304-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14304-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F3C03040DAC
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Jun 2026 22:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0014D8DBB;
	Wed,  3 Jun 2026 22:33:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015544A1395
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 22:33:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780526024; cv=none; b=c39w97CmX3UMI2O6NbFC5s7HobjiLX8VG6xL8B8Gij1a/LPR9eC50a82aHPUSdd/CiCR1eaFOvMXLd/lwjNgzyECF9Ya/Z7x7H8lmX9Xxes0PuIzxn3j+2rFfxKVmWrvdUQmr1QZhP+Jln7bATnPqH01nG9awdeKBnua1wWt8H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780526024; c=relaxed/simple;
	bh=lq9rb8PQRol3H/21t01viHr+r3b/JLoK/P8J0muQN9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iWKDHEs71AssGKwisiAAQlZO2wraBvcJ3eUGaJsL6BNxkOLxYUYbC0DeIaX+BaxI2BQJ7y6fnfmRRUp91RJ3qG3nn2hq12GA1y1ehsP1QRJogFOigo4YS4zH4itSc9/8HZ0VWjBpaa3aypu40Z7RkqjEbspuWHoAFSgjBPSMNRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MTWx7lia; arc=none smtp.client-ip=192.198.163.15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780526022; x=1812062022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lq9rb8PQRol3H/21t01viHr+r3b/JLoK/P8J0muQN9E=;
  b=MTWx7liaqRimDyq/yrkBILED+rVmP8F5YsEyymF2rQtlCaCqNxA7euUY
   sH/X7S+DnhFZxIsd3029J3f3ssllEvHXEuK/6lBsDm1QbLRCv7pghY7Oc
   UuTnnGRWi8GO6sZZ1blOHOpcmI12TtRyy7U4RTgugnJaOAzl1Q6/OQED3
   DvN4c0KcqNcRuHKLKFH+fEuRDZygzr9LbhSiZlq3klh4642dLgmu5NBwI
   zfaHxgB/qp4y8RSxzXIa/tePIQNlUkBv6Dypgjp6E25vhzRNivZQxKc1+
   NmShumSJbuJeCL8gkc7RrBenEoA5htz19/umAryJoJbsYUbspe6YjiO27
   g==;
X-CSE-ConnectionGUID: nuPzxLPZQSOatOi/fx8pwA==
X-CSE-MsgGUID: ovkMghOiTByTOgY8fn/AIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="81475582"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="81475582"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 15:33:41 -0700
X-CSE-ConnectionGUID: ZZryN3C3R3Kl8hb6uutvqw==
X-CSE-MsgGUID: eOEXuPvqQDyqTfI5qOtdYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="244217143"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.116]) ([10.125.108.116])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 15:33:40 -0700
Message-ID: <db30a3cb-6d67-4b96-aeb7-04275985cc60@intel.com>
Date: Wed, 3 Jun 2026 15:33:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ACPI: NFIT: core: Fix possible NULL pointer
 dereference
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
 <2418508.ElGaqSPkdT@rafael.j.wysocki>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <2418508.ElGaqSPkdT@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14304-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:rafael@kernel.org,m:linux-acpi@vger.kernel.org,m:djbw@kernel.org,m:linux-kernel@vger.kernel.org,m:vishal.l.verma@intel.com,m:nvdimm@lists.linux.dev,m:alison.schofield@intel.com,m:chenxiang66@hisilicon.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:from_mime,intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CE60763B9B4



On 6/3/26 10:56 AM, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
> getting NFIT table"), acpi_nfit_probe() installs an ACPI notify handler
> for the NFIT device before checking the presence of the NFIT table.  If
> that table is not there, 0 is returned without allocating the acpi_desc
> object and setting the driver data pointer of the NFIT device.  If the
> platform firmware triggers an NFIT_NOTIFY_UC_MEMORY_ERROR notification
> on the NFIT device at that point, acpi_nfit_uc_error_notify() will
> dereference a NULL pointer.
> 
> Prevent that from occurring by adding an acpi_desc check against NULL
> to acpi_nfit_uc_error_notify().
> 
> Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: All applicable <stable@vger.kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/acpi/nfit/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 5cab62f618c8..8024cd3cad14 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3442,6 +3442,9 @@ static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
>  {
>  	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
>  
> +	if (!acpi_desc)
> +		return;
> +
>  	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
>  		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
>  	else


