Return-Path: <nvdimm+bounces-5804-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC3B69B054
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Feb 2023 17:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0229E280992
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Feb 2023 16:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C720D79F4;
	Fri, 17 Feb 2023 16:14:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCF379EC
	for <nvdimm@lists.linux.dev>; Fri, 17 Feb 2023 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KnUFNJfeceytXekVEZZ2PBZbloO4tvSDT1W02Zgchxk=; b=sGL6zNZAPMTbxDBefMd6fe8/U4
	zzDIyvHo90wFVvbrPONPZBoWqZ0GzWT/uRWXKepVKkZOiFLouYNH8bH+Nu99PS3ZzajtdQueVg0Z5
	pj/1Xhq9d3xl6fUQdnHIx5HtawVKRKzcRV6pn7PNanOGObCpYv4DYoBreTu8V1Rkj0z1vIYHyrwEE
	228Z7QatBHC7S1ho0GE/07cz/NsJ4tujgE2/ENftFosFupD6K0dFz3F0x7q+rUqUWcfhe1foBs4kK
	1gG/qp5BTx5I7Ekzxe46w3MP8frb7NQsujh33+Dya8GbrOiaendnwk0MBSyv1jZZ4ukUW4maTbDL2
	jTDtG0/w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pT3NX-009Rkh-24; Fri, 17 Feb 2023 16:14:31 +0000
Date: Fri, 17 Feb 2023 16:14:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
	hch@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH v10 2/3] fs: introduce super_drop_pagecache()
Message-ID: <Y++n53dzkCsH1qeK@casper.infradead.org>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>

On Fri, Feb 17, 2023 at 02:48:31PM +0000, Shiyang Ruan wrote:
> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
> -		iput(toput_inode);
> -		toput_inode = inode;
> -
> -		cond_resched();
> -		spin_lock(&sb->s_inode_list_lock);
> -	}
> -	spin_unlock(&sb->s_inode_list_lock);
> -	iput(toput_inode);
> +	super_drop_pagecache(sb, invalidate_inode_pages);

I thought I explained last time that you can do this with
invalidate_mapping_pages() / invalidate_inode_pages2_range() ?
Then you don't need to introduce invalidate_inode_pages().

> +void super_drop_pagecache(struct super_block *sb,
> +	int (*invalidator)(struct address_space *))

void super_drop_pagecache(struct super_block *sb,
		int (*invalidate)(struct address_space *, pgoff_t, pgoff_t))

> +		invalidator(inode->i_mapping);

		invalidate(inode->i_mapping, 0, -1)

... then all the changes to mm/truncate.c and filemap.h go away.

