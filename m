Return-Path: <nvdimm+bounces-1372-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A079413741
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 18:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 490E51C0B5C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 16:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E323FCB;
	Tue, 21 Sep 2021 16:18:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1506A72
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 16:18:50 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id a7so5098415plm.1
        for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 09:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0G5U6z7sfNV5LHWThwvwuz5VR0tMErzouInHALjLCbk=;
        b=W/poHxzqVbRNujcvVMnJBITE0shyret2Kv1mY3ojwmid5lQqLdJJXrdVebYNn7HSZ7
         CqOjSzjQjFu/ljfl87tQTS1QV/Az70WahftLGywwMURsfDIFqCFd2kA83A+0VdwGi9oW
         CJeqUsoAoqLQf2LcR692bjQ/UCV8p0PYD/rU/hBHIHZJ3LXqs0dpStcNyOS+tp/52XZ5
         Krnahx9m3aNFU33wOVkCSZ6+auufTKBA2HEI3Z3ptAr53agtnmIzkNIkH8SzhtZyGGVN
         a7b21xTH6jgV88m0hd16WmXFN0wv1bMkdF+gvjXVdoZIiLtifJzLUdjo5sDWtrhtznvc
         Ejcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0G5U6z7sfNV5LHWThwvwuz5VR0tMErzouInHALjLCbk=;
        b=WLINpoRxPsXdksnICsUIVNbuUGZIdZ78e2G6SX7jclrnTj7+99ifT0O6NsKEJ0PLaq
         ybINhGqvczQsuV5PT19wpSEb/0Ri1ZE4TfyQqCLvO/+Yfvt5GQtITqIJZMS+CRcDkjTa
         hOjGCoRag1VbFeRsfj0Y4VI98sBQHhGihRW4R0h5+PoQBswyn30kX78bylmAFl8NfXSf
         kvm0QS7d8CgTPjEtSdZLR7AQfd3rturAyF66hHvYzo4Z51iJks2WHFPmeJa4vHzJ5FZW
         ohkqEi/IJSGFboS1wlMvYAv/lH9fcwOqDf8v7JXY1SXWtg+Cxqph6ST8fIwSI6GSN+M7
         46zQ==
X-Gm-Message-State: AOAM533ARWNdA5zWP1WaK7DShXUchoCBN/dQs7J2WkneGMRWPPvPOXxD
	R+8EFscFeQPW7xvGiKWfkwdTAkesI5r2XN8lIqKrRg==
X-Google-Smtp-Source: ABdhPJxW6PRixbws32rcPYh3WeVfHuhjd+FMM8h2r/uxROH2o5v4h9XRZe9S+z/CpPehalIOyXN5XtCe5MShUtLWI4E=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr6059115pjb.93.1632241130006;
 Tue, 21 Sep 2021 09:18:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116440612.2460985.14600637290781306289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163164780319.2831662.7853294454760344393.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210921142407.efq4ttlqngdnaxf2@intel.com>
In-Reply-To: <20210921142407.efq4ttlqngdnaxf2@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Sep 2021 09:18:39 -0700
Message-ID: <CAPcyv4g9MgN_Qwu4wZykZpprm+XkK80VK6joVc4dQFdzsZijfA@mail.gmail.com>
Subject: Re: [PATCH v5 21/21] cxl/core: Split decoder setup into alloc + add
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Nathan Chancellor <nathan@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 21, 2021 at 7:24 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-14 12:31:22, Dan Williams wrote:
> > The kbuild robot reports:
> >
> >     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
> >     limit (1024) in function 'devm_cxl_add_decoder'
> >
> > It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> > all the different decoder types. Fix the stack usage by splitting the
> > creation into alloc and add steps. This also allows for context
> > specific construction before adding.
> >
> > With the split the caller is responsible for registering a devm callback
> > to trigger device_unregister() for the decoder rather than it being
> > implicit in the decoder registration. I.e. the routine that calls alloc
> > is responsible for calling put_device() if the "add" operation fails.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> I have some comments inline. You can take them or leave them. Hopefully you can
> pull in my patch to document these after too.
>
> Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
>
> > ---
> > Changes since v4:
> > - hold the device lock over the list_empty(&port->dports) check
> >   (Jonathan)
> > - move the list_empty() check after the check for NULL @target_map in
> >   anticipation of endpoint decoders (Ben)
> >
> >  drivers/cxl/acpi.c      |   84 +++++++++++++++++++++++---------
> >  drivers/cxl/core/bus.c  |  123 +++++++++++++++--------------------------------
> >  drivers/cxl/core/core.h |    5 --
> >  drivers/cxl/core/pmem.c |    7 ++-
> >  drivers/cxl/cxl.h       |   15 ++----
> >  5 files changed, 110 insertions(+), 124 deletions(-)
> >
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index d39cc797a64e..2368a8b67698 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -82,7 +82,6 @@ static void cxl_add_cfmws_decoders(struct device *dev,
> >       struct cxl_decoder *cxld;
> >       acpi_size len, cur = 0;
> >       void *cedt_subtable;
> > -     unsigned long flags;
> >       int rc;
> >
> >       len = acpi_cedt->length - sizeof(*acpi_cedt);
> > @@ -119,24 +118,36 @@ static void cxl_add_cfmws_decoders(struct device *dev,
> >               for (i = 0; i < CFMWS_INTERLEAVE_WAYS(cfmws); i++)
> >                       target_map[i] = cfmws->interleave_targets[i];
> >
> > -             flags = cfmws_to_decoder_flags(cfmws->restrictions);
> > -             cxld = devm_cxl_add_decoder(dev, root_port,
> > -                                         CFMWS_INTERLEAVE_WAYS(cfmws),
> > -                                         cfmws->base_hpa, cfmws->window_size,
> > -                                         CFMWS_INTERLEAVE_WAYS(cfmws),
> > -                                         CFMWS_INTERLEAVE_GRANULARITY(cfmws),
> > -                                         CXL_DECODER_EXPANDER,
> > -                                         flags, target_map);
> > -
> > -             if (IS_ERR(cxld)) {
> > +             cxld = cxl_decoder_alloc(root_port,
> > +                                      CFMWS_INTERLEAVE_WAYS(cfmws));
> > +             if (IS_ERR(cxld))
> > +                     goto next;
> > +
> > +             cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
> > +             cxld->target_type = CXL_DECODER_EXPANDER;
> > +             cxld->range = (struct range) {
> > +                     .start = cfmws->base_hpa,
> > +                     .end = cfmws->base_hpa + cfmws->window_size - 1,
> > +             };
> > +             cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
> > +             cxld->interleave_granularity =
> > +                     CFMWS_INTERLEAVE_GRANULARITY(cfmws);
> > +
> > +             rc = cxl_decoder_add(cxld, target_map);
> > +             if (rc)
> > +                     put_device(&cxld->dev);
> > +             else
> > +                     rc = cxl_decoder_autoremove(dev, cxld);
>
> For posterity, I'll say I don't love this interface overall, but I don't have a
> better suggestion.
>
> alloc()
> open coded configuration
> add()
> open coded autoremove
>
> I understand some of the background on moving the responsibility of the devm
> callback to the actual aller, it just ends up a fairly weird interface now since
> all 4 steps are needed to actually create a decoder for consumption by the
> driver.
>
> I'd request a new function to configure the decoder before adding except I don't
> think it's worth doing that either.

Certainly this approach was taken for practical reasons, not elegance.
I too don't see how to clean this up further. It's either make the
caller responsible for all steps, or have monster functions for all
the possible ways a decoder might be configured and tempt the stack
window warnings again.

>
> > +             if (rc) {
> >                       dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
> >                               cfmws->base_hpa, cfmws->base_hpa +
> >                               cfmws->window_size - 1);
>
> Do you think it makes sense to explain to the user what the consequence is of
> this?

In the log message? No, I think that would be too pedantic.

>
> > -             } else {
> > -                     dev_dbg(dev, "add: %s range %#llx-%#llx\n",
> > -                             dev_name(&cxld->dev), cfmws->base_hpa,
> > -                              cfmws->base_hpa + cfmws->window_size - 1);
> > +                     goto next;
> >               }
> > +             dev_dbg(dev, "add: %s range %#llx-%#llx\n",
> > +                     dev_name(&cxld->dev), cfmws->base_hpa,
> > +                     cfmws->base_hpa + cfmws->window_size - 1);
> > +next:
> >               cur += c->length;
> >       }
> >  }
> > @@ -266,6 +277,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >       struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> >       struct acpi_pci_root *pci_root;
> >       struct cxl_walk_context ctx;
> > +     int single_port_map[1], rc;
> >       struct cxl_decoder *cxld;
> >       struct cxl_dport *dport;
> >       struct cxl_port *port;
> > @@ -301,22 +313,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >               return -ENODEV;
> >       if (ctx.error)
> >               return ctx.error;
> > +     if (ctx.count > 1)
> > +             return 0;
> >
> >       /* TODO: Scan CHBCR for HDM Decoder resources */
> >
> >       /*
> > -      * In the single-port host-bridge case there are no HDM decoders
> > -      * in the CHBCR and a 1:1 passthrough decode is implied.
> > +      * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> > +      * Structure) single ported host-bridges need not publish a decoder
> > +      * capability when a passthrough decode can be assumed, i.e. all
> > +      * transactions that the uport sees are claimed and passed to the single
> > +      * dport. Default the range a 0-base 0-length until the first CXL region
> > +      * is activated.
> >        */
> > -     if (ctx.count == 1) {
> > -             cxld = devm_cxl_add_passthrough_decoder(host, port);
> > -             if (IS_ERR(cxld))
> > -                     return PTR_ERR(cxld);
> > +     cxld = cxl_decoder_alloc(port, 1);
> > +     if (IS_ERR(cxld))
> > +             return PTR_ERR(cxld);
> > +
> > +     cxld->interleave_ways = 1;
> > +     cxld->interleave_granularity = PAGE_SIZE;
> > +     cxld->target_type = CXL_DECODER_EXPANDER;
> > +     cxld->range = (struct range) {
> > +             .start = 0,
> > +             .end = -1,
> > +     };
> >
> > -             dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
> > -     }
> > +     device_lock(&port->dev);
> > +     dport = list_first_entry(&port->dports, typeof(*dport), list);
> > +     device_unlock(&port->dev);
> >
> > -     return 0;
> > +     single_port_map[0] = dport->port_id;
> > +
> > +     rc = cxl_decoder_add(cxld, single_port_map);
> > +     if (rc)
> > +             put_device(&cxld->dev);
> > +     else
> > +             rc = cxl_decoder_autoremove(host, cxld);
> > +
> > +     if (rc == 0)
> > +             dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
> > +     return rc;
> >  }
> >
> >  static int add_host_bridge_dport(struct device *match, void *arg)
> > diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> > index 6dfdeaf999f0..396252749477 100644
> > --- a/drivers/cxl/core/bus.c
> > +++ b/drivers/cxl/core/bus.c
> > @@ -453,10 +453,8 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport_dev, int port_id,
> >  }
> >  EXPORT_SYMBOL_GPL(cxl_add_dport);
> >
> > -static int decoder_populate_targets(struct device *host,
> > -                                 struct cxl_decoder *cxld,
> > -                                 struct cxl_port *port, int *target_map,
> > -                                 int nr_targets)
> > +static int decoder_populate_targets(struct cxl_decoder *cxld,
> > +                                 struct cxl_port *port, int *target_map)
> >  {
> >       int rc = 0, i;
> >
> > @@ -464,42 +462,36 @@ static int decoder_populate_targets(struct device *host,
> >               return 0;
> >
> >       device_lock(&port->dev);
> > -     for (i = 0; i < nr_targets; i++) {
> > +     if (list_empty(&port->dports)) {
> > +             rc = -EINVAL;
> > +             goto out_unlock;
> > +     }
>
> Forewarning, I think I'm still going to need to modify this check for endpoints.

I should have expanded the amount of context in the diff. That "return
0;" above is from the !target_map check which should be true for
endpoints, that was one of your earlier feedback items that I heeded.
So I don't think you'll trip over this.

>
> > +
> > +     for (i = 0; i < cxld->nr_targets; i++) {
> >               struct cxl_dport *dport = find_dport(port, target_map[i]);
> >
> >               if (!dport) {
> >                       rc = -ENXIO;
> > -                     break;
> > +                     goto out_unlock;
> >               }
> > -             dev_dbg(host, "%s: target: %d\n", dev_name(dport->dport), i);
> >               cxld->target[i] = dport;
> >       }
> > +
> > +out_unlock:
> >       device_unlock(&port->dev);
> >
> >       return rc;
> >  }
> >
> > -static struct cxl_decoder *
> > -cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
> > -               resource_size_t base, resource_size_t len,
> > -               int interleave_ways, int interleave_granularity,
> > -               enum cxl_decoder_type type, unsigned long flags,
> > -               int *target_map)
> > +struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
> >  {
> >       struct cxl_decoder *cxld;
> >       struct device *dev;
> >       int rc = 0;
> >
> > -     if (interleave_ways < 1)
> > +     if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets < 1)
> >               return ERR_PTR(-EINVAL);
> >
> > -     device_lock(&port->dev);
> > -     if (list_empty(&port->dports))
> > -             rc = -EINVAL;
> > -     device_unlock(&port->dev);
> > -     if (rc)
> > -             return ERR_PTR(rc);
> > -
> >       cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
> >       if (!cxld)
> >               return ERR_PTR(-ENOMEM);
> > @@ -508,22 +500,8 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
> >       if (rc < 0)
> >               goto err;
> >
> > -     *cxld = (struct cxl_decoder) {
> > -             .id = rc,
> > -             .range = {
> > -                     .start = base,
> > -                     .end = base + len - 1,
> > -             },
> > -             .flags = flags,
> > -             .interleave_ways = interleave_ways,
> > -             .interleave_granularity = interleave_granularity,
> > -             .target_type = type,
> > -     };
> > -
> > -     rc = decoder_populate_targets(host, cxld, port, target_map, nr_targets);
> > -     if (rc)
> > -             goto err;
> > -
> > +     cxld->id = rc;
> > +     cxld->nr_targets = nr_targets;
>
> Would be really nice if cxld->nr_targets could be const...
>

Sure, conversion is a little messy, but not too bad.

> >       dev = &cxld->dev;
> >       device_initialize(dev);
> >       device_set_pm_not_required(dev);
> > @@ -541,72 +519,47 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
> >       kfree(cxld);
> >       return ERR_PTR(rc);
> >  }
> > +EXPORT_SYMBOL_GPL(cxl_decoder_alloc);
> >
> > -struct cxl_decoder *
> > -devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
> > -                  resource_size_t base, resource_size_t len,
> > -                  int interleave_ways, int interleave_granularity,
> > -                  enum cxl_decoder_type type, unsigned long flags,
> > -                  int *target_map)
> > +int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
> >  {
> > -     struct cxl_decoder *cxld;
> > +     struct cxl_port *port;
> >       struct device *dev;
> >       int rc;
> >
> > -     if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
> > -             return ERR_PTR(-EINVAL);
> > +     if (!cxld)
> > +             return -EINVAL;
>
> I don't mind, but I think calling this with !cxld is a driver bug, right?
> Perhaps upgrade to WARN_ONCE?

Sure.

>
> >
> > -     cxld = cxl_decoder_alloc(host, port, nr_targets, base, len,
> > -                              interleave_ways, interleave_granularity, type,
> > -                              flags, target_map);
> >       if (IS_ERR(cxld))
> > -             return cxld;
> > +             return PTR_ERR(cxld);
>
> Same as above.

Ok.

>
> >
> > -     dev = &cxld->dev;
> > -     rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
> > -     if (rc)
> > -             goto err;
> > +     if (cxld->interleave_ways < 1)
> > +             return -EINVAL;
> >
> > -     rc = device_add(dev);
> > +     port = to_cxl_port(cxld->dev.parent);
> > +     rc = decoder_populate_targets(cxld, port, target_map);
> >       if (rc)
> > -             goto err;
> > +             return rc;
> >
> > -     rc = devm_add_action_or_reset(host, unregister_cxl_dev, dev);
> > +     dev = &cxld->dev;
> > +     rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
> >       if (rc)
> > -             return ERR_PTR(rc);
> > -     return cxld;
> > +             return rc;
> >
> > -err:
> > -     put_device(dev);
> > -     return ERR_PTR(rc);
> > +     return device_add(dev);
> >  }
> > -EXPORT_SYMBOL_GPL(devm_cxl_add_decoder);
> > +EXPORT_SYMBOL_GPL(cxl_decoder_add);
> >
> > -/*
> > - * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability Structure)
> > - * single ported host-bridges need not publish a decoder capability when a
> > - * passthrough decode can be assumed, i.e. all transactions that the uport sees
> > - * are claimed and passed to the single dport. Default the range a 0-base
> > - * 0-length until the first CXL region is activated.
> > - */
> > -struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> > -                                                  struct cxl_port *port)
> > +static void cxld_unregister(void *dev)
> >  {
> > -     struct cxl_dport *dport;
> > -     int target_map[1];
> > -
> > -     device_lock(&port->dev);
> > -     dport = list_first_entry_or_null(&port->dports, typeof(*dport), list);
> > -     device_unlock(&port->dev);
> > -
> > -     if (!dport)
> > -             return ERR_PTR(-ENXIO);
> > +     device_unregister(dev);
> > +}
> >
> > -     target_map[0] = dport->port_id;
> > -     return devm_cxl_add_decoder(host, port, 1, 0, 0, 1, PAGE_SIZE,
> > -                                 CXL_DECODER_EXPANDER, 0, target_map);
> > +int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld)
> > +{
> > +     return devm_add_action_or_reset(host, cxld_unregister, &cxld->dev);
> >  }
> > -EXPORT_SYMBOL_GPL(devm_cxl_add_passthrough_decoder);
> > +EXPORT_SYMBOL_GPL(cxl_decoder_autoremove);
> >
> >  /**
> >   * __cxl_driver_register - register a driver for the cxl bus
> > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > index c85b7fbad02d..e0c9aacc4e9c 100644
> > --- a/drivers/cxl/core/core.h
> > +++ b/drivers/cxl/core/core.h
> > @@ -9,11 +9,6 @@ extern const struct device_type cxl_nvdimm_type;
> >
> >  extern struct attribute_group cxl_base_attribute_group;
> >
> > -static inline void unregister_cxl_dev(void *dev)
> > -{
> > -     device_unregister(dev);
> > -}
> > -
> >  struct cxl_send_command;
> >  struct cxl_mem_query_commands;
> >  int cxl_query_cmd(struct cxl_memdev *cxlmd,
> > diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> > index 74be5132df1c..5032f4c1c69d 100644
> > --- a/drivers/cxl/core/pmem.c
> > +++ b/drivers/cxl/core/pmem.c
> > @@ -222,6 +222,11 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> >       return cxl_nvd;
> >  }
> >
> > +static void cxl_nvd_unregister(void *dev)
> > +{
> > +     device_unregister(dev);
> > +}
> > +
> >  /**
> >   * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
> >   * @host: same host as @cxlmd
> > @@ -251,7 +256,7 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
> >       dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
> >               dev_name(dev));
> >
> > -     return devm_add_action_or_reset(host, unregister_cxl_dev, dev);
> > +     return devm_add_action_or_reset(host, cxl_nvd_unregister, dev);
> >
> >  err:
> >       put_device(dev);
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 9af5745ba2c0..7d6b011dd963 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -195,6 +195,7 @@ enum cxl_decoder_type {
> >   * @interleave_granularity: data stride per dport
> >   * @target_type: accelerator vs expander (type2 vs type3) selector
> >   * @flags: memory type capabilities and locking
> > + * @nr_targets: number of elements in @target
> >   * @target: active ordered target list in current decoder configuration
> >   */
> >  struct cxl_decoder {
> > @@ -205,6 +206,7 @@ struct cxl_decoder {
> >       int interleave_granularity;
> >       enum cxl_decoder_type target_type;
> >       unsigned long flags;
> > +     int nr_targets;
> >       struct cxl_dport *target[];
> >  };
> >
> > @@ -286,15 +288,10 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
> >
> >  struct cxl_decoder *to_cxl_decoder(struct device *dev);
> >  bool is_root_decoder(struct device *dev);
> > -struct cxl_decoder *
> > -devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
> > -                  resource_size_t base, resource_size_t len,
> > -                  int interleave_ways, int interleave_granularity,
> > -                  enum cxl_decoder_type type, unsigned long flags,
> > -                  int *target_map);
> > -
> > -struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> > -                                                  struct cxl_port *port);
> > +struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets);
> > +int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> > +int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
> > +
> >  extern struct bus_type cxl_bus_type;
> >
> >  struct cxl_driver {
> >

