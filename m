Return-Path: <nvdimm+bounces-14256-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KZ1I8/+HWqfgQkAu9opvQ
	(envelope-from <nvdimm+bounces-14256-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 01 Jun 2026 23:51:11 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E7796625A4B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 01 Jun 2026 23:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E5C43023DC8
	for <lists+linux-nvdimm@lfdr.de>; Mon,  1 Jun 2026 21:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20ACE33D6F7;
	Mon,  1 Jun 2026 21:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXif+v8c"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73BB27FD76
	for <nvdimm@lists.linux.dev>; Mon,  1 Jun 2026 21:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780350668; cv=none; b=AVHjrZW6/UPJ0wjSmkvxT6tpTrGYwtDPbDlZmJmDgeYX/1P4ltnH4sdZKRKEGNFA+T5JVKy32mt97BVQ4d0aSbjUMJSrUuLoeHBuMjRO48FxiPayc7pW+eAWopftZTXvLpacsUuhTL+r/qwfQCwuPr423bHKUf2zuPXYA2yONzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780350668; c=relaxed/simple;
	bh=k/TlNjEi0j2Ww63gzF2QK+oEs4VlqDFVRLcIvgAQrl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImbAnzLgdy1R+Fk3JsZMkJCLUVpZakyvv5JFpZpijZ8mXKbuA5Uj2r8ohU8vJyWdXX/jNnRaTdDASPJaB2XLn/USzS+0nA/0O71O3k3yJuRZg9Fxeo1wtspeUB/tywtbqS1H7zln+WEmd3vK4X9KihqilaTY7LS1vhuwsWulHZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXif+v8c; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780350667; x=1811886667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k/TlNjEi0j2Ww63gzF2QK+oEs4VlqDFVRLcIvgAQrl4=;
  b=jXif+v8cibQV23NA1eki8U7GV5N9IooWN9liE4Ml+EUpZ/5dFFM7QS25
   w/pBTdam9BCWXYgf3L+0+IUNES0BcJ25WLN1B7h/oAkjSdK9FTFmaSw4X
   zPIzoj18+++g2+ITGd3kNDnQ8VksR4vZG520660b1FT9TcnvxNcMOvfnd
   VIpiz2poDpZBSQ5L8tB+ufPNbjEjAcVYt6VNwemALYDb4d7X9NeSe5rBQ
   UYNzWbAOruO+3pRt4S/HA9TKi3uBq7EUkrN0+judTCfOzeup6NCwDL/Tu
   GlRtS3XZ9pGMjIal3QB3Hfj86w60FUUye3PENxWmD+H916Efv5BAR7qSY
   A==;
X-CSE-ConnectionGUID: hV5zIuJNQWOqnQE4+0FpBQ==
X-CSE-MsgGUID: 4IBd98rvSPWH+jGz6U44SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91691388"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="91691388"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 14:51:06 -0700
X-CSE-ConnectionGUID: uDJmgZU/RkWZYpYbXGA1ag==
X-CSE-MsgGUID: 99xJYBbiRm2piWn4FHXarQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="281816378"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.108.24]) ([10.125.108.24])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 14:51:04 -0700
Message-ID: <60fb426e-d8e3-48fa-a1a7-f566d0109c3d@intel.com>
Date: Mon, 1 Jun 2026 14:51:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/9] dax: fix misleading comment about share/index
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
References: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
 <20260530165029.6601-1-john@jagalactic.com>
 <0100019e79cb6bf6-4b48b7f5-c562-4591-aefe-730561f1b8c6-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e79cb6bf6-4b48b7f5-c562-4591-aefe-730561f1b8c6-000000@email.amazonses.com>
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
	TAGGED_FROM(0.00)[bounces-14256-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: E7796625A4B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 5/30/26 9:50 AM, John Groves wrote:
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

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
>  	 */
>  	folio->mapping = NULL;
>  	folio->share = 0;


