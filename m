Return-Path: <nvdimm+bounces-727-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id A78F23E0629
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 18:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D733F1C08F3
	for <lists+linux-nvdimm@lfdr.de>; Wed,  4 Aug 2021 16:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7672FB9;
	Wed,  4 Aug 2021 16:52:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAC70
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628095961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VIz+hyBdU5II1jL4Uqm3V2P4MWWphc3HYTf6v4JPaX0=;
	b=MHVTHbfw/GDqbypyyl/b4d4oJgbBP5eTFfSKYwFcm4vMd3zEvYdy/Ztxdc4ANVLaO7bg48
	ncZn59UviMXc5PM5Tn9U8W+An1G17blzECsOPNNw4bYjT9vfxovOwY7/D9y8Gzha0/9ICw
	kpw9z7PuFQEqykhYvIMlimQ2OSTUZo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-4BklKb8PMKKAny-hCWoj8Q-1; Wed, 04 Aug 2021 12:52:38 -0400
X-MC-Unique: 4BklKb8PMKKAny-hCWoj8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 719191007464;
	Wed,  4 Aug 2021 16:52:36 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9158651C63;
	Wed,  4 Aug 2021 16:52:35 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev,  Jacek Zloch <jacek.zloch@intel.com>,  Lukasz Sobieraj <lukasz.sobieraj@intel.com>,  "Lee\, Chun-Yi" <jlee@suse.com>,  stable@vger.kernel.org,  Krzysztof Rusocki <krzysztof.rusocki@intel.com>,  Damian Bassa <damian.bassa@intel.com>,  vishal.l.verma@intel.com
Subject: Re: [PATCH] ACPI: NFIT: Fix support for virtual SPA ranges
References: <162766355874.3223041.9582643895337437921.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 04 Aug 2021 12:54:00 -0400
In-Reply-To: <162766355874.3223041.9582643895337437921.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Fri, 30 Jul 2021 09:45:58 -0700")
Message-ID: <x49pmuttal3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

Dan Williams <dan.j.williams@intel.com> writes:

> Fix the NFIT parsing code to treat a 0 index in a SPA Range Structure as
> a special case and not match Region Mapping Structures that use 0 to
> indicate that they are not mapped. Without this fix some platform BIOS
> descriptions of "virtual disk" ranges do not result in the pmem driver
> attaching to the range.
>
> Details:
> In addition to typical persistent memory ranges, the ACPI NFIT may also
> convey "virtual" ranges. These ranges are indicated by a UUID in the SPA
> Range Structure of UUID_VOLATILE_VIRTUAL_DISK, UUID_VOLATILE_VIRTUAL_CD,
> UUID_PERSISTENT_VIRTUAL_DISK, or UUID_PERSISTENT_VIRTUAL_CD. The
> critical difference between virtual ranges and UUID_PERSISTENT_MEMORY, is
> that virtual do not support associations with Region Mapping Structures.
> For this reason the "index" value of virtual SPA Range Structures is
> allowed to be 0. If a platform BIOS decides to represent unmapped
                                                           ^^^^^^^^
> NVDIMMs with a 0 index in their "SPA Range Structure Index" the driver
  ^^^^^^^

That language confused me.  I thought you were talking about a separate
issue, whereby NVDIMMs which are not mapped (probably due to some errors
with the dimms themselves) would get an index of 0.  But upon
re-reading, I think you just meant that the virtual media is not mapped
via a region mapping structure.

> falsely matches them and may falsely require labels where "virtual
> disks" are expected to be label-less. I.e. label-less is where the
> namespace-range == region-range and the pmem driver attaches with no
> user action to create a namespace.


> Cc: Jacek Zloch <jacek.zloch@intel.com>
> Cc: Lukasz Sobieraj <lukasz.sobieraj@intel.com>
> Cc: "Lee, Chun-Yi" <jlee@suse.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c2f32acdf848 ("acpi, nfit: treat virtual ramdisk SPA as pmem region")
> Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
> Reported-by: Damian Bassa <damian.bassa@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 23d9a09d7060..6f15e56ef955 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3021,6 +3021,8 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
>  		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
>  		struct nd_mapping_desc *mapping;
>  
> +		if (memdev->range_index == 0 || spa->range_index == 0)
> +			continue;
>  		if (memdev->range_index != spa->range_index)
>  			continue;
>  		if (count >= ND_MAX_MAPPINGS) {

The change looks good, but can you add a comment to the code?  With
that, you can add my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!
Jeff


