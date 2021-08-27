Return-Path: <nvdimm+bounces-1044-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id A8F063F92FB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 05:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E96FE3E10E1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 03:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55CB2FB3;
	Fri, 27 Aug 2021 03:36:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617123FC1
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 03:36:25 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A/3r6Ka0QAwqOj5LEEHSvPAqjBI4kLtp133Aq?=
 =?us-ascii?q?2lEZdPU1SL39qynKppkmPHDP5gr5J0tLpTntAsi9qBDnhPtICOsqTNSftWDd0Q?=
 =?us-ascii?q?PGEGgI1/qB/9SPIU3D398Y/aJhXow7M9foEGV95PyQ3CCIV/om3/mLmZrFudvj?=
X-IronPort-AV: E=Sophos;i="5.84,355,1620662400"; 
   d="scan'208";a="113547097"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Aug 2021 11:36:23 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id BC6444D0D4BD;
	Fri, 27 Aug 2021 11:36:18 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 11:36:12 +0800
Received: from [192.168.22.65] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 27 Aug 2021 11:36:12 +0800
Subject: Re: [PATCH v7 8/8] fs/xfs: Add dax dedupe support
To: Dan Williams <dan.j.williams@intel.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-9-ruansy.fnst@fujitsu.com>
 <CAPcyv4gsak1B3Y0xFvNn+oFBCM2DonsyHQj=ASE2_95n6yfpWQ@mail.gmail.com>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <624617e3-3353-a63a-ff71-f034d5763650@fujitsu.com>
Date: Fri, 27 Aug 2021 11:36:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gsak1B3Y0xFvNn+oFBCM2DonsyHQj=ASE2_95n6yfpWQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-yoursite-MailScanner-ID: BC6444D0D4BD.A09A5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



On 2021/8/20 11:08, Dan Williams wrote:
> On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> Introduce xfs_mmaplock_two_inodes_and_break_dax_layout() for dax files
>> who are going to be deduped.  After that, call compare range function
>> only when files are both DAX or not.
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/xfs_file.c    |  2 +-
>>   fs/xfs/xfs_inode.c   | 57 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_inode.h   |  1 +
>>   fs/xfs/xfs_reflink.c |  4 ++--
>>   4 files changed, 61 insertions(+), 3 deletions(-)
> [..]
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index 13e461cf2055..86c737c2baeb 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -1327,8 +1327,8 @@ xfs_reflink_remap_prep(
>>          if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
>>                  goto out_unlock;
>>
>> -       /* Don't share DAX file data for now. */
>> -       if (IS_DAX(inode_in) || IS_DAX(inode_out))
>> +       /* Don't share DAX file data with non-DAX file. */
>> +       if (IS_DAX(inode_in) != IS_DAX(inode_out))
>>                  goto out_unlock;
> 
> What if you have 2 DAX inodes sharing data and one is flipped to
> non-DAX? Does that operation need to first go undo all sharing?
> 

Yes, I think it is needed to unshare the extents when the DAX flags of 
the file is changed.  I'll look into it.


--
Thanks,
Ruan.



