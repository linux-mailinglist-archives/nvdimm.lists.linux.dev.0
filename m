Return-Path: <nvdimm+bounces-14523-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HefNNtL1O2pMgggAu9opvQ
	(envelope-from <nvdimm+bounces-14523-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:20:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B36D6BF951
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:20:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cRpriO7k;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14523-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14523-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DBFD318F7A6
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9CF3D8131;
	Wed, 24 Jun 2026 15:09:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1EE3BED75;
	Wed, 24 Jun 2026 15:09:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313791; cv=none; b=kItz+bYOKr8XbtxXfQzAhM95gaGJmnyAcPxZkXQjlrX7dKjs7B6o7+MlJMu5iEZEi7sfqkS92xNeBYNBI+7/YE853xg0GR20w8tlXD+QO99+65l4dVfVjEuTL7/CfdiAJTZsk5vGqG0hwL8RvttCT2TD5ERf3BrgvPQ0mgXVMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313791; c=relaxed/simple;
	bh=0WScFHkiuUF1EwQN2UwaqtzS+je2Wt/BeEF5wA2GUXA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nRYC1Ot1UgXfmIwVgbaWSYWrMUABp8NePK/SJgwl+vQjAhKHOfyXAtF6xp2QI1PV3KzQCU80tfh7yGB2QAXkXd+NVziRIsqNoTA1Q7oBJQKrIfBWWQB2gXoOdra4VUMWxSBcxVZWvnKdDRwBOrZwRbRhTZ48te5ErSkULoV7hkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRpriO7k; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240EF1F00A3D;
	Wed, 24 Jun 2026 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313789;
	bh=0WScFHkiuUF1EwQN2UwaqtzS+je2Wt/BeEF5wA2GUXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cRpriO7kN4exQ8S4vujzpAe78OAGRohY3M9oK90aWgf0YWvGK/VjGeL8QKBKjAVNe
	 VORwXaUcTrkH4k5W4Z2Wg77ma8KXKi6UqwKDWc4O1k+WMhjP5pbehbI4KcJUSnyt5p
	 i0nFQ+soYX4KREY53AxWn0AvvHyoI1Hg0TITI4ShsNlqiVgWp4VeZTLXiLQgT1jB9O
	 f7UaDc+clzKMK7s9xAEMYCSasjX1bVFgBd53xJohobvR2Kah7x7Aj6Yb3GLgCJ3hyl
	 fleOi57DkfxL9f+Bq5nMICAbCHO8iZu78x7fDM7+bDGEdV1GoVuBlt7E3KMPqow8Iu
	 7yRZKGsOOJIRw==
From: sashiko-bot@kernel.org
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Richard Cheng" <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624150158.55264-1-icheng@nvidia.com>
References: <20260624150158.55264-1-icheng@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:09:48 +0000
Message-Id: <20260624150949.240EF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14523-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:icheng@nvidia.com,m:linux-cxl@vger.kernel.org,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,nvidia.com:email,lists.linux.dev:replyto,lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2B36D6BF951

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Patch submitted to the wrong repository: adds `ndctl` userspace tes=
t files to the kernel tree.
--

commit a640ffeb53f9a730f09dcd04ab6a813beaced234
Author: Richard Cheng <icheng@nvidia.com>

test/cxl-mbox: Regression test for huge CXL_MEM_SEND_COMMAND out.size

This patch introduces a regression test for an unbounded kvzalloc() in
cxl_mbox_cmd_ctor(). It creates a raw struct cxl_send_command and issues
the ioctl directly against the cxl_test mock memdev.

Link: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/

> diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> new file mode 100644
> index 0000000000000..d81327ba17df4
> --- /dev/null
> +++ b/test/cxl-mbox.c
> @@ -0,0 +1,129 @@
[ ... ]
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>

[Severity: Low]
Was this patch intended for the ndctl repository instead of the Linux
kernel tree? This includes an ndctl userspace library header that does
not exist in the kernel tree.

> +#include <cxl/cxl_mem.h>
> +
> +static const char provider[] =3D "cxl_test";

[ ... ]

> diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> new file mode 100755
> index 0000000000000..67fecf5a3f46f
> --- /dev/null
> +++ b/test/cxl-mbox.sh
> @@ -0,0 +1,48 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +
> +. $(dirname "$0")/common

[Severity: Low]
Does this code rely on an ndctl test dependency script that is absent from
the kernel tree? It looks like both this script and the C file above are
userspace tests belonging to the ndctl project rather than the kernel.

> +
> +BIN=3D"$TEST_PATH"/cxl-mbox
> +rc=3D77

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624150158.5526=
4-1-icheng@nvidia.com?part=3D1

