Return-Path: <nvdimm+bounces-3877-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AC653C468
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 07:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 38DA12E0A29
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Jun 2022 05:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE3EEB8;
	Fri,  3 Jun 2022 05:37:58 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997E0A48
	for <nvdimm@lists.linux.dev>; Fri,  3 Jun 2022 05:37:55 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AmzHIZqsOCmUIsZ4A+6KEVLxBUufnVMhfMUV32f8?=
 =?us-ascii?q?akzHdYEJGY0x3zDEeWmqOM66NamL1eNt3Poi1804PscOBz9NnQVY5rihgHilAw?=
 =?us-ascii?q?SbnLY7Hdx+vZUt+DSFioHpPtpxYMp+ZRCwNZie0SiyFb/6x/RGQ6YnSHuCmULS?=
 =?us-ascii?q?cY3goLeNZYHxJZSxLyrdRbrFA0YDR7zOl4bsekuWHULOX82cc3lE8t8pvnChSU?=
 =?us-ascii?q?MHa41v0iLCRicdj5zcyn1FNZH4WyDrYw3HQGuG4FcbiLwrPIS3Qw4/Xw/stIov?=
 =?us-ascii?q?NfrfTeUtMTKPQPBSVlzxdXK3Kbhpq/3R0i/hkcqFHLxo/ZzahxridzP1XqJW2U?=
 =?us-ascii?q?hZvMKvXhMwTThtZDzpje6ZB/dcrJFDm65DNnxOWKyeEL/JGSRte0Zcj0up+H2B?=
 =?us-ascii?q?C3fICLzUKdBqCm6S9x7fTYu1tgMEiJc7rMasfp3h/wDCfBvEjKbjDSKXi5NlWx?=
 =?us-ascii?q?j48i8lCW/HEaKIxdjtraAXoYhtBIF4bBZsy2uCyiRHXfzRe7lDTuqsz52nayRd?=
 =?us-ascii?q?Z0b7xPd6TcduPLe1ZnFmfoG3u/GnjBBwectuFxlKt9nOqm/+KmCbTW5wbH77+8?=
 =?us-ascii?q?eRl6HWaxXQWIBkXU0ar5Pe+l0iyUs5eLEpS/TAhxYAo9VCmVdn9dxm5pmOU+B8?=
 =?us-ascii?q?WXpxbFOhSwAeTxqvR5i6dB3MYVXhFado7pIk6SCJC/l+Cn/vtHiApvLD9YXSU8?=
 =?us-ascii?q?aad6zO1IykaMGQCZAcCQABD6N7myKkxhxTCCN1jDYaylNT+HTy2yDePxAAkiLI?=
 =?us-ascii?q?XgdEa0Y2g4EvKxT6hzrDNTwgo9kDZRW6o8A59TJCqapbu6lXB6/tEaoGDQTGpu?=
 =?us-ascii?q?HkChtjb7+0UC5yJvDKCTf9LH7yz4fuBdjrGjjZHG5gn6iTo63C4VZ5f7Ss4J0p?=
 =?us-ascii?q?zNMsAPzjzbyf7pwJL47dBMX2rc+lzYoSsG4It16emCNeNaxx+RrKiebAoLEneo?=
 =?us-ascii?q?n4oPhXWggjQfIEXuflXEf+mnQyEVB720Zha8Qc=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AKq5bBahNm/OV6t1BQXu9mYEGynBQXjwji2hC?=
 =?us-ascii?q?6mlwRA09TySZ//rOoB19726MtN9xYgBZpTnuAtjifZqxz/FICMwqTNOftWrdyQ?=
 =?us-ascii?q?2VxeNZnOnfKlTbckWUnIMw6U4jSdkYNDSaNzhHZKjBjjVQa+xQpeVv7prY+dv2?=
 =?us-ascii?q?/jN8Sx1wcaF840NcAgafKEd/Qw5LHvMCZeChz/sCtzy9Ym4Wc8j+InEEWtLIr9?=
 =?us-ascii?q?rNmImjTgUBA3ccmXSzpALt+LjnCAKZwxtbdztOxI0p+W/Dnxe8xojLiYDB9iPh?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="124686804"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2022 13:37:51 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 95F584D1719F;
	Fri,  3 Jun 2022 13:37:50 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 13:37:51 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 3 Jun 2022 13:37:51 +0800
Received: from irides.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 3 Jun 2022 13:37:50 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <akpm@linux-foundation.org>, <jane.chu@oracle.com>,
	<rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>, <willy@infradead.org>,
	<naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>, Ritesh Harjani
	<riteshh@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 11/14] fsdax: Add dax_iomap_cow_copy() for dax zero
Date: Fri, 3 Jun 2022 13:37:35 +0800
Message-ID: <20220603053738.1218681-12-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
References: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 95F584D1719F.AFBC7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Punch hole on a reflinked file needs dax_iomap_cow_copy() too.
Otherwise, data in not aligned area will be not correct.  So, add the
CoW operation for not aligned case in dax_memzero().

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>

==
This patch changed a lot when rebasing to next-20220504 branch.  Though it
has been tested by myself, I think it needs a re-review.
==
---
 fs/dax.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f69e937f6496..24d8b4f99e98 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1221,17 +1221,28 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 }
 #endif /* CONFIG_FS_DAX_PMD */
 
-static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
-		unsigned int offset, size_t size)
+static int dax_memzero(struct iomap_iter *iter, loff_t pos, size_t size)
 {
+	const struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	unsigned offset = offset_in_page(pos);
+	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 	void *kaddr;
 	long ret;
 
-	ret = dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
-	if (ret > 0) {
-		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, kaddr + offset, size);
-	}
+	ret = dax_direct_access(iomap->dax_dev, pgoff, 1, DAX_ACCESS, &kaddr,
+				NULL);
+	if (ret < 0)
+		return ret;
+	memset(kaddr + offset, 0, size);
+	if (srcmap->addr != iomap->addr) {
+		ret = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
+					 kaddr);
+		if (ret < 0)
+			return ret;
+		dax_flush(iomap->dax_dev, kaddr, PAGE_SIZE);
+	} else
+		dax_flush(iomap->dax_dev, kaddr + offset, size);
 	return ret;
 }
 
@@ -1258,7 +1269,7 @@ static s64 dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
 			rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
 		else
-			rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
+			rc = dax_memzero(iter, pos, size);
 		dax_read_unlock(id);
 
 		if (rc < 0)
-- 
2.36.1




