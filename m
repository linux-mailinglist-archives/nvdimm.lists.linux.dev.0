Return-Path: <nvdimm+bounces-2826-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4204A7835
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 19:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 14D681C0E36
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 18:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29A72F3F;
	Wed,  2 Feb 2022 18:48:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190BB2F23;
	Wed,  2 Feb 2022 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643827696; x=1675363696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lt4aeih5HUzhuMRVZTjJnXmGDNR4EvgwNemvdrmLpkc=;
  b=AF17S2LshucLGBm/0e+9nSVcjTmkXNfQvzB8IzBYzY9tTPDIzGJfOy2K
   tr0eXKErbYjVyfbZGdUuqzlNvJDsSSvxg9+vl8JNo4D35tbt4iPKVaiiE
   rXMSzH2kuzcRtIbtFJyBWdYrLEywKPUgSV7KnlpG8B83Ahhqzl9PlX31+
   moETbtP6LTWvXVnNUTWojNmwUz80cjyjiwh1YMiuA9KOUBNonDX9g8GWE
   zr/Ajir1ewWoj2PiFFGguZjqD/QuOXcHSNX//FszSD8cvyWVr+Gf3VWal
   wDu2baJZLJFliJBYGsoIRiiQ3TTojZ/5aO4sLMzqc93ejxpXToMtDtUbm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="246828963"
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="246828963"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 10:48:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="769375114"
Received: from svenur-mobl2.amr.corp.intel.com (HELO intel.com) ([10.252.133.34])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 10:48:14 -0800
Date: Wed, 2 Feb 2022 10:48:13 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 01/14] cxl/region: Add region creation ABI
Message-ID: <20220202184813.euepn3m2twpybpoc@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-2-ben.widawsky@intel.com>
 <CAPcyv4h53gj9vETFcj_RebW+Zt=q+1yOmMo9CpyzHdABanpPRg@mail.gmail.com>
 <CAPcyv4hj=1=+8UvqzSZqJ12ef1F15Hpzud7YjJpz7dZa0=9=QQ@mail.gmail.com>
 <20220202182604.oangkxomx3npmobl@intel.com>
 <20220202182811.ivupsaeogyiwl5so@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202182811.ivupsaeogyiwl5so@intel.com>

On 22-02-02 10:28:11, Ben Widawsky wrote:
> On 22-02-02 10:26:06, Ben Widawsky wrote:
> > On 22-01-28 10:59:26, Dan Williams wrote:
> > > On Fri, Jan 28, 2022 at 10:14 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > > [..]
> > > > Here is that put_device() I was expecting, that kfree() earlier was a
> > > > double-free it seems.
> > > >
> > > > Also, I would have expected a devm action to remove this. Something like:
> > > >
> > > > struct cxl_port *port = to_cxl_port(cxld->dev.parent);
> > > >
> > > > cxl_device_lock(&port->dev);
> > > > if (port->dev.driver)
> > > >     devm_cxl_add_region(port->uport, cxld, id);
> > 
> > I assume you mean devm_cxl_delete_region(), yes?
> > 
> > > > else
> > > >     rc = -ENXIO;
> > > > cxl_device_unlock(&port->dev);
> > > >
> > > > ...then no matter what you know the region will be unregistered when
> > > > the root port goes away.
> > > 
> > > ...actually, the lock and ->dev.driver check here are not needed
> > > because this attribute is only registered while the cxl_acpi driver is
> > > bound. So, it is safe to assume this is protected as decoder remove
> > > synchronizes against active sysfs users.
> > 
> > I'm somewhat confused when you say devm action to remove this. The current auto
> > region deletion happens when the ->release() is called. Are you suggesting when
> > the root decoder is removed I delete the regions at that point?
> 
> Hmm. I went back and looked and I had changed this functionality at some
> point... So forget I said that, it isn't how it's working currently. But the
> question remains, are you suggesting I delete in the root decoder
> unregistration?

I think it's easier if I write what I think you mean.... Here are the relevant
parts:

devm_cxl_region_delete() is removed entirely.

static void unregister_region(void *_cxlr)
{
        struct cxl_region *cxlr = _cxlr;

        device_unregister(&cxlr->dev);
}


static int devm_cxl_region_add(struct cxl_decoder *cxld, struct cxl_region *cxlr)
{
        struct cxl_port *port = to_cxl_port(cxld->dev.parent);
        struct device *dev = &cxlr->dev;
        int rc;

        rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
        if (rc)
                return rc;

        rc = device_add(dev);
        if (rc)
                return rc;

        return devm_add_action_or_reset(&cxld->dev, unregister_region, cxlr);
}

static ssize_t delete_region_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t len)
{
        struct cxl_decoder *cxld = to_cxl_decoder(dev);
        struct cxl_region *cxlr;

        cxlr = cxl_find_region_by_name(cxld, buf);
        if (IS_ERR(cxlr))
                return PTR_ERR(cxlr);

        devm_release_action(dev, unregister_region, cxlr);

        return len;
}
DEVICE_ATTR_WO(delete_region);

