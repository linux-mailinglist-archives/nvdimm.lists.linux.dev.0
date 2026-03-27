Return-Path: <nvdimm+bounces-13776-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIUvLQzxxmkgQgUAu9opvQ
	(envelope-from <nvdimm+bounces-13776-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 22:05:16 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B44D334B7BF
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 22:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B60CF30339DD
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Mar 2026 21:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F523876D6;
	Fri, 27 Mar 2026 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="V1wMqapB";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WTjtjPwc"
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-127.smtp-out.amazonses.com (a11-127.smtp-out.amazonses.com [54.240.11.127])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCD93803D1
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645451; cv=none; b=GyK4pmlReybxI/SVm8eelrhKIGNH4+su8kKcS+M5PjSq/iY2U9eR2tSoRAunXD9I+swr+UumO+tZfOe6ppedL3L9XAvWSTYz7wpAGRhgZTCIuFD/acbVuvbAAIatEyL0FO5XSVeKOJynpEk6EpWcRJPnLq2wKBVJoxv49g1Yj+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645451; c=relaxed/simple;
	bh=4SzJA7zFUk7bTrGAecDeFf/8Y3WBEW174+aL/dgLQJc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Dyh7M0/m1eVZirE/oaqqrCMRgk5UQdHiaUFShgrICjumFTKLolBjdZcOCAtIO8fVXBDEOUo39u7yQwNP3Y+26Kc4Ni/+rmlsrBz7WCyKGhF4wQcVBgYLl2UcuOP9Ej6h/0kFD9FMwPTuaZCy13lrXLzUE5MRrICZ2GHplXVsWRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=V1wMqapB; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=WTjtjPwc; arc=none smtp.client-ip=54.240.11.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645449;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=4SzJA7zFUk7bTrGAecDeFf/8Y3WBEW174+aL/dgLQJc=;
	b=V1wMqapBNlzPUm7MA78hJYWVWEWVvRmHX/XUjzpcfpfyt/gtu+Okpr67x1oBEIff
	Fh4Jr6GZG1GAMB6ULCpQZr4JGcrQz3rEx6tjyMIlsDMfFKn4kiYyMmBqxAsg4jSnBMg
	Km6ctJJFqcydcf675VwoGrzXUxki1jYbhoAjYSX4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645449;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=4SzJA7zFUk7bTrGAecDeFf/8Y3WBEW174+aL/dgLQJc=;
	b=WTjtjPwc0QqnLmBlmGqgQP+NE/bzENNcKKSdO3ocwO2LibuKfy29xxvd8+FzWcFl
	epdfzoZ/idcEQ+FPgUC1oX8J9YfkesqB5m2Fq02bioV7oiIDnb5mjm2DfjBBpbM4iq9
	CMYj4jEofmbB/fz1TAfLUdXwUU7bTVCTYUzMUb7A=
Subject: [PATCH V10 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
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
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Fri, 27 Mar 2026 21:04:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
References: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com> 
 <20260327210356.79124-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi0/npKkGzMxTj2t5BOiiUF5fQ==
Thread-Topic: [PATCH V10 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
X-Wm-Sent-Timestamp: 1774645447
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311c90eb-a582ff97-93ba-49f3-8140-6c5c4bf8bc62-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.11.127
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_FROM(0.00)[bounces-13776-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[42];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev,groves.net];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,email.amazonses.com:mid,jagalactic.com:dkim,amazonses.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B44D334B7BF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: John Groves <john@groves.net>=0D=0A=0D=0AThis function will be used=
 by both device.c and fsdev.c, but both are=0D=0Aloadable modules. Moving=
 to bus.c puts it in core and makes it available=0D=0Ato both.=0D=0A=0D=0A=
No code changes - just relocated.=0D=0A=0D=0AReviewed-by: Ira Weiny <ira.=
weiny@intel.com>=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0A=
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0ASigned-o=
ff-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/bus.c    =
| 20 ++++++++++++++++++++=0D=0A drivers/dax/device.c | 23 ---------------=
--------=0D=0A 2 files changed, 20 insertions(+), 23 deletions(-)=0D=0A=0D=
=0Adiff --git a/drivers/dax/bus.c b/drivers/dax/bus.c=0D=0Aindex c94c0962=
2516..1b412264bb36 100644=0D=0A--- a/drivers/dax/bus.c=0D=0A+++ b/drivers=
/dax/bus.c=0D=0A@@ -1417,6 +1417,26 @@ static const struct device_type de=
v_dax_type =3D {=0D=0A =09.groups =3D dax_attribute_groups,=0D=0A };=0D=0A=
=20=0D=0A+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c *=
/=0D=0A+__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgo=
ff_t pgoff,=0D=0A+=09=09=09      unsigned long size)=0D=0A+{=0D=0A+=09for=
 (int i =3D 0; i < dev_dax->nr_range; i++) {=0D=0A+=09=09struct dev_dax_r=
ange *dax_range =3D &dev_dax->ranges[i];=0D=0A+=09=09struct range *range =
=3D &dax_range->range;=0D=0A+=09=09phys_addr_t phys;=0D=0A+=0D=0A+=09=09i=
f (!in_range(pgoff, dax_range->pgoff, PHYS_PFN(range_len(range))))=0D=0A+=
=09=09=09continue;=0D=0A+=09=09phys =3D PFN_PHYS(pgoff - dax_range->pgoff=
) + range->start;=0D=0A+=09=09if (phys + size - 1 <=3D range->end)=0D=0A+=
=09=09=09return phys;=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=09return -1;=0D=
=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);=0D=0A+=0D=0A static str=
uct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)=0D=0A {=0D=0A=
 =09struct dax_region *dax_region =3D data->dax_region;=0D=0Adiff --git a=
/drivers/dax/device.c b/drivers/dax/device.c=0D=0Aindex 528e81240c4d..2d2=
dbfd35e94 100644=0D=0A--- a/drivers/dax/device.c=0D=0A+++ b/drivers/dax/d=
evice.c=0D=0A@@ -57,29 +57,6 @@ static int check_vma(struct dev_dax *dev_=
dax, struct vm_area_struct *vma,=0D=0A =09=09=09   vma->vm_file, func);=0D=
=0A }=0D=0A=20=0D=0A-/* see "strong" declaration in tools/testing/nvdimm/=
dax-dev.c */=0D=0A-__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *d=
ev_dax, pgoff_t pgoff,=0D=0A-=09=09unsigned long size)=0D=0A-{=0D=0A-=09i=
nt i;=0D=0A-=0D=0A-=09for (i =3D 0; i < dev_dax->nr_range; i++) {=0D=0A-=09=
=09struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];=0D=0A-=09=09s=
truct range *range =3D &dax_range->range;=0D=0A-=09=09unsigned long long =
pgoff_end;=0D=0A-=09=09phys_addr_t phys;=0D=0A-=0D=0A-=09=09pgoff_end =3D=
 dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;=0D=0A-=09=09if (pgoff=
 < dax_range->pgoff || pgoff > pgoff_end)=0D=0A-=09=09=09continue;=0D=0A-=
=09=09phys =3D PFN_PHYS(pgoff - dax_range->pgoff) + range->start;=0D=0A-=09=
=09if (phys + size - 1 <=3D range->end)=0D=0A-=09=09=09return phys;=0D=0A=
-=09=09break;=0D=0A-=09}=0D=0A-=09return -1;=0D=0A-}=0D=0A-=0D=0A static =
void dax_set_mapping(struct vm_fault *vmf, unsigned long pfn,=0D=0A =09=09=
=09      unsigned long fault_size)=0D=0A {=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A

