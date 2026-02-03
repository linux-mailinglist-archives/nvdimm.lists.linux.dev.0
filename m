Return-Path: <nvdimm+bounces-13014-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDURBlVcgWlnFwMAu9opvQ
	(envelope-from <nvdimm+bounces-13014-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 03 Feb 2026 03:24:21 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B454CD3BD5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 03 Feb 2026 03:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C554300B477
	for <lists+linux-nvdimm@lfdr.de>; Tue,  3 Feb 2026 02:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1842F1FC8;
	Tue,  3 Feb 2026 02:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QaE3k+Wm"
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5217283FCF;
	Tue,  3 Feb 2026 02:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770084868; cv=pass; b=UBEabvD3QLR04zWBYhU/blMMFnXHM1ms6hiC4tVgsz1G8A31+dmL8bDNnpHoRenXFEClcIsUUA0MbFIOIVu5mnS444HP4Xb793jKcetjUjF+mM/3jVFVJETUZAkbeHWfBnpQSTSZe1UQrA+Z1+tnxMGbLebbhIrtwpO+OcSosuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770084868; c=relaxed/simple;
	bh=WEWhjNjgMTivhK1+Z3T+JZM4cBxsWzERCWLL8mqoxzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gpPfDVMV8hf3iJwFIT64l7polQzu9vq9qNxLltEdvfgkG/rMMpOZygX6faVQTfTb4MAyAODfvhwIIkV160ojHRTuqCC3IMevwiwySMoB1a/CBXP2CxBWckje2ym0LFX3FG10mTttqfxq7jOYXSDpPmb2pRGc2MkErX/gFgQ+frY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QaE3k+Wm; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770084855; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=E/mHbg3eB+6FQr/BtveC7fDluD+mFkXEZsbud/PidyJSxTl/wouo6mrYNmFHSAHR5GcqkHBnE8lj1WFk8Xj5hzO6PLWNHp/sU0mUZDY6uIPb/EaM94HesZ7M9casC2U6CS9K1oBKi0mFy/MnxRdK+NEkkIsWXhidMogL87mXhK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770084855; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EllBWXmAPg3ovIJDYXMDe9Fex2OSK19yvQg5WdHQF4w=; 
	b=XUWkdi7oIVbt/udwU7tAfFVh/a6FxIwmZF43g/Fgi+JQaEDJevdfL7A+1nt8jx/bWeYUWfCbcUsIAxMhBHrB+CUEIIVYSLKap3ak/7S8rpu96oK+R/LD3o4v89VY8J70QsbN5ZYHORWuVGjr6OjXYV+TUi96viqLVbdvTYvKFLk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770084855;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EllBWXmAPg3ovIJDYXMDe9Fex2OSK19yvQg5WdHQF4w=;
	b=QaE3k+Wmh/gx5qr1Upm0qL0Inj7PEa6EA3QAMU+BD3uK7dQbecfcIgDfF8aFHImG
	7MEJx0odQe04kz7LqQrluT0/3OFnP3bsNGzYqqD5w9ypzLKaeLAUfEWwU7EyzdbxdT+
	exGHEs5o2//4MHs4zteLybWsY17lxJ4ALPsgnoKs=
Received: by mx.zohomail.com with SMTPS id 1770084853055993.3306336899888;
	Mon, 2 Feb 2026 18:14:13 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Cornelia Huck <cohuck@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Yuval Shaia <yuval.shaia@oracle.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH v2] nvdimm: virtio_pmem: serialize flush requests
Date: Tue,  3 Feb 2026 10:13:51 +0800
Message-ID: <20260203021353.121091-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [10.34 / 15.00];
	URIBL_BLACK(7.50)[linux.beauty:email,linux.beauty:dkim,linux.beauty:mid];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	R_DKIM_ALLOW(0.00)[linux.beauty:s=zmail];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com,intel.com,redhat.com,oracle.com,lists.linux.dev,vger.kernel.org];
	DMARC_NA(0.00)[linux.beauty];
	FORGED_SENDER_MAILLIST(0.00)[];
	GREYLIST(0.00)[pass,body];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13014-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c0a:e001:db::/64];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_SPAM(0.00)[0.996];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B454CD3BD5
X-Rspamd-Action: add header
X-Spam: Yes

Under heavy concurrent flush traffic, virtio-pmem can overflow its request
virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
driver logs "no free slots in the virtqueue". Shortly after that the
device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
"virtio pmem device needs a reset".

Serialize virtio_pmem_flush() with a per-device mutex so only one flush
request is in-flight at a time. This prevents req_vq descriptor overflow
under high concurrency.

Reproducer (guest with virtio-pmem):
  - mkfs.ext4 -F /dev/pmem0
  - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
  - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
        direct=1 fsync=1 runtime=30s time_based=1
  - dmesg: "no free slots in the virtqueue"
           "virtio pmem device needs a reset"

Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Li Chen <me@linux.beauty>
---
v2:
- Use guard(mutex)() for flush_lock (as suggested by Ira Weiny).
- Drop redundant might_sleep() next to guard(mutex)() (as suggested by Michael S. Tsirkin).

 drivers/nvdimm/nd_virtio.c   | 3 ++-
 drivers/nvdimm/virtio_pmem.c | 1 +
 drivers/nvdimm/virtio_pmem.h | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa22..af82385be7c6 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	guard(mutex)(&vpmem->flush_lock);
+
 	/*
 	 * Don't bother to submit the request to the device if the device is
 	 * not activated.
@@ -53,7 +55,6 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
-	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 2396d19ce549..77b196661905 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -64,6 +64,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
+	mutex_init(&vpmem->flush_lock);
 	vpmem->vdev = vdev;
 	vdev->priv = vpmem;
 	err = init_vq(vpmem);
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 0dddefe594c4..f72cf17f9518 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
 #include <linux/libnvdimm.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 struct virtio_pmem_request {
@@ -35,6 +36,9 @@ struct virtio_pmem {
 	/* Virtio pmem request queue */
 	struct virtqueue *req_vq;
 
+	/* Serialize flush requests to the device. */
+	struct mutex flush_lock;
+
 	/* nvdimm bus registers virtio pmem device */
 	struct nvdimm_bus *nvdimm_bus;
 	struct nvdimm_bus_descriptor nd_desc;
-- 
2.52.0

