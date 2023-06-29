Return-Path: <nvdimm+bounces-6243-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AD0742A3F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 29 Jun 2023 18:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 664301C20B15
	for <lists+linux-nvdimm@lfdr.de>; Thu, 29 Jun 2023 16:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8BA12B97;
	Thu, 29 Jun 2023 16:07:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7712B89
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 16:07:06 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-98e2865e2f2so22181866b.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 09:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688054824; x=1690646824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xfZ/TTJf1ZjgTOZZ4dAslTfGuQT8e+I59Ry3r/mWbg=;
        b=FPsolf4CWJKjsuyXGhb2xzFNPJQiBZxaR+E22BuHQq92IE4Qw01lHiCX56oiU7NwJ6
         Jv0UVhqj9fBqo9liE3D8jLghUSzhv05mjanFi0xPTd6OPZsHHjFclmX/Fpol18DA/58Z
         Ew/Em9JD8vR7Z6DGRG7vkWY+Dplq1jGaRZAMf86Snj3a12OpjFHxcf7pYUi1HtIQ+2Ix
         CNNxzecgYtkfiw2XE74Q5r/afQvJsWsdMVH6H2h4oCXmIGNQ7IvpfXtVM+jK//vfbTd4
         x68V7hPRUIx3/a2yNoiSynd1Ir0kLTKqtXzDcqU0M6Nb3gOd7Mkkzi0zI+tV59iNXgEk
         HG+w==
X-Gm-Message-State: AC+VfDwblITSgY88nrIf4mc6biEOu1D80LyEYSEkIVe+nBgi6fa3Jbe1
	kucbhNtcOMXgD2wha0oOX+JBhPgpclS94tKTN4A=
X-Google-Smtp-Source: ACHHUZ7cgRYS8YYVr3hCgsEpgcP5bbQZjvy53V/YLYKMqwUMwZxw17sb6Umt8V35dOqpNIQVa2PqIZJi+LLWZLBY/tI=
X-Received: by 2002:a17:906:7a45:b0:988:8e7a:d953 with SMTP id
 i5-20020a1709067a4500b009888e7ad953mr2397442ejo.1.1688054824132; Thu, 29 Jun
 2023 09:07:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-8-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-8-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 18:06:53 +0200
Message-ID: <CAJZ5v0jjwk+jVsULD8nyguc7p00Sn3Hyxq7=PLNzpj-Fz6H6sg@mail.gmail.com>
Subject: Re: [PATCH v5 07/10] acpi/nfit: Move acpi_nfit_notify() before acpi_nfit_add()
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> To use new style of installing event handlers acpi_nfit_notify() needs
> to be known inside acpi_nfit_add(). Move acpi_nfit_notify() upwards in
> the file, so it can be used inside acpi_nfit_add().
>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 07204d482968..aff79cbc2190 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3312,6 +3312,13 @@ void acpi_nfit_shutdown(void *data)
>  }
>  EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
>
> +static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> +{
> +       device_lock(&adev->dev);
> +       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> +       device_unlock(&adev->dev);
> +}
> +
>  static int acpi_nfit_add(struct acpi_device *adev)
>  {
>         struct acpi_buffer buf =3D { ACPI_ALLOCATE_BUFFER, NULL };
> @@ -3446,13 +3453,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_h=
andle handle, u32 event)
>  }
>  EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
>
> -static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> -{
> -       device_lock(&adev->dev);
> -       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> -       device_unlock(&adev->dev);
> -}
> -
>  static const struct acpi_device_id acpi_nfit_ids[] =3D {
>         { "ACPI0012", 0 },
>         { "", 0 },
> --

Please fold this patch into the next one.  By itself, it is an
artificial change IMV.

