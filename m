Return-Path: <nvdimm+bounces-13507-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MGZkD18uqGlPpQAAu9opvQ
	(envelope-from <nvdimm+bounces-13507-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 04 Mar 2026 14:06:39 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AFF42000C0
	for <lists+linux-nvdimm@lfdr.de>; Wed, 04 Mar 2026 14:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7AF75303D7DB
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Mar 2026 13:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B760E26C385;
	Wed,  4 Mar 2026 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxy6EEGd"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0423AB8D
	for <nvdimm@lists.linux.dev>; Wed,  4 Mar 2026 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629557; cv=none; b=ujKWwyFFDV/KmVgcpLDYNP6ektEE2aiEZ+tvkB3BfKEEm+sEYUN3ACNrOxubvCmHaH6pPPYrIo64jg+HGVvLsE0GmKfXukGeet783pu11PYt1HxhjEoQDwv8agIr0DPW9k4YtPbrgg10LvW8Bg5vJiQ/w9lrm09gezAAnlEIIlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629557; c=relaxed/simple;
	bh=Y7ifATAABG7h4JBlQG0n1LL58NvEINqj9ivQCXNlw0Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1RrElKROcnL0v1CyWB+crkPKBxqk+dhc2WuM+RMMQ5w3BuAOvRY9A7FvOJYfnBl/PdNI8+ByLHDu27AtojABIKNfguEiYJ+2CuIvFTEIfNzSlBe68msCM2wQXmCa2tan1VXcwy40zhupcKyOazzOy7IRZjeyMfvwOriCRRRwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxy6EEGd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AA9C19423;
	Wed,  4 Mar 2026 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772629557;
	bh=Y7ifATAABG7h4JBlQG0n1LL58NvEINqj9ivQCXNlw0Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mxy6EEGdcmbZUE/WDqcWU2E94s4roZQ0W3NHf/38vyPHk01+Z4zVphJtQofc5tTSx
	 qilJC7Cv5XpQGEQxRAkNAc2IQRXK7f8DTvMQi7YF/ebNyB4kBLUHoOZRFvY7Kzg30M
	 bi7Ty2/rEO52xNo3cDNL7h7XZILZfre81Iyqa9DHIMR3ducVgEtFz/eW0xDiPpCsCA
	 DPON2RaCM4DTReYYeFy34im5nJR+xj1lDRAPzx4sL30BRBQH6Stei6y/mHbxgMDS+T
	 N0BijKn1YCGAFoS+xkPG2N3U61Txc98kyMFYiuvPlsipeimC80fIkM3kGq9+3vLJ4h
	 ScuzRbXVl265A==
From: Sasha Levin <sashal@kernel.org>
To: Dingisoul <dingiso.kernel@gmail.com>,
	nvdimm@lists.linux.dev
Subject: Re: [BUG]: KASAN: slab-use-after-free in nd_async_device_register on commit 3609fa95fb0f2c1b099e69e56634edb8fc03f87c
Date: Wed,  4 Mar 2026 08:05:54 -0500
Message-ID: <20260304130555.76151-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <8855544b-be9e-4153-aa55-0bc328b13733@gmail.com>
References: <8855544b-be9e-4153-aa55-0bc328b13733@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3AFF42000C0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13507-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,nvdimm@lists.linux.dev];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.995];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

This response was AI-generated by bug-bot. The analysis may contain errors — please verify independently.

## Bug Summary

**KASAN slab-use-after-free** in `nd_async_device_register()` (`drivers/nvdimm/bus.c:495`), introduced by commit `b6eae0f61db2` in v4.20-rc1 (September 2018). The bug triggers when `device_add()` fails (e.g., due to memory allocation failure in `device_private_init()`), causing the device to be freed before its `parent` pointer is accessed.

Here is the formatted reply:

---

### 1. Bug Summary
Use-after-free in `nd_async_device_register()` in the nvdimm subsystem, triggered when `device_add()` fails. Severity: crash (KASAN splat / potential data corruption). Affected subsystem: libnvdimm (drivers/nvdimm/bus.c).

### 2. Stack Trace Analysis
The KASAN report shows the crash at `nd_async_device_register` (drivers/nvdimm/bus.c:495), in workqueue/async context. The device was freed by the same task via `put_device` -> `kobject_put` -> `device_release` -> `kfree`.

### 3. Root Cause
Commit `b6eae0f61db2` added `get_device(dev->parent)` / `put_device(dev->parent)` to hold a parent reference during async init, but the `put_device(dev->parent)` dereferences `dev->parent` **after** `put_device(dev)` may have freed `dev`.

### 4. Affected Versions
v4.20 onward (all stable trees that backported `b6eae0f61db2`).

### 5. Fix
Save `dev->parent` before the `put_device(dev)` calls.

### 6. Prior Discussions
No prior reports found on lore.kernel.org.

### 7. Suggested Actions
- Alexander Duyck authored the original commit and should review.
- Dan Williams, Vishal Verma, Dave Jiang, Ira Weiny as nvdimm maintainers.

---

Here is the final output:

```
### 1. Bug Summary

This is a use-after-free bug in nd_async_device_register() in the nvdimm
subsystem (drivers/nvdimm/bus.c). When device_add() fails due to a
memory allocation failure in device_private_init(), the subsequent
put_device(dev) calls drop the device refcount to zero, freeing the
device. The code then dereferences dev->parent on the freed object,
triggering a KASAN slab-use-after-free. Severity: crash / potential
memory corruption.

### 2. Stack Trace Analysis

Decoded stack trace from the KASAN report:

  dump_stack_lvl (lib/dump_stack.c:122)
  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
  kasan_report (mm/kasan/report.c:597)
  nd_async_device_register (drivers/nvdimm/bus.c:495)
  async_run_entry_fn (kernel/async.c:131)
  process_scheduled_works (kernel/workqueue.c:3340)
  worker_thread (kernel/workqueue.c:3422)
  kthread (kernel/kthread.c:465)
  ret_from_fork (arch/x86/kernel/process.c:164)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:256)

Free trace (same task 131):
  kasan_save_track (mm/kasan/common.c:58)
  kasan_save_free_info (mm/kasan/generic.c:587)
  __kasan_slab_free (mm/kasan/common.c:287)
  kfree (mm/slub.c:6878)
  device_release (drivers/gpu/drm/vkms/vkms_configfs.c:745)
  kobject_put (lib/kobject.c:737)
  nd_async_device_register (drivers/nvdimm/bus.c:495)

The crash occurs in async/workqueue context (kworker/u9:3). The crash
point is at drivers/nvdimm/bus.c:495, which is the dereference of
dev->parent after put_device(dev) has already freed the device object.
The free trace confirms the device was freed by the same call chain
through put_device(dev) -> kobject_put -> device_release -> kfree.

### 3. Root Cause Analysis

The bug is in nd_async_device_register() at drivers/nvdimm/bus.c:486-497.

The reference counting flow when device_add() fails:

  __nd_device_register():
    get_device(dev->parent)   -- parent refcount +1
    get_device(dev)           -- dev refcount +1 (now 2)

  nd_async_device_register():
    device_add(dev):
      get_device(dev)         -- dev refcount +1 (now 3)
      device_private_init()   -- fails (ENOMEM)
      put_device(dev)         -- dev refcount -1 (now 2)
      returns error
    put_device(dev)           -- dev refcount -1 (now 1) [line 492]
    put_device(dev)           -- dev refcount -1 (now 0, dev FREED) [line 494]
    dev->parent               -- USE-AFTER-FREE [line 495]
    put_device(dev->parent)   -- [line 496]

Commit b6eae0f61db2 ("libnvdimm: Hold reference on parent while
scheduling async init") added the get_device(dev->parent) in
__nd_device_register() and the corresponding put_device(dev->parent)
in nd_async_device_register(). However, the put_device(dev->parent)
dereferences dev->parent AFTER put_device(dev) may have freed dev.

The fix is straightforward: save dev->parent in a local variable before
the put_device(dev) calls that can free the device:

  static void nd_async_device_register(void *d, async_cookie_t cookie)
  {
      struct device *dev = d;
      struct device *parent = dev->parent;

      if (device_add(dev) != 0) {
          dev_err(dev, "%s: failed\n", __func__);
          put_device(dev);
      }
      put_device(dev);
      if (parent)
          put_device(parent);
  }

### 4. Affected Versions

The bug was introduced by commit b6eae0f61db2 ("libnvdimm: Hold
reference on parent while scheduling async init"), first included in
v4.20-rc1 (September 2018). This is a regression from v4.19.

The commit was also backported to multiple stable trees, so all
maintained stable kernels from v4.20 onward are affected.

### 5. Relevant Commits and Fixes

Introducing commit:
  b6eae0f61db2 ("libnvdimm: Hold reference on parent while scheduling async init")

The original code that b6eae0f61db2 was fixing:
  4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")

No existing fix was found in mainline or stable trees as of
v6.19-rc4 (commit 3609fa95fb0f).

### 6. Prior Discussions

No prior reports of this specific bug were found on lore.kernel.org.
No related mailing list discussions, proposed patches, or review threads
were identified.

### 7. Suggested Actions

1. The fix is to save dev->parent in a local variable before the
   put_device(dev) calls, as shown in the root cause analysis above.

2. Adding Alexander Duyck who authored commit b6eae0f61db2 that
   introduced this bug.

3. Adding Dan Williams, Vishal Verma, Dave Jiang, and Ira Weiny as
   nvdimm subsystem maintainers.

4. Once fixed, the patch should be tagged:
     Fixes: b6eae0f61db2 ("libnvdimm: Hold reference on parent while scheduling async init")
     Cc: stable@vger.kernel.org


