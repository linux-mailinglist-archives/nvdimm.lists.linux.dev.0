Return-Path: <nvdimm+bounces-2368-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3833A485AB7
	for <lists+linux-nvdimm@lfdr.de>; Wed,  5 Jan 2022 22:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E17DE3E0FF2
	for <lists+linux-nvdimm@lfdr.de>; Wed,  5 Jan 2022 21:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424FE2CB4;
	Wed,  5 Jan 2022 21:32:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCEC2C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418374; x=1672954374;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FvoaSKNWDqMhu7Cml7B14JkUPfLXFZeV1FOyv7XtWtI=;
  b=SzSUKW9GLXtAn5HGU93pI2TFF6RvQSK3hKGtTG+KlXnSFDq8pNfm/tPp
   yktWg3EhPiCcZx6F/6TWdBuv+thFtqgfQbyLBPjOa/rpTrScYxa9CwAEV
   f5K7TAPzYIfH5KTTdS0T17aV70KexDwtEtA9SuXdGKrJE5k4qIoJIApNh
   AXn+vVWD3Jye6+FVGVGWuMQcVCT1lM3iePM8egmvDFKXWSg2/dO6K/wLm
   QbzaXdeU1scWm8+j9SB91TzqAIHeiqUQtcGKhktrTwmDJjwcc9N8DA43X
   kODvh3k5g8IKX9aTB84Wc8KnkUeHQHAmX15UNMImpJkfu2IDAxeVA2WFy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242335941"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="242335941"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="513148340"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:53 -0800
Subject: [ndctl PATCH v3 14/16] build: Add meson build infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:53 -0800
Message-ID: <164141837329.3990253.11664056350173402543.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Build times improve from 10s of seconds to sub-second builds especially
when ccache gets involved and the only change is a git version bump. Recall
that every time the version changes with autotools it does a reconfigure.
With meson only the objects that depend on the version string are rebuilt.
So the primary motivation is to make the ndctl project more enjoyable to
develop.

Tools, libraries, documentation, and tests all seem to be working. The
remaining work is to redo the rpm build infrastructure, and validate that
installation is working as expected.

Given the long standing momentum on the old build system it is still kept
functional for now. The only compatibility hack when moving from an
autotools build to a meson build is to delete the config.h files generated
by the old system in favor of the unified configuration header build from
the config.h.meson template.

Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                        |    5 +
 Documentation/cxl/lib/meson.build |   79 ++++++++++
 Documentation/cxl/meson.build     |   84 +++++++++++
 Documentation/daxctl/meson.build  |   94 ++++++++++++
 Documentation/ndctl/meson.build   |  124 ++++++++++++++++
 clean_config.sh                   |    2 
 config.h.meson                    |  151 ++++++++++++++++++++
 contrib/meson.build               |   28 ++++
 cxl/lib/meson.build               |   35 +++++
 cxl/meson.build                   |   25 +++
 daxctl/device.c                   |    1 
 daxctl/lib/meson.build            |   44 ++++++
 daxctl/meson.build                |   35 +++++
 meson.build                       |  280 +++++++++++++++++++++++++++++++++++++
 meson_options.txt                 |   25 +++
 ndctl/lib/meson.build             |   48 ++++++
 ndctl/meson.build                 |   82 +++++++++++
 test/meson.build                  |  237 +++++++++++++++++++++++++++++++
 tools/meson-vcs-tag.sh            |   18 ++
 util/meson.build                  |   16 ++
 version.h.in                      |    2 
 21 files changed, 1414 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/lib/meson.build
 create mode 100644 Documentation/cxl/meson.build
 create mode 100644 Documentation/daxctl/meson.build
 create mode 100644 Documentation/ndctl/meson.build
 create mode 100755 clean_config.sh
 create mode 100644 config.h.meson
 create mode 100644 contrib/meson.build
 create mode 100644 cxl/lib/meson.build
 create mode 100644 cxl/meson.build
 create mode 100644 daxctl/lib/meson.build
 create mode 100644 daxctl/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 ndctl/lib/meson.build
 create mode 100644 ndctl/meson.build
 create mode 100644 test/meson.build
 create mode 100755 tools/meson-vcs-tag.sh
 create mode 100644 util/meson.build
 create mode 100644 version.h.in

diff --git a/.gitignore b/.gitignore
index 4ab393e71a89..91c5e37b7fef 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,7 +9,9 @@ Makefile.in
 /aclocal.m4
 /autom4te.cache
 /build-aux
-/config.*
+/config.h
+/config.log
+/config.status
 /configure
 /libtool
 /stamp-h1
@@ -24,6 +26,7 @@ Documentation/ndctl/asciidoctor-extensions.rb
 Documentation/cxl/asciidoctor-extensions.rb
 Documentation/cxl/lib/asciidoctor-extensions.rb
 .dirstamp
+build/
 daxctl/config.h
 daxctl/daxctl
 daxctl/lib/libdaxctl.la
diff --git a/Documentation/cxl/lib/meson.build b/Documentation/cxl/lib/meson.build
new file mode 100644
index 000000000000..4b3f59685447
--- /dev/null
+++ b/Documentation/cxl/lib/meson.build
@@ -0,0 +1,79 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Libcxl,g', '-e', 's,@utility@,cxl,g', '@INPUT@'
+    ],
+    input : '../../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,libcxl,g',
+    ],
+    input : '../../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../../copyright.txt',
+]
+
+libcxl_manpages = [
+  'libcxl.txt',
+  'cxl_new.txt',
+]
+
+foreach man : libcxl_manpages
+  name = man.split('.')[0]
+  output = name + '.3'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=libcxl',
+        '-amanmanual=libcxl Manual',
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man3'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man3'),
+    )
+  endif
+endforeach
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
new file mode 100644
index 000000000000..64ce13f59012
--- /dev/null
+++ b/Documentation/cxl/meson.build
@@ -0,0 +1,84 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Cxl,g', '-e', 's,@utility@,cxl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,cxl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../copyright.txt',
+]
+
+cxl_manpages = [
+  'cxl.txt',
+  'cxl-list.txt',
+  'cxl-read-labels.txt',
+  'cxl-write-labels.txt',
+  'cxl-zero-labels.txt',
+]
+
+foreach man : cxl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=cxl',
+        '-amanmanual=cxl Manual',
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
+
+subdir('lib')
diff --git a/Documentation/daxctl/meson.build b/Documentation/daxctl/meson.build
new file mode 100644
index 000000000000..7699e69c29be
--- /dev/null
+++ b/Documentation/daxctl/meson.build
@@ -0,0 +1,94 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Daxctl,g', '-e', 's,@utility@,daxctl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,daxctl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+	'human-option.txt',
+        '../copyright.txt',
+]
+
+daxctl_manpages = [
+  'daxctl.txt',
+  'daxctl-list.txt',
+  'daxctl-migrate-device-model.txt',
+  'daxctl-reconfigure-device.txt',
+  'daxctl-online-memory.txt',
+  'daxctl-offline-memory.txt',
+  'daxctl-disable-device.txt',
+  'daxctl-enable-device.txt',
+  'daxctl-create-device.txt',
+  'daxctl-destroy-device.txt',
+]
+
+foreach man : daxctl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=daxctl',
+        '-amanmanual=daxctl Manual',
+	'-adaxctl_confdir=@0@'.format(daxctlconf_dir),
+	'-adaxctl_conf=@0@'.format(daxctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-adaxctl_confdir=@0@'.format(daxctlconf_dir),
+	'-adaxctl_conf=@0@'.format(daxctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
diff --git a/Documentation/ndctl/meson.build b/Documentation/ndctl/meson.build
new file mode 100644
index 000000000000..b82635a4cc4b
--- /dev/null
+++ b/Documentation/ndctl/meson.build
@@ -0,0 +1,124 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Ndctl,g', '-e', 's,@utility@,ndctl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,ndctl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../copyright.txt',
+        'region-description.txt',
+        'xable-region-options.txt',
+        'dimm-description.txt',
+        'xable-dimm-options.txt',
+        'xable-namespace-options.txt',
+        'ars-description.txt',
+        'labels-description.txt',
+        'labels-options.txt',
+]
+
+ndctl_manpages = [
+  'ndctl.txt',
+  'ndctl-wait-scrub.txt',
+  'ndctl-start-scrub.txt',
+  'ndctl-zero-labels.txt',
+  'ndctl-read-labels.txt',
+  'ndctl-write-labels.txt',
+  'ndctl-init-labels.txt',
+  'ndctl-check-labels.txt',
+  'ndctl-enable-region.txt',
+  'ndctl-disable-region.txt',
+  'ndctl-enable-dimm.txt',
+  'ndctl-disable-dimm.txt',
+  'ndctl-enable-namespace.txt',
+  'ndctl-disable-namespace.txt',
+  'ndctl-create-namespace.txt',
+  'ndctl-destroy-namespace.txt',
+  'ndctl-check-namespace.txt',
+  'ndctl-clear-errors.txt',
+  'ndctl-inject-error.txt',
+  'ndctl-inject-smart.txt',
+  'ndctl-update-firmware.txt',
+  'ndctl-list.txt',
+  'ndctl-monitor.txt',
+  'ndctl-setup-passphrase.txt',
+  'ndctl-update-passphrase.txt',
+  'ndctl-remove-passphrase.txt',
+  'ndctl-freeze-security.txt',
+  'ndctl-sanitize-dimm.txt',
+  'ndctl-load-keys.txt',
+  'ndctl-wait-overwrite.txt',
+  'ndctl-read-infoblock.txt',
+  'ndctl-write-infoblock.txt',
+  'ndctl-activate-firmware.txt',
+]
+
+foreach man : ndctl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=ndctl',
+        '-amanmanual=ndctl Manual',
+	'-andctl_confdir=@0@'.format(ndctlconf_dir),
+	'-andctl_monitorconf=@0@'.format(ndctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-andctl_confdir=@0@'.format(ndctlconf_dir),
+	'-andctl_monitorconf=@0@'.format(ndctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
diff --git a/clean_config.sh b/clean_config.sh
new file mode 100755
index 000000000000..03ec04c5554b
--- /dev/null
+++ b/clean_config.sh
@@ -0,0 +1,2 @@
+#!/bin/bash
+git ls-files -o --exclude build | grep config.h\$ | xargs rm
diff --git a/config.h.meson b/config.h.meson
new file mode 100644
index 000000000000..98102251b494
--- /dev/null
+++ b/config.h.meson
@@ -0,0 +1,151 @@
+/* Debug messages. */
+#mesondefine ENABLE_DEBUG
+
+/* destructive functional tests support */
+#mesondefine ENABLE_DESTRUCTIVE
+
+/* Documentation / man pages. */
+#mesondefine ENABLE_DOCS
+
+/* Enable keyutils support */
+#mesondefine ENABLE_KEYUTILS
+
+/* System logging. */
+#mesondefine ENABLE_LOGGING
+
+/* ndctl test poison support */
+#mesondefine ENABLE_POISON
+
+/* ndctl test support */
+#mesondefine ENABLE_TEST
+
+/* Define to 1 if big-endian-arch */
+#mesondefine HAVE_BIG_ENDIAN
+
+/* Define to 1 if you have the declaration of `BUS_MCEERR_AR', and to 0 if you
+   don't. */
+#mesondefine HAVE_DECL_BUS_MCEERR_AR
+
+/* Define to 1 if you have the declaration of `MAP_SHARED_VALIDATE', and to 0
+   if you don't. */
+#mesondefine HAVE_DECL_MAP_SHARED_VALIDATE
+
+/* Define to 1 if you have the declaration of `MAP_SYNC', and to 0 if you
+   don't. */
+#mesondefine HAVE_DECL_MAP_SYNC
+
+/* Define to 1 if you have the <dlfcn.h> header file. */
+#mesondefine HAVE_DLFCN_H
+
+/* Define to 1 if you have the <inttypes.h> header file. */
+#mesondefine HAVE_INTTYPES_H
+
+/* Define to 1 if you have the <keyutils.h> header file. */
+#mesondefine HAVE_KEYUTILS_H
+
+/* Define to 1 if you have the <linux/version.h> header file. */
+#mesondefine HAVE_LINUX_VERSION_H
+
+/* Define to 1 if little-endian-arch */
+#mesondefine HAVE_LITTLE_ENDIAN
+
+/* Define to 1 if you have the <memory.h> header file. */
+#mesondefine HAVE_MEMORY_H
+
+/* Define to 1 if you have the `secure_getenv' function. */
+#mesondefine HAVE_SECURE_GETENV
+
+/* Define to 1 if you have statement expressions. */
+#mesondefine HAVE_STATEMENT_EXPR
+
+/* Define to 1 if you have the <stdint.h> header file. */
+#mesondefine HAVE_STDINT_H
+
+/* Define to 1 if you have the <stdlib.h> header file. */
+#mesondefine HAVE_STDLIB_H
+
+/* Define to 1 if you have the <strings.h> header file. */
+#mesondefine HAVE_STRINGS_H
+
+/* Define to 1 if you have the <string.h> header file. */
+#mesondefine HAVE_STRING_H
+
+/* Define to 1 if you have the <sys/stat.h> header file. */
+#mesondefine HAVE_SYS_STAT_H
+
+/* Define to 1 if you have the <sys/types.h> header file. */
+#mesondefine HAVE_SYS_TYPES_H
+
+/* Define to 1 if typeof works with your compiler. */
+#mesondefine HAVE_TYPEOF
+
+/* Define to 1 if you have the <unistd.h> header file. */
+#mesondefine HAVE_UNISTD_H
+
+/* Define to 1 if using libuuid */
+#mesondefine HAVE_UUID
+
+/* Define to 1 if you have the `__secure_getenv' function. */
+#mesondefine HAVE___SECURE_GETENV
+
+/* Define to the sub-directory where libtool stores uninstalled libraries. */
+#mesondefine LT_OBJDIR
+
+/* Name of package */
+#mesondefine PACKAGE
+
+/* Define to the address where bug reports for this package should be sent. */
+#mesondefine PACKAGE_BUGREPORT
+
+/* Define to the full name of this package. */
+#mesondefine PACKAGE_NAME
+
+/* Define to the full name and version of this package. */
+#mesondefine PACKAGE_STRING
+
+/* Define to the one symbol short name of this package. */
+#mesondefine PACKAGE_TARNAME
+
+/* Define to the home page for this package. */
+#mesondefine PACKAGE_URL
+
+/* Define to the version of this package. */
+#mesondefine PACKAGE_VERSION
+
+/* Define to 1 if you have the ANSI C header files. */
+#mesondefine STDC_HEADERS
+
+/* Version number of package */
+#mesondefine VERSION
+
+/* Number of bits in a file offset, on hosts where this is settable. */
+#mesondefine _FILE_OFFSET_BITS
+
+/* Define for large files, on AIX-style hosts. */
+#mesondefine _LARGE_FILES
+
+/* Define to 1 if on MINIX. */
+#mesondefine _MINIX
+
+/* Define to 2 if the system does not provide POSIX.1 features except with
+   this defined. */
+#mesondefine _POSIX_1_SOURCE
+
+/* Define to 1 if you need to in order for `stat' and other things to work. */
+#mesondefine _POSIX_SOURCE
+
+/* Define to __typeof__ if your compiler spells it that way. */
+#mesondefine typeof
+
+/* Define to enable GNU Source Extensions */
+#mesondefine _GNU_SOURCE
+
+/* Locations to install configuration files, key config, man pages, etc.. */
+#mesondefine NDCTL_CONF_FILE
+#mesondefine NDCTL_CONF_DIR
+#mesondefine DAXCTL_CONF_DIR
+#mesondefine NDCTL_KEYS_DIR
+#mesondefine NDCTL_MAN_PATH
+#mesondefine DAXCTL_MODPROBE_DATA
+#mesondefine DAXCTL_MODPROBE_INSTALL
+#mesondefine PREFIX
diff --git a/contrib/meson.build b/contrib/meson.build
new file mode 100644
index 000000000000..4ed3c20165b4
--- /dev/null
+++ b/contrib/meson.build
@@ -0,0 +1,28 @@
+bashcompletiondir = get_option('bashcompletiondir')
+if bashcompletiondir == ''
+  bash_completion = dependency('bash-completion', required : false)
+  if bash_completion.found()
+      bashcompletiondir = bash_completion.get_pkgconfig_variable('completionsdir')
+  else
+    bashcompletiondir = datadir / 'bash-completion/completions'
+  endif
+endif
+
+if bashcompletiondir != 'no'
+  install_data('ndctl', install_dir : bashcompletiondir)
+
+# TODO Switch to symlinks once 0.61.0 is more widely available
+#  install_symlink('daxctl',
+#    install_dir : bashcompletiondir,
+#    pointing_to : 'ndctl'
+#  )
+#  install_symlink('cxl',
+#    install_dir : bashcompletiondir,
+#    pointing_to : 'ndctl'
+#  )
+  install_data('ndctl', rename : 'daxctl', install_dir : bashcompletiondir)
+  install_data('ndctl', rename : 'cxl', install_dir : bashcompletiondir)
+endif
+
+modprobedatadir = get_option('sysconfdir') + '/modprobe.d/'
+install_data('nvdimm-security.conf', install_dir : modprobedatadir)
diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
new file mode 100644
index 000000000000..eba0ce7278e7
--- /dev/null
+++ b/cxl/lib/meson.build
@@ -0,0 +1,35 @@
+libcxl_version = '@0@.@1@.@2@'.format(
+  LIBCXL_CURRENT - LIBCXL_AGE,
+  LIBCXL_REVISION,
+  LIBCXL_AGE)
+
+mapfile = files('libcxl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+cxl = library('cxl',
+  '../../util/sysfs.c',
+  '../../util/log.c',
+  '../../util/log.h',
+  'libcxl.c',
+  include_directories : root_inc,
+  dependencies : [
+    uuid,
+    kmod,
+  ],
+  version : libcxl_version,
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+cxl_dep = declare_dependency(link_with : cxl)
+
+custom_target(
+  'libcxl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libcxl.pc.in',
+  output : 'libcxl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
diff --git a/cxl/meson.build b/cxl/meson.build
new file mode 100644
index 000000000000..805924b9df9b
--- /dev/null
+++ b/cxl/meson.build
@@ -0,0 +1,25 @@
+cxl_src = [
+  'cxl.c',
+  'list.c',
+  'memdev.c',
+  '../util/json.c',
+  'json.c',
+  'filter.c',
+]
+
+cxl_tool = executable('cxl',
+  cxl_src,
+  include_directories : root_inc,
+  dependencies : [
+    cxl_dep,
+    util_dep,
+    uuid,
+    kmod,
+    json,
+    versiondep,
+  ],
+  install : true,
+  install_dir : rootbindir,
+)
+
+install_headers('libcxl.h', subdir : 'cxl')
diff --git a/daxctl/device.c b/daxctl/device.c
index d202f02d07e7..d2d206b95cae 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -8,6 +8,7 @@
 #include <limits.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <uuid/uuid.h>
 #include <sys/sysmacros.h>
 #include <util/size.h>
 #include <util/json.h>
diff --git a/daxctl/lib/meson.build b/daxctl/lib/meson.build
new file mode 100644
index 000000000000..b79c6e591945
--- /dev/null
+++ b/daxctl/lib/meson.build
@@ -0,0 +1,44 @@
+libdaxctl_version = '@0@.@1@.@2@'.format(
+  LIBDAXCTL_CURRENT - LIBDAXCTL_AGE,
+  LIBDAXCTL_REVISION,
+  LIBDAXCTL_AGE,
+)
+
+mapfile = files('libdaxctl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+libdaxctl_src = [
+  '../../util/iomem.c',
+  '../../util/sysfs.c',
+  '../../util/log.c',
+  'libdaxctl.c',
+]
+
+daxctl = library(
+ 'daxctl',
+  libdaxctl_src,
+  version : libdaxctl_version,
+  include_directories : root_inc,
+  dependencies : [
+    uuid,
+    kmod,
+  ],
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+
+daxctl_dep = declare_dependency(link_with : daxctl)
+
+custom_target(
+  'libdaxctl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libdaxctl.pc.in',
+  output : 'libdaxctl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
+
+install_data('daxctl.conf', install_dir : datadir / 'daxctl')
diff --git a/daxctl/meson.build b/daxctl/meson.build
new file mode 100644
index 000000000000..ec2e2b648d40
--- /dev/null
+++ b/daxctl/meson.build
@@ -0,0 +1,35 @@
+daxctl_src = [
+  'daxctl.c',
+  'acpi.c',
+  'list.c',
+  'migrate.c',
+  'device.c',
+  '../util/json.c',
+  'json.c',
+  'filter.c',
+]
+
+daxctl_tool = executable('daxctl',
+  daxctl_src,
+  include_directories : root_inc,
+  dependencies : [
+    daxctl_dep,
+    ndctl_dep,
+    iniparser,
+    util_dep,
+    uuid,
+    kmod,
+    json,
+    versiondep,
+  ],
+  install : true,
+  install_dir : rootbindir,
+)
+
+install_headers('libdaxctl.h', subdir : 'daxctl')
+
+install_data('daxctl.example.conf', install_dir : daxctlconf_dir )
+if get_option('systemd').enabled()
+  install_data('90-daxctl-device.rules', install_dir : udevrulesdir)
+  install_data('daxdev-reconfigure@.service', install_dir : systemdunitdir)
+endif
diff --git a/meson.build b/meson.build
new file mode 100644
index 000000000000..272ac642c193
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,280 @@
+project('ndctl', 'c',
+  version : '72',
+  license : [
+    'GPL-2.0',
+    'LGPL-2.1',
+    'CC0-1.0',
+    'MIT',
+  ],
+  default_options : [
+    'c_std=gnu99',
+    'prefix=/usr',
+    'sysconfdir=/etc',
+    'localstatedir=/var',
+  ],
+)
+
+# rootprefixdir and rootlibdir setup copied from systemd:
+rootprefixdir = get_option('rootprefix')
+rootprefix_default = '/usr'
+if rootprefixdir == ''
+        rootprefixdir = rootprefix_default
+endif
+rootbindir = join_paths(rootprefixdir, 'bin')
+
+# join_paths ignores the preceding arguments if an absolute component is
+# encountered, so this should canonicalize various paths when they are
+# absolute or relative.
+prefixdir = get_option('prefix')
+if not prefixdir.startswith('/')
+        error('Prefix is not absolute: "@0@"'.format(prefixdir))
+endif
+if prefixdir != rootprefixdir and rootprefixdir != '/' and not prefixdir.strip('/').startswith(rootprefixdir.strip('/') + '/')
+  error('Prefix is not below root prefix (now rootprefix=@0@ prefix=@1@)'.format(
+	rootprefixdir, prefixdir))
+endif
+
+libdir = join_paths(prefixdir, get_option('libdir'))
+rootlibdir = get_option('rootlibdir')
+if rootlibdir == ''
+  rootlibdir = join_paths(rootprefixdir, libdir.split('/')[-1])
+endif
+datadir = prefixdir / get_option('datadir')
+includedir = prefixdir / get_option('includedir')
+
+pkgconfiglibdir = get_option('pkgconfiglibdir') != '' ? get_option('pkgconfiglibdir') : libdir / 'pkgconfig'
+
+datadir = prefixdir / get_option('datadir')
+includedir = prefixdir / get_option('includedir')
+sysconfdir =  get_option('sysconfdir')
+
+pkgconfig_script = '''
+sed -e s,@VERSION@,@0@,g
+    -e s,@prefix@,@1@,g
+    -e s,@exec_prefix@,@1@,g
+    -e s,@libdir@,@2@,g
+    -e s,@includedir@,@3@,g
+'''.format(meson.project_version(), prefixdir, libdir, includedir).split()
+
+cc_flags = [
+  '-Wall',
+  '-Wchar-subscripts',
+  '-Wformat-security',
+  '-Wmissing-declarations',
+  '-Wmissing-prototypes',
+  '-Wnested-externs ',
+  '-Wshadow',
+  '-Wsign-compare',
+  '-Wstrict-prototypes',
+  '-Wtype-limits',
+  '-Wmaybe-uninitialized',
+  '-Wdeclaration-after-statement',
+  '-Wunused-result',
+  '-D_FORTIFY_SOURCE=2',
+  '-O2',
+]
+cc = meson.get_compiler('c')
+add_project_arguments(cc.get_supported_arguments(cc_flags), language : 'c')
+
+project_source_root = meson.current_source_dir()
+
+# Remove this after the conversion to meson has been completed
+# Cleanup the leftover config.h files to avoid conflicts with the meson
+# generated config.h
+git = find_program('git', required : false)
+if git.found()
+  run_command('clean_config.sh',
+    env : 'GIT_DIR=@0@/.git'.format(project_source_root),
+  )
+endif
+
+version_tag = get_option('version-tag')
+if version_tag != ''
+  vcs_data = configuration_data()
+  vcs_data.set('VCS_TAG', version_tag)
+  version_h = configure_file(
+    configuration : vcs_data,
+    input : 'version.h.in',
+    output : 'version.h'
+  )
+else
+  vcs_tagger = [
+    project_source_root + '/tools/meson-vcs-tag.sh',
+    project_source_root,
+    meson.project_version()
+  ]
+
+  version_h = vcs_tag(
+      input : 'version.h.in',
+      output : 'version.h',
+      command: vcs_tagger
+  )
+endif
+
+versiondep = declare_dependency(
+  compile_args: ['-include', 'version.h'],
+  sources: version_h
+)
+
+kmod = dependency('libkmod')
+libudev = dependency('libudev')
+uuid = dependency('uuid')
+json = dependency('json-c')
+if get_option('docs').enabled()
+  if get_option('asciidoctor').enabled()
+    asciidoc = find_program('asciidoctor', required : true)
+  else
+    asciidoc = find_program('asciidoc', required : true)
+    xmlto = find_program('xmlto', required : true)
+  endif
+endif
+
+if get_option('systemd').enabled()
+  systemd = dependency('systemd', required : true)
+  systemdunitdir = systemd.get_pkgconfig_variable('systemd_system_unit_dir')
+  udev = dependency('udev', required : true)
+  udevdir = udev.get_pkgconfig_variable('udevdir')
+  udevrulesdir = udevdir / 'rules.d'
+endif
+
+cc = meson.get_compiler('c')
+
+# keyutils and iniparser lack pkgconfig
+keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
+iniparser = cc.find_library('iniparser', required : true)
+
+conf = configuration_data()
+check_headers = [
+  ['HAVE_DLFCN_H', 'dlfcn.h'],
+  ['HAVE_INTTYPES_H', 'inttypes.h'],
+  ['HAVE_KEYUTILS_H', 'keyutils.h'],
+  ['HAVE_LINUX_VERSION_H', 'linux/version.h'],
+  ['HAVE_MEMORY_H', 'memory.h'],
+  ['HAVE_STDINT_H', 'stdint.h'],
+  ['HAVE_STDLIB_H', 'stdlib.h'],
+  ['HAVE_STRINGS_H', 'strings.h'],
+  ['HAVE_STRING_H', 'string.h'],
+  ['HAVE_SYS_STAT_H', 'sys/stat.h'],
+  ['HAVE_SYS_TYPES_H', 'sys/types.h'],
+  ['HAVE_UNISTD_H', 'unistd.h'],
+]
+
+foreach h : check_headers
+  if cc.has_header(h.get(1))
+    conf.set(h.get(0), 1)
+  endif
+endforeach
+
+map_sync_symbols = [
+  [ 'signal.h', 'BUS_MCEERR_AR' ],
+  [ 'linux/mman.h', 'MAP_SHARED_VALIDATE' ],
+  [ 'linux/mman.h', 'MAP_SYNC' ],
+]
+
+count = 0
+foreach symbol : map_sync_symbols
+  if cc.has_header_symbol(symbol[0], symbol[1])
+    conf.set('HAVE_DECL_@0@'.format(symbol[1].to_upper()), 1)
+    count = count + 1
+  endif
+endforeach
+
+poison_enabled = false
+if get_option('poison').enabled() and count == 3
+  poison_enabled = true
+endif
+
+conf.set('ENABLE_POISON', poison_enabled)
+conf.set('ENABLE_KEYUTILS', get_option('keyutils').enabled())
+conf.set('ENABLE_TEST', get_option('test').enabled())
+conf.set('ENABLE_DESTRUCTIVE', get_option('destructive').enabled())
+conf.set('ENABLE_LOGGING', get_option('logging').enabled())
+conf.set('ENABLE_DEBUG', get_option('dbg').enabled())
+
+typeof = cc.run('''
+  int main() {
+    struct {
+      char a[16];
+    } x;
+    typeof(x) y;
+
+    return sizeof(x) == sizeof(y);
+  }
+  '''
+)
+
+if typeof.compiled() and typeof.returncode() == 1
+  conf.set('HAVE_TYPEOF', 1)
+  conf.set('HAVE_STATEMENT_EXPR', 1)
+endif
+
+if target_machine.endian() == 'big'
+  conf.set('HAVE_BIG_ENDIAN', 1)
+else
+  conf.set('HAVE_LITTLE_ENDIAN', 1)
+endif
+
+conf.set('_GNU_SOURCE', true)
+conf.set_quoted('PREFIX', get_option('prefix'))
+conf.set_quoted('NDCTL_MAN_PATH', get_option('mandir'))
+
+foreach ident : ['secure_getenv', '__secure_getenv']
+  conf.set10('HAVE_' + ident.to_upper(), cc.has_function(ident))
+endforeach
+
+
+ndctlconf_dir = sysconfdir / 'ndctl.conf.d'
+ndctlconf = ndctlconf_dir / 'monitor.conf'
+conf.set_quoted('NDCTL_CONF_FILE', ndctlconf)
+conf.set_quoted('NDCTL_CONF_DIR', ndctlconf_dir)
+
+ndctlkeys_dir = sysconfdir / 'ndctl' / 'keys'
+conf.set_quoted('NDCTL_KEYS_DIR', ndctlkeys_dir)
+
+daxctlconf_dir = sysconfdir / 'daxctl.conf.d'
+daxctlconf = daxctlconf_dir / 'dax.conf'
+conf.set_quoted('DAXCTL_CONF_DIR', daxctlconf_dir)
+
+conf.set_quoted('DAXCTL_MODPROBE_DATA', datadir / 'daxctl/daxctl.conf')
+conf.set_quoted('DAXCTL_MODPROBE_INSTALL', sysconfdir / 'modprobe.d/daxctl.conf')
+
+config_h = configure_file(
+  input : 'config.h.meson',
+  output : 'config.h',
+  configuration : conf
+)
+add_project_arguments('-include', 'config.h', language : 'c')
+
+LIBNDCTL_CURRENT=25
+LIBNDCTL_REVISION=1
+LIBNDCTL_AGE=19
+
+LIBDAXCTL_CURRENT=6
+LIBDAXCTL_REVISION=0
+LIBDAXCTL_AGE=5
+
+LIBCXL_CURRENT=1
+LIBCXL_REVISION=0
+LIBCXL_AGE=0
+
+root_inc = include_directories(['.', 'ndctl', ])
+
+ccan = static_library('ccan',
+  [ 'ccan/str/str.c', 'ccan/list/list.c' ],
+)
+ccan_dep = declare_dependency(link_with : ccan)
+
+subdir('daxctl/lib')
+subdir('ndctl/lib')
+subdir('cxl/lib')
+subdir('util')
+subdir('ndctl')
+subdir('daxctl')
+subdir('cxl')
+if get_option('docs').enabled()
+  subdir('Documentation/ndctl')
+  subdir('Documentation/daxctl')
+  subdir('Documentation/cxl')
+endif
+subdir('test')
+subdir('contrib')
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 000000000000..95312bfcb0d3
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,25 @@
+option('version-tag', type : 'string',
+       description : 'override the git version string')
+option('docs', type : 'feature', value : 'enabled')
+option('asciidoctor', type : 'feature', value : 'disabled')
+option('systemd', type : 'feature', value : 'enabled')
+option('keyutils', type : 'feature', value : 'enabled',
+  description : 'enable nvdimm device passphrase management')
+option('test', type : 'feature', value : 'disabled',
+  description : 'enable shipping tests in ndctl')
+option('destructive', type : 'feature', value : 'disabled',
+  description : 'enable tests that may clobber live system resources')
+option('poison', type : 'feature', value : 'enabled',
+  description : 'enable tests that inject poison / memory-failure')
+option('logging', type : 'feature', value : 'enabled',
+  description : 'enable log infrastructure')
+option('dbg', type : 'feature', value : 'enabled',
+  description : 'enable dbg messages')
+option('rootprefix', type : 'string',
+       description : '''override the root prefix [default '/' if split-usr and '/usr' otherwise]''')
+option('rootlibdir', type : 'string',
+       description : '''[/usr]/lib/x86_64-linux-gnu or such''')
+option('pkgconfiglibdir', type : 'string', value : '',
+       description : 'directory for standard pkg-config files')
+option('bashcompletiondir', type : 'string',
+       description : '''${datadir}/bash-completion/completions''')
diff --git a/ndctl/lib/meson.build b/ndctl/lib/meson.build
new file mode 100644
index 000000000000..abce87948cf2
--- /dev/null
+++ b/ndctl/lib/meson.build
@@ -0,0 +1,48 @@
+libndctl_version = '@0@.@1@.@2@'.format(
+  LIBNDCTL_CURRENT - LIBNDCTL_AGE,
+  LIBNDCTL_REVISION,
+  LIBNDCTL_AGE)
+
+mapfile = files('libndctl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+ndctl = library(
+ 'ndctl',
+  '../../util/log.c',
+  '../../util/sysfs.c',
+  'dimm.c',
+  'inject.c',
+  'nfit.c',
+  'smart.c',
+  'intel.c',
+  'hpe1.c',
+  'msft.c',
+  'hyperv.c',
+  'papr.c',
+  'ars.c',
+  'firmware.c',
+  'libndctl.c',
+  dependencies : [
+    daxctl_dep,
+    libudev,
+    uuid,
+    kmod,
+  ],
+  include_directories : root_inc,
+  version : libndctl_version,
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+ndctl_dep = declare_dependency(link_with : ndctl)
+
+custom_target(
+  'libndctl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libndctl.pc.in',
+  output : 'libndctl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
diff --git a/ndctl/meson.build b/ndctl/meson.build
new file mode 100644
index 000000000000..6a3d0e5348c2
--- /dev/null
+++ b/ndctl/meson.build
@@ -0,0 +1,82 @@
+ndctl_src = [
+  'ndctl.c',
+  'bus.c',
+  'create-nfit.c',
+  'namespace.c',
+  'check.c',
+  'region.c',
+  'dimm.c',
+  '../util/log.c',
+  '../daxctl/filter.c',
+  'filter.c',
+  'list.c',
+  '../util/json.c',
+  '../daxctl/json.c',
+  'json.c',
+  'json-smart.c',
+  'inject-error.c',
+  'inject-smart.c',
+  'monitor.c',
+]
+
+deps = [
+  util_dep,
+  ndctl_dep,
+  daxctl_dep,
+  cxl_dep,
+  uuid,
+  kmod,
+  json,
+  iniparser,
+  versiondep,
+]
+
+if get_option('keyutils').enabled()
+  ndctl_src += [
+    'keys.c',
+    'load-keys.c',
+  ]
+  deps += keyutils
+endif
+
+if get_option('test').enabled()
+  ndctl_src += [
+  '../test/libndctl.c',
+  '../test/dsm-fail.c',
+  '../util/sysfs.c',
+  '../test/core.c',
+  'test.c',
+]
+endif
+
+if get_option('destructive').enabled()
+  if get_option('test').disabled()
+    error('\'-D=destructive=enabled\' requires \'-Dtest=enabled\'\n')
+  endif
+  ndctl_src += [
+    '../test/pmem_namespaces.c',
+    'bat.c',
+  ]
+endif
+
+if get_option('systemd').enabled()
+  install_data('ndctl-monitor.service', install_dir : systemdunitdir)
+endif
+install_data('monitor.conf', install_dir : ndctlconf_dir)
+install_data('ndctl.conf', install_dir : ndctlconf_dir)
+install_data('keys.readme', install_dir : ndctlkeys_dir)
+
+ndctl_tool = executable('ndctl', ndctl_src,
+  dependencies : deps,
+  install : true,
+  install_dir : rootbindir,
+  include_directories : root_inc,
+)
+
+install_headers(
+  [
+    'libndctl.h',
+    'ndctl.h'
+  ],
+  subdir : 'ndctl'
+)
diff --git a/test/meson.build b/test/meson.build
new file mode 100644
index 000000000000..94287aaef85b
--- /dev/null
+++ b/test/meson.build
@@ -0,0 +1,237 @@
+testcore = [
+  'core.c',
+  '../util/log.c',
+  '../util/sysfs.c',
+]
+
+libndctl_deps = [
+  ndctl_dep,
+  daxctl_dep,
+  uuid,
+  kmod,
+]
+
+ndctl_deps = libndctl_deps + [
+  json,
+  util_dep,
+  versiondep,
+]
+
+libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+namespace_core = [
+  '../ndctl/namespace.c',
+  '../ndctl/filter.c',
+  '../ndctl/check.c',
+  '../util/json.c',
+  '../ndctl/json.c',
+  '../daxctl/filter.c',
+  '../daxctl/json.c',
+]
+
+dsm_fail = executable('dsm-fail', testcore + namespace_core + [ 'dsm-fail.c' ],
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+hugetlb_src = testcore + [ 'hugetlb.c', 'dax-pmd.c' ]
+if poison_enabled
+  hugetlb_src += [ 'dax-poison.c' ]
+endif
+hugetlb = executable('hugetlb', hugetlb_src,
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+ack_shutdown_count = executable('ack-shutdown-count-set',
+  testcore + [ 'ack-shutdown-count-set.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_errors = executable('dax-errors',
+  'dax-errors.c',
+)
+
+smart_notify = executable('smart-notify', 'smart-notify.c',
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+smart_listen = executable('smart-listen', 'smart-listen.c',
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+daxdev_errors = executable('daxdev-errors', [
+    'daxdev-errors.c',
+    '../util/log.c',
+    '../util/sysfs.c',
+  ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+list_smart_dimm = executable('list-smart-dimm', [
+    'list-smart-dimm.c',
+    '../ndctl/filter.c',
+    '../util/json.c',
+    '../ndctl/json.c',
+    '../daxctl/json.c',
+    '../daxctl/filter.c',
+  ],
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+pmem_ns = executable('pmem-ns', testcore + [ 'pmem_namespaces.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_dev = executable('dax-dev', testcore + [ 'dax-dev.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_pmd_src = testcore + [ 'dax-pmd.c' ]
+if poison_enabled
+  dax_pmd_src += [ 'dax-poison.c' ]
+endif
+
+dax_pmd = executable('dax-pmd', dax_pmd_src,
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+device_dax_src = testcore + namespace_core + [
+  'device-dax.c',
+  'dax-dev.c',
+  'dax-pmd.c',
+]
+
+if poison_enabled
+  device_dax_src += 'dax-poison.c'
+endif
+
+device_dax = executable('device-dax', device_dax_src,
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+revoke_devmem = executable('revoke_devmem', testcore + [
+    'revoke-devmem.c',
+    'dax-dev.c',
+  ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+mmap = executable('mmap', 'mmap.c',)
+
+create = find_program('create.sh')
+clear = find_program('clear.sh')
+pmem_errors = find_program('pmem-errors.sh')
+daxdev_errors_sh = find_program('daxdev-errors.sh')
+multi_dax = find_program('multi-dax.sh')
+btt_check = find_program('btt-check.sh')
+label_compat = find_program('label-compat.sh')
+sector_mode = find_program('sector-mode.sh')
+inject_error = find_program('inject-error.sh')
+btt_errors = find_program('btt-errors.sh')
+btt_pad_compat = find_program('btt-pad-compat.sh')
+firmware_update = find_program('firmware-update.sh')
+rescan_partitions = find_program('rescan-partitions.sh')
+inject_smart = find_program('inject-smart.sh')
+monitor = find_program('monitor.sh')
+max_extent = find_program('max_available_extent_ns.sh')
+pfn_meta_errors = find_program('pfn-meta-errors.sh')
+track_uuid = find_program('track-uuid.sh')
+
+tests = [
+  [ 'libndctl',               libndctl ],
+  [ 'dsm-fail',               dsm_fail ],
+  [ 'create.sh',              create ],
+  [ 'clear.sh',               clear ],
+  [ 'pmem-errors.sh',         pmem_errors ],
+  [ 'daxdev-errors.sh',       daxdev_errors_sh ],
+  [ 'multi-dax.sh',           multi_dax ],
+  [ 'btt-check.sh',           btt_check ],
+  [ 'label-compat.sh',        label_compat ],
+  [ 'sector-mode.sh',         sector_mode ],
+  [ 'inject-error.sh',        inject_error ],
+  [ 'btt-errors.sh',          btt_errors ],
+  [ 'hugetlb',                hugetlb ],
+  [ 'btt-pad-compat.sh',      btt_pad_compat ],
+  [ 'firmware-update.sh',     firmware_update ],
+  [ 'ack-shutdown-count-set', ack_shutdown_count ],
+  [ 'rescan-partitions.sh',   rescan_partitions ],
+  [ 'inject-smart.sh',        inject_smart ],
+  [ 'monitor.sh',             monitor ],
+  [ 'max_extent_ns',          max_extent ],
+  [ 'pfn-meta-errors.sh',     pfn_meta_errors ],
+  [ 'track-uuid.sh',          track_uuid ],
+]
+
+if get_option('destructive').enabled()
+  sub_section = find_program('sub-section.sh')
+  dax_ext4 = find_program('dax-ext4.sh')
+  dax_xfs = find_program('dax-xfs.sh')
+  align = find_program('align.sh')
+  device_dax_fio = find_program('device-dax-fio.sh')
+  daxctl_devices = find_program('daxctl-devices.sh')
+  daxctl_create = find_program('daxctl-create.sh')
+  dm = find_program('dm.sh')
+  mmap_test = find_program('mmap.sh')
+
+  tests += [
+    [ 'pmem-ns',           pmem_ns ],
+    [ 'sub-section.sh',    sub_section ],
+    [ 'dax-dev',           dax_dev ],
+    [ 'dax-ext4.sh',       dax_ext4 ],
+    [ 'dax-xfs.sh',        dax_xfs ],
+    [ 'align.sh',          align ],
+    [ 'device-dax',        device_dax ],
+    [ 'revoke-devmem',     revoke_devmem ],
+    [ 'device-dax-fio.sh', device_dax_fio ],
+    [ 'daxctl-devices.sh', daxctl_devices ],
+    [ 'daxctl-create.sh',  daxctl_create ],
+    [ 'dm.sh',             dm ],
+    [ 'mmap.sh',           mmap_test ],
+  ]
+endif
+
+if get_option('keyutils').enabled()
+  security = find_program('security.sh')
+  tests += [
+    [ 'security.sh', security ]
+  ]
+endif
+
+foreach t : tests
+  test(t[0], t[1],
+    is_parallel : false,
+    depends : [
+      ndctl_tool,
+      daxctl_tool,
+      cxl_tool,
+      smart_notify,
+      list_smart_dimm,
+      dax_pmd,
+      dax_errors,
+      daxdev_errors,
+      dax_dev,
+      mmap,
+    ],
+    timeout : 0,
+    env : [
+      'NDCTL=@0@'.format(ndctl_tool.full_path()),
+      'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+      'TEST_PATH=@0@'.format(meson.current_build_dir()),
+      'DATA_PATH=@0@'.format(meson.current_source_dir()),
+    ],
+  )
+endforeach
diff --git a/tools/meson-vcs-tag.sh b/tools/meson-vcs-tag.sh
new file mode 100755
index 000000000000..9f21c37b7d26
--- /dev/null
+++ b/tools/meson-vcs-tag.sh
@@ -0,0 +1,18 @@
+#!/usr/bin/env bash
+# SPDX-License-Identifier: LGPL-2.1-or-later
+
+set -eu
+set -o pipefail
+
+dir="${1:?}"
+fallback="${2:?}"
+
+# Apparently git describe has a bug where it always considers the work-tree
+# dirty when invoked with --git-dir (even though 'git status' is happy). Work
+# around this issue by cd-ing to the source directory.
+cd "$dir"
+# Check that we have either .git/ (a normal clone) or a .git file (a work-tree)
+# and that we don't get confused if a tarball is extracted in a higher-level
+# git repository.
+[ -e .git ] && git describe --abbrev=7 --dirty=+ 2>/dev/null | \
+	sed -e 's/^v//' -e 's/-/./g' || echo "$fallback"
diff --git a/util/meson.build b/util/meson.build
new file mode 100644
index 000000000000..784b27915649
--- /dev/null
+++ b/util/meson.build
@@ -0,0 +1,16 @@
+util = static_library('util', [
+  'parse-options.c',
+  'parse-configs.c',
+  'usage.c',
+  'size.c',
+  'main.c',
+  'help.c',
+  'strbuf.c',
+  'wrapper.c',
+  'bitmap.c',
+  'abspath.c',
+  'iomem.c',
+  ],
+  include_directories : root_inc,
+)
+util_dep = declare_dependency(link_with : util)
diff --git a/version.h.in b/version.h.in
new file mode 100644
index 000000000000..dedbaf95caf7
--- /dev/null
+++ b/version.h.in
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+#define VERSION "@VCS_TAG@"


