Return-Path: <nvdimm+bounces-4572-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE1359E80A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Aug 2022 18:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEE8C1C20952
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Aug 2022 16:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75353202;
	Tue, 23 Aug 2022 16:51:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A882CA5
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 16:51:44 +0000 (UTC)
Received: from zn.tnic (p200300ea971b9893329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9893:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DC0D91EC0681;
	Tue, 23 Aug 2022 18:51:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1661273498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=fpyb/dqy0w041C4ZduhB6mdSn53C2ehshw7ffrOO2as=;
	b=NkIR6KJRRcOke3KLUC2xQQwZ0MBSIYaHCfJb/hh7Ny2zFmCOzl3kVEY7VwECIcM7F6w9CB
	XKGpoFkhG0J6xlPhn6gylCWmVMeP3zVs3wloB9yW0fQKTIfrnnPqxvEJDVtugqXiap7eun
	Y7XRHyiTJ2wsDcxsG8dSG/L6jK1y2Xk=
Date: Tue, 23 Aug 2022 18:51:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org,
	linux-edac@vger.kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, hch@lst.de, nvdimm@lists.linux.dev
Subject: Re: [PATCH v7] x86/mce: retrieve poison range from hardware
Message-ID: <YwUFlo3+my6bJHWj@zn.tnic>
References: <20220802195053.3882368-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220802195053.3882368-1-jane.chu@oracle.com>

On Tue, Aug 02, 2022 at 01:50:53PM -0600, Jane Chu wrote:
> With Commit 7917f9cdb503 ("acpi/nfit: rely on mce->misc to determine
> poison granularity") that changed nfit_handle_mce() callback to report
> badrange according to 1ULL << MCI_MISC_ADDR_LSB(mce->misc), it's been
> discovered that the mce->misc LSB field is 0x1000 bytes, hence injecting
> 2 back-to-back poisons and the driver ends up logging 8 badblocks,
> because 0x1000 bytes is 8 512-byte.

What I'm missing from this text here is, what *is* the mce->misc LSB
field in human speak? What does that field denote?

What effect does that field have on error injection?

And so on.

> Dan Williams noticed that apei_mce_report_mem_error() hardcode
> the LSB field to PAGE_SHIFT instead of consulting the input
> struct cper_sec_mem_err record.  So change to rely on hardware whenever
> support is available.

Rely on hardware? You're changing this to rely on what the firmware
reports.

That mem_err thing comes from a BIOS table AFAICT.

...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

