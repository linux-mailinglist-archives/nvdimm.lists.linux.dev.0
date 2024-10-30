Return-Path: <nvdimm+bounces-9194-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D63029B666A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Oct 2024 15:49:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A6F71F21790
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Oct 2024 14:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2EB1F4FB9;
	Wed, 30 Oct 2024 14:48:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F67E1F4FAF;
	Wed, 30 Oct 2024 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730299729; cv=none; b=Uu56uYRnSnIxwHHAce45UF7T2amLN1fdjuTcKSFTn6Y8gQU9zgUaDgvmilHvMqpGPL1rEX8IB0IO2mHjAeIicYwPvVZGLayrXEMJO9fu7t0/EaDmgINS7BB7+Tn+rp4tnL/rhLDl9l0UwD/B+zrozTR6N6B4NPkqlbzmvBVYxWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730299729; c=relaxed/simple;
	bh=lQRfqcUFnh1Q9TAfFVHoDskiifmQlnSBJhbcwNY/6Zs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYqq+4nj02OZKCLjDK99inWMFmcdSFsG16hINgXbWe9auEkgdi3Oo7YcGzCvRzR1qOVVNtMgQTuG7WxNB7GcWCALUMIaINWGUwjs6vWv89SBptmz5N3hZ9alqTzpX3fu9CJq0FowKN+NTMz+6S+VkhugGYP4oUcMwydLK3Cc25Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xdqd53czYz6GFBq;
	Wed, 30 Oct 2024 22:43:53 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B55EB140593;
	Wed, 30 Oct 2024 22:48:44 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 15:48:43 +0100
Date: Wed, 30 Oct 2024 14:48:41 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Chris Mason
	<clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>, Robert Moore <robert.moore@intel.com>, "Len
 Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	<linux-acpi@vger.kernel.org>, <acpica-devel@lists.linux.dev>, Li Ming
	<ming4.li@intel.com>, Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
	<gustavoars@kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v5 00/27] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <20241030144841.00006746@Huawei.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
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
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 29 Oct 2024 15:34:35 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> A git tree of this series can be found here:
> 
> 	https://github.com/weiny2/linux-kernel/tree/dcd-v4-2024-10-29
> 
> Series info
> ===========
> 
> This series has 4 parts:
> 
> Patch 1: Add core range_overlaps() function
> Patch 2-6: CXL clean up/prelim patches
> Patch 7-25: Core DCD support
> Patch 26-27: cxl_test support

Other than a few trivial comments and that one build bot reported
issue all looks good to me. Nice work Ira, Navneet etc.

Maybe optimistic to hit 6.13, but I'd love it if it did.
If not, Dave, how about shaving a few off the front so at least
there is less to remember for v6 onwards :)

Jonathan

