Return-Path: <nvdimm+bounces-4522-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C664590999
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Aug 2022 02:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 203821C209B1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Aug 2022 00:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4211C371;
	Fri, 12 Aug 2022 00:37:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A015136C
	for <nvdimm@lists.linux.dev>; Fri, 12 Aug 2022 00:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660264629; x=1691800629;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oXhRt65NYjW6187xXabFftOwWWNqETwxMwCLSqwSUus=;
  b=M68SKU7Nv0KMyNcm9nPpCZPKkxxW0yJGaClNxTTqv2Cep+1QwruV3NBy
   ZeKte5ezScxNEW/zD/TkRjzE1sGvlD8omYa3gdpgTkiu4u5nhaZM8Itk7
   GZzt+YJkfH3DPzldSAcVWzvEGrt5FtSOTyrARb/vKH7klaQ5MtoVhUV6o
   G9xJ/rWOxqPP8Sydfot2b4f9boSgpySKOhyyXQ7hWPMfKOP9OjtaHrWk5
   quyqtk8OE7V4it6S2OgdzGz/GWlVMUaKuUX0JfZJnlGvSRF5MdlRCZl/Q
   5U7/HEe29fcWhiVmxWrKfwGWs00DC0D7Ph6Cfjbq3WrOyCZQmZ2RzGOtP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="274547584"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="274547584"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 17:37:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="556341057"
Received: from ljreyesl-mobl.amr.corp.intel.com (HELO mbernalm-mobl.luna.miguelinux.com) ([10.252.249.161])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 17:37:08 -0700
From: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Subject: [ndctl PATCH] meson: fix modprobedatadir default value
Date: Thu, 11 Aug 2022 19:36:53 -0500
Message-Id: <20220812003653.53992-1-miguel.bernal.marin@linux.intel.com>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The modprobedatadir is now set as a meson option, but without a
default value.

Set the default value if modprobedatadir is not set.

Fixes: 524ad09d5eda ("meson: make modprobedatadir an option")
Signed-off-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
---
 contrib/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/meson.build b/contrib/meson.build
index ad63a50..48aa7c0 100644
--- a/contrib/meson.build
+++ b/contrib/meson.build
@@ -26,6 +26,6 @@ endif
 
 modprobedatadir = get_option('modprobedatadir')
 if modprobedatadir == ''
-  modprobedatadir = get_option('modprobedatadir')
+  modprobedatadir = sysconfdir + '/modprobe.d/'
 endif
 install_data('nvdimm-security.conf', install_dir : modprobedatadir)
-- 
2.37.1


