Return-Path: <nvdimm+bounces-14057-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPD4NageDGrbWgUAu9opvQ
	(envelope-from <nvdimm+bounces-14057-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 10:26:16 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA3D579FD1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 10:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ACC7E307D684
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 08:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7AB328B71;
	Tue, 19 May 2026 08:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bOK36c44"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC83E0731
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178521; cv=none; b=ZRVqOjr0b74R/2koi0n3xIhpqIxf37dKsdMZcSHllY04A2MbeLi8+UfeXFjsTLznEGedPHQ0Ahy06w31yTfF0bXRVKDrZGB953i1XlrhT3pT63CuthGmuVLPDjWUmf3uBzw1xJxBEooHCNEs1aaIala8T5wnAkw4JCMRJLlDEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178521; c=relaxed/simple;
	bh=TJ8fpz1evDXICM3tkQS1KlJYrX6HFaEpbf6rZUzgB2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jyE6L4Pi0dKNQFR/s3p3poziHzMPD5QzqwWYm3H3F7RrDz6vk0gdq8igDNXXI9fyb8CrfaglFP6ECTRSD6lUCUEdW5ERuU84q4i2CWdY8tZ/TCte4sPYcXyqBfIcaSu6cMXuzlEDVWxvvPod22IpnPjH/5SV5x9fkehto44j4f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bOK36c44; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779178519; x=1810714519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TJ8fpz1evDXICM3tkQS1KlJYrX6HFaEpbf6rZUzgB2c=;
  b=bOK36c44Q3XmC1jYNoxmdOZqQU7hOaM03Z8I6Nfws4zy4WiST++8Khf5
   6RlvJn/vOiRmx0RR18ySmSFk0ZyL6WWmXzoXBBewSQwAIHQU/7XCgtujp
   WdhjJvnSlZQJUb7ZOh3IbsSkZ859dWSYfDlG59suHNAgy1bAAnLGJ9eE8
   Nxi7RvNIMOoSIn0Kosgd+BG29KKSb+R5aR60WDqfIfeZApae6x6iCpTZy
   6vXghYsn6A5zoUXjiJhgYd3QaXBLfQihe6xCRNHSdb0MgRUXRYn+lv9Zh
   sAdSPs2F82dloIzpZeHJZxqdRhC0ibmhfsvlr+z7lkc1+JhbV1ZEIf4EJ
   Q==;
X-CSE-ConnectionGUID: INwyIedsQ+CEYAOuKnbcrA==
X-CSE-MsgGUID: C+3Ixv15Rsq/8xwCLQ5njg==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="218782758"
X-IronPort-AV: E=Sophos;i="6.23,243,1770562800"; 
   d="scan'208";a="218782758"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 17:15:11 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id BB79B1C000A5
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:15:11 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (az2nlsmom4.o.css.fujitsu.com [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 6A3A8C03707
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:15:11 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by az2nlsmom4.fujitsu.com (Postfix) with ESMTPS id DF3772000292;
	Tue, 19 May 2026 08:15:09 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id 15594608BF;
	Tue, 19 May 2026 10:15:09 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: icheng@nvidia.com
Cc: alison.schofield@intel.com,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	nvdimm@lists.linux.dev,
	smita.koralahallichannabasappa@amd.com,
	tomasz.wolski@fujitsu.com
Subject: Re: [PATCH] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
Date: Tue, 19 May 2026 10:15:06 +0200
Message-Id: <20260519081506.17283-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <agWfgLxDeu_duejj@MWDK4CY14F>
References: <agWfgLxDeu_duejj@MWDK4CY14F>
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
	R_DKIM_ALLOW(-0.20)[fujitsu.com:s=fj2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14057-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomasz.wolski@fujitsu.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,fujitsu.com:mid,fujitsu.com:dkim];
	DKIM_TRACE(0.00)[fujitsu.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: DCA3D579FD1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Richard,

Thanks for your feedback

>> Did you run into any kind of error or even machine crashing from this ?
No, I haven't hit this error path in practice. On systems I've tested, the deferral logic 
in hmem_register_cxl_device() correctly drops ranges that CXL claims

>> btw, though I am not against the change, I don't think this is a fix, maybe you can consider to remove the Fixes tag.
Agreed, I'll drop the tag in v2.

Best regards,
Tomasz

