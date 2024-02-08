Return-Path: <nvdimm+bounces-7389-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FDA84E86A
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 19:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3061B28456A
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Feb 2024 18:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869423F9EE;
	Thu,  8 Feb 2024 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="bRoE/7ia"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4FE364B4;
	Thu,  8 Feb 2024 18:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707418180; cv=none; b=OK2Dfuc9x9dZ7Q1cut/3CB1aOoPXOwbIGGRB1C6N/CEYAyR7PfpojTc1KrGT0Mu2PHbeXKSx8zGFv4oahj2Mn0/TWnAEAmXFanZtO9UUuI+acFdTwzwknHMUZ1FZpGvOyOnqz67794Mej2LZq4yv9/3U9pclT2e1J4o6m3K8q5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707418180; c=relaxed/simple;
	bh=oenQ3E1qB1jTPZO/gOZI9CMarWIZCEOT7s/3o23TNGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XWNtSP3NKXRdQZJ+AfTDd9soJ+iUO18XUX0nSUycAKVxw6tWBGRwdCv/4etY5b6Lw9NynOSvZGjleG5LBq+ROd8i7WjUJYaZAFC0ciuh4dySVd0mr/EKy90p2O4VkUSCQ0ZtL1KWbOWwOD5VmUW2WISCLYG5vn/vHSdgjok+wMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=bRoE/7ia; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707418167;
	bh=oenQ3E1qB1jTPZO/gOZI9CMarWIZCEOT7s/3o23TNGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRoE/7ia1+B9bPI5yF1PR2T1XA93zIRBnTcH0eC3l0F5DKqYSeR5Nk0tY93pHHcMe
	 SB173/Unk3i9YjDHq2INIyynyUJBpjhZxr/0L5wI/UAMDPahLp/TVB7Y5vIH5N5AE5
	 crMulQ2zXJos7wtuG6cN1nQG0cu1edkRYscl6pnAbz3KIhoZ8H50j2WoCr0/ks/Omt
	 UUlXIcysLpTzkhjiT5Iptlazn5vqIFc3f+yfGuUzmScLfFjYAiJ1vOAPY4DDm2eyWC
	 3cTHV3qAZzEPVR6WjB/op0ynHNQPoZFIweA7jAiVScoeq13l0Lfy00tVuzsdsZm7a2
	 9S+WBZwfWHPmQ==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TW5cl1F3pzY5T;
	Thu,  8 Feb 2024 13:49:27 -0500 (EST)
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
Subject: [PATCH v4 11/12] dcssblk: Cleanup alloc_dax() error handling
Date: Thu,  8 Feb 2024 13:49:12 -0500
Message-Id: <20240208184913.484340-12-mathieu.desnoyers@efficios.com>
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
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/block/dcssblk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index a3010849bfed..f363c1d51d9a 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -679,8 +679,8 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		goto put_dev;
 
 	dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
-	if (IS_ERR_OR_NULL(dax_dev)) {
-		rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
+	if (IS_ERR(dax_dev)) {
+		rc = PTR_ERR(dax_dev);
 		goto put_dev;
 	}
 	set_dax_synchronous(dax_dev);
-- 
2.39.2


