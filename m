Return-Path: <nvdimm+bounces-14162-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JduL6GlFmoOoAcAu9opvQ
	(envelope-from <nvdimm+bounces-14162-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 10:04:49 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D965E0D06
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 10:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C7532300E2BC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 May 2026 08:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64B63B27C1;
	Wed, 27 May 2026 08:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="tIHTozK+"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BECC2C11F9
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 08:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779869085; cv=none; b=AXJzyC2vT1RSnNQGA+gOeSzm5DNIZvjmG3IRJNYP4nngsZFVmCfKBsOwsBlM7ARonzK8/34A1kGVSTSF940GQOXEZPWiROd88TxQ/8Ji9ScmOv6HjsNfxpiv306zgf/CKVRq47WCTe+jU4nR2Sg47Ln1MLm3Tfe7H0PS4Ubsduw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779869085; c=relaxed/simple;
	bh=HM9hWX6VnUHxs0n4+BlQjLc+c4PovxyWLIbZq+xbheo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kFA0a/nXw96XXSTmIeF2/RD9V/IPdImdtaQJGwmeTI/TIsdG+XQdtSAzjBgm4eoWvVZd0TkHk0Fgs55YLa1trvbnxTOqLJK6nJyt9nPhETc4hliDXuIOjPhreEhh+V+JZq/X8ZA9e6h3lidSIiMTrmgci6Hl/2wivlzlXB8CW5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=tIHTozK+; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779869084; x=1811405084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HM9hWX6VnUHxs0n4+BlQjLc+c4PovxyWLIbZq+xbheo=;
  b=tIHTozK+6q2xDcXmgc9wZXZONp+sfC1V8Y6p0jGFOrUynxTho9S5ZCBw
   G1mEQ0jJHgnLyhICUxuNvAfOJYt+cI1km70XIPPYvREl0gAwfi6ZmNvC1
   cs6+rOabyu1NDp6DC0tUPMmk3L4yoZdAY0Ujq3h7hB1hoTGnA8AAOT/E5
   GAQ9/wLMHrnRGiIkSrr4Kpymr5eiXJe5axaRnaVkQCT7kdO4yhkRdJSDL
   c3aezHP7F1btaZfScxqOJ+oW0QcBe6rXuQUKd3d/07kx+PKvP/AKqkTXa
   2kU4PtzJTMi+SOMyhLErWVCvVywfYomDcnqphf4rjsQ2Gv3jO+XwhdD5l
   w==;
X-CSE-ConnectionGUID: 3X9LlpeTRCaXiN0KYFVCaw==
X-CSE-MsgGUID: OaVwWPvcRImM4WOSwFYMkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="245252124"
X-IronPort-AV: E=Sophos;i="6.24,171,1774278000"; 
   d="scan'208";a="245252124"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 17:03:34 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 4E72542A33B
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 08:03:34 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id EF6811C4B503
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 08:03:33 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTPS id F400D1800A66;
	Wed, 27 May 2026 08:03:32 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id 51F49606D6;
	Wed, 27 May 2026 10:03:32 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: djbw@kernel.org
Cc: alison.schofield@intel.com,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	icheng@nvidia.com,
	jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	nvdimm@lists.linux.dev,
	smita.koralahallichannabasappa@amd.com,
	tomasz.wolski@fujitsu.com
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
Date: Wed, 27 May 2026 10:03:28 +0200
Message-Id: <20260527080328.12171-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <ec26d3de-d556-4ab9-a333-d69d1e6cdda7@app.fastmail.com>
References: <ec26d3de-d556-4ab9-a333-d69d1e6cdda7@app.fastmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[fujitsu.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[fujitsu.com:s=fj2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14162-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomasz.wolski@fujitsu.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fujitsu.com:mid,fujitsu.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	DKIM_TRACE(0.00)[fujitsu.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 61D965E0D06
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Dan & Alison,

Thanks for your remarks

>> Just report the request_resource() failure. This case does not warrant exporting request_resource _conflict(). Historically one driver can not mess with another driver's resource beyond conflict detection.
Do you think v1 of the patch is good enough or v3 is needed? (which in fact would be the same as v1)

Best regards,
Tomasz

