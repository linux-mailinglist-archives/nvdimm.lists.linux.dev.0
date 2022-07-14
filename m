Return-Path: <nvdimm+bounces-4259-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E62575547
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Jul 2022 20:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36E111C20996
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Jul 2022 18:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186C6600F;
	Thu, 14 Jul 2022 18:45:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD4182
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 18:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657824319; x=1689360319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5XgSObRvgCEBVYMNFLgm/u5va9kqcKxCl7i6MOEhDrY=;
  b=ZublFOSWgpAshEb8fA3WJSOV25XTj51ssGOMyLRnej3KEDM1tgCtF0Ox
   Os3u9bMLIy1tD6zRKfJ5MLX8FnsGypsLsMG74cHYSJetATFabQftoY/12
   4jcRI0TdpNkvRMItbSUvCG7W7ThnsOBjMgGb5bIacQx9yWUjNpw61gs+m
   iuJp1JiIAOsUvxMTGK5KvcAlV9MWe+AJDjnjeJ+zf236GWTw7FR8wzlF9
   qwoV5Dw10Uw/11g/QRADNUkr5EclhAmN64T63GGxViYUO1hV0J/Bce8BL
   dy2Q2Jsp7QupSE350fSKcOLntTgAuF3tml9ABbo4PIXph8gD/0bqA8zBL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="349569735"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="349569735"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:45:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685678001"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:45:16 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1oC3pq-001Dco-13;
	Thu, 14 Jul 2022 21:45:14 +0300
Date: Thu, 14 Jul 2022 21:45:14 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v1 1/1] nvdimm/namespace: return uuid_null only once in
 nd_dev_to_uuid()
Message-ID: <YtBkOo2vME1jgU1C@smile.fi.intel.com>
References: <20220607152525.33468-1-andriy.shevchenko@linux.intel.com>
 <62d05f453b73e_1643dc29412@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d05f453b73e_1643dc29412@dwillia2-xfh.jf.intel.com.notmuch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Jul 14, 2022 at 11:24:05AM -0700, Dan Williams wrote:
> Andy Shevchenko wrote:
> > Refactor nd_dev_to_uuid() in order to make code shorter and cleaner
> > by joining conditions and hence returning uuid_null only once.
> 
> Apologies for the delay, applied for v5.20.

No problem and thanks!

P.S. One patch out of three is a fix, would be nice to have it in v5.19
release.

-- 
With Best Regards,
Andy Shevchenko



