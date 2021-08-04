Return-Path: <nvdimm+bounces-724-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50DB23DFBE6
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 09:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6C6B11C0AF7
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 07:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0121C2FAE;
	Wed,  4 Aug 2021 07:17:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF80F70
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 07:17:55 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9848460F14;
	Wed,  4 Aug 2021 07:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628061475;
	bh=IixKMnv4O7hFfMTSpcTjyF2I3jrmDmNM+Hc0Ua/fAa4=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=W0N6Ern1kdEGBDZDXf1v0GLERfwVGk7Qsy5BDmxec6IA4/IbQuXjXVAW6VT/RKCna
	 F60B1XcT1KX+i7uV1f/op4oUq4VUvHKTFLe33uDoZH41nCsct3f3SFnAh/78bel5cw
	 yT9/kWnUA6MG/G8UVsXrGIPwV2AsRBZvP8GoIGopGkOqXyBIS3YC4jLEGewFGHJM0n
	 2tkC1/4GGugGSowGBbqJuJmx2I5AgQGH4oaVXCiQqIcUZfHQE06LN+xCNpHgXDbryi
	 Ih2wD730zQSofvLkQpff2bYa4NSeOAHR/V4TzRgjESjPEo5/zpy1BCaGMLIe85TpWS
	 re0CC8d5+yGLg==
Subject: Re: [PATCH v2 3/3] erofs: convert all uncompressed cases to iomap
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Liu Bo <bo.liu@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Liu Jiang <gerry@linux.alibaba.com>, Huang Jianan <huangjianan@oppo.com>,
 Tao Ma <boyu.mt@taobao.com>
References: <20210730194625.93856-1-hsiangkao@linux.alibaba.com>
 <20210730194625.93856-4-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <76f9241e-5e7b-1de4-6cef-c92aa1de7498@kernel.org>
Date: Wed, 4 Aug 2021 15:17:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210730194625.93856-4-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2021/7/31 3:46, Gao Xiang wrote:
> Since tail-packing inline has been supported by iomap now, let's
> convert all EROFS uncompressed data I/O to iomap, which is pretty
> straight-forward.
> 
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>   fs/erofs/data.c | 288 ++++++++----------------------------------------
>   1 file changed, 49 insertions(+), 239 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 911521293b20..6b98156bb5ca 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -9,29 +9,6 @@
>   #include <linux/dax.h>
>   #include <trace/events/erofs.h>
>   
> -static void erofs_readendio(struct bio *bio)
> -{
> -	struct bio_vec *bvec;
> -	blk_status_t err = bio->bi_status;
> -	struct bvec_iter_all iter_all;
> -
> -	bio_for_each_segment_all(bvec, bio, iter_all) {
> -		struct page *page = bvec->bv_page;
> -
> -		/* page is already locked */
> -		DBG_BUGON(PageUptodate(page));
> -
> -		if (err)
> -			SetPageError(page);
> -		else
> -			SetPageUptodate(page);
> -
> -		unlock_page(page);
> -		/* page could be reclaimed now */
> -	}
> -	bio_put(bio);
> -}
> -
>   struct page *erofs_get_meta_page(struct super_block *sb, erofs_blk_t blkaddr)
>   {
>   	struct address_space *const mapping = sb->s_bdev->bd_inode->i_mapping;
> @@ -109,206 +86,6 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
>   	return err;
>   }
>   
> -static inline struct bio *erofs_read_raw_page(struct bio *bio,
> -					      struct address_space *mapping,
> -					      struct page *page,
> -					      erofs_off_t *last_block,
> -					      unsigned int nblocks,
> -					      unsigned int *eblks,
> -					      bool ra)
> -{
> -	struct inode *const inode = mapping->host;
> -	struct super_block *const sb = inode->i_sb;
> -	erofs_off_t current_block = (erofs_off_t)page->index;
> -	int err;
> -
> -	DBG_BUGON(!nblocks);
> -
> -	if (PageUptodate(page)) {
> -		err = 0;
> -		goto has_updated;
> -	}
> -
> -	/* note that for readpage case, bio also equals to NULL */
> -	if (bio &&
> -	    (*last_block + 1 != current_block || !*eblks)) {
> -submit_bio_retry:
> -		submit_bio(bio);
> -		bio = NULL;
> -	}
> -
> -	if (!bio) {
> -		struct erofs_map_blocks map = {
> -			.m_la = blknr_to_addr(current_block),
> -		};
> -		erofs_blk_t blknr;
> -		unsigned int blkoff;
> -
> -		err = erofs_map_blocks_flatmode(inode, &map, EROFS_GET_BLOCKS_RAW);
> -		if (err)
> -			goto err_out;
> -
> -		/* zero out the holed page */
> -		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
> -			zero_user_segment(page, 0, PAGE_SIZE);
> -			SetPageUptodate(page);
> -
> -			/* imply err = 0, see erofs_map_blocks */
> -			goto has_updated;
> -		}
> -
> -		/* for RAW access mode, m_plen must be equal to m_llen */
> -		DBG_BUGON(map.m_plen != map.m_llen);
> -
> -		blknr = erofs_blknr(map.m_pa);
> -		blkoff = erofs_blkoff(map.m_pa);
> -
> -		/* deal with inline page */
> -		if (map.m_flags & EROFS_MAP_META) {
> -			void *vsrc, *vto;
> -			struct page *ipage;
> -
> -			DBG_BUGON(map.m_plen > PAGE_SIZE);
> -
> -			ipage = erofs_get_meta_page(inode->i_sb, blknr);
> -
> -			if (IS_ERR(ipage)) {
> -				err = PTR_ERR(ipage);
> -				goto err_out;
> -			}
> -
> -			vsrc = kmap_atomic(ipage);
> -			vto = kmap_atomic(page);
> -			memcpy(vto, vsrc + blkoff, map.m_plen);
> -			memset(vto + map.m_plen, 0, PAGE_SIZE - map.m_plen);
> -			kunmap_atomic(vto);
> -			kunmap_atomic(vsrc);
> -			flush_dcache_page(page);
> -
> -			SetPageUptodate(page);
> -			/* TODO: could we unlock the page earlier? */
> -			unlock_page(ipage);
> -			put_page(ipage);
> -
> -			/* imply err = 0, see erofs_map_blocks */
> -			goto has_updated;
> -		}
> -
> -		/* pa must be block-aligned for raw reading */
> -		DBG_BUGON(erofs_blkoff(map.m_pa));
> -
> -		/* max # of continuous pages */
> -		if (nblocks > DIV_ROUND_UP(map.m_plen, PAGE_SIZE))
> -			nblocks = DIV_ROUND_UP(map.m_plen, PAGE_SIZE);
> -
> -		*eblks = bio_max_segs(nblocks);
> -		bio = bio_alloc(GFP_NOIO, *eblks);
> -
> -		bio->bi_end_io = erofs_readendio;
> -		bio_set_dev(bio, sb->s_bdev);
> -		bio->bi_iter.bi_sector = (sector_t)blknr <<
> -			LOG_SECTORS_PER_BLOCK;
> -		bio->bi_opf = REQ_OP_READ | (ra ? REQ_RAHEAD : 0);
> -	}
> -
> -	err = bio_add_page(bio, page, PAGE_SIZE, 0);
> -	/* out of the extent or bio is full */
> -	if (err < PAGE_SIZE)
> -		goto submit_bio_retry;
> -	--*eblks;
> -	*last_block = current_block;
> -	return bio;
> -
> -err_out:
> -	/* for sync reading, set page error immediately */
> -	if (!ra) {
> -		SetPageError(page);
> -		ClearPageUptodate(page);
> -	}
> -has_updated:
> -	unlock_page(page);
> -
> -	/* if updated manually, continuous pages has a gap */
> -	if (bio)
> -		submit_bio(bio);
> -	return err ? ERR_PTR(err) : NULL;
> -}
> -
> -/*
> - * since we dont have write or truncate flows, so no inode
> - * locking needs to be held at the moment.
> - */
> -static int erofs_raw_access_readpage(struct file *file, struct page *page)
> -{
> -	erofs_off_t last_block;
> -	unsigned int eblks;
> -	struct bio *bio;
> -
> -	trace_erofs_readpage(page, true);
> -
> -	bio = erofs_read_raw_page(NULL, page->mapping,
> -				  page, &last_block, 1, &eblks, false);
> -
> -	if (IS_ERR(bio))
> -		return PTR_ERR(bio);
> -
> -	if (bio)
> -		submit_bio(bio);
> -	return 0;
> -}
> -
> -static void erofs_raw_access_readahead(struct readahead_control *rac)
> -{
> -	erofs_off_t last_block;
> -	unsigned int eblks;
> -	struct bio *bio = NULL;
> -	struct page *page;
> -
> -	trace_erofs_readpages(rac->mapping->host, readahead_index(rac),
> -			readahead_count(rac), true);
> -
> -	while ((page = readahead_page(rac))) {
> -		prefetchw(&page->flags);
> -
> -		bio = erofs_read_raw_page(bio, rac->mapping, page, &last_block,
> -				readahead_count(rac), &eblks, true);
> -
> -		/* all the page errors are ignored when readahead */
> -		if (IS_ERR(bio)) {
> -			pr_err("%s, readahead error at page %lu of nid %llu\n",
> -			       __func__, page->index,
> -			       EROFS_I(rac->mapping->host)->nid);
> -
> -			bio = NULL;
> -		}
> -
> -		put_page(page);
> -	}
> -
> -	if (bio)
> -		submit_bio(bio);
> -}
> -
> -static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
> -{
> -	struct inode *inode = mapping->host;
> -	struct erofs_map_blocks map = {
> -		.m_la = blknr_to_addr(block),
> -	};
> -
> -	if (EROFS_I(inode)->datalayout == EROFS_INODE_FLAT_INLINE) {
> -		erofs_blk_t blks = i_size_read(inode) >> LOG_BLOCK_SIZE;
> -
> -		if (block >> LOG_SECTORS_PER_BLOCK >= blks)
> -			return 0;
> -	}
> -
> -	if (!erofs_map_blocks_flatmode(inode, &map, EROFS_GET_BLOCKS_RAW))
> -		return erofs_blknr(map.m_pa);
> -
> -	return 0;
> -}
> -
>   static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>   		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
>   {
> @@ -327,6 +104,7 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>   	iomap->offset = map.m_la;
>   	iomap->length = map.m_llen;
>   	iomap->flags = 0;
> +	iomap->private = NULL;
>   
>   	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
>   		iomap->type = IOMAP_HOLE;
> @@ -336,20 +114,61 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>   		return 0;
>   	}
>   
> -	/* that shouldn't happen for now */
>   	if (map.m_flags & EROFS_MAP_META) {
> -		DBG_BUGON(1);
> -		return -ENOTBLK;
> +		struct page *ipage;
> +
> +		iomap->type = IOMAP_INLINE;
> +		ipage = erofs_get_meta_page(inode->i_sb,
> +					    erofs_blknr(map.m_pa));

Error handling for erofs_get_meta_page()?

Thanks

> +		iomap->inline_data = page_address(ipage) +
> +					erofs_blkoff(map.m_pa);
> +		iomap->private = ipage;
> +	} else {
> +		iomap->type = IOMAP_MAPPED;
> +		iomap->addr = map.m_pa;
>   	}
> -	iomap->type = IOMAP_MAPPED;
> -	iomap->addr = map.m_pa;
>   	return 0;
>   }
>   
> +static int erofs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
> +		ssize_t written, unsigned flags, struct iomap *iomap)
> +{
> +	struct page *ipage = iomap->private;
> +
> +	if (ipage) {
> +		DBG_BUGON(iomap->type != IOMAP_INLINE);
> +		unlock_page(ipage);
> +		put_page(ipage);
> +	} else {
> +		DBG_BUGON(iomap->type == IOMAP_INLINE);
> +	}
> +	return written;
> +}
> +
>   const struct iomap_ops erofs_iomap_ops = {
>   	.iomap_begin = erofs_iomap_begin,
> +	.iomap_end = erofs_iomap_end,
>   };
>   
> +/*
> + * since we dont have write or truncate flows, so no inode
> + * locking needs to be held at the moment.
> + */
> +static int erofs_readpage(struct file *file, struct page *page)
> +{
> +	return iomap_readpage(page, &erofs_iomap_ops);
> +}
> +
> +static void erofs_readahead(struct readahead_control *rac)
> +{
> +	return iomap_readahead(rac, &erofs_iomap_ops);
> +}
> +
> +static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
> +{
> +	return iomap_bmap(mapping, block, &erofs_iomap_ops);
> +}
> +
>   static int erofs_prepare_dio(struct kiocb *iocb, struct iov_iter *to)
>   {
>   	struct inode *inode = file_inode(iocb->ki_filp);
> @@ -365,15 +184,6 @@ static int erofs_prepare_dio(struct kiocb *iocb, struct iov_iter *to)
>   
>   	if (align & blksize_mask)
>   		return -EINVAL;
> -
> -	/*
> -	 * Temporarily fall back tail-packing inline to buffered I/O instead
> -	 * since tail-packing inline support relies on an iomap core update.
> -	 */
> -	if (EROFS_I(inode)->datalayout == EROFS_INODE_FLAT_INLINE &&
> -	    iocb->ki_pos + iov_iter_count(to) >
> -			rounddown(inode->i_size, EROFS_BLKSIZ))
> -		return 1;
>   	return 0;
>   }
>   
> @@ -409,8 +219,8 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   
>   /* for uncompressed (aligned) files and raw access for other files */
>   const struct address_space_operations erofs_raw_access_aops = {
> -	.readpage = erofs_raw_access_readpage,
> -	.readahead = erofs_raw_access_readahead,
> +	.readpage = erofs_readpage,
> +	.readahead = erofs_readahead,
>   	.bmap = erofs_bmap,
>   	.direct_IO = noop_direct_IO,
>   };
> 

