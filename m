Return-Path: <nvdimm+bounces-7385-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8213F84E83C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 19:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 200301F2E2A1
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 18:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D76237711;
	Thu,  8 Feb 2024 18:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="vtjc7/2f"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB536121;
	Thu,  8 Feb 2024 18:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707418176; cv=none; b=W1znNgZtLBqrcJj1vV/WeHhplAmux3HwWqjFEs1cCVDUjqnpTvD7Yh+dtKpd9JnqKqA7PTEXqjHtFc2p69npT5VmL/AUUekH6WUFFHR5cjE7iYbZZtelx+XbYQ8OgXjjoOy4GZIXeYwuE3IQ6DQsW42g829E5C+4kLXjrSd930Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707418176; c=relaxed/simple;
	bh=Iy1T66BEIuPj6bTS95Nd9D5h8aE2OAfCM3Sw4sgOgjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YpwY3mLe4wp2WNoj6yVTOGj4MuAiDEI0NWaealSE4Giak7h7AXIuwraCK1Bz9cdW580ZpbeWG00fzqXC2CK//TNA5PHuOMXEzkSQxEBZaT2QyPU/a/yXz2mFAQkFOPbab/bvPqm0WTmCX8rq8S9on4AOHvI3AWFElOqK7tQsMio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=vtjc7/2f; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707418166;
	bh=Iy1T66BEIuPj6bTS95Nd9D5h8aE2OAfCM3Sw4sgOgjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtjc7/2fYgtbG9L3HmHuiZ0hGJa5dwKDXt/n16lAht+M2tw/jI1e25yKjrmZukvCz
	 /CX1mCneF7UyCbUOI4h3G4fdzzSb+li471Gx6ba8eevnycoFnHMSk9/h7wbWMnbYvz
	 6nZtKBy7/E8bqAxj2lbFepGPrzFubBQ+wr2SChDD6HS2Wn+qRldp0qwKKSKFtnBJIU
	 OLFpBjTdvJMQftoRrtnmWegJrS0zZtCdd9sUdS3eoFkCZdZGdSYOE7mkXPbWW5GCXd
	 tkUbHVYezf/E/8BNNB/B1FE4KQJPivjjt8+FxxLo9L9C6/i/PG/zlxN+sluj3adEJD
	 E0pl1Ko8zJjwg==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TW5ck2DcczY2L;
	Thu,  8 Feb 2024 13:49:26 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Russell King <linux@armlinux.org.uk>,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 09/12] nvdimm/pmem: Cleanup alloc_dax() error handling
Date: Thu,  8 Feb 2024 13:49:10 -0500
Message-Id: <20240208184913.484340-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
References: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that alloc_dax() returns ERR_PTR(-EOPNOTSUPP) rather than NULL,
the callers do not have to handle NULL return values anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arch@vger.kernel.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Cc: nvdimm@lists.linux.dev
---
 drivers/nvdimm/pmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f1d9f5c6dbac..e9898457a7bd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -558,8 +558,8 @@ static int pmem_attach_disk(struct device *dev,
 	disk->bb = &pmem->bb;
 
 	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
-	if (IS_ERR_OR_NULL(dax_dev)) {
-		rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
+	if (IS_ERR(dax_dev)) {
+		rc = PTR_ERR(dax_dev);
 		if (rc != -EOPNOTSUPP)
 			goto out;
 	} else {
-- 
2.39.2


