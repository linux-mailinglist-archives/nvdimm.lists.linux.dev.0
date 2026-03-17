Return-Path: <nvdimm+bounces-13597-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zG8BDubquWlmPgIAu9opvQ
	(envelope-from <nvdimm+bounces-13597-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 18 Mar 2026 00:59:34 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 827F12B47C0
	for <lists+linux-nvdimm@lfdr.de>; Wed, 18 Mar 2026 00:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1936D301A2A8
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Mar 2026 23:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27113A7F61;
	Tue, 17 Mar 2026 23:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYpLAo3M"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866F23264F3;
	Tue, 17 Mar 2026 23:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773791970; cv=none; b=riiTPZhjUPNePqBzeLxKyWulKAr1XHcpIAsdAjhNSxCqHNpsOYZRsJKFLVxkYqhPlB7z90rbtSxX8mTuQrLA4h6qU1q04cydD08LlVZEXZ/iKgG593Vi8dSYgwUs5YrgPhl4ZcQVF3g52ICeP0vE5AxjXrZ7JX4gWCq2XnwbC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773791970; c=relaxed/simple;
	bh=cait9hXMAsvIZyb/NgLS2rDcJ/atOoQY/OnL3EVQ9Ss=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BfGm5wQRmLQ6vanLpSNVWQsQyyICNoXaeXJqTMSaA0BLGECPf2nZsW2i8EfZA9hnBIf/NJs64o65ffK6bYtRLh0x4iRi8QgbdeouUe+MZCQV/bZTg8Yc6fM7/u6l2TOuyIlkiP2hPgVr+nEJy5qGzXyI16XVRif/STaQc5PbWkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYpLAo3M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32656C4CEF7;
	Tue, 17 Mar 2026 23:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773791970;
	bh=cait9hXMAsvIZyb/NgLS2rDcJ/atOoQY/OnL3EVQ9Ss=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eYpLAo3MXLvSuW6TaH54cOF1DFH372QlPJxT0qQ/dMUH8UJisouSV0lPrLgP7m0me
	 0w74bsEJDYYKJRMd8yt9J3Ecu59rvkWQASq7ReBG6x9hM21Zg+rWcYKucBElMwMUIL
	 fsWYI5iRjB0q1Rxm5MaQMLMQexq3psele6nNh13q1TEQmrjtJ5d0WpTAtjKXyvUrGt
	 08HSfx0V6ORIBECa0RGudmzom7ZiGxsSsmb97nJcucup73HaKsi2Ish7aUDTZwqf/c
	 91QI9m4DNCFE1w5/5c33Z3TC2RdEHTeC8PDxZHYNenDQIa9vjuLXUGOmWolJeZzwnZ
	 4mEaB+qda6FPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D4183808200;
	Tue, 17 Mar 2026 23:59:23 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM fixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <69b9c0b276c61_290b1007c@iweiny-mobl.notmuch>
References: <69b9c0b276c61_290b1007c@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <69b9c0b276c61_290b1007c@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.0-rc5
X-PR-Tracked-Commit-Id: a8aec14230322ed8f1e8042b6d656c1631d41163
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a989fde763f4f24209e4702f50a45be572340e68
Message-Id: <177379196213.62687.15205686384093936090.pr-tracker-bot@kernel.org>
Date: Tue, 17 Mar 2026 23:59:22 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dingisoul <dingiso.kernel@gmail.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,gmail.com,intel.com,lists.linux.dev,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13597-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,nvdimm@lists.linux.dev]
X-Rspamd-Queue-Id: 827F12B47C0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Tue, 17 Mar 2026 15:59:30 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.0-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a989fde763f4f24209e4702f50a45be572340e68

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

