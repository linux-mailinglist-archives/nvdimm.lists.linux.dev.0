Return-Path: <nvdimm+bounces-3075-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA024BC088
	for <lists+linux-nvdimm@lfdr.de>; Fri, 18 Feb 2022 20:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 14D921C09AA
	for <lists+linux-nvdimm@lfdr.de>; Fri, 18 Feb 2022 19:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143BC4C7A;
	Fri, 18 Feb 2022 19:51:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BFA4C79
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 19:51:45 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id b17-20020a9d4791000000b005a17fc2dfc1so2679245otf.1
        for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 11:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mFvG05Uw2C2DK3JJHa3oaPRwbA16TTWZsXYfxs4nKwQ=;
        b=zhrkYnZh/i56D/sXZlOYx/x8qshCSMWZJkV79by3NK+jdA6mxMtjy2cyWt46NwpnbN
         L+O9kcPum78LQWMyK+CnCYuKloXfyQlujK7JXXibBlA4tq+BUoqTiO6SacqdgNxGM1XF
         9MmTg9ZyD2l+0P1MgIOLC8dXEKhfMrkOm+NIKjLsVGy5J8ekWSWNbIGIlhF3NnJtl/ck
         +lOQmHUU1ShSWE8vkaVOlv8Un/XCkU7JhezFQ+q4uyW4F5DS+ZurF646wBO6fUBKBYFr
         pMMEVAxxafiIhW2WO4zh43b844xaiHoQqy/AjMMPD1q/tNG3MDQcTllLSb9pXC/2jZdi
         0VQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mFvG05Uw2C2DK3JJHa3oaPRwbA16TTWZsXYfxs4nKwQ=;
        b=xQE6zCc75UTV7TmOfh2hcuSDXDRZu6Qa8nWT9KuAOZzgEU+s2Ytw4XLRIiSNdNaxE+
         0qnE0M94R/SupCFcVAhLSNcJq1x/gIBSdE1NpKyEKB33fLz/+1lLbULY728NK0S9HUzT
         vZTk0eKkPwVADt8ez4oc1NRcqTsVyA9ctwx/1TxKqDdt91BbD7tlZ+2QxoCbW5eC9vYb
         pUAYPSYYBICAJS43MtgBzTAIFld91Owpqev0jZfNZ96MhuvTf45HT2dh/ZzMkC4kIqzV
         INcKwYZc5+lzWRTi63X6c5BAxAFONVDyGbd/22RXDCGLnljG3ibFWFTkJxMSlxn8AOVD
         GFow==
X-Gm-Message-State: AOAM530JP3xJwyk2UAQRZpfipni3wAZp7XqlVUwdUkYipYcTUFNNr1xB
	HmJiZyNqiDx67sbZGh6ZvsK/KCVtgAlJ0p5XSQLoQQ==
X-Google-Smtp-Source: ABdhPJxpKJmKmDEWzxGfg2GfINo3iBeWaQdSVVkO5ixhiSSVccuJzQslePaoTDc/ltFMTNdaWErNDrzQGtn8XgODxEk=
X-Received: by 2002:a05:6830:910:b0:5a2:a81f:e5e1 with SMTP id
 v16-20020a056830091000b005a2a81fe5e1mr3088204ott.24.1645213904521; Fri, 18
 Feb 2022 11:51:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com> <20220128002707.391076-7-ben.widawsky@intel.com>
In-Reply-To: <20220128002707.391076-7-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Feb 2022 11:51:33 -0800
Message-ID: <CAPcyv4jnbch=LdyNwMJ9WWQNGNnE3gqC5msLUBc3ncUXE6+15w@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] cxl/region: Address space allocation
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> When a region is not assigned a host physical address,

Curious, is there a way to pick one in the current ABI? Not that I
want one, in fact I think Linux should make it as difficult as
possible to create a region with a fixed address (per the 'HPA' field
of the region label) given all the problems it can cause with decoder
allocation ordering. Unless and until someone identifies a solid use
case for that capability it should be de-emphasized.

> one is picked by
> the driver. As the address will determine which CFMWS contains the
> region, it's usually a better idea to let the driver make this
> determination.
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/region.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
> index cc41939a2f0a..5588873dd250 100644
> --- a/drivers/cxl/region.c
> +++ b/drivers/cxl/region.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2021 Intel Corporation. All rights reserved. */
>  #include <linux/platform_device.h>
> +#include <linux/genalloc.h>
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> @@ -64,6 +65,20 @@ static struct cxl_port *get_root_decoder(const struct cxl_memdev *endpoint)
>         return NULL;
>  }
>
> +static void release_cxl_region(void *r)
> +{
> +       struct cxl_region *cxlr = (struct cxl_region *)r;
> +       struct cxl_decoder *rootd = rootd_from_region(cxlr);
> +       struct resource *res = &rootd->platform_res;
> +       resource_size_t start, size;
> +
> +       start = cxlr->res->start;
> +       size = resource_size(cxlr->res);
> +
> +       __release_region(res, start, size);
> +       gen_pool_free(rootd->address_space, start, size);

If the need to keep the gen_pool in sync is dropped then this
open-coded devm release handler can be replaced with
__devm_request_region().

> +}
> +
>  /**
>   * sanitize_region() - Check is region is reasonably configured
>   * @cxlr: The region to check
> @@ -129,8 +144,29 @@ static int sanitize_region(const struct cxl_region *cxlr)
>   */
>  static int allocate_address_space(struct cxl_region *cxlr)
>  {
> -       /* TODO */

The problem with TODOs is now I forget which context calls
allocate_address_space(). If the caller was added in this patch it
would be reviewable, as is, I need to go to another window to search
"allocate_address_space" to recall that it is called from
cxl_region_probe(). That's too late as someone defining a region
should know upfront a region creation time that space has been
reserved, or not.

> -       return 0;
> +       struct cxl_decoder *rootd = rootd_from_region(cxlr);
> +       unsigned long start;

s/unsigned long/resource_size_t/?

> +
> +       start = gen_pool_alloc(rootd->address_space, cxlr->config.size);
> +       if (!start) {
> +               dev_dbg(&cxlr->dev, "Couldn't allocate %lluM of address space",
> +                       cxlr->config.size >> 20);
> +               return -ENOMEM;
> +       }
> +
> +       cxlr->res =
> +               __request_region(&rootd->platform_res, start, cxlr->config.size,
> +                                dev_name(&cxlr->dev), IORESOURCE_MEM);
> +       if (!cxlr->res) {
> +               dev_dbg(&cxlr->dev, "Couldn't obtain region from %s (%pR)\n",
> +                       dev_name(&rootd->dev), &rootd->platform_res);
> +               gen_pool_free(rootd->address_space, start, cxlr->config.size);
> +               return -ENOMEM;
> +       }
> +
> +       dev_dbg(&cxlr->dev, "resource %pR", cxlr->res);
> +
> +       return devm_add_action_or_reset(&cxlr->dev, release_cxl_region, cxlr);
>  }
>
>  /**
> --
> 2.35.0
>

