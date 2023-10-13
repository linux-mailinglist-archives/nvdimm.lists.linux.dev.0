Return-Path: <nvdimm+bounces-6795-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB707C8C59
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Oct 2023 19:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 587581C21151
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Oct 2023 17:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90FD224D9;
	Fri, 13 Oct 2023 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D753621362
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-57c0775d4fcso354657eaf.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 10:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697218400; x=1697823200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDfH1O6ogKZ8M8NviATD62mLbrLkHU8SBP3Zaxp2SRo=;
        b=bedHt4i+FJNl3Vp3Ja8rqBW73e4auqo1bImJ9C3dmJHRsPnBKjlZTTNnsszv32Y7A+
         SHUWQWWtOTxHg+ABsElKQ7F+z6eucnUrmAtz3Vq4gma8CCDeRmQ/bNoIqd9L/R/Oc8MF
         NB5Qnz+QimTktr1OFryLnzgtUVSfJcMUrJdCkFa3pqi3JAmONWWch7+cTPoyDtNITUHh
         G/ZR1+5zZur/uOJIZyNB/fIU93auolqVEOpAzwlnr/1wGbYap4QVfjlsqef3pRbc59OS
         xjbeW/aHpGZQunyBOVnsc809Fsh5kpv/WYvqkT8RxLzTqFQCIcJFuf7nFbzumiXdLU+O
         7M4w==
X-Gm-Message-State: AOJu0YyylgbLZxzr7HypGsc9ATTKF+0JQCXgXhXMXl5+AhvXlde74fUO
	waPlZLdeP3woXlutjbL40Dp3F1mcc+0/cfNb/tw=
X-Google-Smtp-Source: AGHT+IGpqTtsrxMYUFtH5deAkA/tEHSXWzMLbD5VN81q1HO9y18wLTNYO9yqm/6IUKNcHYlc8iapeVquTEbU8laEsmo=
X-Received: by 2002:a4a:de08:0:b0:56e:94ed:c098 with SMTP id
 y8-20020a4ade08000000b0056e94edc098mr26637440oot.0.1697218399800; Fri, 13 Oct
 2023 10:33:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011083334.3987477-1-michal.wilczynski@intel.com> <20231011083334.3987477-2-michal.wilczynski@intel.com>
In-Reply-To: <20231011083334.3987477-2-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 13 Oct 2023 19:33:08 +0200
Message-ID: <CAJZ5v0gGi5joPQ2dCUs_oPZgPqT_=Y-z7epXE2mfYdmp7DOwQQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] ACPI: AC: Remove unnecessary checks
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 10:34=E2=80=AFAM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Remove unnecessary checks for NULL for variables that can't be NULL at
> the point they're checked for it. Defensive programming is discouraged
> in the kernel.
>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/ac.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index aac3e561790c..83d45c681121 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -131,9 +131,6 @@ static void acpi_ac_notify(acpi_handle handle, u32 ev=
ent, void *data)
>         struct acpi_device *device =3D data;
>         struct acpi_ac *ac =3D acpi_driver_data(device);
>
> -       if (!ac)
> -               return;
> -
>         switch (event) {
>         default:
>                 acpi_handle_debug(device->handle, "Unsupported event [0x%=
x]\n",
> @@ -216,12 +213,8 @@ static const struct dmi_system_id ac_dmi_table[]  __=
initconst =3D {
>  static int acpi_ac_add(struct acpi_device *device)
>  {
>         struct power_supply_config psy_cfg =3D {};
> -       int result =3D 0;
> -       struct acpi_ac *ac =3D NULL;
> -
> -
> -       if (!device)
> -               return -EINVAL;
> +       struct acpi_ac *ac;
> +       int result;
>
>         ac =3D kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
>         if (!ac)
> @@ -275,16 +268,9 @@ static int acpi_ac_add(struct acpi_device *device)
>  #ifdef CONFIG_PM_SLEEP
>  static int acpi_ac_resume(struct device *dev)
>  {
> -       struct acpi_ac *ac;
> +       struct acpi_ac *ac =3D acpi_driver_data(to_acpi_device(dev));
>         unsigned int old_state;
>
> -       if (!dev)
> -               return -EINVAL;
> -
> -       ac =3D acpi_driver_data(to_acpi_device(dev));
> -       if (!ac)
> -               return -EINVAL;
> -
>         old_state =3D ac->state;
>         if (acpi_ac_get_state(ac))
>                 return 0;
> @@ -299,12 +285,7 @@ static int acpi_ac_resume(struct device *dev)
>
>  static void acpi_ac_remove(struct acpi_device *device)
>  {
> -       struct acpi_ac *ac =3D NULL;
> -
> -       if (!device || !acpi_driver_data(device))
> -               return;
> -
> -       ac =3D acpi_driver_data(device);
> +       struct acpi_ac *ac =3D acpi_driver_data(device);
>
>         acpi_dev_remove_notify_handler(device, ACPI_ALL_NOTIFY,
>                                        acpi_ac_notify);
> --

Applied as 6.7 material with edits in the subject and changelog, thanks!

