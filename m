Return-Path: <nvdimm+bounces-8646-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FC4945CEC
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Aug 2024 13:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4210DB2285F
	for <lists+linux-nvdimm@lfdr.de>; Fri,  2 Aug 2024 11:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190C41DE85F;
	Fri,  2 Aug 2024 11:10:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765BF14A4E0;
	Fri,  2 Aug 2024 11:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722597024; cv=none; b=uEMCU1mRtcWV/VKoiPZC6bBL7IBVohTlEotetTGGRGaigViztjaPBoLwgLKiL/ssKY3Rd7MsbEH/4Kldztgrf1Y5jgWPWLRUX8hlJPLhRIrWb0Tn3ANG5Bdy1HsDszgdjdoGIkwLMn/7ASJ/S9joi4wATD9MmGrLDFKjU6syyFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722597024; c=relaxed/simple;
	bh=iVYR4L5I/J5MqbejthtE09y+bhsl6E2x2ACkW0f856A=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HWhRZgZG56cCjiTFny0elUvg8sglRmqJmODAjyKsEN90yhcAkgav/x5Ok/wlGofWq6rwDs+3Kno4Oi8jTWutxeX+dDENYj8/VC8nT3kFvmKrDuzNBIkaaeoserCMZ/UJ+BOwBagCLPkr08jMXZN5WCW1uRnkYvn6MKJIRDrPbkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wb32l3LPdz6K9BV;
	Fri,  2 Aug 2024 19:07:43 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id CF3FF140A08;
	Fri,  2 Aug 2024 19:10:20 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 2 Aug
 2024 12:10:13 +0100
Date: Fri, 2 Aug 2024 12:10:10 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Borislav
 Petkov" <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand
	<david@redhat.com>, "David S. Miller" <davem@davemloft.net>, Davidlohr Bueso
	<dave@stgolabs.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, Heiko
 Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, "John Paul
 Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
	<corbet@lwn.net>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt
	<palmer@dabbelt.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring
	<robh@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner
	<tglx@linutronix.de>, "Vasily Gorbik" <gor@linux.ibm.com>, Will Deacon
	<will@kernel.org>, Zi Yan <ziy@nvidia.com>, <devicetree@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mips@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <loongarch@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <sparclinux@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v3 21/26] mm: numa_memblks: make several functions and
 variables static
Message-ID: <20240802121010.00000113@Huawei.com>
In-Reply-To: <20240801060826.559858-22-rppt@kernel.org>
References: <20240801060826.559858-1-rppt@kernel.org>
	<20240801060826.559858-22-rppt@kernel.org>
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
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Thu,  1 Aug 2024 09:08:21 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Make functions and variables that are exclusively used by numa_memblks
> static.
> 
> Move numa_nodemask_from_meminfo() before its callers to avoid forward
> declaration.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Good. I was wondering why some of this internal detail was in the header.
Much nicer after this.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

