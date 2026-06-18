Return-Path: <nvdimm+bounces-14453-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fxHmKoNHM2rz+wUAu9opvQ
	(envelope-from <nvdimm+bounces-14453-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 03:18:59 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8C569CFCC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 03:18:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=WahXT65h;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14453-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.232.135.74 as permitted sender) smtp.mailfrom="nvdimm+bounces-14453-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 90AB6301FF00
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Jun 2026 01:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921AB2D47F1;
	Thu, 18 Jun 2026 01:18:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6311175A89;
	Thu, 18 Jun 2026 01:18:50 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781745532; cv=pass; b=ITqgkAziNMkjb8eZkMQJc7AAdtC/poVhSkbWZXeq/d2neOSGwjEq30iOTg+SX+t+h3Odgt/lbqlJk+/F+Nrqxi2JItTu2KctdqdvhYKU0g7O0vh9Kte88YSBztmsv0L8AaeNr17KNQyFFvxK78VxBfySjViMO2J2tjKXfyIG714=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781745532; c=relaxed/simple;
	bh=s8SwkW2TJEtXTUlOSaAhFW9HuWQZ9cgj+K0qH9V0WyU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=GuvtQLZiNJu5U0j19MHMYzyUbPqkGDEhjpYO9RaALiQD7mgCmjN8bFvKtG4CPEGI9w7VqxUr9DxqBbl4I0esORLSSpHM88vGmt2bEQnhdWY3fKg96MQHcjzjrZAeuu3EkKmln4W2iw6kH+UiinLkYsS039cZVIgQvcl0NQg1XBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=WahXT65h; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal: i=1; a=rsa-sha256; t=1781745527; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EdpoeX0FZB18FpBrHNsIVPc5zLqwlovG27JC4w4yulGEpVe+a7xZvyTim8GdJWtjqrHTAtnooVST9YpeJUPv22X9iYd3w1I3VFp2qhREFUXPni2pDQr0O+IgwbDErlnOpdrxAnep8ZmWgdX2lT96MYJFg577zJHbnl5EPiAhJ/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781745527; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gvtmqQu+4izQ+z8vCyEncJGkS/9pjYX+E8AlS+ZmjMw=; 
	b=XXjgw7jAXBs+D5HoEfn04FzVVUcK8jxMkJk07YeLjyYv8hZhUjgkt3cHBI8mAKM+h5aNEtbBEW+3vFb2BVM31EOjCHFW3opyuIjLz0OzCNcCHpx2L8HUBkDjApu86w9rvT0W7+8Kjgt2mcNB/f8DtgzG4T/FIK15mr3ouVMSj2I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781745527;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=gvtmqQu+4izQ+z8vCyEncJGkS/9pjYX+E8AlS+ZmjMw=;
	b=WahXT65hFt3l/XSNRy6KdvKlm9CSvwbZFWoQ8xEPZcE/+l8TEiBN9g1TkaKhgaZV
	IaeWq3LKnGwmBfBbONrJxKnhMvosucg+c1sqDtY92AA/IuQCcsoIBFPnsY5A8F6tuSg
	S4n92QLeM6Z7CN+qaFk38FIufmiptRPoLmHWRSqM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1781745523625334.74062508792883; Wed, 17 Jun 2026 18:18:43 -0700 (PDT)
Date: Thu, 18 Jun 2026 09:18:43 +0800
From: Li Chen <me@linux.beauty>
To: "Alison Schofield" <alison.schofield@intel.com>
Cc: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>,
	"Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19ed84f1b63.4eb3c0703221791.2736506052608115754@linux.beauty>
In-Reply-To: <aixTFVGZVDaCxMis@aschofie-mobl2.lan>
References: <20260609120726.1714780-1-me@linux.beauty> <aixTFVGZVDaCxMis@aschofie-mobl2.lan>
Subject: Re: [PATCH v4 0/7] nvdimm: virtio_pmem: fix request lifetime and
 converge broken queue failures
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linux.beauty,none];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-14453-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:alison.schofield@intel.com,m:pankaj.gupta.linux@gmail.com,m:dan.j.williams@intel.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:pankajguptalinux@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,intel.com,lists.linux.dev,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[linux.beauty:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux.beauty:dkim,linux.beauty:mid,linux.beauty:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3F8C569CFCC

Hi Alison,


 ---- On Sat, 13 Jun 2026 02:42:29 +0800  Alison Schofield <alison.schofiel=
d@intel.com> wrote ---=20
 > On Tue, Jun 09, 2026 at 08:07:14PM +0800, Li Chen wrote:
 > > Hi,
 >=20
 > Hi Li Chen,
 >=20
 > In case you missed it, a Sashiko AI review of this set has posted
 > feedback. Please take a look.
 >=20
 > https://sashiko.dev/#/patchset/20260609120726.1714780-1-me%40linux.beaut=
y
 >=20
 > -- Alison

Thanks for checking and for the reminder.

I will also keep watching Sashiko's review results for this and future
rerolls, and will fold in any issues that look valid.


Regards,
Li=E2=80=8B


