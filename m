Return-Path: <nvdimm+bounces-3582-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB79505EF5
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Apr 2022 22:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E3D573E0F46
	for <lists+linux-nvdimm@lfdr.de>; Mon, 18 Apr 2022 20:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B87BA5A;
	Mon, 18 Apr 2022 20:44:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A946A57
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 20:44:02 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id q19so20969461pgm.6
        for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 13:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+UgbLDaJtSB6rOG9TeMdW2cweljs8feo1/VhSf13JoA=;
        b=q9OuY9l+exvDdLTbBj1LnecrWW4sk7c+klMzxUEuWylA0upeRxsV7P68KONxZCes6p
         pPSiKHlMuVInXOKfb1KMdObEwnBcZwK+Ezn5m5lefw/fUYackuoVkCCucx/1tLy1FvPR
         NNNDLMHKJCxxRmRnYiMTjrbMOKM/oM0Ptd3UOlDOXwNFaiJUnlrmP741GrjwcReWnUCH
         J9vE8Gmw8q/2rmPHILp/YEjnBzqLyKYRe3/KhsPfju2jW+VxmFxF5WiEL7zZawpnXmbx
         T014q7A4Gfu7DEjhlUGIm74fvRjau03EgySglYSjL4xAX2E3h8P7MkSlcY/Bxu/xX5zi
         zgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+UgbLDaJtSB6rOG9TeMdW2cweljs8feo1/VhSf13JoA=;
        b=cROYm3wrttdFwabNCNNicNuJ2D0iVz4OGSSi8tKFEQQ8ZsjwjBUaf+u+++iuv2HZDE
         aoKp5GvPw/xl8yIyIZzkdNKn4UhW4UZPj8m9nyzbBcXh3ydK4poopHQGwFCZBkfHKPYV
         rz3n34kwTIDUAWp88nboyTJnFtqVGXN526YnId0I063/ZVA0OvKrl6m0aPty0gF1uqz8
         +54FAneDPFYtv90kuPfvYasxtxbIQUaso9rzgzKrKA91GwSg7kLqrpHA61z8UuA//B7M
         48vWQYMLv9hsAKUb7x2Act+m/f3Mp029l8vNZpSjn/DN+O9Vzvu1/hNgoP+Vqa2gLlpf
         X0sQ==
X-Gm-Message-State: AOAM531pIRyNe9L87Qug772aefijB1NXnE6wHVPnCb1l5aB4++SdaluL
	Y5QixRyTUwqu9oN0jQczWMYl0PCRnLWhlIJOL+/laA==
X-Google-Smtp-Source: ABdhPJyJIAwjaQrk8laELix5m7l9tFxoxiItu5fis/ODVXycnJ2/orYccBqUIuYVnS8LvYoc4MqsblXdRE+hH26xO7I=
X-Received: by 2002:a65:6e0e:0:b0:399:26d7:a224 with SMTP id
 bd14-20020a656e0e000000b0039926d7a224mr11536864pgb.437.1650314642384; Mon, 18
 Apr 2022 13:44:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-5-ben.widawsky@intel.com> <CAPcyv4h-VhTaePD+YvC+TKiQ8AU=JFvuEWyONLu6rYasRd4SYA@mail.gmail.com>
In-Reply-To: <CAPcyv4h-VhTaePD+YvC+TKiQ8AU=JFvuEWyONLu6rYasRd4SYA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Apr 2022 13:43:51 -0700
Message-ID: <CAPcyv4gfPibccNXgwkBS+7iKqAkmMNZmx02+LCqnb1NeoqGncw@mail.gmail.com>
Subject: Re: [RFC PATCH 04/15] cxl/core: Create distinct decoder structs
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 14, 2022 at 6:45 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > CXL HDM decoders have distinct properties at each level in the
> > hierarchy. Root decoders manage host physical address space. Switch
> > decoders manage demultiplexing of data to downstream targets. Endpoint
> > decoders must be aware of physical media size constraints. To properly
> > support these unique needs, create these unique structures.
> >
> > CXL HDM decoders do have similar architectural properties at all levels:
> > interleave properties, flags, types and consumption of host physical
> > address space. Those are retained and when possible, still utilized.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > ---
> >  drivers/cxl/core/hdm.c       |   3 +-
> >  drivers/cxl/core/port.c      | 102 ++++++++++++++++++++++++-----------
> >  drivers/cxl/cxl.h            |  69 +++++++++++++++++++++---
> >  tools/testing/cxl/test/cxl.c |   2 +-
> >  4 files changed, 137 insertions(+), 39 deletions(-)
> >
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 3055e246aab9..37c09c77e9a7 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -6,6 +6,7 @@
> >
> >  #include "cxlmem.h"
> >  #include "core.h"
> > +#include "cxl.h"
> >
> >  /**
> >   * DOC: cxl core hdm
> > @@ -242,7 +243,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
> >                 struct cxl_decoder *cxld;
> >
> >                 if (is_cxl_endpoint(port))
> > -                       cxld = cxl_endpoint_decoder_alloc(port);
> > +                       cxld = &cxl_endpoint_decoder_alloc(port)->base;
>
> Please split to:
>
> cxled = cxl_endpoint_decoder_alloc(port);
> cxld = &cxled->base;
>
> >                 else
> >                         cxld = cxl_switch_decoder_alloc(port, target_count);
> >                 if (IS_ERR(cxld)) {
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index 86f451ecb7ed..8dd29c97e318 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -121,18 +121,19 @@ static DEVICE_ATTR_RO(target_type);
> >
> >  static ssize_t emit_target_list(struct cxl_decoder *cxld, char *buf)
> >  {
> > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> >         ssize_t offset = 0;
> >         int i, rc = 0;
> >
> >         for (i = 0; i < cxld->interleave_ways; i++) {
> > -               struct cxl_dport *dport = cxld->target[i];
> > +               struct cxl_dport *dport = t->target[i];
> >                 struct cxl_dport *next = NULL;
> >
> >                 if (!dport)
> >                         break;
> >
> >                 if (i + 1 < cxld->interleave_ways)
> > -                       next = cxld->target[i + 1];
> > +                       next = t->target[i + 1];
> >                 rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
> >                                    next ? "," : "");
> >                 if (rc < 0)
> > @@ -147,14 +148,15 @@ static ssize_t target_list_show(struct device *dev,
> >                                 struct device_attribute *attr, char *buf)
> >  {
> >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> >         ssize_t offset;
> >         unsigned int seq;
> >         int rc;
> >
> >         do {
> > -               seq = read_seqbegin(&cxld->target_lock);
> > +               seq = read_seqbegin(&t->target_lock);
> >                 rc = emit_target_list(cxld, buf);
> > -       } while (read_seqretry(&cxld->target_lock, seq));
> > +       } while (read_seqretry(&t->target_lock, seq));
> >
> >         if (rc < 0)
> >                 return rc;
> > @@ -199,23 +201,6 @@ static const struct attribute_group *cxl_decoder_root_attribute_groups[] = {
> >         NULL,
> >  };
> >
> > -static struct attribute *cxl_decoder_switch_attrs[] = {
> > -       &dev_attr_target_type.attr,
> > -       &dev_attr_target_list.attr,
> > -       NULL,
> > -};
> > -
> > -static struct attribute_group cxl_decoder_switch_attribute_group = {
> > -       .attrs = cxl_decoder_switch_attrs,
> > -};
> > -
> > -static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
> > -       &cxl_decoder_switch_attribute_group,
> > -       &cxl_decoder_base_attribute_group,
> > -       &cxl_base_attribute_group,
> > -       NULL,
> > -};
> > -
> >  static struct attribute *cxl_decoder_endpoint_attrs[] = {
> >         &dev_attr_target_type.attr,
> >         NULL,
> > @@ -232,6 +217,12 @@ static const struct attribute_group *cxl_decoder_endpoint_attribute_groups[] = {
> >         NULL,
> >  };
> >
> > +static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
> > +       &cxl_decoder_base_attribute_group,
> > +       &cxl_base_attribute_group,
> > +       NULL,
> > +};
> > +
> >  static void cxl_decoder_release(struct device *dev)
> >  {
> >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > @@ -264,6 +255,7 @@ bool is_endpoint_decoder(struct device *dev)
> >  {
> >         return dev->type == &cxl_decoder_endpoint_type;
> >  }
> > +EXPORT_SYMBOL_NS_GPL(is_endpoint_decoder, CXL);
> >
> >  bool is_root_decoder(struct device *dev)
> >  {
> > @@ -1136,6 +1128,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
> >  static int decoder_populate_targets(struct cxl_decoder *cxld,
> >                                     struct cxl_port *port, int *target_map)
> >  {
> > +       struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
> >         int i, rc = 0;
> >
> >         if (!target_map)
> > @@ -1146,21 +1139,72 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
> >         if (list_empty(&port->dports))
> >                 return -EINVAL;
> >
> > -       write_seqlock(&cxld->target_lock);
> > -       for (i = 0; i < cxld->nr_targets; i++) {
> > +       write_seqlock(&t->target_lock);
> > +       for (i = 0; i < t->nr_targets; i++) {
> >                 struct cxl_dport *dport = find_dport(port, target_map[i]);
> >
> >                 if (!dport) {
> >                         rc = -ENXIO;
> >                         break;
> >                 }
> > -               cxld->target[i] = dport;
> > +               t->target[i] = dport;
> >         }
> > -       write_sequnlock(&cxld->target_lock);
> > +       write_sequnlock(&t->target_lock);
> >
> >         return rc;
> >  }
> >
> > +static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
> > +                                              unsigned int nr_targets)
> > +{
> > +       struct cxl_decoder *cxld;
> > +
> > +       if (is_cxl_endpoint(port)) {
> > +               struct cxl_endpoint_decoder *cxled;
> > +
> > +               cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
> > +               if (!cxled)
> > +                       return NULL;
> > +               cxld = &cxled->base;
> > +       } else if (is_cxl_root(port)) {
> > +               struct cxl_root_decoder *cxlrd;
> > +
> > +               cxlrd = kzalloc(sizeof(*cxlrd), GFP_KERNEL);
> > +               if (!cxlrd)
> > +                       return NULL;
> > +
> > +               cxlrd->targets =
> > +                       kzalloc(struct_size(cxlrd->targets, target, nr_targets),
> > +                               GFP_KERNEL);
> > +               if (!cxlrd->targets) {
> > +                       kfree(cxlrd);
> > +                       return NULL;
> > +               }
> > +               cxlrd->targets->nr_targets = nr_targets;
> > +               seqlock_init(&cxlrd->targets->target_lock);
> > +               cxld = &cxlrd->base;
> > +       } else {
> > +               struct cxl_switch_decoder *cxlsd;
> > +
> > +               cxlsd = kzalloc(sizeof(*cxlsd), GFP_KERNEL);
> > +               if (!cxlsd)
> > +                       return NULL;
> > +
> > +               cxlsd->targets =
> > +                       kzalloc(struct_size(cxlsd->targets, target, nr_targets),
> > +                               GFP_KERNEL);
> > +               if (!cxlsd->targets) {
> > +                       kfree(cxlsd);
> > +                       return NULL;
> > +               }
> > +               cxlsd->targets->nr_targets = nr_targets;
> > +               seqlock_init(&cxlsd->targets->target_lock);
> > +               cxld = &cxlsd->base;
> > +       }
> > +
> > +       return cxld;
> > +}
> > +
> >  /**
> >   * cxl_decoder_alloc - Allocate a new CXL decoder
> >   * @port: owning port of this decoder
> > @@ -1186,7 +1230,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> >         if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
> >                 return ERR_PTR(-EINVAL);
> >
> > -       cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
> > +       cxld = __cxl_decoder_alloc(port, nr_targets);
> >         if (!cxld)
> >                 return ERR_PTR(-ENOMEM);
> >
> > @@ -1198,8 +1242,6 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> >         get_device(&port->dev);
> >         cxld->id = rc;
> >
> > -       cxld->nr_targets = nr_targets;
> > -       seqlock_init(&cxld->target_lock);
> >         dev = &cxld->dev;
> >         device_initialize(dev);
> >         device_set_pm_not_required(dev);
> > @@ -1274,12 +1316,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
> >   *
> >   * Return: A new cxl decoder to be registered by cxl_decoder_add()
> >   */
> > -struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
> > +struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
> >  {
> >         if (!is_cxl_endpoint(port))
> >                 return ERR_PTR(-EINVAL);
> >
> > -       return cxl_decoder_alloc(port, 0);
> > +       return to_cxl_endpoint_decoder(cxl_decoder_alloc(port, 0));
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
> >
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 6517d5cdf5ee..85fd5e84f978 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -193,6 +193,18 @@ enum cxl_decoder_type {
> >   */
> >  #define CXL_DECODER_MAX_INTERLEAVE 16
> >
> > +/**
> > + * struct cxl_decoder_targets - Target information for root and switch decoders.
> > + * @target_lock: coordinate coherent reads of the target list
> > + * @nr_targets: number of elements in @target
> > + * @target: active ordered target list in current decoder configuration
> > + */
> > +struct cxl_decoder_targets {
> > +       seqlock_t target_lock;
> > +       int nr_targets;
> > +       struct cxl_dport *target[];
> > +};
> > +
> >  /**
> >   * struct cxl_decoder - CXL address range decode configuration
> >   * @dev: this decoder's device
> > @@ -202,9 +214,6 @@ enum cxl_decoder_type {
> >   * @interleave_granularity: data stride per dport
> >   * @target_type: accelerator vs expander (type2 vs type3) selector
> >   * @flags: memory type capabilities and locking
> > - * @target_lock: coordinate coherent reads of the target list
> > - * @nr_targets: number of elements in @target
> > - * @target: active ordered target list in current decoder configuration
> >   */
> >  struct cxl_decoder {
> >         struct device dev;
> > @@ -214,11 +223,46 @@ struct cxl_decoder {
> >         int interleave_granularity;
> >         enum cxl_decoder_type target_type;
> >         unsigned long flags;
> > -       seqlock_t target_lock;
> > -       int nr_targets;
> > -       struct cxl_dport *target[];
> >  };
> >
> > +/**
> > + * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
> > + * @base: Base class decoder
> > + */
> > +struct cxl_endpoint_decoder {
> > +       struct cxl_decoder base;
> > +};
> > +
> > +/**
> > + * struct cxl_switch_decoder - A decoder in a switch or hostbridge.
> > + * @base: Base class decoder
> > + * @targets: Downstream targets for this switch.
> > + */
> > +struct cxl_switch_decoder {
> > +       struct cxl_decoder base;
> > +       struct cxl_decoder_targets *targets;
>
> Please no double-allocation when not necessary. This can be
>
> struct cxl_switch_decoder {
>        struct cxl_decoder base;
>        struct cxl_decoder_targets targets;
> };
>
> ...and then allocated with a single:
>
> cxlsd = kzalloc(struct_size(cxlsd, targets.target, nr_targets), GFP_KERNEL);
>
> ...or something like that (not compile tested).
>
> > +};
>
> > +};
> > +
> > +/**
> > + * struct cxl_root_decoder - A toplevel/platform decoder
> > + * @base: Base class decoder
> > + * @targets: Downstream targets (ie. hostbridges).
> > + */
> > +struct cxl_root_decoder {
> > +       struct cxl_decoder base;
> > +       struct cxl_decoder_targets *targets;
> > +};
>
> Ditto single allocation feedback...
>
> ...although now that struct cxl_root_decoder is identical to
> cxl_switch_decoder is there any benefit to making them distinct types
> beyond being pedantic? Making them the same type means
> cxl_get_decoder_targets() can go because all callers of that are
> already in known !cxl_endpoint_decoder paths. But of course ignore
> this if cxl_root_decoder is going to game some differentiating
> attributes down the road, I have not looked ahead in this series.

Actually regardless of whether root decoders gain additional
attributes they should simply be a strict super-set of root decoders:

struct cxl_endpoint_decoder {
       /* future endpoint decoder specific attributes go here */
      struct cxl_decoder base;
};

struct cxl_switch_decoder {
       struct cxl_decoder base;
       seqlock_t target_lock;
       int nr_targets;
       struct cxl_dport *target[];
};

struct cxl_root_decoder {
       /* future root decoder specific attributes go here */
       struct cxl_switch_decoder cxlsd;
};

> > +#define _to_cxl_decoder(x)                                                     \
> > +       static inline struct cxl_##x##_decoder *to_cxl_##x##_decoder(          \
> > +               struct cxl_decoder *cxld)                                      \
> > +       {                                                                      \
> > +               return container_of(cxld, struct cxl_##x##_decoder, base);     \
> > +       }
> > +
> > +_to_cxl_decoder(root)
> > +_to_cxl_decoder(switch)
> > +_to_cxl_decoder(endpoint)

Per above root decoders could no longer use this macro which was
already borderline not worth doing in my view.

