Return-Path: <nvdimm+bounces-14277-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJ0jBOahHmquDAAAu9opvQ
	(envelope-from <nvdimm+bounces-14277-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 11:27:02 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 145F262B7DA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 02 Jun 2026 11:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9599F301DEDB
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Jun 2026 09:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7783B6C1D;
	Tue,  2 Jun 2026 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="peVpd5Nu"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC223876B5
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 09:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780391965; cv=none; b=DbkNHD88u9VkTStts3C7+PftTBca/j739ZWElUruQLcbIG3QctQWACIF1oaKgU5HJTg2wCfUH27avKoxL17ilcdjY3tXQQxwTjvdTcSLGE3i2/er1AtLyoBQt2y3Lf3jOAvmeB0VyqDUmuyBC3qeCQkcwtXw3Pl4/AO8auVGW1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780391965; c=relaxed/simple;
	bh=4PLQlpsnB/RRYsVV1JxqRCaTqPVvpCZHnrUn1CZYDRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtCcdbH/h6y9vsLWr69UkWwxDgW+EzW7loxqOHLdYIuUOSM5s9xRLlO5cnedJwlFl0cMbnsnHvTMcixEIoJfcuXcMlOGUr7r5o3CXtcOODeWuKIgwKjo11MDQaRffnUIx301uaYh3PZdCGS0sSqbH/jpY2jCJ1+OfWFZgSOhpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=peVpd5Nu; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 47C38D1023;
	Tue, 02 Jun 2026 09:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780391962;
	bh=svkiNZw21V/XkupJT5UQSR+7TebFnLxf7g5NPNd+ovg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=peVpd5NuXYYLA83lZsm/uc3I0zHN2mTApc6949ntTPmVV/LUV9I0QsQSWHGdOvNAf
	 1DuqIr8tvUg05qxlZcVBcmLCs9bf8fk5KUKi1Ih8qvZdWEjgStYIgpgm9S0hXNoko8
	 niVoTza68JiwYG5KvYGbJSGMy2ZXpOQxdxCOuZ6A=
Date: Tue, 2 Jun 2026 09:19:18 +0000
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
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <ah6gFnFkD418B56Q@shell.ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
 <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
X-Rspamd-Queue-Id: 145F262B7DA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ilvokhin.com,reject];
	R_DKIM_ALLOW(-0.20)[ilvokhin.com:s=mail];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14277-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,shell.ilvokhin.com:mid,ilvokhin.com:dkim,ilvokhin.com:email]
X-Rspamd-Action: no action

On Tue, Jun 02, 2026 at 09:32:12AM +0200, Miguel Ojeda wrote:
> On Tue, Jun 2, 2026 at 9:13 AM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > Miguel, I dropped your Acked-by due to the rename. Went with
> > __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> > spelling works for you.
> 
> I am fine with either, but thanks for the caution! :)

Thanks for confirmation, Miguel.

> 
> I assume `_args()` is meant as "the `nonnull` for the arguments, not
> the return"?

Yes, that is exactly what I had in mind.

