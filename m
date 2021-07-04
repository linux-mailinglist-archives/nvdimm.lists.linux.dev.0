Return-Path: <nvdimm+bounces-358-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C593BAEAB
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Jul 2021 22:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2490F1C0DAD
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Jul 2021 20:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0527D2F80;
	Sun,  4 Jul 2021 20:09:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133DB70
	for <nvdimm@lists.linux.dev>; Sun,  4 Jul 2021 20:09:45 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 761B3613C2;
	Sun,  4 Jul 2021 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1625429385;
	bh=ovJyi4Hh16NWrYDmmVuIqD+G6wRTG54EF7/8gepZQE4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fs4PYC8CVzp491neB7SMlBFKgLQen4YUlPVwvIzrxkrN2wMaUcXMzDr2T/mI6Z45d
	 L5S24VjIGaqWPLHBa3BEgvCHZwwaeY3cokDP1g4bYsczeSLgoUcRWDiHv7WXHepnh1
	 DvIhCOvx6YGgBJf0iSx4RYZvBxXAtCrtr6/ZbL3WMyMuQp8EAzqtGt8UWhGKZT3GoG
	 7d/UALYa4CkjKfC3URSxnr/2I0V23yUTgUQ9QUoscNpgBxSKo4LeNSgroMKL00cRPk
	 wI3TACZb4h6QdNPfPkb16OfeEQxnAvPa7iMocYD/gWbQrillzDrTVMT+ud3vyuGHlW
	 ESzRLMJoxRHPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FCF860A38;
	Sun,  4 Jul 2021 20:09:45 +0000 (UTC)
Subject: Re: [GIT PULL] Compute Express Link (CXL) update for v5.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4haJdFPBdUJDwVwMvR4Ezij7Osn-+H0JApF=9fM2AM5wA@mail.gmail.com>
References: <CAPcyv4haJdFPBdUJDwVwMvR4Ezij7Osn-+H0JApF=9fM2AM5wA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4haJdFPBdUJDwVwMvR4Ezij7Osn-+H0JApF=9fM2AM5wA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.14
X-PR-Tracked-Commit-Id: 4ad6181e4b216ed0cb52f45d3c6d2c70c8ae9243
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0c66a95c7e014abc3489e69dd3972d9225027d49
Message-Id: <162542938545.15409.9316512791620116947.pr-tracker-bot@kernel.org>
Date: Sun, 04 Jul 2021 20:09:45 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux PCI <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 3 Jul 2021 08:08:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0c66a95c7e014abc3489e69dd3972d9225027d49

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

