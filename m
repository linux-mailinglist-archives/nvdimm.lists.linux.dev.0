Return-Path: <nvdimm+bounces-14521-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id sC2dOvX0O2rNgQgAu9opvQ
	(envelope-from <nvdimm+bounces-14521-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:17:09 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DABA6BF8D0
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:17:09 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ne7ugI2E;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14521-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14521-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1495F307F87A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 15:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC023DA5C3;
	Wed, 24 Jun 2026 15:08:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073433DA5B7;
	Wed, 24 Jun 2026 15:08:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313716; cv=none; b=rFzLgxsDB1dTAuvroyiOkI1/Q9J+g7UnZgVfsIpT6rEDooNnhUeY0t40ON0jSlt6ExvgrfWQ5HVeWk2iPOdKsqonQC0jZovM24x0it9fVL5wYRRfyshXfOuN528Wqvp0d9eD+SLG55x9sP7n0CUWl7Z3HUf/EuB9ZFWvcdiqZys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313716; c=relaxed/simple;
	bh=QGCuUm2pZHDboKkUZ89nXD036pNrjEi9SFA5a1ThTbs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WInUabgvMXPnv0U99xv62QjVhhX1qZs/trWSvyIpvmFLPj2oGUERAgeHKMWKEhN0GY+MPbX1z87nblevL9KoofMuZsGMEo7XsOotFAkAv3PGGkEPd5NrDCUD71F/TOC3bIg910zko5uAHAkfaao4z3d2uSpxIbH8+KvsCRKxKCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ne7ugI2E; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4801F000E9;
	Wed, 24 Jun 2026 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313714;
	bh=QGCuUm2pZHDboKkUZ89nXD036pNrjEi9SFA5a1ThTbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ne7ugI2EwRZmuQHKtw69DjnFZkGYN3YVO/t4b9awmpJv7v6Jwn6yiSODheqte9XNs
	 q+pVRemBLs1sOErcsiqf5ne6d2OmLNKFpkZ/v/Dxzfo5QdvtESDlrWGm7dG3ZUQ2hv
	 RAqYj/zYU/YXNxYQ/El3FY4ceIMfJ9DX0mSpjww9PuVQW0PL9kPVVnCuzHlU3M/Upm
	 hpKxk1axZFqhqdHmBSrNyQshfPo2Rs6c9jVC/yQMxbUupwWegdzF5oZ/LYTxiquvUK
	 q8vvmipSfDmv/Niw0IIdcNP1OIJ0+9+hLWlh6TL2W0giSYuL6dDDVJ2wj6hwiBse/R
	 jpPkmq0nm3HWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Richard Cheng" <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624145843.55116-1-icheng@nvidia.com>
References: <20260624145843.55116-1-icheng@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:08:33 +0000
Message-Id: <20260624150834.BC4801F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14521-lists,linux-nvdimm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,sashiko.dev:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,smtp.kernel.org:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4DABA6BF8D0

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] User-space ndctl test patch mistakenly submitted to the Linux ke=
rnel tree.
- [Medium] Brittle error handling in test script module loading.
--

commit d71b88195f1dc438adbcafc668b1cd91cd8a75fe
Author: Richard Cheng <icheng@nvidia.com>

test/cxl-mbox: Regression test for huge CXL_MEM_SEND_COMMAND out.size

This commit introduces a regression test for a CXL mailbox issue where a hu=
ge
out.size parameter could trigger a size > INT_MAX kvmalloc() WARN. The test
uses the cxl_test mock memdev and directly issues the CXL_MEM_SEND_COMMAND
ioctl.

Link: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/

> diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> new file mode 100644
> index 0000000000000..d81327ba17df4
> --- /dev/null
> +++ b/test/cxl-mbox.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdlib.h>
> +#include <syslog.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>

[Severity: Medium]
Is this test actually intended for the ndctl repository rather than the Lin=
ux
kernel tree? It looks like it includes <cxl/libcxl.h>, which is an ndctl
user-space library header not present in the Linux kernel tree.

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

[Severity: Medium]
Does this source a 'common' test framework script from ndctl that does not
exist in the kernel tree?

> +
> +BIN=3D"$TEST_PATH"/cxl-mbox
> +rc=3D77
> +# 237 is -ENODEV
> +ERR_NODEV=3D237
> +# TAINT_WARN is bit 9
> +TAINT_WARN=3D512
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe -r cxl_test 2>/dev/null
> +modprobe cxl_test
> +# cxl_test alone does not autoload the mock memdev module on this box
> +modprobe cxl_mock_mem

[Severity: Medium]
Because this script runs with set -e (from the #!/bin/bash -Ex line), will
these unprotected modprobe commands immediately trigger the ERR trap and
abort the script if the modules are missing, instead of gracefully skipping
the test?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145843.5511=
6-1-icheng@nvidia.com?part=3D1

