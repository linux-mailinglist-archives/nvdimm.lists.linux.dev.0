Return-Path: <nvdimm+bounces-2275-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4584750BE
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Dec 2021 03:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A1E3A1C0C60
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Dec 2021 02:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAE32CB5;
	Wed, 15 Dec 2021 02:07:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48D568
	for <nvdimm@lists.linux.dev>; Wed, 15 Dec 2021 02:07:44 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AUpdg86CuEMmTlBVW/0Liw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fB1K41T1z02dVmjEWCm2Ab/uJNDb3LdwiOYTl9h8HuJOAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkHhcwmj/3auK49CMliPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9NljyPhME3xtNWqbS+V?=
 =?us-ascii?q?AUoIrbR3u8aVnG0FgknZP0XoO6XcCHXXcu7iheun2HX6/lnEkA6FYMC/eNwG2t?=
 =?us-ascii?q?P6boTLzVlRhCIh8q3xryhQ+Vhj8hlK9PkVKsTs3cmz3fGDPIiQJnGWI3L48NV2?=
 =?us-ascii?q?HE7gcUmNfrceM0fZhJsYQ7GbhkJPU0YYLo6neG1ljz6dhVbtluepuww+We75Ap?=
 =?us-ascii?q?v3LnoNfLRe8eWXoNRn0CFtiTK8nqRKhMTMtHZwjqY2nW2j+TLkGXwX4d6PLm58?=
 =?us-ascii?q?ON6xVOIymENBRk+S1S2u7+6h1S4VtYZLFYbkgIqrK4v5AmoQ8P7UhmQvnGJpFg?=
 =?us-ascii?q?fVsBWHul87xuCooLQ4gCEFi0UQCVpdtMrrok1SCYs21vPmMnmbQGDGpX9pWm1r?=
 =?us-ascii?q?+/S9G3tf3NOazJqWMPNdiNdi/GLnW35pkunog5fLZOI?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A0OkHXq44M1qxe04nYwPXwCzXdLJyesId70hD?=
 =?us-ascii?q?6qhwISYlEPBw8Pre5cjztCWE7gr5N0tOpTntAtjlfZqYz+8T3WBzB9mftWvd1F?=
 =?us-ascii?q?dARbsKheCJrgEIWReOk9K1vp0BT0ERMqySMbE3t6fHCReDYqsd6ejC4Ka1nv3f?=
 =?us-ascii?q?0nsoaQlrbptr5wB/Bh3zKDwMeCB2QYo+CIGH5tdK4x6peXEsZMy9AXUfG8fZod?=
 =?us-ascii?q?mjruOdXTc2Qw4g9BKVjS6lrJrzEx2j1B8YVD9VhZcOmFK16zDE2g=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,207,1635177600"; 
   d="scan'208";a="118909891"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Dec 2021 10:06:33 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 17B884D144CA;
	Wed, 15 Dec 2021 10:06:30 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 15 Dec 2021 10:06:30 +0800
Received: from [10.167.216.64] (10.167.216.64) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 15 Dec 2021 10:06:29 +0800
Message-ID: <bc5743cb-f79e-2f67-d594-85b56f05bda3@fujitsu.com>
Date: Wed, 15 Dec 2021 10:06:29 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v8 1/9] dax: Use percpu rwsem for dax_{read,write}_lock()
To: Christoph Hellwig <hch@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <david@fromorbit.com>, <jane.chu@oracle.com>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
 <20211202084856.1285285-2-ruansy.fnst@fujitsu.com>
 <Ybi69MCK5sP4ebwG@infradead.org>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <Ybi69MCK5sP4ebwG@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 17B884D144CA.A4B8D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2021/12/14 23:40, Christoph Hellwig 写道:
> On Thu, Dec 02, 2021 at 04:48:48PM +0800, Shiyang Ruan wrote:
>> In order to introduce dax holder registration, we need a write lock for
>> dax.  Change the current lock to percpu_rw_semaphore and introduce a
>> write lock for registration.
> 
> Why do we need to change the existing, global locking for that?

I think we have talked about this in the previous v7 patchset:

 
https://lore.kernel.org/nvdimm/20210924130959.2695749-1-ruansy.fnst@fujitsu.com/T/#m4031bc3dc49dcbaac6f8d99877f910fa9a6f998a

If it is a global lock, any write lock will block other dax devices.

> 
> What is the impact of this to benchmarks?  Also if we stop using srcu
> protection, we should be able to get rid of grace periods or RCU frees.

I didn't test in benchmarks for now.  Could you show me which one I 
should test this code on?  I am not familiar with this...


--
Thanks,
Ruan.



