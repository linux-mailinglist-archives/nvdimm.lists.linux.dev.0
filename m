Return-Path: <nvdimm+bounces-14247-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHPML4AWG2pV/AgAu9opvQ
	(envelope-from <nvdimm+bounces-14247-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 18:55:28 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 221EF60E9C5
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 18:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91DBE30960F8
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 16:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFF33438AE;
	Sat, 30 May 2026 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="EkyLz8mH";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KxuAD4kJ"
X-Original-To: nvdimm@lists.linux.dev
Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF78D3A8730
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159860; cv=none; b=r2syCJmNyN6ie9Z1o9IAjLSKpLbiTGM1tylxcFxLi86sCadIlriiCWB7JC/vgVhTHSU7OmhMEwhyQG5DoAMVFpeEbsX4aWpJRORq5+6bxIsfmwA7wtxpR61/kw3eG1LZh6ef3zR4HjsXGbfEjs2bAOK+nKQZJeG+lr0id5A22w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159860; c=relaxed/simple;
	bh=NhE++qdWxscKu5Z49H9qhvo6ogjYk0igD3AaYFFR/No=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=g3EJRRPk+InFNErNBq8WFL0veeNAqSlHSWFzM9rJbKjt2/IQ850smd/l4LhroCqW6ShC0USATkn8FTQPVhnt4ruKZtx5n0rwjmb91vQ04x1ZHbSG1bCmCpv7KvVzDupcqmhtvkWaPVQBWjj1TrL/i/vf8BrA5D0FLH4tRN+d7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=EkyLz8mH; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KxuAD4kJ; arc=none smtp.client-ip=54.240.48.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159857;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=NhE++qdWxscKu5Z49H9qhvo6ogjYk0igD3AaYFFR/No=;
	b=EkyLz8mH+D7p6ZlDYvgd/UuWesZitokxCPQZL1En7gnsEf+AanNcqXXQfI6R/hft
	1Www01wNxNlbLc67ENkSVVe0X+samWcbBnr0c3EnKeNKD9ekYn3zTjJdqIJlLr4TWtn
	6yUwE/s1OPiPgoYy1FoffwJ7rB1E7z8rcJ+8XPl4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159857;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=NhE++qdWxscKu5Z49H9qhvo6ogjYk0igD3AaYFFR/No=;
	b=KxuAD4kJuFRjHSKXiJqxbVhhb4xUM/Riy6VXogKJl0wDbJW9WqxI/XdiYv4Qteim
	0CFOJk+tdtY9OCDaC0PfYgohWeFduPDKWCusO6XDQmdj3Hpdb0aiRE+7vev9w/FBAqQ
	Gk8K0AIoP1bC5uw2cIT+rKgH4H/cg2FXLfbGmLaQ=
Subject: [PATCH V3 4/9] dax/fsdev: clear dev_dax->pgmap on probe failure
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 30 May 2026 16:50:57 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165053.6653-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAACHlQ
Thread-Topic: [PATCH V3 4/9] dax/fsdev: clear dev_dax->pgmap on probe failure
X-Wm-Sent-Timestamp: 1780159856
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cbc3fa-cdb45b69-de84-4cc0-8aeb-71d0673c1a9c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.48.181
X-Spamd-Result: default: False [0.75 / 15.00];
	CC_EXCESS_QP(1.20)[];
	TO_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-14247-lists,linux-nvdimm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 221EF60E9C5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <John@Groves.net>=0D=0A=0D=0AClear dev_dax->pgmap on pr=
obe failure for dynamic devices. After the dynamic=0D=0Apath sets dev_dax=
->pgmap, if a later probe step fails, devres frees the=0D=0Adevm_kzalloc'=
d pgmap but leaves dev_dax->pgmap dangling.  Subsequent probe=0D=0Aattemp=
ts would hit the "dynamic-dax with pre-populated page map" check and fail=
=0D=0Apermanently. Use a goto cleanup to NULL dev_dax->pgmap on error.=0D=
=0A=0D=0AFixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on cha=
racter dax")=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=
=0A drivers/dax/fsdev.c | 32 +++++++++++++++++++++++---------=0D=0A 1 fil=
e changed, 23 insertions(+), 9 deletions(-)=0D=0A=0D=0Adiff --git a/drive=
rs/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex dbd722ed7ab05..42aac7e952=
516 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=
=0A@@ -223,6 +223,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax=
)=0D=0A {=0D=0A =09struct dax_device *dax_dev =3D dev_dax->dax_dev;=0D=0A=
 =09struct device *dev =3D &dev_dax->dev;=0D=0A+=09bool pgmap_allocated =3D=
 false;=0D=0A =09struct dev_pagemap *pgmap;=0D=0A =09struct inode *inode;=
=0D=0A =09u64 data_offset =3D 0;=0D=0A@@ -253,6 +254,7 @@ static int fsde=
v_dax_probe(struct dev_dax *dev_dax)=0D=0A=20=0D=0A =09=09pgmap->nr_range=
 =3D dev_dax->nr_range;=0D=0A =09=09dev_dax->pgmap =3D pgmap;=0D=0A+=09=09=
pgmap_allocated =3D true;=0D=0A=20=0D=0A =09=09for (i =3D 0; i < dev_dax-=
>nr_range; i++) {=0D=0A =09=09=09struct range *range =3D &dev_dax->ranges=
[i].range;=0D=0A@@ -268,7 +270,8 @@ static int fsdev_dax_probe(struct dev=
_dax *dev_dax)=0D=0A =09=09=09=09=09range_len(range), dev_name(dev))) {=0D=
=0A =09=09=09dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve rang=
e\n",=0D=0A =09=09=09=09 i, range->start, range->end);=0D=0A-=09=09=09ret=
urn -EBUSY;=0D=0A+=09=09=09rc =3D -EBUSY;=0D=0A+=09=09=09goto err_pgmap;=0D=
=0A =09=09}=0D=0A =09}=0D=0A=20=0D=0A@@ -288,8 +291,10 @@ static int fsde=
v_dax_probe(struct dev_dax *dev_dax)=0D=0A =09pgmap->owner =3D dev_dax;=0D=
=0A=20=0D=0A =09addr =3D devm_memremap_pages(dev, pgmap);=0D=0A-=09if (IS=
_ERR(addr))=0D=0A-=09=09return PTR_ERR(addr);=0D=0A+=09if (IS_ERR(addr)) =
{=0D=0A+=09=09rc =3D PTR_ERR(addr);=0D=0A+=09=09goto err_pgmap;=0D=0A+=09=
}=0D=0A=20=0D=0A =09/*=0D=0A =09 * Clear any stale compound folio state l=
eft over from a previous=0D=0A@@ -301,7 +306,7 @@ static int fsdev_dax_pr=
obe(struct dev_dax *dev_dax)=0D=0A =09rc =3D devm_add_action_or_reset(dev=
, fsdev_clear_folio_state_action,=0D=0A =09=09=09=09      dev_dax);=0D=0A=
 =09if (rc)=0D=0A-=09=09return rc;=0D=0A+=09=09goto err_pgmap;=0D=0A=20=0D=
=0A =09/* Detect whether the data is at a non-zero offset into the memory=
 */=0D=0A =09if (pgmap->range.start !=3D dev_dax->ranges[0].range.start) =
{=0D=0A@@ -323,23 +328,32 @@ static int fsdev_dax_probe(struct dev_dax *d=
ev_dax)=0D=0A =09cdev_set_parent(cdev, &dev->kobj);=0D=0A =09rc =3D cdev_=
add(cdev, dev->devt, 1);=0D=0A =09if (rc)=0D=0A-=09=09return rc;=0D=0A+=09=
=09goto err_pgmap;=0D=0A=20=0D=0A =09rc =3D devm_add_action_or_reset(dev,=
 fsdev_cdev_del, cdev);=0D=0A =09if (rc)=0D=0A-=09=09return rc;=0D=0A+=09=
=09goto err_pgmap;=0D=0A=20=0D=0A =09/* Set the dax operations for fs-dax=
 access path */=0D=0A =09rc =3D dax_set_ops(dax_dev, &dev_dax_ops);=0D=0A=
 =09if (rc)=0D=0A-=09=09return rc;=0D=0A+=09=09goto err_pgmap;=0D=0A=20=0D=
=0A =09rc =3D devm_add_action_or_reset(dev, fsdev_clear_ops, dev_dax);=0D=
=0A =09if (rc)=0D=0A-=09=09return rc;=0D=0A+=09=09goto err_pgmap;=0D=0A=20=
=0D=0A =09run_dax(dax_dev);=0D=0A-=09return devm_add_action_or_reset(dev,=
 fsdev_kill, dev_dax);=0D=0A+=09rc =3D devm_add_action_or_reset(dev, fsde=
v_kill, dev_dax);=0D=0A+=09if (rc)=0D=0A+=09=09goto err_pgmap;=0D=0A+=0D=0A=
+=09return 0;=0D=0A+=0D=0A+err_pgmap:=0D=0A+=09if (pgmap_allocated)=0D=0A=
+=09=09dev_dax->pgmap =3D NULL;=0D=0A+=09return rc;=0D=0A }=0D=0A=20=0D=0A=
 static struct dax_device_driver fsdev_dax_driver =3D {=0D=0A--=20=0D=0A2=
=2E53.0=0D=0A=0D=0A

