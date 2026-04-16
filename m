Return-Path: <nvdimm+bounces-13903-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AIxJeZn4WndswAAu9opvQ
	(envelope-from <nvdimm+bounces-13903-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 00:51:18 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D094C415618
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 00:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB4B8306494C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Apr 2026 22:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB9E35E95E;
	Thu, 16 Apr 2026 22:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HSPfyUfR"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB683330644
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776379663; cv=none; b=AdDqyaQDPN9ngraMWBe1rbht05DEvSkn7np6t301cXiSRm30Rb88q00HWlXwFwllRyDhNK1BDGLFNtm/s2CEN2CdB82ULiUl3n8U0FaP+2k10Vk7aT2IZOzHlJ5QGxUc9iGA/mRlxWoBqtOZs2SPNXqfMB24ut437k9FNsfE5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776379663; c=relaxed/simple;
	bh=C13Jb6Kbsy+FPShsH2lJidLemQxpasQcKiM9wp8dEYY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sN9sadzSR/e0TpQe/Jy6yDvbTfVDeWVxVVwFWqSQ8h7mbeY2TXuuKaIds09DfaMfE2WUwdOTZAZDsoC3NI87RJDVs8deJRWEnsjU/qDVPyWsAAnfvijH2rG1OdjA/crjhXHj3I42dDNYct5n057WSWcEU3PyhEY+/rEUxkaiI7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HSPfyUfR; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1776379660; x=1807915660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C13Jb6Kbsy+FPShsH2lJidLemQxpasQcKiM9wp8dEYY=;
  b=HSPfyUfRPyP+CnL3iAoWfhQTsEI1x3uxzm9/SPB5amErqdz0aEVzQ7/b
   Bjp+QCrNqOqkkySpqLbuEW3HdrMbSsZ8XCL1SDqMS0hi3SmKW8V5Z19Ek
   gDMlqsyOrxVLXb8AM9OYZATODgvYbh3azzPd3XfuV2zcpx3mi2mSSFFQl
   d945oNMM0nkoJ1P6TLTuMiGkLlzLAkqu+l9uv+9bP2H+iuCnLhrA9d/3K
   0rvIaBVfLzsq/C5jn/QwZjLHhv4ghk8hQhPp1oi1e59LWkshJnRR78Yxg
   aAXlMWxtcMezZWOZ6/q7lU+AJEv6vl/xEopw2aychsIxALSYMKS8Yza9D
   g==;
X-CSE-ConnectionGUID: m2hCuh+ySYmo0Hqv/63lfQ==
X-CSE-MsgGUID: KpjvPjfYTuC++L9a5UGgRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="236687115"
X-IronPort-AV: E=Sophos;i="6.23,183,1770562800"; 
   d="scan'208";a="236687115"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 07:46:30 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 60E2E1002804
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:46:31 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (az2nlsmom3.o.css.fujitsu.com [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 172D7861274
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:46:31 +0000 (UTC)
Received: from ubuntudhcp (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id 7B4CE1019066;
	Thu, 16 Apr 2026 22:46:29 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by ubuntudhcp (Postfix) with ESMTP id 1BAD8220477;
	Thu, 16 Apr 2026 22:46:28 +0000 (UTC)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: smita.koralahallichannabasappa@amd.com
Cc: alison.schofield@intel.com,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	bp@alien8.de,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	gregkh@linuxfoundation.org,
	huang.ying.caritas@gmail.com,
	ira.weiny@intel.com,
	jack@suse.cz,
	jeff.johnson@oss.qualcomm.com,
	jonathan.cameron@huawei.com,
	len.brown@intel.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	lizhijian@fujitsu.com,
	ming.li@zohomail.com,
	nathan.fontenot@amd.com,
	nvdimm@lists.linux.dev,
	pavel@kernel.org,
	peterz@infradead.org,
	rafael@kernel.org,
	rrichter@amd.com,
	terry.bowman@amd.com,
	tomasz.wolski@fujitsu.com,
	vishal.l.verma@intel.com,
	willy@infradead.org,
	yaoxt.fnst@fujitsu.com,
	yazen.ghannam@amd.com
Subject: [PATCH v8 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Fri, 17 Apr 2026 00:46:18 +0200
Message-Id: <20260416224618.12987-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[fujitsu.com,reject];
	R_DKIM_ALLOW(-0.20)[fujitsu.com:s=fj2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13903-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,kernel.org,amd.com,alien8.de,stgolabs.net,linuxfoundation.org,gmail.com,suse.cz,oss.qualcomm.com,huawei.com,vger.kernel.org,fujitsu.com,zohomail.com,lists.linux.dev,infradead.org];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[fujitsu.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomasz.wolski@fujitsu.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fujitsu.com:email,fujitsu.com:dkim,fujitsu.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: D094C415618
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Smita,

Tested on QEMU and physical setups - it worked as expected
(had to disable ACPI_PRMT/CONFIG_CXL_ATL on our physical system though)

Best regards,
Tomasz

Tested-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>

