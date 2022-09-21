Return-Path: <nvdimm+bounces-4833-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A645E54DF
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 23:02:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB7BD280C9C
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Sep 2022 21:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1E68462;
	Wed, 21 Sep 2022 21:02:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4F57C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663794168; x=1695330168;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZhWQONEsjwWmD5xXRq7QVScsHxlSfo61SS3x1MMKs5c=;
  b=fuQOYjlJgMI2J0a9+BmYfPfOb4CqYtT+MbGEljOtLZM2T3n0yC7oJ8tH
   maJWK3iJIIcgzpBp1EU1ZspXv1pnn9MyCdwTeOfKKPyfKi3uBhFRqEdeB
   oisuNwOF9KLE9NxuMKv7nv8ufQFL6XkLhf0PAgc8SwfClyEFVuLTpLPX/
   XLQQIftOG9a5fr0i+uJ4SnH1i+Z4vq8RJEmGGPduJsXZy0zOmggpRTnCV
   C2U2uoIMAgGnyOB+Vd7LAWTZGy9idqSQ5g+PoW3w49bhdyc4gBtBNrcuo
   140QXLPTIofhsxz/MAqP6Qksd1JJnGYEqQRa33IL6cFIIn7MzOPojD+FD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="279848626"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="279848626"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:02:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="681934786"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:02:48 -0700
Subject: [PATCH 2/4] ndctl/libndctl: Add bus_prefix for cxl
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 21 Sep 2022 14:02:47 -0700
Message-ID: 
 <166379416797.433612.11380777795382753298.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

With support of being able to detect the cxl bus, setup the bus_prefix
for cxl bus.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/libndctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 10422e24d38b..d2e800bc840a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2012,6 +2012,12 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 			goto out;
 		}
 		rc =  add_papr_dimm(dimm, dimm_base);
+	} else if (ndctl_bus_has_cxl(bus)) {
+		dimm->bus_prefix = strdup("cxl");
+		if (!dimm->bus_prefix) {
+			rc = -ENOMEM;
+			goto out;
+		}
 	}
 
 	if (rc == -ENODEV) {



