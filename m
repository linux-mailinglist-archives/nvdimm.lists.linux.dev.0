Return-Path: <nvdimm+bounces-14142-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Vj3qFp+xEWruowYAu9opvQ
	(envelope-from <nvdimm+bounces-14142-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 May 2026 15:54:39 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 937785BF1FF
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 May 2026 15:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F40AA3014BE3
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 May 2026 13:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE93389473;
	Sat, 23 May 2026 13:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="CLspGlc2"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF1F328B61
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779544472; cv=none; b=uTPH1VtW8JPaNbFc7AjZXZT314db2MP0kUFS67ePZZZhQTuG7SKK2YBuZSp26creB6S8i5ychp79vtelk45Y77oEkZRXfumhEN9v5rQzlr8TBDpzov8t+Jp4xU9dNERAUsGP58m8kSOOOGXDHKq9EBuFUiN68yPI5xI84vMPGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779544472; c=relaxed/simple;
	bh=X039arksf8wCZaY1gegeQwWWjIB25yWGN31F0LxRFV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXFg0B8Kd06EHdadQylL1dW4Mj8XB98wQTwHgafQHYr8qnzeLyOw1dKPjFVXNKg8uk8iqH49veWNp+d6qlhhZuQk6isAUQxDPlC0jo2cs6oJ4Tc9BC43hs9sE6WMiiZaolfLm0JtbxYzrLaupbnGNWYLvWiLKzJ2DrnKBvSL7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=CLspGlc2; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B0FF4D0A95;
	Sat, 23 May 2026 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779544469;
	bh=azf2cAACap+DXFF5XblNSQG+CE81RY4YaUZbwOo7nr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CLspGlc2odvTlcOlSaGOKqJyQ0zvxfpUgXERroy3jQqjlKBfGGVV1sZSfI9urVVMu
	 FVXnieCF6FSx14EGbfjSkRme5YgdnafmNZyCrZM5Ys/mhHnPMkLacrcYClUJb9cig7
	 70phs+OApR96hELJ6Dm77X+96EY0Y1ItQoTzip/E=
Date: Sat, 23 May 2026 13:54:28 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <ahGxlAUeUwSbbYi4@shell.ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ilvokhin.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14142-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,ilvokhin.com:email,ilvokhin.com:dkim]
X-Rspamd-Queue-Id: 937785BF1FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, May 23, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> On Thu, May 21, 2026 at 07:18:03AM +0000, Dmitry Ilvokhin wrote:
> > Add __nonnull() to unconditional guard constructors so the compiler
> > warns when NULL is statically known to be passed:
> > 
> > - DEFINE_GUARD(): re-declare the constructor with __nonnull().
> > - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> > 
> > DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> > pointer arguments (.lock is hardcoded to (void *)1).
> > 
> > Define the __nonnull() macro in compiler_attributes.h, following the
> > existing convention for attribute wrappers.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Miguel Ojeda <ojeda@kernel.org>
> 
> The build robot found something to hate in this one. I think you're on
> Cc there. It looks to me like clang-23 is confused somehow, but who
> knows.

Thanks for the heads-up, Peter. I got the report and will look into it.

