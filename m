Return-Path: <nvdimm+bounces-7766-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA5F88E514
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 Mar 2024 15:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29AE71F2FE60
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 Mar 2024 14:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B5A135A67;
	Wed, 27 Mar 2024 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hag0fvgc"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ADB148FE5
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543413; cv=none; b=Qk9dbtTIR23y48bFr/XwX+kxb1UvomUZpkGfmObIKiXCR/e7OnNOf8PVVf3XEWEo0Sfe0ehpsmkGBupyG42kfNDkAL/c2mn0CmUJRBSYklj2LBkTutm3CQ+2XySBrBtZmbm9n6UulmQGhkR/z6K9V17XwtWmIXtQ0//FP+XR/BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543413; c=relaxed/simple;
	bh=rFl/6jLaFbtBJ+88FvM913PJ4x0vjfjJ4PxyPcL+Huc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BBd8HkBm11dl/50THK287OBN2cKWbVEFdV08Agu9Ns16l6Sq2utO0MCP+pBOAn1y3Vcaqy1UGOVMh97n0fdTIlPENnTiIz9puyI4nK4+SU9vL/a3PAgUq1YESzg8fCqPRQAFVlo5BAbfsx/It9mcQbqz/o28PfG1HsRhDIBOWig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hag0fvgc; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56c404da0ebso702967a12.0
        for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 05:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543408; x=1712148208; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvtYxn/jBnHDfTZoo9tjjvjwD5frxuJyBUKvJwnL+3s=;
        b=hag0fvgcjB3kPKywzdGamOIV8MRk6jhddXBIbbGRErtcJB+e2Wqss7D1nq3AZdwMex
         IxYjPsProRk1qbcFCALGbeUgKZfUW0XAhQEpbbbGqjW69wE2dip4SGqAjvynEn2HOjme
         LscT5X2a5F6SrtWGIj+a3HCTAWSq49ccMR7aM4HA7gklvEEodYyVEn3SZtXHWRDjVxi7
         3IX7eB3Fkvrk327ey3M/bJjqlfwFG7UO0l0LW+WHCJmC3tkSg1BMNvTCutP6LlhA4zh1
         V9LrWdmTETyN8n/lWlbQBKSt3q2KiAqOcfutlNMB5pXAvIzpS++B4caR/7HX1LN7cPk5
         7yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543408; x=1712148208;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvtYxn/jBnHDfTZoo9tjjvjwD5frxuJyBUKvJwnL+3s=;
        b=nlkcYm9uDzGKbj1IhS5mjNP4Esaj1AvZmKJZsONi8MHEt2Ec7V655DY6l3cALi3Yib
         NRAyWfoY0K/lAU3xRxLzXX0dgGcL6UNK1e9KADAdweM82lJUQZQ3s6sZcSHqFddnKyKk
         hPcyLi9DPC5EhFOl6ttzZXTyr95oSDSnraWoATFF1wA+vKDxyh/zey4FBVhYd6DUYPjx
         ZZsl6ANrfbznPeHKMyKiCMriux565VcRMJmFyXoNPtZLi6buhJCRRWYpfFTfN++xpbwg
         VbY2+9QoyF3lfYTDLGEuQkBJQO1u8g38u8yqtkzdst258TY/bgyHb+7tkY1UYrmXmlVh
         L72Q==
X-Forwarded-Encrypted: i=1; AJvYcCXEZth+ZO0Pm6knNsiSdAEDRvXLXx1CtcM85E2le9fgCj3vZ57eb9eEC9m/6aF/d4m9g8tZh8rdQPGBahnzgYIvYjFlKwkI
X-Gm-Message-State: AOJu0YxYAd7W3mRUFBrDSi7g+OL23qwSLZnIwFA6hQKTQ8IpceVz9bHi
	JVw4e0FSrcKNcZ3FnW40JgDf9buSE4T+FhI8zGmMIkpkWEJwzVG1JyyntobjpS8=
X-Google-Smtp-Source: AGHT+IFQzE941/frKvlveayAo5OwX27t9ISC9Ui//MJIb/s8SSfev7LRMOseQU2wGRtbmTboQ2qixg==
X-Received: by 2002:a17:906:af97:b0:a47:2d4f:6fad with SMTP id mj23-20020a170906af9700b00a472d4f6fadmr3640240ejb.39.1711543407742;
        Wed, 27 Mar 2024 05:43:27 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:43:27 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:40:58 +0100
Subject: [PATCH 05/22] hwrng: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-5-0feffab77d99@linaro.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Jens Axboe <axboe@kernel.dk>, Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Amit Shah <amit@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Gonglei <arei.gonglei@huawei.com>, "David S. Miller" <davem@davemloft.net>, 
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, 
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev, 
 kvm@vger.kernel.org, linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
 linux-sound@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=763;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=rFl/6jLaFbtBJ+88FvM913PJ4x0vjfjJ4PxyPcL+Huc=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPeh3H1wemzDqhAibGWW67UcAFh1HQXSznqt
 bEbHHO+hSuJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT3gAKCRDBN2bmhouD
 1ypVD/9oHD41Qj1Sqk48VDcTdVES1YvXuuDoKvE3VyWtnVGYiNb60QFQKU80jN6oLcjshjDFPK4
 E9ATN58meESWX5UMMQUPAUThgndBeYYVkY6/3jhOvGFwreHYYn4O2qTukURJ1fI7ASP2fyP/3nW
 zr2qKyF4JGyI2ZhgGugQ9cVcNM8jB7rnMrOLR759/ggj4hB10TDUDnS/PYNpCk5h+ilyPgVaiZO
 lIM7Rl/97VdAbNVvm67vKkma6hKMUwEPWrsQLNcssIjRs4uK15fsCuM6ZDHjQn3u6K/mSnvitSE
 EyW7+cwNG6sSW5FoX1RnBwUYIC3+ayD8aiBjm3Qi9QmwHNo7xf/VXT7UowyM7ax8vMNyNSXkWi+
 hZhp1/+lVuMFTQzw8S4FzsvcPx5VCKOtoQizvNZKcMN0MhhXh8GSusi2u8XPahVqki02HVqEd8i
 p73OVWfBh6OSn+I/RaMqDWLtZAUQbLU69/ujHReW2gJzgZLukbsW9E4kEq3bWO/LuLvm6yFdril
 sg92y2CGcR4zgijh+/THpA9SRF8QURenYZM4NUWlLj3Ef+o54LpKRfdBDST0ZPeeiaaVneb8UWE
 LRajuEBICJqBAAAyaa4VGBaB7T+nodd9jR3MEMAWXS0ZnBrP1efJCygFMbepcVlv5jiKT282G0W
 t4D4aOVlYAW4RKQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/char/hw_random/virtio-rng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 7a4b45393acb..dd998f4fe4f2 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -245,7 +245,6 @@ static const struct virtio_device_id id_table[] = {
 
 static struct virtio_driver virtio_rng_driver = {
 	.driver.name =	KBUILD_MODNAME,
-	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
 	.probe =	virtrng_probe,
 	.remove =	virtrng_remove,

-- 
2.34.1


