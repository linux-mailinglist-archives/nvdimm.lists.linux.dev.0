Return-Path: <nvdimm+bounces-2831-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74AD74A7894
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 20:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A66A21C0B9E
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 19:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E0F2F40;
	Wed,  2 Feb 2022 19:16:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739162F23
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 19:16:04 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id a19so137987pfx.4
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 11:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=naI6MmLyx3L0vKPsxq7pKDZKfopnOyY98ZoZTC2aPak=;
        b=P2y/LrvSPC0RFt1lRjlYZTjc/r3DnLBYn7NFszSEH27xSI1HyFHLuBOwLJ5mvST9JB
         YjK2RCmEWtsTG4yOowy+y20BdlFihwkijB+PnDpBiYCHAiphSsu7XHFQeOCv6Pi7OdrH
         PTa8Q5RIyDQItqRmpSSEsnEH0YM6E+8QWUUm6punMq72cRR2GUjdOw1G0E96gR077oV/
         wZioAKAfdia6hMUa3ACPUSAGx4gLrSfwShd98L9gO+4MIJvrJpvx/1gI9LUMfplquRfC
         M6365rUPVGGVBgzJRgbqzQ4y3ZezP1aCyely/NPE0aHRnvm4ahGGoexd6d2pWDdmFJrL
         /6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=naI6MmLyx3L0vKPsxq7pKDZKfopnOyY98ZoZTC2aPak=;
        b=7jOs0avSBXz7hDO3j0MsHcIGIDc+cr8eqDA1el1cz2FD+c61w6Y+fCYz2M4ijG1dlU
         u0JtyqzM213XSeYAP8n7QAZ/XAGnXpEshfhgzmGNwD5DDVzhfTWkIG7KaNp8zRT9vtiV
         gKoTrojPgXCr6RRadVVCPC5iK71l0oO2SIR8t8R+YYsDgrUTJoWg3dQTQFa33etu8o9l
         CPkGd9X1onMtr2L1BKZVofHFL72XraaC5HydNNkgHW1aN0T1T9EayC4DTqlLwVwLIAlG
         VQC3qNLVD48SKXryXTs3t2F1RG3Y9WpnyQkg21g84qfUNu6dHcZsM/jhGmR0qHo19dw7
         VIkA==
X-Gm-Message-State: AOAM531N/tp64E/I+PQGnXAjTtxkYx+wVq2hjYYnNl4hRpEAo3bRpPil
	bjUxQyun3qSI557nK+3y17npg//DS2S+hkmkagjLIg==
X-Google-Smtp-Source: ABdhPJwvSgu10WkeHrWi7zMyV6EcyEw4DOAWQyoc1XWGluJ/l5BEod2F/nSEp/bba2iXAmejpNJBVPk23tkJJ+L+ohU=
X-Received: by 2002:a05:6a00:1312:: with SMTP id j18mr30454828pfu.61.1643829363837;
 Wed, 02 Feb 2022 11:16:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-2-ben.widawsky@intel.com> <CAPcyv4h53gj9vETFcj_RebW+Zt=q+1yOmMo9CpyzHdABanpPRg@mail.gmail.com>
 <CAPcyv4hj=1=+8UvqzSZqJ12ef1F15Hpzud7YjJpz7dZa0=9=QQ@mail.gmail.com>
 <20220202182604.oangkxomx3npmobl@intel.com> <20220202182811.ivupsaeogyiwl5so@intel.com>
 <20220202184813.euepn3m2twpybpoc@intel.com> <CAPcyv4hTRVuO=gVDe1ePTOaC3HiKKD7a00Zxz1uBLakfYFEtsw@mail.gmail.com>
 <20220202190254.gg3t5xhpdcnfpkp2@intel.com>
In-Reply-To: <20220202190254.gg3t5xhpdcnfpkp2@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 2 Feb 2022 11:15:51 -0800
Message-ID: <CAPcyv4gQwH7_YWMC0wbztNsv4JLoyk+R-72U5=95ZyHQWMf=Fw@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 2, 2022 at 11:03 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-02-02 11:00:04, Dan Williams wrote:
> > On Wed, Feb 2, 2022 at 10:48 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > On 22-02-02 10:28:11, Ben Widawsky wrote:
> > > > On 22-02-02 10:26:06, Ben Widawsky wrote:
> > > > > On 22-01-28 10:59:26, Dan Williams wrote:
> > > > > > On Fri, Jan 28, 2022 at 10:14 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > > [..]
> > > > > > > Here is that put_device() I was expecting, that kfree() earlier was a
> > > > > > > double-free it seems.
> > > > > > >
> > > > > > > Also, I would have expected a devm action to remove this. Something like:
> > > > > > >
> > > > > > > struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > > > > > >
> > > > > > > cxl_device_lock(&port->dev);
> > > > > > > if (port->dev.driver)
> > > > > > >     devm_cxl_add_region(port->uport, cxld, id);
> > > > >
> > > > > I assume you mean devm_cxl_delete_region(), yes?
> > > > >
> > > > > > > else
> > > > > > >     rc = -ENXIO;
> > > > > > > cxl_device_unlock(&port->dev);
> > > > > > >
> > > > > > > ...then no matter what you know the region will be unregistered when
> > > > > > > the root port goes away.
> > > > > >
> > > > > > ...actually, the lock and ->dev.driver check here are not needed
> > > > > > because this attribute is only registered while the cxl_acpi driver is
> > > > > > bound. So, it is safe to assume this is protected as decoder remove
> > > > > > synchronizes against active sysfs users.
> > > > >
> > > > > I'm somewhat confused when you say devm action to remove this. The current auto
> > > > > region deletion happens when the ->release() is called. Are you suggesting when
> > > > > the root decoder is removed I delete the regions at that point?
> > > >
> > > > Hmm. I went back and looked and I had changed this functionality at some
> > > > point... So forget I said that, it isn't how it's working currently. But the
> > > > question remains, are you suggesting I delete in the root decoder
> > > > unregistration?
> > >
> > > I think it's easier if I write what I think you mean.... Here are the relevant
> > > parts:
> > >
> > > devm_cxl_region_delete() is removed entirely.
> > >
> > > static void unregister_region(void *_cxlr)
> > > {
> > >         struct cxl_region *cxlr = _cxlr;
> > >
> > >         device_unregister(&cxlr->dev);
> > > }
> > >
> > >
> > > static int devm_cxl_region_add(struct cxl_decoder *cxld, struct cxl_region *cxlr)
> > > {
> > >         struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > >         struct device *dev = &cxlr->dev;
> > >         int rc;
> > >
> > >         rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
> > >         if (rc)
> > >                 return rc;
> > >
> > >         rc = device_add(dev);
> > >         if (rc)
> > >                 return rc;
> > >
> > >         return devm_add_action_or_reset(&cxld->dev, unregister_region, cxlr);
> >
> > Decoders can't host devm actions. The host for this action would need
> > to be the parent port.
>
> Happy to change it since I can't imagine a decoder would go down without the
> port also going down. Can you please explain why a decoder can't host a devm
> action though. I'd like to understand that better.

So, devm releases resources at 2 times one of which is "too late". The
natural / expected point at which they are released is by the driver
core at $driver->remove($dev) time. There is also a backstop release
point at $dev->${type,class,bus}->release() time. The latter one is
"too late" because it effectively leave the device registered
indefinitely which is broken because the parent sysfs directory
hierarchy for that device will have already been removed, so the late
release may crash depending on when the last put_device($dev) is
performed. The decoder never experiences a ->remove() event, but it's
parent port does (at least for non-root ports). For this case it will
likely need to reach further up and use the same devm host as the
decoder itself which is the ACPI0017 device.

>
> >
> > > }
> > >
> > > static ssize_t delete_region_store(struct device *dev,
> > >                                    struct device_attribute *attr,
> > >                                    const char *buf, size_t len)
> > > {
> > >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > >         struct cxl_region *cxlr;
> > >
> > >         cxlr = cxl_find_region_by_name(cxld, buf);
> > >         if (IS_ERR(cxlr))
> > >                 return PTR_ERR(cxlr);
> > >
> > >         devm_release_action(dev, unregister_region, cxlr);
> >
> > Yes, modulo the same comment as before that the decoder object is not
> > a suitable devm host. This also needs a solution for the race between
> > these 2 actions:
> >
> > echo "ACPI0017:00" > /sys/bus/platform/drivers/cxl_acpi/unbind
> > echo $region > /sys/bus/cxl/devices/$decoder/delete_region
>
> Is there a better solution than taking the root port lock?

Depends what lockdep says. The first choice lock to synchronize those
2 actions would be the ACPI0017 device_lock, but lockdep might point
out a problem with that vs sysfs teardown synchronization.

