Return-Path: <nvdimm+bounces-14286-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id TyfwE3lSH2qkkQAAu9opvQ
	(envelope-from <nvdimm+bounces-14286-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 00:00:25 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 471336324B7
	for <lists+linux-nvdimm@lfdr.de>; Wed, 03 Jun 2026 00:00:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=bYNYy6De;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14286-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14286-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 413173026501
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Jun 2026 21:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58DA3AE194;
	Tue,  2 Jun 2026 21:58:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8F38B122
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 21:58:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780437535; cv=none; b=b8VGlJ5yzzZ3C731pbaZa7kUax4cPeazrJy3UyV6P4E7bwvVOft9YnHNZPCSwEIXwYSQfczqRcUfIJI6uBkVIemSax/i6ZxCfi5rHBUyD6yzhpTyRrpl4pL1g5S9DPm06M0Qf0Q5NWczhgYke1fDs+E2g4zXp1pWoJlKkd3VjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780437535; c=relaxed/simple;
	bh=lNy4OD9Hyui7+ARYdd9IyIqNHVlY1wQRJPb6kguiFcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpErt3PyXrtHN5nBvSk8CaXL5+/uXwI90HNMsf4AGysRuH2+4vHLLjeCu25N2GGvefEnr1ZH18SDbW+AM7oKk1bXoxZk9SJxkimvuA5h3uFCtnCMYCD2ywCqznanSqcy/lHgh5JGI0md4kemeX9sXESp43It7zOIfZLrcRYhLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYNYy6De; arc=none smtp.client-ip=198.175.65.20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780437535; x=1811973535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lNy4OD9Hyui7+ARYdd9IyIqNHVlY1wQRJPb6kguiFcI=;
  b=bYNYy6DenQmibd184gy309DYHMHwjWYvHZTXDlK7bSrjzpoTIhKrZyoJ
   3jDItJOsf1I1bR9E04I48smfD5NA5VlsswveJLWPt1b81hsByd5lOMM7P
   A2sFtyu5AJ6IhUajRO7DGakjJQWZAtAHDlh2yurEHJHDLbqtu2Yij5sWO
   1uhk8j/Bd+BdtjBfEnbtHsNvVWrTRmHrw8oacseERoYAt5VSI9UTQj+40
   Fey9I0MG+Qg4iffh1k2o7g0dHnfDgR5DDaIk8suCJV7NHyrflQiDL1+Fy
   JAWd9bn5uS0trC6qMhcrfj6Q1mNLJRijr10dZ8SzeCM1fq/Wr//Dv8Q3I
   Q==;
X-CSE-ConnectionGUID: da6zUwyyT4qhh8yyG9QIQA==
X-CSE-MsgGUID: VEsGiND0RgmQJX5veo4CXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80973649"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="80973649"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:58:54 -0700
X-CSE-ConnectionGUID: IG+QdlJ5TlK0+C4nKDLCdg==
X-CSE-MsgGUID: 9clSxAXFQ5mnHp1Pm9/Kgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="245838734"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.116])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:58:51 -0700
Date: Wed, 3 Jun 2026 00:58:49 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans de Goede <hansg@kernel.org>, Armin Wolf <w_armin@gmx.de>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v1 01/17] ACPI: bus: Introduce
 devm_acpi_install_notify_handler()
Message-ID: <ah9SGXfJv2fz22Yl@ashevche-desk.local>
References: <4739447.LvFx2qVVIh@rafael.j.wysocki>
 <2268031.irdbgypaU6@rafael.j.wysocki>
 <ah8l-p0Ih9tzu0G1@ashevche-desk.local>
 <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14286-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmx.de,intel.com,lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[andriy.shevchenko@linux.intel.com,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:rafael@kernel.org,m:linux-acpi@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:hansg@kernel.org,m:w_armin@gmx.de,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andriy.shevchenko@linux.intel.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.intel.com:from_mime,ashevche-desk.local:mid,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 471336324B7

On Tue, Jun 02, 2026 at 10:57:23PM +0200, Rafael J. Wysocki wrote:
> On Tue, Jun 2, 2026 at 8:50 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Thu, May 21, 2026 at 03:59:50PM +0200, Rafael J. Wysocki wrote:

...

> > > +     acpi_dev_remove_notify_handler(ACPI_COMPANION(dev), dr->handler_type,
> >
> > acpi_dev might be also part of the same data structure, so you won't need to
> > take dev again and derive adev from it.
> 
> I'm not sure what you mean.
> 
> Put acpi_dev into struct acpi_notify_handler_devres?

Yes.

> > > +                                    dr->handler);

...

> > > + * devm_acpi_install_notify_handler - Install an ACPI notify handler for a

> > > + *                                 managed device
> >
> > There is a stray space just after asterisk.
> 
> Which asterisk?

The line above has "<space>*<space>(sic!)<tab><tab> ... managed device".
The <space> after the asterisk is a stray one.

...

> > > +             return dev_err_probe(dev, -ENODEV, "No ACPI companion in %s()\n", __func__);
> >
> > Not sure how __func__ may help here. We will have a device instance to be
> > printed. It's obvious then how to find the culprit call.
> 
> But it doesn't hurt either, does it?

From my p.o.v. it's just extra information that's not needed. But I'm not going
fight to death against it.

...

> So thanks for the review, but I don't think I want to send a v2 at this point.
> 
> I'd rather send a follow-up patch to clean up these things.

Okay!

-- 
With Best Regards,
Andy Shevchenko



