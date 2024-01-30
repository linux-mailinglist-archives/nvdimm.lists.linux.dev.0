Return-Path: <nvdimm+bounces-7256-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB4F843154
	for <lists+linux-nvdimm@lfdr.de>; Wed, 31 Jan 2024 00:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B553B1C225E7
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Jan 2024 23:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A28879949;
	Tue, 30 Jan 2024 23:35:32 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E46E7EF06;
	Tue, 30 Jan 2024 23:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706657732; cv=none; b=g6442ekTHdjjqOC8nxN31HDM3BEASsPFkFj7XgRuX6QS5bFSfSNjhDOSmwUTZgktNUNOh5LF7DsDe6eiAmjOnZnY/79pOgZ8aq3B9sYH2nAkANnVGK8OA3bh7pQKQlMt03Lq7QvdAaBa5H4gy3mBo6ns+4Du+mokCvgnJE06NjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706657732; c=relaxed/simple;
	bh=+mctNj/YEcYLFeXbNtadH4Z7+fsEywT23GI8gTUHXng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TgOzAUBwmyXQh0/zfnfKCqqAreuD0564U9MLEBzIzgw3uoOQNAZ2/vuCDGceXqMs6npZwFYcvNRx5Q2bVh7U9Nd/rALTIopXahur354b3unT213JoQaPpTqbaq7RkYVFOpFCbd0dmlCfjJz9qVswaBiA8IJsdIK6g3RCiprZxc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92636C433F1;
	Tue, 30 Jan 2024 23:35:30 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: ndctl: Add support of qos_class for CXL CLI
Date: Tue, 30 Jan 2024 16:32:40 -0700
Message-ID: <20240130233526.1031801-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:
- Update against changes in kernel from multi to single qos_class entry
- Add test in cxl-topology.sh (Dan)
- See individual patch log for details
v3:
- Rebase against latest ndctl/pending branch.

The series adds support for the kernel enabling of QoS class in the v6.8
kernel. The kernel exports a qos_class token for the root decoders (CFMWS) and as
well as for the CXL memory devices. The qos_class exported for a device is
calculated by the driver during device probe. Currently a qos_class is exported
for the volatile partition (ram) and another for the persistent partition (pmem).
In the future qos_class will be exported for DCD regions. Display of qos_class is
through the CXL CLI list command with -vvv for extra verbose.

A qos_class check as also been added for region creation. A warning is emitted
when the qos_class of a memory range of a CXL memory device being included in
the CXL region assembly does not match the qos_class of the root decoder. Options
are available to suppress the warning or to fail the region creation. This
enabling provides a guidance on flagging memory ranges being used is not
optimal for performance for the CXL region to be formed.


