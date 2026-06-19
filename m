Return-Path: <nvdimm+bounces-14461-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id AMJPO9WINGp3agYAu9opvQ
	(envelope-from <nvdimm+bounces-14461-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Jun 2026 02:09:57 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3F86A3268
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Jun 2026 02:09:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5CIO1oe;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14461-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.232.135.74 as permitted sender) smtp.mailfrom="nvdimm+bounces-14461-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EF7B3302F310
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Jun 2026 00:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E98420ED;
	Fri, 19 Jun 2026 00:09:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D5C10F0;
	Fri, 19 Jun 2026 00:09:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827793; cv=none; b=pbtrVxt5+SriwIwF69nJsrUMaJwNaDr5s1HAOLzW63F+xRIYNiApQgZtS8cJ1w/guDCRaMKTqG4MgGhgBtIo8XKRuqqLsQ7hvU9WddijDEkifrFLTLxQGg/cGDWe0H40Cp6zPW/fc4Xr1UEvX+gZvojwDvcaFW8F8iFVfgM0w70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827793; c=relaxed/simple;
	bh=kW7yZm+xXpaVjcqJoh9CrN2RWRIXMLol16rzHKxl+hI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F0s5a9G5Fz779Xa8xG/7kcgJjCEg2N0ERX70BhMfXbs6M49Pby5ZbjZ9Qx8zRyQviDXC5e2TFaZDW6ynbLvVg7rDaef0SDghr/uiXTSj8Yu5agrfxycpeMDoJXIcKz+SGLn0QDGL6r9A5CZ1wE2j1yMPR+TkoqNF/CUW/B6SdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5CIO1oe; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CF41F000E9;
	Fri, 19 Jun 2026 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827791;
	bh=VCp1M1WBlxc+BHi27sal0mnlhHjtxnftSyLiwR8hV/0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=S5CIO1oeMM3f4hPmzjbbmcV32UFYGUoxctacIlQ5oqL12rb5PduR3dpeNSLgggn7l
	 RrfhrTANEmI997nw8SJREpOPpINmDSuWhoUzCTmiByvcKzLN+LipMHIE2jXjAzxA3K
	 tUQuqCI6uIIEDd0/xxyUAA0ZHqfprt1TtPMRNHlKwmQ5ztgc9BV8P4NDKbaALY02f/
	 7IdCUMd8/jIJFc6Rga+8/xL71yHtBUTO2sVIGJIUtrztz34t0LJRbjLHTnv9a4SCUZ
	 JnJ5mAT4hMiS6bolvIBaUnQYInpj2OPSzr9xIKgNnA9O49LntdAbMZj66WUMIjOeXy
	 Qzwy+AmauLkRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568A53A5676C;
	Fri, 19 Jun 2026 00:09:46 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
References: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.2
X-PR-Tracked-Commit-Id: 86e411b6ec277dbb8ac1f1d855dc337181a62a29
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfd96ad1389cd6045a3af05bd34b2e52b291e365
Message-Id: <178182778495.3120511.840711900426249032.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jun 2026 00:09:44 +0000
To: Alison Schofield <alison.schofield@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:alison.schofield@intel.com,m:torvalds@linux-foundation.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:iweiny@kernel.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[pr-tracker-bot@kernel.org,nvdimm@lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14461-lists,linux-nvdimm=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,nvdimm@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7D3F86A3268

The pull request you sent on Thu, 18 Jun 2026 10:13:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfd96ad1389cd6045a3af05bd34b2e52b291e365

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

