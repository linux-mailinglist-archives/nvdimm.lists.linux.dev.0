Return-Path: <nvdimm+bounces-13984-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGU0JryJ82md4wEAu9opvQ
	(envelope-from <nvdimm+bounces-13984-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 18:56:28 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F34264A6197
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 18:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACBFB3020A95
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 16:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D293630BC;
	Thu, 30 Apr 2026 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="LzryY13Z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pZufQiL4"
X-Original-To: nvdimm@lists.linux.dev
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8394341AB8
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777567873; cv=none; b=NHT+0/wY6/yp0e08F7vlcyxXCrYCmpdRUzt9E7dJSzBVfi82/q0RnFBA5cMlls7sNFty9lJ1XVgD+S3cVaWJA4lBplEh+3ebtdzgqV7gus0QdR4pU6u+yBcR0ZTQ1NboPZf6gAnT+D0F4yt0DK9NQFJv65SiXAMzY0zCKAk8keQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777567873; c=relaxed/simple;
	bh=8heCOqWXg0B0ic/LZEv4/oqrbh10xfSNh9Rzn5gk3LY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nHDWczsVVgkYGc8jMev2k8ebScxIXc7slUU9dQacHIui7vkzZYRbupLjesVLEymP271NbWY5h7ywFwcLCelEgbrAmtgN3YI7Zw4tdHjdxmlEL0+OWsT7esUHRosFyUfjeZzrcag5G9GdF9R1Webv5Bt7WecDhupAMGSUNNiFq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=LzryY13Z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=pZufQiL4; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B05447A00C0;
	Thu, 30 Apr 2026 12:51:10 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Thu, 30 Apr 2026 12:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777567870;
	 x=1777654270; bh=mcF810TAYIZ+eGBrJePl+D8wRSaNJ0xNu7eemO+CWV4=; b=
	LzryY13ZbaKwACj5iiovHrGvOjcXIlxDtKM6S+0dbTMuxVvmCfDiKQTetSKzadRC
	1urWtdnniACFynuReBRqB7yRWm/pqEsIDF4YrLOve4DGz9aEPR28hLQnMoiFZs/+
	jf82SOYt2oHtmMg+xH13wM2VF/p4YKOw+dM22EVxPLik4jWKWWqUr2ECXQNlhVMT
	QTzea7gvFZ4h9cDYUoyUV/JDKfYce6/2dy2trv3nJ3AEDp/8LtY0Y7Y44qyMZ0/G
	wzSy503brYLjiZG/EB/mOdqEQl7eQtMd9PRfTmCimhW63Tr6TlkTwduZhgstinK5
	WGOVjLSNrLooBvwOZjOo8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777567870; x=
	1777654270; bh=mcF810TAYIZ+eGBrJePl+D8wRSaNJ0xNu7eemO+CWV4=; b=p
	ZufQiL45KBSn0NlbGiKTccHmf7XVfNinF3eoLzOSXxtywiqlelKGFj8d57SCqOie
	UVrYNB6ImKMbyReNTFQI+IB3nZI/on2w1dyc2XVCvNfdvNNR7eRRXpg3couLJsbJ
	BJsjMSa8uPCAITB/biYWaynd+hmLY9ZapxEzwzOdpnOGxw/GSx2pwgu7EyShzMVf
	FpD/2LrGuRwvEHHQyPsaIStE2QlsHmIVW+0CgFOeROqgFmA51kwfrztnCIlVQWFE
	RRWN+w49Tg7cz8M8YLLVXG75zDShvTWfYe9C5U60a/TnAVUBU8mXGhyoXyKY8x11
	HBzMTdewJizjpUezfDN6g==
X-ME-Sender: <xms:fojzaaOcV4OSD2karapCjAwdICx9nowUaetRIuGYe9lhb4DaasWArg>
    <xme:fojzaTz32j7o6gVTsZgKH949lTl4DYCGfKT56lMc_dJ1tnv_BVM_u9KWjqG0w98uC
    3jMgbnjlfYogbcPm08bQ7tQfjWsbp4H0kd2yYYzy0s8vLsLEgvAe-TZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdflohhhnhcu
    ifhrohhvvghsfdcuoehjghhrohhvvghssehfrghsthhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepveduieelvedutddvvddvkeeuvefhieefieelfeekiedtkedutdeiteeu
    tefhteegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epjhhgrhhovhgvshesfhgrshhtmhgrihhlrdgtohhmpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggvvhdrshhrihhnihhvrghsuhhluh
    esghhmrghilhdrtghomhdprhgtphhtthhopehjohhhnhesghhrohhvvghsrdhnvghtpdhr
    tghpthhtohepjhhonhgrthhhrghnrdgtrghmvghrohhnsehhuhgrfigvihdrtghomhdprh
    gtphhtthhopegrlhhishhonhdrshgthhhofhhivghlugesihhnthgvlhdrtghomhdprhgt
    phhtthhopegurghvvgdrjhhirghnghesihhnthgvlhdrtghomhdprhgtphhtthhopehvih
    hshhgrlhdrlhdrvhgvrhhmrgesihhnthgvlhdrtghomhdprhgtphhtthhopehjohhhnhes
    jhgrghgrlhgrtghtihgtrdgtohhmpdhrtghpthhtohepughjsgifsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehnvhguihhmmheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:fojzafynmOC9fJ2ZwplqC8HRhP9TkmfD72IBy1BSnwGQcLEQuJqh3w>
    <xmx:fojzaXth5l_jKewQgLeezTyXGlTUd3B3W7v3ui6BFwi97emJBY6Thw>
    <xmx:fojzaZFz87gS6CK4cxoY0aSUlYNa64aXT-9SPOMdPF1UeyDYVCEDrA>
    <xmx:fojzaV5KuhdotwPrcdW3x0TS_X6E8lbuSzfBkd5Ilsaesm-ipyguJQ>
    <xmx:fojzaZdsIzxikvC-_C5bQ-jxPdugexsKr_2kh-DaLQZexqPeHbuIDBVV>
Feedback-ID: if7ae487a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F1901700065; Thu, 30 Apr 2026 12:51:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Apr 2026 11:50:49 -0500
From: "John Groves" <jgroves@fastmail.com>
To: "Dave Jiang" <dave.jiang@intel.com>, "John Groves" <john@jagalactic.com>,
 "John Groves" <John@groves.net>, "Dan Williams" <djbw@kernel.org>,
 "Alison Schofield" <alison.schofield@intel.com>
Cc: "John Groves" <jgroves@micron.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Aravind Ramesh" <arramesh@micron.com>, "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "dev.srinivasulu@gmail.com" <dev.srinivasulu@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Message-Id: <d44e26da-f48e-40e2-82ec-b4cf4048454c@app.fastmail.com>
In-Reply-To: <1e7e9b08-1985-4917-a2f2-f0ef78d8b591@intel.com>
References: 
 <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
 <20260430153413.84181-1-john@jagalactic.com>
 <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
 <1e7e9b08-1985-4917-a2f2-f0ef78d8b591@intel.com>
Subject: Re: [PATCH V5 2/2] Add test/daxctl-famfs.sh to test famfs mode transitions:
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F34264A6197
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.65 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fastmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[fastmail.com:s=fm2,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	FREEMAIL_FROM(0.00)[fastmail.com];
	TAGGED_FROM(0.00)[bounces-13984-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[micron.com,intel.com,huawei.com,gmail.com,vger.kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgroves@fastmail.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[fastmail.com:+,messagingengine.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[groves.net:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,app.fastmail.com:mid,fastmail.com:dkim]



On Thu, Apr 30, 2026, at 11:27 AM, Dave Jiang wrote:
> 
> 
> On 4/30/26 8:34 AM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > - devdax <-> famfs mode switches
> > - Verify famfs -> system-ram is rejected (must go via devdax)
> > - Test JSON output shows correct mode
> > - Test error handling for invalid modes
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  test/daxctl-famfs.sh | 253 +++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build     |   2 +
> >  2 files changed, 255 insertions(+)
> >  create mode 100755 test/daxctl-famfs.sh
> > 
> > diff --git a/test/daxctl-famfs.sh b/test/daxctl-famfs.sh
> > new file mode 100755
> > index 0000000..12fbfef
> > --- /dev/null
> > +++ b/test/daxctl-famfs.sh
> > @@ -0,0 +1,253 @@
> > +#!/bin/bash -Ex
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2025 Micron Technology, Inc. All rights reserved.
> > +#
> > +# Test daxctl famfs mode transitions and mode detection
> > +
> > +rc=77
> > +. $(dirname $0)/common
> > +
> > +trap 'cleanup $LINENO' ERR
> > +
> > +daxdev=""
> > +original_mode=""
> > +
> > +cleanup()
> > +{
> > + printf "Error at line %d\n" "$1"
> > + # Try to restore to original mode if we know it
> > + if [[ $daxdev && $original_mode ]]; then
> > + "$DAXCTL" reconfigure-device -f -m "$original_mode" "$daxdev" 2>/dev/null || true
> > + fi
> > + exit $rc
> > +}
> > +
> > +# Check if fsdev_dax module is available
> > +check_fsdev_dax()
> > +{
> > + if modinfo fsdev_dax &>/dev/null; then
> > + return 0
> > + fi
> > + if grep -qF "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
> > + return 0
> > + fi
> > + printf "fsdev_dax module not available, skipping\n"
> > + exit 77
> > +}
> > +
> > +# Check if kmem module is available (needed for system-ram mode tests)
> > +check_kmem()
> > +{
> > + if modinfo kmem &>/dev/null; then
> > + return 0
> > + fi
> > + if grep -qF "kmem" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
> > + return 0
> > + fi
> > + printf "kmem module not available, skipping system-ram tests\n"
> > + return 1
> > +}
> > +
> > +# Find an existing dax device to test with
> > +find_daxdev()
> > +{
> > + # Look for any available dax device
> > + daxdev=$("$DAXCTL" list | jq -er '.[0].chardev // empty' 2>/dev/null) || true
> > +
> > + if [[ ! $daxdev ]]; then
> > + printf "No dax device found, skipping\n"
> > + exit 77
> 
> Can you use 'do_skip' here?
> 
> DJ

Yes! Done in 2 places...

<snip>

Thanks,
John

