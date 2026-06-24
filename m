Return-Path: <nvdimm+bounces-14518-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HYl1AKz0O2qmgQgAu9opvQ
	(envelope-from <nvdimm+bounces-14518-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:15:56 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A1F6BF8AC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:15:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=XiZcBU40;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14518-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14518-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 540EA30FF82B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 15:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05A83D75C7;
	Wed, 24 Jun 2026 15:06:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED313B7B7B;
	Wed, 24 Jun 2026 15:06:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313581; cv=none; b=rd9iIOCJi+cadReACP5tf3/90Yjuge+X58qZ14PU1hc4KfLC7Rra1oID8Vq4xSt8IvsmiEMt69TFMdm0xrtQEdDOSaxK0UUyjbhoEaiieIsSINBwkgI8cSx7fJVqS/Ew5R6XTNDO1yufID8YOkJkw91EzUjH3Vxj1+uk08uurnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313581; c=relaxed/simple;
	bh=f7UaoYbOWavBqgJEpuif2hSUC52wuuoFQfEsIgs+3I4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VRd7/7b3Mg0reSwcBKYBil3f3fKwxUflKYvDkHWRIod57Uout0+1cSLwfWAOAn7ucnuyXHD7T7ojjbVBUq+hSgQVL7dMOZAEjaYjCC3ZRpZ3OPh8skbOzsjtSHixfU/cKqgLo2o4vcL47i+j+IvwbYjLw1t2HVmrByvmmvPgNH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=XiZcBU40; arc=none smtp.client-ip=78.40.148.171
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=W/D3O2+J0VWRFChiKYTHNHKiPT17z8dGAOaBF9hvnyU=; b=XiZcBU40nY51nV
	lCHELy8REPU5dIGU4ZyzR8dlBXXyqf+gLYOG/0mJv8T3p7t/o4DXOtKtgtzRyWv4LuyfPQpH9QJpP
	QragtCvFvRIdQFtWB5xVPH+ysxKRO0sBJKKd6V06cKIdiK6lb4Tx7tzJ2ZqJxLc3H5Nbwmwy/UnSD
	JS/juxsKE+Jjd+mY1qNuKuuzdqFCq/vbGqnRKoAAIIMqVeW0A9HanASAo5+FgCo2LZi2DppZQK0lR
	I/WZh13XBZa2m8dUmWV5qUGmvN/E5jBO66/FFa8NnSVFy/izYBSYnkdoLUiGhAFoPxWhequvgV4fU
	xGLUNCK9sEXBH4ch0veg==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wcPAy-009kn3-67; Wed, 24 Jun 2026 16:06:04 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wcPAx-00000003na2-3f8R;
	Wed, 24 Jun 2026 16:06:03 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH v2] nvdimm/btt: fix sequence endian in btt_log_read error print
Date: Wed, 24 Jun 2026 16:06:02 +0100
Message-Id: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[codethink.co.uk,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[codethink.co.uk:s=imap5-20230908];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14518-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:vishal.l.verma@intel.com,m:djbw@kernel.org,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:iweiny@kernel.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:ben.dooks@codethink.co.uk,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[ben.dooks@codethink.co.uk,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[ben.dooks@codethink.co.uk,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[codethink.co.uk:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,codethink.co.uk:dkim,codethink.co.uk:email,codethink.co.uk:mid,codethink.co.uk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 58A1F6BF8AC

The error reporting in btt_log_read() prints sequence numbers out
from the log which are stored in little endian without any endian
conversion. Make sure these are passed throuhg endian convesion
before going to the kernel console so the user sees the correct
sequence number and to avoid any warnings from sparse due to
endian conversion.

Fix the following (prototype) sparse warnings:
drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
drivers/nvdimm/btt.c:342:17:    expected int
drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
drivers/nvdimm/btt.c:342:17:    expected int
drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
v2: reworded commnit messae
---
 drivers/nvdimm/btt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 7e1112960d7f..e9d548442884 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
 	if (old_ent < 0 || old_ent > 1) {
 		dev_err(to_dev(arena),
 				"log corruption (%d): lane %d seq [%d, %d]\n",
-				old_ent, lane, log.ent[arena->log_index[0]].seq,
-				log.ent[arena->log_index[1]].seq);
+				old_ent, lane,
+				le32_to_cpu(log.ent[arena->log_index[0]].seq),
+				le32_to_cpu(log.ent[arena->log_index[1]].seq));
 		/* TODO set error state? */
 		return -EIO;
 	}
-- 
2.37.2.352.g3c44437643


