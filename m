Return-Path: <nvdimm+bounces-14404-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ZCcNAuvzKmrbzwMAu9opvQ
	(envelope-from <nvdimm+bounces-14404-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:44:11 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A7C6741C6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 19:44:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=jagalactic.com header.s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq header.b=pKVp7xc6;
	dkim=pass header.d=amazonses.com header.s=224i4yxa5dv7c2xz3womw6peuasteono header.b=Ul3MTdnr;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14404-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14404-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=jagalactic.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E42A3367336E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jun 2026 17:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1303C4A3409;
	Thu, 11 Jun 2026 17:32:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from a10-27.smtp-out.amazonses.com (a10-27.smtp-out.amazonses.com [54.240.10.27])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985648A2D0
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:32:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199170; cv=none; b=Fwr7E9jyG0R90p7l/fZ/gf1zUySJdqZ6/zjnNz8aeYSBhK93XpTE5STwKk7lRUhM6DZ3855m3hd3qIqdKxlVMGe9NXyUo1aXPbhHGiRj2lBpBg5ANqTA85ZxofS7+lpuCRgIaoSnkHET2UdLnlzci0MZbc835APQg/dEhDeNDvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199170; c=relaxed/simple;
	bh=JGEaB23H0mEnrU3LNgJnTu6D3rRBvSNFesI6+AAND80=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=WhMpSdWm+lhTJaZCu2gl3STsb97zp/8NTjNOZ7AYNjR+hpJ3Fk9ozjU2ZQ49F0YREnS3oErhf8Y0IGWhUphqJzrQ2iFO2LIMQsGcXbgIiy2NGyt2A/drMZ67Nc7jwoNTHKxT0lF0/SYqASuRkE4VeEgaeOj5m6aOVWELIke8tbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=pKVp7xc6; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Ul3MTdnr; arc=none smtp.client-ip=54.240.10.27
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199165;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=JGEaB23H0mEnrU3LNgJnTu6D3rRBvSNFesI6+AAND80=;
	b=pKVp7xc6BkvNJbFCL31gIB7CfXwHvz3hw+eeNmCWz8i91skBsC4Yc0xLEPs2LPXL
	QuXzIW9IJakwyLktAIDjJjx2JUTb+B22q93FUmTarTSxoBkU2M5yL5LRdDD9PZjQuAS
	EiTHk8zbx1LprQaohkX3VTH3UD39xSLAOBAtDpjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199165;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=JGEaB23H0mEnrU3LNgJnTu6D3rRBvSNFesI6+AAND80=;
	b=Ul3MTdnrw7rNQzl0EWz3uNHF4WZZlRsto9Mhq85JH4xGo3t2sYd0IzUwo9Msu82n
	Tf4OY/DYR4tN/nGp3uUqRV3u8e15uc2zykZePCnDg3hv6Ph1aGtnHeRoV9EnkpLLGLW
	dnZuFEF+nZBfXD+v650Ila33DYtUpPGZ4m4g90FM=
Subject: [PATCH V5 7/9] dax: read holder_ops once in
 dax_holder_notify_failure()
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
	=?UTF-8?Q?Richard_Cheng?= <icheng@nvidia.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Thu, 11 Jun 2026 17:32:45 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
References: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com> 
 <20260611173240.66020-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+chPcdwnZtLKT8WXyri1Y9Lr/w==
Thread-Topic: [PATCH V5 7/9] dax: read holder_ops once in
 dax_holder_notify_failure()
X-Wm-Sent-Timestamp: 1781199164
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7be595f-5045353d-86b9-49fd-b1ca-fbb40c22d06c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.10.27
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FORGED_RECIPIENTS(0.00)[m:John@Groves.net,m:djbw@kernel.org,m:jgroves@micron.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:willy@infradead.org,m:jack@suse.cz,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:miklos@szeredi.hu,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:jic23@kernel.org,m:nvdimm@lists.linux.dev,m:linux-cxl@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:icheng@nvidia.com,m:john@groves.net,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-14404-lists,linux-nvdimm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EXCESS_QP(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[jagalactic.com:dkim,jagalactic.com:from_mime,email.amazonses.com:mid,lists.linux.dev:from_smtp,groves.net:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,nvidia.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 53A7C6741C6

From: John Groves <John@Groves.net>=0D=0A=0D=0Adax_holder_notify_failure(=
) reads dax_dev->holder_ops twice without=0D=0AREAD_ONCE() -- once for th=
e NULL check and once for the indirect=0D=0Anotify_failure() call. A conc=
urrent fs_put_dax() or kill_dax() can clear=0D=0Aholder_ops between the t=
wo reads, so the check can observe a non-NULL=0D=0Apointer while the call=
 dereferences NULL.=0D=0A=0D=0AFetch holder_ops once into a local with RE=
AD_ONCE() so the NULL check and=0D=0Athe indirect call observe the same v=
alue.=0D=0A=0D=0AFixes: 8012b86608552 ("dax: introduce holder for dax_dev=
ice")=0D=0ASuggested-by: Richard Cheng <icheng@nvidia.com>=0D=0ASigned-of=
f-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c | =
11 +++++++++--=0D=0A 1 file changed, 9 insertions(+), 2 deletions(-)=0D=0A=
=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/super.c=0D=0Aindex 2=
5cf99dd9360b..6b5ee6589e39b 100644=0D=0A--- a/drivers/dax/super.c=0D=0A++=
+ b/drivers/dax/super.c=0D=0A@@ -303,6 +303,7 @@ EXPORT_SYMBOL_GPL(dax_re=
covery_write);=0D=0A int dax_holder_notify_failure(struct dax_device *dax=
_dev, u64 off,=0D=0A =09=09=09      u64 len, int mf_flags)=0D=0A {=0D=0A+=
=09const struct dax_holder_operations *ops;=0D=0A =09int rc, id;=0D=0A=20=
=0D=0A =09id =3D dax_read_lock();=0D=0A@@ -311,12 +312,18 @@ int dax_hold=
er_notify_failure(struct dax_device *dax_dev, u64 off,=0D=0A =09=09goto o=
ut;=0D=0A =09}=0D=0A=20=0D=0A-=09if (!dax_dev->holder_ops) {=0D=0A+=09/*=0D=
=0A+=09 * Read holder_ops once: a concurrent fs_put_dax() or kill_dax() c=
an=0D=0A+=09 * clear it. Without the single fetch the compiler could relo=
ad=0D=0A+=09 * between the NULL check and the call and dereference a NULL=
 ops.=0D=0A+=09 */=0D=0A+=09ops =3D READ_ONCE(dax_dev->holder_ops);=0D=0A=
+=09if (!ops) {=0D=0A =09=09rc =3D -EOPNOTSUPP;=0D=0A =09=09goto out;=0D=0A=
 =09}=0D=0A=20=0D=0A-=09rc =3D dax_dev->holder_ops->notify_failure(dax_de=
v, off, len, mf_flags);=0D=0A+=09rc =3D ops->notify_failure(dax_dev, off,=
 len, mf_flags);=0D=0A out:=0D=0A =09dax_read_unlock(id);=0D=0A =09return=
 rc;=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A

