Return-Path: <nvdimm+bounces-14463-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xYCxCBj+NmrfHQcAu9opvQ
	(envelope-from <nvdimm+bounces-14463-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 20 Jun 2026 22:54:48 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2F76A9BA6
	for <lists+linux-nvdimm@lfdr.de>; Sat, 20 Jun 2026 22:54:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WjQh3qs5;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14463-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14463-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2828C301874D
	for <lists+linux-nvdimm@lfdr.de>; Sat, 20 Jun 2026 20:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8C823E35F;
	Sat, 20 Jun 2026 20:54:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B86640D59C;
	Sat, 20 Jun 2026 20:54:40 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781988881; cv=none; b=qDYFiX1qNrohZ9elb+7LVCVeNTblKVIr/+BkxfL5Pbs8K9+FBi5qavjOHnaWv+4o8waayNOWj2T4qRo4J+wnnnzR5r543dceJS5Y4ydMMBSPCZKKEwhpD1zknza/CKUyNp0f1qJh5ytYBXoKRhcU80PJkcsmIZbh15VdluUx6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781988881; c=relaxed/simple;
	bh=sqiWgj1rs8bD0Mg+ItWHWE/xMYLzoyvWrk6vgGiLxVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZITC3gHK/2k6r9v2HV4c77xD1jjEZckr5JOcheHsHYFlEyOcFcdcKuSMw4vIM7IseT3Yp2ufAIBbLOa5t4n3dzRt4vbX+GjBP407QZxLvbcqIifU+cpSysMIHSd9JDd76b/MjfgyGVoivLDqAOTvd+k+ywVFbXwzZe+BRFBByBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjQh3qs5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA906C2BCB0;
	Sat, 20 Jun 2026 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781988880;
	bh=sqiWgj1rs8bD0Mg+ItWHWE/xMYLzoyvWrk6vgGiLxVQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=WjQh3qs52nolg+UJXSQA4MaYyKrgJC+MD0e6viIsvzoTfLXxn7dvI7m3qMZ7URIAS
	 bmUhO661UhsYL3fGPQRbY1WaLl+k7twmUyRpmNC6ANbVE/7Ywu9pjsAPDAdVzGxhiC
	 Bua+OSTekgxoOGry3k8In4b/dCY2IAj6Swv0ps+8mAqWj9ysA99Ahdh7uMtaOobHXB
	 RxQzdJpDihwVBTjTKgiH304M7p/0oOfUKt3ZCpr3lXJT1JaU+Zm+PHQRWT6acpHjZK
	 C3MYFddVP95LwzYfqZjaSj12xL1d384VqVclEUTVHPO3/KN9VWfU6JrZllLZXL+5NK
	 1JGL0CltgV4BQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98804CD4F26;
	Sat, 20 Jun 2026 20:54:40 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 20 Jun 2026 15:54:39 -0500
Subject: [PATCH] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me>
X-B4-Tracking: v=1; b=H4sIAA7+NmoC/x3MTQqAIBBA4avIrBuYTPu7SrRInWo2JQoRRHdPW
 n6L9x7InIQzjOqBxJdkOY+CulLg9+XYGCUUgybdUqsJncEgOWK3msbV1uKgXW/8QMZTDyWLiVe
 5/+U0v+8HL7wcnmIAAAA=
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781988878; l=2964;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=dMEqUebt+fSrQCUWcbCd+vcAjwiYJq6rPAxYeIr65ao=;
 b=CziGNvNLLqPwryaor2yCzelXtrjLC6gyYvlxpHufLDdJ9+9ht7obykAFld35+c9Iz1l6Jh+c9
 dbzOberahf1Cu8Pk6UzIlu+l+Oquw8NtKhrh5b8iA87ssTUqc8SZCwF
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14463-lists,linux-nvdimm=lfdr.de,hexlabsecurity.proton.me];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lists.linux.dev:from_smtp];
	FORGED_RECIPIENTS(0.00)[m:dave.jiang@intel.com,m:djbw@kernel.org,m:ira.weiny@intel.com,m:vishal.l.verma@intel.com,m:linux-kernel@vger.kernel.org,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[devnull@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[hexlabsecurity@proton.me];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[devnull@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6F2F76A9BA6

From: Bryam Vargas <hexlabsecurity@proton.me>

The on-media namespace index field nslot is a u32 read from the DIMM
label storage area.  __nd_label_validate() bounds it against the config
area size, but sizeof_namespace_label() returns unsigned, so the product
nslot * label_size is evaluated in 32-bit and wraps modulo 2^32 before
the comparison.  A crafted nslot passes the bound and is then used as the
loop trip count in nd_label_data_init(), whose memset() walks off the end
of the config_size buffer: an out-of-bounds write.

The field is not trusted -- it comes from the medium, or from userspace
via ND_CMD_SET_CONFIG_DATA.  Evaluate the product in 64-bit so the bound
check is exact; conforming labels are unaffected.

Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
The check was safe when introduced: 4a826c83db4e ("libnvdimm: namespace
indices: read and validate") multiplied by sizeof(struct
nd_namespace_label), a size_t, so the product was 64-bit.  564e871aa66f
replaced that with sizeof_namespace_label(), which returns unsigned, when
the label size became a runtime value -- narrowing the product to 32 bits.

The sibling multiply in sizeof_namespace_index() uses an nslot derived
from config_size (nvdimm_num_label_slots()), not the on-media field, so it
cannot overflow and is left unchanged.

Reproduced with an out-of-tree module that mirrors nd_label_data_init() --
kvzalloc(config_size), the __nd_label_validate() bound check, and the
memset loop -- since the defect is the wrapped arithmetic into the memset,
not the DIMM-probe plumbing:

Build A (without this patch), nslot = 0x02000000, 128-byte labels:
    the u32 product wraps to 0, the index is accepted, and the loop's
    memset() writes past the kvzalloc'd buffer ->
      right of the config_size region -> panic.
  Build B (with this patch): the 64-bit product exceeds config_size, the
    index is rejected, the loop never runs -> clean.
  Control (legitimate small nslot): writes stay in bounds -> clean.

BUG: KASAN: slab-out-of-bounds, Write of size 128, 0 bytes to the
---
 drivers/nvdimm/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 4218e3ac4a2a..ec12ce72cfe2 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -202,7 +202,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 		}
 
 		nslot = __le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof_namespace_label(ndd)
+		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
 			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",

---
base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
change-id: 20260620-b4-disp-7f43b155-92b84c904c08

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>



