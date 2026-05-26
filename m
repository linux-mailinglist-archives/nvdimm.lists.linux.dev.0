Return-Path: <nvdimm+bounces-14145-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id L+DEBndkFWqCUwcAu9opvQ
	(envelope-from <nvdimm+bounces-14145-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 11:14:31 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FAA5D3166
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 11:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 78C863009884
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 May 2026 09:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B033D3D1E;
	Tue, 26 May 2026 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="G20wPe6j"
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806043D25DD
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 09:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786867; cv=none; b=ArkdEdNGh0/IvguIPWmdcsZyPCe+9HvB/9qezSR29a1G+I29m2MSRFaVP1CTlf1bZpVjRAM8UvNnAxqM7oxyUysdchGxdS/IfU8+uhlDnZOf7qzCICHlsrw8eZLYYJM8RCTGuVApysfq2kNKfU9JHTLJ/LA87JY16psetvs5qvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786867; c=relaxed/simple;
	bh=EYYNU4ExJR7WZvmk5PwwgzVsvwFa6AqfTVfXEGquAWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmhykTnNDtwHnF5WteL81QrvQXcP+RO3vJo3KO9++VI9qUfGZt+HfgJPpq5DqlS/rt5DUFxA8QjVKfvsDRW24ycktQvhVUBDDxF9yl5iLgBEn/DxHMBreMecnsTob+vsuZmTD6RqdyCsVvXNS/wLHmvgBrmfVlhTPub5BpIHJtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=G20wPe6j; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779786857; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=U4H6R3EAlEmptOXkSQ2rupqy0nAMW3NIYX1SmQ+InxQ=;
	b=G20wPe6jymLtRKKY/u6r6qhdXBmseGOIvYPmBhAJuFEBpzRfQ0i/qDyzyhdqGSVdscSenB8IzbWCH0y7P0jfbDNOygLEPTHgmxTGzBcbgucJOf9VIktrZAOT+nvUoO5+SpyejAhX3p37KURax6Vcf30qM0lO9HYV4/OFK9RTZGk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3fq17T_1779786852;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X3fq17T_1779786852 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 17:14:16 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: jic23@kernel.org
Cc: alison.schofield@intel.com,
	cp0613@linux.alibaba.com,
	dave.jiang@intel.com,
	guoren@kernel.org,
	linux-cxl@vger.kernel.org,
	lucas.demarchi@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert when driver is builtin or live
Date: Tue, 26 May 2026 17:14:12 +0800
Message-ID: <20260526091412.166618-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260519124934.6bdda161@jic23-huawei>
References: <20260519124934.6bdda161@jic23-huawei>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14145-lists,linux-nvdimm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[cp0613@linux.alibaba.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A7FAA5D3166
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 19 May 2026 12:49:34 +0100, Jonathan Cameron wrote:

> Agreed. I'm curious why it was built that way.  I scraped an email address
> that is hopefully the right Lucas from another thread. +CC
>
> [...]
>
> My suspicion is this is papering over a race condition that occurs in
> a normal module load -  it may not be possible to tell the difference
> between COMMING and BUILTIN reliably.

I went and read through libkmod's code and history carefully on this,
and your suspicion is correct -- the COMING return is deliberate, not
incidental.

The behavior was introduced in libkmod commit fd44a98 ("Fix race while
loading modules", 2015), and Lucas spelled out the rationale in the
commit message:

  The problem is that the creation of /sys/module/<name> and
  /sys/module/<name>/initstate are not atomic. There's a small window
  in which the directory exists but the initstate file was still not
  created.
  [...]
  We enforce mod->builtin to always be up-to-date when
  kmod_module_get_initstate() is called. This way if the directory
  exists but the initstate doesn't, we can be sure this is because the
  module is in the "coming" state, i.e. kernel didn't create the file
  yet, but since builtin modules were already handled by checking our
  index the only reason for that to happen is that we hit the race
  condition.

So COMING on the sysfs fallback path is intentional: libkmod treats
kmod_module_is_builtin() (i.e. the modules.builtin lookup) as the
authoritative answer to "is this builtin", and assumes anything else
hitting the dir-without-initstate window has to be a concurrent load
race. When modules.builtin is missing, that assumption silently flips
and a builtin driver looks exactly like a load-in-progress -- which
is the COMING you saw.

Given that, I don't think the right fix is in libkmod. Returning
BUILTIN unconditionally on the dir-without-initstate fallback would
re-open the very race fd44a98 set out to close: a parallel modprobe
of a real loadable module that wins the directory creation but not
yet the initstate write would be misreported as builtin, and callers
waiting on it (the nls_cp437 / sd-card scenario in fd44a98) would
skip the wait. That's a behavioral regression on a configuration
libkmod has supported for ten years, in exchange for tidying up a
no-modules_install setup that libkmod arguably never promised to
handle. Lucas (CC'd) -- please correct me if I'm misreading the
original intent.

So I'll take Alison's suggestion and handle it on the ndctl side. v2
will keep the BUILTIN/LIVE short-circuit and additionally treat
KMOD_MODULE_COMING as builtin when /sys/module/<name>/ exists but the
initstate file does not -- exactly the fingerprint your VM hits.

I'll post v2 shortly.

Thanks,
Pei

