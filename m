Return-Path: <nvdimm+bounces-9009-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63212993B1A
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Oct 2024 01:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE86EB24C4C
	for <lists+linux-nvdimm@lfdr.de>; Mon,  7 Oct 2024 23:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67811E0B7A;
	Mon,  7 Oct 2024 23:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ex0Wtc8m"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1A1E0B62
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343053; cv=none; b=WInZKGssYVP+z7QSQ+5/NK4QakUOIr78nZaBdaKQliQ56ijRuRBQVMVvAaUD79LVfdvKt2pCS4MRRmQR+9AfylCDc1awX4CJHjS1VRylAzfToSqUVTxZaerX08dLoZaFAJOkVFQGWB+RRSOmHp48a6Esf0HrfxOYwGAXGsYJoYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343053; c=relaxed/simple;
	bh=25abfl2BS9dFkTdXX0+31aST06TnuN8czjzUJuskVdg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FVsOoFbKY4+xDB36uS0OfDQm+awTm4ydbPeix/ijOYfzjYiF1e2FWwLegKi8Q0GRv/6CTFdjfNsQrIs3tjIjFPo2uy0TYhleUrjnP8TP9K+6ZNhKEX5dGdSt+aI9v64AIRq6cy/Wq6YkjRzoFMPn8LsceNQs6nDETQaFmiFGFaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ex0Wtc8m; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343052; x=1759879052;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=25abfl2BS9dFkTdXX0+31aST06TnuN8czjzUJuskVdg=;
  b=Ex0Wtc8mletVd7lHAEGfpNrtCageEAfCNleYyRFiJxiiQ27V3kWva4Of
   qoA3SxSQfUDt/9sbsG6CDFkwjHoxSiKsyTIotEe3GqOFDRxYSEbmbTVN+
   JMAQa0XsPhQisDW1sYHsD/Cr0W8KVBPI+c0aTWFFYLIMQSzom1YNmPXXy
   DwHuklfCTSdJpxiBDzoxAD1pMJquQbp00MqUCFjZ48QwuzQQc0R0iZ56Z
   1ZStuWvXR4tv9IqGfKDzz2cMuEQzB1KXpiyBmmyPp4bABWXbh2VWXbiW8
   4GVMT8YZBH+Q8oOQP13bTTiZmxt1MeMGDTbX8igoMLz2pkwrvnS3zI3gf
   Q==;
X-CSE-ConnectionGUID: 9uWsjolGRvW5Im0qMKZvmQ==
X-CSE-MsgGUID: szx0HzgRRHaRZXman2MzgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="26972709"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="26972709"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:31 -0700
X-CSE-ConnectionGUID: I+zbHvZ7S9eNid67cB76JQ==
X-CSE-MsgGUID: YrITNL93QN6Fb5wFlI0eSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="76001840"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:28 -0700
From: ira.weiny@intel.com
Date: Mon, 07 Oct 2024 18:16:32 -0500
Subject: [PATCH v4 26/28] cxl/mem: Trace Dynamic capacity Event Record
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-26-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=3361;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=LdRVXAlR9eD7J7gxqAsHuSXAaD3qE9l34vZICTobZvE=;
 b=+zQoVSnmNQpvyXPhGHtglbkqJ/dPkWI8LLj7+oEsMA+Kf4W/aImQ9j0Z1X8yEJKhDBvqlorEn
 0YLC1sIZ2p1AwelUr2W236aRoWU9d4AV3ko17j9Uhpaxll9Jvg5miXz
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djiang: Use 3.1 spec reference]
---
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 6b25d15403a3..816e28cc5a40 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -994,6 +994,10 @@ static void __cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		ev_type = CXL_CPER_EVENT_DRAM;
 	else if (uuid_equal(uuid, &CXL_EVENT_MEM_MODULE_UUID))
 		ev_type = CXL_CPER_EVENT_MEM_MODULE;
+	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
+		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
+		return;
+	}
 
 	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index 9167cfba7f59..1303024b5239 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -731,6 +731,71 @@ TRACE_EVENT(cxl_poison,
 	)
 );
 
+/*
+ * Dynamic Capacity Event Record - DER
+ *
+ * CXL rev 3.1 section 8.2.9.2.1.6 Table 8-50
+ */
+
+#define CXL_DC_ADD_CAPACITY			0x00
+#define CXL_DC_REL_CAPACITY			0x01
+#define CXL_DC_FORCED_REL_CAPACITY		0x02
+#define CXL_DC_REG_CONF_UPDATED			0x03
+#define show_dc_evt_type(type)	__print_symbolic(type,		\
+	{ CXL_DC_ADD_CAPACITY,	"Add capacity"},		\
+	{ CXL_DC_REL_CAPACITY,	"Release capacity"},		\
+	{ CXL_DC_FORCED_REL_CAPACITY,	"Forced capacity release"},	\
+	{ CXL_DC_REG_CONF_UPDATED,	"Region Configuration Updated"	} \
+)
+
+TRACE_EVENT(cxl_dynamic_capacity,
+
+	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
+		 struct cxl_event_dcd *rec),
+
+	TP_ARGS(cxlmd, log, rec),
+
+	TP_STRUCT__entry(
+		CXL_EVT_TP_entry
+
+		/* Dynamic capacity Event */
+		__field(u8, event_type)
+		__field(u16, hostid)
+		__field(u8, region_id)
+		__field(u64, dpa_start)
+		__field(u64, length)
+		__array(u8, tag, CXL_EXTENT_TAG_LEN)
+		__field(u16, sh_extent_seq)
+	),
+
+	TP_fast_assign(
+		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
+
+		/* Dynamic_capacity Event */
+		__entry->event_type = rec->event_type;
+
+		/* DCD event record data */
+		__entry->hostid = le16_to_cpu(rec->host_id);
+		__entry->region_id = rec->region_index;
+		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
+		__entry->length = le64_to_cpu(rec->extent.length);
+		memcpy(__entry->tag, &rec->extent.tag, CXL_EXTENT_TAG_LEN);
+		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
+	),
+
+	CXL_EVT_TP_printk("event_type='%s' host_id='%d' region_id='%d' " \
+		"starting_dpa=%llx length=%llx tag=%s " \
+		"shared_extent_sequence=%d",
+		show_dc_evt_type(__entry->event_type),
+		__entry->hostid,
+		__entry->region_id,
+		__entry->dpa_start,
+		__entry->length,
+		__print_hex(__entry->tag, CXL_EXTENT_TAG_LEN),
+		__entry->sh_extent_seq
+	)
+);
+
 #endif /* _CXL_EVENTS_H */
 
 #define TRACE_INCLUDE_FILE trace

-- 
2.46.0


