Return-Path: <nvdimm+bounces-5810-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D395669B763
	for <lists+linux-nvdimm@lfdr.de>; Sat, 18 Feb 2023 02:17:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 104111C20913
	for <lists+linux-nvdimm@lfdr.de>; Sat, 18 Feb 2023 01:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10998393;
	Sat, 18 Feb 2023 01:17:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C5A378
	for <nvdimm@lists.linux.dev>; Sat, 18 Feb 2023 01:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1676683019; i=@fujitsu.com;
	bh=EarUJXJHeKc/uIrwmeqmpWyHrRMI7AcdO5uvPtkXwtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=AJbD5xnirMYHgnmv0bUZg1KcyvYCo5v0rLrglNS6oAO51KHq1o2OX+7+ah/9TfemF
	 zA1GTjy216Vn0FHe8tpCx0iy8B3CrpDi0323ZNSu6WhkmRFnMSJqiiPvt+JCg+94fp
	 2ZcY9pCNQuTj7swZmRYyQqx4b8sps6uBdiGDcVsWsW4QpLT0aghj6I4z/TvP3A3UkN
	 xg/Zm5JW+q0XhBXu/jE0uxRuBHTHbOaeUtWWlHIAGtGRF2IEzoiedGZIqVK4Tysi6p
	 E+hcAaO1Eq608yqzoZTN2xL6IDx13WuuPOfM3DGWT3L8uSo8DyUdVlQD8qIwburBal
	 syL72CUr8mm2g==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRWlGSWpSXmKPExsViZ8ORpMuh/iH
  Z4MEDVos569ewWUyfeoHRYsuxe4wWl5/wWZyesIjJYvfrm2wWe/aeZLG4t+Y/q8WuPzvYLVb+
  +MNq8fvHHDYHbo9TiyQ8Nq/Q8li85yWTx6ZVnWwemz5NYvc4MeM3i8eLzTMZPT4+vcXi8XmTX
  ABnFGtmXlJ+RQJrRuvmqcwF/VwV1598YWxgPMvRxcjFISSwkVHi4dWFjBDOUiaJC3c+MkM4Wx
  klbn4+DJTh5OAVsJN4dGUhE4jNIqAqsff2J6i4oMTJmU9YQGxRgWSJY+db2UBsYQFHiV3H2li
  7GDk4RAQ0JN5sMQKZySzQwiRxfNIHqG3LGSWufr4ENpRNQEfiwoK/rCA2p4CJxN6Hv8AGMQtY
  SCx+c5AdwpaXaN46mxnElhBQkLgxaRULhF0p0frhF5StJnH13CbmCYxCs5DcNwvJqFlIRi1gZ
  F7FaFqcWlSWWqRrrJdUlJmeUZKbmJmjl1ilm6iXWqpbnlpcomukl1herJdaXKxXXJmbnJOil5
  dasokRGJspxWrCOxi/9P7VO8QoycGkJMr7edv7ZCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvPc
  UPyQLCRalpqdWpGXmANMETFqCg0dJhHe5DFCat7ggMbc4Mx0idYpRUUqcV0wNKCEAksgozYNr
  g6WmS4yyUsK8jAwMDEI8BalFuZklqPKvGMU5GJWEeaOUgabwZOaVwE1/BbSYCWjxAua3IItLE
  hFSUg1MobfmRjtl6ss5zLo9Nyc0cu633adu3+GYHGJUwTq5f/65e9IyihYMD9h9VGKM/gUr1J
  U8aj34IXzyqyjDvwYOi2bf1j9zmaNP7scqxYeRLAWFIR4/0vN9luXEmTVO//7QL+TsjV2rrps
  +uX/80uzzEr8kBU7cWa054XT1/NC6Wdf+8Ly1ts3dzS9456HtrI5TQl/eP1pypPiSFkvpM61S
  0Yq359inztoSzfaozU5mX2fxoezd/w4sZNuvvN35D+/bmJueWs5JBV57zxRmBNktvsUU1xRdf
  aPu//aiWBkTO2sriairP++Xv3jhq/Wx9dmXeWf/3c2cMbn3x7Yt2zMfXt6y41irmqRV4MPd7y
  acFFRiKc5INNRiLipOBAC6nf7+yAMAAA==
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-6.tower-565.messagelabs.com!1676683015!365172!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.102.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21012 invoked from network); 18 Feb 2023 01:16:56 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-6.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Feb 2023 01:16:56 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id B8BF01B1;
	Sat, 18 Feb 2023 01:16:55 +0000 (GMT)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id AA0611AC;
	Sat, 18 Feb 2023 01:16:55 +0000 (GMT)
Received: from [10.167.201.2] (10.167.201.2) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Sat, 18 Feb 2023 01:16:50 +0000
Message-ID: <d5e5c50f-6d16-5a52-e79d-3578acdc1d92@fujitsu.com>
Date: Sat, 18 Feb 2023 09:16:43 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 2/3] fs: introduce super_drop_pagecache()
To: Matthew Wilcox <willy@infradead.org>
CC: <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <djwong@kernel.org>,
	<david@fromorbit.com>, <dan.j.williams@intel.com>, <hch@infradead.org>,
	<jane.chu@oracle.com>, <akpm@linux-foundation.org>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
 <Y++n53dzkCsH1qeK@casper.infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <Y++n53dzkCsH1qeK@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.201.2]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP



在 2023/2/18 0:14, Matthew Wilcox 写道:
> On Fri, Feb 17, 2023 at 02:48:31PM +0000, Shiyang Ruan wrote:
>> -		invalidate_mapping_pages(inode->i_mapping, 0, -1);
>> -		iput(toput_inode);
>> -		toput_inode = inode;
>> -
>> -		cond_resched();
>> -		spin_lock(&sb->s_inode_list_lock);
>> -	}
>> -	spin_unlock(&sb->s_inode_list_lock);
>> -	iput(toput_inode);
>> +	super_drop_pagecache(sb, invalidate_inode_pages);
> 
> I thought I explained last time that you can do this with
> invalidate_mapping_pages() / invalidate_inode_pages2_range() ?
> Then you don't need to introduce invalidate_inode_pages().
> 
>> +void super_drop_pagecache(struct super_block *sb,
>> +	int (*invalidator)(struct address_space *))
> 
> void super_drop_pagecache(struct super_block *sb,
> 		int (*invalidate)(struct address_space *, pgoff_t, pgoff_t))
> 
>> +		invalidator(inode->i_mapping);
> 
> 		invalidate(inode->i_mapping, 0, -1)
> 
> ... then all the changes to mm/truncate.c and filemap.h go away.

Yes, I tried as you suggested, but I found that they don't have same 
type of return value.

int invalidate_inode_pages2_range(struct address_space *mapping,
				  pgoff_t start, pgoff_t end);

unsigned long invalidate_mapping_pages(struct address_space *mapping,
		pgoff_t start, pgoff_t end);


--
Thanks,
Ruan.

