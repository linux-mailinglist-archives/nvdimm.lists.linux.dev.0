Return-Path: <nvdimm+bounces-3482-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 542FF4FB7D1
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Apr 2022 11:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id F16393E0F44
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Apr 2022 09:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3064B137E;
	Mon, 11 Apr 2022 09:39:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1383B1363
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 09:39:28 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AgRuiuqIDifFuNuOBFE+RrpQlxSXFcZb7ZxGrkP8?=
 =?us-ascii?q?bfHDshjwh1zNSnGccC2/UaauCM2v9e4slYNni9UIEsJeBz4NqS1BcGVNFFSwT8?=
 =?us-ascii?q?ZWfbTi6wuYcBwvLd4ubChsPA/w2MrEsF+hpCC+MzvuRGuK59yMkj/nRHuOU5NP?=
 =?us-ascii?q?sYUideyc1EU/Ntjozw4bVsqYw6TSIK1vlVeHa+qUzC3f5s9JACV/43orYwP9ZU?=
 =?us-ascii?q?FsejxtD1rA2TagjUFYzDBD5BrpHTU26ByOQroW5goeHq+j/ILGRpgs1/j8mDJW?=
 =?us-ascii?q?rj7T6blYXBLXVOGBiiFIPA+773EcE/Xd0j87XN9JFAatToy+UltZq2ZNDs4esY?=
 =?us-ascii?q?Qk0PKzQg/lbWB5de817FfQco+OYeSnn66R/yGWDKRMA2c5GAEgoPIEw9PxwBGZ?=
 =?us-ascii?q?U//0EbjsKa3irh+m26LO9RPNliskqII/sJox3kn1py3fbS+knRZTCSqDRzd5ew?=
 =?us-ascii?q?Do0wMtJGJ72a8gGbjxgRBfNeRtCPhEQEp1WtOOpgGTvNjhdgFGLrKE0pW/Jw2R?=
 =?us-ascii?q?Z1qbhMd/QUtiLXtlO2EKZoH/WuWj0HHkyNNef4T6e7jSgi4fnnyr9VcQZFKCQ8?=
 =?us-ascii?q?eRji1megGcUDXU+UVq9vOn8hFWyVsxSL2QK9Sc066s/7kqmSp/6RRLQiHqFuAM?=
 =?us-ascii?q?MHtldCes37CmTxafOpQWUHG4JSnhGctNOnMs3QyE6k0+HhPv3CjF19r6YU3SQ8?=
 =?us-ascii?q?vGTtzzaBMS/BQfufgddFU1cvYal+9p103ryoh9YOPbdprXI9fvYmFhmdBQDuog?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ALopJ36zYdAy1BA3b1mhsKrPwyL1zdoMgy1kn?=
 =?us-ascii?q?xilNoRw8SL37qynIpoVj6faUskd2ZJhOo7+90cW7MBfhHNtOkO4s1NSZMjUO2l?=
 =?us-ascii?q?HFEGgK1+KLqFeMJ8S9zJ856U4KSchD4bPLfDtHZIrBgTVQDexQveWvweS5g/vE?=
 =?us-ascii?q?1XdxQUVPY6Fk1Q1wDQGWCSRNNXJ7LKt8BJyB/dBGujblXXwWa/6wDn4DU/OGiM?=
 =?us-ascii?q?bMkPvdEGQ7Li9i+A+Tlimp9bK/NxCZ2y0VWzRJzaxn0UWtqX2A2pme?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="123470902"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Apr 2022 17:39:25 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id B6A434D17168;
	Mon, 11 Apr 2022 17:39:23 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Mon, 11 Apr 2022 17:39:27 +0800
Received: from [192.168.22.28] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Mon, 11 Apr 2022 17:39:22 +0800
Message-ID: <38060b98-aa1c-1cef-5db5-9ad54f63b0aa@fujitsu.com>
Date: Mon, 11 Apr 2022 17:39:23 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v12 2/7] mm: factor helpers for memory_failure_dev_pagemap
To: Christoph Hellwig <hch@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <david@fromorbit.com>, <jane.chu@oracle.com>,
	Christoph Hellwig <hch@lst.de>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-3-ruansy.fnst@fujitsu.com>
 <YlPMn2DjbqzAVhrb@infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <YlPMn2DjbqzAVhrb@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: B6A434D17168.A32DF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/4/11 14:37, Christoph Hellwig 写道:
>> +	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
>> +unlock:
>> +	dax_unlock_page(page, cookie);
>> +	return 0;
> 
> As the buildbot points out this should probably be a "return rc".

Yes, my mistake, when resolving the conflict with latest code.


--
Thanks,
Ruan



