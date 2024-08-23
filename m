Return-Path: <nvdimm+bounces-8846-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4468095D423
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Aug 2024 19:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BE7FB216ED
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Aug 2024 17:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F5218C929;
	Fri, 23 Aug 2024 17:17:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8EF18BC0F
	for <nvdimm@lists.linux.dev>; Fri, 23 Aug 2024 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724433460; cv=none; b=s4Ff6FVUe8TlKzemlsDB3dNP7lth4e4FGznzAX8Z2BVH19d5WBXC2y7q8k1NkTcZ2+kOBau6dD70R3UNXdsYabYbt5/BMlAww/ugNMDmzNL3Q+qAzYEtcUgzxCKx8AGHxW2WG/p3sMMCl2VtCOpZLy5wfdG/fQPdbdOUCiW0ZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724433460; c=relaxed/simple;
	bh=lCxMlrFWlPzZle8jCcnfTAfxOAP60K7Pgbx49ro+y4A=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Om+jnjKTYsyPNTyHxbckz9AMSY9d85fsbZjM+2uXMKbUBNzlYLdAgtErE/Km0k2p5DYHzAcxmYgXHBgWW5MxH30WZEJ9MEGyFCtP3MReKsMGoCGvty8o7CTxeFDUMVmjfmxsLKFBqrnbjuFc51U0l7VAWnb82vHsvTK2PVT2Evs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wr6BH29yqz6K5cY;
	Sat, 24 Aug 2024 01:14:31 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CE3A140B33;
	Sat, 24 Aug 2024 01:17:36 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 23 Aug
 2024 18:17:35 +0100
Date: Fri, 23 Aug 2024 18:17:34 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, Josef Bacik
	<josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Petr Mladek
	<pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-btrfs@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 19/25] cxl/region/extent: Expose region extent
 information in sysfs
Message-ID: <20240823181734.000022bb@Huawei.com>
In-Reply-To: <66c7faba90d0a_1719d294b@iweiny-mobl.notmuch>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
	<20240816-dcd-type2-upstream-v3-19-7c9b96cba6d7@intel.com>
	<63cfd343-763e-4f7a-a1cc-857927a7282c@intel.com>
	<66c7faba90d0a_1719d294b@iweiny-mobl.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Thu, 22 Aug 2024 21:58:02 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Dave Jiang wrote:
> > 
> > 
> > On 8/16/24 7:44 AM, ira.weiny@intel.com wrote:  
> > > From: Navneet Singh <navneet.singh@intel.com>
> > > 
> > > Extent information can be helpful to the user to coordinate memory usage
> > > with the external orchestrator and FM.
> > > 
> > > Expose the details of region extents by creating the following
> > > sysfs entries.
> > > 
> > >         /sys/bus/cxl/devices/dax_regionX/extentX.Y
> > >         /sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> > >         /sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> > >         /sys/bus/cxl/devices/dax_regionX/extentX.Y/tag
> > > 
> > > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > > Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > ---
> > > Changes:
> > > [iweiny: split this out]
> > > [Jonathan: add documentation for extent sysfs]
> > > [Jonathan/djbw: s/label/tag]
> > > [Jonathan/djbw: treat tag as uuid]
> > > [djbw: use __ATTRIBUTE_GROUPS]
> > > [djbw: make tag invisible if it is empty]
> > > [djbw/iweiny: use conventional id names for extents; extentX.Y]
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-cxl | 13 ++++++++
> > >  drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++++++++++
> > >  2 files changed, 71 insertions(+)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > > index 3a5ee88e551b..e97e6a73c960 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > > @@ -599,3 +599,16 @@ Description:
> > >  		See Documentation/ABI/stable/sysfs-devices-node. access0 provides
> > >  		the number to the closest initiator and access1 provides the
> > >  		number to the closest CPU.
> > > +
> > > +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> > > +		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> > > +		/sys/bus/cxl/devices/dax_regionX/extentX.Y/tag  
> > 
> > I wonder consider an entry for each with their own descriptions, which seems to be the standard practice.  
> 
> :-/  Except kind of for the access'.
> 
> What:           /sys/bus/cxl/devices/regionZ/accessY/read_bandwidth
>                 /sys/bus/cxl/devices/regionZ/accessY/write_banwidth
> 
> What:           /sys/bus/cxl/devices/regionZ/accessY/read_latency
>                 /sys/bus/cxl/devices/regionZ/accessY/write_latency
> 
> But I think you have a point.

It's a balance between complexity and repetition.

E.g. https://elixir.bootlin.com/linux/v6.11-rc4/source/Documentation/ABI/testing/sysfs-bus-iio#L427
is one of these files I know far too well. That would be a lot
of very boring repetition and that doc is long enough without breaking them up.

Here there are only 3 and a good bit of description differs so
probably good to split up.

Less so for bandwidth and latency cases.

Jonathan

> 
> Ira
> 
> > 
> > DJ
> >   
> 
> [snip]
> 


