Return-Path: <nvdimm+bounces-7572-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D71867B29
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 17:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CE9D1F22181
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 16:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C896212C547;
	Mon, 26 Feb 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+XfVHwq"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DBE12C532
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708963749; cv=none; b=j+vvVRC2b7aNbY70196QAMrrvATvHLTrDxqI+B3gF0w28akfr+tPshDtRGuS4fKVIEBZUPUbDeaPeUPlkX5W+7IaXvIBBq1W7VRup1dkIzmN8cnqBnF9JTuOA2mWsqga9jw3Na+gZFkbjcGGG8k9DYV22DSIxO5c6+vsD3oIdEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708963749; c=relaxed/simple;
	bh=haOLgV/8XDe1wiDHpv8/QB2A+c/GZzdT/aVNiO2q4Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJ2Py9gCg3uXCew5Hcx8CBoHS4HpBtPN+lo2v5YXnfOsWeSLnhXBuHWF/Kk055S5I49FQ3kU6Ny+PVpJFWuL9E0473vyN5vgfhHe+QVCZQw5OBOpD3TTOWwYnUsqkCETZ5oUvM/OJ7iGZ6s6J69TOToBbdMQ8gU6VYBvwuXvaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+XfVHwq; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-595b3644acbso1348163eaf.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 08:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708963746; x=1709568546; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u9D3RCtWOdzu87BYCJb9nwXu0HmW2w9gBV06s00d0kw=;
        b=Y+XfVHwqlxqSype9XP5z+9DUiLBxt04lV7BJQrnHPpgKwO1lSO28Hdy1CiG6pHytW7
         fIq/DHrCElrC9FMHFeRJQvcdy5LnxAqC11kIfnMjk1AOOrRVm+ESxko4hr3mrQqMHMUq
         JnE71DkzAf6MwdFEWofPg6RZY4fr46Q9NJWybujrSq4hbAPfvsMKS6NYIPwT6UexG21I
         zQZ8KgTm7pGbXXjCY12tige0nPIXcVaJUnwdcl3pL1OEAiv7w9TRfcr3ehnYcuNg1LQg
         dolJyXYoDMCnajmzk7Y4m+swGl5apkMUd7boBi/W4AQXNVtTyJiIc0Odsu5tAEgrR9D3
         E/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708963746; x=1709568546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u9D3RCtWOdzu87BYCJb9nwXu0HmW2w9gBV06s00d0kw=;
        b=B7DfIZ3JW4B6+2zZWPJkjqHa6ntxteU9rjMwcSZkW+0EBC/qfg4JfdVbSoOR652DvY
         YtWYH8mhpihLCMU8h+pw6M6oe/03Wn+t7QT1oGKoYLAp1QgqObQpRj/o+b4yQYGsRJnj
         BDH+doT3tMtdxZDZVPm7kGVGuK2BSbC0wmT9aKvs9Uj09+NUfcEeVAb4IKIciQzwMctx
         jicNavZ55qy9ZEp5CQUuE+g4gqmgkau2DwWBVpwvp7C4UctTgxSpwREtUKe0unthbHDv
         YoUpSWHe8F9rfTkUUncOPsm2IW0KN+zFYxZQFUVw5bRFpquoPqGpWesZlKlLfbPn7EsJ
         4z0w==
X-Forwarded-Encrypted: i=1; AJvYcCUcJ3x0/f9z3jpUwcFlK+VURQwFHDI7uVh5GkF1z0Se5r5jfx565+ozsnTPE1PP4KRf1l3a94j2YDfNZTI4a416e+GvGAxZ
X-Gm-Message-State: AOJu0Yy0vQyhIyvVMWItSxSFTUPGjuQ5fP1zOoLS0fN45FDqowJIWcBe
	91dpigcG+qdbx4rCGjTjVJ/GAWS8/UUVV1FT7B4OCz0m1pEG2fb3
X-Google-Smtp-Source: AGHT+IGzZAR5zUijDa1rMNpaNuIzI/u6jivbkCIhyuA7EK93AA3nmZ0c+VT5zVgwq3sS2f/9SptS+w==
X-Received: by 2002:a05:6871:340c:b0:21d:e301:6a34 with SMTP id nh12-20020a056871340c00b0021de3016a34mr3700813oac.3.1708963746644;
        Mon, 26 Feb 2024 08:09:06 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id e20-20020a056870451400b0021fd54aba16sm1497112oao.48.2024.02.26.08.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 08:09:06 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 10:09:04 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 05/20] dev_dax_iomap: Add dax_operations for use by
 fs-dax on devdax
Message-ID: <2cidhftdpd6t3zsbeafk5oty6uogtgfwkyysicsyyd5hbmmb7k@ebbbikzq4jyb>
References: <cover.1708709155.git.john@groves.net>
 <5727b1be956278e3a6c4cf7b728ee4f8f037ae51.1708709155.git.john@groves.net>
 <20240226123245.00000c01@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226123245.00000c01@Huawei.com>

On 24/02/26 12:32PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:49 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Notes about this commit:
> > 
> > * These methods are based somewhat loosely on pmem_dax_ops from
> >   drivers/nvdimm/pmem.c
> > 
> > * dev_dax_direct_access() is returns the hpa, pfn and kva. The kva was
> >   newly stored as dev_dax->virt_addr by dev_dax_probe().
> > 
> > * The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
> >   for read/write (dax_iomap_rw())
> > 
> > * dev_dax_recovery_write() and dev_dax_zero_page_range() have not been
> >   tested yet. I'm looking for suggestions as to how to test those.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/bus.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 107 insertions(+)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index 664e8c1b9930..06fcda810674 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -10,6 +10,12 @@
> >  #include "dax-private.h"
> >  #include "bus.h"
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +#include <linux/backing-dev.h>
> > +#include <linux/pfn_t.h>
> > +#include <linux/range.h>
> > +#endif
> > +
> 
> Is it worth avoiding includes based on config? Probably not.

Just trying to demonstrate that I can be tedious :D
I'll drop the #if unless somebody disagrees.

> 
> >  static DEFINE_MUTEX(dax_bus_lock);
> >  
> >  #define DAX_NAME_LEN 30
> > @@ -1349,6 +1355,101 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +
> 
> > +
> > +static long __dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> > +			     long nr_pages, enum dax_access_mode mode, void **kaddr,
> > +			     pfn_t *pfn)
> > +{
> > +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> > +	size_t dax_size = dev_dax_size(dev_dax);
> > +	size_t size = nr_pages << PAGE_SHIFT;
> > +	size_t offset = pgoff << PAGE_SHIFT;
> > +	phys_addr_t phys;
> > +	u64 virt_addr = dev_dax->virt_addr + offset;
> > +	pfn_t local_pfn;
> > +	u64 flags = PFN_DEV|PFN_MAP;
> > +
> > +	WARN_ON(!dev_dax->virt_addr); /* virt_addr must be saved for direct_access */
> Fair enough, but from local code point of view, does it make sense to check this
> if !kaddr as we won't use this.

Hmm. This gets called with kaddr=NULL for mmap faults, and with non-NULL
kaddr for read/write (which need the virt_addr to do a memcpy variant).
If dev_dax->virt-addr is NULL, mmap will work but read/write will hork.

I lean toward keeping the warning. With these updates, it's broken if
read/write are broken.

> > +
> > +	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
> > +
> > +	if (kaddr)
> > +		*kaddr = (void *)virt_addr;
> 
> Back to earlier comment on virt_addr as a void *. Definitely looking like
> that would be more accurate and simpler!  Also not much point in computing
> virt_addr unless kaddr is good.

Yes, done (the void *).

the computation is copied directly from drivers/nvdimm/__pmem_direct_access() -
which does not warn if virt_addr is null. Actually I suppose this code should
just trust that dev_dax_probe sets virt_addr, and not warn?

So I'm now contradicting myself above...

> 
> > +
> > +	local_pfn = phys_to_pfn_t(phys, flags); /* are flags correct? */
> If you aren't going to do anything with it for !pfn, move it under the if (pfn).
> 
> > +	if (pfn)
> > +		*pfn = local_pfn;
> > +
> > +	/* This the valid size at the specified address */
> > +	return PHYS_PFN(min_t(size_t, size, dax_size - offset));
> > +}
> > +
> 
> > +
> > +static const struct dax_operations dev_dax_ops = {
> > +	.direct_access = dev_dax_direct_access,
> > +	.zero_page_range = dev_dax_zero_page_range,
> > +	.recovery_write = dev_dax_recovery_write,
> > +};
> > +
> > +#endif /* IS_ENABLED(CONFIG_DEV_DAX_IOMAP) */
> > +
> >  struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
> >  {
> >  	struct dax_region *dax_region = data->dax_region;
> > @@ -1404,11 +1505,17 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
> >  		}
> >  	}
> >  
> 
> If we were to make this 
> 
> 	if (IS_ENABLED(CONFIG_DEV_DAX_IOMAP))
> 
> etc can we avoid the ifdef stuff above and let dead code removal deal with it?
> Might need a few stubs - I haven't tried.

Better, thanks. No stubs needed.

> 
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +	/* holder_ops currently populated separately in a slightly hacky way */
> > +	dax_dev = alloc_dax(dev_dax, &dev_dax_ops);
> > +#else
> >  	/*
> >  	 * No dax_operations since there is no access to this device outside of
> >  	 * mmap of the resulting character device.
> >  	 */
> >  	dax_dev = alloc_dax(dev_dax, NULL);
> > +#endif

Thanks!
John


