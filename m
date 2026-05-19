Return-Path: <nvdimm+bounces-14058-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oG0GLWwgDGphWwUAu9opvQ
	(envelope-from <nvdimm+bounces-14058-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 10:33:48 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF97457A2F0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 10:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8729730C60FD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 May 2026 08:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E653E2740;
	Tue, 19 May 2026 08:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="sOq0q/Ht"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212F3E16B5
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179116; cv=none; b=mq87/qfjRqfKFn8lX7ujbLOQ2tzXB84HHgUpJ4SvNeUwOGG2sBeyvdjPxzZa0XFfNJus9+qza6vjcpzCWWCPB2R89silocl7eDYD7wzuCOX3oa4QaGA5X1neaIVMDbyEinCxU7KTf5AWWEjxSaN4RhPpssqECNJoTV+ypCloOZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179116; c=relaxed/simple;
	bh=GczDtyA7QqyhgpCt+uS5CB8iB1mmQPJ5p+3j3+yEVDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fhO7yqjZlQdbeiBMGhSc9/xeA2EYuGLpkJK4KnKPnTSkbrRE+Ek0gLwQvnUz8phU5ZxuuvCn74+bwI2sl9U0tI2Jdw3d6pTHMNkl/cZbVkyMJqlqGq6N6x1ERGGVrjbPwpChNPUJ7a9tZeL7nxm+OTVOtSHPNpfGLYi8IqQa6Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=sOq0q/Ht; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779179116; x=1810715116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GczDtyA7QqyhgpCt+uS5CB8iB1mmQPJ5p+3j3+yEVDU=;
  b=sOq0q/HtumZ4npXIQUfNtYB4yhf+8b6m+MuAAaZcqAHb2ju1kzdpylrS
   /5BVSG65K4WFjawgN6oqHU3vwW+YmYp0xJCxgh3sVl6/6ikjOEuC20qHj
   LWarIVNo/AQrDD2SMxGiIEtX+DHhjmtqEdSYh8LrDGIPslsuW2u3VHVTE
   huLm/Z5ByCYMpb5FJgPHUH/ln4E9i7Q4HfgCbYnQ/oA5fEg7nWkaU+/Rd
   8o7sIlPkTHl2yj9IwdEQqtKkWMCu3r6aJxUDTM8cwOqSigR5viM/lvYcG
   9OuKm1NUubooByNuWP1ooJehK/ZJDy2e+2Q066LakEXbDPEGukFAWTWZq
   w==;
X-CSE-ConnectionGUID: Y8KI7//7QJe+KveRCrwE/g==
X-CSE-MsgGUID: E1XnGl0DSa+ZCV3yScV83g==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="241098022"
X-IronPort-AV: E=Sophos;i="6.23,243,1770562800"; 
   d="scan'208";a="241098022"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 17:25:08 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 52FC142A313
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:25:07 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (az2uksmom1.o.css.fujitsu.com [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 055D21C04B01
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:25:07 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 6D5671800C07;
	Tue, 19 May 2026 08:25:05 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id B25F960A84;
	Tue, 19 May 2026 10:25:04 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: alison.schofield@intel.com
Cc: ardb@kernel.org,
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
Date: Tue, 19 May 2026 10:25:02 +0200
Message-Id: <20260519082502.18627-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <agX7LCdvy38_z4Pt@aschofie-mobl2.lan>
References: <agX7LCdvy38_z4Pt@aschofie-mobl2.lan>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14058-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomasz.wolski@fujitsu.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fujitsu.com:mid,fujitsu.com:dkim];
	DKIM_TRACE(0.00)[fujitsu.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: DF97457A2F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Alison,

>> How about using request_resource_conflict() so that we can offer
>> more description in the error message?

Thanks for the hint - I will add that in v2.

Best regards,
Tomasz

