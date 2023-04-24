Return-Path: <nvdimm+bounces-5930-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8176E2A86
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Apr 2023 21:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B08C7280998
	for <lists+linux-nvdimm@lfdr.de>; Fri, 14 Apr 2023 19:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B2C63D3;
	Fri, 14 Apr 2023 19:15:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3732CA9
	for <nvdimm@lists.linux.dev>; Fri, 14 Apr 2023 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681499700; x=1713035700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=O/ZkdGkFWjPqCH3nbEJPSXJ9hN5Lx0sJbMbzI1w+lY4=;
  b=cXBmXNB40jbee42SBqLCd+yDV5F+PULn5E4HnAkbqmp+Cgj8e6Kh4XKM
   ohhlAtSXHlax2awOOmUpUOh7S/wib5GbqrA46+37FNn2r4Zvu2BH4e4PN
   eHJgeaJrhR+NvAu3Pz8rKcAZ1fRM8m8u4ZUyycSkCX5zsAMhPHeg9jdmu
   9mUOCdU3+r2gTmyGCtxuRtqrsZGYTJtO0Cqyv82h77jTEX/+WATifFmsT
   SKFbaWt1pvEbjfvhP/qT2O7GQAQ8EN44u8y1+E6Ly7a7DFEuCneJAllGq
   bY9iH8C7GUGmPJAG7H91KLAVwy8fd4+ev2ioWYuz2a684MsvpGW16rh3K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="430841784"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="430841784"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 12:14:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="667304254"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="667304254"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.22.80])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 12:14:59 -0700
Date: Fri, 14 Apr 2023 12:14:58 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: kernel-janitors@vger.kernel.org, nvdimm@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>, cocci@inria.fr,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: Replace the usage of a variable by a direct
 function call in nd_pfn_validate()
Message-ID: <ZDmmMhFTg5TaikRl@aschofie-mobl2>
References: <40c60719-4bfe-b1a4-ead7-724b84637f55@web.de>
 <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
 <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>
 <ZDlvunCNe9yWykIE@aschofie-mobl2>
 <88f4dd20-4159-2b66-3adc-9a5a68f9eec7@web.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88f4dd20-4159-2b66-3adc-9a5a68f9eec7@web.de>

On Fri, Apr 14, 2023 at 06:50:59PM +0200, Markus Elfring wrote:
> >> The address of a data structure member was determined before
> >> a corresponding null pointer check in the implementation of
> >> the function “nd_pfn_validate”.
> >>
> >> Thus avoid the risk for undefined behaviour by replacing the usage of
> >> the local variable “parent_uuid” by a direct function call within
> >> a later condition check.
> >
> > Hi Markus,
> >
> > I think I understand what you are saying above, but I don't follow
> > how that applies here. This change seems to be a nice simplification,
> > parent_uuid, is used once, just grab it when needed.
> 
> Thanks for your positive feedback.

Hi Markus,

FYI - I'm a tiny bit taken aback that in response to me applying, and
providing feedback, on your patch, you respond with 2 links for me to
follow and cut off a chunk of my feedback.

Seems like it would taken the same amount of time to just answer my
two questions directly.

Was this part of a larger patch set? Andy's comment seems to indicate
that. Would have been nice to be CC'd on the cover letter.


More below...

> 
> 
> > What is the risk of undefined behavior?
> 
> See also:
> https://wiki.sei.cmu.edu/confluence/display/c/EXP34-C.+Do+not+dereference+null+pointers?focusedCommentId=405504137#comment-405504137

Where is the NULL pointer dereference here?

> 
> 
> >> This issue was detected by using the Coccinelle software.
> > Which cocci script?
> 
> See also:
> Reconsidering pointer dereferences before null pointer checks (with SmPL)
> https://lore.kernel.org/cocci/1a11455f-ab57-dce0-1677-6beb8492a257@web.de/
> https://sympa.inria.fr/sympa/arc/cocci/2023-04/msg00021.html
> 

The cocci script linked above does not seem to apply here.

> 
> How do you think about to review and improve any similarly affected software components?
> 
> Regards,
> Markus
> 

