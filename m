Return-Path: <nvdimm+bounces-3076-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 322524BC122
	for <lists+linux-nvdimm@lfdr.de>; Fri, 18 Feb 2022 21:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 70D103E0FF2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 18 Feb 2022 20:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9DB4C80;
	Fri, 18 Feb 2022 20:23:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548794C7C
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 20:23:46 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 195so8797200pgc.6
        for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 12:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GyqkxaZxl73TqFha4nD8IMbHVF8tfQHRwYUPfxNvUcU=;
        b=GXHbSOxiCTn+hCpMAxL5Mp9N0hk5yrn8bjBJtigPwOdmVcfx9vr3TcZVrnkxEEelY5
         qZoZkwi2rAZSQ13I0fT51F/Z+GGkxByRmMWOm77tkKM1cMpbEBUhAunEVbt6rLH+UIx0
         rsh77i3UrTa/MmBYAQmSf2XF3BzmEvyo/yOFxKn6gQzqDHkKl9pN9lMAdYo3exHmxlPm
         XrLS7kzIWK411UMMIPsdVqAkwq22t+IocQe925lWA5zsajEfrF7VM4Cqe1aAwrZGKLR3
         HXJu8BAqFhy7gZ1GTy+qtqOywY9jycxA9EsZtRNFWSSvhXj9qtPwTWQfqHv76l5LnRSS
         hlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyqkxaZxl73TqFha4nD8IMbHVF8tfQHRwYUPfxNvUcU=;
        b=J2x3ZfQO0K9E5NJs4yihQDaP5EdoA//vaSPdjXonnIefy/He3j3l8ddy/1ZZ14D7rs
         5BXsZysBc9Mvce+/iLG/f8/3Lew7QrHvruGv3iKYRiRRSY3UkZVSfCLG3or6OqMrQKWS
         hV1xS0QJuAysX3d0f7bPq+FOcXqv4LE3y0gzYrLSXRKnh43l+EfOnwbDbqebj/xvKTyO
         9yEeVUt6h03TfqyoOLoT6tr7XwuEjR1f/2156knhKD21MtZg4K/KIyn8IlUmxIyERTPI
         BvXLBCnlxffMPZNcBZKPnvXZVbXhNFg+Cp3CmlevlloGaDeFqJlJGODA6siqmCAV+oGo
         8zBA==
X-Gm-Message-State: AOAM5302rVpiYuYwGaiylGF1rbk/1aDqxaSOpIK6GhAdv4Z3NCB77lv1
	QIuwxbhBnxr09LC56GlJXrrJDKjiblf/BQlaFlrqww==
X-Google-Smtp-Source: ABdhPJzixhQyIw1tn6LwQvktyhGOjkKda6ppQ+LSCyqOBgZdCojip1jmRw5NbgXbCarC8LVTGH4gcemK3zeOBnlfCQU=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr7792614pgb.74.1645215825608; Fri, 18
 Feb 2022 12:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com> <20220128002707.391076-8-ben.widawsky@intel.com>
In-Reply-To: <20220128002707.391076-8-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Feb 2022 12:23:34 -0800
Message-ID: <CAPcyv4jn+kF-7qBXny_MBCCF9OdDFmVNaRx=sK+TWGTmkWgeww@mail.gmail.com>
Subject: Re: [PATCH v3 07/14] cxl/region: Implement XHB verification
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Cross host bridge verification primarily determines if the requested
> interleave ordering can be achieved by the root decoder, which isn't as
> programmable as other decoders.

I don't understand that comment. Are you talking about the CFMWS
static decoders that can not be programmed at all, or the 1st level
decoders beneath that.

> The algorithm implemented here is based on the CXL Type 3 Memory Device
> Software Guide, chapter 2.13.14

Just spell out the support here and don't require the reader to read
that other doc to understand if it follows it exactly, or takes some
liberties. I.e. the assumptions and tradeoffs built into the design
choices in the patch need to be spelled out here.

>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
> Changes since v2:
> - Fail earlier on lack of host bridges. This should only be capable as
>   of now with cxl_test memdevs.
> ---
>  .clang-format        |  2 +
>  drivers/cxl/cxl.h    | 13 +++++++
>  drivers/cxl/region.c | 89 +++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/.clang-format b/.clang-format
> index fa959436bcfd..1221d53be90b 100644
> --- a/.clang-format
> +++ b/.clang-format
> @@ -169,6 +169,8 @@ ForEachMacros:
>    - 'for_each_cpu_and'
>    - 'for_each_cpu_not'
>    - 'for_each_cpu_wrap'
> +  - 'for_each_cxl_decoder_target'
> +  - 'for_each_cxl_endpoint'
>    - 'for_each_dapm_widgets'
>    - 'for_each_dev_addr'
>    - 'for_each_dev_scope'
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index b300673072f5..a291999431c7 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -81,6 +81,19 @@ static inline int cxl_to_interleave_ways(u8 eniw)
>         }
>  }
>
> +static inline u8 cxl_to_eniw(u8 ways)
> +{
> +       if (is_power_of_2(ways))
> +               return ilog2(ways);
> +
> +       return ways / 3 + 8;
> +}
> +
> +static inline u8 cxl_to_ig(u16 g)
> +{
> +       return ilog2(g) - 8;
> +}

These need better names to not be confused with the reverse helpers.
How about interleave_ways_to_cxl_iw() and
interleave_granularity_to_cxl_ig()?

> +
>  static inline bool cxl_is_interleave_ways_valid(int iw)
>  {
>         switch (iw) {
> diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
> index 5588873dd250..562c8720da56 100644
> --- a/drivers/cxl/region.c
> +++ b/drivers/cxl/region.c
> @@ -29,6 +29,17 @@
>
>  #define region_ways(region) ((region)->config.interleave_ways)
>  #define region_granularity(region) ((region)->config.interleave_granularity)
> +#define region_eniw(region) (cxl_to_eniw(region_ways(region)))
> +#define region_ig(region) (cxl_to_ig(region_granularity(region)))

This feels like too much indirection...

> +
> +#define for_each_cxl_endpoint(ep, region, idx)                                 \
> +       for (idx = 0, ep = (region)->config.targets[idx];                      \
> +            idx < region_ways(region); ep = (region)->config.targets[++idx])

Is the macro really buying anything in terms of readability?

for (i = 0; i < region->interleave_ways; i++)

...looks ok to me.

> +
> +#define for_each_cxl_decoder_target(dport, decoder, idx)                       \
> +       for (idx = 0, dport = (decoder)->target[idx];                          \
> +            idx < (decoder)->nr_targets - 1;                                  \
> +            dport = (decoder)->target[++idx])

Doesn't this need locking to protect against target array updates?
Another detail that might be less obfuscated with an open coded loop.
I would only expect a new for_each() macro when the iterator is a
function call, not a simple array de-reference with an incremented
index.

>
>  static struct cxl_decoder *rootd_from_region(struct cxl_region *cxlr)
>  {
> @@ -195,6 +206,30 @@ static bool qtg_match(const struct cxl_decoder *rootd,
>         return true;
>  }
>
> +static int get_unique_hostbridges(const struct cxl_region *cxlr,
> +                                 struct cxl_port **hbs)
> +{
> +       struct cxl_memdev *ep;
> +       int i, hb_count = 0;
> +
> +       for_each_cxl_endpoint(ep, cxlr, i) {
> +               struct cxl_port *hb = get_hostbridge(ep);
> +               bool found = false;
> +               int j;
> +
> +               BUG_ON(!hb);

Doesn't seem like a reason to crash the kernel.

> +
> +               for (j = 0; j < hb_count; j++) {
> +                       if (hbs[j] == hb)
> +                               found = true;
> +               }
> +               if (!found)
> +                       hbs[hb_count++] = hb;
> +       }
> +
> +       return hb_count;
> +}
> +
>  /**
>   * region_xhb_config_valid() - determine cross host bridge validity
>   * @cxlr: The region being programmed
> @@ -208,7 +243,59 @@ static bool qtg_match(const struct cxl_decoder *rootd,
>  static bool region_xhb_config_valid(const struct cxl_region *cxlr,
>                                     const struct cxl_decoder *rootd)
>  {
> -       /* TODO: */
> +       const int rootd_eniw = cxl_to_eniw(rootd->interleave_ways);
> +       const int rootd_ig = cxl_to_ig(rootd->interleave_granularity);
> +       const int cxlr_ig = region_ig(cxlr);
> +       const int cxlr_iw = region_ways(cxlr);
> +       struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];

I'm worried about the stack usage of this. 0day has not complained
yet, but is it necessary to collect everything into an array versus
having a helper that does the lookup based on an index? It's not like
cxl_region_probe() is a fast path.

> +       struct cxl_dport *target;
> +       int i;
> +
> +       i = get_unique_hostbridges(cxlr, hbs);
> +       if (dev_WARN_ONCE(&cxlr->dev, i == 0, "Cannot find a valid host bridge\n"))

Doesn't seem like a reason to crash the kernel. At least the topology
basics like this can be validated at target assignment time.

> +               return false;
> +
> +       /* Are all devices in this region on the same CXL host bridge */
> +       if (i == 1)
> +               return true;

Doesn't this also need to check that the decoder is not interleaved
across host bridges?

> +
> +       /* CFMWS.HBIG >= Device.Label.IG */
> +       if (rootd_ig < cxlr_ig) {
> +               dev_dbg(&cxlr->dev,
> +                       "%s HBIG must be greater than region IG (%d < %d)\n",
> +                       dev_name(&rootd->dev), rootd_ig, cxlr_ig);
> +               return false;
> +       }
> +
> +       /*
> +        * ((2^(CFMWS.HBIG - Device.RLabel.IG) * (2^CFMWS.ENIW)) > Device.RLabel.NLabel)
> +        *
> +        * XXX: 2^CFMWS.ENIW is trying to decode the NIW. Instead, use the look
> +        * up function which supports non power of 2 interleave configurations.
> +        */
> +       if (((1 << (rootd_ig - cxlr_ig)) * (1 << rootd_eniw)) > cxlr_iw) {

Now here is where some helper macros could make things more readable.
This looks like an acronym soup despite me being familiar with the CXL
spec.

> +               dev_dbg(&cxlr->dev,
> +                       "granularity ratio requires a larger number of devices (%d) than currently configured (%d)\n",
> +                       ((1 << (rootd_ig - cxlr_ig)) * (1 << rootd_eniw)),
> +                       cxlr_iw);
> +               return false;
> +       }
> +
> +       /*
> +        * CFMWS.InterleaveTargetList[n] must contain all devices, x where:
> +        *      (Device[x],RegionLabel.Position >> (CFMWS.HBIG -
> +        *      Device[x].RegionLabel.InterleaveGranularity)) &
> +        *      ((2^CFMWS.ENIW) - 1) = n
> +        */
> +       for_each_cxl_decoder_target(target, rootd, i) {
> +               if (((i >> (rootd_ig - cxlr_ig))) &
> +                   (((1 << rootd_eniw) - 1) != target->port_id)) {
> +                       dev_dbg(&cxlr->dev,
> +                               "One or more devices are not connected to the correct hostbridge.\n");
> +                       return false;
> +               }
> +       }
> +
>         return true;
>  }
>
> --
> 2.35.0
>

