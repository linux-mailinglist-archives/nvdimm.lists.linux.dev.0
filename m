Return-Path: <nvdimm+bounces-4728-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 639315B8EC1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Sep 2022 20:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0770B280C1D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Sep 2022 18:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE209441A;
	Wed, 14 Sep 2022 18:16:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640824403
	for <nvdimm@lists.linux.dev>; Wed, 14 Sep 2022 18:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D133C433C1;
	Wed, 14 Sep 2022 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663179406;
	bh=jXFOz1XVK5eWZZw6y6L5fljt3zc2+fxNH9PxNP+WsS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrv/a+EKivgV16U2LUPUSjAKCu880fbgBNkF74k9+hMyrgav6ctMMJgVUlbzAUXUj
	 V7v7mTGVo7+m8K4lmHi3aHXtjPSs20Y+v7ybhwm8pmZ5k0oZQ0qgcV0iGn4cMdjgJa
	 wcZ7TGgUm6d06N1HnkXTsvNky79zKZc1Ba13HcNGUS0x2wpmmvFlFPE7/NRKYPYZEb
	 W9xQI901oNKZXw+Xxlhtz9kHblgylfJd0bU+fAXbdBNxmQxc2LKnCQhoT5FXds7zJT
	 VxAdToZdETZr1yKkUg0aak3BFdx/c4SgYKEyCdaP1jmu2O0TgUdPHh7uFphzogA/k+
	 GApvPvvtZYfaA==
Date: Wed, 14 Sep 2022 11:16:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH 2/3] fs: move drop_pagecache_sb() for others to use
Message-ID: <YyIajcWz/h1k3kvq@magnolia>
References: <9e9521a4-6e07-e226-2814-b78a2451656b@fujitsu.com>
 <1662114961-66-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1662114961-66-3-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662114961-66-3-git-send-email-ruansy.fnst@fujitsu.com>

On Fri, Sep 02, 2022 at 10:36:00AM +0000, Shiyang Ruan wrote:
> xfs_notify_failure requires a method to invalidate all mappings.
> drop_pagecache_sb() can do this but it is a static function and only
> build with CONFIG_SYSCTL.  Now, move it to super.c and make it available
> for others.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/drop_caches.c   | 33 ---------------------------------
>  fs/super.c         | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |  1 +
>  3 files changed, 35 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index e619c31b6bd9..5c8406076f9b 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -3,7 +3,6 @@
>   * Implement the manual drop-all-pagecache function
>   */
>  
> -#include <linux/pagemap.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/fs.h>
> @@ -15,38 +14,6 @@
>  /* A global variable is a bit ugly, but it keeps the code simple */
>  int sysctl_drop_caches;
>  
> -static void drop_pagecache_sb(struct super_block *sb, void *unused)
> -{
> -	struct inode *inode, *toput_inode = NULL;
> -
> -	spin_lock(&sb->s_inode_list_lock);
> -	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -		spin_lock(&inode->i_lock);
> -		/*
> -		 * We must skip inodes in unusual state. We may also skip
> -		 * inodes without pages but we deliberately won't in case
> -		 * we need to reschedule to avoid softlockups.
> -		 */
> -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> -		    (mapping_empty(inode->i_mapping) && !need_resched())) {
> -			spin_unlock(&inode->i_lock);
> -			continue;
> -		}
> -		__iget(inode);
> -		spin_unlock(&inode->i_lock);
> -		spin_unlock(&sb->s_inode_list_lock);
> -
> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> -		iput(toput_inode);
> -		toput_inode = inode;
> -
> -		cond_resched();
> -		spin_lock(&sb->s_inode_list_lock);
> -	}
> -	spin_unlock(&sb->s_inode_list_lock);
> -	iput(toput_inode);
> -}
> -
>  int drop_caches_sysctl_handler(struct ctl_table *table, int write,
>  		void *buffer, size_t *length, loff_t *ppos)
>  {
> diff --git a/fs/super.c b/fs/super.c
> index 734ed584a946..bdf53dbe834c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -36,6 +36,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/user_namespace.h>
>  #include <linux/fs_context.h>
> +#include <linux/pagemap.h>
>  #include <uapi/linux/mount.h>
>  #include "internal.h"
>  
> @@ -677,6 +678,39 @@ void drop_super_exclusive(struct super_block *sb)
>  }
>  EXPORT_SYMBOL(drop_super_exclusive);
>  
> +void drop_pagecache_sb(struct super_block *sb, void *unused)
> +{
> +	struct inode *inode, *toput_inode = NULL;
> +
> +	spin_lock(&sb->s_inode_list_lock);
> +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		spin_lock(&inode->i_lock);
> +		/*
> +		 * We must skip inodes in unusual state. We may also skip
> +		 * inodes without pages but we deliberately won't in case
> +		 * we need to reschedule to avoid softlockups.
> +		 */
> +		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> +		    (mapping_empty(inode->i_mapping) && !need_resched())) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}
> +		__iget(inode);
> +		spin_unlock(&inode->i_lock);
> +		spin_unlock(&sb->s_inode_list_lock);
> +
> +		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> +		iput(toput_inode);
> +		toput_inode = inode;
> +
> +		cond_resched();
> +		spin_lock(&sb->s_inode_list_lock);
> +	}
> +	spin_unlock(&sb->s_inode_list_lock);
> +	iput(toput_inode);
> +}
> +EXPORT_SYMBOL(drop_pagecache_sb);

You might want to rename this "super_drop_pagecache" to fit with the
other functions that all have "super" in the name somewhere.

--D

> +
>  static void __iterate_supers(void (*f)(struct super_block *))
>  {
>  	struct super_block *sb, *p = NULL;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9eced4cc286e..5ded28c0d2c9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3292,6 +3292,7 @@ extern struct super_block *get_super(struct block_device *);
>  extern struct super_block *get_active_super(struct block_device *bdev);
>  extern void drop_super(struct super_block *sb);
>  extern void drop_super_exclusive(struct super_block *sb);
> +void drop_pagecache_sb(struct super_block *sb, void *unused);
>  extern void iterate_supers(void (*)(struct super_block *, void *), void *);
>  extern void iterate_supers_type(struct file_system_type *,
>  			        void (*)(struct super_block *, void *), void *);
> -- 
> 2.37.2
> 

