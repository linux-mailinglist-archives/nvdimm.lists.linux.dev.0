Return-Path: <nvdimm+bounces-3869-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E81253C191
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 03:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A94A12802E6
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 01:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BD281C;
	Fri,  3 Jun 2022 01:07:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4647E9
	for <nvdimm@lists.linux.dev>; Fri,  3 Jun 2022 01:07:30 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AQ0Z3/6DgZxD0VhVW/9Tiw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fVAKx1W8mhDEHx2AeDGvQPKqPazShftl0bIi+8xsFuZaAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkHhcwmj/3auK79SMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9NljyPhME3xtNWqbS+V?=
 =?us-ascii?q?AUoIrbR3u8aVnG0FgknZ/EYqOeefSbXXcu7iheun2HX6/lnEkA6FYMC/eNwG2t?=
 =?us-ascii?q?P6boTLzVlRhSCgee3ybW7R8Fsm808IcitN4Qa0llgxjHxDPAoW5nPTqzGo9hC0?=
 =?us-ascii?q?18YmcFKGef2ZswXczNjYR3MJRpVNT8/BJs42uXumXj7dzxRrUm9pKwr7myVxwt?=
 =?us-ascii?q?0uJDhMsXSfNOiRshPmEuc4GXc8AzRBhAcKczazD+t8WyljeyJmjn0MKobF6W93?=
 =?us-ascii?q?vprhkCDg2IUFRsaXEe6pv//jVSxM/pZNUAV/y8Gqakp6FftStj7Qg3+rHOa1jY?=
 =?us-ascii?q?aUt1BGqs67xuMxbff4wexAGUPCDVGbbQOtsYwSHoh1kKhmMngDjhi9raSTBq17?=
 =?us-ascii?q?LiTqT+tKC49NnIZaGkIQGMt59jlvZF2gAnDQ8huFIargdDvXzL92TaHqG45nbp?=
 =?us-ascii?q?7pcoK0biruFPKmTShorDXQQMvoAbaRGSo6kV+foHNT4ip70XLqOZON66HQVSb+?=
 =?us-ascii?q?nsJgc6T6KYJF57lvDKMWuIlDryv5ujDNDzanE4pGIMusSmuk0NP16g4DCpWfR8?=
 =?us-ascii?q?va5hbP2SyJhK7hO+Y37cLVFPCUEO9S9vZ5xwW8JXd?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AKBuoD6xevEiNhfSd59CEKrPwEL1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uA6ilfqWV8cjzuiWbtN9vYhsdcLy7WZVoIkmskKKdg7NhXotKNTOO0A?=
 =?us-ascii?q?SVxepZnOnfKlPbexHWx6p00KdMV+xEAsTsMF4St63HyTj9P9E+4NTvysyVuds?=
 =?us-ascii?q?=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124680146"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2022 09:07:28 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 6940B4D17168;
	Fri,  3 Jun 2022 09:07:28 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 09:07:28 +0800
Received: from [10.167.201.2] (10.167.201.2) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 3 Jun 2022 09:07:27 +0800
Message-ID: <09048a58-65ea-b92c-5586-dc337bf18d1a@fujitsu.com>
Date: Fri, 3 Jun 2022 09:07:26 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <david@fromorbit.com>, <hch@infradead.org>,
	<jane.chu@oracle.com>, <rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, <naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220602115640.69f7f295e731e615344a160a@linux-foundation.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20220602115640.69f7f295e731e615344a160a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 6940B4D17168.ADE05
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/6/3 2:56, Andrew Morton 写道:
> On Sun, 8 May 2022 22:36:06 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> 
>> This is a combination of two patchsets:
>>   1.fsdax-rmap: https://lore.kernel.org/linux-xfs/20220419045045.1664996-1-ruansy.fnst@fujitsu.com/
>>   2.fsdax-reflink: https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/
> 
> I'm getting lost in conflicts trying to get this merged up.  Mainly
> memory-failure.c due to patch series "mm, hwpoison: enable 1GB hugepage
> support".
> 
> Could you please take a look at what's in the mm-unstable branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm a few hours from
> now?  Or the next linux-next.
> 
> And I suggest that converting it all into a single 14-patch series
> would be more straightforward.

The patchset in this thread is the 14-patch series.  I have solved many 
conflicts.  It's an updated / newest version, and a combination of the 2 
urls quoted above.  In an other word, instead of using this two:

 >> This is a combination of two patchsets:
 >>   1.fsdax-rmap: https://...
 >>   2.fsdax-reflink: https://...

you could take this (the url of the current thread):
https://lore.kernel.org/linux-xfs/20220508143620.1775214-1-ruansy.fnst@fujitsu.com/

My description misleaded you.  Sorry for that.


--
Thanks,
Ruan.

> 
> Thanks.



