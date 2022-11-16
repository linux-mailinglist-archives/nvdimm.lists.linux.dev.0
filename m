Return-Path: <nvdimm+bounces-5169-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B5B62BCF1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 13:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3508C1C2095D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 12:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04EC65CA7;
	Wed, 16 Nov 2022 12:04:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773707C
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 12:04:21 +0000 (UTC)
Received: by mail-qk1-f178.google.com with SMTP id k4so11412162qkj.8
        for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 04:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQdBkxqg5BqsUvdY+IvEe5QBnPb9zU/ugVGD23aN9Pc=;
        b=kzl0ByBJntzRHaosCcZ3H6GLnM9QkDxsXCxz/ECgRwqw+irPBUj20kd6e7ZGERm375
         m08Jpzdmd12vgX6Bycc+DeC6JzNyvtIwcSXF8+r8y2RUyPuj+a2XEwrAvnEvLxsNwk84
         acgZIH8is6BQBoq+gm/oC/MmwkzTRBmZ5TDLJPnTCbzSjho4ehwfhYenGwM0tXBs73DO
         XbY4ATspGupNDtu2A5eNpfdzWZLj9OBWayIni0oSuaYJJy1W4UwZvfbeCZ1jQclb3fFh
         SKWkWMS3Qijdp5AaNXGasR9KxkvGynTF0asPipe4FLajGII1LtY5A/Pe5wJ8J8B+rGUx
         hDbg==
X-Gm-Message-State: ANoB5pml2Uqwz80YudIsGkuOy6Wslw8n7F9MkSAh/14UXJ2F6lp1Cael
	4h3Rig8Hf+8PyNQljctpaGfZ4FjnOLubyn/7N9k=
X-Google-Smtp-Source: AA0mqf6yT2vd1Aqocqi53J5J3FryjVqUIUHcxPUW5lEr/cSGo6jsIlR1imANAiZRmrxh3QOsZPojLDJpr14dvqZYtEg=
X-Received: by 2002:a37:638f:0:b0:6ec:fa04:d97c with SMTP id
 x137-20020a37638f000000b006ecfa04d97cmr18174937qkb.764.1668600260287; Wed, 16
 Nov 2022 04:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
In-Reply-To: <20221116075736.1909690-1-vishal.l.verma@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 16 Nov 2022 13:04:07 +0100
Message-ID: <CAJZ5v0hP9p+0gWNKaOD=3FW3SDrb3ZXWaUyqVGx_GVzkapeUSA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ACPI: HMAT: fix single-initiator target registrations
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, liushixin2@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 16, 2022 at 8:57 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Patch 1 is an obvious cleanup found while fixing this problem.
>
> Patch 2 Fixes a bug with initiator registration for single-initiator
> systems. More details on this in its commit message.
>
>
> Vishal Verma (2):
>   ACPI: HMAT: remove unnecessary variable initialization
>   ACPI: HMAT: Fix initiator registration for single-initiator systems

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for both and please feel free to ask Dan to take them.

Alternatively, if you want me to apply them, please let me know.

>  drivers/acpi/numa/hmat.c | 33 ++++++++++++++++++++++++++++++---
>  1 file changed, 30 insertions(+), 3 deletions(-)
>
>
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
> --

