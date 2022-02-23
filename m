Return-Path: <nvdimm+bounces-3116-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F404C1E80
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Feb 2022 23:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 17F591C0A46
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Feb 2022 22:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D6D6ADD;
	Wed, 23 Feb 2022 22:31:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77B57A;
	Wed, 23 Feb 2022 22:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645655480; x=1677191480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xgACDg0e5bK7JLWwcUSJH2hZ92CVCmS7RJeUQ1jH29E=;
  b=J/mo5KDOBJ1k9mQfPql0ZZgYgFvK1R/fU9LI58iGdJtPs5qToCb7vdqN
   gwSN4r9rP057kDWMciw0WZQrt+37rN/FBAnK9DRyIWQPWWpNvEUsmpmzz
   Eu4jxsAA4kZTxIgkQht1KG30CWRPjLYNzbFGx1v0mC6Ei8wlrhDj05Tna
   Osx2BvyXXYp60wb4/Rx8dLh9Bme7JOQ1LnDW4toe5JWif9hQRL06i84V7
   c7EYPq/FpJ8kANqKcDJKa7izkJKm7htAIaTdS5DhqHwKGajG6WiIfoaop
   Rda3SwINuno/Ym2zfo4TNIzvGfC8J/LQtkVO68G9bD2FiLf3+mNP+9toE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="232717267"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="232717267"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:31:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="491374807"
Received: from srikrish-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.138.225])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:31:19 -0800
Date: Wed, 23 Feb 2022 14:31:18 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 02/14] cxl/region: Introduce concept of region
 configuration
Message-ID: <20220223223118.6syneumumjkmdtcy@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-3-ben.widawsky@intel.com>
 <CAPcyv4hHJcPLRJM-7z+wKhjBhp9HH2qXuEeC0VfDnD6yU9H-Wg@mail.gmail.com>
 <20220217183628.6iwph6w3ndoct3o3@intel.com>
 <CAPcyv4gTgwmeX_WpsPdZ1K253XmwXwWU4629PKB__n4MF6CeFQ@mail.gmail.com>
 <20220223214955.riljjquteodtdyaj@intel.com>
 <CAPcyv4iqd-_37kfL0_UMq+17tt==P1Nq1yWFZkcJQ42A+03O7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4iqd-_37kfL0_UMq+17tt==P1Nq1yWFZkcJQ42A+03O7w@mail.gmail.com>

On 22-02-23 14:24:00, Dan Williams wrote:
> On Wed, Feb 23, 2022 at 1:50 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > On 22-02-17 11:57:59, Dan Williams wrote:
> > > On Thu, Feb 17, 2022 at 10:36 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > >
> > > > Consolidating earlier discussions...
> > > >
> > > > On 22-01-28 16:25:34, Dan Williams wrote:
> > > > > On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > > > >
> > > > > > The region creation APIs create a vacant region. Configuring the region
> > > > > > works in the same way as similar subsystems such as devdax. Sysfs attrs
> > > > > > will be provided to allow userspace to configure the region.  Finally
> > > > > > once all configuration is complete, userspace may activate the region.
> > > > > >
> > > > > > Introduced here are the most basic attributes needed to configure a
> > > > > > region. Details of these attribute are described in the ABI
> > > > >
> > > > > s/attribute/attributes/
> > > > >
> > > > > > Documentation. Sanity checking of configuration parameters are done at
> > > > > > region binding time. This consolidates all such logic in one place,
> > > > > > rather than being strewn across multiple places.
> > > > >
> > > > > I think that's too late for some of the validation. The complex
> > > > > validation that the region driver does throughout the topology is
> > > > > different from the basic input validation that can  be done at the
> > > > > sysfs write time. For example ,this patch allows negative
> > > > > interleave_granularity values to specified, just return -EINVAL. I
> > > > > agree that sysfs should not validate everything, I disagree with
> > > > > pushing all validation to cxl_region_probe().
> > > > >
> > > >
> > > > Okay. It might save us some back and forth if you could outline everything you'd
> > > > expect to be validated, but I can also make an attempt to figure out the
> > > > reasonable set of things.
> > >
> > > Input validation. Every value that gets written to a sysfs attribute
> > > should be checked for validity, more below:
> > >
> > > >
> > > > > >
> > > > > > A example is provided below:
> > > > > >
> > > > > > /sys/bus/cxl/devices/region0.0:0
> > > > > > ├── interleave_granularity
> > >
> > > ...validate granularity is within spec and can be supported by the root decoder.
> > >
> > > > > > ├── interleave_ways
> > >
> > > ...validate ways is within spec and can be supported by the root decoder.
> >
> > I'm not sure how to do this one. Validation requires device positions and we
> > can't set the targets until ways is set. Can you please provide some more
> > insight on what you'd like me to check in addition to the value being within
> > spec?
> 
> For example you could check that interleave_ways is >= to the root
> level interleave. I.e. it would be invalid to attempt a x1 interleave
> on a decoder that is x2 interleaved at the host-bridge level.

I tried to convince myself that that assertion always holds and didn't feel
super comfortable. If you do, I can add those kinds of checks.

Thanks.
Ben

