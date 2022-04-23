Return-Path: <nvdimm+bounces-3679-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8E850C594
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 02:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 13E7D2E09A4
	for <lists+linux-nvdimm@lfdr.de>; Sat, 23 Apr 2022 00:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5546F33F1;
	Sat, 23 Apr 2022 00:08:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D37C
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 00:08:54 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id c23so14211377plo.0
        for <nvdimm@lists.linux.dev>; Fri, 22 Apr 2022 17:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8rhM0AUb28XSifpCDXIdOqSJ0aXgis9HwJ8WeGFTvA=;
        b=Xo+AVVSSyCqyl6ckW7mfe0Iwmo4zy/V4+U2hF6gPGUNtJcEYoN6mTkc23bEcCHz3W3
         XxkljElQVQh93aBFm+72UaoPCi175LJHN1iV+AdzJcJA58Ri76Q1OfE1/joS8U9p9/2z
         iDwMa8UrQvMSsNKEFJhLYQ3Dn57PNdq+qVrH0RKjuX3pbD+FMLt5Lk0UJKVQ6vejHQrn
         U0oKpbwqz8JOldgBXzAHf+OHD6T/H8f1N+npIeWcevHpAH6rmtgmuA6TsQNj6oEEmmWk
         8+jsj8mZIpQuOtmihV1P12NvbzEGFBwkE9SuYTb1sqvwo8UODX5G+7sCxQIJLF62/mKa
         Yffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8rhM0AUb28XSifpCDXIdOqSJ0aXgis9HwJ8WeGFTvA=;
        b=2poZoHchyuGxPy92PO+YsaHtZwxEXsoGQkq1HgkFLtcfrhup3RePbeKyBGh0/4AnJp
         F8udvzrbueXWu9eDMcDdSVphcI8fLyC8VEVcMej1JBzB3QEwxG9NtJt4UdW2RxE9n+7p
         rPm4937CRjpJ73TdqxVGWU+qJeBa9IxPKQbWqChVUw4hBTccSCY7HWs6pPqaf4kO8HIa
         1AzHVcDE85wUEmOKm1TlTrBJf1CoqXt2APv71sYo+/kPuocIZo9uo+gO5hpgrxLFJ6Hc
         3c7z+5Am8UYLOfcZrAKBkD0ILz5LYcbPRmPvw1oj2+4oJB0TmoNwAAL81Y16QpAbvByE
         hWfg==
X-Gm-Message-State: AOAM531BAD9yyxD6lEjlGYe48fQ7bEm6JJRHhNM/hi8NONj2c8ALz4A5
	/l9Ooe5zQ61Pqak8GtEO4580I3FmhJt+lMdvi5Ghkx/dpbE=
X-Google-Smtp-Source: ABdhPJzQ6kd9z32Km/IESdCoiX/cv1J1qD5/s745g8GFGUBao7YJJIoB6xbB0cmsgfrtl1R71Fx0fgm/TB3crzcaBoA=
X-Received: by 2002:a17:90b:4c84:b0:1d2:cadc:4e4d with SMTP id
 my4-20020a17090b4c8400b001d2cadc4e4dmr18959361pjb.8.1650672533937; Fri, 22
 Apr 2022 17:08:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YmNBJBTxUCvDHMbw@iweiny-desk3>
In-Reply-To: <YmNBJBTxUCvDHMbw@iweiny-desk3>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2022 17:08:43 -0700
Message-ID: <CAPcyv4jtNgfjWLyu6MtBAjwUiqe2qEBW802AzZZeg2gZ_wU9AQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] cxl/acpi: Add root device lockdep validation
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 22, 2022 at 4:58 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Thu, Apr 21, 2022 at 08:33:18AM -0700, Dan Williams wrote:
> > The CXL "root" device, ACPI0017, is an attach point for coordinating
> > platform level CXL resources and is the parent device for a CXL port
> > topology tree. As such it has distinct locking rules relative to other
> > CXL subsystem objects, but because it is an ACPI device the lock class
> > is established well before it is given to the cxl_acpi driver.
>
> This final sentence gave me pause because it implied that the device lock class
> was set to something other than no validate.  But I don't see that anywhere in
> the acpi code.  So given that it looks to me like ACPI is just using the
> default no validate class...

Oh, good observation. *If* ACPI had set a custom lock class then
cxl_acpi would need to be careful to restore that ACPI-specific class
and not reset it to "no validate" on exit, or skip setting its own
custom class. However, I think for generic buses like ACPI that feed
devices into other subsystems it likely has little reason to set its
own class. For safety, since device_lock_set_class() is general
purpose, I'll have it emit a debug message and fail if the class is
not "no validate" on entry.

Thanks Ira!

