Return-Path: <nvdimm+bounces-4756-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE1A5BB076
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 17:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FF4C1C20993
	for <lists+linux-nvdimm@lfdr.de>; Fri, 16 Sep 2022 15:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A7B5C93;
	Fri, 16 Sep 2022 15:43:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A455C81
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 15:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8EAC433D6;
	Fri, 16 Sep 2022 15:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663343013;
	bh=YNSjP/LiCCx3Suc7zoGweqKnIGX37rmyAojFu4j9Jpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pveEJvBs5oLqN97djCT3lNEcGo8sygvspthc3T6FPX2c2JBTSgbmWcnPOA0T1UIMC
	 2oLag7mwCeBb4PdOrgGOaDexLa5ClhsPeLFvUUGzXxsDv3ij8xkOwPa0I6wrOpJakE
	 WT/WjagmVY+3qiWPEOlUXrqc6z+f5hRbc0ZnVPASXv7+Gu2tjB8aiq7hCNaFe94TqD
	 WtGSJVDLPk5h025tMLlKPQRiqMqZUtqLNPAShKqCqxbbeUoT/0V/H6Pv8PJvbG/rQ+
	 cXsNbBYF0XOwGDG3hD1rNhuuGjGl9Z6QyjWZt1hjzXBf58O5Oo0Sb7SnoOO9D18Mcx
	 dTkz/XIdsFrwg==
Date: Fri, 16 Sep 2022 08:43:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: dan.j.williams@intel.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, david@fromorbit.com, jane.chu@oracle.com
Subject: Re: [PATCH v8 0/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <YySZpaX6NU6aSdke@magnolia>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
 <bf68da75-5b05-5376-c306-24f9d2b92e80@fujitsu.com>
 <YyIY0+8AzTIDKMVy@magnolia>
 <YyIaVZ36biogzQU3@magnolia>
 <d3b5ce9e-dcdf-26b1-cdea-712d7e1be1f6@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3b5ce9e-dcdf-26b1-cdea-712d7e1be1f6@fujitsu.com>

On Thu, Sep 15, 2022 at 10:56:09AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2022/9/15 2:15, Darrick J. Wong 写道:
> > On Wed, Sep 14, 2022 at 11:09:23AM -0700, Darrick J. Wong wrote:
> > > On Wed, Sep 07, 2022 at 05:46:00PM +0800, Shiyang Ruan wrote:
> > > > ping
> > > > 
> > > > 在 2022/9/2 18:35, Shiyang Ruan 写道:
> > > > > Changes since v7:
> > > > >     1. Add P1 to fix calculation mistake
> > > > >     2. Add P2 to move drop_pagecache_sb() to super.c for xfs to use
> > > > >     3. P3: Add invalidate all mappings after sync.
> > > > >     4. P3: Set offset&len to be start&length of device when it is to be removed.
> > > > >     5. Rebase on 6.0-rc3 + Darrick's patch[1] + Dan's patch[2].
> > > > > 
> > > > > Changes since v6:
> > > > >     1. Rebase on 6.0-rc2 and Darrick's patch[1].
> > > > > 
> > > > > [1]: https://lore.kernel.org/linux-xfs/Yv5wIa2crHioYeRr@magnolia/
> > > > > [2]: https://lore.kernel.org/linux-xfs/166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com/
> > > 
> > > Just out of curiosity, is it your (or djbw's) intent to send all these
> > > as bugfixes for 6.0 via akpm like all the other dax fixen?
> > 
> > Aha, this is 6.1 stuff, please ignore this question.
> 
> Actually I hope these patches can be merged ASAP. (But it seems a bit late
> for 6.0 now.)
> 
> And do you know which/whose branch has picked up your patch[1]?  I cannot
> find it.

It's not upstream, though the maintainer (Dave currently) reviewed it.
I don't know if he hasn't had time to put together a fixes branch or if
he's simply punting all the queued up stuff to 6.1.

(Dave?)

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > --D
> > 
> > > --D
> > > 
> > > > > 
> > > > > Shiyang Ruan (3):
> > > > >     xfs: fix the calculation of length and end
> > > > >     fs: move drop_pagecache_sb() for others to use
> > > > >     mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
> > > > > 
> > > > >    drivers/dax/super.c         |  3 ++-
> > > > >    fs/drop_caches.c            | 33 ---------------------------------
> > > > >    fs/super.c                  | 34 ++++++++++++++++++++++++++++++++++
> > > > >    fs/xfs/xfs_notify_failure.c | 31 +++++++++++++++++++++++++++----
> > > > >    include/linux/fs.h          |  1 +
> > > > >    include/linux/mm.h          |  1 +
> > > > >    6 files changed, 65 insertions(+), 38 deletions(-)
> > > > > 

