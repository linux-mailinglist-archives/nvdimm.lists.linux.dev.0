Return-Path: <nvdimm+bounces-346-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFD23B970F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Jul 2021 22:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F2D5F1C0F9C
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Jul 2021 20:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCB733F0;
	Thu,  1 Jul 2021 20:10:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A41433E1
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:32 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606984"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606984"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:26 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271440"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:25 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 19/21] Documentation/cxl: add library API documentation
Date: Thu,  1 Jul 2021 14:10:03 -0600
Message-Id: <20210701201005.3065299-20-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add library API documentation for libcxl(3) using the existing
asciidoc(tor) build system. Add a section 3 man page for 'libcxl' that
provides an overview of the library and its usage, and a man page for
the 'cxl_new()' API.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/lib/cxl_new.txt | 43 +++++++++++++++++++++++
 Documentation/cxl/lib/libcxl.txt  | 56 +++++++++++++++++++++++++++++
 configure.ac                      |  1 +
 Makefile.am                       |  1 +
 .gitignore                        |  3 ++
 Documentation/cxl/lib/Makefile.am | 58 +++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+)
 create mode 100644 Documentation/cxl/lib/cxl_new.txt
 create mode 100644 Documentation/cxl/lib/libcxl.txt
 create mode 100644 Documentation/cxl/lib/Makefile.am

diff --git a/Documentation/cxl/lib/cxl_new.txt b/Documentation/cxl/lib/cxl_new.txt
new file mode 100644
index 0000000..d4d5bcb
--- /dev/null
+++ b/Documentation/cxl/lib/cxl_new.txt
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl_new(3)
+==========
+
+NAME
+----
+cxl_new - Create a new library context object that acts as a handle for all
+library operations
+
+SYNOPSIS
+--------
+[verse]
+----
+#include <cxl/libcxl.h>
+
+int cxl_new(struct cxl_ctx **ctx);
+----
+
+DESCRIPTION
+-----------
+Instantiates a new library context, and stores an opaque pointer in ctx. The
+context is freed by linklibcxl:cxl_unref[3], i.e. cxl_new(3) implies an
+internal linklibcxl:cxl_ref[3].
+
+
+RETURN VALUE
+------------
+Returns 0 on success, and a negative errno on failure.
+Possible error codes are:
+
+ * -ENOMEM
+ * -ENXIO
+
+EXAMPLE
+-------
+See example usage in test/libcxl.c
+
+include::../../copyright.txt[]
+
+SEE ALSO
+--------
+linklibcxl:cxl_ref[3], linklibcxl:cxl_unref[3]
diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
new file mode 100644
index 0000000..47f4cc3
--- /dev/null
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+libcxl(3)
+=========
+
+NAME
+----
+libcxl - A library to interact with CXL devices through sysfs(5)
+and ioctl(2) interfaces
+
+SYNOPSIS
+--------
+[verse]
+#include <cxl/libcxl.h>
+cc ... -lcxl
+
+DESCRIPTION
+-----------
+libcxl provides interfaces to interact with CXL devices in Linux, using sysfs
+interfaces for most kernel interactions, and the ioctl() interface for command
+submission.
+
+The starting point for all library interfaces is a 'cxl_ctx' object, returned
+by linklibcxl:cxl_new[3]. CXL 'Type 3' memory devices are children of the
+cxl_ctx object, and can be iterated through using an iterator API.
+
+Library level interfaces that are agnostic to any device, or a specific
+subclass of operations have the prefix 'cxl_'
+
+The object representing a CXL Type 3 device is 'cxl_memdev'. Library interfaces
+related to these devices have the prefix 'cxl_memdev_'. These interfaces are
+mostly associated with sysfs interactions (unless otherwise noted in their
+respective documentation pages). They are typically used to retrieve data
+published by the kernel, or to send data or trigger kernel operations for a
+given device.
+
+A 'cxl_cmd' is a reference counted object which is used to perform 'Mailbox'
+commands as described in the CXL Specification. A 'cxl_cmd' object is tied to a
+'cxl_memdev'. Associated library interfaces have the prefix 'cxl_cmd_'. Within
+this sub-class of interfaces, there are:
+
+ * 'cxl_cmd_new_*' interfaces that allocate a new cxl_cmd object for a given
+   command type.
+
+ * 'cxl_cmd_submit' which submits the command via ioctl()
+
+ * 'cxl_cmd_<name>_get_<field>' interfaces that get specific fields out of the
+   command response
+
+ * 'cxl_cmd_get_*' interfaces to get general command related information.
+
+include::../../copyright.txt[]
+
+SEE ALSO
+--------
+linklibcxl:cxl[1]
diff --git a/configure.ac b/configure.ac
index dadae0a..00497ae 100644
--- a/configure.ac
+++ b/configure.ac
@@ -231,6 +231,7 @@ AC_CONFIG_FILES([
         Documentation/ndctl/Makefile
         Documentation/daxctl/Makefile
         Documentation/cxl/Makefile
+        Documentation/cxl/lib/Makefile
 ])
 
 AC_OUTPUT
diff --git a/Makefile.am b/Makefile.am
index 4904ee7..e2f6bef 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,6 +4,7 @@ ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
 SUBDIRS = . cxl/lib daxctl/lib ndctl/lib cxl ndctl daxctl
 if ENABLE_DOCS
 SUBDIRS += Documentation/ndctl Documentation/daxctl Documentation/cxl
+SUBDIRS += Documentation/cxl/lib
 endif
 SUBDIRS += test
 
diff --git a/.gitignore b/.gitignore
index 6a97b92..6468c7a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,12 +14,15 @@ Makefile.in
 /libtool
 /stamp-h1
 *.1
+*.3
 Documentation/daxctl/asciidoc.conf
 Documentation/ndctl/asciidoc.conf
 Documentation/cxl/asciidoc.conf
+Documentation/cxl/lib/asciidoc.conf
 Documentation/daxctl/asciidoctor-extensions.rb
 Documentation/ndctl/asciidoctor-extensions.rb
 Documentation/cxl/asciidoctor-extensions.rb
+Documentation/cxl/lib/asciidoctor-extensions.rb
 Documentation/ndctl/attrs.adoc
 .dirstamp
 daxctl/config.h
diff --git a/Documentation/cxl/lib/Makefile.am b/Documentation/cxl/lib/Makefile.am
new file mode 100644
index 0000000..41e3a5f
--- /dev/null
+++ b/Documentation/cxl/lib/Makefile.am
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020-2021 Intel Corporation. All rights reserved.
+
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Libcxl,g' -e's,@utility@,libcxl,g'
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+else
+
+do_subst = sed -e 's,UTILITY,libcxl,g'
+CONFFILE = asciidoc.conf
+asciidoc.conf: ../../asciidoc.conf.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+endif
+
+man3_MANS = \
+	libcxl.3 \
+	cxl_new.3
+
+EXTRA_DIST = $(man3_MANS)
+
+CLEANFILES = $(man3_MANS)
+
+XML_DEPS = \
+	../../../version.m4 \
+	../../copyright.txt \
+	Makefile \
+	$(CONFFILE)
+
+RM ?= rm -f
+
+if USE_ASCIIDOCTOR
+
+%.3: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
+		-I. -rasciidoctor-extensions \
+		-amansource=libcxl -amanmanual="libcxl Manual" \
+		-andctl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+else
+
+%.xml: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		--unsafe -alibcxl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+%.3: %.xml $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@ && \
+		$(XMLTO) -o . -m ../../manpage-normal.xsl man $<
+
+endif
-- 
2.31.1


