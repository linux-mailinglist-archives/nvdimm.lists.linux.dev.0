Return-Path: <nvdimm+bounces-4355-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D619857A20A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Jul 2022 16:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB71B1C20985
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Jul 2022 14:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FD433F6;
	Tue, 19 Jul 2022 14:42:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E5C139A;
	Tue, 19 Jul 2022 14:42:54 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LnM0w0x3sz67NZj;
	Tue, 19 Jul 2022 22:39:28 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 16:42:51 +0200
Received: from localhost (10.81.209.49) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 19 Jul
 2022 15:42:50 +0100
Date: Tue, 19 Jul 2022 15:42:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Ben
 Widawsky" <bwidawsk@kernel.org>
Subject: Re: [PATCH 34/46] cxl/region: Add region creation support
Message-ID: <20220719154248.00006478@Huawei.com>
In-Reply-To: <62cb69f47767b_353516294c9@dwillia2-xfh.notmuch>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-9-dan.j.williams@intel.com>
	<20220630141721.00005dce@Huawei.com>
	<62cb69f47767b_353516294c9@dwillia2-xfh.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.209.49]
X-ClientProxiedBy: lhreml749-chm.china.huawei.com (10.201.108.199) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected


> > > An example of creating a new region:
> > > 
> > > - Allocate a new region name:
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
> > > 
> > > - Create a new region by name:
> > > while
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)  
> > 
> > Perhaps it is worth calling out the region ID allocator is shared
> > with nvdimms and other usecases.  I'm not really sure what the advantage
> > in doing that is, but it doesn't do any real harm.  
> 
> The rationale is that there are several producers of memory regions
> nvdimm, device-dax (hmem), and now cxl. Of those cases cxl can pass
> regoins to nvdimm and nvdimm can pass regions to device-dax (pmem). If
> each of those cases allocated their own region-id it would just
> complicate debug for no benefit. I can add this a note to remind why
> memregion_alloc() was introduced in the first instance.
> 
> >   
> > > ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
> > > do true; done  
> 
> I recall you also asked to clarify the rationale of this complexity. It
> is related to the potential proliferation of disaparate region ids, but
> also a lesson learned from nvdimm which itself learned lessons from
> md-raid. The lesson from md-raid in short is do not use ioctl for object
> creation. After "not ioctl" the choice is configfs or a small bit of
> sysfs hackery. Configfs is overkill when there is already a sysfs
> hierarchy that just needs one new object injected.
> 
> Namespace creation in nvdimm pre-created "seed" devices which let the
> kernel control the naming, but confused end users that wondered about
> vestigial devices. This "read to learn next object name" + "write to
> atomically claim and instantiate that id" cleans up that vestigial
> device problem while also constraining object naming to follow memregion
> id expectations.
Ok.  Makes sense to me now. Thanks!


> > > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > > index 472ec9cb1018..ebe6197fb9b8 100644
> > > --- a/drivers/cxl/core/core.h
> > > +++ b/drivers/cxl/core/core.h
> > > @@ -9,6 +9,18 @@ extern const struct device_type cxl_nvdimm_type;
> > >  
> > >  extern struct attribute_group cxl_base_attribute_group;
> > >  
> > > +#ifdef CONFIG_CXL_REGION
> > > +extern struct device_attribute dev_attr_create_pmem_region;
> > > +extern struct device_attribute dev_attr_delete_region;
> > > +/*
> > > + * Note must be used at the end of an attribute list, since it
> > > + * terminates the list in the CONFIG_CXL_REGION=n case.  
> > 
> > That's rather ugly.  Maybe just push the ifdef down into the c file
> > where we will be shortening the list and it should be obvious what is
> > going on without needing the comment?  Much as I don't like ifdef
> > magic in the c files, it sometimes ends up cleaner.  
> 
> No, I think ifdef in C is definitely uglier, but I also notice that
> helpers like SET_SYSTEM_SLEEP_PM_OPS() are defined to be used in any
> place in the list. So, I'll just duplicate that approach.

Ah. That's better, though has that odd quirk of no trailing comma where
the macro is called which always makes me look twice!

Guess looking twice is better than not looking at all though :)

Thanks,

Jonathan

