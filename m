Return-Path: <nvdimm+bounces-2703-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 673F94A4F9E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 20:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 8CCE81C0A4B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 19:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702692CA8;
	Mon, 31 Jan 2022 19:43:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AC52CA1
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 19:43:26 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id b15so13432998plg.3
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 11:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BJ5eTNOljeQiBb+4Da9lfe/D8UXMTP9lhbMmuMvfP4=;
        b=5sbnuwLig36cQG8vix7th9LzbbtzUoQalxLr7+K0uu7gmmt7Z8Jrz1TUYhic1rbxgc
         U2eJIV9uol8XOqR58z1WjU+OZQVTxOrYP0M9X98W5kuNmPrhluYMJZ/BkKn/cquh1hAZ
         ihK93dgZvsZ6aZDelcVRCiZ/7zvvcjuI/7TGgH6Bq4te/yQGYMn1p3/1lSdjhI3z62Na
         sI8VWGfE2FMz8xmhe1yoFl1AFrgzRoI6yAcji4ceiNDY6UZEY5gK408u6ZyyfN8UZlkQ
         4JSraEzqntn1esccbmqGlzOm5rUw34W/wx47WxDSKHYa/95EmKh0rFOgDuV3F56J7TYN
         DWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BJ5eTNOljeQiBb+4Da9lfe/D8UXMTP9lhbMmuMvfP4=;
        b=oSdATz4+zB0hLUpJ9e4ojl/vRAN6VQPGKQXAmuxFGde92rGW4rhnZoDCMIgs8gVelb
         2oPV71nq9SFJg2jmt1sOZ19SXqINGp71rUI0UGNV3pfs3v04px7jzUd/CfsZbvUr23Tp
         Le7SPagRmqiFhiaRkGE7lKZY9P18ox2bzkM87QtQ73/YpaLART8H/dVpP+9snZ1EhvE8
         lbcK/8FO3WS31+PjpTKY8Dqem32AlM11+5G3EvJk6wpZsjKTcPhwHzFa/gHsVAbrKYv6
         chrdNtCQSUeOLShuFGM8nd/Ue5lKMcOy2JVXI+1Ku9juGNRAFkHYxuQ1C/gEzw3A3R0y
         WtHw==
X-Gm-Message-State: AOAM532r/X5ne6BZalgUj1dm8/zWpPZaBl8ezCiwgUm0JWL+uyG3vaOM
	qzNnJeFWjhHLjXKeiuzmclIYMANEytr77HTdVHEh8fRAmj4=
X-Google-Smtp-Source: ABdhPJy2O50aGMUcEo0FcluXeWfsaGxwDyhWt2H4x476asF9rwa/VodoepiNVkjHxWcP0klAwphdF3Ec3v2oWndLxCI=
X-Received: by 2002:a17:902:d705:: with SMTP id w5mr21674211ply.34.1643658205909;
 Mon, 31 Jan 2022 11:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298419875.3018233.7880727408723281411.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131154848.00006615@Huawei.com>
In-Reply-To: <20220131154848.00006615@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 11:43:17 -0800
Message-ID: <CAPcyv4hkoNzWhXgM6aEMTXF-mc=Z4A71d-XwbUpJypc=Mqi2Uw@mail.gmail.com>
Subject: Re: [PATCH v3 15/40] cxl: Prove CXL locking
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 7:49 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:29:58 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > When CONFIG_PROVE_LOCKING is enabled the 'struct device' definition gets
> > an additional mutex that is not clobbered by
> > lockdep_set_novalidate_class() like the typical device_lock(). This
> > allows for local annotation of subsystem locks with mutex_lock_nested()
> > per the subsystem's object/lock hierarchy. For CXL, this primarily needs
> > the ability to lock ports by depth and child objects of ports by their
> > parent parent-port lock.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Hi Dan,
>
> This infrastructure is nice.
>
> A few comments inline - mostly requests for a few comments to make
> life easier when reading this in future.  Also, I'd slightly prefer
> this as 2 patches so the trivial nvdimm / Kconfig.debug stuff is separate
> from the patch actually introducing support for this in CXL.

The nvdimm changes don't really stand on their own, because there is
no need for them until the second user arrives. Also splitting patches
mid-stream confuses b4, so unless it's a clear cut case, like needs to
be split for backport reasons, I prefer to keep it combined in this
case.

>
> Anyhow, all trivial stuff so as far as I'm concerned.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> Thanks,
>
> Jonathan
>
> > ---
> >  drivers/cxl/acpi.c       |   10 +++---
> >  drivers/cxl/core/pmem.c  |    4 +-
> >  drivers/cxl/core/port.c  |   43 ++++++++++++++++++++-------
> >  drivers/cxl/cxl.h        |   74 ++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/pmem.c       |   12 ++++---
> >  drivers/nvdimm/nd-core.h |    2 +
> >  lib/Kconfig.debug        |   23 ++++++++++++++
> >  7 files changed, 143 insertions(+), 25 deletions(-)
> >
>
>
> > @@ -712,15 +725,23 @@ static int cxl_bus_match(struct device *dev, struct device_driver *drv)
> >
> >  static int cxl_bus_probe(struct device *dev)
> >  {
> > -     return to_cxl_drv(dev->driver)->probe(dev);
> > +     int rc;
> > +
> > +     cxl_nested_lock(dev);
>
> I guess it is 'fairly' obvious why this call is here (I assume because the device
> lock is already held), but maybe worth a comment?

Sure.

>
> > +     rc = to_cxl_drv(dev->driver)->probe(dev);
> > +     cxl_nested_unlock(dev);
> > +
> > +     return rc;
> >  }
> >
> >  static void cxl_bus_remove(struct device *dev)
> >  {
> >       struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
> >
> > +     cxl_nested_lock(dev);
> >       if (cxl_drv->remove)
> >               cxl_drv->remove(dev);
> > +     cxl_nested_unlock(dev);
> >  }
> >
> >  struct bus_type cxl_bus_type = {
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index c1dc53492773..569cbe7f23d6 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -285,6 +285,7 @@ static inline bool is_cxl_root(struct cxl_port *port)
> >       return port->uport == port->dev.parent;
> >  }
> >
> > +bool is_cxl_port(struct device *dev);
> >  struct cxl_port *to_cxl_port(struct device *dev);
> >  struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
> >                                  resource_size_t component_reg_phys,
> > @@ -295,6 +296,7 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
> >
> >  struct cxl_decoder *to_cxl_decoder(struct device *dev);
> >  bool is_root_decoder(struct device *dev);
> > +bool is_cxl_decoder(struct device *dev);
> >  struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
> >                                          unsigned int nr_targets);
> >  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
> > @@ -347,4 +349,76 @@ struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
> >  #ifndef __mock
> >  #define __mock static
> >  #endif
> > +
> > +#ifdef CONFIG_PROVE_CXL_LOCKING
> > +enum cxl_lock_class {
> > +     CXL_ANON_LOCK,
> > +     CXL_NVDIMM_LOCK,
> > +     CXL_NVDIMM_BRIDGE_LOCK,
> > +     CXL_PORT_LOCK,
>
> As you are going to increment off the end of this perhaps a comment
> here so that no one thinks "I'll just add another entry after CXL_PORT_LOCK"

Ah, yes. It's subtle that you can't define anything after the
CXL_PORT_LOCK definition unless you also defined some maximum CXL port
depth. It's at least worth a comment to say as much.

>
> > +};
> > +
> > +static inline void cxl_nested_lock(struct device *dev)
> > +{
> > +     if (is_cxl_port(dev)) {
> > +             struct cxl_port *port = to_cxl_port(dev);
> > +
> > +             mutex_lock_nested(&dev->lockdep_mutex,
> > +                               CXL_PORT_LOCK + port->depth);
> > +     } else if (is_cxl_decoder(dev)) {
> > +             struct cxl_port *port = to_cxl_port(dev->parent);
> > +
> > +             mutex_lock_nested(&dev->lockdep_mutex,
> > +                               CXL_PORT_LOCK + port->depth + 1);
>
> Perhaps a comment on why port->dev + 1 is a safe choice?
> Not immediately obvious to me and I'm too lazy to figure it out :)

Oh, it's because a decoder is a child of its parent port so it should
be locked at the same level as other immediate child of the port. Will
comment.

>
> > +     } else if (is_cxl_nvdimm_bridge(dev))
> > +             mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_BRIDGE_LOCK);
> > +     else if (is_cxl_nvdimm(dev))
> > +             mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_LOCK);
> > +     else
> > +             mutex_lock_nested(&dev->lockdep_mutex, CXL_ANON_LOCK);
> > +}
> > +
> > +static inline void cxl_nested_unlock(struct device *dev)
> > +{
> > +     mutex_unlock(&dev->lockdep_mutex);
> > +}
> > +
> > +static inline void cxl_device_lock(struct device *dev)
> > +{
> > +     /*
> > +      * For double lock errors the lockup will happen before lockdep
> > +      * warns at cxl_nested_lock(), so assert explicitly.
> > +      */
> > +     lockdep_assert_not_held(&dev->lockdep_mutex);
> > +
> > +     device_lock(dev);
> > +     cxl_nested_lock(dev);
> > +}
> > +
> > +static inline void cxl_device_unlock(struct device *dev)
> > +{
> > +     cxl_nested_unlock(dev);
> > +     device_unlock(dev);
> > +}
> > +#else
> > +static inline void cxl_nested_lock(struct device *dev)
> > +{
> > +}
> > +
> > +static inline void cxl_nested_unlock(struct device *dev)
> > +{
> > +}
> > +
> > +static inline void cxl_device_lock(struct device *dev)
> > +{
> > +     device_lock(dev);
> > +}
> > +
> > +static inline void cxl_device_unlock(struct device *dev)
> > +{
> > +     device_unlock(dev);
> > +}
> > +#endif
> > +
> > +
>
> One blank line only.

Ok.

>
> >  #endif /* __CXL_H__ */
> ...
> > diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> > index a11850dd475d..2650a852eeaf 100644
> > --- a/drivers/nvdimm/nd-core.h
> > +++ b/drivers/nvdimm/nd-core.h
> > @@ -185,7 +185,7 @@ static inline void devm_nsio_disable(struct device *dev,
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_PROVE_LOCKING
> > +#ifdef CONFIG_PROVE_NVDIMM_LOCKING
> >  extern struct class *nd_class;
> >
> >  enum {
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 9ef7ce18b4f5..ea9291723d06 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -1509,6 +1509,29 @@ config CSD_LOCK_WAIT_DEBUG
> >         include the IPI handler function currently executing (if any)
> >         and relevant stack traces.
> >
> > +choice
> > +     prompt "Lock debugging: prove subsystem device_lock() correctness"
> > +     depends on PROVE_LOCKING
> > +     help
> > +       For subsystems that have instrumented their usage of the device_lock()
> > +       with nested annotations, enable lock dependency checking. The locking
> > +       hierarchy 'subclass' identifiers are not compatible across
> > +       sub-systems, so only one can be enabled at a time.
> > +
> > +config PROVE_NVDIMM_LOCKING
> > +     bool "NVDIMM"
> > +     depends on LIBNVDIMM
> > +     help
> > +       Enable lockdep to validate nd_device_lock() usage.
>
> I would slightly have preferred a first patch that pulled out the NVDIMM parts
> and a second that introduced it for CXL.

Noted.

> > +
> > +config PROVE_CXL_LOCKING
> > +     bool "CXL"
> > +     depends on CXL_BUS
> > +     help
> > +       Enable lockdep to validate cxl_device_lock() usage.
> > +
> > +endchoice
> > +
> >  endmenu # lock debugging
> >
> >  config TRACE_IRQFLAGS
> >
>

