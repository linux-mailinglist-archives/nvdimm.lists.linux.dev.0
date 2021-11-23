Return-Path: <nvdimm+bounces-2029-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAC045AF82
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 23:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 675E03E1030
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 22:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAF12C96;
	Tue, 23 Nov 2021 22:54:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF772C81
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 22:54:31 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7AF60F5D;
	Tue, 23 Nov 2021 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1637708071;
	bh=NYkX8UHWeP1OEOzoKcmsOPU82GrKW5S4+IZ7T4iz94Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXMKf7yMwweCOKAzEhfZayDcajvP1O2UdSzRfQBzFDtkQ3b0NxAgePyY/ApKecqJS
	 QRl27OUtt8ygRdblDJxy//OCChxugex79UUdvMS9oPEY+UZnvM0n5uyVIcFA+Od7qH
	 S9NBv+1Lq4LHL1ydTCM3aS1U3cu0vCnmWNqiAkrtW71TSqXMBfB9Rmco6uRNZ+fTYq
	 AAyj38T84Zwq5VWYOhQdTQ72iFh3otPvctyg1hmLpjJEyn1+JrWa3ODOQwQN+ImZVJ
	 17HF6GW5sXzvWbqvXiEKycV9D8L76owqYREgiKs6ah7AFzGd2OAahNhBKJ4ki8RsHw
	 5IqICgEUzZAUw==
Date: Tue, 23 Nov 2021 14:54:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 20/29] ext4: cleanup the dax handling in ext4_fill_super
Message-ID: <20211123225430.GN266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
 <20211109083309.584081-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083309.584081-21-hch@lst.de>

On Tue, Nov 09, 2021 at 09:33:00AM +0100, Christoph Hellwig wrote:
> Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
> the need for the dax_dev local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ext4/super.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index eb4df43abd76e..b60401bb1c310 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3879,7 +3879,6 @@ static void ext4_setup_csum_trigger(struct super_block *sb,
>  
>  static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  {
> -	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
>  	char *orig_data = kstrdup(data, GFP_KERNEL);
>  	struct buffer_head *bh, **group_desc;
>  	struct ext4_super_block *es = NULL;
> @@ -3910,12 +3909,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if ((data && !orig_data) || !sbi)
>  		goto out_free_base;
>  
> -	sbi->s_daxdev = dax_dev;
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
>  	if (!sbi->s_blockgroup_lock)
>  		goto out_free_base;
>  
> +	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb = sb;
>  	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
> @@ -4300,7 +4299,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		goto failed_mount;
>  	}
>  
> -	if (dax_dev) {
> +	if (sbi->s_daxdev) {
>  		if (blocksize == PAGE_SIZE)
>  			set_bit(EXT4_FLAGS_BDEV_IS_DAX, &sbi->s_ext4_flags);
>  		else
> @@ -5096,10 +5095,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  out_fail:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
> +	fs_put_dax(sbi->s_daxdev );

Nit: no space before the paren  ^ here.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  out_free_base:
>  	kfree(sbi);
>  	kfree(orig_data);
> -	fs_put_dax(dax_dev);
>  	return err ? err : ret;
>  }
>  
> -- 
> 2.30.2
> 

