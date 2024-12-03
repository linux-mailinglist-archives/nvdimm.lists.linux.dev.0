Return-Path: <nvdimm+bounces-9429-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B679E100D
	for <lists+linux-nvdimm@lfdr.de>; Tue,  3 Dec 2024 01:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 892691651D3
	for <lists+linux-nvdimm@lfdr.de>; Tue,  3 Dec 2024 00:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CA71632DA;
	Tue,  3 Dec 2024 00:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="D949jriR"
X-Original-To: nvdimm@lists.linux.dev
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC55BAF0
	for <nvdimm@lists.linux.dev>; Tue,  3 Dec 2024 00:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.6.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733186187; cv=none; b=ZmIAtLIIcMEy2STUvdlXIiFOqBjTM5Vtr7/wbGMT4XNmXavaBKhj7dITSZiWitodcUi0TwtkCXTK7nZk8bsuWCPbo9tt7ubEXh2GbjCQKtu2y4nIV3KIiPvWxH9ShXNv3ybzop4huKVqyvC3szza/Z+d7IO0URCFWgU8vo4WqhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733186187; c=relaxed/simple;
	bh=Pmw7vYn6qgzOMO6/dIiRil2NNEOTXXUDIaI88Xs0kLk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SRfDUxl7XEpQPAG/VVnRK0B18qZZBrACFq58KztffGHBdS22t/bAturNr3pZUQeXmRetDK2lkQyPBw64XiGfsLWwGU4DJpSE2eIzryom3bUPEkBoIxGnaALoTPbKOEVfwZDaK8HFDSLiHZpbJwwHYxRDK1DzJrOyCNBNhPNl2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=D949jriR; arc=none smtp.client-ip=17.58.6.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; t=1733186184;
	bh=IiwvAxmsMkXtcn4MTTv7QwRfPfONTV00nftEb1rZOV4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:
	 x-icloud-hme;
	b=D949jriRjnEuZv55IaXlTezpTBP0oTLN0tjcD66KylzVfRFBw5FJVnVNc4HzKEued
	 BSRukh6XUyf33FKsfmGlDk8dN+oY2dNTKTa6nMS2l44qgvuRByVm2v6+qhEIWFg4fK
	 lIlc8VhpxiiBHYqk5vUmEm3zlGDQJy5/RN4T55qbH6oM5KZBaViTjQ3nU2jXukxAeG
	 YYgoVOhnfwedNrVGZHSiDwSDPpc6wWi7XfhckaneCDIJ7mJ3fhmvdw/XrDSqTeCH4i
	 Z2tEHG5XQQnYmrEbxupyotVkgN3Wqn+jO1CSnQVck6og9N1GeAyOAmWta96i0owje9
	 5szmAPOowFNYQ==
Received: from [192.168.1.26] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
	by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 804FE4A00B8;
	Tue,  3 Dec 2024 00:36:03 +0000 (UTC)
From: Zijun Hu <zijun_hu@icloud.com>
Date: Tue, 03 Dec 2024 08:33:26 +0800
Subject: [PATCH v2 04/32] hwmon: Adapt for constified device_find_child()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241203-const_dfc_done-v2-4-7436a98c497f@quicinc.com>
References: <20241203-const_dfc_done-v2-0-7436a98c497f@quicinc.com>
In-Reply-To: <20241203-const_dfc_done-v2-0-7436a98c497f@quicinc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Chun-Kuang Hu <chunkuang.hu@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Jean Delvare <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>, 
 Martin Tuma <martin.tuma@digiteqautomotive.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Andreas Noever <andreas.noever@gmail.com>, 
 Michael Jamet <michael.jamet@intel.com>, 
 Mika Westerberg <mika.westerberg@linux.intel.com>, 
 Yehezkel Bernat <YehezkelShB@gmail.com>, 
 Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>, 
 Vladimir Oltean <olteanv@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Takashi Sakamoto <o-takashi@sakamocchi.jp>, 
 Jiri Slaby <jirislaby@kernel.org>, 
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, 
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
 Mike Christie <michael.christie@oracle.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Davidlohr Bueso <dave@stgolabs.net>, 
 Jonathan Cameron <jonathan.cameron@huawei.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andreas Larsson <andreas@gaisler.com>, Stuart Yoder <stuyoder@gmail.com>, 
 Laurentiu Tudor <laurentiu.tudor@nxp.com>, Jens Axboe <axboe@kernel.dk>, 
 Sudeep Holla <sudeep.holla@arm.com>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Zijun Hu <zijun_hu@icloud.com>, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-hwmon@vger.kernel.org, 
 linux-media@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-gpio@vger.kernel.org, netdev@vger.kernel.org, 
 linux-pwm@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux1394-devel@lists.sourceforge.net, linux-serial@vger.kernel.org, 
 linux-sound@vger.kernel.org, open-iscsi@googlegroups.com, 
 linux-scsi@vger.kernel.org, linux-cxl@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-block@vger.kernel.org, 
 arm-scmi@vger.kernel.org, linux-efi@vger.kernel.org, 
 linux-remoteproc@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: hnVgDw1K1lIcz6xDWLO_ZLGwCsDdmTOX
X-Proofpoint-ORIG-GUID: hnVgDw1K1lIcz6xDWLO_ZLGwCsDdmTOX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_14,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2412030002
X-Apple-Remote-Links: v=1;h=KCk=;charset=UTF-8

From: Zijun Hu <quic_zijuhu@quicinc.com>

device_find_child() has been constified to take new match function type:
typedef int (*device_match_t)(struct device *dev, const void *data);

Make hwmon_match_device() take a const pointer to adapt for the new type.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 drivers/hwmon/hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 49b366254529fe6c03e8af6870ebd269cdcfd70c..9325bec83ae52d6519bcbd72b2e6213cfaee0b6d 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -341,7 +341,7 @@ static int hwmon_attr_base(enum hwmon_sensor_types type)
 
 static DEFINE_MUTEX(hwmon_pec_mutex);
 
-static int hwmon_match_device(struct device *dev, void *data)
+static int hwmon_match_device(struct device *dev, const void *data)
 {
 	return dev->class == &hwmon_class;
 }

-- 
2.34.1


