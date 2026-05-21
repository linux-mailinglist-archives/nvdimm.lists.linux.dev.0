Return-Path: <nvdimm+bounces-14087-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mE/rNi8iD2rPGAYAu9opvQ
	(envelope-from <nvdimm+bounces-14087-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 17:18:07 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E48D85A8260
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 17:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 11132305EF98
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 May 2026 14:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0703D3D00;
	Thu, 21 May 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9YefkF7"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C3C17557E;
	Thu, 21 May 2026 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372769; cv=none; b=EW6twEplMnvqXeMYbqXuud5Va7c2CkfzDOViS1p3XHzrh/Wq6rhvHLhlUYRmQMxPJ7hM1GOS0NqI4jlIl5LfKJxfFu9MxH6pgoJrECc/7IhnPJCIwIk1NlEnF9jZGL15WGchMVDMHnDU7LGz1tCIBjo4QGT760BUlF8b3l+IETQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372769; c=relaxed/simple;
	bh=NQEoAh5bDKJKSYpLsVWdhrI9W/7GDxBWah5OmP9M8UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZeRe8TJZy8E873rXRxPCoUUZVPG6fJLXbJvTzUwKgkBD0adprJ8X0MYXq7OZIDf1/SEmmKfklCdEW9sNDNJ0qSZOxm7N141NEupOk/bpSV04RT9DNNHiIt/4wkH6k28EDJxEhz9ABPPk+6cq7WK+mWjoZd5gHZc8Sr5arhuA4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9YefkF7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00481F000E9;
	Thu, 21 May 2026 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779372768;
	bh=u+Qs5jTgdFX08/ZfXI2WSu51gzdaUqkJN/r0v3qZgvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9YefkF7grgqgf/3LRJ7QH7DW7QaZ6/HI92/hnEDJkco0rfpsO/2jLZklNZDH/TKW
	 NexIZFKnjuCZe8+KFpYvWXDVM77LdbXMq0G7fuS2kkRGuTwL3f65R0BPQhQm4w5x4l
	 IulLHFIUaGma7ur1j18jloyJW3B4Jnf4dLyQIVtcWPunZgfPZgiM0XxYZ+b4005jc1
	 MRhkTMnwUAR1kTmTimF15guAL/4XrVkgLogX1th+CHrDnnbsbalCMfGUIMI5R/grG8
	 pXrZ68Sijf3q0fg7/MSAMo6E+DiNDFp/OIYPi4JFugePv5HhhqrD8GYo7L1sHxKLTh
	 g+2F3uARtMqnw==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hans de Goede <hansg@kernel.org>, Armin Wolf <w_armin@gmx.de>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 nvdimm@lists.linux.dev
Subject:
 [PATCH v1 02/17] ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
Date: Thu, 21 May 2026 16:01:16 +0200
Message-ID: <3048737.e9J7NaK4W3@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <4739447.LvFx2qVVIh@rafael.j.wysocki>
References: <4739447.LvFx2qVVIh@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTE_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux.intel.com,kernel.org,gmx.de,intel.com,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-14087-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rafael@kernel.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rafael.j.wysocki:mid,intel.com:email]
X-Rspamd-Queue-Id: E48D85A8260
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Now that devm_acpi_install_notify_handler() is available, use it in
acpi_nfit_probe() instead of a custom devm action removing an ACPI
notify handler installed via acpi_dev_install_notify_handler().

Also drop the explicit ACPI_COMPANION() check against NULL that is
not necessary any more becuase devm_acpi_install_notify_handler()
carries out an equivalent check internally and use ACPI_HANDLE() to
retrieve the platform device's ACPI handle.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/nfit/core.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9304ac996d41..5cab62f618c8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3298,14 +3298,6 @@ static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
 	device_unlock(dev);
 }
 
-static void acpi_nfit_remove_notify_handler(void *data)
-{
-	struct acpi_device *adev = data;
-
-	acpi_dev_remove_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-				       acpi_nfit_notify);
-}
-
 void acpi_nfit_shutdown(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
@@ -3342,22 +3334,12 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 	struct acpi_nfit_desc *acpi_desc;
 	struct device *dev = &pdev->dev;
 	struct acpi_table_header *tbl;
-	struct acpi_device *adev;
 	acpi_status status = AE_OK;
 	acpi_size sz;
 	int rc = 0;
 
-	adev = ACPI_COMPANION(&pdev->dev);
-	if (!adev)
-		return -ENODEV;
-
-	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-					     acpi_nfit_notify, dev);
-	if (rc)
-		return rc;
-
-	rc = devm_add_action_or_reset(dev, acpi_nfit_remove_notify_handler,
-					adev);
+	rc = devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
+					      acpi_nfit_notify, dev);
 	if (rc)
 		return rc;
 
@@ -3388,7 +3370,7 @@ static int acpi_nfit_probe(struct platform_device *pdev)
 	acpi_desc->acpi_header = *tbl;
 
 	/* Evaluate _FIT and override with that if present */
-	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
+	status = acpi_evaluate_object(ACPI_HANDLE(dev), "_FIT", NULL, &buf);
 	if (ACPI_SUCCESS(status) && buf.length > 0) {
 		union acpi_object *obj = buf.pointer;
 
-- 
2.51.0





