Return-Path: <nvdimm+bounces-11672-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 463BAB7F595
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Sep 2025 15:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC02B3AAB2A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Sep 2025 13:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C9730596F;
	Wed, 17 Sep 2025 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UTKGaDJw"
X-Original-To: nvdimm@lists.linux.dev
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B731961B
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115843; cv=none; b=iOANM98m5nEq7Tp0e6rUzEOaGvNcYIJu+202bu40kJGcR7ccP+X/OBtCoScTUpfjeaoAQGrVCsizQGXp3zk8J2acH66TrGSiX9opZyOwefYbv5wzhiPjg5K06A8Yq//ThYwW6Q6rIhY7aK3YZ1qoyDmf+4I8OKugVagjhqQTCcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115843; c=relaxed/simple;
	bh=RkAsuDKxc8445mRlXvsnxqnd4Yo1V+gjETT/kjelF7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uZDmBv7wQr5psM6HRdbBp/LYtYTF722M2Xo+9NBpCr0yQdsAp7TWE6b0F7QYECtruX7oWyHH1X5SJ1T1hMGSEVeaU7M/9lnE4LnElS5R8/BG745n2poIkN5TuuAOKuuZyDnZhkI9rwR4jUb5Rta3UxxJJjI4xi7dIUTw+sqwwW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UTKGaDJw; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917133039epoutp04e44687b211edf89c05377379146e53d8~mFQqfrT2l2402424024epoutp04f
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917133039epoutp04e44687b211edf89c05377379146e53d8~mFQqfrT2l2402424024epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115839;
	bh=L8I4pczPLL+3fGYbV4VkM8e4qH7d3Y7IhMKieoHkqSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTKGaDJwo6oD7oaol5OXUqHLXJQiRQ4zrE+S5NQnJL3PUlWS+uPR1wFk2dWu5lVbO
	 1MlWw7mlg+wffKsbznF3pWGeg97Go4SNlzZBjk+z06vt3fNR5KTppIcLtE1UIN8FjP
	 W1HUweeazn+07HSgPQhWRfj7VVgmSbYdz9/4FA+8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917133039epcas5p11360ebf8a46a222e314ef3069f83145d~mFQp6BH5V0664606646epcas5p14;
	Wed, 17 Sep 2025 13:30:39 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cRfly2D12z6B9m5; Wed, 17 Sep
	2025 13:30:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133037epcas5p3c0681f2c381334fc70574a40250a8490~mFQoPPnev3265832658epcas5p3H;
	Wed, 17 Sep 2025 13:30:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133034epsmtip19dfb297d6ecf5f484acf96743154c98c~mFQlv8Qq60457804578epsmtip1T;
	Wed, 17 Sep 2025 13:30:34 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Date: Wed, 17 Sep 2025 18:59:25 +0530
Message-Id: <20250917132940.1566437-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133037epcas5p3c0681f2c381334fc70574a40250a8490
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133037epcas5p3c0681f2c381334fc70574a40250a8490
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133037epcas5p3c0681f2c381334fc70574a40250a8490@epcas5p3.samsung.com>

CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
Modified __pmem_label_update function using setter functions to update
namespace label as per CXL LSA 2.1

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c |  3 +++
 drivers/nvdimm/nd.h    | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 3235562d0e1c..182f8c9a01bf 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -924,6 +924,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 
 	nd_label = to_label(ndd, slot);
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
+	nsl_set_type(ndd, nd_label);
 	nsl_set_uuid(ndd, nd_label, nspm->uuid);
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
@@ -935,7 +936,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
 	nsl_set_dpa(ndd, nd_label, res->start);
 	nsl_set_slot(ndd, nd_label, slot);
+	nsl_set_alignment(ndd, nd_label, 0);
 	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
+	nsl_set_region_uuid(ndd, nd_label, NULL);
 	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, nd_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 158809c2be9e..e362611d82cc 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -295,6 +295,29 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 	return nd_label->efi.uuid;
 }
 
+static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *ns_label)
+{
+	if (ndd->cxl && ns_label)
+		uuid_parse(CXL_NAMESPACE_UUID, (uuid_t *) ns_label->cxl.type);
+}
+
+static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
+				     struct nd_namespace_label *ns_label,
+				     u32 align)
+{
+	if (ndd->cxl)
+		ns_label->cxl.align = __cpu_to_le32(align);
+}
+
+static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
+				       struct nd_namespace_label *ns_label,
+				       const uuid_t *uuid)
+{
+	if (ndd->cxl && uuid)
+		export_uuid(ns_label->cxl.region_uuid, uuid);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
-- 
2.34.1


