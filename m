Return-Path: <nvdimm+bounces-7291-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 179868473AB
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 16:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105191C22FF1
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Feb 2024 15:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ECA1474D0;
	Fri,  2 Feb 2024 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxOHYcNB"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DF91474A8
	for <nvdimm@lists.linux.dev>; Fri,  2 Feb 2024 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706888954; cv=none; b=CrrA58BOGGC4PiG5hrnMxegjkR3fqJ92d4kQKeeMl82GjubVdW+gBc2Z+iP3OBo1qD0ch4i+Ne4VQvW0FrhkJZ14ADEJyaZhqpZNG+K6Q29STV/XhKUbylXA+ZTTyk5hHFlCkOplEf+ChqsuoS4A5h0WIMQNYPGX1pAKfJhCfSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706888954; c=relaxed/simple;
	bh=LGMeKnVMuKT0hJfwlj8v3NusBylUlfzamfAZ3dCBxtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEuXHqy/anpgjcVgxIE4UwY5qu8LPsnCwSpSVL3uF8vy9jYguqzhRUVmASSyoU6uc3wpHRytkggSrDTIvz3aKyxDLZlPOZf4bmLxFIco953FnmYLvPfk2752ZFdMfLgThok0JC56dVG9An27y7oH7L2+HoA1o55Q1rC6PaIRkI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxOHYcNB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706888952; x=1738424952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=LGMeKnVMuKT0hJfwlj8v3NusBylUlfzamfAZ3dCBxtE=;
  b=OxOHYcNBWZAJPbv/8cr1+4qoBKOVk2qBwodnzdQYtdb77gV/lYGPlQRw
   HQPjz3gi1CCQN3PCauAsbnJZJ52mX/uBlOkddWiGS1M0wKfbO4Ba0xLj/
   dArEp4z+tt+RCc2uSWaDzVEhzSVAgLQi6z8Hy31z8aJgAa5ZnIxQdg122
   svVFJg+wh5Jhpa71/5u7gikNdo3E7cOZAX64QKseqU6wtuRBBMnPDHROS
   m0lA5JsvoTXd/3Ql59dSUcOP6LcKPtDllAdey68rlfL2OHrkY23wE51nz
   9E7xzOKwOINBlBgKXwAgjs0MchDtB3HqFvjxtoZ51fW89dMuB3sLrJl75
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="11544408"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="11544408"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 07:49:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="932497916"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="932497916"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 07:49:09 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1rVvms-00000001JDq-3RG1;
	Fri, 02 Feb 2024 17:49:06 +0200
Date: Fri, 2 Feb 2024 17:49:06 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use
 acpi_evaluate_dsm_typed()
Message-ID: <Zb0O8o-REzAjLhzl@smile.fi.intel.com>
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
 <6531d1e01d0e1_7258329440@dwillia2-xfh.jf.intel.com.notmuch>
 <ZVt1J_14iJjnSln9@smile.fi.intel.com>
 <CAJZ5v0hk2ygfjU7WtgTBhwXhqDc8+xoBb+-gs6Ym9tOJtSoZ4A@mail.gmail.com>
 <ZVuVMNlfumQ4p6oM@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZVuVMNlfumQ4p6oM@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Nov 20, 2023 at 07:19:44PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 20, 2023 at 04:11:54PM +0100, Rafael J. Wysocki wrote:
> > On Mon, Nov 20, 2023 at 4:03 PM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Thu, Oct 19, 2023 at 06:03:28PM -0700, Dan Williams wrote:
> > > > Andy Shevchenko wrote:
> > > > > The acpi_evaluate_dsm_typed() provides a way to check the type of the
> > > > > object evaluated by _DSM call. Use it instead of open coded variant.
> > > >
> > > > Looks good to me.
> > > >
> > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > Thank you!
> > >
> > > Who is taking care of this? Rafael?
> > 
> > I can apply it.
> 
> Would be nice, thank you!

Any news on this?

-- 
With Best Regards,
Andy Shevchenko



