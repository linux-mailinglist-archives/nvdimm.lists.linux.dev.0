Return-Path: <nvdimm+bounces-9269-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D949BD677
	for <lists+linux-nvdimm@lfdr.de>; Tue,  5 Nov 2024 21:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D55C1F21D10
	for <lists+linux-nvdimm@lfdr.de>; Tue,  5 Nov 2024 20:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9171C21441E;
	Tue,  5 Nov 2024 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzMTeaq7"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C387212F07;
	Tue,  5 Nov 2024 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730837062; cv=none; b=o9VGHah25c5xjHFd/iXTcaLTBpT6qBrCdq6u5iKBBexj1soJhvUSIMiueqgLlppy+SS8imIdLWy35MxtNuWzRCeGUNesZBJkLbhD448379rPCW1++6i5V3PFHf0XYbQBSCapLGGRpaAad1c+eaFU5oKSr4kILB8skp8VDZBdKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730837062; c=relaxed/simple;
	bh=eJoGcopdNmljlIMHeVs7FeUmL5g59KaYGS7jljq7dCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B76hW7ZXWzUYZVXnETq9FcH6EojGsvPJbJm9nB+nVDcvOSNN8CnDFO9wkN1L7bphfWqUJXIwEtjMTO7hKH+JNqk5Oe+EZAabclhqtasIbuasEGdnwFiZktVZyw9FzaSv0vcBS9ek1Tt9RIxQz+7FNXWu8X5rWojB6qPe37SWTXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzMTeaq7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD856C4CED6;
	Tue,  5 Nov 2024 20:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730837061;
	bh=eJoGcopdNmljlIMHeVs7FeUmL5g59KaYGS7jljq7dCs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GzMTeaq7fCS1exkS/vtJilvht2YJpxm9mt4RoUVJ0SEuNviyMOUQgWPawSmVsDQPW
	 z+uKsvixeObCwX1WOGaIu8oHHkJf/6iyxLN+TRfPGBovoQYpCzyyvbyjc+pk9HP+K6
	 BjTZXC5eTo9Gscap5mHEkWgtFJiWjzbnIRaC0hes8c5jZF2ZY/uKs+M5+/SdEsuj9m
	 /JQig/ZjP82XsX3bmA5YE0Gaf15muS3K/k8I4KDsG0m4+XNjSYONaOocNXmx7m32CK
	 syKf2iamG9DIfBueifjqoR4H1g/WeVkAQ97CIW11aIzSBIoOy/PmmB5YwJKhckZaao
	 Vb8B5d6GbHa4g==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-290d8d5332cso2816442fac.2;
        Tue, 05 Nov 2024 12:04:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVg6XiXMIffhPDRSrpLcSnUtlkyARyn4arV6q6+pysoasE4DEgjzI1ZfbUmVwTjQnwqQ7NoSz6u@lists.linux.dev, AJvYcCXi4fOAFXEmEjcFzWGLiayAQ89jGy6/zYL+0kJR/oKt1cQxsJcasYiKR0OHaQb+2b12DcRRyMXZy6RhyrI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxZhIaJs1CWblWYsx269JFg1xhnvRUsRg7BIkJKqCF+KxsZ6Wk
	RO35w/83jOy8qoKepI3WfcJRpKzB6Q2q4qPMnybsuXDxJDbw+XezOWR8bIki3XlrHEn7ayupAZu
	IEknN5Rm2SCAT4+YvSVvqfJ5RiHc=
X-Google-Smtp-Source: AGHT+IEYpuCksg/9E0B6w++BeVqadbre9CIsSPMlA6oA/XZdzHEtTpwsUXwlrZjqDz7xxdZrIHS69StkEz26h9FXpvk=
X-Received: by 2002:a05:6870:a588:b0:261:1aad:2c03 with SMTP id
 586e51a60fabf-2949f07e31fmr9323988fac.43.1730837060944; Tue, 05 Nov 2024
 12:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com> <20241105-dcd-type2-upstream-v6-2-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-2-85c7fa2140fe@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 5 Nov 2024 21:04:09 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gRM_cgBPivkey7Z8P0kOFfhoBZC49RSwe9s_Cuax3Cag@mail.gmail.com>
Message-ID: <CAJZ5v0gRM_cgBPivkey7Z8P0kOFfhoBZC49RSwe9s_Cuax3Cag@mail.gmail.com>
Subject: Re: [PATCH v6 02/27] ACPI/CDAT: Add CDAT/DSMAS shared and read only
 flag values
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Navneet Singh <navneet.singh@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>, 
	Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org, 
	acpica-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 7:38=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wrot=
e:
>
> The Coherent Device Attribute Table (CDAT) Device Scoped Memory Affinity
> Structure (DSMAS) version 1.04 [1] defines flags to indicate if a DPA ran=
ge
> is read only and/or shared.
>
> Add read only and shareable flag definitions.
>
> This change was merged in ACPI via PR 976.[2]

s/ACPI/ACPICA/

>
> Link: https://uefi.org/sites/default/files/resources/Coherent%20Device%20=
Attribute%20Table_1.04%20published_0.pdf [1]
> Link: https://github.com/acpica/acpica/pull/976 [2]
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: acpica-devel@lists.linux.dev
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

With the above change:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  include/acpi/actbl1.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 199afc2cd122ca8b383b1c9286f8c8cc33842fae..387fc821703a80b324637743f=
0d5afe03b8d7943 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -403,6 +403,8 @@ struct acpi_cdat_dsmas {
>  /* Flags for subtable above */
>
>  #define ACPI_CDAT_DSMAS_NON_VOLATILE        (1 << 2)
> +#define ACPI_CDAT_DSMAS_SHAREABLE           (1 << 3)
> +#define ACPI_CDAT_DSMAS_READ_ONLY           (1 << 6)
>
>  /* Subtable 1: Device scoped Latency and Bandwidth Information Structure=
 (DSLBIS) */
>
>
> --
> 2.47.0
>
>

