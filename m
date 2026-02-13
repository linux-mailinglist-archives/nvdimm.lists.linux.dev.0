Return-Path: <nvdimm+bounces-13092-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GScIxB8jmmJCgEAu9opvQ
	(envelope-from <nvdimm+bounces-13092-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Feb 2026 02:19:12 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 01FE5132390
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Feb 2026 02:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 149A830A18A7
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Feb 2026 01:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210B0226D00;
	Fri, 13 Feb 2026 01:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGc3lPPg"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4624621B9F5;
	Fri, 13 Feb 2026 01:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770945522; cv=none; b=idLebbcbeqQt2YCgw+PcYi6KrA5eRcQQkaqu3CFh9tPVUrnYBx5ozh7k5j8AsbdK3b1vTlt86K8UCOP9qlp0Vi3LIV4RS737MqmQ68TDOFRxi1gEBwiGCti0Kf0gIyQYO/Zo58sHf5rwv3mWvf5N1zJ7PXXOMdaoiLZAiD0yocg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770945522; c=relaxed/simple;
	bh=o/AFj0wbaA3ZO5SoMkiUxlTCygQN9/BnxE2QjNaq0do=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WzZ+bRXQXpee/oRnMwvxPCr780MQ/PKC73d/NoOCIC5HoIhV0Alj6G12FoX1B7MhEMlfy/PvVxsFoEBB9FpgQlprcMpGSYvVwgJkxJMDGlxDG6GPR+35Tn32+0+cMvzNsxaY5LAbBx4CgiB6z+2FMIL/waELwIttJm+1UFTmsew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGc3lPPg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA7AC4CEF7;
	Fri, 13 Feb 2026 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770945522;
	bh=o/AFj0wbaA3ZO5SoMkiUxlTCygQN9/BnxE2QjNaq0do=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bGc3lPPgGrFA6cmnLkPG6SJdlAUgug5crCwbogEXdLBguih1ga1W6oeRqgTK73/l9
	 JYAdLDbhBrg1z9ZwLcrI0z0iS+iM0Xcjm8NbvFD9rin3xvXZseJ5q42FcCDNIKgvsg
	 qStbRDJ+MDa3m95WxUOL3z2zrrz3w+GF3LPuR6kjwBIJ3tLvb1e21p8pbVngX0if02
	 BcCqe7sNaxbugzupAJwBQxWQvucLYcYIffRVJeU9uf0qpyPO+1ZVvQR2ThC/9WgK3A
	 cxLvBx5wpPwXhniTygtGc9nY5612xjga58KwoMiicbI20S/7OeTRSDWuNTY+pz/o1a
	 QPjorSVqhN30Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85397393108D;
	Fri, 13 Feb 2026 01:18:37 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
References: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0
X-PR-Tracked-Commit-Id: a9ba6733c7f1096c4506bf4e34a546e07242df74
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e99785a923d585174a71ea9c081bee708184862e
Message-Id: <177094551623.1792804.17341554728681602271.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 01:18:36 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, Davidlohr Bueso <dave@stgolabs.net>, "Jiang, Dave" <dave.jiang@intel.com>, Li Chen <me@linux.beauty>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,vger.kernel.org,lists.linux.dev,stgolabs.net,intel.com,linux.beauty,gmail.com,redhat.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13092-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 01FE5132390
X-Rspamd-Action: no action

The pull request you sent on Wed, 11 Feb 2026 15:09:16 -0600:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e99785a923d585174a71ea9c081bee708184862e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

