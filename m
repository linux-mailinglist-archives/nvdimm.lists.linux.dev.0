Return-Path: <nvdimm+bounces-10133-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87EB2A7BDEB
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Apr 2025 15:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 683563B8963
	for <lists+linux-nvdimm@lfdr.de>; Fri,  4 Apr 2025 13:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8651F0E57;
	Fri,  4 Apr 2025 13:34:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2671F0E31
	for <nvdimm@lists.linux.dev>; Fri,  4 Apr 2025 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773655; cv=none; b=LX71yGmEe8hGfNJiZmIMYoCT5O3Y5PIwmYuXgA7srWqyszF8r7IiGU1vX+4q0hYnwwQJw8WbtGandT89jpwMA14ei/T4GZbyGfz/n6OT8i4TZMITrPP8DuyEHdF9oO0ERruX9WOqB3yTqA/T8ARD/f383wYdJZZannOavRO6QiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773655; c=relaxed/simple;
	bh=B6AmqiWAWAQHPpfTvZpYHk8KMpkuBOP+r7HbmOUmCgI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBc0zbu7bVj8EQZJS8r9a4SK1CwyiCwp0HN2h+07rbPyit5r2+S0X332AgNK5KjCxxmTJgRdE737jJqD3BlisTA+DMwrdVhwXGDVzoE8Rqi4RqU8fiQm7DUfkGN+N8ISL/voGghpfeC+VvOmuUrZgmmXHlXEszK70bEupGHNP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZTfcQ2vK9z6M4WF;
	Fri,  4 Apr 2025 21:30:30 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C3B2140682;
	Fri,  4 Apr 2025 21:34:12 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 4 Apr
 2025 15:34:10 +0200
Date: Fri, 4 Apr 2025 14:34:09 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Terry Bowman <terry.bowman@amd.com>
CC: <dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<rafael@kernel.org>, <len.brown@intel.com>, <pavel@ucw.cz>,
	<ming.li@zohomail.com>, <nathan.fontenot@amd.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <huang.ying.caritas@gmail.com>,
	<yaoxt.fnst@fujitsu.com>, <peterz@infradead.org>,
	<gregkh@linuxfoundation.org>, <quic_jjohnson@quicinc.com>,
	<ilpo.jarvinen@linux.intel.com>, <bhelgaas@google.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<akpm@linux-foundation.org>, <gourry@gourry.net>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <rrichter@amd.com>, <benjamin.cheatham@amd.com>,
	<PradeepVineshReddy.Kodamati@amd.com>, <lizhijian@fujitsu.com>
Subject: Re: [PATCH v3 3/4] dax/mum: Save the dax mum platform device
 pointer
Message-ID: <20250404143409.00000961@huawei.com>
In-Reply-To: <20250403183315.286710-4-terry.bowman@amd.com>
References: <20250403183315.286710-1-terry.bowman@amd.com>
	<20250403183315.286710-4-terry.bowman@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 3 Apr 2025 13:33:14 -0500
Terry Bowman <terry.bowman@amd.com> wrote:

> From: Nathan Fontenot <nathan.fontenot@amd.com>

mum?

> 
> In order to handle registering hmem devices for SOFT RESERVE
> resources after the dax hmem device initialization occurs
> we need to save a reference to the dax hmem platform device
> that will be used in a following patch.
> 
> Saving the platform device pointer also allows us to clean
> up the walk_hmem_resources() routine to no require the
> struct device argument.
> 
> There should be no functional changes.
> 
> Signed-off-by: Nathan Fontenot <nathan.fontenot@amd.com>
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>


