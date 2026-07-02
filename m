Return-Path: <nvdimm+bounces-14755-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id B7J6G0SlRmqiawsAu9opvQ
	(envelope-from <nvdimm+bounces-14755-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 02 Jul 2026 19:52:04 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FACD6FBAD0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 02 Jul 2026 19:52:03 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ymepa36T;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14755-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14755-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 32FCE3143279
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Jul 2026 16:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D04381EA9;
	Thu,  2 Jul 2026 16:51:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193F9317146;
	Thu,  2 Jul 2026 16:51:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011079; cv=none; b=aoztfLET7ZB9xbDTxc7Rdgxmm3J1IinhQ/x8XiBgVxMBm+s5DsfhHM1N2Q2bqvDsl/qRmvWJWE3HcXxDszdkG20+FOSr1bnZLlPUeHziU31nj6QdzMQq8E9mOd6ypXFeUgI5612YQf6f6EmktkNktc7krhyxDepsJvMS1p3tqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011079; c=relaxed/simple;
	bh=biYNUAbSLkMakBI2InMvj+slMvc5J5VSiUpkwej/21U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rM8CmaCCNP/7TloF7PDZGL9YjQeXPeyW2QBOBCLoLVRWMx6yIffy27XauQzN80+3Vj05Fo37lGrflmo8/bfl1JGeqDnsmAl4aFMBzMUAD0Whgz9u9fSo5rvkqXHVG60QddQKz2d0qT/QOO2thQtk2BbNCoinZtz1vWkM4cLWR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ymepa36T; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D15C81F000E9;
	Thu,  2 Jul 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011078;
	bh=ydgqm4JLD9wHorHnF+2XAPjVnBLFS4UbABn2TMKW9lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ymepa36TovSJKNYZV3u+xpDtmvDD0jgD8tu6oITOhStEqSB4dFm2GSNjYvX6a/XhD
	 idd1sj/Z9E/KlApdD9cMjRLqTlqdgS1ZGfahdEB1adsC1jHUM18Idy2FDJdP+91o7q
	 QlYswMBkWSAqfhgV/t0BjA2QDKkEneDGjH+Gl5qKC5w3Z9fiVXFpsrFrRHn8BhtWaG
	 lcACOAbDkojouQsXQtSoi47LOb5OGkLJW+AXDJEZT+ElhlEosUQhZ2/nNXhEJR9+aI
	 PyMC3eJrsnz1BJ5WVFaLKabv6f9zwLwtBLpgZ7fU4xVDkd9t8o3JJ3wtYAC95RX0Zj
	 PrPeMRFBP/AuA==
Date: Thu, 2 Jul 2026 09:51:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
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
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
Message-ID: <20260702165117.GK9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702140705.GE21339@lst.de>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:joannelkoong@gmail.com,m:brauner@kernel.org,m:willy@infradead.org,m:hsiangkao@linux.alibaba.com,m:linux-fsdevel@vger.kernel.org,m:linux-xfs@vger.kernel.org,m:axboe@kernel.dk,m:clm@fb.com,m:dsterba@suse.com,m:viro@zeniv.linux.org.uk,m:jack@suse.cz,m:djbw@kernel.org,m:xiang@kernel.org,m:chao@kernel.org,m:zbestahu@gmail.com,m:jefflexu@linux.alibaba.com,m:dhavale@google.com,m:lihongbo22@huawei.com,m:guochunhai@vivo.com,m:linkinjeon@kernel.org,m:sj1557.seo@samsung.com,m:yuezhang.mo@sony.com,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:miklos@szeredi.hu,m:agruenba@redhat.com,m:mikulas@artax.karlin.mff.cuni.cz,m:hyc.lee@gmail.com,m:almaz.alexandrovich@paragon-software.com,m:cem@kernel.org,m:dlemoal@kernel.org,m:naohiro.aota@wdc.com,m:jth@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-btrfs@vger.kernel
 .org,m:nvdimm@lists.linux.dev,m:linux-erofs@lists.ozlabs.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:fuse-devel@lists.linux.dev,m:gfs2@lists.linux.dev,m:ntfs3@lists.linux.dev,m:riteshlist@gmail.com,m:hyclee@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[djwong@kernel.org,nvdimm@lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[49];
	TAGGED_FROM(0.00)[bounces-14755-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,nvdimm@lists.linux.dev];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,infradead.org,linux.alibaba.com,vger.kernel.org,kernel.dk,fb.com,suse.com,zeniv.linux.org.uk,suse.cz,google.com,huawei.com,vivo.com,samsung.com,sony.com,mit.edu,dilger.ca,linux.ibm.com,szeredi.hu,redhat.com,artax.karlin.mff.cuni.cz,paragon-software.com,wdc.com,lists.linux.dev,lists.ozlabs.org,lists.sourceforge.net];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5FACD6FBAD0

On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> In terms of merge logistics, I wonder if we should delay this and
> the previous patch to the next merge window so that we can minimize the
> cross-subsystem merge pain with more file system iomap conversion.
> If none of them actually happen until rc6 or so, orif  the merges aren't
> painful we could still pick them up late in the merge window.

I'd say everything but this patch should go in during the merge window
for 7.3, along with clear instructions to brauner/torvalds to expect
this patch to appear right before 7.3-rc1 gets tagged, to clean up all
the other changes that come in.

--D

