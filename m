Return-Path: <nvdimm+bounces-6213-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C68DE73A1FD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jun 2023 15:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 034631C2115D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jun 2023 13:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D341ED55;
	Thu, 22 Jun 2023 13:38:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9E41D2D1
	for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 13:38:03 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qn1Zp5kQNz67ZCK;
	Thu, 22 Jun 2023 21:35:14 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 22 Jun
 2023 14:37:54 +0100
Date: Thu, 22 Jun 2023 14:37:53 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: David Hildenbrand <david@redhat.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Len Brown <lenb@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, "Dan
 Williams" <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 1/3] mm/memory_hotplug: Allow an override for the
 memmap_on_memory param
Message-ID: <20230622143753.00000282@Huawei.com>
In-Reply-To: <0ea4728a-8601-bf75-1921-bcde0818aac3@redhat.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
	<20230613-vv-kmem_memmap-v1-1-f6de9c6af2c6@intel.com>
	<0ea4728a-8601-bf75-1921-bcde0818aac3@redhat.com>
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
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 16 Jun 2023 09:46:59 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 16.06.23 00:00, Vishal Verma wrote:
> > For memory hotplug to consider MHP_MEMMAP_ON_MEMORY behavior, the
> > 'memmap_on_memory' module parameter was a hard requirement.
> > 
> > In preparation for the dax/kmem driver to use memmap_on_memory
> > semantics, arrange for the module parameter check to be bypassed via the
> > appropriate mhp_flag.
> > 
> > Recall that the kmem driver could contribute huge amounts of hotplugged
> > memory originating from special purposes devices such as CXL memory
> > expanders. In some cases memmap_on_memory may be the /only/ way this new
> > memory can be hotplugged. Hence it makes sense for kmem to have a way to
> > force memmap_on_memory without depending on a module param, if all the
> > other conditions for it are met.  
> 
> Just let the admin configure it. After all, an admin is involved in 
> configuring the dax/kmem device to begin with. If add_memory() fails you 
> could give a useful hint to the admin.
> 

Agreed. If it were just the default then fine, but making it the only option
limits admin choices.

Jonathan

