Return-Path: <nvdimm+bounces-387-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id F28A33BDA83
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 17:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 8232C3E106E
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 15:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A5A2F80;
	Tue,  6 Jul 2021 15:50:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE2168
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 15:50:53 +0000 (UTC)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1m0nLI-0007mc-4r; Tue, 06 Jul 2021 17:50:36 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1m0nL6-0005Sx-So; Tue, 06 Jul 2021 17:50:25 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel@pengutronix.de,
	Cornelia Huck <cohuck@redhat.com>,
	linux-kernel@vger.kernel.org,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Geoff Levand <geoff@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Wu Hao <hao.wu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Stephen Hemminger <sthemmin@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	Johannes Thumshirn <morbidrsa@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jon Mason <jdmason@kudzu.us>,
	Allen Hubbe <allenbh@gmail.com>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <mgross@linux.intel.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thorsten Scherer <t.scherer@eckelmann.de>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Michael Buesch <m@bues.ch>,
	Sven Van Asbroeck <TheSven73@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Andreas Noever <andreas.noever@gmail.com>,
	Michael Jamet <michael.jamet@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Martyn Welch <martyn@welchs.me.uk>,
	Manohar Vanga <manohar.vanga@gmail.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Marc Zyngier <maz@kernel.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Samuel Holland <samuel@sholland.org>,
	Qinglang Miao <miaoqinglang@huawei.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Joey Pabalan <jpabalanb@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <lznuaa@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	David Woodhouse <dwmw@amazon.co.uk>,
	SeongJae Park <sjpark@amazon.de>,
	Julien Grall <jgrall@amazon.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-acpi@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dmaengine@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	linux-fpga@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-i3c@lists.infradead.org,
	industrypack-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-ntb@googlegroups.com,
	linux-pci@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	alsa-devel@alsa-project.org,
	linux-arm-msm@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-staging@lists.linux.dev,
	greybus-dev@lists.linaro.org,
	target-devel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-serial@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH v2 4/4] bus: Make remove callback return void
Date: Tue,  6 Jul 2021 17:48:03 +0200
Message-Id: <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev

The driver core ignores the return value of this callback because there
is only little it can do when a device disappears.

This is the final bit of a long lasting cleanup quest where several
buses were converted to also return void from their remove callback.
Additionally some resource leaks were fixed that were caused by drivers
returning an error code in the expectation that the driver won't go
away.

With struct bus_type::remove returning void it's prevented that newly
implemented buses return an ignored error code and so don't anticipate
wrong expectations for driver authors.

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk> (For ARM, Amba and related parts)
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Chen-Yu Tsai <wens@csie.org> (for drivers/bus/sunxi-rsb.c)
Acked-by: Pali Rohár <pali@kernel.org>
Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org> (for drivers/media)
Acked-by: Hans de Goede <hdegoede@redhat.com> (For drivers/platform)
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-By: Vinod Koul <vkoul@kernel.org>
Acked-by: Juergen Gross <jgross@suse.com> (For Xen)
Acked-by: Lee Jones <lee.jones@linaro.org> (For drivers/mfd)
Acked-by: Johannes Thumshirn <jth@kernel.org> (For drivers/mcb)
Acked-by: Johan Hovold <johan@kernel.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org> (For drivers/slimbus)
Acked-by: Kirti Wankhede <kwankhede@nvidia.com> (For drivers/vfio)
Acked-by: Maximilian Luz <luzmaximilian@gmail.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com> (For ulpi and typec)
Acked-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com> (For ipack)
Reviewed-by: Tom Rix <trix@redhat.com> (For fpga)
Acked-by: Geoff Levand <geoff@infradead.org> (For ps3)
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---

 arch/arm/common/locomo.c                  | 3 +--
 arch/arm/common/sa1111.c                  | 4 +---
 arch/arm/mach-rpc/ecard.c                 | 4 +---
 arch/mips/sgi-ip22/ip22-gio.c             | 3 +--
 arch/parisc/kernel/drivers.c              | 5 ++---
 arch/powerpc/platforms/ps3/system-bus.c   | 3 +--
 arch/powerpc/platforms/pseries/ibmebus.c  | 3 +--
 arch/powerpc/platforms/pseries/vio.c      | 3 +--
 drivers/acpi/bus.c                        | 3 +--
 drivers/amba/bus.c                        | 4 +---
 drivers/base/auxiliary.c                  | 4 +---
 drivers/base/isa.c                        | 4 +---
 drivers/base/platform.c                   | 4 +---
 drivers/bcma/main.c                       | 6 ++----
 drivers/bus/sunxi-rsb.c                   | 4 +---
 drivers/cxl/core.c                        | 3 +--
 drivers/dax/bus.c                         | 4 +---
 drivers/dma/idxd/sysfs.c                  | 4 +---
 drivers/firewire/core-device.c            | 4 +---
 drivers/firmware/arm_scmi/bus.c           | 4 +---
 drivers/firmware/google/coreboot_table.c  | 4 +---
 drivers/fpga/dfl.c                        | 4 +---
 drivers/hid/hid-core.c                    | 4 +---
 drivers/hid/intel-ish-hid/ishtp/bus.c     | 4 +---
 drivers/hv/vmbus_drv.c                    | 5 +----
 drivers/hwtracing/intel_th/core.c         | 4 +---
 drivers/i2c/i2c-core-base.c               | 5 +----
 drivers/i3c/master.c                      | 4 +---
 drivers/input/gameport/gameport.c         | 3 +--
 drivers/input/serio/serio.c               | 3 +--
 drivers/ipack/ipack.c                     | 4 +---
 drivers/macintosh/macio_asic.c            | 4 +---
 drivers/mcb/mcb-core.c                    | 4 +---
 drivers/media/pci/bt8xx/bttv-gpio.c       | 3 +--
 drivers/memstick/core/memstick.c          | 3 +--
 drivers/mfd/mcp-core.c                    | 3 +--
 drivers/misc/mei/bus.c                    | 4 +---
 drivers/misc/tifm_core.c                  | 3 +--
 drivers/mmc/core/bus.c                    | 4 +---
 drivers/mmc/core/sdio_bus.c               | 4 +---
 drivers/net/netdevsim/bus.c               | 3 +--
 drivers/ntb/core.c                        | 4 +---
 drivers/ntb/ntb_transport.c               | 4 +---
 drivers/nvdimm/bus.c                      | 3 +--
 drivers/pci/endpoint/pci-epf-core.c       | 4 +---
 drivers/pci/pci-driver.c                  | 3 +--
 drivers/pcmcia/ds.c                       | 4 +---
 drivers/platform/surface/aggregator/bus.c | 4 +---
 drivers/platform/x86/wmi.c                | 4 +---
 drivers/pnp/driver.c                      | 3 +--
 drivers/rapidio/rio-driver.c              | 4 +---
 drivers/rpmsg/rpmsg_core.c                | 4 +---
 drivers/s390/cio/ccwgroup.c               | 4 +---
 drivers/s390/cio/css.c                    | 4 +---
 drivers/s390/cio/device.c                 | 4 +---
 drivers/s390/cio/scm.c                    | 4 +---
 drivers/s390/crypto/ap_bus.c              | 4 +---
 drivers/scsi/scsi_debug.c                 | 3 +--
 drivers/siox/siox-core.c                  | 4 +---
 drivers/slimbus/core.c                    | 4 +---
 drivers/soc/qcom/apr.c                    | 4 +---
 drivers/spi/spi.c                         | 4 +---
 drivers/spmi/spmi.c                       | 3 +--
 drivers/ssb/main.c                        | 4 +---
 drivers/staging/fieldbus/anybuss/host.c   | 4 +---
 drivers/staging/greybus/gbphy.c           | 4 +---
 drivers/target/loopback/tcm_loop.c        | 5 ++---
 drivers/thunderbolt/domain.c              | 4 +---
 drivers/tty/serdev/core.c                 | 4 +---
 drivers/usb/common/ulpi.c                 | 4 +---
 drivers/usb/serial/bus.c                  | 4 +---
 drivers/usb/typec/bus.c                   | 4 +---
 drivers/vdpa/vdpa.c                       | 4 +---
 drivers/vfio/mdev/mdev_driver.c           | 4 +---
 drivers/virtio/virtio.c                   | 3 +--
 drivers/vme/vme.c                         | 4 +---
 drivers/xen/xenbus/xenbus.h               | 2 +-
 drivers/xen/xenbus/xenbus_probe.c         | 4 +---
 include/linux/device/bus.h                | 2 +-
 sound/aoa/soundbus/core.c                 | 4 +---
 80 files changed, 83 insertions(+), 219 deletions(-)

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index e45f4e4e06b6..24d21ba63030 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -834,14 +834,13 @@ static int locomo_bus_probe(struct device *dev)
 	return ret;
 }
 
-static int locomo_bus_remove(struct device *dev)
+static void locomo_bus_remove(struct device *dev)
 {
 	struct locomo_dev *ldev = LOCOMO_DEV(dev);
 	struct locomo_driver *drv = LOCOMO_DRV(dev->driver);
 
 	if (drv->remove)
 		drv->remove(ldev);
-	return 0;
 }
 
 struct bus_type locomo_bus_type = {
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index ff5e0d04cb89..092a2ebc0c28 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -1364,15 +1364,13 @@ static int sa1111_bus_probe(struct device *dev)
 	return ret;
 }
 
-static int sa1111_bus_remove(struct device *dev)
+static void sa1111_bus_remove(struct device *dev)
 {
 	struct sa1111_dev *sadev = to_sa1111_device(dev);
 	struct sa1111_driver *drv = SA1111_DRV(dev->driver);
 
 	if (drv->remove)
 		drv->remove(sadev);
-
-	return 0;
 }
 
 struct bus_type sa1111_bus_type = {
diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index 827b50f1c73e..53813f9464a2 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -1052,7 +1052,7 @@ static int ecard_drv_probe(struct device *dev)
 	return ret;
 }
 
-static int ecard_drv_remove(struct device *dev)
+static void ecard_drv_remove(struct device *dev)
 {
 	struct expansion_card *ec = ECARD_DEV(dev);
 	struct ecard_driver *drv = ECARD_DRV(dev->driver);
@@ -1067,8 +1067,6 @@ static int ecard_drv_remove(struct device *dev)
 	ec->ops = &ecard_default_ops;
 	barrier();
 	ec->irq_data = NULL;
-
-	return 0;
 }
 
 /*
diff --git a/arch/mips/sgi-ip22/ip22-gio.c b/arch/mips/sgi-ip22/ip22-gio.c
index de0768a49ee8..dfc52f661ad0 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -143,14 +143,13 @@ static int gio_device_probe(struct device *dev)
 	return error;
 }
 
-static int gio_device_remove(struct device *dev)
+static void gio_device_remove(struct device *dev)
 {
 	struct gio_device *gio_dev = to_gio_device(dev);
 	struct gio_driver *drv = to_gio_driver(dev->driver);
 
 	if (dev->driver && drv->remove)
 		drv->remove(gio_dev);
-	return 0;
 }
 
 static void gio_device_shutdown(struct device *dev)
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 80fa0650736b..776d624a7207 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -133,14 +133,13 @@ static int parisc_driver_probe(struct device *dev)
 	return rc;
 }
 
-static int __exit parisc_driver_remove(struct device *dev)
+static void __exit parisc_driver_remove(struct device *dev)
 {
 	struct parisc_device *pa_dev = to_parisc_device(dev);
 	struct parisc_driver *pa_drv = to_parisc_driver(dev->driver);
+
 	if (pa_drv->remove)
 		pa_drv->remove(pa_dev);
-
-	return 0;
 }
 	
 
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 1a5665875165..cc5774c64fae 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -381,7 +381,7 @@ static int ps3_system_bus_probe(struct device *_dev)
 	return result;
 }
 
-static int ps3_system_bus_remove(struct device *_dev)
+static void ps3_system_bus_remove(struct device *_dev)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	struct ps3_system_bus_driver *drv;
@@ -399,7 +399,6 @@ static int ps3_system_bus_remove(struct device *_dev)
 			__func__, __LINE__, drv->core.name);
 
 	pr_debug(" <- %s:%d: %s\n", __func__, __LINE__, dev_name(&dev->core));
-	return 0;
 }
 
 static void ps3_system_bus_shutdown(struct device *_dev)
diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index c6c79ef55e13..7ee3ed7d6cc2 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -366,14 +366,13 @@ static int ibmebus_bus_device_probe(struct device *dev)
 	return error;
 }
 
-static int ibmebus_bus_device_remove(struct device *dev)
+static void ibmebus_bus_device_remove(struct device *dev)
 {
 	struct platform_device *of_dev = to_platform_device(dev);
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 
 	if (dev->driver && drv->remove)
 		drv->remove(of_dev);
-	return 0;
 }
 
 static void ibmebus_bus_device_shutdown(struct device *dev)
diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index e00f3725ec96..58283cecbd52 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1257,7 +1257,7 @@ static int vio_bus_probe(struct device *dev)
 }
 
 /* convert from struct device to struct vio_dev and pass to driver. */
-static int vio_bus_remove(struct device *dev)
+static void vio_bus_remove(struct device *dev)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct vio_driver *viodrv = to_vio_driver(dev->driver);
@@ -1276,7 +1276,6 @@ static int vio_bus_remove(struct device *dev)
 		vio_cmo_bus_remove(viodev);
 
 	put_device(devptr);
-	return 0;
 }
 
 static void vio_bus_shutdown(struct device *dev)
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ee24246d88fd..51f374e42869 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1018,7 +1018,7 @@ static int acpi_device_probe(struct device *dev)
 	return 0;
 }
 
-static int acpi_device_remove(struct device *dev)
+static void acpi_device_remove(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = acpi_dev->driver;
@@ -1033,7 +1033,6 @@ static int acpi_device_remove(struct device *dev)
 	acpi_dev->driver_data = NULL;
 
 	put_device(dev);
-	return 0;
 }
 
 struct bus_type acpi_bus_type = {
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 939ca220bf78..962041148482 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -219,7 +219,7 @@ static int amba_probe(struct device *dev)
 	return ret;
 }
 
-static int amba_remove(struct device *dev)
+static void amba_remove(struct device *dev)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
 	struct amba_driver *drv = to_amba_driver(dev->driver);
@@ -236,8 +236,6 @@ static int amba_remove(struct device *dev)
 
 	amba_put_disable_pclk(pcdev);
 	dev_pm_domain_detach(dev, true);
-
-	return 0;
 }
 
 static void amba_shutdown(struct device *dev)
diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index adc199dfba3c..0c86f5bed9f4 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -79,7 +79,7 @@ static int auxiliary_bus_probe(struct device *dev)
 	return ret;
 }
 
-static int auxiliary_bus_remove(struct device *dev)
+static void auxiliary_bus_remove(struct device *dev)
 {
 	struct auxiliary_driver *auxdrv = to_auxiliary_drv(dev->driver);
 	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
@@ -87,8 +87,6 @@ static int auxiliary_bus_remove(struct device *dev)
 	if (auxdrv->remove)
 		auxdrv->remove(auxdev);
 	dev_pm_domain_detach(dev, true);
-
-	return 0;
 }
 
 static void auxiliary_bus_shutdown(struct device *dev)
diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index aa4737667026..55e3ee2da98f 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -46,14 +46,12 @@ static int isa_bus_probe(struct device *dev)
 	return 0;
 }
 
-static int isa_bus_remove(struct device *dev)
+static void isa_bus_remove(struct device *dev)
 {
 	struct isa_driver *isa_driver = dev->platform_data;
 
 	if (isa_driver && isa_driver->remove)
 		isa_driver->remove(dev, to_isa_dev(dev)->id);
-
-	return 0;
 }
 
 static void isa_bus_shutdown(struct device *dev)
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 8640578f45e9..a94b7f454881 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1438,7 +1438,7 @@ static int platform_probe(struct device *_dev)
 	return ret;
 }
 
-static int platform_remove(struct device *_dev)
+static void platform_remove(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
@@ -1450,8 +1450,6 @@ static int platform_remove(struct device *_dev)
 			dev_warn(_dev, "remove callback returned a non-zero value. This will be ignored.\n");
 	}
 	dev_pm_domain_detach(_dev, true);
-
-	return 0;
 }
 
 static void platform_shutdown(struct device *_dev)
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 6535614a7dc1..e076630d17bd 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -27,7 +27,7 @@ static DEFINE_MUTEX(bcma_buses_mutex);
 
 static int bcma_bus_match(struct device *dev, struct device_driver *drv);
 static int bcma_device_probe(struct device *dev);
-static int bcma_device_remove(struct device *dev);
+static void bcma_device_remove(struct device *dev);
 static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 
 static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -614,7 +614,7 @@ static int bcma_device_probe(struct device *dev)
 	return err;
 }
 
-static int bcma_device_remove(struct device *dev)
+static void bcma_device_remove(struct device *dev)
 {
 	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
 	struct bcma_driver *adrv = container_of(dev->driver, struct bcma_driver,
@@ -623,8 +623,6 @@ static int bcma_device_remove(struct device *dev)
 	if (adrv->remove)
 		adrv->remove(core);
 	put_device(dev);
-
-	return 0;
 }
 
 static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index d46db132d085..6f225dddc74f 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -169,13 +169,11 @@ static int sunxi_rsb_device_probe(struct device *dev)
 	return drv->probe(rdev);
 }
 
-static int sunxi_rsb_device_remove(struct device *dev)
+static void sunxi_rsb_device_remove(struct device *dev)
 {
 	const struct sunxi_rsb_driver *drv = to_sunxi_rsb_driver(dev->driver);
 
 	drv->remove(to_sunxi_rsb_device(dev));
-
-	return 0;
 }
 
 static struct bus_type sunxi_rsb_bus = {
diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
index a2e4d54fc7bc..2b90b7c3b9d7 100644
--- a/drivers/cxl/core.c
+++ b/drivers/cxl/core.c
@@ -1034,13 +1034,12 @@ static int cxl_bus_probe(struct device *dev)
 	return to_cxl_drv(dev->driver)->probe(dev);
 }
 
-static int cxl_bus_remove(struct device *dev)
+static void cxl_bus_remove(struct device *dev)
 {
 	struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
 
 	if (cxl_drv->remove)
 		cxl_drv->remove(dev);
-	return 0;
 }
 
 struct bus_type cxl_bus_type = {
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 5aee26e1bbd6..6cc4da4c713d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -172,15 +172,13 @@ static int dax_bus_probe(struct device *dev)
 	return 0;
 }
 
-static int dax_bus_remove(struct device *dev)
+static void dax_bus_remove(struct device *dev)
 {
 	struct dax_device_driver *dax_drv = to_dax_drv(dev->driver);
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	if (dax_drv->remove)
 		dax_drv->remove(dev_dax);
-
-	return 0;
 }
 
 static struct bus_type dax_bus_type = {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 0460d58e3941..5a017c62c752 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -260,7 +260,7 @@ static void disable_wq(struct idxd_wq *wq)
 	dev_info(dev, "wq %s disabled\n", dev_name(&wq->conf_dev));
 }
 
-static int idxd_config_bus_remove(struct device *dev)
+static void idxd_config_bus_remove(struct device *dev)
 {
 	int rc;
 
@@ -305,8 +305,6 @@ static int idxd_config_bus_remove(struct device *dev)
 			dev_info(dev, "Device %s disabled\n", dev_name(dev));
 
 	}
-
-	return 0;
 }
 
 static void idxd_config_bus_shutdown(struct device *dev)
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 68216988391f..90ed8fdaba75 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -187,14 +187,12 @@ static int fw_unit_probe(struct device *dev)
 	return driver->probe(fw_unit(dev), unit_match(dev, dev->driver));
 }
 
-static int fw_unit_remove(struct device *dev)
+static void fw_unit_remove(struct device *dev)
 {
 	struct fw_driver *driver =
 			container_of(dev->driver, struct fw_driver, driver);
 
 	driver->remove(fw_unit(dev));
-
-	return 0;
 }
 
 static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 784cf0027da3..2682c3df651c 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -116,15 +116,13 @@ static int scmi_dev_probe(struct device *dev)
 	return scmi_drv->probe(scmi_dev);
 }
 
-static int scmi_dev_remove(struct device *dev)
+static void scmi_dev_remove(struct device *dev)
 {
 	struct scmi_driver *scmi_drv = to_scmi_driver(dev->driver);
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
 	if (scmi_drv->remove)
 		scmi_drv->remove(scmi_dev);
-
-	return 0;
 }
 
 static struct bus_type scmi_bus_type = {
diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index dc83ea118c67..c52bcaa9def6 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -44,15 +44,13 @@ static int coreboot_bus_probe(struct device *dev)
 	return ret;
 }
 
-static int coreboot_bus_remove(struct device *dev)
+static void coreboot_bus_remove(struct device *dev)
 {
 	struct coreboot_device *device = CB_DEV(dev);
 	struct coreboot_driver *driver = CB_DRV(dev->driver);
 
 	if (driver->remove)
 		driver->remove(device);
-
-	return 0;
 }
 
 static struct bus_type coreboot_bus_type = {
diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 511b20ff35a3..1ae6779a0dd6 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -284,15 +284,13 @@ static int dfl_bus_probe(struct device *dev)
 	return ddrv->probe(ddev);
 }
 
-static int dfl_bus_remove(struct device *dev)
+static void dfl_bus_remove(struct device *dev)
 {
 	struct dfl_driver *ddrv = to_dfl_drv(dev->driver);
 	struct dfl_device *ddev = to_dfl_dev(dev);
 
 	if (ddrv->remove)
 		ddrv->remove(ddev);
-
-	return 0;
 }
 
 static int dfl_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 7db332139f7d..dbed2524fd47 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2302,7 +2302,7 @@ static int hid_device_probe(struct device *dev)
 	return ret;
 }
 
-static int hid_device_remove(struct device *dev)
+static void hid_device_remove(struct device *dev)
 {
 	struct hid_device *hdev = to_hid_device(dev);
 	struct hid_driver *hdrv;
@@ -2322,8 +2322,6 @@ static int hid_device_remove(struct device *dev)
 
 	if (!hdev->io_started)
 		up(&hdev->driver_input_lock);
-
-	return 0;
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index f0802b047ed8..8a51bd9cd093 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -255,7 +255,7 @@ static int ishtp_cl_bus_match(struct device *dev, struct device_driver *drv)
  *
  * Return: Return value from driver remove() call.
  */
-static int ishtp_cl_device_remove(struct device *dev)
+static void ishtp_cl_device_remove(struct device *dev)
 {
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(dev->driver);
@@ -267,8 +267,6 @@ static int ishtp_cl_device_remove(struct device *dev)
 
 	if (driver->remove)
 		driver->remove(device);
-
-	return 0;
 }
 
 /**
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 57bbbaa4e8f7..392c1ac4f819 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -922,7 +922,7 @@ static int vmbus_probe(struct device *child_device)
 /*
  * vmbus_remove - Remove a vmbus device
  */
-static int vmbus_remove(struct device *child_device)
+static void vmbus_remove(struct device *child_device)
 {
 	struct hv_driver *drv;
 	struct hv_device *dev = device_to_hv_device(child_device);
@@ -932,11 +932,8 @@ static int vmbus_remove(struct device *child_device)
 		if (drv->remove)
 			drv->remove(dev);
 	}
-
-	return 0;
 }
 
-
 /*
  * vmbus_shutdown - Shutdown a vmbus device
  */
diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
index 66eed2dff818..7e753a75d23b 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -95,7 +95,7 @@ static int intel_th_probe(struct device *dev)
 
 static void intel_th_device_remove(struct intel_th_device *thdev);
 
-static int intel_th_remove(struct device *dev)
+static void intel_th_remove(struct device *dev)
 {
 	struct intel_th_driver *thdrv = to_intel_th_driver(dev->driver);
 	struct intel_th_device *thdev = to_intel_th_device(dev);
@@ -164,8 +164,6 @@ static int intel_th_remove(struct device *dev)
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
-
-	return 0;
 }
 
 static struct bus_type intel_th_bus = {
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 84f12bf90644..54964fbe3f03 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -601,7 +601,7 @@ static int i2c_device_probe(struct device *dev)
 	return status;
 }
 
-static int i2c_device_remove(struct device *dev)
+static void i2c_device_remove(struct device *dev)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct i2c_adapter      *adap;
@@ -631,9 +631,6 @@ static int i2c_device_remove(struct device *dev)
 	client->irq = 0;
 	if (client->flags & I2C_CLIENT_HOST_NOTIFY)
 		pm_runtime_put(&client->adapter->dev);
-
-	/* return always 0 because there is WIP to make remove-functions void */
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index e2e12a5585e5..c3b4c677b442 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -322,7 +322,7 @@ static int i3c_device_probe(struct device *dev)
 	return driver->probe(i3cdev);
 }
 
-static int i3c_device_remove(struct device *dev)
+static void i3c_device_remove(struct device *dev)
 {
 	struct i3c_device *i3cdev = dev_to_i3cdev(dev);
 	struct i3c_driver *driver = drv_to_i3cdrv(dev->driver);
@@ -331,8 +331,6 @@ static int i3c_device_remove(struct device *dev)
 		driver->remove(i3cdev);
 
 	i3c_device_free_ibi(i3cdev);
-
-	return 0;
 }
 
 struct bus_type i3c_bus_type = {
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 61fa7e724172..db58a01b23d3 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -697,13 +697,12 @@ static int gameport_driver_probe(struct device *dev)
 	return gameport->drv ? 0 : -ENODEV;
 }
 
-static int gameport_driver_remove(struct device *dev)
+static void gameport_driver_remove(struct device *dev)
 {
 	struct gameport *gameport = to_gameport_port(dev);
 	struct gameport_driver *drv = to_gameport_driver(dev->driver);
 
 	drv->disconnect(gameport);
-	return 0;
 }
 
 static void gameport_attach_driver(struct gameport_driver *drv)
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 29f491082926..ec117be3d8d8 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -778,12 +778,11 @@ static int serio_driver_probe(struct device *dev)
 	return serio_connect_driver(serio, drv);
 }
 
-static int serio_driver_remove(struct device *dev)
+static void serio_driver_remove(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
 	serio_disconnect_driver(serio);
-	return 0;
 }
 
 static void serio_cleanup(struct serio *serio)
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 7de9605cac4f..b1c3198355e7 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -67,15 +67,13 @@ static int ipack_bus_probe(struct device *device)
 	return drv->ops->probe(dev);
 }
 
-static int ipack_bus_remove(struct device *device)
+static void ipack_bus_remove(struct device *device)
 {
 	struct ipack_device *dev = to_ipack_dev(device);
 	struct ipack_driver *drv = to_ipack_driver(device->driver);
 
 	if (drv->ops->remove)
 		drv->ops->remove(dev);
-
-	return 0;
 }
 
 static int ipack_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 49af60bdac92..c1fdf2896021 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -88,7 +88,7 @@ static int macio_device_probe(struct device *dev)
 	return error;
 }
 
-static int macio_device_remove(struct device *dev)
+static void macio_device_remove(struct device *dev)
 {
 	struct macio_dev * macio_dev = to_macio_device(dev);
 	struct macio_driver * drv = to_macio_driver(dev->driver);
@@ -96,8 +96,6 @@ static int macio_device_remove(struct device *dev)
 	if (dev->driver && drv->remove)
 		drv->remove(macio_dev);
 	macio_dev_put(macio_dev);
-
-	return 0;
 }
 
 static void macio_device_shutdown(struct device *dev)
diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index 38fbb3b59873..edf4ee6eff25 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -77,7 +77,7 @@ static int mcb_probe(struct device *dev)
 	return ret;
 }
 
-static int mcb_remove(struct device *dev)
+static void mcb_remove(struct device *dev)
 {
 	struct mcb_driver *mdrv = to_mcb_driver(dev->driver);
 	struct mcb_device *mdev = to_mcb_device(dev);
@@ -89,8 +89,6 @@ static int mcb_remove(struct device *dev)
 	module_put(carrier_mod);
 
 	put_device(&mdev->dev);
-
-	return 0;
 }
 
 static void mcb_shutdown(struct device *dev)
diff --git a/drivers/media/pci/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8xx/bttv-gpio.c
index b730225ca887..a2b18e2bed1b 100644
--- a/drivers/media/pci/bt8xx/bttv-gpio.c
+++ b/drivers/media/pci/bt8xx/bttv-gpio.c
@@ -46,14 +46,13 @@ static int bttv_sub_probe(struct device *dev)
 	return sub->probe ? sub->probe(sdev) : -ENODEV;
 }
 
-static int bttv_sub_remove(struct device *dev)
+static void bttv_sub_remove(struct device *dev)
 {
 	struct bttv_sub_device *sdev = to_bttv_sub_dev(dev);
 	struct bttv_sub_driver *sub = to_bttv_sub_drv(dev->driver);
 
 	if (sub->remove)
 		sub->remove(sdev);
-	return 0;
 }
 
 struct bus_type bttv_sub_bus_type = {
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index bb1065990aeb..660df7d269fa 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -91,7 +91,7 @@ static int memstick_device_probe(struct device *dev)
 	return rc;
 }
 
-static int memstick_device_remove(struct device *dev)
+static void memstick_device_remove(struct device *dev)
 {
 	struct memstick_dev *card = container_of(dev, struct memstick_dev,
 						  dev);
@@ -105,7 +105,6 @@ static int memstick_device_remove(struct device *dev)
 	}
 
 	put_device(dev);
-	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/mfd/mcp-core.c b/drivers/mfd/mcp-core.c
index eff9423e90f5..2fa592c37c6f 100644
--- a/drivers/mfd/mcp-core.c
+++ b/drivers/mfd/mcp-core.c
@@ -33,13 +33,12 @@ static int mcp_bus_probe(struct device *dev)
 	return drv->probe(mcp);
 }
 
-static int mcp_bus_remove(struct device *dev)
+static void mcp_bus_remove(struct device *dev)
 {
 	struct mcp *mcp = to_mcp(dev);
 	struct mcp_driver *drv = to_mcp_driver(dev->driver);
 
 	drv->remove(mcp);
-	return 0;
 }
 
 static struct bus_type mcp_bus_type = {
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 935acc6bbf3c..3bf2bb4fd152 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -884,7 +884,7 @@ static int mei_cl_device_probe(struct device *dev)
  *
  * Return:  0 on success; < 0 otherwise
  */
-static int mei_cl_device_remove(struct device *dev)
+static void mei_cl_device_remove(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
 	struct mei_cl_driver *cldrv = to_mei_cl_driver(dev->driver);
@@ -896,8 +896,6 @@ static int mei_cl_device_remove(struct device *dev)
 
 	mei_cl_bus_module_put(cldev);
 	module_put(THIS_MODULE);
-
-	return 0;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *a,
diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 667e574a7df2..52656fc87e99 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -87,7 +87,7 @@ static void tifm_dummy_event(struct tifm_dev *sock)
 	return;
 }
 
-static int tifm_device_remove(struct device *dev)
+static void tifm_device_remove(struct device *dev)
 {
 	struct tifm_dev *sock = container_of(dev, struct tifm_dev, dev);
 	struct tifm_driver *drv = container_of(dev->driver, struct tifm_driver,
@@ -101,7 +101,6 @@ static int tifm_device_remove(struct device *dev)
 	}
 
 	put_device(dev);
-	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 4383c262b3f5..f6b7a9c5bbff 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -140,14 +140,12 @@ static int mmc_bus_probe(struct device *dev)
 	return drv->probe(card);
 }
 
-static int mmc_bus_remove(struct device *dev)
+static void mmc_bus_remove(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
 	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	drv->remove(card);
-
-	return 0;
 }
 
 static void mmc_bus_shutdown(struct device *dev)
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 3d709029e07c..fda03b35c14a 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -203,7 +203,7 @@ static int sdio_bus_probe(struct device *dev)
 	return ret;
 }
 
-static int sdio_bus_remove(struct device *dev)
+static void sdio_bus_remove(struct device *dev)
 {
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
@@ -232,8 +232,6 @@ static int sdio_bus_remove(struct device *dev)
 		pm_runtime_put_sync(dev);
 
 	dev_pm_domain_detach(dev, false);
-
-	return 0;
 }
 
 static const struct dev_pm_ops sdio_bus_pm_ops = {
diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ccec29970d5b..14b154929533 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -370,12 +370,11 @@ static int nsim_bus_probe(struct device *dev)
 	return nsim_dev_probe(nsim_bus_dev);
 }
 
-static int nsim_bus_remove(struct device *dev)
+static void nsim_bus_remove(struct device *dev)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
 
 	nsim_dev_remove(nsim_bus_dev);
-	return 0;
 }
 
 static int nsim_num_vf(struct device *dev)
diff --git a/drivers/ntb/core.c b/drivers/ntb/core.c
index f8f75a504a58..27dd93deff6e 100644
--- a/drivers/ntb/core.c
+++ b/drivers/ntb/core.c
@@ -271,7 +271,7 @@ static int ntb_probe(struct device *dev)
 	return rc;
 }
 
-static int ntb_remove(struct device *dev)
+static void ntb_remove(struct device *dev)
 {
 	struct ntb_dev *ntb;
 	struct ntb_client *client;
@@ -283,8 +283,6 @@ static int ntb_remove(struct device *dev)
 		client->ops.remove(client, ntb);
 		put_device(dev);
 	}
-
-	return 0;
 }
 
 static void ntb_dev_release(struct device *dev)
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 4a02561cfb96..a9b97ebc71ac 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -304,7 +304,7 @@ static int ntb_transport_bus_probe(struct device *dev)
 	return rc;
 }
 
-static int ntb_transport_bus_remove(struct device *dev)
+static void ntb_transport_bus_remove(struct device *dev)
 {
 	const struct ntb_transport_client *client;
 
@@ -312,8 +312,6 @@ static int ntb_transport_bus_remove(struct device *dev)
 	client->remove(dev);
 
 	put_device(dev);
-
-	return 0;
 }
 
 static struct bus_type ntb_transport_bus = {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index e6aa87043a95..9dc7f3edd42b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -108,7 +108,7 @@ static int nvdimm_bus_probe(struct device *dev)
 	return rc;
 }
 
-static int nvdimm_bus_remove(struct device *dev)
+static void nvdimm_bus_remove(struct device *dev)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
 	struct module *provider = to_bus_provider(dev);
@@ -123,7 +123,6 @@ static int nvdimm_bus_remove(struct device *dev)
 	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s)\n", dev->driver->name,
 			dev_name(dev));
 	module_put(provider);
-	return 0;
 }
 
 static void nvdimm_bus_shutdown(struct device *dev)
diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint/pci-epf-core.c
index 4b9ad96bf1b2..502eb79cd551 100644
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -387,7 +387,7 @@ static int pci_epf_device_probe(struct device *dev)
 	return driver->probe(epf);
 }
 
-static int pci_epf_device_remove(struct device *dev)
+static void pci_epf_device_remove(struct device *dev)
 {
 	struct pci_epf *epf = to_pci_epf(dev);
 	struct pci_epf_driver *driver = to_pci_epf_driver(dev->driver);
@@ -395,8 +395,6 @@ static int pci_epf_device_remove(struct device *dev)
 	if (driver->remove)
 		driver->remove(epf);
 	epf->driver = NULL;
-
-	return 0;
 }
 
 static struct bus_type pci_epf_bus_type = {
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3a72352aa5cf..a0615395500a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -440,7 +440,7 @@ static int pci_device_probe(struct device *dev)
 	return error;
 }
 
-static int pci_device_remove(struct device *dev)
+static void pci_device_remove(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
@@ -476,7 +476,6 @@ static int pci_device_remove(struct device *dev)
 	 */
 
 	pci_dev_put(pci_dev);
-	return 0;
 }
 
 static void pci_device_shutdown(struct device *dev)
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index bd81aa64d011..5bd1b80424e7 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -350,7 +350,7 @@ static void pcmcia_card_remove(struct pcmcia_socket *s, struct pcmcia_device *le
 	return;
 }
 
-static int pcmcia_device_remove(struct device *dev)
+static void pcmcia_device_remove(struct device *dev)
 {
 	struct pcmcia_device *p_dev;
 	struct pcmcia_driver *p_drv;
@@ -389,8 +389,6 @@ static int pcmcia_device_remove(struct device *dev)
 	/* references from pcmcia_device_probe */
 	pcmcia_put_dev(p_dev);
 	module_put(p_drv->owner);
-
-	return 0;
 }
 
 
diff --git a/drivers/platform/surface/aggregator/bus.c b/drivers/platform/surface/aggregator/bus.c
index 0169677c243e..0a40dd9c94ed 100644
--- a/drivers/platform/surface/aggregator/bus.c
+++ b/drivers/platform/surface/aggregator/bus.c
@@ -316,14 +316,12 @@ static int ssam_bus_probe(struct device *dev)
 		->probe(to_ssam_device(dev));
 }
 
-static int ssam_bus_remove(struct device *dev)
+static void ssam_bus_remove(struct device *dev)
 {
 	struct ssam_device_driver *sdrv = to_ssam_device_driver(dev->driver);
 
 	if (sdrv->remove)
 		sdrv->remove(to_ssam_device(dev));
-
-	return 0;
 }
 
 struct bus_type ssam_bus_type = {
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 62e0d56a3332..a76313006bdc 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -980,7 +980,7 @@ static int wmi_dev_probe(struct device *dev)
 	return ret;
 }
 
-static int wmi_dev_remove(struct device *dev)
+static void wmi_dev_remove(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	struct wmi_driver *wdriver =
@@ -997,8 +997,6 @@ static int wmi_dev_remove(struct device *dev)
 
 	if (ACPI_FAILURE(wmi_method_enable(wblock, 0)))
 		dev_warn(dev, "failed to disable device\n");
-
-	return 0;
 }
 
 static struct class wmi_bus_class = {
diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index c29d590c5e4f..cc6757dfa3f1 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -123,7 +123,7 @@ static int pnp_device_probe(struct device *dev)
 	return error;
 }
 
-static int pnp_device_remove(struct device *dev)
+static void pnp_device_remove(struct device *dev)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
 	struct pnp_driver *drv = pnp_dev->driver;
@@ -139,7 +139,6 @@ static int pnp_device_remove(struct device *dev)
 		pnp_disable_dev(pnp_dev);
 
 	pnp_device_detach(pnp_dev);
-	return 0;
 }
 
 static void pnp_device_shutdown(struct device *dev)
diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 72874153972e..a72bb0a40fcf 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -112,7 +112,7 @@ static int rio_device_probe(struct device *dev)
  * driver, then run the driver remove() method.  Then update
  * the reference count.
  */
-static int rio_device_remove(struct device *dev)
+static void rio_device_remove(struct device *dev)
 {
 	struct rio_dev *rdev = to_rio_dev(dev);
 	struct rio_driver *rdrv = rdev->driver;
@@ -124,8 +124,6 @@ static int rio_device_remove(struct device *dev)
 	}
 
 	rio_dev_put(rdev);
-
-	return 0;
 }
 
 static void rio_device_shutdown(struct device *dev)
diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index c1404d3dae2c..7f6fac618ab2 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -530,7 +530,7 @@ static int rpmsg_dev_probe(struct device *dev)
 	return err;
 }
 
-static int rpmsg_dev_remove(struct device *dev)
+static void rpmsg_dev_remove(struct device *dev)
 {
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
@@ -546,8 +546,6 @@ static int rpmsg_dev_remove(struct device *dev)
 
 	if (rpdev->ept)
 		rpmsg_destroy_ept(rpdev->ept);
-
-	return err;
 }
 
 static struct bus_type rpmsg_bus = {
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index a6aeab1ea0ae..382c5b5f8cd3 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -439,15 +439,13 @@ module_exit(cleanup_ccwgroup);
 
 /************************** driver stuff ******************************/
 
-static int ccwgroup_remove(struct device *dev)
+static void ccwgroup_remove(struct device *dev)
 {
 	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
 	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(dev->driver);
 
 	if (gdrv->remove)
 		gdrv->remove(gdev);
-
-	return 0;
 }
 
 static void ccwgroup_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 092fd1ea5799..ebc321edba51 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1371,7 +1371,7 @@ static int css_probe(struct device *dev)
 	return ret;
 }
 
-static int css_remove(struct device *dev)
+static void css_remove(struct device *dev)
 {
 	struct subchannel *sch;
 
@@ -1379,8 +1379,6 @@ static int css_remove(struct device *dev)
 	if (sch->driver->remove)
 		sch->driver->remove(sch);
 	sch->driver = NULL;
-
-	return 0;
 }
 
 static void css_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index cd5d2d4d8e46..adf33b653d87 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1741,7 +1741,7 @@ ccw_device_probe (struct device *dev)
 	return 0;
 }
 
-static int ccw_device_remove(struct device *dev)
+static void ccw_device_remove(struct device *dev)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct ccw_driver *cdrv = cdev->drv;
@@ -1775,8 +1775,6 @@ static int ccw_device_remove(struct device *dev)
 	spin_unlock_irq(cdev->ccwlock);
 	io_subchannel_quiesce(sch);
 	__disable_cmf(cdev);
-
-	return 0;
 }
 
 static void ccw_device_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index b31711307e5a..b6b4589c70bd 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -28,15 +28,13 @@ static int scmdev_probe(struct device *dev)
 	return scmdrv->probe ? scmdrv->probe(scmdev) : -ENODEV;
 }
 
-static int scmdev_remove(struct device *dev)
+static void scmdev_remove(struct device *dev)
 {
 	struct scm_device *scmdev = to_scm_dev(dev);
 	struct scm_driver *scmdrv = to_scm_drv(dev->driver);
 
 	if (scmdrv->remove)
 		scmdrv->remove(scmdev);
-
-	return 0;
 }
 
 static int scmdev_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index d2560186d771..8a0d37c0e2a5 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -884,7 +884,7 @@ static int ap_device_probe(struct device *dev)
 	return rc;
 }
 
-static int ap_device_remove(struct device *dev)
+static void ap_device_remove(struct device *dev)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	struct ap_driver *ap_drv = ap_dev->drv;
@@ -909,8 +909,6 @@ static int ap_device_remove(struct device *dev)
 	ap_dev->drv = NULL;
 
 	put_device(dev);
-
-	return 0;
 }
 
 struct ap_queue *ap_get_qdev(ap_qid_t qid)
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5b3a20a140f9..58f69366bdcc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7674,7 +7674,7 @@ static int sdebug_driver_probe(struct device *dev)
 	return error;
 }
 
-static int sdebug_driver_remove(struct device *dev)
+static void sdebug_driver_remove(struct device *dev)
 {
 	struct sdebug_host_info *sdbg_host;
 	struct sdebug_dev_info *sdbg_devinfo, *tmp;
@@ -7691,7 +7691,6 @@ static int sdebug_driver_remove(struct device *dev)
 	}
 
 	scsi_host_put(sdbg_host->shost);
-	return 0;
 }
 
 static int pseudo_lld_bus_match(struct device *dev,
diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index 1794ff0106bc..7c4f32d76966 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -520,7 +520,7 @@ static int siox_probe(struct device *dev)
 	return sdriver->probe(sdevice);
 }
 
-static int siox_remove(struct device *dev)
+static void siox_remove(struct device *dev)
 {
 	struct siox_driver *sdriver =
 		container_of(dev->driver, struct siox_driver, driver);
@@ -528,8 +528,6 @@ static int siox_remove(struct device *dev)
 
 	if (sdriver->remove)
 		sdriver->remove(sdevice);
-
-	return 0;
 }
 
 static void siox_shutdown(struct device *dev)
diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 1d2bc181da05..78480e332ab8 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -81,7 +81,7 @@ static int slim_device_probe(struct device *dev)
 	return ret;
 }
 
-static int slim_device_remove(struct device *dev)
+static void slim_device_remove(struct device *dev)
 {
 	struct slim_device *sbdev = to_slim_device(dev);
 	struct slim_driver *sbdrv;
@@ -91,8 +91,6 @@ static int slim_device_remove(struct device *dev)
 		if (sbdrv->remove)
 			sbdrv->remove(sbdev);
 	}
-
-	return 0;
 }
 
 static int slim_device_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 7abfc8c4fdc7..475a57b435b2 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -217,7 +217,7 @@ static int apr_device_probe(struct device *dev)
 	return adrv->probe(adev);
 }
 
-static int apr_device_remove(struct device *dev)
+static void apr_device_remove(struct device *dev)
 {
 	struct apr_device *adev = to_apr_device(dev);
 	struct apr_driver *adrv;
@@ -231,8 +231,6 @@ static int apr_device_remove(struct device *dev)
 		idr_remove(&apr->svcs_idr, adev->svc_id);
 		spin_unlock(&apr->svcs_lock);
 	}
-
-	return 0;
 }
 
 static int apr_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c99181165321..ad2b558dc9cb 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -405,7 +405,7 @@ static int spi_probe(struct device *dev)
 	return ret;
 }
 
-static int spi_remove(struct device *dev)
+static void spi_remove(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
 
@@ -420,8 +420,6 @@ static int spi_remove(struct device *dev)
 	}
 
 	dev_pm_domain_detach(dev, true);
-
-	return 0;
 }
 
 static void spi_shutdown(struct device *dev)
diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index 51f5aeb65b3b..b37ead9e2fad 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -345,7 +345,7 @@ static int spmi_drv_probe(struct device *dev)
 	return err;
 }
 
-static int spmi_drv_remove(struct device *dev)
+static void spmi_drv_remove(struct device *dev)
 {
 	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
 
@@ -356,7 +356,6 @@ static int spmi_drv_remove(struct device *dev)
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	pm_runtime_put_noidle(dev);
-	return 0;
 }
 
 static void spmi_drv_shutdown(struct device *dev)
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 3a29b5570f9f..8a93c83cb6f8 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -283,7 +283,7 @@ static void ssb_device_shutdown(struct device *dev)
 		ssb_drv->shutdown(ssb_dev);
 }
 
-static int ssb_device_remove(struct device *dev)
+static void ssb_device_remove(struct device *dev)
 {
 	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
 	struct ssb_driver *ssb_drv = drv_to_ssb_drv(dev->driver);
@@ -291,8 +291,6 @@ static int ssb_device_remove(struct device *dev)
 	if (ssb_drv && ssb_drv->remove)
 		ssb_drv->remove(ssb_dev);
 	ssb_device_put(ssb_dev);
-
-	return 0;
 }
 
 static int ssb_device_probe(struct device *dev)
diff --git a/drivers/staging/fieldbus/anybuss/host.c b/drivers/staging/fieldbus/anybuss/host.c
index 0f730efe9a6d..8a75f6642c78 100644
--- a/drivers/staging/fieldbus/anybuss/host.c
+++ b/drivers/staging/fieldbus/anybuss/host.c
@@ -1186,15 +1186,13 @@ static int anybus_bus_probe(struct device *dev)
 	return adrv->probe(adev);
 }
 
-static int anybus_bus_remove(struct device *dev)
+static void anybus_bus_remove(struct device *dev)
 {
 	struct anybuss_client_driver *adrv =
 		to_anybuss_client_driver(dev->driver);
 
 	if (adrv->remove)
 		adrv->remove(to_anybuss_client(dev));
-
-	return 0;
 }
 
 static struct bus_type anybus_bus = {
diff --git a/drivers/staging/greybus/gbphy.c b/drivers/staging/greybus/gbphy.c
index 13d319860da5..5a5c17a4519b 100644
--- a/drivers/staging/greybus/gbphy.c
+++ b/drivers/staging/greybus/gbphy.c
@@ -169,7 +169,7 @@ static int gbphy_dev_probe(struct device *dev)
 	return ret;
 }
 
-static int gbphy_dev_remove(struct device *dev)
+static void gbphy_dev_remove(struct device *dev)
 {
 	struct gbphy_driver *gbphy_drv = to_gbphy_driver(dev->driver);
 	struct gbphy_device *gbphy_dev = to_gbphy_dev(dev);
@@ -180,8 +180,6 @@ static int gbphy_dev_remove(struct device *dev)
 	pm_runtime_set_suspended(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_dont_use_autosuspend(dev);
-
-	return 0;
 }
 
 static struct bus_type gbphy_bus_type = {
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6d0b0e67e79e..cbb2118fb35e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -81,7 +81,7 @@ static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
 }
 
 static int tcm_loop_driver_probe(struct device *);
-static int tcm_loop_driver_remove(struct device *);
+static void tcm_loop_driver_remove(struct device *);
 
 static int pseudo_lld_bus_match(struct device *dev,
 				struct device_driver *dev_driver)
@@ -363,7 +363,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 	return 0;
 }
 
-static int tcm_loop_driver_remove(struct device *dev)
+static void tcm_loop_driver_remove(struct device *dev)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct Scsi_Host *sh;
@@ -373,7 +373,6 @@ static int tcm_loop_driver_remove(struct device *dev)
 
 	scsi_remove_host(sh);
 	scsi_host_put(sh);
-	return 0;
 }
 
 static void tcm_loop_release_adapter(struct device *dev)
diff --git a/drivers/thunderbolt/domain.c b/drivers/thunderbolt/domain.c
index a062befcb3b2..7018d959f775 100644
--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -86,7 +86,7 @@ static int tb_service_probe(struct device *dev)
 	return driver->probe(svc, id);
 }
 
-static int tb_service_remove(struct device *dev)
+static void tb_service_remove(struct device *dev)
 {
 	struct tb_service *svc = tb_to_service(dev);
 	struct tb_service_driver *driver;
@@ -94,8 +94,6 @@ static int tb_service_remove(struct device *dev)
 	driver = container_of(dev->driver, struct tb_service_driver, driver);
 	if (driver->remove)
 		driver->remove(svc);
-
-	return 0;
 }
 
 static void tb_service_shutdown(struct device *dev)
diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 9cdfcfe07e87..92498961fd92 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -421,15 +421,13 @@ static int serdev_drv_probe(struct device *dev)
 	return ret;
 }
 
-static int serdev_drv_remove(struct device *dev)
+static void serdev_drv_remove(struct device *dev)
 {
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
 	if (sdrv->remove)
 		sdrv->remove(to_serdev_device(dev));
 
 	dev_pm_domain_detach(dev, true);
-
-	return 0;
 }
 
 static struct bus_type serdev_bus_type = {
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 7e13b74e60e5..4169cf40a03b 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -78,14 +78,12 @@ static int ulpi_probe(struct device *dev)
 	return drv->probe(to_ulpi_dev(dev));
 }
 
-static int ulpi_remove(struct device *dev)
+static void ulpi_remove(struct device *dev)
 {
 	struct ulpi_driver *drv = to_ulpi_driver(dev->driver);
 
 	if (drv->remove)
 		drv->remove(to_ulpi_dev(dev));
-
-	return 0;
 }
 
 static struct bus_type ulpi_bus = {
diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index 7133818a58b9..9e38142acd38 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -74,7 +74,7 @@ static int usb_serial_device_probe(struct device *dev)
 	return retval;
 }
 
-static int usb_serial_device_remove(struct device *dev)
+static void usb_serial_device_remove(struct device *dev)
 {
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 	struct usb_serial_driver *driver;
@@ -101,8 +101,6 @@ static int usb_serial_device_remove(struct device *dev)
 
 	if (!autopm_err)
 		usb_autopm_put_interface(port->serial->interface);
-
-	return 0;
 }
 
 static ssize_t new_id_store(struct device_driver *driver,
diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index 7f3c9a8e2bf0..78e0e78954f2 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -382,7 +382,7 @@ static int typec_probe(struct device *dev)
 	return ret;
 }
 
-static int typec_remove(struct device *dev)
+static void typec_remove(struct device *dev)
 {
 	struct typec_altmode_driver *drv = to_altmode_driver(dev->driver);
 	struct typec_altmode *adev = to_typec_altmode(dev);
@@ -400,8 +400,6 @@ static int typec_remove(struct device *dev)
 
 	adev->desc = NULL;
 	adev->ops = NULL;
-
-	return 0;
 }
 
 struct bus_type typec_bus = {
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index bb3f1d1f0422..3fc4525fc05c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -34,15 +34,13 @@ static int vdpa_dev_probe(struct device *d)
 	return ret;
 }
 
-static int vdpa_dev_remove(struct device *d)
+static void vdpa_dev_remove(struct device *d)
 {
 	struct vdpa_device *vdev = dev_to_vdpa(d);
 	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
 
 	if (drv && drv->remove)
 		drv->remove(vdev);
-
-	return 0;
 }
 
 static struct bus_type vdpa_bus = {
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index c368ec824e2b..e2cb1ff56f6c 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -57,7 +57,7 @@ static int mdev_probe(struct device *dev)
 	return ret;
 }
 
-static int mdev_remove(struct device *dev)
+static void mdev_remove(struct device *dev)
 {
 	struct mdev_driver *drv =
 		container_of(dev->driver, struct mdev_driver, driver);
@@ -67,8 +67,6 @@ static int mdev_remove(struct device *dev)
 		drv->remove(mdev);
 
 	mdev_detach_iommu(mdev);
-
-	return 0;
 }
 
 static int mdev_match(struct device *dev, struct device_driver *drv)
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..2a6055c0d4d3 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -278,7 +278,7 @@ static int virtio_dev_probe(struct device *_d)
 
 }
 
-static int virtio_dev_remove(struct device *_d)
+static void virtio_dev_remove(struct device *_d)
 {
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
@@ -292,7 +292,6 @@ static int virtio_dev_remove(struct device *_d)
 
 	/* Acknowledge the device's existence again. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
-	return 0;
 }
 
 static struct bus_type virtio_bus = {
diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
index 1b15afea28ee..8dba20186be3 100644
--- a/drivers/vme/vme.c
+++ b/drivers/vme/vme.c
@@ -1990,7 +1990,7 @@ static int vme_bus_probe(struct device *dev)
 	return -ENODEV;
 }
 
-static int vme_bus_remove(struct device *dev)
+static void vme_bus_remove(struct device *dev)
 {
 	struct vme_driver *driver;
 	struct vme_dev *vdev = dev_to_vme_dev(dev);
@@ -1998,8 +1998,6 @@ static int vme_bus_remove(struct device *dev)
 	driver = dev->platform_data;
 	if (driver->remove)
 		driver->remove(vdev);
-
-	return 0;
 }
 
 struct bus_type vme_bus_type = {
diff --git a/drivers/xen/xenbus/xenbus.h b/drivers/xen/xenbus/xenbus.h
index 2a93b7c9c159..2754bdfadcb8 100644
--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -106,7 +106,7 @@ void xs_request_exit(struct xb_req_data *req);
 
 int xenbus_match(struct device *_dev, struct device_driver *_drv);
 int xenbus_dev_probe(struct device *_dev);
-int xenbus_dev_remove(struct device *_dev);
+void xenbus_dev_remove(struct device *_dev);
 int xenbus_register_driver_common(struct xenbus_driver *drv,
 				  struct xen_bus_type *bus,
 				  struct module *owner,
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 97f0d234482d..f4f52d574df9 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -326,7 +326,7 @@ int xenbus_dev_probe(struct device *_dev)
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_probe);
 
-int xenbus_dev_remove(struct device *_dev)
+void xenbus_dev_remove(struct device *_dev)
 {
 	struct xenbus_device *dev = to_xenbus_device(_dev);
 	struct xenbus_driver *drv = to_xenbus_driver(_dev->driver);
@@ -356,8 +356,6 @@ int xenbus_dev_remove(struct device *_dev)
 	if (!drv->allow_rebind ||
 	    xenbus_read_driver_state(dev->nodename) == XenbusStateClosing)
 		xenbus_switch_state(dev, XenbusStateClosed);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(xenbus_dev_remove);
 
diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index 1ea5e1d1545b..062777a45a74 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -91,7 +91,7 @@ struct bus_type {
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	int (*probe)(struct device *dev);
 	void (*sync_state)(struct device *dev);
-	int (*remove)(struct device *dev);
+	void (*remove)(struct device *dev);
 	void (*shutdown)(struct device *dev);
 
 	int (*online)(struct device *dev);
diff --git a/sound/aoa/soundbus/core.c b/sound/aoa/soundbus/core.c
index 002fb5bf220b..c9579d97fbab 100644
--- a/sound/aoa/soundbus/core.c
+++ b/sound/aoa/soundbus/core.c
@@ -104,7 +104,7 @@ static int soundbus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return retval;
 }
 
-static int soundbus_device_remove(struct device *dev)
+static void soundbus_device_remove(struct device *dev)
 {
 	struct soundbus_dev * soundbus_dev = to_soundbus_device(dev);
 	struct soundbus_driver * drv = to_soundbus_driver(dev->driver);
@@ -112,8 +112,6 @@ static int soundbus_device_remove(struct device *dev)
 	if (dev->driver && drv->remove)
 		drv->remove(soundbus_dev);
 	soundbus_dev_put(soundbus_dev);
-
-	return 0;
 }
 
 static void soundbus_device_shutdown(struct device *dev)
-- 
2.30.2


