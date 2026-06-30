Return-Path: <nvdimm+bounces-14675-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id buqqJWWNQ2qSbQoAu9opvQ
	(envelope-from <nvdimm+bounces-14675-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 11:33:25 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 041BF6E237C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 11:33:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=P3noz52J;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14675-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14675-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2807C3065E93
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jun 2026 09:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCBF3EF665;
	Tue, 30 Jun 2026 09:25:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71483EA967;
	Tue, 30 Jun 2026 09:25:19 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811521; cv=pass; b=MU1hZFcAqHm1K6HyXY9MfGy5jMQtRretVQhRTgx+ULokhMdK60AKFxkkuGsCsyxbG7DFZoNHOrgZSSC2tG/5uf6UEa9IlwNVLtkn9wkyGR3JBpwXPUbADikDlW95OtAHkmezHax+8QrUvfetHZcZNcdZLDx+yFeJnLDFvwVzy7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811521; c=relaxed/simple;
	bh=v7bA4+F3yI9k/CDGXP1id/Vw0fJvb+BTkRRsfX/PMGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyccWKgM+G+6ktQNILNtReUyXFEeT1Qgg1SGQWmetGy9lgEbv6RXCFpPFlaXRwau3O1eBb05qXt5dAgEmLr11QsDVtlLwZjKN13JezfUMMt6OT6EVks8E6SHy0bpAlewvfi7xGnQinEopm4m63JEXjKRwMFJcDxkfZJNH+75uVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=P3noz52J; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782811478; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CsAsPPhV6TuLnus56jKDIZlo40qEiydQ9xG3I/ZHkS/p740KKIJ+7sti3x9hYdcBzUnNUJaOPp0Of9T9Po+SjPhp9kPmb1DTf4YiLTYqhgZQW1tRrksQMoA6meZBcGMlZrMk4SqKdU9R2Nqd9JLm35Wh2W5VE9cOGT7qOAVdNbY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811478; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=R9WpHO3lpLDOGEBdwEb7NtjWJTyPYL2fJKhNy7s1I24=; 
	b=Q86K+o4mv240EFxejmwy9h4MaZ/v1352C72Tq99Tz1dHUllPjf3XUxyGIPM1nqQML6TiaCozQmYuFbkw5qKXuCthPD1v5VB/qhnhwZCO4LrNkulwxD4FV7t7u8jch5DMgv7/uXSqV1r0OybZ5E5YQ002IIGY7YSOoVj0Sw76ugI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811478;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=R9WpHO3lpLDOGEBdwEb7NtjWJTyPYL2fJKhNy7s1I24=;
	b=P3noz52JxnVWkwUPK89995yP+qP8mwamqd2K3euO7BKC1iIuDt5oP5nlBjoBN7gS
	QKM+ne+whElJiXk/06Fgnqvxv3nNL/qMP/Mpzs3Lol+rPyowfODX9btD0SoJ9IFSIVi
	0mzBSVS/XEPEUA8rHbSl+/Lv+sktJfcnrTQFNz60=
Received: by mx.zohomail.com with SMTPS id 1782811476259188.37083781721344;
	Tue, 30 Jun 2026 02:24:36 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 12/12] nvdimm: virtio_pmem: drain requests in freeze
Date: Tue, 30 Jun 2026 17:23:37 +0800
Message-ID: <20260630092338.2094628-13-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.beauty,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14675-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,intel.com,lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS(0.00)[m:pankaj.gupta.linux@gmail.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:me@linux.beauty,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime,lists.linux.dev:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 041BF6E237C

virtio_pmem_freeze() currently deletes virtqueues and resets the device
without waking threads waiting for a virtqueue descriptor or a host
completion.

Mark the request virtqueue broken before reset. This makes new submissions
fail fast and lets -ENOSPC waiters leave the wait list. Reset the device
before draining used and unused request tokens, then delete the virtqueues.
This wakes waiters with -EIO. It also keeps the detach call on a quiesced
device.

Clear req_vq after del_vqs(). Make drain tolerate a NULL queue so remove
after freeze does not dereference a stale virtqueue pointer. Also make
virtio_pmem_flush() stop checking req_vq once the broken state is visible.
A waiter woken by freeze/remove can resume after del_vqs() has cleared
req_vq.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v7:
- Stop checking req_vq once the broken state is visible, so a waiter woken
  by freeze/remove does not dereference req_vq after del_vqs() clears it.
Changes in v6:
- Clear req_vq after del_vqs() and make drain tolerate a NULL queue.
Changes in v5:
- Reset the device before draining used and unused request tokens.
- Use the split broken-marking and post-reset drain helpers.
v2->v3:
- No change.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/nd_virtio.c   |  5 +++++
 drivers/nvdimm/virtio_pmem.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index a6820300cbe8f..3b8be79a20a0f 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -99,6 +99,9 @@ void virtio_pmem_drain(struct virtio_pmem *vpmem)
 	struct virtio_pmem_request *req;
 	unsigned int len;
 
+	if (!vpmem->req_vq)
+		return;
+
 	while ((req = virtqueue_get_buf(vpmem->req_vq, &len)) != NULL) {
 		virtio_pmem_clear_inflight(vpmem, req);
 		virtio_pmem_complete_err(req);
@@ -218,6 +221,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 			break;
 	}
 
+	if (READ_ONCE(vpmem->broken))
+		err = -EIO;
 	if (err == -EIO || virtqueue_is_broken(vpmem->req_vq))
 		virtio_pmem_mark_broken(vpmem);
 
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 36664a5ea25e3..7ee3fb1779f73 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -17,11 +17,16 @@ static struct virtio_device_id id_table[] = {
  /* Initialize virt queue */
 static int init_vq(struct virtio_pmem *vpmem)
 {
+	int err;
+
 	/* single vq */
 	vpmem->req_vq = virtio_find_single_vq(vpmem->vdev,
 					virtio_pmem_host_ack, "flush_queue");
-	if (IS_ERR(vpmem->req_vq))
-		return PTR_ERR(vpmem->req_vq);
+	if (IS_ERR(vpmem->req_vq)) {
+		err = PTR_ERR(vpmem->req_vq);
+		vpmem->req_vq = NULL;
+		return err;
+	}
 
 	spin_lock_init(&vpmem->pmem_lock);
 	INIT_LIST_HEAD(&vpmem->req_list);
@@ -31,6 +36,15 @@ static int init_vq(struct virtio_pmem *vpmem)
 	return 0;
 };
 
+static void virtio_pmem_del_vqs(struct virtio_pmem *vpmem)
+{
+	if (!vpmem->req_vq)
+		return;
+
+	vpmem->vdev->config->del_vqs(vpmem->vdev);
+	vpmem->req_vq = NULL;
+}
+
 static int virtio_pmem_validate(struct virtio_device *vdev)
 {
 	struct virtio_shm_region shm_reg;
@@ -139,7 +153,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
-	vdev->config->del_vqs(vdev);
+	virtio_pmem_del_vqs(vpmem);
 out_wq:
 	destroy_workqueue(vpmem->flush_wq);
 out_err:
@@ -164,18 +178,28 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 	nvdimm_bus_unregister(nvdimm_bus);
-	vdev->config->del_vqs(vdev);
+	virtio_pmem_del_vqs(vpmem);
 	destroy_workqueue(vpmem->flush_wq);
 }
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
 	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 	drain_workqueue(vpmem->flush_wq);
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
 
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+	virtio_pmem_del_vqs(vpmem);
+
 	return 0;
 }
 
-- 
2.52.0

