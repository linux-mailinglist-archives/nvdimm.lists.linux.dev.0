Return-Path: <nvdimm+bounces-7471-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8856685665B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 15 Feb 2024 15:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46A7D286496
	for <lists+linux-nvdimm@lfdr.de>; Thu, 15 Feb 2024 14:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766E4133416;
	Thu, 15 Feb 2024 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="BnQ8gALW"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0E2132476;
	Thu, 15 Feb 2024 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708008403; cv=none; b=F3sIdTJjNbA5VHHPjF8xNm559X3yKvZQBuq9MKg0Yq9qKJvPSGjd2B5tgyyfOaC8GWAwxH+JVkBqTXFqS243UeeZCeAi4h83KF/ECb3grzYg/+w6tHPqR70nZZ/axyGFX8oZV1rHIreS8hDGGkJMKv8blKtBIZSPQ4d091Gdl1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708008403; c=relaxed/simple;
	bh=ecUyvilxXmAuEa6CVYKrKIA8K8l2tVUUJHjpsI0Te00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RtrIlPQKivuDouKnyMSD7SrE3LFEY9W2IebzBwvZ+mA9xzECi2E5jOwuKG4ER9F/igJeKYk29edD4LKbS91pLI8enMUPbePfA99qt8vDZae6wzEdAsMg5ayMIB85c6QR7oCVxfNnesgCWM2OJeQo0dYBxmgPzroZ2DF78UESoiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=BnQ8gALW; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1708008400;
	bh=ecUyvilxXmAuEa6CVYKrKIA8K8l2tVUUJHjpsI0Te00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnQ8gALWRG0w08WHE18FXz/gmkcBs+yrQ55MT0cKd97EICKIovqMo4kVDLrKcH8bh
	 YQI6fZljO24zHkyqsBzPTcvX20Vmg1ap8c8Tut+BU0Ci57M0gEpwtLnH+URQUAtmmg
	 76+jmRJI3BJZlPVr+gtSamRkZubkS4p6ZAiRoPVMrfSWx4HichoBiZJGLDkgrUvm+H
	 3BOlrHqxHEUVhYGYgEgu5uP0I6z8XFlAkekIdXkSRk81RBemq+K4JJyRUPbB2q5zqA
	 kStS73njuquarYVVqiJKuZr+R21XtlJhj0W1tdwj08C9j7a2ZkXN80Oc/GHeo+rxH5
	 /2vMn1vOE7jHg==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TbHvN0F0TzZS6;
	Thu, 15 Feb 2024 09:46:40 -0500 (EST)
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
Subject: [PATCH v6 3/9] nvdimm/pmem: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
Date: Thu, 15 Feb 2024 09:46:27 -0500
Message-Id: <20240215144633.96437-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215144633.96437-1-mathieu.desnoyers@efficios.com>
References: <20240215144633.96437-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for checking whether the architecture has data cache
aliasing within alloc_dax(), modify the error handling of nvdimm/pmem
pmem_attach_disk() to treat alloc_dax() -EOPNOTSUPP failure as non-fatal.

[ Based on commit "nvdimm/pmem: Fix leak on dax_add_host() failure". ]

Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
 drivers/nvdimm/pmem.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9fe358090720..e9898457a7bd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -560,17 +560,19 @@ static int pmem_attach_disk(struct device *dev,
 	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
-		goto out;
+		if (rc != -EOPNOTSUPP)
+			goto out;
+	} else {
+		set_dax_nocache(dax_dev);
+		set_dax_nomc(dax_dev);
+		if (is_nvdimm_sync(nd_region))
+			set_dax_synchronous(dax_dev);
+		pmem->dax_dev = dax_dev;
+		rc = dax_add_host(dax_dev, disk);
+		if (rc)
+			goto out_cleanup_dax;
+		dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	}
-	set_dax_nocache(dax_dev);
-	set_dax_nomc(dax_dev);
-	if (is_nvdimm_sync(nd_region))
-		set_dax_synchronous(dax_dev);
-	pmem->dax_dev = dax_dev;
-	rc = dax_add_host(dax_dev, disk);
-	if (rc)
-		goto out_cleanup_dax;
-	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
 		goto out_remove_host;
-- 
2.39.2


