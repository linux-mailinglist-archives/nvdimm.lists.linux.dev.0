Return-Path: <nvdimm+bounces-2462-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC4848CD6F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 22:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E5EF33E0F34
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jan 2022 21:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE982CA3;
	Wed, 12 Jan 2022 21:07:16 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C2B173
	for <nvdimm@lists.linux.dev>; Wed, 12 Jan 2022 21:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5088C36AE9;
	Wed, 12 Jan 2022 21:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1642021635;
	bh=Q4wnYuehSQfT7lgJVtKDm/o6jqZcPN9o8LkY698vJZg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Fd8uFCNDvYYxsVa8FxDN4ZwsoMHVqSLngP/iQUHxaq3rNmscUt7ZVFDlIBqSLjkR/
	 RRIGJe5gvl49MT3ol/Yy3/sh/HIhW3NNVcbmCZSjl4M61ldIM2FyWfiHbmFNF+NL4c
	 Ix5efFyHXO3j1sEjo8sZlxs77kG8J3jtYTxBWuAX55L5PPZSq5YYo/vlU2+6LPV8DF
	 wTRT0r8lQ+y2v3Vf51QXxTaxLgP0LHEXDW5Wt9V09g/6gIe/FP/glwR9T0CXFEmG89
	 6NcSEKXZtfPMgysyQWtg/JVuqugrp8qX9j59ojQHXMPlgPAJZDn9pp5KQxXlYeWZK4
	 u0GR1DHlrjkkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D428AF6078C;
	Wed, 12 Jan 2022 21:07:14 +0000 (UTC)
Subject: Re: [GIT PULL] iomap for 5.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <YdyoN7RU/JMOk/lW@casper.infradead.org>
References: <YdyoN7RU/JMOk/lW@casper.infradead.org>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <YdyoN7RU/JMOk/lW@casper.infradead.org>
X-PR-Tracked-Remote: git://git.infradead.org/users/willy/linux.git tags/iomap-5.17
X-PR-Tracked-Commit-Id: 4d7bd0eb72e5831ddb1288786a96448b48440825
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f079ab01b5609fb0c9acc52c88168bf1eed82373
Message-Id: <164202163486.6701.11106784098359730682.pr-tracker-bot@kernel.org>
Date: Wed, 12 Jan 2022 21:07:14 +0000
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 10 Jan 2022 21:42:15 +0000:

> git://git.infradead.org/users/willy/linux.git tags/iomap-5.17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f079ab01b5609fb0c9acc52c88168bf1eed82373

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

