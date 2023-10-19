Return-Path: <nvdimm+bounces-6825-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 453167CEC1C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Oct 2023 01:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763981C20AB6
	for <lists+linux-nvdimm@lfdr.de>; Wed, 18 Oct 2023 23:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4D93D3AE;
	Wed, 18 Oct 2023 23:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AgEgG8UT"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEAC15AFB
	for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697672012; x=1729208012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mufGButwLpL6uBFFn43+xl6wMGqTQF8VWI+npPtC0G4=;
  b=AgEgG8UTP4ndxlQOZsDuoVvzMlbAg70DlpfM2vTnaY/bNsOVz5cnNYDN
   HjscOcAzfWwy9rGWZ+8PxKMTh5V2r1kuuha3cjycVOCc3Y24jE6aen5bC
   Os10UuJwCFues+DSiVsvocHI5jrsb3hi9ZUUUw2huO63fp3zhXdFNJq1z
   bzYZoHxtHVT9kO7dmWrkND5QTVLs/dH/VlyK/BV7yfwwlk3t11IsHi8DH
   BOzzKkE+z2Q2QWJSGAo8FNC7q+97CuIqm2UFICwlk2RwrFD9K79nq+WyT
   bP9RZXhlbL7Xza1ZOtOkQA8TIqQdtQ8GpBnYJBBsKcGxfkZ6h3XPa/TN9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="366380841"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="366380841"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 16:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="750293083"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="750293083"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.171.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 16:33:31 -0700
Date: Wed, 18 Oct 2023 16:33:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Justin Stitt <justinstitt@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: replace deprecated strncpy with strscpy
Message-ID: <ZTBrSb/h13YzE3Ws@aschofie-mobl2>
References: <20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com>
 <CAFhGd8o-ftoGQ4qvrdGM2tSYWBqvYbF7Qb7O+UfsbzYxVmU6sA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFhGd8o-ftoGQ4qvrdGM2tSYWBqvYbF7Qb7O+UfsbzYxVmU6sA@mail.gmail.com>

On Wed, Oct 18, 2023 at 03:39:59PM -0700, Justin Stitt wrote:
> I have a feeling I may have botched the subject line for this patch.
> Can anyone confirm if it's good or not?
> 
> Automated tooling told me that this was the most common patch
> prefix but it may be caused by large patch series that just
> happened to touch this file once.
> 
> Should the subject be: nvdimm/btt: ... ?
> 
> Judging from [1] I see a few "block" and a few of nvdimm/btt.

Hi Justin,

It should be nvdimm/btt because it only touches btt.c.

Here's the old school way that I use to find prefixes. Maybe you can
train your automated tooling to do this, and then share it with me ;)

I do:

~/git/linux/drivers/nvdimm$ git log --pretty=oneline --abbrev-commit btt.c

3222d8c2a7f8 block: remove ->rw_page
ba229aa8f249 nvdimm-btt: Use the enum req_op type
86947df3a923 block: Change the type of the last .rw_page() argument
8b9ab6266204 block: remove blk_cleanup_disk
3205190655ea nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
322cbb50de71 block: remove genhd.h

And I see a few choices, with 'block' being pretty common.
I peek in those patches and see that block was used when the patch
included files in drivers/block AND also in nvdimm/btt.

Use nvdimm/btt for your patch.

A bit more below -

> 
> On Wed, Oct 18, 2023 at 3:35 PM Justin Stitt <justinstitt@google.com> wrote:
> >
> > strncpy() is deprecated for use on NUL-terminated destination strings
> > [1] and as such we should prefer more robust and less ambiguous string
> > interfaces.
> >
> > We expect super->signature to be NUL-terminated based on its usage with
> > memcpy against a NUL-term'd buffer:
> > btt_devs.c:
> > 253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
> > btt.h:
> > 13  | #define BTT_SIG "BTT_ARENA_INFO\0"
> >
> > NUL-padding is not required as `super` is already zero-allocated:
> > btt.c:
> > 985 | super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
> > ... rendering any additional NUL-padding superfluous.
> >
> > Considering the above, a suitable replacement is `strscpy` [2] due to
> > the fact that it guarantees NUL-termination on the destination buffer
> > without unnecessarily NUL-padding.
> >
> > Let's also use the more idiomatic strscpy usage of (dest, src,
> > sizeof(dest)) instead of (dest, src, XYZ_LEN) for buffers that the
> > compiler can determine the size of. This more tightly correlates the
> > destination buffer to the amount of bytes copied.
> >
> > Side note, this pattern of memcmp() on two NUL-terminated strings should
> > really be changed to just a strncmp(), if i'm not mistaken? I see
> > multiple instances of this pattern in this system.

I'm not following this note about memcmp() usage. Where is that?

> >
> > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> > Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> > Link: https://github.com/KSPP/linux/issues/90
> > Cc: linux-hardening@vger.kernel.org
> > Signed-off-by: Justin Stitt <justinstitt@google.com>
> > ---
> > Note: build-tested only.
> >
> > Found with: $ rg "strncpy\("

How you found it goes in the commit log, not below the line.

> > ---
> >  drivers/nvdimm/btt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > index d5593b0dc700..9372c36e8f76 100644
> > --- a/drivers/nvdimm/btt.c
> > +++ b/drivers/nvdimm/btt.c
> > @@ -986,7 +986,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
> >         if (!super)
> >                 return -ENOMEM;
> >
> > -       strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
> > +       strscpy(super->signature, BTT_SIG, sizeof(super->signature));
> >         export_uuid(super->uuid, nd_btt->uuid);
> >         export_uuid(super->parent_uuid, parent_uuid);
> >         super->flags = cpu_to_le32(arena->flags);
> >
> > ---
> > base-commit: 58720809f52779dc0f08e53e54b014209d13eebb
> > change-id: 20231018-strncpy-drivers-nvdimm-btt-c-15f93879989e
> >
> > Best regards,
> > --
> > Justin Stitt <justinstitt@google.com>
> >
> 
> [1]: https://lore.kernel.org/all/?q=dfn%3Adrivers%2Fnvdimm%2Fbtt.c
> 
> Thanks
> Justin
> 

