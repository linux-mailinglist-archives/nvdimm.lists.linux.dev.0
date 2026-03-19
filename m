Return-Path: <nvdimm+bounces-13633-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM7NObj4u2llqwIAu9opvQ
	(envelope-from <nvdimm+bounces-13633-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 14:23:04 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8572CBE30
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 14:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4AE71304B5C4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 13:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59973C345F;
	Thu, 19 Mar 2026 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Luq322gQ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Z8zEk/7M"
X-Original-To: nvdimm@lists.linux.dev
Received: from a48-182.smtp-out.amazonses.com (a48-182.smtp-out.amazonses.com [54.240.48.182])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CD43A4526
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773926419; cv=none; b=YHus5k/iHtoPqerwCxpzS4VW8jwHj3NsBq19wlb9J4g1HTX+wPcljKT5LpzPhH5b01Lhft+uRKYSeiGC12PGh2iGpEGiUTUPCm1Z6RQn49KUr/PK2m/tm/cb4gxeFcRggbjA+ercVOof10FfaTCf5G7hkbBK+S7tnFHC5uXrMjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773926419; c=relaxed/simple;
	bh=3P1DJ3PxyuLI1lMtCqf3yEm20zZ5+pdmyAoAEVyDjtA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=HuLchfkodM2ZLgq61wrVHeP6jiCd4PeW+S0OlyM43EIqvygG14QDtpmGRF+pkev88xYTkDYEbF6jvIgR8B7s7ApBl0Te4SoceuJRIAsNs2FnmwBjSmDsCWo8toDDRYsZsIco+RvXNhH408d6XguNeH88i7k4voWu5PDXwtnuhBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Luq322gQ; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Z8zEk/7M; arc=none smtp.client-ip=54.240.48.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1773926417;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=3P1DJ3PxyuLI1lMtCqf3yEm20zZ5+pdmyAoAEVyDjtA=;
	b=Luq322gQ9ue7aqAEMLGHbzm01Qc8HL4tXw4s1fEQmYpJKvFKLkzwJBnPTlsdqV9J
	hv4WCUAU7ctsK9VUvCQ28BGLAbvtX+zQFjY181dCC4D4Obf8ZoBC+DZnHGdsIEBHBzt
	5riIlRfJ5JCcnL+FfpB1TlRGYMBWvnYP3ONKDsNg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1773926417;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=3P1DJ3PxyuLI1lMtCqf3yEm20zZ5+pdmyAoAEVyDjtA=;
	b=Z8zEk/7MpmHxsMh7QEQ0SzPvM+AbbHbZMCkZlezjvP7eC/ONVBeao6Ht9yVa69g3
	DNKfv5VIMEcgJiNJNAHU21ej1gGhfH0/sHJYpQxaDrfWcunv0QVa/twLTfLddx72AzP
	mRSAgbZOQhemyk1OUDa5vPJrxJX2sajydwh+CGi8=
Subject: [PATCH V8 08/10] famfs_fuse: Add DAX address_space_operations with
 noop_dirty_folio
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Thu, 19 Mar 2026 13:20:17 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260318203054.4344.fuse@groves.net>
References: <20260318203054.4344.fuse@groves.net> 
 <20260319132002.13463-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHctz+ZMjBZ3RwkQ1uhcQrmTMqILwAAVQgdABjhqxM=
Thread-Topic: [PATCH V8 08/10] famfs_fuse: Add DAX address_space_operations
 with noop_dirty_folio
X-Wm-Sent-Timestamp: 1773926415
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d064102fd-58576b65-023d-41ee-bec5-9d3e8cad1ba4-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.19-54.240.48.182
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_FROM(0.00)[bounces-13633-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[40];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev,groves.net];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	NEURAL_HAM(-0.00)[-0.149];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[jagalactic.com:dkim,groves.net:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,email.amazonses.com:mid,amazonses.com:dkim]
X-Rspamd-Queue-Id: 5F8572CBE30
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <John@Groves.net>=0D=0A=0D=0AFamfs is memory-backed; th=
ere is no place to write back to, and no=0D=0Areason to mark pages dirty =
at all.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=
=0A fs/fuse/famfs.c | 11 +++++++++++=0D=0A 1 file changed, 11 insertions(=
+)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=0Aindex 8=
7012df537eb..121ed74e9727 100644=0D=0A--- a/fs/fuse/famfs.c=0D=0A+++ b/fs=
/fuse/famfs.c=0D=0A@@ -14,6 +14,7 @@=0D=0A #include <linux/mm.h>=0D=0A #i=
nclude <linux/dax.h>=0D=0A #include <linux/iomap.h>=0D=0A+#include <linux=
/pagemap.h>=0D=0A #include <linux/path.h>=0D=0A #include <linux/namei.h>=0D=
=0A #include <linux/string.h>=0D=0A@@ -39,6 +40,15 @@ static const struct=
 dax_holder_operations famfs_fuse_dax_holder_ops =3D {=0D=0A =09.notify_f=
ailure=09=09=3D famfs_dax_notify_failure,=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A=
+ * DAX address_space_operations for famfs.=0D=0A+ * famfs doesn't need d=
irty tracking - writes go directly to=0D=0A+ * memory with no writeback r=
equired.=0D=0A+ */=0D=0A+static const struct address_space_operations fam=
fs_dax_aops =3D {=0D=0A+=09.dirty_folio=09=3D noop_dirty_folio,=0D=0A+};=0D=
=0A+=0D=0A /*************************************************************=
****************/=0D=0A=20=0D=0A /*=0D=0A@@ -624,6 +634,7 @@ famfs_file_i=
nit_dax(=0D=0A =09if (famfs_meta_set(fi, meta) =3D=3D NULL) {=0D=0A =09=09=
i_size_write(inode, meta->file_size);=0D=0A =09=09inode->i_flags |=3D S_D=
AX;=0D=0A+=09=09inode->i_data.a_ops =3D &famfs_dax_aops;=0D=0A =09} else =
{=0D=0A =09=09pr_debug("%s: file already had metadata\n", __func__);=0D=0A=
 =09=09__famfs_meta_free(meta);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A

