Return-Path: <nvdimm+bounces-3501-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AABD34FEF0F
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 08:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A52631C0B4A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 06:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5AC23D5;
	Wed, 13 Apr 2022 06:01:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0F223CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829699; x=1681365699;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6f5NDzNq7ZkGie/x3qcHs7RbkZ14iszEa1ADUciL4uE=;
  b=hPmcf6e4R3qKgVpJBDIhY6Iy6NURjNQv9TMWDHtMrgj6eR3ext5oebO9
   Redy3SJ8N4+XB6c7zHtY0UMfbcENzSpSspvH/1kA8Nc/hHdbK2QPUVxJa
   SA+W9mjxRBi9K9PqBIk07DctGuJHMzTwG1fE75mH9Vaka2kfnW2LKRDHz
   2ypgv1P0yXlYz+/prRPM9PoB4ebSVt2/HSZTVqsd6QVP9/XoDzCc8Z9b7
   EplvGFrM1RK0ZGBQTNaSCi7eTyZyHzEmTvUuEnQWHjXU4Ze5GE8ZJau/S
   0bZfQw8C4+GuU+lKDjAsqWm+GMuabpPMHlpN/VdrGDTjUBUo7jiPFco96
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="261430787"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="261430787"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:39 -0700
X-IronPort-AV: E=Sophos;i="5.90,255,1643702400"; 
   d="scan'208";a="559626138"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:01:38 -0700
Subject: [PATCH v2 02/12] device-core: Add dev->lock_class to enable
 device_lock() lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 vishal.l.verma@intel.com, alison.schofield@intel.com,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:01:38 -0700
Message-ID: <164982969858.684294.17819743973041389492.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The device_lock() is hidden from lockdep by default because, for
example, a device subsystem may do something like:

---
device_add(dev1);
...in driver core...
device_lock(dev1);
bus->probe(dev1); /* where bus->probe() calls driver1_probe() */

driver1_probe(struct device *dev)
{
	...do some enumeration...
	dev2->parent = dev;
	/* this triggers probe under device_lock(dev2); */
	device_add(dev2);
}
---

To lockdep, that device_lock(dev2) looks like a deadlock because lockdep
only sees lock classes, not individual lock instances. All device_lock()
instances across the entire kernel are the same class. However, this is
not a deadlock in practice because the locking is strictly hierarchical.
I.e. device_lock(dev1) is held over device_lock(dev2), but never the
reverse. In order for lockdep to be satisfied and see that it is
hierarchical in practice the mutex_lock() call in device_lock() needs to
be moved to mutex_lock_nested() where the @subclass argument to
mutex_lock_nested() represents the nesting level, i.e.:

s/device_lock(dev1)/mutex_lock_nested(&dev1->mutex, 1)/

s/device_lock(dev2)/mutex_lock_nested(&dev2->mutex, 2)/

Now, what if the internals of the device_lock() could be annotated with
the right @subclass argument to call mutex_lock_nested()?

With device_set_lock_class() a subsystem can optionally add that
metadata. The device_lock() still takes dev->mutex, but when
dev->lock_class is >= 0 it additionally takes dev->lockdep_mutex with
the proper nesting. Unlike dev->mutex, dev->lockdep_mutex is not marked
lockdep_set_novalidate_class() and lockdep will become useful... at
least for one subsystem at a time.

It is still the case that only one subsystem can be using lockdep with
lockdep_mutex at a time because different subsystems will collide class
numbers. You might say "well, how about subsystem1 gets class ids 0 to 9
and subsystem2 gets class ids 10 to 20?". MAX_LOCKDEP_SUBCLASSES is 8,
and 8 is just enough class ids for one subsystem of moderate complexity.

Fixing that problem needs deeper changes, but for now moving the ability
to set a lock class into the core lets the NVDIMM and CXL subsystems
drop their incomplete solutions which attempt to set the lock class and
take the lockdep mutex after the fact.

This approach has prevented at least one deadlock scenario from making
its way upstream that was not caught by the current "local /
after-the-fact" usage of dev->lockdep_mutex (commit 87a30e1f05d7
("driver-core, libnvdimm: Let device subsystems add local lockdep
coverage")).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/device.h |   92 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 4 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index af2576ace130..6083e757e804 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -402,6 +402,7 @@ struct dev_msi_info {
  * @mutex:	Mutex to synchronize calls to its driver.
  * @lockdep_mutex: An optional debug lock that a subsystem can use as a
  * 		peer lock to gain localized lockdep coverage of the device_lock.
+ * @lock_class: per-subsystem annotated device lock class
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
  * @platform_data: Platform data specific to the device.
@@ -501,6 +502,7 @@ struct device {
 					   dev_set_drvdata/dev_get_drvdata */
 #ifdef CONFIG_PROVE_LOCKING
 	struct mutex		lockdep_mutex;
+	int			lock_class;
 #endif
 	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
@@ -762,18 +764,100 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
 	return !!(dev->power.driver_flags & flags);
 }
 
+static inline void device_lock_assert(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+}
+
 #ifdef CONFIG_PROVE_LOCKING
 static inline void device_lockdep_init(struct device *dev)
 {
 	mutex_init(&dev->lockdep_mutex);
+	dev->lock_class = -1;
 	lockdep_set_novalidate_class(&dev->mutex);
 }
-#else
+
+static inline void device_lock(struct device *dev)
+{
+	/*
+	 * For double-lock programming errors the kernel will hang
+	 * trying to acquire @dev->mutex before lockdep can report the
+	 * problem acquiring @dev->lockdep_mutex, so manually assert
+	 * before that hang.
+	 */
+	lockdep_assert_not_held(&dev->lockdep_mutex);
+
+	mutex_lock(&dev->mutex);
+	if (dev->lock_class >= 0)
+		mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+}
+
+static inline int device_lock_interruptible(struct device *dev)
+{
+	int rc;
+
+	lockdep_assert_not_held(&dev->lockdep_mutex);
+
+	rc = mutex_lock_interruptible(&dev->mutex);
+	if (rc || dev->lock_class < 0)
+		return rc;
+
+	return mutex_lock_interruptible_nested(&dev->lockdep_mutex,
+					       dev->lock_class);
+}
+
+static inline int device_trylock(struct device *dev)
+{
+	if (mutex_trylock(&dev->mutex)) {
+		if (dev->lock_class >= 0)
+			mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
+		return 1;
+	}
+
+	return 0;
+}
+
+static inline void device_unlock(struct device *dev)
+{
+	if (dev->lock_class >= 0)
+		mutex_unlock(&dev->lockdep_mutex);
+	mutex_unlock(&dev->mutex);
+}
+
+/*
+ * Note: this routine expects that the state of @dev->mutex is stable
+ * from entry to exit. There is no support for changing lockdep
+ * validation classes, only enabling and disabling validation.
+ */
+static inline void device_set_lock_class(struct device *dev, int lock_class)
+{
+	/*
+	 * Allow for setting or clearing the lock class while the
+	 * device_lock() is held, in which case the paired nested lock
+	 * might need to be acquired or released now to accommodate the
+	 * next device_unlock().
+	 */
+	if (dev->lock_class < 0 && lock_class >= 0) {
+		/* Enabling lockdep validation... */
+		if (mutex_is_locked(&dev->mutex))
+			mutex_lock_nested(&dev->lockdep_mutex, lock_class);
+	} else if (dev->lock_class >= 0 && lock_class < 0) {
+		/* Disabling lockdep validation... */
+		if (mutex_is_locked(&dev->mutex))
+			mutex_unlock(&dev->lockdep_mutex);
+	} else {
+		dev_warn(dev,
+			 "%s: failed to change lock_class from: %d to %d\n",
+			 __func__, dev->lock_class, lock_class);
+		return;
+	}
+	dev->lock_class = lock_class;
+}
+#else /* !CONFIG_PROVE_LOCKING */
 static inline void device_lockdep_init(struct device *dev)
 {
 	lockdep_set_novalidate_class(&dev->mutex);
 }
-#endif
 
 static inline void device_lock(struct device *dev)
 {
@@ -795,10 +879,10 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
-static inline void device_lock_assert(struct device *dev)
+static inline void device_set_lock_class(struct device *dev, int lock_class)
 {
-	lockdep_assert_held(&dev->mutex);
 }
+#endif /* CONFIG_PROVE_LOCKING */
 
 static inline struct device_node *dev_of_node(struct device *dev)
 {


