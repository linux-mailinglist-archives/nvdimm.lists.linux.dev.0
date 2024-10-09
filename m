Return-Path: <nvdimm+bounces-9023-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FC5996ADF
	for <lists+linux-nvdimm@lfdr.de>; Wed,  9 Oct 2024 14:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15EF41F29484
	for <lists+linux-nvdimm@lfdr.de>; Wed,  9 Oct 2024 12:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F1D19E83C;
	Wed,  9 Oct 2024 12:51:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A718619CC34
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728478314; cv=none; b=YxtvC3Vax6GAiLeE7+SOqzcoh9GoVDqRyR3kq/ayyBepdcGLdcGi2NrcDVkmXxBNLCSBv9IygZOGJMeM/biyNXquI3Ek4id8HBgoHXZnGZjexI6PKTu7VtrDyGjNBLQEL+lG6mb2PbXtvJZk2i8wtgETBUYINmbzXlHKOK7zCAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728478314; c=relaxed/simple;
	bh=dF3rM4GYNFGcBcZ9fKpWcLZR2/eAYRWIYHT7Mt8IkJo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQx0DMe7PiRU/E1UEIV5NAnoSF3vy+cKwPtwDaelBhY3by+3ZRs+1KCjq4v8uKsIvdcU+a3k8i++h094tAFJEIDQTUUP5gGmJJPUf+CxK/4BGEDPsnws2I++mIEHIVFQ04b4nYBntP7ees3igUjhQXxfHnaSzBEvEN/oHEGniDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNt6066Zyz6K76s;
	Wed,  9 Oct 2024 20:50:32 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A1AC14038F;
	Wed,  9 Oct 2024 20:51:50 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 9 Oct
 2024 14:51:48 +0200
Date: Wed, 9 Oct 2024 13:51:46 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-btrfs@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/28] cxl/core: Separate region mode from decoder
 mode
Message-ID: <20241009135146.00001043@Huawei.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-9-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-9-c261ee6eeded@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Oct 2024 18:16:15 -0500
ira.weiny@intel.com wrote:

> From: Navneet Singh <navneet.singh@intel.com>
> 
> Until now region modes and decoder modes were equivalent in that both
> modes were either PMEM or RAM.  The addition of Dynamic
> Capacity partitions defines up to 8 DC partitions per device.
> 
> The region mode is thus no longer equivalent to the endpoint decoder
> mode.  IOW the endpoint decoders may have modes of DC0-DC7 while the
> region mode is simply DC.
> 
> Define a new region mode enumeration which applies to regions separate
> from the decoder mode.  Adjust the code to process these modes
> independently.
> 
> There is no equal to decoder mode dead in region modes.  Avoid
> constructing regions with decoders which have been flagged as dead.
> 
> Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>



