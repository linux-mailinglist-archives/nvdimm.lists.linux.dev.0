Return-Path: <nvdimm+bounces-4609-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A72455A57B5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 30 Aug 2022 01:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92E281C20942
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Aug 2022 23:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3FE6106;
	Mon, 29 Aug 2022 23:42:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2A26100
	for <nvdimm@lists.linux.dev>; Mon, 29 Aug 2022 23:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661816521; x=1693352521;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1CA/VXe1Tkqo/AK4Dr12mppaujMsFv8I2WgW47/QZVw=;
  b=CFVhWhiQCudRpi5r7pcnVMxsiCSXcP41ZeeQ0aMEsn2HAKy0rosDwnP2
   Jz5wMkxJ+v+9jLlzB1/KM6RWPOGI6HfMvbZslnmm2ZqLf5NGbXnpTxr2+
   qRy9iZNc55HUlm8jwqEuFdUE0+EnZLndEXwDf8ZabysXBKcyFRS+dOtqa
   w5SWkBTMmzdPMSvYmDZ33C+e2ElVEU9CgjQ7ht+b5qhbzD4/+1uJd2s/Z
   i/6Xh+XBoGC9jbkitns7naRRdOlrZktmTxd9UWuRJUIR0LWST04s7ANVK
   W8SDkfhTxmy6tb06SlNJy4WEIEHwM0n0iXzL9Ip/n1HbLAsY37cydlMRB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="358989944"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="358989944"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="588358105"
Received: from kmora1-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.213.169.48])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:00 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	corsepiu@fedoraproject.org,
	<linux-cxl@vger.kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/2] misc RPM / release scripts fixes
Date: Mon, 29 Aug 2022 17:41:55 -0600
Message-Id: <20220829234157.101085-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=540; h=from:subject; bh=1CA/VXe1Tkqo/AK4Dr12mppaujMsFv8I2WgW47/QZVw=; b=owGbwMvMwCXGf25diOft7jLG02pJDMm8fke/8G1w+aC+muO6qKtSwqz5HXIzzs1e9eJFZcDavZ07 X5oe7ihlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEPmow/C+8vfBFf57BO/ckybelvM YiPo7sM8+ul9B/s+qDb87OtfIM//Qq3std/ftD+5gTn9bU1CMtbJa7Xmsxb+roUzvGXl9TwgkA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a couple of fixes to the RPM spec to correctly claim ownership of
config directories, and updates to release scripts for meson.

Vishal Verma (2):
  ndctl.spec.in: Address misc. packaging bugs (RHBZ#2100157)
  scripts: update release scripts for meson

 ndctl.spec.in              |  8 +++++++-
 scripts/do_abidiff         | 14 ++++++--------
 scripts/prepare-release.sh | 24 ++++++++++++------------
 3 files changed, 25 insertions(+), 21 deletions(-)


base-commit: c9c9db39354ea0c3f737378186318e9b7908e3a7
-- 
2.37.2


