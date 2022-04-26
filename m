Return-Path: <nvdimm+bounces-3723-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5055108E4
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 Apr 2022 21:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2EEE280A8D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 Apr 2022 19:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961E82CA5;
	Tue, 26 Apr 2022 19:23:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A46B7E
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651000978; x=1682536978;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CEloj/FYqmR8/A3+Jw0HM/VA7CxCHVorhGVbkZfxGUo=;
  b=WM81mFiCTaAhlKbhotV7+NcDc6JL5rQiPc3VSb8mRprKLwE9zDEy4Ljf
   FiewM/VUjoF1OUtW5MWim7P/5gxNyXbrrUrFP8dakZ/slwuvI1aChPgRf
   pRoBciLXwqh+QEJSk3wDalVl1Z4TT2h/PomuCRjzHZkvnOE51w1J0AwPJ
   ZKq1vnF6Qk1FOi/FoItDY+ZbqRqMfcuJuSyqf2NCvreiwI/bPDUAW16Cw
   WUfJBp0QEcq664765b4JmbwSqwetkT+yqXGYyfIGPNGf0+cgDygSZnlrN
   4u0wIvXjU0TbFqHfqZSwUVfxIOAAIhhNuW5rNN8AM8H7MEO044f4UeAJd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="328638189"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="328638189"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 12:22:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="558490040"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 12:22:44 -0700
Subject: [PATCH v6 2/8] cxl/acpi: Add root device lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Date: Tue, 26 Apr 2022 12:22:44 -0700
Message-ID: <165100081305.1528964.11138612430659737238.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165094691930.1127280.7077256361741497990.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165094691930.1127280.7077256361741497990.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL "root" device, ACPI0017, is an attach point for coordinating
platform level CXL resources and is the parent device for a CXL port
topology tree. As such it has distinct locking rules relative to other
CXL subsystem objects, but because it is an ACPI device the lock class
is established well before it is given to the cxl_acpi driver.

However, the lockdep API does support changing the lock class "live" for
situations like this. Add a device_lock_set_class() helper that a driver
can use in ->probe() to set a custom lock class, and
device_lock_reset_class() to return to the default "no validate" class
before the custom lock class key goes out of scope after ->remove().

Note the helpers are all macros to support dead code elimination in the
CONFIG_PROVE_LOCKING=n case, however device_set_lock_class() still needs
#ifdef CONFIG_PROVE_LOCKING since lockdep_match_class() explicitly does
not have a helper in the CONFIG_PROVE_LOCKING=n case (see comment in
lockdep.h). The lockdep API needs 2 small tweaks to prevent "unused"
warnings for the @key argument to lock_set_class(), and a new
lock_set_novalidate_class() is added to supplement
lockdep_set_novalidate_class() in the cases where the lock class is
converted while the lock is held.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v5:
- 0day reports [1] that clang does not like how the macros shadow the
  definition of the @__d variable. Move __device_lock_set_class() to a
  unique variable name. Note that the variable is needed as some macro
  callers may pass a 'void *' to device_set_lock_class().

[1]: https://lore.kernel.org/all/202204261758.lzXWne7H-lkp@intel.com/

 drivers/cxl/acpi.c      |   13 +++++++++++++
 include/linux/device.h  |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/lockdep.h |    6 +++++-
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d15a6aec0331..40286f5df812 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -275,6 +275,13 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
 	return 1;
 }
 
+static struct lock_class_key cxl_root_key;
+
+static void cxl_acpi_lock_reset_class(void *dev)
+{
+	device_lock_reset_class(dev);
+}
+
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -283,6 +290,12 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
+	device_lock_set_class(&pdev->dev, &cxl_root_key);
+	rc = devm_add_action_or_reset(&pdev->dev, cxl_acpi_lock_reset_class,
+				      &pdev->dev);
+	if (rc)
+		return rc;
+
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/include/linux/device.h b/include/linux/device.h
index 93459724dcde..833b0b3b0193 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -850,6 +850,49 @@ static inline bool device_supports_offline(struct device *dev)
 	return dev->bus && dev->bus->offline && dev->bus->online;
 }
 
+#define __device_lock_set_class(dev, name, key)                        \
+do {                                                                   \
+	struct device *__d2 __maybe_unused = dev;                      \
+	lock_set_class(&__d2->mutex.dep_map, name, key, 0, _THIS_IP_); \
+} while (0)
+
+/**
+ * device_lock_set_class - Specify a temporary lock class while a device
+ *			   is attached to a driver
+ * @dev: device to modify
+ * @key: lock class key data
+ *
+ * This must be called with the device_lock() already held, for example
+ * from driver ->probe(). Take care to only override the default
+ * lockdep_no_validate class.
+ */
+#ifdef CONFIG_LOCKDEP
+#define device_lock_set_class(dev, key)                                    \
+do {                                                                       \
+	struct device *__d = dev;                                          \
+	dev_WARN_ONCE(__d, !lockdep_match_class(&__d->mutex,               \
+						&__lockdep_no_validate__), \
+		 "overriding existing custom lock class\n");               \
+	__device_lock_set_class(__d, #key, key);                           \
+} while (0)
+#else
+#define device_lock_set_class(dev, key) __device_lock_set_class(dev, #key, key)
+#endif
+
+/**
+ * device_lock_reset_class - Return a device to the default lockdep novalidate state
+ * @dev: device to modify
+ *
+ * This must be called with the device_lock() already held, for example
+ * from driver ->remove().
+ */
+#define device_lock_reset_class(dev) \
+do { \
+	struct device *__d __maybe_unused = dev;                       \
+	lock_set_novalidate_class(&__d->mutex.dep_map, "&dev->mutex",  \
+				  _THIS_IP_);                          \
+} while (0)
+
 void lock_device_hotplug(void);
 void unlock_device_hotplug(void);
 int lock_device_hotplug_sysfs(void);
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 467b94257105..43b0dc6a0b21 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -290,6 +290,9 @@ extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
 			   unsigned long ip);
 
+#define lock_set_novalidate_class(l, n, i) \
+	lock_set_class(l, n, &__lockdep_no_validate__, 0, i)
+
 static inline void lock_set_subclass(struct lockdep_map *lock,
 		unsigned int subclass, unsigned long ip)
 {
@@ -357,7 +360,8 @@ static inline void lockdep_set_selftest_task(struct task_struct *task)
 # define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, i)			do { } while (0)
 # define lock_downgrade(l, i)			do { } while (0)
-# define lock_set_class(l, n, k, s, i)		do { } while (0)
+# define lock_set_class(l, n, key, s, i)	do { (void)(key); } while (0)
+# define lock_set_novalidate_class(l, n, i)	do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_init_map_type(lock, name, key, sub, inner, outer, type) \


