Return-Path: <nvdimm+bounces-14342-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5BQ9N302J2qLtQIAu9opvQ
	(envelope-from <nvdimm+bounces-14342-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 08 Jun 2026 23:39:09 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4095665AB49
	for <lists+linux-nvdimm@lfdr.de>; Mon, 08 Jun 2026 23:39:09 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=cQUPy+Un;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14342-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14342-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD0FE302633F
	for <lists+linux-nvdimm@lfdr.de>; Mon,  8 Jun 2026 21:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6DC3A6F0B;
	Mon,  8 Jun 2026 21:39:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A633A1695
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 21:39:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954746; cv=none; b=ecSYyTMnIbcwWNVG1kqIEnCsrp7xlmiu+57bXIBjq1Tk+jBM9wmGkcUZsktDzR/rotMiJcysmekGintbUZrnPSSZCh9vMGwngrxIfHKgl8g3WkF21V4WBgFf3oFp8RZR2chgOu9TVamxyxwjpUUgIbcIBSJmhMZN9bbb0uZb4PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954746; c=relaxed/simple;
	bh=fY5IWLEy1I6c8Z7Uz1QiZcbXgAx7FjqH5ElMe0zIaX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGMci5o3q/3ugw9W0Qgr3PyJb6wfsO9DBcPfRAds9SXPKGHkJWfMPVfhsgYzTKDuSVq/CkvhnS5s5mFIrtzpDFDhLX4duwKn/2R8hAKqQkOnfly9soWrcQwzmRTQsZpSqBuNGaTbsgY9HT4bj21WVuJQuJmqggRNQ9ANjeRoFi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQUPy+Un; arc=none smtp.client-ip=192.198.163.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780954745; x=1812490745;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fY5IWLEy1I6c8Z7Uz1QiZcbXgAx7FjqH5ElMe0zIaX4=;
  b=cQUPy+UnP6UcqiXTUwMWF+JKxfQGDN3qmFx845z45tUS17b8mfEK9FL5
   LigU0ca2+C2SeOlEyIhbddt2D9oUR37D+vSySNvlfK9kAeXp04OUbjPtb
   HfPCP9kyfOAJUxhJykH+fMPZWACaQmea/jItTro9AdhmvKGDYZuYGjMc7
   D868L0JdfM6YY+Q0A1KsUhG/I6eHcuoEjN4XWMotw4wdJuGym6IxC9nBG
   jCiczDPjkhWlo01F5lLNR76Sn0tIdiqrabLgTfmwEnmIYbE4Llw9GJPSV
   CR9Peiy+CCztftSGJaim9Z5RzfmTL1UarC40/2OLy4UfNYumpffflpENN
   g==;
X-CSE-ConnectionGUID: agfVm6qgQgyms0TOPp1+KA==
X-CSE-MsgGUID: Y220sZ5vRsajxFZ4Oa46zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="107142943"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="107142943"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:39:04 -0700
X-CSE-ConnectionGUID: DzbcaY8/T2Su6l8SURZbCg==
X-CSE-MsgGUID: Pjj7yoHhRCCOGc1lYxt7Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="242721937"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 14:39:02 -0700
Message-ID: <bf0d88bd-a514-499d-a81f-24f4e0c7c186@intel.com>
Date: Mon, 8 Jun 2026 14:39:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 6/9] dax/fsdev: fail probe on invalid pgmap offset
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
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193354.94372-1-john@jagalactic.com>
 <0100019ea393f2e0-98d65e1f-5656-4e44-afa4-f9836ab6dd40-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019ea393f2e0-98d65e1f-5656-4e44-afa4-f9836ab6dd40-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14342-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:john@jagalactic.com,m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lists.linux.dev:from_smtp,groves.net:email,intel.com:dkim,intel.com:email,intel.com:mid,intel.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4095665AB49



On 6/7/26 12:34 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> condition means the remapped region starts after the device's data
> region, which is an impossible state. Previously the probe continued
> with data_offset=0, leaving virt_addr silently misaligned. Now probe
> returns -EINVAL with a diagnostic message.
> 
> Fixes: 759455848df0b ("dax: Save the kva from memremap")
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/fsdev.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index af9ef80c05c6d..dcb512625ce65 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -320,8 +320,12 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		u64 phys = dev_dax->ranges[0].range.start;
>  		u64 pgmap_phys = pgmap[0].range.start;
>  
> -		if (!WARN_ON(pgmap_phys > phys))
> -			data_offset = phys - pgmap_phys;
> +		if (pgmap_phys > phys) {
> +			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
> +				pgmap_phys, phys);
> +			return -EINVAL;
> +		}
> +		data_offset = phys - pgmap_phys;
>  
>  		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
>  		       __func__, phys, pgmap_phys, data_offset);


