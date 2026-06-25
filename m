Return-Path: <nvdimm+bounces-14552-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mpp2CMERPWpkwggAu9opvQ
	(envelope-from <nvdimm+bounces-14552-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 13:32:17 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6750F6C51F5
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 13:32:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cY0EK7Ps;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14552-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14552-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05A22313B584
	for <lists+linux-nvdimm@lfdr.de>; Thu, 25 Jun 2026 11:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54C23DA5CD;
	Thu, 25 Jun 2026 11:28:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307233D813D
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386903; cv=none; b=S/UGCjwUGhqVOayXE8pXtkMutLtEJrzr26LgG8cJLSapJ1BNPicLxL9CvnzoDcdGaXIcenpf0PKXrBfLFuyRHQm9zW+jVndPKqZHA3UR0aeAo7nAONLMJQpNi4OPGw6dCcTLgHhf3XuezoZ32g8hMi9E7a3uhnBLAf0K4lj2fg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386903; c=relaxed/simple;
	bh=MH96XZs7MF5UV1+fZ2jQQiPTR+7dlAPgtIOhHTm8MGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVVo/nms81ofq6qo6TirHA5bRK2GB9/XdLkQbO87pmcoSK4k0qTWL64/CXrt4iAVOgkrKkF8Sj8w2FWL2cmF9rCglv78x5B4TyL8avdH8aj6Mng223XueoRpbKHv6t9sR2vzXX9BMfZ+5eibfvcbxSs3Y0pKKF31RVza//S31FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cY0EK7Ps; arc=none smtp.client-ip=74.125.82.173
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-304f590dd91so2539166eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386901; x=1782991701; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWGYp5PimR7iNvegHe/tRkVtZEJJWTBhNsd/pXJaxDQ=;
        b=cY0EK7PsghAhm4GgbAOYLANIN0Phzy62n+M2zPcVHWdPI25PsDasEfgUnQhBZSsSUc
         WSYBaRcQH5bJ8LCEETpDjyn+vjij7qZ0E28zxm8oRyAwyCCxFKZgpoJcxFdugWlJRkGr
         kgdH9hfjtvtYvl+8mvKiO+g+0riiH3cRbOFSTlS3AkOAXGTRK6lshAm8K3P7mCcH77p5
         RCQUy5+jDMVP+ZlZfPAAeFbLFwZ2vzK5cGtJqfTOz1WP5Vepxh/lIq5jVDgWeI7DxrlY
         Ng0BoVxCCJUJEtbnxfhmNgkmtWfj0W3bL7CprV3UjUyElpdmolMdUkxrl4paX6DQ1QpU
         EiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386901; x=1782991701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zWGYp5PimR7iNvegHe/tRkVtZEJJWTBhNsd/pXJaxDQ=;
        b=clagQ+zbRvS/YQt34UOBR+BxRJ4jAvJnWgSBc4utuKlNsbZdwttPY8WAzw1Bupk8O1
         TwX0g7ueOXh0jJjl2MO7R+hxPDie2sYBjrP0/0LNVDT8gXsSU8x2PCGobNnlqcf5MJXN
         lRiIh9y5Cd4zRMnPRvqajuNA1Op6TgD9kibaNGeM7hel0sb8JIxEdKlfGfZ9kkypBnOC
         7Zkv1xlberSrHdz9sPee4ZcfIECWAgqLqbWmMnUmzFi4puizrvx7ryCk+jf5w9A/lG0k
         h5cHAVSf2pn3DswKUbxUgIXb2MdEe9ZUNQ/rB/ro/3VNXvWEM5HvKlq47roPQEfpfNJc
         YuOg==
X-Gm-Message-State: AOJu0Yzct/RZS89YaU2u709NOoBmUbAoIEZGIBp9fLKHqpwqd+gDYbuo
	p6EXn5OHBaTqzJB/j4XBxSTfhTYLAPjrQ+TMrnmINLjsGlZzBxWR3s7r
X-Gm-Gg: AfdE7cl6ivCyVZp0l2g58gC3O7Jgtq3WfCjmVvz0bq0wB+CyCRsEsB1eTCSWbpYtSEL
	6a27ibGc+wU0m0ZSvYah4N3lw5BXaOyW0NCrYuGmZezPEQOlFaeZ7M+uXRZF0ZLUvZgH5NzH3fx
	PTeSYFxYcfNw409EE9XgoMlom2lr0b/fehFP/r3DXXEllJEM5sV4wIS61u9bkHvEgaXnp2v72xW
	T9EFyondaeA82TN+yJHh83bve10CVwsQrI1U1qFy0bvBcvCoijp9a3vYhq+irlUFA0fwXijrZlE
	8XYcS/hZ9VD3Be+R/TmTCoeM8T7vyPWT1aasKb6lDiL4cph5DRfHlr3alkHvHt2RQ2GkBKkGgX3
	iFdIMEr1yLuhzRF01hbvFGlw0xFoj1+SQusuFUZDjtCNE1dXlOcFEjkLbYLJNAJTXSpeg+ff7c5
	SyuII8j9+bXkP+GipmiNcN2+qkSxh79NlNu1BfdcnTC/a4yQW/x5NZKgN/YOANA0sy+Rq9
X-Received: by 2002:a05:7300:7246:b0:30c:5a5:df4f with SMTP id 5a478bee46e88-30c84eb9cf8mr2905159eec.16.1782386901207;
        Thu, 25 Jun 2026 04:28:21 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:20 -0700 (PDT)
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
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v11 08/31] cxl/events: Split event msgnum configuration from irq setup
Date: Thu, 25 Jun 2026 04:04:45 -0700
Message-ID: <20260625112638.550691-9-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-14552-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:djbw@kernel.org,m:jic23@kernel.org,m:dave@stgolabs.net,m:dave.jiang@intel.com,m:vishal.l.verma@intel.com,m:iweiny@kernel.org,m:alison.schofield@intel.com,m:John@Groves.net,m:gourry@gourry.net,m:anisa.su@samsung.com,m:nifan.cxl@gmail.com,m:ming.li@zohomail.com,m:nifancxl@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[anisasu887@gmail.com,nvdimm@lists.linux.dev];
	FREEMAIL_CC(0.00)[lists.linux.dev,kernel.org,stgolabs.net,intel.com,Groves.net,gourry.net,samsung.com,gmail.com,zohomail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisasu887@gmail.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:mid,samsung.com:email,lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email,zohomail.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6750F6C51F5

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 60f9fa05d9ef..35942b2ace53 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -599,35 +599,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -674,11 +670,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 
-- 
2.43.0


