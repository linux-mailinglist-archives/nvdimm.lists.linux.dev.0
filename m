Return-Path: <nvdimm+bounces-1413-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F445418EFB
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Sep 2021 08:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1877F1C0A47
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Sep 2021 06:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F7D3FD3;
	Mon, 27 Sep 2021 06:17:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C463FC8
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 06:17:56 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id y186so5441712pgd.0
        for <nvdimm@lists.linux.dev>; Sun, 26 Sep 2021 23:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=g91KILktNNUUVd+3f2/+5R/t9sdil7VmAXnlMm2l/Uk=;
        b=cU/6nkNYI11cbtPYfVnt/peEIfif6j3XjmI2Kgwk4eMq+hej3uVoe4GKGvU+/qkKTi
         RlZtoqdbgsnxfSbJc4tt8lRqEGh/X/msstOW6lc2Xg8qBn7+Uxk4qy4xmn8m0VyJY+5F
         pZzLoNzDbpDCgsfLOrX1YwR39LKQ2ejkS/dbZkEp6uyxfxSAXuOPswhkf6sx7MLhP3Bq
         dZl7cUS73Z4Y+CmVaWTX8E/93iM97e1q8f9LTjcPTfQz9hXILUKmnPrMGpdWrRqgWRb9
         a37XDfLPNQgA0uS06As+AwyYCDNOfAXkfpC+PabnCKR13EAGc4cnxiDLAS+ELU6/HpYh
         FeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=g91KILktNNUUVd+3f2/+5R/t9sdil7VmAXnlMm2l/Uk=;
        b=43c3VK+9BSVdRnYKSRgc61pRiiGsF+2qm8LlDt5S5jFnS+Uu3NtEqAE7Zg0v+PnwSO
         4yfBPxPImi0xe0Muj8YPy5rcuNrvkMLCiJRprbMkJzmGS7psnDxLB/AL+7A/TE5uDSYU
         DagOE0GX98svjq6J8SKqfd8UG5JCL2mbCMLp/be+2zssiP5NX165AjM6K8WxDErVRwb3
         oVlAd1tXrb0zEw6lF0WGkgMxY1WkyLm6tVG8sNjdo8xSNmMU3GGG6p6oQMIMqNd77yDs
         YWWU67M9U+BdQ1eO2IH6SwwqTlVKPXIDERRtvDRXE4SmP1Dt1iFdtmZxINTLV5CwB4W+
         pNwA==
X-Gm-Message-State: AOAM5332UD0jWv4YB1Z0ErchWS5NByo37BId8CeQc579l3g9V52YSuEy
	kbq6EX6tbOrokNQAGUzYYnQvej6AjCg=
X-Google-Smtp-Source: ABdhPJwgv5NnKIJyTTHA+WwVFZB+1HaZ+GOn5h0C3czcvXOQNEIzzWaMr2sxDgkhjj1efY6n9KVNNg==
X-Received: by 2002:a63:cf10:: with SMTP id j16mr15155863pgg.257.1632723475832;
        Sun, 26 Sep 2021 23:17:55 -0700 (PDT)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n22sm17552019pgc.55.2021.09.26.23.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 23:17:55 -0700 (PDT)
Date: Mon, 27 Sep 2021 14:17:47 +0800
From: Murphy Zhou <jencce.kernel@gmail.com>
To: nvdimm@lists.linux.dev, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org
Subject: [regression] fs dax xfstests panic
Message-ID: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

Since this commit:

commit edb0872f44ec9976ea6d052cb4b93cd2d23ac2ba
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Aug 9 16:17:43 2021 +0200

    block: move the bdi from the request_queue to the gendisk


Looping xfstests generic/108 or xfs/279 on mountpoints with fsdax
enabled can lead to panic like this:

[  373.882656] BUG: kernel NULL pointer dereference, address: 0000000000000300 
[  373.893342] #PF: supervisor read access in kernel mode 
[  373.899082] #PF: error_code(0x0000) - not-present page 
[  373.904820] PGD 0 P4D 0  
[  373.907647] Oops: 0000 [#1] SMP PTI 
[  373.911542] CPU: 5 PID: 0 Comm: swapper/5 Kdump: loaded Tainted: G          I       5.14.0-rc4+ #1 
[  373.921544] Hardware name: Lenovo ThinkSystem SR630 -[7X02CTO1WW]-/-[7X02CTO1WW]-, BIOS -[IVE116S-1.20]- 02/08/2018 
[  373.933193] RIP: 0010:wb_timer_fn+0x3a/0x3c0 
[  373.937966] Code: 60 4c 8b 67 50 8b 9d 98 00 00 00 8b 95 b8 00 00 00 8b 85 d8 00 00 00 4c 8b 6d 28 01 d3 01 c3 48 8b 45 60 48 8b 80 90 00 00 00 <48> 8b 80 00 03 00 00 4c 8b b0 98 00 00 00 4d 85 ed 0f 84 ca 00 00 
[  373.958915] RSP: 0018:ffffaa0f465e4eb0 EFLAGS: 00010246 
[  373.964748] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000020 
[  373.972712] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff937c41649500 
[  373.980676] RBP: ffff937bf0f38400 R08: 0000000000000020 R09: 0000000000000000 
[  373.988641] R10: 0000000000000020 R11: 000000000000003d R12: ffff937d2bbf0d20 
[  373.996606] R13: 0000000000000000 R14: 0000000000000000 R15: ffff937f2f55c0c0 
[  374.004570] FS:  0000000000000000(0000) GS:ffff937f2f540000(0000) knlGS:0000000000000000 
[  374.013602] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  374.020015] CR2: 0000000000000300 CR3: 0000000c14c10003 CR4: 00000000007706e0 
[  374.027981] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  374.035944] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
[  374.043907] PKRU: 55555554 
[  374.046927] Call Trace: 
[  374.049657]  <IRQ> 
[  374.051902]  ? blk_stat_free_callback_rcu+0x30/0x30 
[  374.057350]  call_timer_fn+0x26/0xf0 
[  374.061344]  __run_timers.part.0+0x1c0/0x220 
[  374.066112]  ? __hrtimer_run_queues+0x136/0x270 
[  374.071169]  ? recalibrate_cpu_khz+0x10/0x10 
[  374.075940]  ? ktime_get+0x38/0x90 
[  374.079737]  run_timer_softirq+0x26/0x50 
[  374.084106]  __do_softirq+0xca/0x276 
[  374.088102]  __irq_exit_rcu+0xc1/0xe0 
[  374.092195]  sysvec_apic_timer_interrupt+0x72/0x90 
[  374.097545]  </IRQ> 
[  374.099885]  asm_sysvec_apic_timer_interrupt+0x12/0x20 
[  374.105613] RIP: 0010:acpi_idle_do_entry+0x4c/0x50 



It can be reliably reproduced on xfs or ext4. It was tested on pmem ramdisks.

Thanks,
Murphy

