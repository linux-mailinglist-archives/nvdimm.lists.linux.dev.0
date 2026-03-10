Return-Path: <nvdimm+bounces-13574-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLCONgeFr2lvaAIAu9opvQ
	(envelope-from <nvdimm+bounces-13574-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 03:42:15 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32AE6244491
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 03:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D8F0304C977
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 Mar 2026 02:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF1D3A9620;
	Tue, 10 Mar 2026 02:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UUTZF9j8"
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7369533DEC2
	for <nvdimm@lists.linux.dev>; Tue, 10 Mar 2026 02:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773110497; cv=none; b=JyW2PY/NKY5M4saRK4RCSvTr/8tjbhLvcBY2MoYMXYsu6Lpd+tlUbvq+SxIZB55l2s12XZix1dpJBJcs73jMeTdMiJCcIGQ6uGVGtERpNeBQ9qER5bOd8qSRVtOhEAeWq/8iOdS/5nJjf3uNM7WQ/W0sX8ZYSXCIqltTQdRoNnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773110497; c=relaxed/simple;
	bh=pM+FoS81WOcr5yKq2Pb2RdxqH9dz2XRct0H73QCPefo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aMLFaZzqP/82U6nXpT7+XdJ6HHPyPGACamgSGQxIVNupinCGgJpIUkh/qdugysFngRiIOnV30AYzAN8zPyW0cQY8K+mWt+p6B/BfqIGjQj1anN6NDh77SSa4FZMKmsG9FiZXl5zSAZEg4ljhZCjZHUugnL/iXiAd+g+qx3jrg7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UUTZF9j8; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773110492; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=o3CX2Sg3PoU2AFf6axIZF6t45CRA6GKKu9tSLCakU40=;
	b=UUTZF9j8Nbm+jUAKoKi2tTUoXmhEbZinq1+N1oS1lfEb8xBTbCW1AMb3j+9dgOpLCC54ePnMTz2xKEfnzHPIXC+8Lvou6gvzUOKb5ZRADilnVoYTXmc5hFWaP5H2D49hpijI28z/KMtIumj23KDCm7S9epciDaIBqXfYwEo4GpE=
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X-eAS8E_1773110481 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Mar 2026 10:41:32 +0800
From: cp0613@linux.alibaba.com
To: ishal.l.verma@intel.com,
	alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH 0/2] ndctl: Fix build issues when fwctl is disabled
Date: Tue, 10 Mar 2026 10:41:00 +0800
Message-ID: <20260310024102.25682-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32AE6244491
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13574-lists,linux-nvdimm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

From: Chen Pei <cp0613@linux.alibaba.com>

This patch series addresses two closely related build failures that
occur when the fwctl feature is not enabled in the build configuration
(-Dfwctl=disabled).

The patches fix these problems by:
1. Updating the stub function signature to match its actual usage.
2. Conditionally including fwctl in test dependencies only when enabled.

These changes ensure that ndctl builds cleanly regardless of the fwctl
build option.

Chen Pei (2):
  ndctl: Fix missing key_type parameter in ndctl_dimm_remove_key stub
  ndctl/test: Fix meson configuration error when fwctl is disabled

 ndctl/keys.h     |  3 ++-
 test/meson.build | 31 ++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.43.0


