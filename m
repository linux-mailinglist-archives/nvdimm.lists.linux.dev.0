Return-Path: <nvdimm+bounces-6922-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B157F16A2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 20 Nov 2023 16:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82E85B218F2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 20 Nov 2023 15:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58EA1CAA3;
	Mon, 20 Nov 2023 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N52dy9Mu"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1FC1C6B5
	for <nvdimm@lists.linux.dev>; Mon, 20 Nov 2023 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700492600; x=1732028600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XD144tY1SUS/e9n/Sng5IXSmD15Fyn6Y6l/2wUYcIcA=;
  b=N52dy9MuVynoSi1a0JOj/yfPVjk9FM+ejVgGRvapQw9tVRYcqmG2WRNv
   1S07kWrZ6LiUl//+aXqx1hmWGPfH4/9zNMjb+1B4kh4tptTD+yskQLfrG
   YHPWud8izSyyGVreZ9ziaqFZLR7wY+vMetqYv46wh25UJizy1Lp1ZlOe5
   ui09HEWSgBiQj3rjAor0ze9KFj5gXeowccUaMpvPLyPQKlzgtINschDZO
   rgInK5limZEyE83JTJZ8SGcBUji34mzenuM7cE5sTfJtBYJVEscOk899z
   R7Def9ti6Ww4M3Z68Lc6OWZr+VdmqOhnV3CXMyPs0zJ1rX/fEhJEiqzYz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="4820556"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="4820556"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 07:03:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="939814693"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="939814693"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 07:03:06 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1r55nj-0000000FZzA-2YQd;
	Mon, 20 Nov 2023 17:03:03 +0200
Date: Mon, 20 Nov 2023 17:03:03 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use
 acpi_evaluate_dsm_typed()
Message-ID: <ZVt1J_14iJjnSln9@smile.fi.intel.com>
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
 <6531d1e01d0e1_7258329440@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6531d1e01d0e1_7258329440@dwillia2-xfh.jf.intel.com.notmuch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 19, 2023 at 06:03:28PM -0700, Dan Williams wrote:
> Andy Shevchenko wrote:
> > The acpi_evaluate_dsm_typed() provides a way to check the type of the
> > object evaluated by _DSM call. Use it instead of open coded variant.
> 
> Looks good to me.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thank you!

Who is taking care of this? Rafael?

-- 
With Best Regards,
Andy Shevchenko



