Return-Path: <nvdimm+bounces-7284-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3F3846446
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 00:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 979B41F23B02
	for <lists+linux-nvdimm@lfdr.de>; Thu,  1 Feb 2024 23:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A939A47A72;
	Thu,  1 Feb 2024 23:06:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDF3CF5B;
	Thu,  1 Feb 2024 23:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706828812; cv=none; b=BE/yhWBSNmNZk6C6K23He3jVWKlvHlPFJ8Nq01lMKkKbstfNcLwPKhPAtZNAcCeQ4VjCMeCdVyrcnjUpvhFdyvWxrrkRuWUtiU6pyhRFeTTSrNZFLq4CpDKO6+j6l6Usth0YK3/eCV4P+T9qoQ96LBD5qOtJr2rI1zz11B9iGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706828812; c=relaxed/simple;
	bh=uwpMqP9zpqBLa5X6I9RTAUdIL9SGrKim2/2EKQ2twag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p0lMqR9FypDJ9hGk3NX5dR5s9EXsjBOXKoV30nV1EQGdKR39eHcBiTFYnqUpjKMv1TjwjOgaN5LJjsGEoFqQiszTAtDeTrGenGsj1O1OC4YFrSVrPAnn3WnOvsi3bnoY6q+AHrVTYF1M765VrWYGb3AJg2TH85VOcl1zt0PV/uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B0CC433C7;
	Thu,  1 Feb 2024 23:06:51 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: ndctl: Add support of qos_class for CXL CLI
Date: Thu,  1 Feb 2024 16:05:03 -0700
Message-ID: <20240201230646.1328211-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5:
- split out test to its own bash script. (Vishal)
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
through the CXL CLI list command.

A qos_class check as also been added for region creation. A warning is emitted
when the qos_class of a memory range of a CXL memory device being included in
the CXL region assembly does not match the qos_class of the root decoder. Options
are available to suppress the warning or to fail the region creation. This
enabling provides a guidance on flagging memory ranges being used is not
optimal for performance for the CXL region to be formed.

