Return-Path: <nvdimm+bounces-9499-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96849EC031
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Dec 2024 01:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68F34282E92
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 Dec 2024 00:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70942C190;
	Wed, 11 Dec 2024 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="ZMziQD7S"
X-Original-To: nvdimm@lists.linux.dev
Received: from pv50p00im-ztdg10011901.me.com (pv50p00im-ztdg10011901.me.com [17.58.6.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2D0E573
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.6.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875819; cv=none; b=Kw4lfKNx0WBqa5adpg5bScfWrG2UhbVJxQ+OnRQBjn+sTxROneav83EqFYAl16eYO6HVy4+LOrktyrE6xrnPWa4GaaORwUArblZtK9bDK7SnLOrPZm+ERMWQFctsJhgwvzf7V+jO77XXTW8dTaUmgW+VE8PeKZGcN+ry0gPwVCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875819; c=relaxed/simple;
	bh=uu8niFBuTktUm8L4HBE8hYXnmfT8aDo3Fscee6GQXug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RgEfu9Z0SkgQ49N3RP9Lvo0d7hHSHaryC4UzxNr9HHXB9rkSnRRNII4V7/FjNfzv1vfhtk4kO6qd9LLCu4IC4gsS8r6F//nDlxYM0ZM4YrsOuv9eBXHAB8WevpHqR2JkD35CDE6nxliGkrWW6nBtCNqkSdO2ZVFq/MuaYKTdPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=ZMziQD7S; arc=none smtp.client-ip=17.58.6.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; t=1733875818;
	bh=egbpCFsMNX3HSfK1Qdbq/Oeo9m9Resakyx57QcAlzlg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:
	 x-icloud-hme;
	b=ZMziQD7Sqw2q5rX9VR53JEuPRIF31YBH5zcYX9TVsT4yXZfVWy2tIr4KEIcxND5B5
	 FkoeLsi+10U4/n+YlnIgNq91YUZPymcdwU8YY3yoyF9ofHbdD6xjbGQiHwjdCc7WdH
	 Pa1VmscQq704VGY6XUJ0De0DiBlHau9K2IzwU2MwAHmdQvxrVgApa7Ky1H/JpFCa0b
	 nT/1Y4JxYqSGYrFkk4QSwXGzJd5wGDwKRYgdlZAs+XXBqTDMyyUlKqCL4RS8ByzK+h
	 txAkyGsQZdetxkSIO4db8WIa/uzyHePEM5mpcAR/jlFDPSpwwCu/a7hiTmOM33V2iD
	 /aH53L14z+W4Q==
Received: from [192.168.1.26] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
	by pv50p00im-ztdg10011901.me.com (Postfix) with ESMTPSA id 3C9FD3A0396;
	Wed, 11 Dec 2024 00:10:05 +0000 (UTC)
From: Zijun Hu <zijun_hu@icloud.com>
Date: Wed, 11 Dec 2024 08:08:08 +0800
Subject: [PATCH v4 06/11] driver core: Remove match_any()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241211-const_dfc_done-v4-6-583cc60329df@quicinc.com>
References: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com>
In-Reply-To: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, 
 =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>, 
 Zijun Hu <zijun_hu@icloud.com>, linux-kernel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-sound@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-cxl@vger.kernel.org, linux1394-devel@lists.sourceforge.net, 
 arm-scmi@vger.kernel.org, linux-efi@vger.kernel.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-mediatek@lists.infradead.org, linux-hwmon@vger.kernel.org, 
 linux-media@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-usb@vger.kernel.org, linux-serial@vger.kernel.org, 
 netdev@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: sN02TlMcVyCyVJWzuZdLcTiLJFs5WRbr
X-Proofpoint-GUID: sN02TlMcVyCyVJWzuZdLcTiLJFs5WRbr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-10_13,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=856 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2412100174
X-Apple-Remote-Links: v=1;h=KCk=;charset=UTF-8

From: Zijun Hu <quic_zijuhu@quicinc.com>

Static match_any() is exactly same as API device_match_any().
Remove the former and use the later instead.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 drivers/base/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8116bc8dd6e9eba0653ca686a90c7008de9e2840..289f2dafa8f3831931d0f316d66ee12c2cb8a2e1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4114,11 +4114,6 @@ struct device *device_find_child_by_name(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(device_find_child_by_name);
 
-static int match_any(struct device *dev, const void *unused)
-{
-	return 1;
-}
-
 /**
  * device_find_any_child - device iterator for locating a child device, if any.
  * @parent: parent struct device
@@ -4130,7 +4125,7 @@ static int match_any(struct device *dev, const void *unused)
  */
 struct device *device_find_any_child(struct device *parent)
 {
-	return device_find_child(parent, NULL, match_any);
+	return device_find_child(parent, NULL, device_match_any);
 }
 EXPORT_SYMBOL_GPL(device_find_any_child);
 

-- 
2.34.1


