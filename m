Return-Path: <nvdimm+bounces-14063-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFVVEThQDGqTewUAu9opvQ
	(envelope-from <nvdimm+bounces-14063-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 13:57:44 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEF457E299
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 13:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA1493064674
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 11:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1ED94779A9;
	Tue, 19 May 2026 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="Q1JzYcRw"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C5C3328FD
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 11:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191694; cv=none; b=F6SNiI8ayZtgd9TkCyZi2JuIugl8xws8AaO+5diXjgUS00dQUtUjisrBxsiZtjkz9o2VOgjE8Q3f+J0CLc4FFj1X+YgEDLGepVT8NUSiAbFaQhtpRydaBxJyXITB7Aql625/GNhZ8Ku8sIkaw47K6uhhOQK4SdJ4f4rpgjNZ8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191694; c=relaxed/simple;
	bh=cKW7IkjJxSkTHJyCv4yQtVqFIKFwmALPt8LBCwWDIIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGBHXnxh70eiIzGnIF9vDMpHSfs6tf6MD+IsXBD+kRlguRG0p58Wtpx0UOActBZEx2TxwmKvFYbmI+h2/zb5dhLDyoHWs9kTMVp1CImPTqyOZGzhl7CpBHPsOqSPffnMQDZSm/FkxjvUce+q4pJuu7HlWjgnpswjWEszdMXK0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=Q1JzYcRw; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 493A7D0805;
	Tue, 19 May 2026 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779191690;
	bh=zRsE2vPKgX0eKECBE4DwNFiQcuKvIy6vdkZ9SvFMc0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q1JzYcRwX2pTPEtrYf0z7m3PrTSq18eHaWrkis/FXOdB4twrWKYeT4CnSzHXUdawM
	 S3MbO93VNARrHdUYm5q7cIGGMbRFnzyNJCiHx606X6pk6qBvrg4zBygxdVrafDXzc/
	 mfp2U7xo5A3eHG/j8q1GVS41p96lDysWkZjkNgp0=
Date: Tue, 19 May 2026 11:54:49 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <agxPiQKt2pykEIA4@shell.ilvokhin.com>
References: <cover.1779116497.git.d@ilvokhin.com>
 <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
 <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ilvokhin.com,reject];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14063-lists,linux-nvdimm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[d@ilvokhin.com,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[ilvokhin.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,gnu.org:url,ilvokhin.com:email,ilvokhin.com:dkim,shell.ilvokhin.com:mid,llvm.org:url]
X-Rspamd-Queue-Id: 8EEF457E299
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 08:19:35PM +0200, Miguel Ojeda wrote:
> On Mon, May 18, 2026 at 5:22 PM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > Add __nonnull() to unconditional guard constructors so the compiler
> > verifies at each call site that NULL is never passed:
> 
> > This provides automated, compiler-enforced verification that no
> > unconditional guard constructor receives NULL.
> 
> I wouldn't say "verify", since the compiler does a best-effort here
> with the information it has statically.
> 
> In other words, the attribute does not prevent NULL pointers to be passed.

Fair enough.

I'll re-word this paragraph as "Add __nonnull() to unconditional guard
constructors so the compiler warns when NULL is statically known to be
passed" and drop the "compiler-enforced verification" paragraph.

> 
> > + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-nonnull-function-attribute
> 
> Hmm... It appears GCC has changed the docs in commit 6e3c137f5dbb
> ("doc: Merge function, variable, type, and statement attribute
> sections [PR88472]"), dropping the per-kind attribute pages.
> 
> So the right link would need to be now:
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
> 
> I will need to send a patch to fix the other links.

Fixed locally. Thanks!

> 
> > + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
> 
> I think this link goes to `_Nonnull` -- the GNU one is instead:
> 
>   https://clang.llvm.org/docs/AttributeReference.html#id10
> 
> (I don't love the numeric IDs, though, since they break, so I think it
> is fine either way -- the `_Nonnull` is fairly close to the one we
> want and I hope that one doesn't break)

I don't quite like numeric IDs either. There is only one #id reference
in include/linux/compiler_attributes.h and link is already dead. I'll
keep current link since it gives at least some clue what to look for on
the page.

> 
> > + */
> > +#define __nonnull(x...)                        __attribute__((__nonnull__(x)))
> 
> This is indeed available for a long time, and we already use it
> elsewhere in the kernel tree (which would be nice to clean up
> separately).

> 
> If you don't mind, please place it before `__nonstring__` (the file is
> meant to be sorted by the actual attribute name -- there are a few
> instances where this is not the case anymore, which I will eventually
> clean up)

Thanks, fixed locally.

> 
> Thanks!
> 
> Cheers,
> Miguel

