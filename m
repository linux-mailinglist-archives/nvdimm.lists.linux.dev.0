Return-Path: <nvdimm+bounces-14155-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPRFLEkoFmqUiQcAu9opvQ
	(envelope-from <nvdimm+bounces-14155-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 01:10:01 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E975DD728
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 01:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8559307BD1A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 23:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0183CEBA7;
	Tue, 26 May 2026 23:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IR66NLB5"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F228B3AD524
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779836853; cv=none; b=D6psK7Bru9BFti/QMCyiVejG0MQsVIFM6wchUl5xP2tbqaPgKQLVO+cT7/D+TrkcIeob5Zwia/mRcN248Yz8mp9A8GimRgU0YS3K31ik36K7pVqkKID/UERFlXl2jPygx1tEtDzmi2ZbRha95KSiN9AkeJfx0r7si/qI95U0l/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779836853; c=relaxed/simple;
	bh=SxOUOxWnasaThRanXaxXY2WB3R8Bb6abXQavsMC9H4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qm7j5xUwzWmKlLU8HlVWxd4elQUHpNinLH3Lb4o10ERAyS1peOJFNTMbB9qJHg16W/zHLgnmzTPRxVATbf6yLHsnd4IlbyBVtJL1FDz0B5ztH73y4s2vi2T6shkadzoB7KU8OibIiC5mccSSBjZQuyNlZGpJrlL7OmmyR28TUgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IR66NLB5; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779836851; x=1811372851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SxOUOxWnasaThRanXaxXY2WB3R8Bb6abXQavsMC9H4I=;
  b=IR66NLB5qH7iWd452fMRXn1jBhhA8DCMTMbMvn1xoya79u+rkz2mCah6
   Xcv7qQIsc1OF+lvOoNstAIQ7RJPhxevpk3NqahL5kiiTcOLQdfGG14O6/
   hjvUcWkcceaaUTDyVIF9LtKWoU3mPLxFL9bvxSs6xu+Apq2XOxkhKK/Yw
   6QTvdWgyvxXlZwcEAQfu9cEEVwI/KusQGesWsWWJqj4X405ENmevH4Qjq
   /ts1k/9fasRLX1HqiClB8bWeZ32sxlVDZIjCw5+DK2nrC4cD6gkuyIasf
   nJKWRUfI/RBaSz1sRp0WxFlyxnoqIpX6b//ql/Z+XwgQ0erJ8fjiSG4t/
   A==;
X-CSE-ConnectionGUID: ud+LAQBCTEKlPxsSgYIeeQ==
X-CSE-MsgGUID: THVx/dA5QGO/cGaR8onK0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80775640"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80775640"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:07:31 -0700
X-CSE-ConnectionGUID: 7XP1E8DiSJOTMBH7QV9eNA==
X-CSE-MsgGUID: Z1AjfBgCT4OEv6eIOeDicg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="241223378"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 16:07:29 -0700
Message-ID: <53fe6abc-00c4-449f-ab94-2632b2aa2928@intel.com>
Date: Tue, 26 May 2026 16:07:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/7] dax: fix misleading comment about share/index
 union in dax_folio_reset_order()
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
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191843.79132-1-john@jagalactic.com>
 <0100019e512043a6-62e6e881-6d31-48e2-86f0-bb2c32248f0a-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e512043a6-62e6e881-6d31-48e2-86f0-bb2c32248f0a-000000@email.amazonses.com>
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
	TAGGED_FROM(0.00)[bounces-14155-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: 43E975DD728
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/22/26 12:18 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> The comment in dax_folio_reset_order() claims that DAX maintains an
> invariant where folio->share != 0 only when folio->mapping == NULL,
> implying folio->share is zero whenever mapping is non-NULL. This is
> misleading because folio->share and folio->index are a union -- for
> non-shared folios with mapping != NULL, reading folio->share returns
> the file page offset (folio->index), which is typically non-zero.
> 
> Reword the comment to accurately describe the union aliasing: the
> assignment clears whichever interpretation of the union word is active
> (index for non-shared folios, share for shared folios), which is correct
> because the folio is being released in either case.
> 
> No functional change -- the code was already correct, only the
> justification was wrong.
> 
> Fixes: 59eb73b98ae0b ("dax: Factor out dax_folio_reset_order() helper")
> 
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/dax.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99b..df19c9317d10e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -392,12 +392,12 @@ int dax_folio_reset_order(struct folio *folio)
>  	int order = folio_order(folio);
>  
>  	/*
> -	 * DAX maintains the invariant that folio->share != 0 only when
> -	 * folio->mapping == NULL (enforced by dax_folio_make_shared()).
> -	 * Equivalently: folio->mapping != NULL implies folio->share == 0.
> -	 * Callers ensure share has been decremented to zero before
> -	 * calling here, so unconditionally clearing both fields is
> -	 * correct.
> +	 * Clear the mapping and the index/share union word. folio->share
> +	 * and folio->index occupy the same union in struct folio. For
> +	 * non-shared folios (mapping != NULL), the union holds folio->index
> +	 * (file page offset); for shared folios (mapping == NULL), it holds
> +	 * folio->share (reference count). Either way, we are releasing the
> +	 * folio and both fields should be zeroed.

In the old comments, there is the pre-condition that "callers ensure share has been decremented to zero before calling here." Is this precondition remain true? Maybe should leave that comment in if that is the case?

 
>  	 */
>  	folio->mapping = NULL;
>  	folio->share = 0;


