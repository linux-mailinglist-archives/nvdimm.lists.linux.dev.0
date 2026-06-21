Return-Path: <nvdimm+bounces-14475-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bhK8C/jhN2q2VAcAu9opvQ
	(envelope-from <nvdimm+bounces-14475-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:07:04 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6C26AAD4C
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 15:07:03 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=EFmv781H;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14475-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14475-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4020C3042923
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Jun 2026 13:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35759367291;
	Sun, 21 Jun 2026 13:03:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D291936682A;
	Sun, 21 Jun 2026 13:03:53 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047035; cv=pass; b=IdBGhN+0cJBAh6tAJd8B9nzKJfd1kqaaykzD55VRUAMF/fzclXw3XeCPL1J8C2t5uJRDdqedOeBbayKLwPtcbpnpxefF2mkaU00w5hCfo3L1dAgrgiGt868Jz5Mnzi0wQLiC6fvxt3deAncpymbvwNRRRFBoPP81bTc1ebtF7RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047035; c=relaxed/simple;
	bh=7M9kmKBZp9rRu0tA2yaME8tBtzESVFG0IxssR+73ZAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZXgeJQTXXkzrGZUf8HVtE6e/8x9JMsK9NXsxsvZw6F7XHs0OYRo6OF3boJk68TOC/iwSwf8z41KNddsFgg5PaH+ewKWzWitvoatCxYVgheII2hrPOz8c/PX2P0uArF4hcoiUHBhGV9WQDC48hPaws255A9jKvMZRUx3HFF0RmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=EFmv781H; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1782047016; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=f9E9qvTYWBNIBDkXm6fgw6tSiaHY/GxLNBJ03Uj9UiPyJPbXyjlv9phHJEYJvsBiLbg82GgVS5wJTZXmM0SKEzkYOpeG5XGID2DVA2Az+cxuXpBLIhJBeu4UKFWrr+7+OBwE4Od8ymL+orH+F9TtOdtm4BIvDqC0KkZGVSJjlrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047016; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LZLBhHbmtjpySzZTarBL23J3mQcNrZwkvgLBIJ78RGM=; 
	b=bAlad01sDqx1GLmgptCqPp1NLsmH+y41m3zan5lt70cBWIFgxgYg/mkrIcuIufj7JKkYLHqgT9lUzY0Pu4vPRlZkxA7UBYAiyOSm4tqSt52GD3dFAt2iMZ5dad7g9R2JARjxq6v1eY5mDi1QcOAdDGrlxVwY86NHsJ7SlpMwioA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047016;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=LZLBhHbmtjpySzZTarBL23J3mQcNrZwkvgLBIJ78RGM=;
	b=EFmv781HFfJZxTBIGc5tZUGUme4fRFChURsdzCnruo146STntdNbJDjOoLv5fwW7
	vtM5gyRbD2Xnwn4ydJD/c5ZUe5rExCE2vlWfhPCpxUxlXiEz8YlZmhIedOfcg4LBfPR
	S7VUGj5aFDr5Y51D1uvCRSXM7T7mHquUEi+1b6sQ=
Received: by mx.zohomail.com with SMTPS id 1782047013626864.9869101777588;
	Sun, 21 Jun 2026 06:03:33 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v6 09/12] nvdimm: virtio_pmem: publish done with release/acquire
Date: Sun, 21 Jun 2026 21:02:40 +0800
Message-ID: <20260621130246.2973254-10-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
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
	TAGGED_FROM(0.00)[bounces-14475-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,intel.com,lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS(0.00)[m:pankaj.gupta.linux@gmail.com,m:dan.j.williams@intel.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:me@linux.beauty,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:from_smtp,linux.beauty:dkim,linux.beauty:email,linux.beauty:mid,linux.beauty:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9C6C26AAD4C

virtio_pmem_host_ack() publishes the device response by setting done and
waking the submitter. The submitter reads resp.ret after wait_event()
observes done.

Use smp_store_release() on done and smp_load_acquire() in the wait
condition so the response read is ordered after completion.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch.

 drivers/nvdimm/nd_virtio.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 7b6761adf28bc..35d36bd36a526 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -17,6 +17,19 @@ static void virtio_pmem_req_release(struct kref *kref)
 	kfree(req);
 }
 
+static void virtio_pmem_signal_done(struct virtio_pmem_request *req)
+{
+	/* Pairs with smp_load_acquire() in virtio_pmem_req_done(). */
+	smp_store_release(&req->done, true);
+	wake_up(&req->host_acked);
+}
+
+static bool virtio_pmem_req_done(struct virtio_pmem_request *req)
+{
+	/* Pairs with smp_store_release() in virtio_pmem_signal_done(). */
+	return smp_load_acquire(&req->done);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -42,8 +55,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		WRITE_ONCE(req_data->done, true);
-		wake_up(&req_data->host_acked);
+		virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -130,7 +142,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
+		wait_event(req_data->host_acked,
+			   virtio_pmem_req_done(req_data));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-- 
2.52.0

