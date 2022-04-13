Return-Path: <nvdimm+bounces-3512-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 122DB4FEF1F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 08:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id C748D3E106D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 06:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A313428E4;
	Wed, 13 Apr 2022 06:02:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA566258C
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829753; x=1681365753;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0j1hA1fWHoFpMRJXA9DIC9aEvgsqA/8Z+smjBQbu3OM=;
  b=JRySiH4g/fTOmv2o5s0/5rCYeaZxHwrPQEQ1lUArfj5x0yfa4qWHRVlT
   mdb0lHB7wlK9Z5QE6YW+DDpLawP+lbB/mZ1cOaahTzN1Jl+QJfOvug7oY
   Ez31iF8YcBHy8eSBSuDVW7TV4mXElAtgHLN93A6i0+qWMEzZtldY7cR+M
   dEYy0f2oo+ZGkewd/TLAF/bRJhb3NBbDl5umqoa0Qc/6edZLC3vd9sUBu
   v06bBSgMeAPigFqAvPXI55jaOy358oWSpUs1e4vG29UfJGyYO7fni2xyU
   Q8Y4xQhn9qIY9NBq2/Gh6+lgWTaDWUTr5c6OrKN6ZEhGJLlmQERteXwS3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="261430984"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="261430984"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="611754268"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:32 -0700
Subject: [PATCH v2 12/12] device-core: Enable multi-subsystem device_lock()
 lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:31 -0700
Message-ID: <164982975184.684294.8587689380766181427.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

While device_set_lock_class() allows device_lock() to take a nested lock
per the requirements of a given subsystem, it does not allow multiple
subsystems to enable lockdep validation at the same time. For example if
CXL does:

device_set_lock_class(&cxlmd->dev, 1);

...and LIBNVDIMM does:

device_set_lock_class(&nvdimm->dev, 1);

...lockdep will treat those as identical locks and flag false positive
reports depending on how those 2 subsystems interact. Given that there
are not enough available lock class ids for each subsystem to own a
slice of the number space, the only other way for lockdep to see that
those are different locks is to literally make them different locks.

Update device_set_lock_class() to also take a subsystem id which also
acts as an index into a new array of lockdep_mutex instances. So now CXL
and NVDIMM can do:

device_set_lock_class(&cxlmd->dev, DEVICE_LOCK_CXL, 1);
device_set_lock_class(&nvdimm->dev, DEVICE_LOCK_NVDIMM, 1);

...and lockdep will manage their dependency chains individually per
expectations.

Note that the reason the mutex_init() for the various subsystem
device-locks is unrolled in device_lockdep_init(), vs a loop over [0 ..
DEVICE_LOCK_MAX], is to give each lock a unique @lock_class_key and name
in reports. While the approach is not elegant, and requires manual
enabling, it seems the best that can be done given lockdep's
expectations. Otherwise this validation has already proven useful in
keeping device_lock() deadlocks from landing upstream.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c       |    2 -
 drivers/cxl/cxl.h        |    4 +-
 drivers/cxl/port.c       |    2 -
 drivers/nvdimm/nd-core.h |    5 +-
 include/linux/device.h   |   95 ++++++++++++++++++++++++++++++++++++----------
 lib/Kconfig.debug        |   24 ------------
 6 files changed, 82 insertions(+), 50 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index ef5c3252bdb2..ed2fdb45b424 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -283,7 +283,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
-	device_set_lock_class(&pdev->dev, CXL_ROOT_LOCK);
+	device_set_lock_class(&pdev->dev, DEVICE_LOCK_CXL, CXL_ROOT_LOCK);
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 05dc4c081ad2..2528d4ab2e74 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -423,7 +423,7 @@ enum cxl_lock_class {
 	 */
 };
 
-#ifdef CONFIG_PROVE_CXL_LOCKING
+#ifdef CONFIG_PROVE_LOCKING
 static inline int clamp_lock_class(struct device *dev, int lock_class)
 {
 	if (lock_class >= MAX_LOCKDEP_SUBCLASSES) {
@@ -460,7 +460,7 @@ static inline int cxl_lock_class(struct device *dev)
 
 static inline void cxl_set_lock_class(struct device *dev)
 {
-	device_set_lock_class(dev, cxl_lock_class(dev));
+	device_set_lock_class(dev, DEVICE_LOCK_CXL, cxl_lock_class(dev));
 }
 #else
 static inline void cxl_set_lock_class(struct device *dev)
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index d420da5fc39c..493a195a9f5a 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -17,7 +17,7 @@
  * firmware) are managed in this drivers context. Each driver instance
  * is responsible for tearing down the driver context of immediate
  * descendant ports. The locking for this is validated by
- * CONFIG_PROVE_CXL_LOCKING.
+ * CONFIG_PROVE_LOCKING.
  *
  * The primary service this driver provides is presenting APIs to other
  * drivers to utilize the decoders, and indicating to userspace (via bind
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 75892e43b2c9..56a2e56e552b 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -162,7 +162,7 @@ static inline void devm_nsio_disable(struct device *dev,
 }
 #endif
 
-#ifdef CONFIG_PROVE_NVDIMM_LOCKING
+#ifdef CONFIG_PROVE_LOCKING
 extern struct class *nd_class;
 
 enum {
@@ -194,7 +194,8 @@ static inline int nvdimm_lock_class(struct device *dev)
 
 static inline void nvdimm_set_lock_class(struct device *dev)
 {
-	device_set_lock_class(dev, nvdimm_lock_class(dev));
+	device_set_lock_class(dev, DEVICE_LOCK_NVDIMM,
+			      nvdimm_lock_class(dev));
 }
 #else
 static inline void nvdimm_set_lock_class(struct device *dev)
diff --git a/include/linux/device.h b/include/linux/device.h
index 6083e757e804..12c675edb28d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -386,6 +386,17 @@ struct dev_msi_info {
 #endif
 };
 
+enum device_lock_subsys {
+	DEVICE_LOCK_NONE = -1,
+#if IS_ENABLED(CONFIG_LIBNVDIMM)
+	DEVICE_LOCK_NVDIMM,
+#endif
+#if IS_ENABLED(CONFIG_CXL_BUS)
+	DEVICE_LOCK_CXL,
+#endif
+	DEVICE_LOCK_MAX,
+};
+
 /**
  * struct device - The basic device structure
  * @parent:	The device's "parent" device, the device to which it is attached.
@@ -400,8 +411,8 @@ struct dev_msi_info {
  * 		This identifies the device type and carries type-specific
  * 		information.
  * @mutex:	Mutex to synchronize calls to its driver.
- * @lockdep_mutex: An optional debug lock that a subsystem can use as a
- * 		peer lock to gain localized lockdep coverage of the device_lock.
+ * @lockdep_mutex: A set of optional debug locks that subsystems can use as a
+ *		peer lock to @mutex to gain lockdep coverage of device_lock().
  * @lock_class: per-subsystem annotated device lock class
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
@@ -501,8 +512,9 @@ struct device {
 	void		*driver_data;	/* Driver data, set and get with
 					   dev_set_drvdata/dev_get_drvdata */
 #ifdef CONFIG_PROVE_LOCKING
-	struct mutex		lockdep_mutex;
+	struct mutex		lockdep_mutex[DEVICE_LOCK_MAX];
 	int			lock_class;
+	enum device_lock_subsys	lock_subsys;
 #endif
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
@@ -772,45 +784,77 @@ static inline void device_lock_assert(struct device *dev)
 #ifdef CONFIG_PROVE_LOCKING
 static inline void device_lockdep_init(struct device *dev)
 {
-	mutex_init(&dev->lockdep_mutex);
+#if IS_ENABLED(CONFIG_CXL_BUS)
+	mutex_init(&dev->lockdep_mutex[DEVICE_LOCK_CXL]);
+#endif
+#if IS_ENABLED(CONFIG_LIBNVDIMM)
+	mutex_init(&dev->lockdep_mutex[DEVICE_LOCK_NVDIMM]);
+#endif
+	dev->lock_subsys = DEVICE_LOCK_NONE;
 	dev->lock_class = -1;
 	lockdep_set_novalidate_class(&dev->mutex);
 }
 
+static inline bool subsys_valid(enum device_lock_subsys subsys)
+{
+	if (DEVICE_LOCK_MAX == 0)
+		return false;
+	if (subsys <= DEVICE_LOCK_NONE)
+		return false;
+	if (subsys >= DEVICE_LOCK_MAX)
+		return false;
+	return true;
+}
+
+static inline struct mutex *device_lockdep_mutex(struct device *dev)
+{
+	if (!subsys_valid(dev->lock_subsys))
+		return NULL;
+	if (dev->lock_class < 0)
+		return NULL;
+	return &dev->lockdep_mutex[dev->lock_subsys];
+}
+
 static inline void device_lock(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
 	/*
 	 * For double-lock programming errors the kernel will hang
 	 * trying to acquire @dev->mutex before lockdep can report the
-	 * problem acquiring @dev->lockdep_mutex, so manually assert
-	 * before that hang.
+	 * problem acquiring @lockdep_mutex, so manually assert before
+	 * that hang.
 	 */
-	lockdep_assert_not_held(&dev->lockdep_mutex);
+	if (lockdep_mutex)
+		lockdep_assert_not_held(lockdep_mutex);
 
 	mutex_lock(&dev->mutex);
-	if (dev->lock_class >= 0)
-		mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+	if (lockdep_mutex)
+		mutex_lock_nested(lockdep_mutex, dev->lock_class);
 }
 
 static inline int device_lock_interruptible(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
 	int rc;
 
-	lockdep_assert_not_held(&dev->lockdep_mutex);
+	if (lockdep_mutex)
+		lockdep_assert_not_held(lockdep_mutex);
 
 	rc = mutex_lock_interruptible(&dev->mutex);
-	if (rc || dev->lock_class < 0)
+	if (rc || !lockdep_mutex)
 		return rc;
 
-	return mutex_lock_interruptible_nested(&dev->lockdep_mutex,
-					       dev->lock_class);
+	return mutex_lock_interruptible_nested(lockdep_mutex, dev->lock_class);
 }
 
 static inline int device_trylock(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
 	if (mutex_trylock(&dev->mutex)) {
-		if (dev->lock_class >= 0)
-			mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+		if (lockdep_mutex)
+			mutex_lock_nested(lockdep_mutex, dev->lock_class);
 		return 1;
 	}
 
@@ -819,8 +863,10 @@ static inline int device_trylock(struct device *dev)
 
 static inline void device_unlock(struct device *dev)
 {
+	struct mutex *lockdep_mutex = device_lockdep_mutex(dev);
+
 	if (dev->lock_class >= 0)
-		mutex_unlock(&dev->lockdep_mutex);
+		mutex_unlock(lockdep_mutex);
 	mutex_unlock(&dev->mutex);
 }
 
@@ -829,8 +875,13 @@ static inline void device_unlock(struct device *dev)
  * from entry to exit. There is no support for changing lockdep
  * validation classes, only enabling and disabling validation.
  */
-static inline void device_set_lock_class(struct device *dev, int lock_class)
+static inline void device_set_lock_class(struct device *dev,
+					 enum device_lock_subsys subsys,
+					 int lock_class)
 {
+	if (!subsys_valid(subsys))
+		return;
+
 	/*
 	 * Allow for setting or clearing the lock class while the
 	 * device_lock() is held, in which case the paired nested lock
@@ -840,11 +891,12 @@ static inline void device_set_lock_class(struct device *dev, int lock_class)
 	if (dev->lock_class < 0 && lock_class >= 0) {
 		/* Enabling lockdep validation... */
 		if (mutex_is_locked(&dev->mutex))
-			mutex_lock_nested(&dev->lockdep_mutex, lock_class);
+			mutex_lock_nested(&dev->lockdep_mutex[subsys],
+					  lock_class);
 	} else if (dev->lock_class >= 0 && lock_class < 0) {
 		/* Disabling lockdep validation... */
 		if (mutex_is_locked(&dev->mutex))
-			mutex_unlock(&dev->lockdep_mutex);
+			mutex_unlock(&dev->lockdep_mutex[subsys]);
 	} else {
 		dev_warn(dev,
 			 "%s: failed to change lock_class from: %d to %d\n",
@@ -852,6 +904,7 @@ static inline void device_set_lock_class(struct device *dev, int lock_class)
 		return;
 	}
 	dev->lock_class = lock_class;
+	dev->lock_subsys = subsys;
 }
 #else /* !CONFIG_PROVE_LOCKING */
 static inline void device_lockdep_init(struct device *dev)
@@ -879,7 +932,9 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
-static inline void device_set_lock_class(struct device *dev, int lock_class)
+static inline void device_set_lock_class(struct device *dev,
+					 enum device_lock_subsys subssys,
+					 int lock_class)
 {
 }
 #endif /* CONFIG_PROVE_LOCKING */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1f8db59bdddd..cfe3b092c31d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1544,30 +1544,6 @@ config CSD_LOCK_WAIT_DEBUG
 	  include the IPI handler function currently executing (if any)
 	  and relevant stack traces.
 
-choice
-	prompt "Lock debugging: prove subsystem device_lock() correctness"
-	depends on PROVE_LOCKING
-	help
-	  For subsystems that have instrumented their usage of the device_lock()
-	  with nested annotations, enable lock dependency checking. The locking
-	  hierarchy 'subclass' identifiers are not compatible across
-	  sub-systems, so only one can be enabled at a time.
-
-config PROVE_NVDIMM_LOCKING
-	bool "NVDIMM"
-	depends on LIBNVDIMM
-	help
-	  Enable lockdep to validate libnvdimm subsystem usage of the
-	  device lock.
-
-config PROVE_CXL_LOCKING
-	bool "CXL"
-	depends on CXL_BUS
-	help
-	  Enable lockdep to validate CXL subsystem usage of the device lock.
-
-endchoice
-
 endmenu # lock debugging
 
 config TRACE_IRQFLAGS


