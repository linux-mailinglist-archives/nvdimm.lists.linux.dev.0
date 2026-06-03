Return-Path: <nvdimm+bounces-14302-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wDFSNaBsIGoI3QAAu9opvQ
	(envelope-from <nvdimm+bounces-14302-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 20:04:16 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F2963A618
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 20:04:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLkDK1n5;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14302-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14302-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5C773095CA9
	for <lists+linux-nvdimm@lfdr.de>; Wed,  3 Jun 2026 17:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BDEA3806D3;
	Wed,  3 Jun 2026 17:59:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCCD37FF70;
	Wed,  3 Jun 2026 17:59:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509552; cv=none; b=RBtfy506rw5FxwPWXKOnVlyF+EBiVNjTAtKd8oyK9E7mvs5hFcdphuwC6scC698jltpmmJTwjdhm+rSZAIi/G2qknD5zdz+f46cDidg1aMZVkjHkCOu1c6xK5n3oQrgrTgPZatpfVmzVOWqnx3y2G8EUl2XjCT6KLvc6wB65tg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509552; c=relaxed/simple;
	bh=zoFNHB1J8xmyYrha/t6eapnjffI2ALlN2EwppUHpzIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YBReLtoxdE0qTCes7M6ZaMUnrwbaUQ1fMCPCRcA0ynGeP2s4XedPLyR9NwbMGIo0wPLF5KtRThsCNnO8ouF/5T8qtYBgnPgxHSE2PUPwQTtjjrlxZ6I/TsuZZWHLZ4GwKnyavRFAVrhVwXnWcDxlrJZqUxwfHuvbk39Cay4HxRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLkDK1n5; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3BF1F00893;
	Wed,  3 Jun 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509551;
	bh=NfXMCDskTI3m8h7njOgKHv3dJExtbkBLtlu9xyvDT1o=;
	h=From:To:Cc:Subject:Date;
	b=BLkDK1n53VryVlBtzBy7187nQ8tPsPr4O5ceea+ZZ5n6TDuFxZOOQxFE/Lyfl4xre
	 JsBfZelmUPQv35gYXEJ0tswofaTrmkUEqNVprC/+TrPRc60JW0DhzGMPxzW27vMFnm
	 YkazC8ACLHz2Gx6BA08oDHraPYlH19uG10OSvAknZAjKsk6RbsTo3ZXQgMEMo5mpxW
	 LfNIlqcA2Vv6Q+apm3GR8WWr9+F1FBM1HSWOw0vPWl4tnaadJB9NR+TastkviK4t9v
	 YOohDoP8OwAlxQu3BEHhORx6bqlysJhkSKy8/0PxnlEphn6dknD6KuEAGmvbFZgUgK
	 ylbf2DvEV2MDg==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
Subject:
 [PATCH v2 0/4] ACPI: NFIT: core: Fix multiple issues related to concurrency
 and cleanup
Date: Wed, 03 Jun 2026 19:55:30 +0200
Message-ID: <5110904.31r3eYUQgx@rafael.j.wysocki>
Organization: Linux Kernel Development
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	CTE_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14302-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:linux-acpi@vger.kernel.org,m:djbw@kernel.org,m:linux-kernel@vger.kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:nvdimm@lists.linux.dev,m:alison.schofield@intel.com,m:chenxiang66@hisilicon.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[rafael@kernel.org,nvdimm@lists.linux.dev];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rafael@kernel.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,rafael.j.wysocki:mid,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 30F2963A618

Hi All,

This series is a replacement for

https://lore.kernel.org/linux-acpi/6000262.DvuYhMxLoT@rafael.j.wysocki/

and it addresses some additional issues discovered during the review
of the patch above.  Some of it is based on the sashiko.dev feedback:

https://sashiko.dev/#/patchset/6000262.DvuYhMxLoT%40rafael.j.wysocki

Patch [1/4] adds a NULL pointer check to prevent a possible NULL pointer
dereference from occurring.

Patch [2/4] fixes issues related to acpi_nfit_init() failures.

Patch [3/4] is a preparatory cleanup before the next patch.

Patch [4/4] addresses a possible deadlock during driver removal or
failing probe and missing NVDIMM device notifications from platform
firmware.

Thanks!




