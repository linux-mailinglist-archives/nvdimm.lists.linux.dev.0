Return-Path: <nvdimm+bounces-7641-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB30587085C
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Mar 2024 18:36:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FAED28278B
	for <lists+linux-nvdimm@lfdr.de>; Mon,  4 Mar 2024 17:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4E4612F8;
	Mon,  4 Mar 2024 17:36:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9690612EF;
	Mon,  4 Mar 2024 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573786; cv=none; b=bpkWQnxS8RXqW7lYa6aJ9T7W7c0JR3F3vZGgDExOVZ61ktlnrHTEZdsKNyUFDT0+23kaYx0UEjbz7D+dLM7UV7ZglM7TrN14X6ULqS99AMXZ0PXghuZGbmNTee13cVV9vDA225B6ZjhKMFFMJo6P/1667Vs+ZZb2NCBi2w6aVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573786; c=relaxed/simple;
	bh=cBXEGvlaoRIaEbVUo1jmhKuFkUNx0fedDYLpxTRgGCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=emDudOTNh9MzxDSz6FzxBR8HUZWuAYT9TSEkYAWhInAHxWurdHYhSH4aMNMAP0wDgE5oGl9g+iFlzgT+qy2hFryVQR3g7BU6XaTmElcOi0nMFB7SBvBIUgs4CaGRQ0lhPJYsqGRLwTcSNS/VnfOmsI6G5l9YaZNgKeF4/Y2Typ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75847C43394;
	Mon,  4 Mar 2024 17:36:25 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Subject: [NDCTL PATCH v9 0/4] ndctl: Add support of qos_class for CXL CLI
Date: Mon,  4 Mar 2024 10:35:31 -0700
Message-ID: <20240304173618.1580662-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Vishal,
With the QoS class series merged to the v6.8 kernel, can you please review and
apply this series to ndctl if acceptable?

v9:
- Rename cxl_region_qos_class_matches() to cxl_region_qos_class_mismatch() (Vishal)
- Rename ->qos_enforce to ->enforce_qos (Vishal)
- Rename json output qos_class_mismatched to qos_class_mismatch (Vishal)
v8:
- Move qos_class comparison to libcxl. (Vishal)
- Move check to validate_decoder(). (Vishal)
- Update test to pick decoder that will always work. (Vishal)
- Fix script style. (Vishal)
v7:
- Removed qos restriction flag entirely (Alison)
- Added check for invalid qos_class when doing json output
- Change -q to -Q (Vishal)
- Add qos_class_mismatched to region output for cxl list (Vishal)
- Add -Q test in cxl-qos-class.sh test (Vishal)
- Change verify behavior to only do qos matching with -Q (Vishal/Dan)
v6:
- Check return value of create_region_validate_qos_class() (Wonjae)
v5:
- split out test from cxl-topology.sh (Vishal)
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


