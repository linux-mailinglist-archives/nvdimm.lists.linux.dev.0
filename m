Return-Path: <nvdimm+bounces-2845-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD574A819A
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 10:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id EF4B31C0CC2
	for <lists+linux-nvdimm@lfdr.de>; Thu,  3 Feb 2022 09:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA592CA1;
	Thu,  3 Feb 2022 09:41:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5C2F26
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 09:41:39 +0000 (UTC)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JqDF41lBMz67Sfy;
	Thu,  3 Feb 2022 17:40:56 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 10:41:30 +0100
Received: from localhost (10.47.78.15) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 3 Feb
 2022 09:41:30 +0000
Date: Thu, 3 Feb 2022 09:41:23 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>, "Linux
 NVDIMM" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
Message-ID: <20220203094123.000049e6@Huawei.com>
In-Reply-To: <CAPcyv4hwdMetDJ-+yL9-2rY92g2C4wWPqpRiQULaX_M6ZQPMtA@mail.gmail.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20220131184126.00002a47@Huawei.com>
	<CAPcyv4iYpj7MH4kKMP57ouHb85GffEmhXPupq5i1mwJwzFXr0w@mail.gmail.com>
	<20220202094437.00003c03@Huawei.com>
	<CAPcyv4hwdMetDJ-+yL9-2rY92g2C4wWPqpRiQULaX_M6ZQPMtA@mail.gmail.com>
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
X-Originating-IP: [10.47.78.15]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 2 Feb 2022 07:44:37 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, Feb 2, 2022 at 1:45 AM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > On Tue, 1 Feb 2022 15:57:10 -0800
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >  
> > > On Mon, Jan 31, 2022 at 10:41 AM Jonathan Cameron
> > > <Jonathan.Cameron@huawei.com> wrote:  
> > > >
> > > > On Sun, 23 Jan 2022 16:31:24 -0800
> > > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > >  
> > > > > While CXL memory targets will have their own memory target node,
> > > > > individual memory devices may be affinitized like other PCI devices.
> > > > > Emit that attribute for memdevs.
> > > > >
> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> > > >
> > > > Hmm. Is this just duplicating what we can get from
> > > > the PCI device?  It feels a bit like overkill to have it here
> > > > as well.  
> > >
> > > Not all cxl_memdevs are associated with PCI devices.  
> >
> > Platform devices have numa nodes too...  
> 
> So what's the harm in having a numa_node attribute local to the memdev?
> 

I'm not really against, it just wanted to raise the question of
whether we want these to go further than the granularity at which
numa nodes can be assigned.  Right now that at platform_device or
PCI EP (from ACPI anyway).  Sure the value might come from higher
up a hierarchy but at least in theory it can be assigned to
individual devices.

This is pushing that description beyond that point so is worth discussing.

> Yes, userspace could carry complications like:
> 
> cat $(readlink -f /sys/bus/cxl/devices/mem0)/../numa_node
> 
> ...but if you take that argument to its extreme, most "numa_node"
> attributes in sysfs could be eliminated because userspace can keep
> walking up the hierarchy to find the numa_node versus the kernel doing
> it on behalf of userspace.

