Return-Path: <nvdimm+bounces-9186-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8C59B5424
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Oct 2024 21:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 731671C20E63
	for <lists+linux-nvdimm@lfdr.de>; Tue, 29 Oct 2024 20:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DFA20FAB4;
	Tue, 29 Oct 2024 20:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5CIHDKj"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED7E2076DE
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234184; cv=none; b=DQVoEDSlwwTPhAZX8viTkcd9AUpfoJhzCmqsc6C9U+Gg2phIimnzxYUQqGrGDvyMPkoI+8vZtoGR3I3wI19sM0fqjfSzBO7hN/WUI92IbrY+N72UeR6awVZ9h+Tx56Ouw/xYhnwZpxfiUNUFZXEVNUUXfKyW7Ad6IOK+bxBt9wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234184; c=relaxed/simple;
	bh=6NV0fNZDa4iM1BNj9k4XyjoxI/70ROvaukQvk19MsVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ci5XXw1xAMQTbDajGV8ImyoM3CbN2VYE+YUMn31hNFj1/DZwTTOXfQKB/JQw3ITAi0DBZ+VvN8VBpOCmZZpS4v8ERBVrWAwUHXrzuuRedICn7q1x8hHSc1ec89PDTiVKvis83i2CB5/8idzCFNFrroOtYtVcpB5Q+eAw5s7ODsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5CIHDKj; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234181; x=1761770181;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6NV0fNZDa4iM1BNj9k4XyjoxI/70ROvaukQvk19MsVE=;
  b=e5CIHDKj16HE26ERLRfL6+3LIMhadxy0JIpN3kUCKMRsHaXDCOAeXoT2
   T0xSVAJgES4lpFogWndIetbOL7J7dQe7YZ+4/OsKWSVB+z8N1sac5Pr3u
   lDb8VYyfyNBGsTQKDep+lEICf2FHGXLUGAUCllIXQXk+QG5uvSRP3FIlg
   uIofqO+FiONXVBeuBySwtR7EroycjRL8gF2nXd+80Vo2ay+7htX/jVL+3
   1bgLWdVVE0IktXQCdENLSgmiEE5bc2dE2ZeF1tsjzV+5L63IrGejRzNih
   rWaOGwB386BMXid9OG+7Nvrw9mnT73ik50WzhvLkzdbHC/u1rL8wxzk4U
   A==;
X-CSE-ConnectionGUID: Z8v5T4hpQGGAgGChGFSlvQ==
X-CSE-MsgGUID: NwRVftcQQCuKfMAslJFFkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52457695"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52457695"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:36:21 -0700
X-CSE-ConnectionGUID: /q9NL7foSVSQ9lTPJ0qjNQ==
X-CSE-MsgGUID: /WntmMAQS/iZSG0QSqbDIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="119561353"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:36:19 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 29 Oct 2024 15:35:01 -0500
Subject: [PATCH v5 26/27] tools/testing/cxl: Make event logs dynamic
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-26-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=15624;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=6NV0fNZDa4iM1BNj9k4XyjoxI/70ROvaukQvk19MsVE=;
 b=va1o61usRTbPDUr0KouyLqGnWDYNXmRa7EY6k4WHeFY1qFJIZQfyqiMhQ0qZGEMol3ksunKiZ
 TIfaW+8YU26B4W5t6I7J3TMj/U7gEP2WSUP6TzK4kxrUKyNdPJFzemq
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
Changes:
[Jonathan: change handle 0 handling]
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


