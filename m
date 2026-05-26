Return-Path: <nvdimm+bounces-14150-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKrfIAC8FWrKYQcAu9opvQ
	(envelope-from <nvdimm+bounces-14150-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 17:28:00 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A565D8B3F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 17:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5EB4A31D7451
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 15:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18AF4395DB8;
	Tue, 26 May 2026 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="xtHDw9ww"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B49D346795
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808393; cv=none; b=ZjYSl2to5tAnwHVc4a9Bl2yOC/qu6KkdYLw7d6K/NhvL19m9jEoUo4iM4egEM7W1/1DZ2Ab9kuU9Z0LRYV+TpMplYlZEfRfIPPrzjGxxz3jh0kVht59mhg7KERhgYRTLATIN1UEoGV/Mx0fcbJl5IvDa0VkVJccykM2kQGSQyMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808393; c=relaxed/simple;
	bh=AyCjuMi09pCuS611oE9c3ZLXxzVop/+xAKxRR8tSswk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTD6IWT5MFES1PkZ7BrFB+sRofhGf2pdlmt+/rtBziShiN3BiVKYava2FWfuwu51G+il05w2EHUYvqNv/VvCV7BcsN8T/nkq/TPr+WFPaXbsFNPJPlFlEqoK6TU49Z+NknROgrrCF25yCBjuqzrfz6x61GNtBuQ7MPqu4Eez/YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=xtHDw9ww; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id ABC03D0C4B;
	Tue, 26 May 2026 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779808384;
	bh=w7fh/zrSEr4aiiZTWxTruWfZmIvpNK/R/una2H3xjd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xtHDw9wwWgqvb9UrbriKSbej9cKBiuXOhXwAhLqOTPYFGTinLcwujcGvPvsxucVMi
	 f40mdSZNqRod8hk3AUvSpNVBe6EsuwUCVn5aSuGl9ShxLBOaPukHknCQlJs5LfML+L
	 0kORWOZO3guDaOo/Co0LPMOdQImXXuCIgBPa+Goo=
Date: Tue, 26 May 2026 15:13:03 +0000
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
Message-ID: <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14150-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bootlin.com:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,ilvokhin.com:email,ilvokhin.com:dkim]
X-Rspamd-Queue-Id: F3A565D8B3F
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

Seems like clang is not confused here, I was able to reproduce the problem
with GCC 11 as well.

There is a conflict with glibc's own __nonnull macro

    https://elixir.bootlin.com/glibc/glibc-2.43/source/misc/sys/cdefs.h#L560-L562

which doesn't match the one from include/linux/compiler_attributes.h.
They usually don't collide, except for User Mode Linux builds, which
include both kernel and userspace headers.

Options are:

1. Drop the __nonnull() macro from include/linux/compiler_attributes.h
   and use __attribute__((__nonnull__())) directly in
   include/linux/cleanup.h. This is a bit unfortunate, since __nonnull()
   seems like a useful shortcut, but seems like the simplest solution.

2. Rename __nonnull() to __nonnull_args() to avoid the conflict.
   A returns_nonnull attribute is supported by compilers, so the name
   fits, but it diverges from the existing naming convention in
   include/linux/compiler_attributes.h.

3. #define __nonnull(params) __attribute__((__nonnull__ params)). This
   keeps the name and is compatible with both kernel and glibc usage.
   Current call sites use __nonnull() with no arguments, which works
   identically. Future callers with specific parameter numbers would use
   __nonnull((1, 2)) with double parens, matching glibc's convention. I
   don't like this option, listed it here for the sake of completeness.

I am leaning towards option 1 so far.

