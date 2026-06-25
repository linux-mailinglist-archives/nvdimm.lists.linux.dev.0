Return-Path: <nvdimm+bounces-14564-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id C9w8KrIRPWphwggAu9opvQ
	(envelope-from <nvdimm+bounces-14564-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 13:32:02 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A47F06C51EF
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 13:32:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MoF6RZuG;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14564-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 104.64.211.4 as permitted sender) smtp.mailfrom="nvdimm+bounces-14564-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 49339302A803
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 11:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334393DC4B1;
	Thu, 25 Jun 2026 11:29:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F93DBD55
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:58 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386940; cv=none; b=LCOZlontDu32nDR2/Sy918Mk+8NpRTizl9/yhlid4dUSZFgvipwtl+tUgV4ji0kcthbSRfXkcTHs46azHZ7yEAOcoXYd88oXM5+z2lHDUSjInmIP6G9UvWGpsO6DN0xZKDh/BKH55McqK2aYchjheGG9zTbI4X96G/6kfrBggSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386940; c=relaxed/simple;
	bh=lDCI3vzKkNv0kMeo9UgEy9FHiON7O3NPicd0Dj6Khks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpcNc83bd1LUDe/LChpi8KPv+wO7CjyHPA9jbOvc44VodncDvVywaapfOKaGUY7b93Os2M0PnlZWzwm1093TGOwJax3Sp2Zw5MAGljGU1w2yA5TMBtVCNlt2Y5s0ZVb5isCfR6z7C0gax/7ygo/+6oGRz7h/mtA31Lx6iD5Yla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MoF6RZuG; arc=none smtp.client-ip=74.125.82.177
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-30c23abc62eso2419508eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386938; x=1782991738; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gR7m/DSqaMQo7FqxUtVjsmVLITybnD5yvw0NvjsHn0=;
        b=MoF6RZuG6kDkxGyNgi+aQVVhwpgSmP3fGcbOZudnlH/J7/zqxjtp31n+/dItRQ7+7c
         7qXPoCIoiB0kKhJjuXMZt0S4aMbwtlU75Nk378fQUzZ77R7PMaqz+zUyjMhwl7m0HGcr
         YqpcS9FMg3rmD+zVpU9qVrpYcG4R2E4m0Oom6fMLjSQBWN5zhhk0lGcECUbR7XUMeqh1
         P3b6/rm9mdK1AF6cjNU0OhfRCeZ4ymvWyBX/K5/QYMEIje1zAyemH81gVtuFJggVwJKU
         /cnAaKdRJOzWkY7UpiXPbAqk6yynKlrnORoUJEriwzxzQtXQQRnR+4chQp04nmXPchqT
         uluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386938; x=1782991738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gR7m/DSqaMQo7FqxUtVjsmVLITybnD5yvw0NvjsHn0=;
        b=V8Cb6IdiB+fw0kYRrl6wXtdiYd0QydnQ8Pj1Jx6LgZrBGD8kllobx1H9wOFfl15t4G
         vWNrIbLU76VNZBOszmiCX4bJ/NPLevw9/WGNq6kVdnOiJpKmeaUCr56jemUVREuj094c
         v28z5H6+sagjsG6rhu/hAyJGY+PMkVyFbng2vb0yFee2Rdh+mwkXS9z28q5aJmaSZLKH
         NCw9lvhZXcISb1CdQhv1VufRFOxiwe0lTr5j9SimLSchrehMH0vvWQAavr91GZxKvlm+
         hrwq3NvOI3a/PwyoShk9/gpPgztTDM5TFBouzQlTXsZR2Osol/sTBqbuzi+rOhoCqGl/
         iI9Q==
X-Gm-Message-State: AOJu0YxOYWY53ToFhs1c5i1urBIOA2OsXafPIW68nF86Cng898HN7F7M
	ieSZY6kLtVmnFUzVUu1fo3n9UnMCbPOSl4fQBOQFh28ZWCeMA3nxjS8b
X-Gm-Gg: AfdE7clqr2jglb81RarlAjZqoxdSu5D3Zkv62w7fnSzH+gVQgrzoI5/D45lDvIegVRd
	1cJ1mJfjBu7Z93qj/18r/5tM/2buUWke8MGmM1bA5uaG0OleKAB+8tAg0MFBsouHXx8XNK7tM59
	ENUMn3KjifUWpBi5o19lrjHBzLvYymEz/Qie+BRktE21bTHiccRxRwsHeJ/yxQ2k/oVDMjj98Sp
	z+yjUT8rzdwH20WcjjbI9uHHEqlpzz897yBhmXslsxWJgwl0p8WWWd06tZFWKL5PbwYcsM9eVGI
	/mkAXKL44po+wgsYfvAiTzw96bJY+EsJHQ7qgscgIAf0v0rPQF+Je/EThht1zClcH3HfHyZ4Ak3
	rB1huOgBhvm2dAYR52e5MB88iIaHPJf5bT4JRvw/DJM9vTqOYIWHKRA10HyPEQaG0MACxKr8hez
	QD8I80JORTVhdlygczXjniVMQTM0THAVN2XWqjGWRSbQvsTS5l79tHoWY3J7PDUUR2R1+qW/8Vi
	hEiviA=
X-Received: by 2002:a05:7300:2303:b0:307:934e:da79 with SMTP id 5a478bee46e88-30c84e27462mr2850884eec.34.1782386937520;
        Thu, 25 Jun 2026 04:28:57 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:57 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Fan Ni <nifan.cxl@gmail.com>
Subject: [PATCH v11 20/31] cxl/region/extent: Expose dc_extent information in sysfs
Date: Thu, 25 Jun 2026 04:04:57 -0700
Message-ID: <20260625112638.550691-21-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14564-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[anisasu887@gmail.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS(0.00)[m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:dave.jiang@intel.com,m:vishal.l.verma@intel.com,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@Groves.net,m:gourry@gourry.net,m:anisa.su@samsung.com,m:nifan.cxl@gmail.com,m:nifancxl@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[lists.linux.dev,kernel.org,stgolabs.net,intel.com,Groves.net,gourry.net,samsung.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisasu887@gmail.com,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,samsung.com:mid,samsung.com:email,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A47F06C51EF

From: Ira Weiny <iweiny@kernel.org>

Extent information can be helpful to the user to coordinate memory
usage with the external orchestrator and FM.

Expose the details of each dc_extent by creating the following sysfs
entries.

	/sys/bus/cxl/devices/dax_regionX/extentX.Y
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid

Each dc_extent surfaces as its own extentX.Y device under the parent
dax_region.  offset and length describe that dc_extent's HPA range,
not an aggregate bounding box across the containing tagged
allocation — so when a tagged allocation has multiple
DPA-discontiguous extents, each is reported with its own offset and
length.  uuid is the tag identifying the containing allocation; it
is shared across dc_extents that belong to the same tagged
allocation and is hidden for untagged extents.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Tested-by: Fan Ni <nifan.cxl@gmail.com>

---
Changes:
1. Bump kver to 7.3 and date to June 2026
---
 Documentation/ABI/testing/sysfs-bus-cxl | 36 ++++++++++++++++
 drivers/cxl/core/extent.c               | 56 +++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 00b98bbe0ff3..2a3817cc6eef 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -661,3 +661,39 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
+Date:		June, 2026
+KernelVersion:	v7.3
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent offset
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
+Date:		June, 2026
+KernelVersion:	v7.3
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent length
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
+Date:		June, 2026
+KernelVersion:	v7.3
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  UUID of this
+		extent.
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 36be56ca1097..69c993cdd558 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -6,6 +6,61 @@
 
 #include "core.h"
 
+static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	return sysfs_emit(buf, "%#llx\n", dc_extent->hpa_range.start);
+}
+static DEVICE_ATTR_RO(offset);
+
+static ssize_t length_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+	u64 length = range_len(&dc_extent->hpa_range);
+
+	return sysfs_emit(buf, "%#llx\n", length);
+}
+static DEVICE_ATTR_RO(length);
+
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	return sysfs_emit(buf, "%pUb\n", &dc_extent->group->uuid);
+}
+static DEVICE_ATTR_RO(uuid);
+
+static struct attribute *dc_extent_attrs[] = {
+	&dev_attr_offset.attr,
+	&dev_attr_length.attr,
+	&dev_attr_uuid.attr,
+	NULL
+};
+
+static umode_t dc_extent_visible(struct kobject *kobj,
+				 struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	if (a == &dev_attr_uuid.attr &&
+	    uuid_is_null(&dc_extent->group->uuid))
+		return 0;
+
+	return a->mode;
+}
+
+static const struct attribute_group dc_extent_attribute_group = {
+	.attrs = dc_extent_attrs,
+	.is_visible = dc_extent_visible,
+};
+
+__ATTRIBUTE_GROUPS(dc_extent_attribute);
+
 
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct dc_extent *dc_extent)
@@ -99,6 +154,7 @@ static void dc_extent_release(struct device *dev)
 static const struct device_type dc_extent_type = {
 	.name = "extent",
 	.release = dc_extent_release,
+	.groups = dc_extent_attribute_groups,
 };
 
 bool is_dc_extent(struct device *dev)
-- 
2.43.0


