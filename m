Return-Path: <nvdimm+bounces-5496-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6E76477EB
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 22:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C2FD280C29
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 21:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221F3A46C;
	Thu,  8 Dec 2022 21:28:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51234A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534891; x=1702070891;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NoWS9D6wnTNeLKyoMLfd4hRdhlgdi4frHXHBXCJJhGk=;
  b=e573kj/YfIa0jP5aW615XUVzrIjXXuzbyLrzNPY/rbekJ88dEb6EtQBp
   ZQDJtvWE+i2953QzXWZbfaMWizWdzFeqM05jPe/qZqvmb879oMgzXuYo7
   udshJVNHA0WuB8niLFaloYkFUSmMJzgcqLVtvVfwEjHc58ui2BUCNqoU2
   /DHsOkkPkG6+3gCt84UI0rPMjdIVdfmo/ffNABnNBbLo5YuGCaM1byb+1
   O0XI/aWviUe2HDPI71RiodlLDYWlo3fPMljZl+guoHnOFQuhWlNMHkJN2
   HaLdb0DE4ndBsk/WgsXj9MIqgzGzEs4JTCArZMtVdl3zL5z+rXQxUQ0IM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458745"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458745"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976047038"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976047038"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:10 -0800
Subject: [ndctl PATCH v2 02/18] ndctl/test: Add kernel backtrace detection
 to some dax tests
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:09 -0800
Message-ID: <167053488991.582963.6703486459060296948.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

It is useful to fail a test if it triggers a backtrace. Generalize the
mechanism from test/cxl-topology.sh and add it to tests that want
to validate clean kernel logs.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/common              |   10 ++++++++++
 test/cxl-region-sysfs.sh |    4 +---
 test/cxl-topology.sh     |    5 +----
 test/dax.sh              |    2 ++
 test/daxdev-errors.sh    |    2 ++
 test/multi-dax.sh        |    2 ++
 6 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/test/common b/test/common
index 65615cc09a3e..44cc352f6009 100644
--- a/test/common
+++ b/test/common
@@ -132,3 +132,13 @@ json2var()
 {
 	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
 }
+
+# check_dmesg
+# $1: line number where this is called
+check_dmesg()
+{
+	# validate no WARN or lockdep report during the run
+	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+	grep -q "Call Trace" <<< $log && err $1
+	true
+}
diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 63186b60dfec..e128406cd8c8 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -164,8 +164,6 @@ readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
 			  jq -r ".[] | .decoder.decoder")
 echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
 
-# validate no WARN or lockdep report during the run
-log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-grep -q "Call Trace" <<< $log && err "$LINENO"
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index f7e390d22680..1f15d29f0600 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -169,9 +169,6 @@ done
 # validate that the bus can be disabled without issue
 $CXL disable-bus $root -f
 
-
-# validate no WARN or lockdep report during the run
-log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-grep -q "Call Trace" <<< $log && err "$LINENO"
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
diff --git a/test/dax.sh b/test/dax.sh
index bb9848b10ecc..3ffbc8079eba 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -118,4 +118,6 @@ else
 	run_xfs
 fi
 
+check_dmesg "$LINENO"
+
 exit 0
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 7f79718113d0..84ef93499acf 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -71,6 +71,8 @@ if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badbl
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
 
+check_dmesg "$LINENO"
+
 _cleanup
 
 exit 0
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 04070adb18e4..d471e1c96b5e 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -28,6 +28,8 @@ chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices
 json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a $ALIGN_SIZE -s 16M)
 chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
 
+check_dmesg "$LINENO"
+
 _cleanup
 
 exit 0


