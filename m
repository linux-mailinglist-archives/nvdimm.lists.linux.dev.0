Return-Path: <nvdimm+bounces-1448-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 8437641A8D6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 08:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 0BA173E10AC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 28 Sep 2021 06:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBECD3FF5;
	Tue, 28 Sep 2021 06:23:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3172D72
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 06:23:52 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AzxInbKIOS5sSqRVzFE+RwZQlxSXFcZb7ZxGrkP8?=
 =?us-ascii?q?bfHC60zkl1GFVyDEbWjuFa6mOajTwKo8nPo6/pkIHuJPQxoNqS1BcGVNFFSwT8?=
 =?us-ascii?q?ZWfbTi6wuYcBwvLd4ubChsPA/w2MrEsF+hpCC+BzvuRGuK59yAkhPvYHuOU5NP?=
 =?us-ascii?q?sYUideyc1EU/Ntjozw4bVsqYw6TSIK1vlVeHa+qUzC3f5s9JACV/43orYwP9ZU?=
 =?us-ascii?q?FsejxtD1rA2TagjUFYzDBD5BrpHTU26ByOQroW5goeHq+j/ILGRpgs1/j8mDJW?=
 =?us-ascii?q?rj7T6blYXBLXVOGBiiFIPA+773EcE/Xd0j87XN9JFAatToy+UltZq2ZNDs4esY?=
 =?us-ascii?q?Qk0PKzQg/lbWB5de817FfQfpeeWfynu6qR/yGWDKRMA2c5GAEgoPIEw9PxwBGZ?=
 =?us-ascii?q?U//0EbjsKa3irmOOyxKOTS+9inM0vIcDneoQFtRlIwTjfS/RgXpHHR6TD4MRw3?=
 =?us-ascii?q?TEsi8QIFvHbD+IVayVoahvoYBBVPFoTTpUkk4+AnHjjfiZYqHqRpKwq8y7Sxgk?=
 =?us-ascii?q?327/oWPLTZNCLQMB9mkeDunmA+2X/HwFcONGBoRKF+XKEgvTT2y/2MKoIG7q8+?=
 =?us-ascii?q?uF7hnWI23ceThEbPXO/oP+kmguwQN5SNUEQ0jQhoLJ090GxSNT5GRqirxasuh8?=
 =?us-ascii?q?aRsoVEOAg7gyJ4rTb7hzfBWUeSDNFLts8u6ceQT0sy0/Mj93yLSJgvafTSn+H8?=
 =?us-ascii?q?LqQ6zSoNkA9M24YYgcWQA0E/Z/noYcunlTIVNklDa3dszFfMVkc2BjT9G5n2ep?=
 =?us-ascii?q?V1pVNis2GEZn8q2rEjvD0osQdu207hl6Y0z4=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AunpnqKNbIuqYKcBcTv2jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7TEUdfUxSKGlfq+V8sjzqiWftN98YhAdcLO7Scy9qBHnhP1ICOAqVN/MYOCMgh?=
 =?us-ascii?q?rLEGgN1+vf6gylMyj/28oY7q14bpV5YeeaMXFKyer8/ym0euxN/OW6?=
X-IronPort-AV: E=Sophos;i="5.85,328,1624291200"; 
   d="scan'208";a="115096993"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Sep 2021 14:23:51 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 8836C4D0DC83;
	Tue, 28 Sep 2021 14:23:50 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 28 Sep 2021 14:23:44 +0800
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Tue, 28 Sep 2021 14:23:43 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Tue, 28 Sep 2021 14:23:42 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <dan.j.williams@intel.com>, <djwong@kernel.org>, <hch@lst.de>,
	<linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <david@fromorbit.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, Ritesh Harjani <riteshh@linux.ibm.com>
Subject: [PATCH v10 5/8] fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
Date: Tue, 28 Sep 2021 14:23:08 +0800
Message-ID: <20210928062311.4012070-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
References: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 8836C4D0DC83.AED86
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Punch hole on a reflinked file needs dax_iomap_cow_copy() too.
Otherwise, data in not aligned area will be not correct.  So, add the
CoW operation for not aligned case in dax_iomap_zero().

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index debe459680f2..5379de8ad0c7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1212,6 +1212,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 s64 dax_iomap_zero(const struct iomap_iter *iter, loff_t pos, u64 length)
 {
 	const struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = &iter->srcmap;
 	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
 	pgoff_t pgoff;
 	long rc, id;
@@ -1230,21 +1231,27 @@ s64 dax_iomap_zero(const struct iomap_iter *iter, loff_t pos, u64 length)
 
 	id = dax_read_lock();
 
-	if (page_aligned)
+	if (page_aligned) {
 		rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
-	else
-		rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
-	if (rc < 0) {
-		dax_read_unlock(id);
-		return rc;
+		goto out;
 	}
 
-	if (!page_aligned) {
-		memset(kaddr + offset, 0, size);
+	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
+	if (rc < 0)
+		goto out;
+	memset(kaddr + offset, 0, size);
+	if (srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {
+		rc = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
+					kaddr);
+		if (rc < 0)
+			goto out;
+		dax_flush(iomap->dax_dev, kaddr, PAGE_SIZE);
+	} else
 		dax_flush(iomap->dax_dev, kaddr + offset, size);
-	}
+
+out:
 	dax_read_unlock(id);
-	return size;
+	return rc < 0 ? rc : size;
 }
 
 static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
-- 
2.33.0




