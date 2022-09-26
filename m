Return-Path: <nvdimm+bounces-4895-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5E15EB1E6
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Sep 2022 22:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 358701C20966
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Sep 2022 20:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2A046B5;
	Mon, 26 Sep 2022 20:14:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD506468D
	for <nvdimm@lists.linux.dev>; Mon, 26 Sep 2022 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664223274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Jl9DGKzngRhLYPjhuYBdFnF7GWXVO26pEtDYy5KZlU=;
	b=R7U4CEsxOdIXaRgJ9UXwppCTOzNZXikHyrRvaZnMQZrEaAqtLepGtfmoK4O9LzRG+JToVQ
	WynuiYbTx2EcYMtZH2O9OsfNn9pJkjITAmuQDqiL5iWkz3krbcM5zGmWLZfhTeLhJxWpWC
	s7uCIhc0cKfVGkHgauZIG8/3hzMKPnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-6THcGo_mM8WYdeSO3qKTAA-1; Mon, 26 Sep 2022 16:14:29 -0400
X-MC-Unique: 6THcGo_mM8WYdeSO3qKTAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65E67811E67;
	Mon, 26 Sep 2022 20:14:28 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EA6D2166B26;
	Mon, 26 Sep 2022 20:14:28 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>,  Vishal Verma <vishal.l.verma@intel.com>,  Dave Jiang <dave.jiang@intel.com>,  Ira Weiny <ira.weiny@intel.com>,  "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,  Pavel Tatashin <pasha.tatashin@soleen.com>,  "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,  nvdimm@lists.linux.dev,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] libnvdimm/region: Allow setting align attribute on regions without mappings
References: <20220830054505.1159488-1-tyhicks@linux.microsoft.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 26 Sep 2022 16:18:18 -0400
In-Reply-To: <20220830054505.1159488-1-tyhicks@linux.microsoft.com> (Tyler
	Hicks's message of "Tue, 30 Aug 2022 00:45:05 -0500")
Message-ID: <x49tu4tlwj9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

Tyler Hicks <tyhicks@linux.microsoft.com> writes:

> The alignment constraint for namespace creation in a region was
> increased, from 2M to 16M, for non-PowerPC architectures in v5.7 with
> commit 2522afb86a8c ("libnvdimm/region: Introduce an 'align'
> attribute"). The thought behind the change was that region alignment
> should be uniform across all architectures and, since PowerPC had the
> largest alignment constraint of 16M, all architectures should conform to
> that alignment.
>
> The change regressed namespace creation in pre-defined regions that
> relied on 2M alignment but a workaround was provided in the form of a
> sysfs attribute, named 'align', that could be adjusted to a non-default
> alignment value.
>
> However, the sysfs attribute's store function returned an error (-ENXIO)
> when userspace attempted to change the alignment of a region that had no
> mappings. This affected 2M aligned regions of volatile memory that were
> defined in a device tree using "pmem-region" and created by the
> of_pmem_region_driver, since those regions do not contain mappings
> (ndr_mappings is 0).
>
> Allow userspace to set the align attribute on pre-existing regions that
> do not have mappings so that namespaces can still be within those
> regions, despite not being aligned to 16M.
>
> Link: https://lore.kernel.org/lkml/CA+CK2bDJ3hrWoE91L2wpAk+Yu0_=GtYw=4gLDDD7mxs321b_aA@mail.gmail.com
> Fixes: 2522afb86a8c ("libnvdimm/region: Introduce an 'align' attribute")
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
>
> While testing with a recent kernel release (6.0-rc3), I rediscovered
> this bug and eventually realized that I never followed through with
> fixing it upstream. After a year later, here's the v2 that Aneesh
> requested. Sorry about that!
>
> v2:
> - Included Aneesh's feedback to ensure the val is a power of 2 and
>   greater than PAGE_SIZE even for regions without mappings
> - Reused the max_t() trick from default_align() to avoid special
>   casing, with an if-else, when regions have mappings and when they
>   don't
>   + Didn't include Pavel's Reviewed-by since this is a slightly
>     different approach than what he reviewed in v1
> - Added a Link commit tag to Pavel's initial problem description
> v1: https://lore.kernel.org/lkml/20210326152645.85225-1-tyhicks@linux.microsoft.com/
>
>  drivers/nvdimm/region_devs.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 473a71bbd9c9..550ea0bd6c53 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -509,16 +509,13 @@ static ssize_t align_store(struct device *dev,
>  {
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	unsigned long val, dpa;
> -	u32 remainder;
> +	u32 mappings, remainder;
>  	int rc;
>  
>  	rc = kstrtoul(buf, 0, &val);
>  	if (rc)
>  		return rc;
>  
> -	if (!nd_region->ndr_mappings)
> -		return -ENXIO;
> -
>  	/*
>  	 * Ensure space-align is evenly divisible by the region
>  	 * interleave-width because the kernel typically has no facility
> @@ -526,7 +523,8 @@ static ssize_t align_store(struct device *dev,
>  	 * contribute to the tail capacity in system-physical-address
>  	 * space for the namespace.
>  	 */
> -	dpa = div_u64_rem(val, nd_region->ndr_mappings, &remainder);
> +	mappings = max_t(u32, 1, nd_region->ndr_mappings);
> +	dpa = div_u64_rem(val, mappings, &remainder);
>  	if (!is_power_of_2(dpa) || dpa < PAGE_SIZE
>  			|| val > region_size(nd_region) || remainder)
>  		return -EINVAL;

The math all looks okay, and this matches what's done in default_align.
Unfortunately, I don't know enough about the power architecture to
understand how you can have a region with no dimms (ndr_mappings == 0).

-Jeff


