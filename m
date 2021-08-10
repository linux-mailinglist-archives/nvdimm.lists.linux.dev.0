Return-Path: <nvdimm+bounces-701-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 4492C3DFA6D
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 06:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 15BDE3E0F71
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 04:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3442FAE;
	Wed,  4 Aug 2021 04:30:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com [47.88.44.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A640F70
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:30:53 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UhwJ.LP_1628051435;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UhwJ.LP_1628051435)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 Aug 2021 12:30:37 +0800
Date: Wed, 4 Aug 2021 12:30:35 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Chao Yu <chao@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Liu Bo <bo.liu@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Liu Jiang <gerry@linux.alibaba.com>,
	Huang Jianan <huangjianan@oppo.com>, Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH v2 1/3] erofs: iomap support for non-tailpacking DIO
Message-ID: <YQoX62zRERGX9BGB@B-P7TQMD6M-0146.local>
Mail-Followup-To: Chao Yu <chao@kernel.org>, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Liu Bo <bo.liu@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Liu Jiang <gerry@linux.alibaba.com>,
	Huang Jianan <huangjianan@oppo.com>, Tao Ma <boyu.mt@taobao.com>
References: <20210730194625.93856-1-hsiangkao@linux.alibaba.com>
 <20210730194625.93856-2-hsiangkao@linux.alibaba.com>
 <e79e3261-e582-e848-b550-c0c3163d9af4@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e79e3261-e582-e848-b550-c0c3163d9af4@kernel.org>

Hi Chao,

On Wed, Aug 04, 2021 at 10:57:08AM +0800, Chao Yu wrote:
> On 2021/7/31 3:46, Gao Xiang wrote:

...

> >   }
> > +static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> > +		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
> > +{
> > +	int ret;
> > +	struct erofs_map_blocks map;
> > +
> > +	map.m_la = offset;
> > +	map.m_llen = length;
> > +
> > +	ret = erofs_map_blocks_flatmode(inode, &map, EROFS_GET_BLOCKS_RAW);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	iomap->bdev = inode->i_sb->s_bdev;
> > +	iomap->offset = map.m_la;
> > +	iomap->length = map.m_llen;
> > +	iomap->flags = 0;
> > +
> > +	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
> > +		iomap->type = IOMAP_HOLE;
> > +		iomap->addr = IOMAP_NULL_ADDR;
> > +		if (!iomap->length)
> > +			iomap->length = length;
> 
> This only happens for the case offset exceeds isize?

Thanks for the review.

Yeah, this is a convention (length 0 with !EROFS_MAP_MAPPED) for post-EOF
in erofs_map_blocks_flatmode(), need to follow iomap rule as well.

> 
> > +		return 0;
> > +	}
> > +
> > +	/* that shouldn't happen for now */
> > +	if (map.m_flags & EROFS_MAP_META) {
> > +		DBG_BUGON(1);
> > +		return -ENOTBLK;
> > +	}
> > +	iomap->type = IOMAP_MAPPED;
> > +	iomap->addr = map.m_pa;
> > +	return 0;
> > +}
> > +
> > +const struct iomap_ops erofs_iomap_ops = {
> > +	.iomap_begin = erofs_iomap_begin,
> > +};
> > +
> > +static int erofs_prepare_dio(struct kiocb *iocb, struct iov_iter *to)
> > +{
> > +	struct inode *inode = file_inode(iocb->ki_filp);
> > +	loff_t align = iocb->ki_pos | iov_iter_count(to) |
> > +		iov_iter_alignment(to);
> > +	struct block_device *bdev = inode->i_sb->s_bdev;
> > +	unsigned int blksize_mask;
> > +
> > +	if (bdev)
> > +		blksize_mask = (1 << ilog2(bdev_logical_block_size(bdev))) - 1;
> > +	else
> > +		blksize_mask = (1 << inode->i_blkbits) - 1;
> > +
> > +	if (align & blksize_mask)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Temporarily fall back tail-packing inline to buffered I/O instead
> > +	 * since tail-packing inline support relies on an iomap core update.
> > +	 */
> > +	if (EROFS_I(inode)->datalayout == EROFS_INODE_FLAT_INLINE &&
> > +	    iocb->ki_pos + iov_iter_count(to) >
> > +			rounddown(inode->i_size, EROFS_BLKSIZ))
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > +{
> > +	/* no need taking (shared) inode lock since it's a ro filesystem */
> > +	if (!iov_iter_count(to))
> > +		return 0;
> > +
> > +	if (iocb->ki_flags & IOCB_DIRECT) {
> > +		int err = erofs_prepare_dio(iocb, to);
> > +
> > +		if (!err)
> > +			return iomap_dio_rw(iocb, to, &erofs_iomap_ops,
> > +					    NULL, 0);
> > +		if (err < 0)
> > +			return err;
> > +		/*
> > +		 * Fallback to buffered I/O if the operation being performed on
> > +		 * the inode is not supported by direct I/O. The IOCB_DIRECT
> > +		 * flag needs to be cleared here in order to ensure that the
> > +		 * direct I/O path within generic_file_read_iter() is not
> > +		 * taken.
> > +		 */
> > +		iocb->ki_flags &= ~IOCB_DIRECT;
> > +	}
> > +	return generic_file_read_iter(iocb, to);
> 
> It looks it's fine to call filemap_read() directly since above codes have
> covered DIO case, then we don't need to change iocb->ki_flags flag, it's
> minor though.

Yeah, we could use filemap_read() here instead. yet IMO, it might be
better to drop IOCB_DIRECT too to keep iocb consistent with the real
semantics (even it's not used internally.)

> 
> > +}
> > +
> >   /* for uncompressed (aligned) files and raw access for other files */
> >   const struct address_space_operations erofs_raw_access_aops = {
> >   	.readpage = erofs_raw_access_readpage,
> >   	.readahead = erofs_raw_access_readahead,
> >   	.bmap = erofs_bmap,
> > +	.direct_IO = noop_direct_IO,
> > +};
> > +
> > +const struct file_operations erofs_file_fops = {
> > +	.llseek		= generic_file_llseek,
> > +	.read_iter	= erofs_file_read_iter,
> > +	.mmap		= generic_file_readonly_mmap,
> > +	.splice_read	= generic_file_splice_read,
> >   };
> > diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> > index aa8a0d770ba3..00edb7562fea 100644
> > --- a/fs/erofs/inode.c
> > +++ b/fs/erofs/inode.c
> > @@ -247,7 +247,10 @@ static int erofs_fill_inode(struct inode *inode, int isdir)
> >   	switch (inode->i_mode & S_IFMT) {
> >   	case S_IFREG:
> >   		inode->i_op = &erofs_generic_iops;
> > -		inode->i_fop = &generic_ro_fops;
> > +		if (!erofs_inode_is_data_compressed(vi->datalayout))
> > +			inode->i_fop = &erofs_file_fops;
> > +		else
> > +			inode->i_fop = &generic_ro_fops;
> 
> if (erofs_inode_is_data_compressed(vi->datalayout))
> 	inode->i_fop = &generic_ro_fops;
> else
> 	inode->i_fop = &erofs_file_fops;
> 
> Otherwise, it looks good to me.

ok, will fix in the next version.

Thanks,
Gao Xiang

> 
> Reviewed-by: Chao Yu <chao@kernel.org>
> 
> Thanks
> 
> >   		break;
> >   	case S_IFDIR:
> >   		inode->i_op = &erofs_dir_iops;
> > diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> > index 543c2ff97d30..2669c785d548 100644
> > --- a/fs/erofs/internal.h
> > +++ b/fs/erofs/internal.h
> > @@ -371,6 +371,7 @@ static inline int z_erofs_map_blocks_iter(struct inode *inode,
> >   #endif	/* !CONFIG_EROFS_FS_ZIP */
> >   /* data.c */
> > +extern const struct file_operations erofs_file_fops;
> >   struct page *erofs_get_meta_page(struct super_block *sb, erofs_blk_t blkaddr);
> >   /* inode.c */
> > 

