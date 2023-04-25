Return-Path: <nvdimm+bounces-5952-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B8E6EE4A0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Apr 2023 17:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B81C1C2091D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Apr 2023 15:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503776D39;
	Tue, 25 Apr 2023 15:18:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E36363D9
	for <nvdimm@lists.linux.dev>; Tue, 25 Apr 2023 15:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C680C433EF;
	Tue, 25 Apr 2023 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682435881;
	bh=OZVtwFWo7+1hR1E/XFg8v7jLksChEj4wIb247kHrI2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JwuiYzoE9l78rA8VNEL7AMkMtYghXYh1MhzRtXMnCSRA9FgM/K0NzCyfCHGaNdnVt
	 aIeHzHmeqbLKat4hJ1Oq7PBAve2s18Wh05BcH+6o+l3mw/nfuKNmuoUu4rx6nq7g+I
	 Z4YGADE1utvo86K7C8mGq3AvAeE0iCJ9R1GozHBCQej9h/5kUxhnzH27StZlEJBXyg
	 5fq/WsC893YV8eOQcHWIFwJmnaio0ljNHnr2lGifbygRZQE0lQDHbdRUnBQdkJGtWm
	 sLdv/HCbVAk0eywgGBVhF0anUGlHajCypKtFawvQrMWdKWhSWY4jjHwGsCYJ5avSc0
	 Gc1cfGvS7qmlw==
Date: Tue, 25 Apr 2023 08:18:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dan.j.williams@intel.com, willy@infradead.org,
	akpm@linux-foundation.org
Subject: Re: [RFC PATCH v11.1 2/2] mm, pmem, xfs: Introduce MF_MEM_REMOVE for
 unbind
Message-ID: <20230425151800.GS360889@frogsfrogsfrogs>
References: <1679996506-2-3-git-send-email-ruansy.fnst@fujitsu.com>
 <1681296735-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <0a53ee26-5771-0808-ccdc-d1739c9dacac@fujitsu.com>
 <20230420120956.cdxcwojckiw36kfg@quack3>
 <d557c0cb-e244-6238-2df4-01ce75ededdf@fujitsu.com>
 <20230425132315.u5ocvbneeqzzbifl@quack3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230425132315.u5ocvbneeqzzbifl@quack3>

On Tue, Apr 25, 2023 at 03:23:15PM +0200, Jan Kara wrote:
> On Tue 25-04-23 20:47:35, Shiyang Ruan wrote:
> > 
> > 
> > 在 2023/4/20 20:09, Jan Kara 写道:
> > > On Thu 20-04-23 10:07:39, Shiyang Ruan wrote:
> > > > 在 2023/4/12 18:52, Shiyang Ruan 写道:
> > > > > This is a RFC HOTFIX.
> > > > > 
> > > > > This hotfix adds a exclusive forzen state to make sure any others won't
> > > > > thaw the fs during xfs_dax_notify_failure():
> > > > > 
> > > > >     #define SB_FREEZE_EXCLUSIVE	(SB_FREEZE_COMPLETE + 2)
> > > > > Using +2 here is because Darrick's patch[0] is using +1.  So, should we
> > > > > make these definitions global?
> > > > > 
> > > > > Another thing I can't make up my mind is: when another freezer has freeze
> > > > > the fs, should we wait unitl it finish, or print a warning in dmesg and
> > > > > return -EBUSY?
> > > > > 
> > > > > Since there are at least 2 places needs exclusive forzen state, I think
> > > > > we can refactor helper functions of freeze/thaw for them.  e.g.
> > > > >     int freeze_super_exclusive(struct super_block *sb, int frozen);
> > > > >     int thaw_super_exclusive(struct super_block *sb, int frozen);
> > > > > 
> > > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=repair-fscounters&id=c3a0d1de4d54ffb565dbc7092dfe1fb851940669
> > > 
> > > I'm OK with the idea of new freeze state that does not allow userspace to
> > > thaw the filesystem. But I don't really like the guts of filesystem
> > > freezing being replicated inside XFS. It is bad enough that they are
> > > replicated in [0], replicating them *once more* in another XFS file shows
> > > we are definitely doing something wrong. And Luis will need yet another
> > > incantation of the exlusive freeze for suspend-to-disk. So please guys get
> > > together and reorganize the generic freezing code so that it supports
> > > exclusive freeze (for in-kernel users) and works for your usecases instead
> > > of replicating it inside XFS...
> > 
> > I agree that too much replicating code is not good.  It's necessary to
> > create a generic exclusive freeze/thaw for all users.  But for me, I don't
> > have the confidence to do it well, because it requires good design and code
> > changes will involve other filesystems.  It's diffcult.
> > 
> > However, I hope to be able to make progress on this unbind feature. Thus, I
> > tend to refactor a common helper function for xfs first, and update the code
> > later when the generic freeze is done.
> 
> I think Darrick was thinking about working on a proper generic interface.
> So please coordinate with him.

I'll post a vfs generic kernelfreeze series later today.

One thing I haven't figured out yet is what's supposed to happen when
PREREMOVE is called on a frozen filesystem.  We don't want userspace to
be able to thaw the fs while PREREMOVE is running, so I /guess/ that
means we need some method for the kernel to take over a userspace
freeze and then put it back when we're done?

--D

> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

