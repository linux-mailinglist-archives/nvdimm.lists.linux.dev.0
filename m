Return-Path: <nvdimm+bounces-4288-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C39575874
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 02:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D8ED1C20A2F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Jul 2022 00:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143997463;
	Fri, 15 Jul 2022 00:04:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A77460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843493; x=1689379493;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DGEzL9znCuaboJ+RyfY9Q0LRbffLG45ke94gDuGE16E=;
  b=lEoGrsfE3Kq3Mfu15p1NzYpekpuvJo/UZ5iLt/GhqhH31RTTN3pp32Ip
   bcJ+KRggkcTgsSGFRo1s7lQ/SKRrHOiKyTKwB2IdNe2eHXKghFG0rqPQb
   aCXV2lZEE5eSn4UInv+sS1J1CQy79GAe1AQ9a6rB8/vevKNslTl4GpEzO
   vxB7ylqTVAX3IhJrGOwl3CUTmmfV+uuOdv8cV+zxNR9zgN8uaYLTKMSa1
   OYpon85VnWflrqXab3u92nqO7SQnwpoZ2ZbLiLDGQ97iuBUp9G6mPm7rt
   6UZptyaJljeIE427b+8KXQiNwNrxewGqYlNN/wUWWtYzWi7r34aPY3seW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="349627696"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="349627696"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="628897286"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:04 -0700
Subject: [PATCH v2 25/28] cxl/hdm: Commit decoder state to hardware
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: hch@lst.de, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:03:04 -0700
Message-ID: <165784338418.1758207.14659830845389904356.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

After all the soft validation of the region has completed, convey the
region configuration to hardware while being careful to commit decoders
in specification mandated order. In addition to programming the endpoint
decoder base-address, interleave ways and granularity, the switch
decoder target lists are also established.

While the kernel can enforce spec-mandated commit order, it can not
enforce spec-mandated reset order. For example, the kernel can't stop
someone from removing an endpoint device that is occupying decoderN in a
switch decoder where decoderN+1 is also committed. To reset decoderN,
decoderN+1 must be torn down first. That "tear down the world"
implementation is saved for a follow-on patch.

Callback operations are provided for the 'commit' and 'reset'
operations. While those callbacks may prove useful for CXL accelerators
(Type-2 devices with memory) the primary motivation is to enable a
simple way for cxl_test to intercept those operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |   16 ++
 drivers/cxl/core/hdm.c                  |  218 +++++++++++++++++++++++++++++++
 drivers/cxl/core/port.c                 |    1 
 drivers/cxl/core/region.c               |  194 ++++++++++++++++++++++++++--
 drivers/cxl/cxl.h                       |   13 ++
 tools/testing/cxl/test/cxl.c            |   46 +++++++
 6 files changed, 477 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 94e19e24de8d..2c42888a3df0 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -361,3 +361,19 @@ Description:
 		not an endpoint decoder. Once all positions have been
 		successfully written a final validation for decode conflicts is
 		performed before activating the region.
+
+
+What:		/sys/bus/cxl/devices/regionZ/commit
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Write a boolean 'true' string value to this attribute to
+		trigger the region to transition from the software programmed
+		state to the actively decoding in hardware state. The commit
+		operation in addition to validating that the region is in proper
+		configured state, validates that the decoders are being
+		committed in spec mandated order (last committed decoder id +
+		1), and checks that the hardware accepts the commit request.
+		Reading this value indicates whether the region is committed or
+		not.
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 81645de1064f..88edb8391fbd 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -129,6 +129,8 @@ struct cxl_hdm *devm_cxl_setup_hdm(struct cxl_port *port)
 		return ERR_PTR(-ENXIO);
 	}
 
+	dev_set_drvdata(dev, cxlhdm);
+
 	return cxlhdm;
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_setup_hdm, CXL);
@@ -462,6 +464,213 @@ int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)
 	return devm_add_action_or_reset(&port->dev, cxl_dpa_release, cxled);
 }
 
+static void cxld_set_interleave(struct cxl_decoder *cxld, u32 *ctrl)
+{
+	u16 eig;
+	u8 eiw;
+
+	ways_to_cxl(cxld->interleave_ways, &eiw);
+	granularity_to_cxl(cxld->interleave_granularity, &eig);
+
+	u32p_replace_bits(ctrl, eig, CXL_HDM_DECODER0_CTRL_IG_MASK);
+	u32p_replace_bits(ctrl, eiw, CXL_HDM_DECODER0_CTRL_IW_MASK);
+	*ctrl |= CXL_HDM_DECODER0_CTRL_COMMIT;
+}
+
+static void cxld_set_type(struct cxl_decoder *cxld, u32 *ctrl)
+{
+	u32p_replace_bits(ctrl, !!(cxld->target_type == 3),
+			  CXL_HDM_DECODER0_CTRL_TYPE);
+}
+
+static void cxld_set_hpa(struct cxl_decoder *cxld, u64 *base, u64 *size)
+{
+	struct cxl_region *cxlr = cxld->region;
+	struct cxl_region_params *p = &cxlr->params;
+
+	cxld->hpa_range = (struct range) {
+		.start = p->res->start,
+		.end = p->res->end,
+	};
+
+	*base = p->res->start;
+	*size = resource_size(p->res);
+}
+
+static void cxld_clear_hpa(struct cxl_decoder *cxld)
+{
+	cxld->hpa_range = (struct range) {
+		.start = 0,
+		.end = -1,
+	};
+}
+
+static int cxlsd_set_targets(struct cxl_switch_decoder *cxlsd, u64 *tgt)
+{
+	struct cxl_dport **t = &cxlsd->target[0];
+	int ways = cxlsd->cxld.interleave_ways;
+
+	if (dev_WARN_ONCE(&cxlsd->cxld.dev,
+			  ways > 8 || ways > cxlsd->nr_targets,
+			  "ways: %d overflows targets: %d\n", ways,
+			  cxlsd->nr_targets))
+		return -ENXIO;
+
+	*tgt = FIELD_PREP(GENMASK(7, 0), t[0]->port_id);
+	if (ways > 1)
+		*tgt |= FIELD_PREP(GENMASK(15, 8), t[1]->port_id);
+	if (ways > 2)
+		*tgt |= FIELD_PREP(GENMASK(23, 16), t[2]->port_id);
+	if (ways > 3)
+		*tgt |= FIELD_PREP(GENMASK(31, 24), t[3]->port_id);
+	if (ways > 4)
+		*tgt |= FIELD_PREP(GENMASK_ULL(39, 32), t[4]->port_id);
+	if (ways > 5)
+		*tgt |= FIELD_PREP(GENMASK_ULL(47, 40), t[5]->port_id);
+	if (ways > 6)
+		*tgt |= FIELD_PREP(GENMASK_ULL(55, 48), t[6]->port_id);
+	if (ways > 7)
+		*tgt |= FIELD_PREP(GENMASK_ULL(63, 56), t[7]->port_id);
+
+	return 0;
+}
+
+/*
+ * Per CXL 2.0 8.2.5.12.20 Committing Decoder Programming, hardware must set
+ * committed or error within 10ms, but just be generous with 20ms to account for
+ * clock skew and other marginal behavior
+ */
+#define COMMIT_TIMEOUT_MS 20
+static int cxld_await_commit(void __iomem *hdm, int id)
+{
+	u32 ctrl;
+	int i;
+
+	for (i = 0; i < COMMIT_TIMEOUT_MS; i++) {
+		ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
+		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMIT_ERROR, ctrl)) {
+			ctrl &= ~CXL_HDM_DECODER0_CTRL_COMMIT;
+			writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
+			return -EIO;
+		}
+		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl))
+			return 0;
+		fsleep(1000);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int cxl_decoder_commit(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct cxl_hdm *cxlhdm = dev_get_drvdata(&port->dev);
+	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
+	int id = cxld->id, rc;
+	u64 base, size;
+	u32 ctrl;
+
+	if (cxld->flags & CXL_DECODER_F_ENABLE)
+		return 0;
+
+	if (port->commit_end + 1 != id) {
+		dev_dbg(&port->dev,
+			"%s: out of order commit, expected decoder%d.%d\n",
+			dev_name(&cxld->dev), port->id, port->commit_end + 1);
+		return -EBUSY;
+	}
+
+	down_read(&cxl_dpa_rwsem);
+	/* common decoder settings */
+	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(cxld->id));
+	cxld_set_interleave(cxld, &ctrl);
+	cxld_set_type(cxld, &ctrl);
+	cxld_set_hpa(cxld, &base, &size);
+
+	writel(upper_32_bits(base), hdm + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(id));
+	writel(lower_32_bits(base), hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(id));
+	writel(upper_32_bits(size), hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(id));
+	writel(lower_32_bits(size), hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(id));
+
+	if (is_switch_decoder(&cxld->dev)) {
+		struct cxl_switch_decoder *cxlsd =
+			to_cxl_switch_decoder(&cxld->dev);
+		void __iomem *tl_hi = hdm + CXL_HDM_DECODER0_TL_HIGH(id);
+		void __iomem *tl_lo = hdm + CXL_HDM_DECODER0_TL_LOW(id);
+		u64 targets;
+
+		rc = cxlsd_set_targets(cxlsd, &targets);
+		if (rc) {
+			dev_dbg(&port->dev, "%s: target configuration error\n",
+				dev_name(&cxld->dev));
+			goto err;
+		}
+
+		writel(upper_32_bits(targets), tl_hi);
+		writel(lower_32_bits(targets), tl_lo);
+	} else {
+		struct cxl_endpoint_decoder *cxled =
+			to_cxl_endpoint_decoder(&cxld->dev);
+		void __iomem *sk_hi = hdm + CXL_HDM_DECODER0_SKIP_HIGH(id);
+		void __iomem *sk_lo = hdm + CXL_HDM_DECODER0_SKIP_LOW(id);
+
+		writel(upper_32_bits(cxled->skip), sk_hi);
+		writel(lower_32_bits(cxled->skip), sk_lo);
+	}
+
+	writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
+	up_read(&cxl_dpa_rwsem);
+
+	port->commit_end++;
+	rc = cxld_await_commit(hdm, cxld->id);
+err:
+	if (rc) {
+		dev_dbg(&port->dev, "%s: error %d committing decoder\n",
+			dev_name(&cxld->dev), rc);
+		cxld->reset(cxld);
+		return rc;
+	}
+	cxld->flags |= CXL_DECODER_F_ENABLE;
+
+	return 0;
+}
+
+static int cxl_decoder_reset(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct cxl_hdm *cxlhdm = dev_get_drvdata(&port->dev);
+	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
+	int id = cxld->id;
+	u32 ctrl;
+
+	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
+		return 0;
+
+	if (port->commit_end != id) {
+		dev_dbg(&port->dev,
+			"%s: out of order reset, expected decoder%d.%d\n",
+			dev_name(&cxld->dev), port->id, port->commit_end);
+		return -EBUSY;
+	}
+
+	down_read(&cxl_dpa_rwsem);
+	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
+	ctrl &= ~CXL_HDM_DECODER0_CTRL_COMMIT;
+	writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
+
+	cxld_clear_hpa(cxld);
+	writel(0, hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(id));
+	writel(0, hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(id));
+	writel(0, hdm + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(id));
+	writel(0, hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(id));
+	up_read(&cxl_dpa_rwsem);
+
+	port->commit_end--;
+	cxld->flags &= ~CXL_DECODER_F_ENABLE;
+
+	return 0;
+}
+
 static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			    int *target_map, void __iomem *hdm, int which,
 			    u64 *dpa_base)
@@ -484,6 +693,8 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	base = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
 	size = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
 	committed = !!(ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED);
+	cxld->commit = cxl_decoder_commit;
+	cxld->reset = cxl_decoder_reset;
 
 	if (!committed)
 		size = 0;
@@ -507,6 +718,13 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			cxld->target_type = CXL_DECODER_EXPANDER;
 		else
 			cxld->target_type = CXL_DECODER_ACCELERATOR;
+		if (cxld->id != port->commit_end + 1) {
+			dev_warn(&port->dev,
+				 "decoder%d.%d: Committed out of order\n",
+				 port->id, cxld->id);
+			return -ENXIO;
+		}
+		port->commit_end = cxld->id;
 	} else {
 		/* unless / until type-2 drivers arrive, assume type-3 */
 		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_TYPE, ctrl) == 0) {
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 215ce5e16986..7ab9a98c5d4f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -632,6 +632,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	port->component_reg_phys = component_reg_phys;
 	ida_init(&port->decoder_ida);
 	port->hdm_end = -1;
+	port->commit_end = -1;
 	xa_init(&port->dports);
 	xa_init(&port->endpoints);
 	xa_init(&port->regions);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 225340529fc3..de794344d964 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -115,6 +115,173 @@ static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(uuid);
 
+static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
+					  struct cxl_region *cxlr)
+{
+	return xa_load(&port->regions, (unsigned long)cxlr);
+}
+
+static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int i;
+
+	for (i = count - 1; i >= 0; i--) {
+		struct cxl_endpoint_decoder *cxled = p->targets[i];
+		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+		struct cxl_port *iter = cxled_to_port(cxled);
+		struct cxl_ep *ep;
+		int rc;
+
+		while (!is_cxl_root(to_cxl_port(iter->dev.parent)))
+			iter = to_cxl_port(iter->dev.parent);
+
+		for (ep = cxl_ep_load(iter, cxlmd); iter;
+		     iter = ep->next, ep = cxl_ep_load(iter, cxlmd)) {
+			struct cxl_region_ref *cxl_rr;
+			struct cxl_decoder *cxld;
+
+			cxl_rr = cxl_rr_load(iter, cxlr);
+			cxld = cxl_rr->decoder;
+			rc = cxld->reset(cxld);
+			if (rc)
+				return rc;
+		}
+
+		rc = cxled->cxld.reset(&cxled->cxld);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int cxl_region_decode_commit(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int i, rc;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		struct cxl_endpoint_decoder *cxled = p->targets[i];
+		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+		struct cxl_region_ref *cxl_rr;
+		struct cxl_decoder *cxld;
+		struct cxl_port *iter;
+		struct cxl_ep *ep;
+
+		/* commit bottom up */
+		for (iter = cxled_to_port(cxled); !is_cxl_root(iter);
+		     iter = to_cxl_port(iter->dev.parent)) {
+			cxl_rr = cxl_rr_load(iter, cxlr);
+			cxld = cxl_rr->decoder;
+			rc = cxld->commit(cxld);
+			if (rc)
+				break;
+		}
+
+		/* success, all decoders up to the root are programmed */
+		if (is_cxl_root(iter))
+			continue;
+
+		/* programming @iter failed, teardown */
+		for (ep = cxl_ep_load(iter, cxlmd); ep && iter;
+		     iter = ep->next, ep = cxl_ep_load(iter, cxlmd)) {
+			cxl_rr = cxl_rr_load(iter, cxlr);
+			cxld = cxl_rr->decoder;
+			cxld->reset(cxld);
+		}
+
+		cxled->cxld.reset(&cxled->cxld);
+		if (i == 0)
+			return rc;
+		break;
+	}
+
+	if (i >= p->nr_targets)
+		return 0;
+
+	/* undo the targets that were successfully committed */
+	cxl_region_decode_reset(cxlr, i);
+	return rc;
+}
+
+static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	bool commit;
+	ssize_t rc;
+
+	rc = kstrtobool(buf, &commit);
+	if (rc)
+		return rc;
+
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+
+	/* Already in the requested state? */
+	if (commit && p->state >= CXL_CONFIG_COMMIT)
+		goto out;
+	if (!commit && p->state < CXL_CONFIG_COMMIT)
+		goto out;
+
+	/* Not ready to commit? */
+	if (commit && p->state < CXL_CONFIG_ACTIVE) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (commit)
+		rc = cxl_region_decode_commit(cxlr);
+	else {
+		p->state = CXL_CONFIG_RESET_PENDING;
+		up_write(&cxl_region_rwsem);
+		device_release_driver(&cxlr->dev);
+		down_write(&cxl_region_rwsem);
+
+		/*
+		 * The lock was dropped, so need to revalidate that the reset is
+		 * still pending.
+		 */
+		if (p->state == CXL_CONFIG_RESET_PENDING)
+			rc = cxl_region_decode_reset(cxlr, p->interleave_ways);
+	}
+
+	if (rc)
+		goto out;
+
+	if (commit)
+		p->state = CXL_CONFIG_COMMIT;
+	else if (p->state == CXL_CONFIG_RESET_PENDING)
+		p->state = CXL_CONFIG_ACTIVE;
+
+out:
+	up_write(&cxl_region_rwsem);
+
+	if (rc)
+		return rc;
+	return len;
+}
+
+static ssize_t commit_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", p->state >= CXL_CONFIG_COMMIT);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(commit);
+
 static umode_t cxl_region_visible(struct kobject *kobj, struct attribute *a,
 				  int n)
 {
@@ -393,6 +560,7 @@ static DEVICE_ATTR_RW(size);
 
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
+	&dev_attr_commit.attr,
 	&dev_attr_interleave_ways.attr,
 	&dev_attr_interleave_granularity.attr,
 	&dev_attr_resource.attr,
@@ -669,12 +837,6 @@ static int cxl_port_attach_region(struct cxl_port *port,
 	return rc;
 }
 
-static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
-					  struct cxl_region *cxlr)
-{
-	return xa_load(&port->regions, (unsigned long)cxlr);
-}
-
 static void cxl_port_detach_region(struct cxl_port *port,
 				   struct cxl_region *cxlr,
 				   struct cxl_endpoint_decoder *cxled)
@@ -1062,20 +1224,32 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 	return rc;
 }
 
-static void cxl_region_detach(struct cxl_endpoint_decoder *cxled)
+static int cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 {
 	struct cxl_port *iter, *ep_port = cxled_to_port(cxled);
 	struct cxl_region *cxlr = cxled->cxld.region;
 	struct cxl_region_params *p;
+	int rc = 0;
 
 	lockdep_assert_held_write(&cxl_region_rwsem);
 
 	if (!cxlr)
-		return;
+		return 0;
 
 	p = &cxlr->params;
 	get_device(&cxlr->dev);
 
+	if (p->state > CXL_CONFIG_ACTIVE) {
+		/*
+		 * TODO: tear down all impacted regions if a device is
+		 * removed out of order
+		 */
+		rc = cxl_region_decode_reset(cxlr, p->interleave_ways);
+		if (rc)
+			goto out;
+		p->state = CXL_CONFIG_ACTIVE;
+	}
+
 	for (iter = ep_port; !is_cxl_root(iter);
 	     iter = to_cxl_port(iter->dev.parent))
 		cxl_port_detach_region(iter, cxlr, cxled);
@@ -1103,6 +1277,7 @@ static void cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 	down_write(&cxl_region_rwsem);
 out:
 	put_device(&cxlr->dev);
+	return rc;
 }
 
 void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled)
@@ -1160,8 +1335,7 @@ static int detach_target(struct cxl_region *cxlr, int pos)
 		goto out;
 	}
 
-	cxl_region_detach(p->targets[pos]);
-	rc = 0;
+	rc = cxl_region_detach(p->targets[pos]);
 out:
 	up_write(&cxl_region_rwsem);
 	return rc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 70862141209b..a51709613c43 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -54,6 +54,7 @@
 #define   CXL_HDM_DECODER0_CTRL_LOCK BIT(8)
 #define   CXL_HDM_DECODER0_CTRL_COMMIT BIT(9)
 #define   CXL_HDM_DECODER0_CTRL_COMMITTED BIT(10)
+#define   CXL_HDM_DECODER0_CTRL_COMMIT_ERROR BIT(11)
 #define   CXL_HDM_DECODER0_CTRL_TYPE BIT(12)
 #define CXL_HDM_DECODER0_TL_LOW(i) (0x20 * (i) + 0x24)
 #define CXL_HDM_DECODER0_TL_HIGH(i) (0x20 * (i) + 0x28)
@@ -257,7 +258,9 @@ enum cxl_decoder_type {
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @region: currently assigned region for this decoder
  * @flags: memory type capabilities and locking
- */
+ * @commit: device/decoder-type specific callback to commit settings to hw
+ * @reset: device/decoder-type specific callback to reset hw settings
+*/
 struct cxl_decoder {
 	struct device dev;
 	int id;
@@ -267,6 +270,8 @@ struct cxl_decoder {
 	enum cxl_decoder_type target_type;
 	struct cxl_region *region;
 	unsigned long flags;
+	int (*commit)(struct cxl_decoder *cxld);
+	int (*reset)(struct cxl_decoder *cxld);
 };
 
 /*
@@ -339,11 +344,15 @@ struct cxl_root_decoder {
  * changes to interleave_ways or interleave_granularity
  * @CXL_CONFIG_ACTIVE: All targets have been added the region is now
  * active
+ * @CXL_CONFIG_RESET_PENDING: see commit_store()
+ * @CXL_CONFIG_COMMIT: Soft-config has been committed to hardware
  */
 enum cxl_config_state {
 	CXL_CONFIG_IDLE,
 	CXL_CONFIG_INTERLEAVE_ACTIVE,
 	CXL_CONFIG_ACTIVE,
+	CXL_CONFIG_RESET_PENDING,
+	CXL_CONFIG_COMMIT,
 };
 
 /**
@@ -425,6 +434,7 @@ struct cxl_nvdimm {
  * @parent_dport: dport that points to this port in the parent
  * @decoder_ida: allocator for decoder ids
  * @hdm_end: track last allocated HDM decoder instance for allocation ordering
+ * @commit_end: cursor to track highest committed decoder for commit ordering
  * @component_reg_phys: component register capability base address (optional)
  * @dead: last ep has been removed, force port re-creation
  * @depth: How deep this port is relative to the root. depth 0 is the root.
@@ -440,6 +450,7 @@ struct cxl_port {
 	struct cxl_dport *parent_dport;
 	struct ida decoder_ida;
 	int hdm_end;
+	int commit_end;
 	resource_size_t component_reg_phys;
 	bool dead;
 	unsigned int depth;
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 4dad0fa7ac4c..a072b2d3e726 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -429,6 +429,50 @@ static int map_targets(struct device *dev, void *data)
 	return 0;
 }
 
+static int mock_decoder_commit(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	int id = cxld->id;
+
+	if (cxld->flags & CXL_DECODER_F_ENABLE)
+		return 0;
+
+	dev_dbg(&port->dev, "%s commit\n", dev_name(&cxld->dev));
+	if (port->commit_end + 1 != id) {
+		dev_dbg(&port->dev,
+			"%s: out of order commit, expected decoder%d.%d\n",
+			dev_name(&cxld->dev), port->id, port->commit_end + 1);
+		return -EBUSY;
+	}
+
+	port->commit_end++;
+	cxld->flags |= CXL_DECODER_F_ENABLE;
+
+	return 0;
+}
+
+static int mock_decoder_reset(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	int id = cxld->id;
+
+	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
+		return 0;
+
+	dev_dbg(&port->dev, "%s reset\n", dev_name(&cxld->dev));
+	if (port->commit_end != id) {
+		dev_dbg(&port->dev,
+			"%s: out of order reset, expected decoder%d.%d\n",
+			dev_name(&cxld->dev), port->id, port->commit_end);
+		return -EBUSY;
+	}
+
+	port->commit_end--;
+	cxld->flags &= ~CXL_DECODER_F_ENABLE;
+
+	return 0;
+}
+
 static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 {
 	struct cxl_port *port = cxlhdm->port;
@@ -482,6 +526,8 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 		cxld->interleave_ways = min_not_zero(target_count, 1);
 		cxld->interleave_granularity = SZ_4K;
 		cxld->target_type = CXL_DECODER_EXPANDER;
+		cxld->commit = mock_decoder_commit;
+		cxld->reset = mock_decoder_reset;
 
 		if (target_count) {
 			rc = device_for_each_child(port->uport, &ctx,


