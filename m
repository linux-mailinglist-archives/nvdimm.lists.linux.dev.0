Return-Path: <nvdimm+bounces-4124-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF84B562AC2
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Jul 2022 07:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id C35972E0A65
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Jul 2022 05:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FAF1101;
	Fri,  1 Jul 2022 05:15:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CB310E8
	for <nvdimm@lists.linux.dev>; Fri,  1 Jul 2022 05:15:01 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AJLjYGq6B6cmXTrRbn3QZXwxRtJbFchMFZxGqfqr?=
 =?us-ascii?q?LsXjdYENS12RVy2McX2/UPKnYZzPxKohxPorjpBkF7JCGx4cwT1A5pCpnJ55og?=
 =?us-ascii?q?ZCbXIzGdC8cHM8zwvXrFRsht4NHAjX5BJhcokT0+1H9YtANkVEmjfvSHuCkUba?=
 =?us-ascii?q?dUsxMbVQMpBkJ2EsLd9ER0tYAbeiRW2thiPuqyyHtEAbNNw1cbgr435m+RCZH5?=
 =?us-ascii?q?5wejt+3UmsWPpintHeG/5Uc4Ql2yauZdxMUSaEMdgK2qnqq8V23wo/Z109F5tK?=
 =?us-ascii?q?NmbC9fFAIQ6LJIE6FjX8+t6qK20AE/3JtlP1gcqd0hUR/0l1lm/hr1dxLro32R?=
 =?us-ascii?q?wEyIoXCheYcTwJFVSp5OMWq/Zeeeyfn4JLPlB2un3zEhq8G4FsNFYER5Od7KW9?=
 =?us-ascii?q?U8vkfMjoMclaIgOfe6LKwSsFtgMo5JcXmNY9ZvWtvpRnVD+khR5/rQKjQ49Jcm?=
 =?us-ascii?q?jAqiahmG+jSZs8cQT5udwjbJRlOPEoHTp4zgo+Agnj5bi0dpkmZqLQ650DNwwF?=
 =?us-ascii?q?rlrvgKtzYfpqNX8o9tkKZoH/Wumf0GBcXMPSBxjeftHGhnOnCmWX8Qo16PLm58?=
 =?us-ascii?q?ON6xU2d3UQNBxAME1i2u/+0jgi5Qd03FqC+0kLCtoBrrAryEIa7BEb+/Ra5Utc?=
 =?us-ascii?q?nc4I4O4UHBMulk8I4OzqkO1U=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AKuVcIKPFYuaVXMBcTiWjsMiBIKoaSvp037Eq?=
 =?us-ascii?q?v3oBKyC9Ffbo7vxG/c5rsyMc5wx/ZJhNo6HlBEDEewK6yXcX2+cs1NWZMDUO0V?=
 =?us-ascii?q?HAROoJgLcKgQeQfhEWndQ86U4PSdkcNDS9NzlHZNjBkXSFOudl0N+a67qpmOub?=
 =?us-ascii?q?639sSDthY6Zm4xwRMHfhLmRGABlBGYEiFIeRou5Opz+bc3wRacihQlYfWeyrna?=
 =?us-ascii?q?ywqLvWJQ4BGwU86BSDyReh6LvBGRCe2RsEFxNjqI1SiVT4rw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="127096438"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Jul 2022 13:14:52 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id B88394D1719A;
	Fri,  1 Jul 2022 13:14:51 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 1 Jul 2022 13:14:50 +0800
Received: from [192.168.22.78] (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 1 Jul 2022 13:14:53 +0800
Message-ID: <07805923-6455-e046-8c0a-60ed99d1fb38@fujitsu.com>
Date: Fri, 1 Jul 2022 13:14:51 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<david@fromorbit.com>, <hch@infradead.org>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
 <Yr5AV5HaleJXMmUm@magnolia>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <Yr5AV5HaleJXMmUm@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: B88394D1719A.AFAA7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/7/1 8:31, Darrick J. Wong 写道:
> On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
>> Failure notification is not supported on partitions.  So, when we mount
>> a reflink enabled xfs on a partition with dax option, let it fail with
>> -EINVAL code.
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> 
> Looks good to me, though I think this patch applies to ... wherever all
> those rmap+reflink+dax patches went.  I think that's akpm's tree, right?

Yes, they are in his tree, still in mm-unstable now.

> 
> Ideally this would go in through there to keep the pieces together, but
> I don't mind tossing this in at the end of the 5.20 merge window if akpm
> is unwilling.

Both are fine to me.  Thanks!


--
Ruan.

> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> ---
>>   fs/xfs/xfs_super.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 8495ef076ffc..a3c221841fa6 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -348,8 +348,10 @@ xfs_setup_dax_always(
>>   		goto disable_dax;
>>   	}
>>   
>> -	if (xfs_has_reflink(mp)) {
>> -		xfs_alert(mp, "DAX and reflink cannot be used together!");
>> +	if (xfs_has_reflink(mp) &&
>> +	    bdev_is_partition(mp->m_ddev_targp->bt_bdev)) {
>> +		xfs_alert(mp,
>> +			"DAX and reflink cannot work with multi-partitions!");
>>   		return -EINVAL;
>>   	}
>>   
>> -- 
>> 2.36.1
>>
>>
>>



