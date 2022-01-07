Return-Path: <nvdimm+bounces-2399-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD74487D13
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jan 2022 20:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 535F61C0B3F
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jan 2022 19:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2989A2CA3;
	Fri,  7 Jan 2022 19:31:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62774173
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 19:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641583867; x=1673119867;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9vKLJitBL4avQk4JOw0KZYR1d4V7xO5yUoVWk6OCNlY=;
  b=Xx7L3d2QLD9Fex7AjrN58uU5YAnMZuxqK/BduHq0WAWr6Q2FzT71IUIA
   Z09gFDiJyAg2wWmlf+Ttzw0ieLlIZvll2KuxvwJLwxed46zyBm/ooHKq1
   m+FuGwPLi+ktvoCOMZGAWfegOa+CXJJemtHC3LY/LQvV6OreEEd9qphd8
   O+uJLs6DvtI8X8J5fWNYGimNru6ft8hLyJRKxPQpAY6mS92VbZkbuX8M8
   QPI4dol2JfhLgCttqzVtUv+UcXVBRMnCZroBxojD47yNh+vyC7NoKKV03
   qK2PUY2dVYbIvEUqMMbUgMXLBjybFTqsxfvtXcurdzAICbaYvyF97dK48
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="230269176"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="230269176"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:31:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="612275947"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:31:06 -0800
Subject: [ndctl PATCH] ndctl/build: Default asciidoctor to enabled
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev
Date: Fri, 07 Jan 2022 11:31:06 -0800
Message-ID: <164158386600.302694.5479584050156277551.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The autotools build infra previously defaulted asciidoctor to enabled, do
the same for Meson.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 meson_options.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson_options.txt b/meson_options.txt
index 95312bfcb0d3..aa4a6dc8e12a 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -1,7 +1,7 @@
 option('version-tag', type : 'string',
        description : 'override the git version string')
 option('docs', type : 'feature', value : 'enabled')
-option('asciidoctor', type : 'feature', value : 'disabled')
+option('asciidoctor', type : 'feature', value : 'enabled')
 option('systemd', type : 'feature', value : 'enabled')
 option('keyutils', type : 'feature', value : 'enabled',
   description : 'enable nvdimm device passphrase management')


