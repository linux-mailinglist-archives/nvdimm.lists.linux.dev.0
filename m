Return-Path: <nvdimm+bounces-1307-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id CDAFF40C3DB
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Sep 2021 12:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1C7973E104B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Sep 2021 10:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE0B3FDB;
	Wed, 15 Sep 2021 10:45:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9543FC9
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 10:45:55 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AUkymV6PNeIyklkzvrR21lsFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdQS9gDtzhWNWzGZOXDzUb6yIZGDzL9p/YN6/9UgHuMXUm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHiK0SiuFaOC79CEtjPzQHdIQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/kSiAmctgjttLroCYR?=
 =?us-ascii?q?xorP7HXhaIWVBww/yRWZPQapeaWeSXh2SCU5wicG5f2+N1iBV83MaUW4OFyBnt?=
 =?us-ascii?q?E9OBeIzcIBjichuay0Zq6TOd2j8guJcWtO5kQ0llsxDefD7A5QJTHQqzP/vdZ2?=
 =?us-ascii?q?is9goZFGvO2T8Ybdj1pYzzDbgdJN1NRD4gx9M+yh2XyaD1YgFaUo7cnpWnZyUp?=
 =?us-ascii?q?6172FGNzLdt2PQO1Rn12EvSTC/mLkElcWOcL34TqO8lqonfOJkS6TcJgdE7m06?=
 =?us-ascii?q?e9sqEaO3WFVBBB+fV+6p+Spz0ClV99BJkg85CUjt+4x+VatQ927WAe3yFaAvxg?=
 =?us-ascii?q?BS59THvc85QWl1KXZ+UCaC3ICQzoHb8Yp3OcyRDo3xhqZkcjBGzNiqvuWRGib+?=
 =?us-ascii?q?7PSqim9UQALLHUFTT0JSwobpd3ippwjyBXVQZB+E8aIYnfdcd3r62nS6nFg2PN?=
 =?us-ascii?q?I1ohWv5hXNGvv21qEzqUlhCZrjukPYl+Y0w=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AcQes1az7h01bGVT/ilAiKrPwSb1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uEvBw+PrCoB1273XJYVUqOU3I++ruBEDoexq1nqKdibNhXotKNzOLhI?=
 =?us-ascii?q?LHFu9f0bc=3D?=
X-IronPort-AV: E=Sophos;i="5.85,295,1624291200"; 
   d="scan'208";a="114519056"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Sep 2021 18:45:51 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id A327A4D0D9D2;
	Wed, 15 Sep 2021 18:45:46 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 15 Sep 2021 18:45:46 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 15 Sep 2021 18:45:45 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <djwong@kernel.org>, <hch@lst.de>, <linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <dan.j.williams@intel.com>,
	<david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>, Ritesh Harjani
	<riteshh@linux.ibm.com>
Subject: [PATCH v9 5/8] fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
Date: Wed, 15 Sep 2021 18:44:58 +0800
Message-ID: <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: A327A4D0D9D2.A0E5A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

Punch hole on a reflinked file needs dax_iomap_cow_copy() too.
Otherwise, data in not aligned area will be not correct.  So, add the
CoW operation for not aligned case in dax_iomap_zero().

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/dax.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4f346e25e488..ca4308c85988 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1212,6 +1212,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 s64 dax_iomap_zero(struct iomap_iter *iter, loff_t pos, u64 length)
 {
 	const struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = &iter->srcmap;
 	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
 	pgoff_t pgoff;
 	long rc, id;
@@ -1230,21 +1231,27 @@ s64 dax_iomap_zero(struct iomap_iter *iter, loff_t pos, u64 length)
 
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




