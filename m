Return-Path: <nvdimm+bounces-1161-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A89E400452
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Sep 2021 19:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 52B3D3E1028
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Sep 2021 17:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433623FDE;
	Fri,  3 Sep 2021 17:51:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A119772
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 17:51:32 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id m26so106276pff.3
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 10:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B42gsDWG6sRhF8u1dVxsiIOrQG1CZU86y4GnMNNM3og=;
        b=UYqUXm1HSA1fkpMppgozipb6YR2uES6VTVF5TnR2wMBh/4PelrdClptrhHH1zPHsOT
         lH+D9eXX32ZBO1/kzrFQkw77zY/tym2SEtuTSfarEUFvG5PTZNOr6U78OS7T8mYDDaLY
         T+YA/DzVdydXqRJe9af8jMHvD9ABvn9LgKUzyyJZU21kZjt2tantYVyCm4rzBYd3deEY
         S197O+deImOUEMM+fSeHu0Wz3U3Gr4BVsdEW+Xzo8a2TLsIbPGggocA7mg5/HzraXtrZ
         bJsK7v4cg52VwnVKL0VRjkJ1LbGXaV1mMzgXnPB4pZ4iH0iZsKypmrsvWgIeO6KQ5s9m
         RaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B42gsDWG6sRhF8u1dVxsiIOrQG1CZU86y4GnMNNM3og=;
        b=avguntEcQdq2TqawORnbmkvBagHGfDmqoVqHfPUjx12rGa15AQFymI6jlwD8rXAg+R
         ZUwEiDjexCQ3R/Ax2IUQ81NmtgkWk53201zlWPzN6ZMlYVaDZJGxIu4HpJtjOhRQLBew
         5wu5GxDSepkTjg+m4b81NNxb7z16F6fQjUKxTa42/A5vnExZ9Fw80gRDXU2VzeOV7OnL
         GopQo8CPv+XLWmEyIT+udETpxDXT4oMXswFcr+EZ4VK3SUskd3D+D4QOteJOEXiqb5UH
         FLncAyTEpm3GaMbhfL9rlFSbF3ki9iTJBt7gn66x1V30Ne15AxMGooGVYYYH/bzxKcgv
         0OaA==
X-Gm-Message-State: AOAM533vZ9Vmn24k5JNdGhnhjY9HJz1X78m1Z7aIJzJIxo/nZXqtC3kf
	fnLG7D1RcXm8Vz78jzwgMouCB2XFdgH3twIc1pztEw==
X-Google-Smtp-Source: ABdhPJxYQ+JeD0UWwnT9Y+SgxEhqvpnfZFxl0ACPyfhDVFtvfy9H+6vYmp7vGBqhsMV2trnrjcdOLrBywa+McZUGK/A=
X-Received: by 2002:a63:1262:: with SMTP id 34mr209923pgs.356.1630691491989;
 Fri, 03 Sep 2021 10:51:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982124835.1124374.16212896894542743429.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210902193031.000035b4@Huawei.com>
In-Reply-To: <20210902193031.000035b4@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 10:51:21 -0700
Message-ID: <CAPcyv4hocfkjizFD=153+OeKYR1-UfhG1k8qYEqnFWPMW4oMqw@mail.gmail.com>
Subject: Re: [PATCH v3 23/28] cxl/acpi: Do not add DSDT disabled ACPI0016 host
 bridge ports
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Alison Schofield <alison.schofield@intel.com>, 
	stable <stable@vger.kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 2, 2021 at 11:30 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:07:28 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > During CXL ACPI probe, host bridge ports are discovered by scanning
> > the ACPI0017 root port for ACPI0016 host bridge devices. The scan
> > matches on the hardware id of "ACPI0016". An issue occurs when an
> > ACPI0016 device is defined in the DSDT yet disabled on the platform.
> > Attempts by the cxl_acpi driver to add host bridge ports using a
> > disabled device fails, and the entire cxl_acpi probe fails.
> >
> > The DSDT table includes an _STA method that sets the status and the
> > ACPI subsystem has checks available to examine it. One such check is
> > in the acpi_pci_find_root() path. Move the call to acpi_pci_find_root()
> > to the matching function to prevent this issue when adding either
> > upstream or downstream ports.
> You could mention that has the side effect that the existing
> call in add_host_bridge_uport() is now guarantee not to fail so
> can be moved closer to where it is used.  That chunk had
> me briefly confused.
>
> >
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > Fixes: 7d4b5ca2e2cb ("cxl/acpi: Add downstream port data to cxl_port instances")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> I'd imagine we want to get this in an early rc so perhaps pull out of
> this series.

I'm going to keep it in this series because it causes merge conflicts
for what follows, but I'll merge it independently of the follow-on
reworks which may need to wait another cycle.

>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
>
> > ---
> >  drivers/cxl/acpi.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index 8ae89273f58e..2d8f1ec1abff 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -243,6 +243,9 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
> >  {
> >       struct acpi_device *adev = to_acpi_device(dev);
> >
> > +     if (!acpi_pci_find_root(adev->handle))
> > +             return NULL;
> > +
> >       if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
> >               return adev;
> >       return NULL;
> > @@ -266,10 +269,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >       if (!bridge)
> >               return 0;
> >
> > -     pci_root = acpi_pci_find_root(bridge->handle);
> > -     if (!pci_root)
> > -             return -ENXIO;
> > -
> >       dport = find_dport_by_dev(root_port, match);
> >       if (!dport) {
> >               dev_dbg(host, "host bridge expected and not found\n");
> > @@ -282,6 +281,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >               return PTR_ERR(port);
> >       dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
> >
> > +     pci_root = acpi_pci_find_root(bridge->handle);
> >       ctx = (struct cxl_walk_context){
> >               .dev = host,
> >               .root = pci_root->bus,
> >
>
>

