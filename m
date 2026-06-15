Return-Path: <nvdimm+bounces-14421-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id N3DOHiL9L2pyLQUAu9opvQ
	(envelope-from <nvdimm+bounces-14421-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 15:24:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D003686B95
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 15:24:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14421-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14421-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AFB14300846D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 15 Jun 2026 13:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1B333C507;
	Mon, 15 Jun 2026 13:22:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AC33F411B
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 13:22:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529761; cv=none; b=eC3nBsPAl/JamjDUdVXC5aZ5Cdj3yGpSLNImTXK8e9l706Y6Cb/Ea/5lwDizTrDjQjEnnAGhU9OW9AnLRXsZGCTLX6+9Iivv4WALmxO6q02NhXyNG1gHvYj24Y4ESj3HIOHjtHDaR2+uV6IQNxRh52ExWvFFvXvR6cH2PRgjsyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529761; c=relaxed/simple;
	bh=e2qlcvauBAi4XtzeZV5u2HFUaH2GDZ6VqDjdYQ/giz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsVk7iUFuudaK+HANcouVAUZcv74UYH9QtfbuuV7GpPveEXRg2YcVYh4RroqzGHCKoUlv9Qi24qwhscBXcqZ5wLPQhviqDPWAbnI1Y8klHSJvmVOTnbginFP5KJ/7tBpALV0O7rpz9YcjftyKboS/RBtXIbPlsgxyBsH9uT6yUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C90E3140A0A;
	Mon, 15 Jun 2026 13:22:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf15.hostedemail.com (Postfix) with ESMTPA id D6C521B;
	Mon, 15 Jun 2026 13:22:33 +0000 (UTC)
Date: Mon, 15 Jun 2026 08:22:32 -0500
From: John Groves <John@groves.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V5 7/9] dax: read holder_ops once in
 dax_holder_notify_failure()
Message-ID: <ai_70p0O3u3S__gh@groves.net>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173240.66020-1-john@jagalactic.com>
 <0100019eb7be595f-5045353d-86b9-49fd-b1ca-fbb40c22d06c-000000@email.amazonses.com>
 <ait2Lymb4y-Wb2ie@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ait2Lymb4y-Wb2ie@MWDK4CY14F>
X-Stat-Signature: wi4m6dat41b8azege1in4ra9iexqebu5
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19TFhvmT3BAejXjJoTuyXfYam/BZhUdxSY=
X-HE-Tag: 1781529753-543104
X-HE-Meta: U2FsdGVkX183+gFmPlX0UJGoOj4EB+fyIojJtMwSlLOmbwsxRaUn2+UYb73LuIm7J02Hs/CICiWQgz1i5uwrGBiDCBVhulYHYDJAq9eHOiSBzlwvgbKbH40H3CdO+gFd14HN03/Lfv8KDVDBBKmdqYoR3Gp8ASk2ykAb6e9dGht2NfX7+SMS4dm5AlEl+23d2ECTivvL4e8OKFaFafXKQSCy/Q986daBPYfgTt3b4XQRblrsT1K2gc45S2gam2b9hb+JlshQcwWdx5aZN01nQ8GowfViST++oid1PSBrdPyKz1He6AFJJ4TjJ1IfyXWXGiPhMuYYIDXCIeD6dd8cNQrmNedtzPgH24kRRzWA2olRB4CvcLKguvrXjuPtcJwn3yqdFt7a3nC2CMYMtcsIMg==
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14421-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_RECIPIENTS(0.00)[m:icheng@nvidia.com,m:john@jagalactic.com,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,nvidia.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,groves.net:email,groves.net:mid,groves.net:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7D003686B95

On 26/06/12 11:02AM, Richard Cheng wrote:
> On Thu, Jun 11, 2026 at 05:32:45PM +0800, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > dax_holder_notify_failure() reads dax_dev->holder_ops twice without
> > READ_ONCE() -- once for the NULL check and once for the indirect
> > notify_failure() call. A concurrent fs_put_dax() or kill_dax() can clear
> > holder_ops between the two reads, so the check can observe a non-NULL
> > pointer while the call dereferences NULL.
> > 
> 
> Hello John,
> 
> Thanks for this.
> 
> Reviewed-by: Richard Cheng <icheng@nvidia.com>
> 
> Small message nit, kill_dax() isn't a racing clearer.

Right -- kill_dax() clears holder_ops only after synchronize_srcu(), so it
can't race a reader under dax_read_lock(). Reworded the commit message and
the code comment for V6 to name only fs_put_dax().

> Plus I think this only fix holder_ops double-fetch, the fs_put_dax()
> race issue is separate and pre-existing.

Yes, intentionally -- this patch is just the reader-side double-fetch. The
fs_put_dax() race is the separate, pre-existing one handled by the next
patch in the series ("dax: fix holder_ops race in fs_put_dax()").

> 
> Best regards,
> Richard Cheng.

Thanks,
John

<snip>

