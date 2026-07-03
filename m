Return-Path: <nvdimm+bounces-14762-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id SnQXI6KSR2qjbQAAu9opvQ
	(envelope-from <nvdimm+bounces-14762-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 03 Jul 2026 12:44:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F23BE7015DD
	for <lists+linux-nvdimm@lfdr.de>; Fri, 03 Jul 2026 12:44:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8LzFtRD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14762-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14762-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4132F30985FE
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jul 2026 10:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CE03C2BA2;
	Fri,  3 Jul 2026 10:37:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC913161A4;
	Fri,  3 Jul 2026 10:37:27 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075048; cv=none; b=NBkBuqmD3Z5C6dTQsW77a+YcJFPPOziPoA3ob4nzYFi0JXEIw8x2g9QYDQmozRLcLVEA0UJGuHjbeCObklCztB8zGF1djZxm3mAj3mTlR9BmgBVbwzmjfhW2VoAYsaSveP50I99WnYb+0O/azEyB85v2gFiRxUEHMbc4w5uyiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075048; c=relaxed/simple;
	bh=d4s4dMLniDIuK4LTsTNvbrHzQ5sC7wrFJBhb2lMg/u0=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=hzO8GDLQc6WIhHSjeerGPh7k8fUjKV3P+oVBPa2o1gs+zNEJx+gYtkqBlQQ5HUpwLj+7mv44jiOXvB/4BAY5MGZeeyRc4VvUXBxU5NC1yv16WkrII7ia2zP+UU3CK1ipCkODCRnJj6SEesA7ax/OBI8S6aVfKX1GgUs4K/JiFvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8LzFtRD; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CFA1F000E9;
	Fri,  3 Jul 2026 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075047;
	bh=ibq5yGoOYYUKiAiXchC0WA0gL3l+/26cw0R84LkFjaY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=W8LzFtRDEJ+LA4ga+f6QzIP5wIjhPrvbgSkeN5H9fdUp8ldRpYac+VP2pbFWqLIaZ
	 VOZRYcIErzh7ZZVI1opgKNPyPdXZNYzLlXZRZvIfpIEGsP8CRSvmh6dp1f1DUAQ8eT
	 REmssNKn6FgP95Nylwk1jyDskOejoq/ZtxJV6+SZMcueW6AmnmkTRlSc0afIY2ZaY4
	 0j6EQgUmekHKxLsbkP1RtsOiATrm0qsMc/rLKl6p2+xyg60HQXm8THGcRmHmGEbsA5
	 +KIVTrOUxI8EdD77tZ08aAlBNDaVgctnhdPNMu6u++MTrLUeeidjuDh4Pwu7QdGwKu
	 L34A4eoQ9xeiA==
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 brauner@kernel.org, willy@infradead.org, hsiangkao@linux.alibaba.com, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
 open list <linux-kernel@vger.kernel.org>, 
 "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
 "open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
 "open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
 "open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
 "open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
 "open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
 "open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, 
 "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
In-Reply-To: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de> <20260702165117.GK9392@frogsfrogsfrogs>
 <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Date: Fri, 03 Jul 2026 12:37:14 +0200
Message-Id: <20260703-nachrangig-gegeben-befestigen-8219a53648c7@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d4s4dMLniDIuK4LTsTNvbrHzQ5sC7wrFJBhb2lMg/u0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5T7iz7fS6t1kzwm8fcparv3KDyXRbpMKKF15fNPbwT
 dVe5OMk1lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRtgxGhmMbHf76zT147eA7
 nZiMnzu9Q+v+PNtl5pjYUP6f6/XP/z8YGe7siubVVw14xJBz7G+cn2VOrNK0S08/rfgQ3Ddj8wq
 eCi4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Action: no action
X-Spamd-Result: default: False [3.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-14762-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:joannelkoong@gmail.com,m:djwong@kernel.org,m:hch@lst.de,m:brauner@kernel.org,m:willy@infradead.org,m:hsiangkao@linux.alibaba.com,m:linux-fsdevel@vger.kernel.org,m:linux-xfs@vger.kernel.org,m:axboe@kernel.dk,m:clm@fb.com,m:dsterba@suse.com,m:viro@zeniv.linux.org.uk,m:jack@suse.cz,m:djbw@kernel.org,m:xiang@kernel.org,m:chao@kernel.org,m:zbestahu@gmail.com,m:jefflexu@linux.alibaba.com,m:dhavale@google.com,m:lihongbo22@huawei.com,m:guochunhai@vivo.com,m:linkinjeon@kernel.org,m:sj1557.seo@samsung.com,m:yuezhang.mo@sony.com,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:miklos@szeredi.hu,m:agruenba@redhat.com,m:mikulas@artax.karlin.mff.cuni.cz,m:hyc.lee@gmail.com,m:almaz.alexandrovich@paragon-software.com,m:cem@kernel.org,m:dlemoal@kernel.org,m:naohiro.aota@wdc.com,m:jth@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:lin
 ux-btrfs@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-erofs@lists.ozlabs.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:fuse-devel@lists.linux.dev,m:gfs2@lists.linux.dev,m:ntfs3@lists.linux.dev,m:riteshlist@gmail.com,m:hyclee@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[brauner@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[50];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,nvdimm@lists.linux.dev];
	FREEMAIL_CC(0.00)[kernel.org,lst.de,infradead.org,linux.alibaba.com,vger.kernel.org,kernel.dk,fb.com,suse.com,zeniv.linux.org.uk,suse.cz,gmail.com,google.com,huawei.com,vivo.com,samsung.com,sony.com,mit.edu,dilger.ca,linux.ibm.com,szeredi.hu,redhat.com,artax.karlin.mff.cuni.cz,paragon-software.com,wdc.com,lists.linux.dev,lists.ozlabs.org,lists.sourceforge.net];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brauner:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:email,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F23BE7015DD

On 2026-07-02 18:47 -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 9:51 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > > Looks good:
> > >
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > >
> > > In terms of merge logistics, I wonder if we should delay this and
> > > the previous patch to the next merge window so that we can minimize the
> > > cross-subsystem merge pain with more file system iomap conversion.
> > > If none of them actually happen until rc6 or so, orif  the merges aren't
> > > painful we could still pick them up late in the merge window.
> >
> > I'd say everything but this patch should go in during the merge window
> > for 7.3, along with clear instructions to brauner/torvalds to expect
> > this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> > the other changes that come in.
> 
> Just to clarify, did you mean this patch and the previous one? If i'm
> interpreting Christoph's concern correctly, I think he's worried about
> other filesystems converting to iomap using the ->iomap_begin() /
> ->iomap_end() functions still? That sounds like a good plan to me, for
> v3 I'll submit everything but this patch and the last one and then

Ok, so we'll do the prep for vfs-7.3.iomap (aka to be merged in the
v7.3-rc1 cycle)...

> submit these patches (and any cleanup ones that become necessary) to
> Christian right before 7.3-rc1 gets tagged (which as I understand it,
> is when the merge window is about to close).

and merge these _after_ v7.3-rc1 has been tagged...


