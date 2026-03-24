Return-Path: <nvdimm+bounces-13696-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YAttNn7ewWnxXQQAu9opvQ
	(envelope-from <nvdimm+bounces-13696-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 01:44:46 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 402062FFEE1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 01:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB46131019EC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 00:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E109313298;
	Tue, 24 Mar 2026 00:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="o0Wl3KSJ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="m24+E6mc"
X-Original-To: nvdimm@lists.linux.dev
Received: from a8-40.smtp-out.amazonses.com (a8-40.smtp-out.amazonses.com [54.240.8.40])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB330B51D
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312731; cv=none; b=g665MNWlkCeW1nPlw1ITVQkr1vRqvheotyHvmxnoz+jZG1EgXkjKRNsCnOulhVuVqw4DqMbhn8Chsdam+vJ6jzwTLKZGTiU/kUP0unwKd5wTE5stiV4lRf5QoxHxduN3wDG6FXM4EkygJ4dJQtEzkJKE0G479d1HOUxpiRyAar0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312731; c=relaxed/simple;
	bh=+ozPvkfHB51tU0Cm/zY8s6uhLjVwAvzitKIS09ao+TM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=iHdrxvJVZsOGnEuadPb12LdXf77OrnzFoiFT6RKacyOVPqYUpvnUSG5JgJAG2p9U5oTAvHKJ2WdJtmWdWZXb5+LCKaxg5F0/KRWf3iogaZZY28nddzBsOW1MbeHA0N5Hf0vN8w7Uy9ED9RgcZVXpdaeQ54hQz9AyAhI6TXWY6yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=o0Wl3KSJ; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=m24+E6mc; arc=none smtp.client-ip=54.240.8.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312728;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=+ozPvkfHB51tU0Cm/zY8s6uhLjVwAvzitKIS09ao+TM=;
	b=o0Wl3KSJP1IgjNzxg9cn0P6U8xKA71317YLPLIgXv9DG8qpkjoVAGium55d9jUQu
	21h7yXKzqk8gx7cyLvYTtjbWc3NnUeuJbXmQD0HIbVJJ0PiFfAa6+dQu2BHguHNdiLB
	CLJfN8KND52nydcLIXPyLVsx3qtMjQcCdF/jXIFA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312728;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=+ozPvkfHB51tU0Cm/zY8s6uhLjVwAvzitKIS09ao+TM=;
	b=m24+E6mceGg2a4fxNrSg6OeuhQ7bihN+RlTxtWzvFuIDjDDuQotfrBL6sSNgWpkC
	YasAKNk0taG0d7k9mlSGaO1oGroOdqcx+0IP8gt+HiOmN5yuY3nbsACzWLuN7e76cLR
	IgOxMVXsoyXZ6j7/6fJ6e+9GaEAv6lhmYvLzLkUM=
Subject: [PATCH V9 4/8] dax: Save the kva from memremap
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>
Date: Tue, 24 Mar 2026 00:38:48 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
References: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com> 
 <20260324003833.5027-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyaT6kMwSdwXRx+HFn8jHvAjuA==
Thread-Topic: [PATCH V9 4/8] dax: Save the kva from memremap
X-Wm-Sent-Timestamp: 1774312727
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d47a813-6b74d7e9-5171-4382-bfa5-67bf9667c62a-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.8.40
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_FROM(0.00)[bounces-13696-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[41];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev,groves.net];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[email.amazonses.com:mid,intel.com:email,jagalactic.com:dkim,amazonses.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,groves.net:email]
X-Rspamd-Queue-Id: 402062FFEE1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <john@groves.net>

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 2 ++
 drivers/dax/fsdev.c       | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..7a3727d76a68 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -69,6 +69,7 @@ struct dev_dax_range {
  * data while the device is activated in the driver.
  * @region: parent region
  * @dax_dev: core dax functionality
+ * @virt_addr: kva from memremap; used by fsdev_dax
  * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
@@ -83,6 +84,7 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 8b5c6976ad17..c75478d3d548 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -121,6 +121,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
+	u64 data_offset = 0;
 	struct cdev *cdev;
 	void *addr;
 	int rc, i;
@@ -196,7 +197,6 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
 		u64 phys = dev_dax->ranges[0].range.start;
 		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
-		u64 data_offset = 0;
 
 		if (!WARN_ON(pgmap_phys > phys))
 			data_offset = phys - pgmap_phys;
@@ -204,6 +204,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
+	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.53.0


