Return-Path: <nvdimm+bounces-6899-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CAE7E532C
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Nov 2023 11:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FFB51C20AF8
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Nov 2023 10:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950D610A2F;
	Wed,  8 Nov 2023 10:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ym8T05T8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qLxBvJig"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8963210A06
	for <nvdimm@lists.linux.dev>; Wed,  8 Nov 2023 10:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0286D1F45A;
	Wed,  8 Nov 2023 10:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1699438519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nBa+FLt1HNfPvl1vLM5je/FvvKMWJOjySfB3IYTCWLI=;
	b=ym8T05T88JVyuTK0E9fN8LvBtecEb7dkyx4weR6s00GbcDO2DnrM61QSKaVsx8FJIYGsvB
	r5JXi64ErMmRC9KZsLaKOjZJnOSUQZbnTD8lYmV9K5QDSxwzkbeEfcf7jiJO+OrDLTi4Ok
	NQ1VFf0l5833ms0CFR67d/FsqiufpYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1699438519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nBa+FLt1HNfPvl1vLM5je/FvvKMWJOjySfB3IYTCWLI=;
	b=qLxBvJig27eBx0p0iaOO0LrVHq+CRcfaSAmCNE717BS17UsUoI6BYHZu+v1j54G7l7GB8H
	iiad8huONmHzL7DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E89F3133F5;
	Wed,  8 Nov 2023 10:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id G4G4OLZfS2WkaAAAMHmgww
	(envelope-from <jack@suse.cz>); Wed, 08 Nov 2023 10:15:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7A4C6A07C0; Wed,  8 Nov 2023 11:15:18 +0100 (CET)
Date: Wed, 8 Nov 2023 11:15:18 +0100
From: Jan Kara <jack@suse.cz>
To: Abhinav Singh <singhabhinav9051571833@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, dan.j.williams@intel.com,
	willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] fs : Fix warning using plain integer as NULL
Message-ID: <20231108101518.e4nriftavrhw45xk@quack3>
References: <20231108044550.1006555-1-singhabhinav9051571833@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108044550.1006555-1-singhabhinav9051571833@gmail.com>

On Wed 08-11-23 10:15:50, Abhinav Singh wrote:
> Sparse static analysis tools generate a warning with this message
> "Using plain integer as NULL pointer". In this case this warning is
> being shown because we are trying to initialize  pointer to NULL using
> integer value 0.
> 
> Signed-off-by: Abhinav Singh <singhabhinav9051571833@gmail.com>

Nice cleanup. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>
								Honza

> ---
>  fs/dax.c       | 2 +-
>  fs/direct-io.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 3380b43cb6bb..423fc1607dfa 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1128,7 +1128,7 @@ static int dax_iomap_copy_around(loff_t pos, uint64_t length, size_t align_size,
>  	/* zero the edges if srcmap is a HOLE or IOMAP_UNWRITTEN */
>  	bool zero_edge = srcmap->flags & IOMAP_F_SHARED ||
>  			 srcmap->type == IOMAP_UNWRITTEN;
> -	void *saddr = 0;
> +	void *saddr = NULL;
>  	int ret = 0;
>  
>  	if (!zero_edge) {
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 20533266ade6..60456263a338 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1114,7 +1114,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
>  	loff_t offset = iocb->ki_pos;
>  	const loff_t end = offset + count;
>  	struct dio *dio;
> -	struct dio_submit sdio = { 0, };
> +	struct dio_submit sdio = { NULL, };
>  	struct buffer_head map_bh = { 0, };
>  	struct blk_plug plug;
>  	unsigned long align = offset | iov_iter_alignment(iter);
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

