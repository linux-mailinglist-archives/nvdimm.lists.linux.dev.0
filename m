Return-Path: <nvdimm+bounces-9266-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D63D29BD521
	for <lists+linux-nvdimm@lfdr.de>; Tue,  5 Nov 2024 19:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67FF01F264D0
	for <lists+linux-nvdimm@lfdr.de>; Tue,  5 Nov 2024 18:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169DC1F9434;
	Tue,  5 Nov 2024 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWDHfK+t"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B97B1F8F0E
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831979; cv=none; b=khgYX5HkqCTumCu3CkghRL2hpKwH0PbVK+mjLxTu+0wPamvIU1vr/EjgQDwNJBk3MLbksKLUU+X62uXpaWxkgCVuB8l8dX30ZT2xuoe9nUsJXsMm98ZVhxHlOtfLYUVX7N6awF2YNvZ4re5AcdSVv4xpDV2mkdFbM/Dy6LQ6es0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831979; c=relaxed/simple;
	bh=2Vycd2tVNexSZra4jq61u55rDAGYrO2GPqDdjO2Y8Vg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dZ07p+W3IzGh1oXOi19SvcYe2tDWZXF7VzvMpU9HsWSFFzvJZys2EYnZB2yZguPbACUxSNtuXI8tudkxwzrlNX3LrDlc7JVhp+PFZhA8pxmzhItJM0Ouq99j6jpkRx5+Cg8r28GhfYIurzJODduCHV29ZAPsVWE92qbm1rTdtyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eWDHfK+t; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831977; x=1762367977;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=2Vycd2tVNexSZra4jq61u55rDAGYrO2GPqDdjO2Y8Vg=;
  b=eWDHfK+tHgzJuyqL3aGP0Kpw2eq/8tnowJPmuMgl139yv3vzRSR1MdXl
   gElCyhBf79Fhi6SxY2S3TttFUsM0WNrVTy7/H8zl+1tNzMsUixeu7EuFk
   Ag34lQ2js6zl24iPed7fx4l/xKVDC/YDXgIInZSF20ASCgfDukgKv4ysg
   t3YLAS7pr0KPDGRV+YtY9NaP/KVGdL7q+x0uUholIm8Oc1IRz0mUFuhsV
   CFNsXD5SdumtxtNQg7eD30S7Q4uBe57PfxKHeFkEiXT3znCBmYyf1Gdi0
   8IR4IMQHCVrvlrdgJss4N1qGQsfGmjXcyj1KSxZF+qZdFc2OL46tIIO4R
   g==;
X-CSE-ConnectionGUID: Gqgln9c2RyuhIml3ZnHxdQ==
X-CSE-MsgGUID: U72mzpzLQuic6eB/NJ3Xaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30771354"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30771354"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:37 -0800
X-CSE-ConnectionGUID: qVmRfygyQhSF/2mSBF7e/Q==
X-CSE-MsgGUID: bpxM31UOS3K5aUqYBCmmDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88916724"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:36 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:48 -0600
Subject: [PATCH v6 26/27] tools/testing/cxl: Make event logs dynamic
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-26-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=15571;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=2Vycd2tVNexSZra4jq61u55rDAGYrO2GPqDdjO2Y8Vg=;
 b=iEFRSZlyDIxIaNuaOnJ4FGBmOz5gtrkvoHRijY3Qvsmt9lKBEpFgp8uf47m/VL6H3ybjlJrbq
 G/73KoMnjKMCkSq/nNQRbfdZagY95A5fcdp0isu3HxqKRuyF4QwfxUW
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

The event logs test was created as static arrays as an easy way to mock
events.  Dynamic Capacity Device (DCD) test support requires events be
generated dynamically when extents are created or destroyed.

The current event log test has specific checks for the number of events
seen including log overflow.

Modify mock event logs to be dynamically allocated.  Adjust array size
and mock event entry data to match the output expected by the existing
event test.

Use the static event data to create the dynamic events in the new logs
without inventing complex event injection for the previous tests.

Simplify log processing by using the event log array index as the
handle.  Add a lock to manage concurrency required when user space is
allowed to control DCD extents

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 tools/testing/cxl/test/mem.c | 268 ++++++++++++++++++++++++++-----------------
 1 file changed, 162 insertions(+), 106 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index ad5c4c18c5c643aff7180a686c1990a136069f6d..611cd9677cd0a63214322189efb4ef9fb3a1ceb6 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -126,18 +126,26 @@ static struct {
 
 #define PASS_TRY_LIMIT 3
 
-#define CXL_TEST_EVENT_CNT_MAX 15
+#define CXL_TEST_EVENT_CNT_MAX 16
+/* 1 extra slot to accommodate that handles can't be 0 */
+#define CXL_TEST_EVENT_ARRAY_SIZE (CXL_TEST_EVENT_CNT_MAX + 1)
 
 /* Set a number of events to return at a time for simulation.  */
 #define CXL_TEST_EVENT_RET_MAX 4
 
+/*
+ * @last_handle: last handle (index) to have an entry stored
+ * @current_handle: current handle (index) to be returned to the user on get_event
+ * @nr_overflow: number of events added past the log size
+ * @lock: protect these state variables
+ * @events: array of pending events to be returned.
+ */
 struct mock_event_log {
-	u16 clear_idx;
-	u16 cur_idx;
-	u16 nr_events;
+	u16 last_handle;
+	u16 current_handle;
 	u16 nr_overflow;
-	u16 overflow_reset;
-	struct cxl_event_record_raw *events[CXL_TEST_EVENT_CNT_MAX];
+	rwlock_t lock;
+	struct cxl_event_record_raw *events[CXL_TEST_EVENT_ARRAY_SIZE];
 };
 
 struct mock_event_store {
@@ -172,56 +180,65 @@ static struct mock_event_log *event_find_log(struct device *dev, int log_type)
 	return &mdata->mes.mock_logs[log_type];
 }
 
-static struct cxl_event_record_raw *event_get_current(struct mock_event_log *log)
-{
-	return log->events[log->cur_idx];
-}
-
-static void event_reset_log(struct mock_event_log *log)
-{
-	log->cur_idx = 0;
-	log->clear_idx = 0;
-	log->nr_overflow = log->overflow_reset;
-}
-
 /* Handle can never be 0 use 1 based indexing for handle */
-static u16 event_get_clear_handle(struct mock_event_log *log)
+static u16 event_inc_handle(u16 handle)
 {
-	return log->clear_idx + 1;
+	handle = (handle + 1) % CXL_TEST_EVENT_ARRAY_SIZE;
+	if (handle == 0)
+		handle = 1;
+	return handle;
 }
 
-/* Handle can never be 0 use 1 based indexing for handle */
-static __le16 event_get_cur_event_handle(struct mock_event_log *log)
-{
-	u16 cur_handle = log->cur_idx + 1;
-
-	return cpu_to_le16(cur_handle);
-}
-
-static bool event_log_empty(struct mock_event_log *log)
-{
-	return log->cur_idx == log->nr_events;
-}
-
-static void mes_add_event(struct mock_event_store *mes,
+/* Add the event or free it on overflow */
+static void mes_add_event(struct cxl_mockmem_data *mdata,
 			  enum cxl_event_log_type log_type,
 			  struct cxl_event_record_raw *event)
 {
+	struct device *dev = mdata->mds->cxlds.dev;
 	struct mock_event_log *log;
 
 	if (WARN_ON(log_type >= CXL_EVENT_TYPE_MAX))
 		return;
 
-	log = &mes->mock_logs[log_type];
+	log = &mdata->mes.mock_logs[log_type];
+
+	guard(write_lock)(&log->lock);
 
-	if ((log->nr_events + 1) > CXL_TEST_EVENT_CNT_MAX) {
+	dev_dbg(dev, "Add log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
+
+	/* Check next buffer */
+	if (event_inc_handle(log->last_handle) == log->current_handle) {
 		log->nr_overflow++;
-		log->overflow_reset = log->nr_overflow;
+		dev_dbg(dev, "Overflowing log %d nr %d\n",
+			log_type, log->nr_overflow);
+		devm_kfree(dev, event);
 		return;
 	}
 
-	log->events[log->nr_events] = event;
-	log->nr_events++;
+	dev_dbg(dev, "Log %d; handle %u\n", log_type, log->last_handle);
+	event->event.generic.hdr.handle = cpu_to_le16(log->last_handle);
+	log->events[log->last_handle] = event;
+	log->last_handle = event_inc_handle(log->last_handle);
+}
+
+static void mes_del_event(struct device *dev,
+			  struct mock_event_log *log,
+			  u16 handle)
+{
+	struct cxl_event_record_raw *record;
+
+	lockdep_assert(lockdep_is_held(&log->lock));
+
+	dev_dbg(dev, "Clearing event %u; record %u\n",
+		handle, log->current_handle);
+	record = log->events[handle];
+	if (!record)
+		dev_err(dev, "Mock event index %u empty?\n", handle);
+
+	log->events[handle] = NULL;
+	log->current_handle = event_inc_handle(log->current_handle);
+	devm_kfree(dev, record);
 }
 
 /*
@@ -234,7 +251,7 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_get_event_payload *pl;
 	struct mock_event_log *log;
-	u16 nr_overflow;
+	u16 handle;
 	u8 log_type;
 	int i;
 
@@ -255,29 +272,38 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	memset(cmd->payload_out, 0, struct_size(pl, records, 0));
 
 	log = event_find_log(dev, log_type);
-	if (!log || event_log_empty(log))
+	if (!log)
 		return 0;
 
 	pl = cmd->payload_out;
 
-	for (i = 0; i < ret_limit && !event_log_empty(log); i++) {
-		memcpy(&pl->records[i], event_get_current(log),
-		       sizeof(pl->records[i]));
-		pl->records[i].event.generic.hdr.handle =
-				event_get_cur_event_handle(log);
-		log->cur_idx++;
+	guard(read_lock)(&log->lock);
+
+	handle = log->current_handle;
+	dev_dbg(dev, "Get log %d handle %u last %u\n",
+		log_type, handle, log->last_handle);
+	for (i = 0; i < ret_limit && handle != log->last_handle;
+	     i++, handle = event_inc_handle(handle)) {
+		struct cxl_event_record_raw *cur;
+
+		cur = log->events[handle];
+		dev_dbg(dev, "Sending event log %d handle %d idx %u\n",
+			log_type, le16_to_cpu(cur->event.generic.hdr.handle),
+			handle);
+		memcpy(&pl->records[i], cur, sizeof(pl->records[i]));
+		pl->records[i].event.generic.hdr.handle = cpu_to_le16(handle);
 	}
 
 	cmd->size_out = struct_size(pl, records, i);
 	pl->record_count = cpu_to_le16(i);
-	if (!event_log_empty(log))
+	if (handle != log->last_handle)
 		pl->flags |= CXL_GET_EVENT_FLAG_MORE_RECORDS;
 
 	if (log->nr_overflow) {
 		u64 ns;
 
 		pl->flags |= CXL_GET_EVENT_FLAG_OVERFLOW;
-		pl->overflow_err_count = cpu_to_le16(nr_overflow);
+		pl->overflow_err_count = cpu_to_le16(log->nr_overflow);
 		ns = ktime_get_real_ns();
 		ns -= 5000000000; /* 5s ago */
 		pl->first_overflow_timestamp = cpu_to_le64(ns);
@@ -292,8 +318,8 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
-	struct mock_event_log *log;
 	u8 log_type = pl->event_log;
+	struct mock_event_log *log;
 	u16 handle;
 	int nr;
 
@@ -304,23 +330,20 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	if (!log)
 		return 0; /* No mock data in this log */
 
-	/*
-	 * This check is technically not invalid per the specification AFAICS.
-	 * (The host could 'guess' handles and clear them in order).
-	 * However, this is not good behavior for the host so test it.
-	 */
-	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
-		dev_err(dev,
-			"Attempting to clear more events than returned!\n");
-		return -EINVAL;
-	}
+	guard(write_lock)(&log->lock);
 
 	/* Check handle order prior to clearing events */
-	for (nr = 0, handle = event_get_clear_handle(log);
-	     nr < pl->nr_recs;
-	     nr++, handle++) {
+	handle = log->current_handle;
+	for (nr = 0; nr < pl->nr_recs && handle != log->last_handle;
+	     nr++, handle = event_inc_handle(handle)) {
+
+		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
+			log_type, handle,
+			le16_to_cpu(pl->handles[nr]));
+
 		if (handle != le16_to_cpu(pl->handles[nr])) {
-			dev_err(dev, "Clearing events out of order\n");
+			dev_err(dev, "Clearing events out of order %u %u\n",
+				handle, le16_to_cpu(pl->handles[nr]));
 			return -EINVAL;
 		}
 	}
@@ -329,25 +352,12 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 		log->nr_overflow = 0;
 
 	/* Clear events */
-	log->clear_idx += pl->nr_recs;
-	return 0;
-}
-
-static void cxl_mock_event_trigger(struct device *dev)
-{
-	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
-	struct mock_event_store *mes = &mdata->mes;
-	int i;
+	for (nr = 0; nr < pl->nr_recs; nr++)
+		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));
+	dev_dbg(dev, "Delete log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
 
-	for (i = CXL_EVENT_TYPE_INFO; i < CXL_EVENT_TYPE_MAX; i++) {
-		struct mock_event_log *log;
-
-		log = event_find_log(dev, i);
-		if (log)
-			event_reset_log(log);
-	}
-
-	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+	return 0;
 }
 
 struct cxl_event_record_raw maint_needed = {
@@ -476,8 +486,27 @@ static int mock_set_timestamp(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
-static void cxl_mock_add_event_logs(struct mock_event_store *mes)
+/* Create a dynamically allocated event out of a statically defined event. */
+static void add_event_from_static(struct cxl_mockmem_data *mdata,
+				  enum cxl_event_log_type log_type,
+				  struct cxl_event_record_raw *raw)
+{
+	struct device *dev = mdata->mds->cxlds.dev;
+	struct cxl_event_record_raw *rec;
+
+	rec = devm_kmemdup(dev, raw, sizeof(*rec), GFP_KERNEL);
+	if (!rec) {
+		dev_err(dev, "Failed to alloc event for log\n");
+		return;
+	}
+	mes_add_event(mdata, log_type, rec);
+}
+
+static void cxl_mock_add_event_logs(struct cxl_mockmem_data *mdata)
 {
+	struct mock_event_store *mes = &mdata->mes;
+	struct device *dev = mdata->mds->cxlds.dev;
+
 	put_unaligned_le16(CXL_GMER_VALID_CHANNEL | CXL_GMER_VALID_RANK,
 			   &gen_media.rec.media_hdr.validity_flags);
 
@@ -485,43 +514,60 @@ static void cxl_mock_add_event_logs(struct mock_event_store *mes)
 			   CXL_DER_VALID_BANK | CXL_DER_VALID_COLUMN,
 			   &dram.rec.media_hdr.validity_flags);
 
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_INFO);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO, &maint_needed);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&mem_module);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_INFO;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FAIL);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &maint_needed);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
+		      (struct cxl_event_record_raw *)&mem_module);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&mem_module);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
 	/* Overflow this log */
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FAIL;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FATAL);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL, &hardware_replace);
+	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL,
 		      (struct cxl_event_record_raw *)&dram);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FATAL;
 }
 
+static void cxl_mock_event_trigger(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct mock_event_store *mes = &mdata->mes;
+
+	cxl_mock_add_event_logs(mdata);
+	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+}
+
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
 {
 	if (cmd->size_out < sizeof(mock_gsl_payload))
@@ -1469,6 +1515,14 @@ static int cxl_mock_mailbox_create(struct cxl_dev_state *cxlds)
 	return 0;
 }
 
+static void init_event_log(struct mock_event_log *log)
+{
+	rwlock_init(&log->lock);
+	/* Handle can never be 0 use 1 based indexing for handle */
+	log->current_handle = 1;
+	log->last_handle = 1;
+}
+
 static int cxl_mock_mem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1541,7 +1595,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-	cxl_mock_add_event_logs(&mdata->mes);
+	for (int i = 0; i < CXL_EVENT_TYPE_MAX; i++)
+		init_event_log(&mdata->mes.mock_logs[i]);
+	cxl_mock_add_event_logs(mdata);
 
 	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds);
 	if (IS_ERR(cxlmd))

-- 
2.47.0


