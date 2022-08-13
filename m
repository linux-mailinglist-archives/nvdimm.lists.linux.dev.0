Return-Path: <nvdimm+bounces-4524-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3047F591CE6
	for <lists+linux-nvdimm@lfdr.de>; Sun, 14 Aug 2022 00:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E998280C34
	for <lists+linux-nvdimm@lfdr.de>; Sat, 13 Aug 2022 22:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136B433CD;
	Sat, 13 Aug 2022 22:00:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6F928F5;
	Sat, 13 Aug 2022 22:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660428042; x=1691964042;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J2stkkYmPik2bQMds1PPTKQFWYY4K6w3/+pjsawBn4I=;
  b=HJqLse1iEyD+5ycn8xeBxUfR3BBfNyCk6Xh7fHhgFL1iIplNCsxI6FZo
   Fj1sNlfHXvd0fivsBEeIDGDpRyUpocibZ0UdSTHNmy4oyRBadNISbeboY
   nPzfoG0zOcSUn3/n+StXVaXEb0RzwGCs23jgzzsaQqHqC7ChEgHW9qq4r
   RJ05ApwRCbTPIgwiYukZhXIm2Z9INJEvXDJ5uL/VvpZ5EzvyyxKjAoWN7
   BTSDE7fyHRDiSOo544h5bB6M7OvgH9gH5hjCrJdOz9HubEhrhzRBCayVd
   MJhNAe36NHXfCZw5EQf1vZjbtmzJKJbghjdcZVZ0DV0ul/Ot5tah1ocYn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="292575221"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="292575221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2022 15:00:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="635047705"
Received: from tsaiyinl-mobl1.amr.corp.intel.com (HELO localhost) ([10.209.125.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2022 15:00:40 -0700
From: ira.weiny@intel.com
To: Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org,
	linux-xtensa@linux-xtensa.org,
	keyrings@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	dri-devel@lists.freedesktop.org,
	dm-devel@redhat.com,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	netdev@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	iommu@lists.linux.dev,
	bpf@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] checkpatch: Add kmap and kmap_atomic to the deprecated list
Date: Sat, 13 Aug 2022 15:00:34 -0700
Message-Id: <20220813220034.806698-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead
as mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when
the kmap’s pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

kmap_local_page() is safe from any context and is therefore redundant
with kmap_atomic() with the exception of any pagefault or preemption
disable requirements.  However, using kmap_atomic() for these side
effects makes the code less clear.  So any requirement for pagefault or
preemption disable should be made explicitly.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts).
It is faster than kmap() in kernels with HIGHMEM enabled. Furthermore,
the tasks can be preempted and, when they are scheduled to run again,
the kernel virtual addresses are restored.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Suggested by credits.
	Thomas: Idea to keep from growing more kmap/kmap_atomic calls.
	Fabio: Stole some of his boiler plate commit message.

Notes on tree-wide conversions:

I've cc'ed mailing lists for subsystems which currently contains either kmap()
or kmap_atomic() calls.  As some of you already know Fabio and I have been
working through converting kmap() calls to kmap_local_page().  But there is a
lot more work to be done.  Help from the community is always welcome,
especially with kmap_atomic() conversions.  To keep from stepping on each
others toes I've created a spreadsheet of the current calls[1].  Please let me
or Fabio know if you plan on tacking one of the conversions so we can mark it
off the list.

[1] https://docs.google.com/spreadsheets/d/1i_ckZ10p90bH_CkxD2bYNi05S2Qz84E2OFPv8zq__0w/edit#gid=1679714357

---
 scripts/checkpatch.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 79e759aac543..9ff219e0a9d5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -807,6 +807,8 @@ our %deprecated_apis = (
 	"rcu_barrier_sched"			=> "rcu_barrier",
 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
+	"kmap"					=> "kmap_local_page",
+	"kmap_atomic"				=> "kmap_local_page",
 );
 
 #Create a search pattern for all these strings to speed up a loop below

base-commit: 4a9350597aff50bbd0f4b80ccf49d2e02d1111f5
-- 
2.35.3


