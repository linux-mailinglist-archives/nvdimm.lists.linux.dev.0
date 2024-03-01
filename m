Return-Path: <nvdimm+bounces-7639-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2BC86EBEF
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Mar 2024 23:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 773972825AA
	for <lists+linux-nvdimm@lfdr.de>; Fri,  1 Mar 2024 22:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE845EE70;
	Fri,  1 Mar 2024 22:37:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1663B1AC;
	Fri,  1 Mar 2024 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332662; cv=none; b=YwtJkXBo3WNocaUuqwg3EeHj4wFs7FHF6OX9MR+NivBQUsg/IW356Oy64sLVl8m0dpLCM5QLKvhtk2nXz7danpN1ru75Zd+IJOfAPrPKLOxe/oynnvjh4oIPpkPVZCoYmpTr0Hel9ulASNhy5Ab7q3/pXbK4DJZr6TqxOQ36xSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332662; c=relaxed/simple;
	bh=vfobGTS3PRSGK/2HyUbICHQSQiKDPbUXBWgzUK2WV1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqseVp3BiPorI0bhjFprioL4xR3ngbQ6h5up217BTSpFBN7OuNSKyRRHlTCV0Y6U+0cipH+C9GTR2nevEdFpWj+GxJInkkDX9ae/luh3iASLJ7j+cUyaO1PMalDkkUtqmoeI9NeGlbyBrvOOcnCgv2aYz0CC7wH/ZM+pX+tWvyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6720CC433C7;
	Fri,  1 Mar 2024 22:37:42 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v8 4/4] ndctl: add test for qos_class in CXL test suite
Date: Fri,  1 Mar 2024 15:36:43 -0700
Message-ID: <20240301223736.1380778-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240301223736.1380778-1-dave.jiang@intel.com>
References: <20240301223736.1380778-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests in cxl-qos-class.sh to verify qos_class are set with the fake
qos_class create by the kernel.  Root decoders should have qos_class
attribute set. Memory devices should have ram_qos_class or pmem_qos_class
set depending on which partitions are valid.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v8:
- Change way to pick decoder to be consistent. (Vishal)
- Change way to read memdev qos_class. (Vishal)
- Move "done" on same line. (Vishal)
---
 test/common           |  4 ++
 test/cxl-qos-class.sh | 99 +++++++++++++++++++++++++++++++++++++++++++
 test/meson.build      |  2 +
 3 files changed, 105 insertions(+)
 create mode 100755 test/cxl-qos-class.sh

diff --git a/test/common b/test/common
index f1023ef20f7e..5694820c7adc 100644
--- a/test/common
+++ b/test/common
@@ -150,3 +150,7 @@ check_dmesg()
 	grep -q "Call Trace" <<< $log && err $1
 	true
 }
+
+
+# CXL COMMON
+TEST_QOS_CLASS=42
diff --git a/test/cxl-qos-class.sh b/test/cxl-qos-class.sh
new file mode 100755
index 000000000000..fbc0e50b7fe4
--- /dev/null
+++ b/test/cxl-qos-class.sh
@@ -0,0 +1,99 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test
+rc=1
+
+check_qos_decoders () {
+	# check root decoders have expected fake qos_class
+	# also make sure the number of root decoders equal to the number
+	# with qos_class found
+	json=$($CXL list -b cxl_test -D -d root)
+	decoders=$(echo "$json" | jq length)
+	count=0
+	while read -r qos_class; do
+		if [[ "$qos_class" != "$TEST_QOS_CLASS" ]]; then
+			err "$LINENO"
+		fi
+		count=$((count+1))
+	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
+
+	if [[ "$count" != "$decoders" ]]; then
+		err "$LINENO"
+	fi
+}
+
+check_qos_memdevs () {
+	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
+	# expected fake value programmed.
+	json=$(cxl list -b cxl_test -M)
+	ram_size=$(jq ".[] | .ram_size" <<< $json)
+	ram_qos_class=$(jq ".[] | .ram_qos_class" <<< $json)
+	pmem_size=$(jq ".[] | .pmem_size" <<< $json)
+	pmem_qos_class=$(jq ".[] | .pmem_qos_class" <<< $json)
+
+	if [[ "$ram_size" != null ]] && ((ram_qos_class != TEST_QOS_CLASS)); then
+		err "$LINENO"
+	fi
+
+	if [[ "$pmem_size" != null ]] && ((pmem_qos_class != TEST_QOS_CLASS)); then
+		err "$LINENO"
+	fi
+}
+
+# Based on cxl-create-region.sh create_single()
+destroy_regions()
+{
+	if [[ "$*" ]]; then
+		$CXL destroy-region -f -b cxl_test "$@"
+	else
+		$CXL destroy-region -f -b cxl_test all
+	fi
+}
+
+create_region_check_qos()
+{
+	# Find an x1 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r "[ .[] |
+		  select(.max_available_extent > 0) |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) ] |
+		  .[0].decoder")
+
+	# Find a memdev for this host-bridge
+	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+		    .targets | .[] | select(.position == 0) | .target")
+	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	memdevs="$mem0"
+
+	# Send create-region with -Q to enforce qos_class matching
+	region=$($CXL create-region -Q -d $decoder -m $memdevs | jq -r ".region")
+	if [[ ! $region ]]; then
+		echo "failed to create region"
+		err "$LINENO"
+	fi
+
+	destroy_regions "$region"
+}
+
+check_qos_decoders
+
+check_qos_memdevs
+
+create_region_check_qos
+
+check_dmesg "$LINEO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 5eb35749a95b..4892df11119f 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
 cxl_poison = find_program('cxl-poison.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
+cxl_qos_class = find_program('cxl-qos-class.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -192,6 +193,7 @@ tests = [
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
+  [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.43.0


