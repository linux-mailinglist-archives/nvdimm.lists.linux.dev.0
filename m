Return-Path: <nvdimm+bounces-14054-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGPsIWX7C2r2SwUAu9opvQ
	(envelope-from <nvdimm+bounces-14054-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 07:55:49 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E04BD577A48
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 07:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72FCD305933C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 05:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4043A34FF78;
	Tue, 19 May 2026 05:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="ExpCegpr"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B17032D42B
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 05:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779169835; cv=none; b=Tb2GKR8SBfzb0uL1guKyyxRX/S/+IysC+qQ+j4eEsMFrJRgSy8ICdY0s4hizjlxT047bwVL0ea6VSDjYcYEdHQHVM5KYKDTA8OKNN5eqWhwnc6y/HbBBWazi2rlTxBzefjgn9TZpZ0pTsm4bYqX9EDHNTHnQPd0wtwFtu8wK++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779169835; c=relaxed/simple;
	bh=R/tnHUko7D+r3pgXbo43DR9BDen0uTM6J+JkfW2aJ2g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=cSPSmpgjMajE/DvG2pUGNjeCAaKSu9gQ2KnymgOOXL5gx/MQ7et1bnW0NE5If3l1iYo16fAg+0GLVgzQZIlnjnRQqwiGbtafeBIPFeNAPj6PMhLH8sMvbv71+jCVeiIpHd7UCyImsmNB/WbGpDNnIYp9/XozEbk9HfuxM8Mi4X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=ExpCegpr; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-83ec36a13e9so1354001b3a.0
        for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 22:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1779169830; x=1779774630; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tR5Snb8/Kee/sNXevElfs1t3MackxeJDCbbiIWdetnk=;
        b=ExpCegpr7U2aCr5L/3+EDJsAU8EY3LacCiOq64dq1fzODPM0Z8iSuRrItee0bfiGqF
         h9mLqg/FtGt1yAtCA5MW6n1MmG11p5U4fIq/g1I3hWObDMMeyWIwUKWRygKRf2fbf2SX
         nnlGmziwbrZcW78oq19Q0O2j4fGwgJ9kVUGjBBc+3j1zZYtFbPxXtSk0oaDBcwdWi1Ap
         Y1LGBTfWMaKBSQ3067qXcdZqu8Of5QuPC5bJMnNe6JYsEe9GqzqfHHaa4aW+TO9x5vu4
         RK6gUtsCo6PbmdiMuUs6d9dFAW6T/wL2P1DLFTtolg+2Pketv60IEtFK7YKLR9wxYtM7
         +jHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779169830; x=1779774630;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tR5Snb8/Kee/sNXevElfs1t3MackxeJDCbbiIWdetnk=;
        b=BtnBZLKtXs+k2jIMh9LxFymK4iw/XoX9yAkSZg4VoiyW9VMs9p0nQo4wWc4UI7wLJL
         8pe7B3ZZr2O2GtpAcdrBYcoLJJa5JYfKw3KYlb+gRe40HKkwP0VVkxEEy8VmxbD7hh0V
         ZDjyektAJeErfNnHlDJdo+txn6/k8QRpCprOhd3u/GCH9WHKd4TI2Oj51gxmJ4DBlXhf
         3xM98XaGqRIOEtbRGaCV4/oZz1gAREx6/vxmGYg2n5TfIZzBqFaBoT2m4/FZSz7Mh4zh
         Qu0JTkTA+QNkkq7PVS6MN1dKS6lQoaEyVMD2PdWpaV4eEb88qkZa6lRRYD4CnIFrrjUT
         /PWQ==
X-Gm-Message-State: AOJu0YwZ8S1bQ3kafC/uUYfhtYNWRepPSeJ5UPK5qZZ2wr+w9yiSUB6g
	SvfBAkt1cDqY5WIW+OxLvl69G3j5cOv2/i0p+PSbDuSGhL8S4m/QzN81ww2HcKRHZcI=
X-Gm-Gg: Acq92OEHQ5YyAVFKsJ9OUQa/sez1kpFrfCVUvdnEjHhLuUBJBvaRib1Q8UePByh5wly
	geyfl6/0W9rX2A5kCkfoDiIhjyuqbhP+wMj8GMz+2aKVaJJiPlIU4mnwiNl7/GTw/ENfgeml4jL
	PM1njOr64Xtvm0D9jSu9t8uhj206JRseSObj27m3miaF38mDnfInuXkCdXs9ezd4JvybkpMEtET
	oTSsHPRLa8LZfHKUz3rZ/AWXZrGpnXXIfU+4jmOL6LtEA0sUibWLnQ3seuyMQ0CxOa+sAfppioq
	gURQXWdVXrrj2Rdjj+OVoEcHHrF+WD4GMDIYfFIwkHbTNCdQ4PznMtqz+G/LrefsZRwMTmsTwal
	Y+gPk3bf0NNVd456H/bpBDNInUAf/yONW0g4NVYPtULs9RrJcvnLKIrlUsH9lZihsR6rSSb/5IK
	MTMKzve18/Q3+bgo+Ca2+FzQbh27vridEkGipSyvKS3nJQid5cdhqB5NXIk3o1jl/CPvsgvRQwa
	spMN8dzFuq2MKq/0G1IAbPkE3PnWlkYiLZl2+DDmjnGC9GpaxmYK4M=
X-Received: by 2002:a05:6a00:90aa:b0:829:8c08:d1f4 with SMTP id d2e1a72fcca58-83f33ccd856mr18535467b3a.39.1779169830165;
        Mon, 18 May 2026 22:50:30 -0700 (PDT)
Received: from [127.0.1.1] ([103.158.43.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm16818807b3a.1.2026.05.18.22.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 22:50:29 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Subject: [PATCH 0/2] nvdimm/btt: fix a few memory leaks
Date: Tue, 19 May 2026 11:20:11 +0530
Message-Id: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABP6C2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0NL3byylMzc3JzUxOxiXUPDNBODRJPENGOjRCWgjoKi1LTMCrBp0bG
 1tQDWZ/BoXQAAAA==
To: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Abdun Nihaal <nihaal@cse.iitm.ac.in>
X-Mailer: b4 0.13.0
X-Spamd-Result: default: False [-1.56 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[cse-iitm-ac-in.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[iitm.ac.in : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[cse-iitm-ac-in.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-14054-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nihaal@cse.iitm.ac.in,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cse-iitm-ac-in.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,cse.iitm.ac.in:mid,iitm.ac.in:email]
X-Rspamd-Queue-Id: E04BD577A48
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The following two patches fix memory leak issues in error paths in the
btt_init() and discover_arenas() functions.

- nvdimm/btt: fix potential memory leak in btt_init()
- nvdimm/btt: fix potential memory leak in discover_arenas()

Compile tested only. Issue found using static analysis.

Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Abdun Nihaal (2):
      nvdimm/btt: fix potential memory leak in discover_arenas()
      nvdimm/btt: fix potential memory leak in btt_init()

 drivers/nvdimm/btt.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)
---
base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
change-id: 20260519-nvdimmleaks-11f40a4af32a

Best regards,
-- 
Abdun Nihaal <nihaal@cse.iitm.ac.in>


