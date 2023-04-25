Return-Path: <nvdimm+bounces-5951-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F6F6EE301
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Apr 2023 15:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3061280BEA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Apr 2023 13:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1604C65;
	Tue, 25 Apr 2023 13:30:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F27B
	for <nvdimm@lists.linux.dev>; Tue, 25 Apr 2023 13:30:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 74FB91FD9D;
	Tue, 25 Apr 2023 13:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1682428996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q2T/Y7qFdCUy3re4ctXa9sRrn9+mZ7IugqZ9aq6o34k=;
	b=H5RfPmr5xbyO42qx+ZpGkRUj4c5qyh3489DrJZCn0bCZCHarr9ITUocACe2p9hpNO4DjSS
	I3z5Mo9Scj2JMheTyoFt4x5R1/Qn79qJ3eUzSMfYiOmEpEXjQi1GRNYfGXNs0dZcIA1kSj
	Z6PSBP3KAuGFl2cD/TbSR4YODdQbzwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1682428996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q2T/Y7qFdCUy3re4ctXa9sRrn9+mZ7IugqZ9aq6o34k=;
	b=3CbBzZyWb+srmnqcSy2+VdX9IAWZmiyyj1hNABq5DBj/WsGr2Y+J12K9Mqh+LOIqmTzs3m
	dRxsR5GpIV4WdPBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6633713466;
	Tue, 25 Apr 2023 13:23:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Jw3kGETUR2S8EwAAMHmgww
	(envelope-from <jack@suse.cz>); Tue, 25 Apr 2023 13:23:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EE3D9A0729; Tue, 25 Apr 2023 15:23:15 +0200 (CEST)
Date: Tue, 25 Apr 2023 15:23:15 +0200
From: Jan Kara <jack@suse.cz>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Jan Kara <jack@suse.cz>, djwong@kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dan.j.williams@intel.com, willy@infradead.org,
	akpm@linux-foundation.org
Subject: Re: [RFC PATCH v11.1 2/2] mm, pmem, xfs: Introduce MF_MEM_REMOVE for
 unbind
Message-ID: <20230425132315.u5ocvbneeqzzbifl@quack3>
References: <1679996506-2-3-git-send-email-ruansy.fnst@fujitsu.com>
 <1681296735-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <0a53ee26-5771-0808-ccdc-d1739c9dacac@fujitsu.com>
 <20230420120956.cdxcwojckiw36kfg@quack3>
 <d557c0cb-e244-6238-2df4-01ce75ededdf@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d557c0cb-e244-6238-2df4-01ce75ededdf@fujitsu.com>

On Tue 25-04-23 20:47:35, Shiyang Ruan wrote:
> 
> 
> 在 2023/4/20 20:09, Jan Kara 写道:
> > On Thu 20-04-23 10:07:39, Shiyang Ruan wrote:
> > > 在 2023/4/12 18:52, Shiyang Ruan 写道:
> > > > This is a RFC HOTFIX.
> > > > 
> > > > This hotfix adds a exclusive forzen state to make sure any others won't
> > > > thaw the fs during xfs_dax_notify_failure():
> > > > 
> > > >     #define SB_FREEZE_EXCLUSIVE	(SB_FREEZE_COMPLETE + 2)
> > > > Using +2 here is because Darrick's patch[0] is using +1.  So, should we
> > > > make these definitions global?
> > > > 
> > > > Another thing I can't make up my mind is: when another freezer has freeze
> > > > the fs, should we wait unitl it finish, or print a warning in dmesg and
> > > > return -EBUSY?
> > > > 
> > > > Since there are at least 2 places needs exclusive forzen state, I think
> > > > we can refactor helper functions of freeze/thaw for them.  e.g.
> > > >     int freeze_super_exclusive(struct super_block *sb, int frozen);
> > > >     int thaw_super_exclusive(struct super_block *sb, int frozen);
> > > > 
> > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=repair-fscounters&id=c3a0d1de4d54ffb565dbc7092dfe1fb851940669
> > 
> > I'm OK with the idea of new freeze state that does not allow userspace to
> > thaw the filesystem. But I don't really like the guts of filesystem
> > freezing being replicated inside XFS. It is bad enough that they are
> > replicated in [0], replicating them *once more* in another XFS file shows
> > we are definitely doing something wrong. And Luis will need yet another
> > incantation of the exlusive freeze for suspend-to-disk. So please guys get
> > together and reorganize the generic freezing code so that it supports
> > exclusive freeze (for in-kernel users) and works for your usecases instead
> > of replicating it inside XFS...
> 
> I agree that too much replicating code is not good.  It's necessary to
> create a generic exclusive freeze/thaw for all users.  But for me, I don't
> have the confidence to do it well, because it requires good design and code
> changes will involve other filesystems.  It's diffcult.
> 
> However, I hope to be able to make progress on this unbind feature. Thus, I
> tend to refactor a common helper function for xfs first, and update the code
> later when the generic freeze is done.

I think Darrick was thinking about working on a proper generic interface.
So please coordinate with him.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

