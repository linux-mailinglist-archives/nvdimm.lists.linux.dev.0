Return-Path: <nvdimm+bounces-5954-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED496EEC6E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 26 Apr 2023 04:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9DCF280B41
	for <lists+linux-nvdimm@lfdr.de>; Wed, 26 Apr 2023 02:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A480139E;
	Wed, 26 Apr 2023 02:37:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6905610FF
	for <nvdimm@lists.linux.dev>; Wed, 26 Apr 2023 02:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C95CC433EF;
	Wed, 26 Apr 2023 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682476636;
	bh=QQLblGEacILjgXIqymBXeQ4m3vNonM/22q1B7+2JnGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BHhTcAN+ORMlfpnk+1ZdNmVfn8moJOuGjhJ4EckwYW54v+bnGgqi31edzuZY9xhEA
	 JIyakRbNkSiKZVz74XnX79GcAqHYxriZeBa6fMi3CkuNXs75Mc5Cry3MyRJDlPAiaI
	 2N3jgFFjuRO1DMJKiMwGir9l3Zc1Nupk0NVnzdeVWmtcjQb2Q+bj6QcWGeRGKweOxq
	 mw9nfMTZb10fqpbnIiVt0nznvcu7i+0FbSoQ4R+TzI4Lc0l6o85CppunfmOYNMZZjf
	 mv6BlL3nPhPO+x/eJ1HA2o7YI0AjdPNLMtIMl7C2YqVByDjn5OMVGe8z+5DZ1zzCF8
	 wR31niEr0w4lA==
Date: Tue, 25 Apr 2023 19:37:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Jan Kara <jack@suse.cz>, Luis Chamberlain <mcgrof@kernel.org>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	dan.j.williams@intel.com, willy@infradead.org,
	akpm@linux-foundation.org
Subject: Re: [RFC PATCH v11.1 2/2] mm, pmem, xfs: Introduce MF_MEM_REMOVE for
 unbind
Message-ID: <20230426023715.GA59245@frogsfrogsfrogs>
References: <1679996506-2-3-git-send-email-ruansy.fnst@fujitsu.com>
 <1681296735-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <0a53ee26-5771-0808-ccdc-d1739c9dacac@fujitsu.com>
 <20230420120956.cdxcwojckiw36kfg@quack3>
 <d557c0cb-e244-6238-2df4-01ce75ededdf@fujitsu.com>
 <20230425132315.u5ocvbneeqzzbifl@quack3>
 <20230425151800.GS360889@frogsfrogsfrogs>
 <baabaf6d-151b-9667-c766-bf3e89b085cb@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baabaf6d-151b-9667-c766-bf3e89b085cb@fujitsu.com>

On Wed, Apr 26, 2023 at 10:27:43AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/4/25 23:18, Darrick J. Wong 写道:
> > On Tue, Apr 25, 2023 at 03:23:15PM +0200, Jan Kara wrote:
> > > On Tue 25-04-23 20:47:35, Shiyang Ruan wrote:
> > > > 
> > > > 
> > > > 在 2023/4/20 20:09, Jan Kara 写道:
> > > > > On Thu 20-04-23 10:07:39, Shiyang Ruan wrote:
> > > > > > 在 2023/4/12 18:52, Shiyang Ruan 写道:
> > > > > > > This is a RFC HOTFIX.
> > > > > > > 
> > > > > > > This hotfix adds a exclusive forzen state to make sure any others won't
> > > > > > > thaw the fs during xfs_dax_notify_failure():
> > > > > > > 
> > > > > > >      #define SB_FREEZE_EXCLUSIVE	(SB_FREEZE_COMPLETE + 2)
> > > > > > > Using +2 here is because Darrick's patch[0] is using +1.  So, should we
> > > > > > > make these definitions global?
> > > > > > > 
> > > > > > > Another thing I can't make up my mind is: when another freezer has freeze
> > > > > > > the fs, should we wait unitl it finish, or print a warning in dmesg and
> > > > > > > return -EBUSY?
> > > > > > > 
> > > > > > > Since there are at least 2 places needs exclusive forzen state, I think
> > > > > > > we can refactor helper functions of freeze/thaw for them.  e.g.
> > > > > > >      int freeze_super_exclusive(struct super_block *sb, int frozen);
> > > > > > >      int thaw_super_exclusive(struct super_block *sb, int frozen);
> > > > > > > 
> > > > > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=repair-fscounters&id=c3a0d1de4d54ffb565dbc7092dfe1fb851940669
> > > > > 
> > > > > I'm OK with the idea of new freeze state that does not allow userspace to
> > > > > thaw the filesystem. But I don't really like the guts of filesystem
> > > > > freezing being replicated inside XFS. It is bad enough that they are
> > > > > replicated in [0], replicating them *once more* in another XFS file shows
> > > > > we are definitely doing something wrong. And Luis will need yet another
> > > > > incantation of the exlusive freeze for suspend-to-disk. So please guys get
> > > > > together and reorganize the generic freezing code so that it supports
> > > > > exclusive freeze (for in-kernel users) and works for your usecases instead
> > > > > of replicating it inside XFS...
> > > > 
> > > > I agree that too much replicating code is not good.  It's necessary to
> > > > create a generic exclusive freeze/thaw for all users.  But for me, I don't
> > > > have the confidence to do it well, because it requires good design and code
> > > > changes will involve other filesystems.  It's diffcult.
> > > > 
> > > > However, I hope to be able to make progress on this unbind feature. Thus, I
> > > > tend to refactor a common helper function for xfs first, and update the code
> > > > later when the generic freeze is done.
> > > 
> > > I think Darrick was thinking about working on a proper generic interface.
> > > So please coordinate with him.
> > 
> > I'll post a vfs generic kernelfreeze series later today.
> > 
> > One thing I haven't figured out yet is what's supposed to happen when
> > PREREMOVE is called on a frozen filesystem.
> 
> call PREREMOVE when:
> 1. freezed by kernel:    we wait unitl kernel thaws -> not sure
> 2. freezed by userspace: we take over the control of freeze state:
>      a. userspace can't thaw before PREREMOVE is done
>      b. kernel keeps freeze state after PREREMOVE is done and before
> userspace thaws
> 
> Since the unbind interface doesn't return any other errcode except -ENODEV,
> the only thing I can think of to do is wait for the other one done?  If
> another one doesn't thaw after a long time waitting, we print a "waitting
> too long" warning in dmesg.  But I'm not sure if this is good.
> 
> > We don't want userspace to
> > be able to thaw the fs while PREREMOVE is running, so I /guess/ that
> > means we need some method for the kernel to take over a userspace
> > freeze and then put it back when we're done?
> 
> As is designed by Luis, we can add sb->s_writers.frozen_by_user flag to
> distinguish whether current freeze state is initiated by kernel or
> userspace.  In his patch, userspace can take over kernel's freeze.  We just
> need to switch the order.

<nod> How does this patchset
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=a97da76ed5256d692a02ece01b4032dbf68cbf89
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=93310faf77480265b3bc784f6883f5af9ccfce3b
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=a68cea1aa317775046372840ee4f0ba5bdb75d9f

strike you?

I think for #2 above I could write a freeze_super_excl variant that
turns a userspace freeze into a kernel freeze, and a thaw_super_excl
variant that changes it back.

--D

> 
> 
> --
> Thanks,
> Ruan.
> 
> > 
> > --D
> > 
> > > 								Honza
> > > 
> > > -- 
> > > Jan Kara <jack@suse.com>
> > > SUSE Labs, CR

