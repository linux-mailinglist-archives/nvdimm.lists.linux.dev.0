Return-Path: <nvdimm+bounces-874-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 394333EC7A1
	for <lists+linux-nvdimm@lfdr.de>; Sun, 15 Aug 2021 08:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 4E48A1C06BE
	for <lists+linux-nvdimm@lfdr.de>; Sun, 15 Aug 2021 06:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38B32FB6;
	Sun, 15 Aug 2021 06:05:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A0A2FAD
	for <nvdimm@lists.linux.dev>; Sun, 15 Aug 2021 06:05:27 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id C6F9C6103A;
	Sun, 15 Aug 2021 06:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1629007526;
	bh=suj+Kddq7COXexPNRgvB9DqbdShlFbdlvv2JIGlKgL4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=P5wfLB4eTNpTdDPki5CtQY5fd6TGR3D/peBv49ReYMJ/W3ASdXrPZKmCVRovs3cAP
	 RltL0d0Ory0GJoDKxtQfIi3s9t/JCfMMan4+RL3/SHX1c4SW9uRSce8Z+A6U57fdy9
	 Sy7mg287I7qX/qYQ0oIkxeA9zTujRrt2kmgRfb+AH0c5L/oY1uGA6/vdHNKsLfZarC
	 TcWpSuxmGSc9+TrTjAxkT+J05jWtwOjf4stCJBVU/mBQvLdgRAVjzTqMuqaIh0SJT0
	 xjg/LuuKVqT9zIP/oy7v2LknhF8ZPjQzDekhALPFLqY0gTbObN8CiVGRqwTiLCTcOe
	 t5P+yw4ZVSoXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B359760A9C;
	Sun, 15 Aug 2021 06:05:26 +0000 (UTC)
Subject: Re: [GIT PULL] libvdimm + dax fixes for v5.14-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4iDA0og-BpZWnXY=6pi1GJ9KYpq-f7UkTqSpin1E7rUvg@mail.gmail.com>
References: <CAPcyv4iDA0og-BpZWnXY=6pi1GJ9KYpq-f7UkTqSpin1E7rUvg@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4iDA0og-BpZWnXY=6pi1GJ9KYpq-f7UkTqSpin1E7rUvg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.14-rc6
X-PR-Tracked-Commit-Id: 96dcb97d0a40a60b9aee9f2c7a44ce8a1b6704bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ba34c0cba0b4e64ff321c9a74272eaab7b27bca
Message-Id: <162900752667.24719.10582282518830967139.pr-tracker-bot@kernel.org>
Date: Sun, 15 Aug 2021 06:05:26 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 14 Aug 2021 15:34:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.14-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ba34c0cba0b4e64ff321c9a74272eaab7b27bca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

