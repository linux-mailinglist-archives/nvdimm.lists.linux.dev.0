Return-Path: <nvdimm+bounces-6345-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BED72750795
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jul 2023 14:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB3872818BF
	for <lists+linux-nvdimm@lfdr.de>; Wed, 12 Jul 2023 12:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F142772C;
	Wed, 12 Jul 2023 12:08:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C07F1F959
	for <nvdimm@lists.linux.dev>; Wed, 12 Jul 2023 12:08:45 +0000 (UTC)
Received: from [134.238.52.102] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qJYdj-00CX6F-BR; Wed, 12 Jul 2023 13:08:16 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qJYdg-0005XT-2O;
	Wed, 12 Jul 2023 13:08:12 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-acpi@vger.kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH v2] ACPI: NFIT: add helper to_nfit_mem() to take device to nfit_mem
Date: Wed, 12 Jul 2023 13:08:10 +0100
Message-Id: <20230712120810.21282-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a quick helper to just do struct device to the struct nfit_mem
field it should be referencing. This reduces the number of code
lines in some of the following code as it removes the intermediate
struct nvdimm.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
v2:
  - fix typo of follwoing
  - add blank line in to_nfit_mem()
---
 drivers/acpi/nfit/core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0fcc247fdfac..b04c8a41380a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1361,18 +1361,23 @@ static const struct attribute_group *acpi_nfit_attribute_groups[] = {
 	NULL,
 };
 
-static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+static struct nfit_mem *to_nfit_mem(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	return nvdimm_provider_data(nvdimm);
+}
+
+static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+{
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return __to_nfit_memdev(nfit_mem);
 }
 
 static struct acpi_nfit_control_region *to_nfit_dcr(struct device *dev)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return nfit_mem->dcr;
 }
@@ -1531,8 +1536,7 @@ static DEVICE_ATTR_RO(serial);
 static ssize_t family_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	if (nfit_mem->family < 0)
 		return -ENXIO;
@@ -1543,8 +1547,7 @@ static DEVICE_ATTR_RO(family);
 static ssize_t dsm_mask_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	if (nfit_mem->family < 0)
 		return -ENXIO;
@@ -1555,8 +1558,7 @@ static DEVICE_ATTR_RO(dsm_mask);
 static ssize_t flags_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 	u16 flags = __to_nfit_memdev(nfit_mem)->flags;
 
 	if (test_bit(NFIT_MEM_DIRTY, &nfit_mem->flags))
@@ -1576,8 +1578,7 @@ static DEVICE_ATTR_RO(flags);
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return sprintf(buf, "%s\n", nfit_mem->id);
 }
@@ -1586,8 +1587,7 @@ static DEVICE_ATTR_RO(id);
 static ssize_t dirty_shutdown_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return sprintf(buf, "%d\n", nfit_mem->dirty_shutdown);
 }
-- 
2.40.1


