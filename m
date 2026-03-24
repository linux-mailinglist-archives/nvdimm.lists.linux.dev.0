Return-Path: <nvdimm+bounces-13691-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICWjIfLcwWnxXQQAu9opvQ
	(envelope-from <nvdimm+bounces-13691-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 01:38:10 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B8F2FFC46
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 01:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BA157305093F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Mar 2026 00:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1538630AAA9;
	Tue, 24 Mar 2026 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ok/ahvK3";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="FIBFA2vU"
X-Original-To: nvdimm@lists.linux.dev
Received: from a11-4.smtp-out.amazonses.com (a11-4.smtp-out.amazonses.com [54.240.11.4])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908CD1DF26E
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312599; cv=none; b=IP4Ga5JR7/L7bNL3NLeYwvr4qW35fNBiOTDW2ffaEYeiKow2ySrLQdAGhNZUDinUEkKqDS7lOJRw+jvAEwHJeG7clb3N/l6HO5LZxsAdYaZWmeqY3W8ACr+1HnDQTblT9Z6NUZoj5i/C1LA31hQpK0tLXXuBtWSfaibdO48cno0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312599; c=relaxed/simple;
	bh=tG4vh62NqV1A3sNULhBYd/HpqWGsf8oGTjGFvpAfB8Y=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=iQdmesOB1wAvAUlDmVvBWLEPzwYJ9a7Qj8HQkpO8Z0WKBNyF5aw/tO02m78brXZYKeR1drRFcXxjxctcpmQ6BDTBNutKkS5lYeBIFik4SLNRNSXO5zE8T+aduxt/Z4I7G62JjEBowtD5poccX2i56dg1BQISEE28M4uhEn11sXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ok/ahvK3; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=FIBFA2vU; arc=none smtp.client-ip=54.240.11.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312597;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=tG4vh62NqV1A3sNULhBYd/HpqWGsf8oGTjGFvpAfB8Y=;
	b=ok/ahvK3myEmWsKnTDxcrwAx95r2VeEB2HrvPdg9I4+Pb8cPWETIHeuaCntbshfu
	8PkDNhlzwJccbobvYJX+Nq5sl656m4z6kDAExvdLWZp/O3T6Uu1geZ6IDdgt1L2pO1H
	GurDNu0IpLL3NAYPcaF/cga9HnUZldNXGNkUlfDg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312597;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=tG4vh62NqV1A3sNULhBYd/HpqWGsf8oGTjGFvpAfB8Y=;
	b=FIBFA2vUq+S3/XOGODmRNeoNwoDsjP1EYwgso198tMvwax9sEkRzYzEcAX++edmO
	KyrmbqOR0Eo8xFAidrfsZe2w/uNqYKIvTzn4kJ74xCoWQhwA4C9k/4gw4hMm/kO3lq4
	LVAOAvnw8CiBzZbY9n2kMZews1VWQ+BT79RmeZEA=
Subject: [PATCH BUNDLE v9] famfs: Fabric-Attached Memory File System
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
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>
Date: Tue, 24 Mar 2026 00:36:37 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260324003630.4930-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyZEswjXSG92Tn2kGdN5KULUYA==
Thread-Topic: [PATCH BUNDLE v9] famfs: Fabric-Attached Memory File System
X-Wm-Sent-Timestamp: 1774312596
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d45a702-37d7aa37-4b46-4c21-86db-bf9bd3d914bb-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.4
X-Spamd-Result: default: False [0.75 / 15.00];
	TO_EXCESS_QP(1.20)[];
	CC_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[jagalactic.com,quarantine];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[jagalactic.com:s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq,amazonses.com:s=224i4yxa5dv7c2xz3womw6peuasteono];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TAGGED_FROM(0.00)[bounces-13691-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[39];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@jagalactic.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[jagalactic.com:+,amazonses.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	FROM_EXCESS_QP(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[email.amazonses.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amazonses.com:dkim,jagalactic.com:dkim,lwn.net:url]
X-Rspamd-Queue-Id: 09B8F2FFC46
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a coordinated patch submission for famfs (Fabric-Attached Memory=0D=
=0AFile System) across three repositories:=0D=0A=0D=0A  1. Linux kernel d=
ax (cover + 7 patches) - dax fsdev driver + fuse/famfs=20=0D=0A     integ=
ration=0D=0A  2. Linux kernel fs/fuse - famfs support into fuse. Depends =
on the dax=0D=0A     patches=0D=0A=0D=0ANOTE: the fuse fuse package (seco=
nd series) depends on the dax patches=0D=0A(first series).=0D=0A=0D=0AThi=
s bundle does not contain the user space libfuse and ndctl patches;=0D=0A=
those will be sent separately to the respective projects.=0D=0A=0D=0AEach=
 series is posted as a reply to this cover message, with individual=0D=0A=
patches replying to their respective series cover.=0D=0A=0D=0AOverview=0D=
=0A--------=0D=0AFamfs exposes shared memory as a file system. It consume=
s shared memory=0D=0Afrom dax devices and provides memory-mappable files =
that map directly to=0D=0Athe memory with no page cache involvement. Famf=
s differs from conventional=0D=0Afile systems in fs-dax mode in that it h=
andles in-memory metadata in a=0D=0Asharable way (which begins with never=
 caching dirty shared metadata).=0D=0A=0D=0AFamfs started as a standalone=
 file system [1,2], but the consensus at=0D=0ALSFMM 2024 and 2025 [3,4] w=
as that it should be ported into fuse.=0D=0A=0D=0AThe key performance req=
uirement is that famfs must resolve mapping faults=0D=0Awithout upcalls. =
This is achieved by fully caching the file-to-devdax=0D=0Ametadata for al=
l active files via two fuse client/server message/response=0D=0Apairs: GE=
T_FMAP and GET_DAXDEV.=0D=0A=0D=0APatch Series Summary=0D=0A-------------=
-------=0D=0A=0D=0ALinux Kernel dax (V8, xx patches): New fsdev driver (d=
rivers/dax/fsdev.c)=0D=0Aproviding a devdax mode compatible with fs-dax. =
Devices can be switched=0D=0Aamong 'devdax', 'fsdev' and 'system-ram' mod=
es via daxctl or sysfs.=0D=0A=0D=0A=0D=0ALinux kernel fuse (V8, xx patche=
s: Famfs integration adding GET_FMAP and=0D=0AGET_DAXDEV messages for cac=
hing file-to-dax mappings in the kernel.=0D=0A=0D=0ATesting=0D=0A-------=0D=
=0AThe famfs user space [5] includes comprehensive smoke and unit tests t=
hat=0D=0Aexercise all three components together. The ndctl series include=
s a=0D=0Adedicated test for famfs mode transitions.=0D=0A=0D=0AReferences=
=0D=0A----------=0D=0A[1] https://lore.kernel.org/linux-cxl/cover.1708709=
155.git.john@groves.net/=0D=0A[2] https://lore.kernel.org/linux-cxl/cover=
=2E1714409084.git.john@groves.net/=0D=0A[3] https://lwn.net/Articles/9831=
05/ (LSFMM 2024)=0D=0A[4] https://lwn.net/Articles/1020170/ (LSFMM 2025)=0D=
=0A[5] https://famfs.org (famfs user space)=0D=0A[6] https://lore.kernel.=
org/linux-cxl/20250703185032.46568-1-john@groves.net/ (V2)=0D=0A[7] https=
://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-john@groves.net/T=
/#m0000d8c00290f48c086b8b176c7525e410f8508c (related ndctl series)=0D=0A-=
-=0D=0AJohn Groves=0D=0A

