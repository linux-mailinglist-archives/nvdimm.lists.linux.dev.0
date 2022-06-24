Return-Path: <nvdimm+bounces-4003-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C584A558FB1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 06:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73481280D08
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Jun 2022 04:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C3B258F;
	Fri, 24 Jun 2022 04:20:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A223D5;
	Fri, 24 Jun 2022 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044419; x=1687580419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=inIN8uups6gFh4YJjaeGxbzSP26ZRDBYb3GSvNZIKQY=;
  b=O9LTZnY2RLjj8RGYupc9wXdacuAycjlp2zzZsHMzyvdA4tEhyQcOfmxR
   jNXu/Xf1MMtSWaPkArluVmaJUkFGO0wdJ5nohV2tp3cRzyzSHnWiuomSV
   EDloOVP/vnpMuWGvUo0C/9bLEghH4by7n0bvhsnsEBgPXPm53MmWJd2y/
   alMYhscoZxgA19jTqZGBTY39pDxz32PPLLbCJgkXgjOUZjGzVgN+Z4Vfs
   EEz6ark+1M48LzzIMHk/7fdd1bD9aE3Z4SLFkF+vDkrs4iKYg8bX4I9z7
   RfDiNI13ylO7ZzFKwOptT+XlT5fgcUK3FEVdsv6bXleRPGAU4t8lWREmC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912807"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912807"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092950"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Subject: [PATCH 40/46] cxl/region: Attach endpoint decoders
Date: Thu, 23 Jun 2022 21:19:44 -0700
Message-Id: <20220624041950.559155-15-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL regions (interleave sets) are made up of a set of memory devices
where each device maps a portion of the interleave with one of its
decoders (see CXL 2.0 8.2.5.12 CXL HDM Decoder Capability Structure).
As endpoint decoders are identified by a provisioning tool they can be
added to a region provided the region interleave properties are set
(way, granularity, HPA) and DPA has been assigned to the decoder.

The attach event triggers several validation checks, for example:
- is the DPA sized appropriately for the region
- is the decoder reachable via the host-bridges identified by the
  region's root decoder
- is the device already active in a different region position slot
- are there already regions with a higher HPA active on a given port
  (per CXL 2.0 8.2.5.12.20 Committing Decoder Programming)

...and the attach event affords an opportunity to collect data and
resources relevant to later programming the target lists in switch
decoders, for example:
- allocate a decoder at each cxl_port in the decode chain
- for a given switch port, how many the region's endpoints are hosted
  through the port
- how many unique targets (next hops) does a port need to map to reach
  those endpoints

The act of reconciling this information and deploying it to the decoder
configuration is saved for a follow-on patch.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/core.h   |   7 +
 drivers/cxl/core/port.c   |  10 +-
 drivers/cxl/core/region.c | 338 +++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h         |  20 +++
 drivers/cxl/cxlmem.h      |   5 +
 5 files changed, 372 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 36b6bd8dac2b..0e4e5c2d9452 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -42,6 +42,13 @@ resource_size_t cxl_dpa_size(struct cxl_endpoint_decoder *cxled);
 resource_size_t cxl_dpa_resource(struct cxl_endpoint_decoder *cxled);
 extern struct rw_semaphore cxl_dpa_rwsem;
 
+bool is_switch_decoder(struct device *dev);
+static inline struct cxl_ep *cxl_ep_load(struct cxl_port *port,
+					 struct cxl_memdev *cxlmd)
+{
+	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
+}
+
 int cxl_memdev_init(void);
 void cxl_memdev_exit(void);
 void cxl_mbox_init(void);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 7756409d0a58..fde2a2e103d4 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -447,7 +447,7 @@ bool is_root_decoder(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_root_decoder, CXL);
 
-static bool is_switch_decoder(struct device *dev)
+bool is_switch_decoder(struct device *dev)
 {
 	return is_root_decoder(dev) || dev->type == &cxl_decoder_switch_type;
 }
@@ -503,6 +503,7 @@ static void cxl_port_release(struct device *dev)
 		cxl_ep_remove(port, ep);
 	xa_destroy(&port->endpoints);
 	xa_destroy(&port->dports);
+	xa_destroy(&port->regions);
 	ida_free(&cxl_port_ida, port->id);
 	kfree(port);
 }
@@ -633,6 +634,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	port->dpa_end = -1;
 	xa_init(&port->dports);
 	xa_init(&port->endpoints);
+	xa_init(&port->regions);
 
 	device_initialize(dev);
 	lockdep_set_class_and_subclass(&dev->mutex, &cxl_port_key, port->depth);
@@ -1110,12 +1112,6 @@ static void reap_dports(struct cxl_port *port)
 	}
 }
 
-static struct cxl_ep *cxl_ep_load(struct cxl_port *port,
-				  struct cxl_memdev *cxlmd)
-{
-	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
-}
-
 int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
 			  struct cxl_dport *parent_dport)
 {
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 4830365f3857..65bf84abad57 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -428,6 +428,254 @@ static size_t show_targetN(struct cxl_region *cxlr, char *buf, int pos)
 	return rc;
 }
 
+static int match_free_decoder(struct device *dev, void *data)
+{
+	struct cxl_decoder *cxld;
+	int *id = data;
+
+	if (!is_switch_decoder(dev))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+
+	/* enforce ordered allocation */
+	if (cxld->id != *id)
+		return 0;
+
+	if (!cxld->region)
+		return 1;
+
+	(*id)++;
+
+	return 0;
+}
+
+static struct cxl_decoder *cxl_region_find_decoder(struct cxl_port *port,
+						   struct cxl_region *cxlr)
+{
+	struct device *dev;
+	int id = 0;
+
+	dev = device_find_child(&port->dev, &id, match_free_decoder);
+	if (!dev)
+		return NULL;
+	/*
+	 * This decoder is pinned registered as long as the endpoint decoder is
+	 * registered, and endpoint decoder unregistration holds the
+	 * cxl_region_rwsem over unregister events, so no need to hold on to
+	 * this extra reference.
+	 */
+	put_device(dev);
+	return to_cxl_decoder(dev);
+}
+
+static struct cxl_region_ref *alloc_region_ref(struct cxl_port *port,
+					       struct cxl_region *cxlr)
+{
+	struct cxl_region_ref *cxl_rr;
+
+	cxl_rr = kzalloc(sizeof(*cxl_rr), GFP_KERNEL);
+	if (!cxl_rr)
+		return NULL;
+	cxl_rr->port = port;
+	cxl_rr->region = cxlr;
+	xa_init(&cxl_rr->endpoints);
+	return cxl_rr;
+}
+
+static void free_region_ref(struct cxl_region_ref *cxl_rr)
+{
+	struct cxl_port *port = cxl_rr->port;
+	struct cxl_region *cxlr = cxl_rr->region;
+	struct cxl_decoder *cxld = cxl_rr->decoder;
+
+	dev_WARN_ONCE(&cxlr->dev, cxld->region != cxlr, "region mismatch\n");
+	if (cxld->region == cxlr) {
+		cxld->region = NULL;
+		put_device(&cxlr->dev);
+	}
+
+	xa_erase(&port->regions, (unsigned long)cxlr);
+	xa_destroy(&cxl_rr->endpoints);
+	kfree(cxl_rr);
+}
+
+static int cxl_rr_add(struct cxl_region_ref *cxl_rr)
+{
+	struct cxl_port *port = cxl_rr->port;
+	struct cxl_region *cxlr = cxl_rr->region;
+
+	return xa_insert(&port->regions, (unsigned long)cxlr, cxl_rr,
+			 GFP_KERNEL);
+}
+
+static int cxl_rr_ep_add(struct cxl_region_ref *cxl_rr,
+			 struct cxl_endpoint_decoder *cxled)
+{
+	int rc;
+	struct cxl_port *port = cxl_rr->port;
+	struct cxl_region *cxlr = cxl_rr->region;
+	struct cxl_decoder *cxld = cxl_rr->decoder;
+	struct cxl_ep *ep = cxl_ep_load(port, cxled_to_memdev(cxled));
+
+	rc = xa_insert(&cxl_rr->endpoints, (unsigned long)cxled, ep,
+			 GFP_KERNEL);
+	if (rc)
+		return rc;
+	cxl_rr->nr_eps++;
+
+	if (!cxld->region) {
+		cxld->region = cxlr;
+		get_device(&cxlr->dev);
+	}
+
+	return 0;
+}
+
+static int cxl_port_attach_region(struct cxl_port *port,
+				  struct cxl_region *cxlr,
+				  struct cxl_endpoint_decoder *cxled, int pos)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_ep *ep = cxl_ep_load(port, cxlmd);
+	struct cxl_region_ref *cxl_rr = NULL, *iter;
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_decoder *cxld = NULL;
+	unsigned long index;
+	int rc = -EBUSY;
+
+	lockdep_assert_held_write(&cxl_region_rwsem);
+
+	xa_for_each(&port->regions, index, iter) {
+		struct cxl_region_params *ip = &iter->region->params;
+
+		if (iter->region == cxlr)
+			cxl_rr = iter;
+		if (ip->res->start > p->res->start) {
+			dev_dbg(&cxlr->dev,
+				"%s: HPA order violation %s:%pr vs %pr\n",
+				dev_name(&port->dev),
+				dev_name(&iter->region->dev), ip->res, p->res);
+			return -EBUSY;
+		}
+	}
+
+	if (cxl_rr) {
+		struct cxl_ep *ep_iter;
+		int found = 0;
+
+		cxld = cxl_rr->decoder;
+		xa_for_each(&cxl_rr->endpoints, index, ep_iter) {
+			if (ep_iter == ep)
+				continue;
+			if (ep_iter->next == ep->next) {
+				found++;
+				break;
+			}
+		}
+
+		/*
+		 * If this is a new target or if this port is direct connected
+		 * to this endpoint then add to the target count.
+		 */
+		if (!found || !ep->next)
+			cxl_rr->nr_targets++;
+	} else {
+		cxl_rr = alloc_region_ref(port, cxlr);
+		if (!cxl_rr) {
+			dev_dbg(&cxlr->dev,
+				"%s: failed to allocate region reference\n",
+				dev_name(&port->dev));
+			return -ENOMEM;
+		}
+		rc = cxl_rr_add(cxl_rr);
+		if (rc) {
+			dev_dbg(&cxlr->dev,
+				"%s: failed to track region reference\n",
+				dev_name(&port->dev));
+			kfree(cxl_rr);
+			return rc;
+		}
+	}
+
+	if (!cxld) {
+		if (port == cxled_to_port(cxled))
+			cxld = &cxled->cxld;
+		else
+			cxld = cxl_region_find_decoder(port, cxlr);
+		if (!cxld) {
+			dev_dbg(&cxlr->dev, "%s: no decoder available\n",
+				dev_name(&port->dev));
+			goto out_erase;
+		}
+
+		if (cxld->region) {
+			dev_dbg(&cxlr->dev, "%s: %s already attached to %s\n",
+				dev_name(&port->dev), dev_name(&cxld->dev),
+				dev_name(&cxld->region->dev));
+			rc = -EBUSY;
+			goto out_erase;
+		}
+
+		cxl_rr->decoder = cxld;
+	}
+
+	rc = cxl_rr_ep_add(cxl_rr, cxled);
+	if (rc) {
+		dev_dbg(&cxlr->dev,
+			"%s: failed to track endpoint %s:%s reference\n",
+			dev_name(&port->dev), dev_name(&cxlmd->dev),
+			dev_name(&cxld->dev));
+		goto out_erase;
+	}
+
+	return 0;
+out_erase:
+	if (cxl_rr->nr_eps == 0)
+		free_region_ref(cxl_rr);
+	return rc;
+}
+
+static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
+					  struct cxl_region *cxlr)
+{
+	return xa_load(&port->regions, (unsigned long)cxlr);
+}
+
+static void cxl_port_detach_region(struct cxl_port *port,
+				   struct cxl_region *cxlr,
+				   struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_region_ref *cxl_rr;
+	struct cxl_ep *ep;
+
+	lockdep_assert_held_write(&cxl_region_rwsem);
+
+	cxl_rr = cxl_rr_load(port, cxlr);
+	if (!cxl_rr)
+		return;
+
+	ep = xa_erase(&cxl_rr->endpoints, (unsigned long)cxled);
+	if (ep) {
+		struct cxl_ep *ep_iter;
+		unsigned long index;
+		int found = 0;
+
+		cxl_rr->nr_eps--;
+		xa_for_each(&cxl_rr->endpoints, index, ep_iter) {
+			if (ep_iter->next == ep->next) {
+				found++;
+				break;
+			}
+		}
+		if (!found)
+			cxl_rr->nr_targets--;
+	}
+
+	if (cxl_rr->nr_eps == 0)
+		free_region_ref(cxl_rr);
+}
+
 /*
  * - Check that the given endpoint is attached to a host-bridge identified
  *   in the root interleave.
@@ -435,14 +683,28 @@ static size_t show_targetN(struct cxl_region *cxlr, char *buf, int pos)
 static int cxl_region_attach(struct cxl_region *cxlr,
 			     struct cxl_endpoint_decoder *cxled, int pos)
 {
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *ep_port, *root_port, *iter;
 	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_dport *dport;
+	int i, rc = -ENXIO;
 
 	if (cxled->mode == CXL_DECODER_DEAD) {
 		dev_dbg(&cxlr->dev, "%s dead\n", dev_name(&cxled->cxld.dev));
 		return -ENODEV;
 	}
 
-	if (pos >= p->interleave_ways) {
+	/* all full of members, or interleave config not established? */
+	if (p->state > CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		dev_dbg(&cxlr->dev, "region already active\n");
+		return -EBUSY;
+	} else if (p->state < CXL_CONFIG_INTERLEAVE_ACTIVE) {
+		dev_dbg(&cxlr->dev, "interleave config missing\n");
+		return -ENXIO;
+	}
+
+	if (pos < 0 || pos >= p->interleave_ways) {
 		dev_dbg(&cxlr->dev, "position %d out of range %d\n", pos,
 			p->interleave_ways);
 		return -ENXIO;
@@ -461,15 +723,83 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		return -EBUSY;
 	}
 
+	for (i = 0; i < p->interleave_ways; i++) {
+		struct cxl_endpoint_decoder *cxled_target;
+		struct cxl_memdev *cxlmd_target;
+
+		cxled_target = p->targets[pos];
+		if (!cxled_target)
+			continue;
+
+		cxlmd_target = cxled_to_memdev(cxled_target);
+		if (cxlmd_target == cxlmd) {
+			dev_dbg(&cxlr->dev,
+				"%s already specified at position %d via: %s\n",
+				dev_name(&cxlmd->dev), pos,
+				dev_name(&cxled_target->cxld.dev));
+			return -EBUSY;
+		}
+	}
+
+	ep_port = cxled_to_port(cxled);
+	root_port = cxlrd_to_port(cxlrd);
+	dport = cxl_dport_load(root_port, ep_port->host_bridge);
+	if (!dport) {
+		dev_dbg(&cxlr->dev, "%s:%s invalid target for %s\n",
+			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
+			dev_name(cxlr->dev.parent));
+		return -ENXIO;
+	}
+
+	if (cxlrd->calc_hb(cxlrd, pos) != dport) {
+		dev_dbg(&cxlr->dev, "%s:%s invalid target position for %s\n",
+			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
+			dev_name(&cxlrd->cxlsd.cxld.dev));
+		return -ENXIO;
+	}
+
+	if (cxled->cxld.target_type != cxlr->type) {
+		dev_dbg(&cxlr->dev, "%s:%s type mismatch: %d vs %d\n",
+			dev_name(&cxlmd->dev), dev_name(&cxled->cxld.dev),
+			cxled->cxld.target_type, cxlr->type);
+		return -ENXIO;
+	}
+
+	if (resource_size(cxled->dpa_res) * p->interleave_ways !=
+	    resource_size(p->res)) {
+		dev_dbg(&cxlr->dev,
+			"decoder-size-%#llx * ways-%d != region-size-%#llx\n",
+			(u64)resource_size(cxled->dpa_res), p->interleave_ways,
+			(u64)resource_size(p->res));
+		return -EINVAL;
+	}
+
+	for (iter = ep_port; !is_cxl_root(iter);
+	     iter = to_cxl_port(iter->dev.parent)) {
+		rc = cxl_port_attach_region(iter, cxlr, cxled, pos);
+		if (rc)
+			goto err;
+	}
+
 	p->targets[pos] = cxled;
 	cxled->pos = pos;
 	p->nr_targets++;
 
+	if (p->nr_targets == p->interleave_ways)
+		p->state = CXL_CONFIG_ACTIVE;
+
 	return 0;
+
+err:
+	for (iter = ep_port; !is_cxl_root(iter);
+	     iter = to_cxl_port(iter->dev.parent))
+		cxl_port_detach_region(iter, cxlr, cxled);
+	return rc;
 }
 
 static void cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 {
+	struct cxl_port *iter, *ep_port = cxled_to_port(cxled);
 	struct cxl_region *cxlr = cxled->cxld.region;
 	struct cxl_region_params *p;
 
@@ -481,6 +811,10 @@ static void cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 	p = &cxlr->params;
 	get_device(&cxlr->dev);
 
+	for (iter = ep_port; !is_cxl_root(iter);
+	     iter = to_cxl_port(iter->dev.parent))
+		cxl_port_detach_region(iter, cxlr, cxled);
+
 	if (cxled->pos < 0 || cxled->pos >= p->interleave_ways ||
 	    p->targets[cxled->pos] != cxled) {
 		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
@@ -491,6 +825,8 @@ static void cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 		goto out;
 	}
 
+	if (p->state == CXL_CONFIG_ACTIVE)
+		p->state = CXL_CONFIG_INTERLEAVE_ACTIVE;
 	p->targets[cxled->pos] = NULL;
 	p->nr_targets--;
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 30227348f768..09dbd46cc4c7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -414,6 +414,7 @@ struct cxl_nvdimm {
  * @id: id for port device-name
  * @dports: cxl_dport instances referenced by decoders
  * @endpoints: cxl_ep instances, endpoints that are a descendant of this port
+ * @regions: cxl_region_ref instances, regions mapped by this port
  * @parent_dport: dport that points to this port in the parent
  * @decoder_ida: allocator for decoder ids
  * @dpa_end: cursor to track highest allocated decoder for allocation ordering
@@ -428,6 +429,7 @@ struct cxl_port {
 	int id;
 	struct xarray dports;
 	struct xarray endpoints;
+	struct xarray regions;
 	struct cxl_dport *parent_dport;
 	struct ida decoder_ida;
 	int dpa_end;
@@ -470,6 +472,24 @@ struct cxl_ep {
 	struct cxl_port *next;
 };
 
+/**
+ * struct cxl_region_ref - track a region's interest in a port
+ * @port: point in topology to install this reference
+ * @decoder: decoder assigned for @region in @port
+ * @region: region for this reference
+ * @endpoints: cxl_ep references for region members beneath @port
+ * @nr_eps: number of endpoints beneath @port
+ * @nr_targets: number of distinct targets needed to reach @nr_eps
+ */
+struct cxl_region_ref {
+	struct cxl_port *port;
+	struct cxl_decoder *decoder;
+	struct cxl_region *region;
+	struct xarray endpoints;
+	int nr_eps;
+	int nr_targets;
+};
+
 /*
  * The platform firmware device hosting the root is also the top of the
  * CXL port topology. All other CXL ports have another CXL port as their
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index eee96016c3c7..a83bb6782d23 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -55,6 +55,11 @@ static inline struct cxl_port *cxled_to_port(struct cxl_endpoint_decoder *cxled)
 	return to_cxl_port(cxled->cxld.dev.parent);
 }
 
+static inline struct cxl_port *cxlrd_to_port(struct cxl_root_decoder *cxlrd)
+{
+	return to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+}
+
 static inline struct cxl_memdev *
 cxled_to_memdev(struct cxl_endpoint_decoder *cxled)
 {
-- 
2.36.1


