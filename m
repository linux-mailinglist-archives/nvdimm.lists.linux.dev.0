Return-Path: <nvdimm+bounces-8544-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C357A937C42
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Jul 2024 20:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3BAB1C21440
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Jul 2024 18:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCCD1465A0;
	Fri, 19 Jul 2024 18:16:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5498D13C9A7;
	Fri, 19 Jul 2024 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721412968; cv=none; b=FFopjQ6SB0IF8AqLQwAyBe3oXTDlnchmeYJiQfY7NjPKYHniiu+ywwhRCNtvvEJbXeHjfougawD0NKL5qXjOE8NHkH+p6FUNMKzkWlWpdgwl/snQcOzx1Y3/ygFWOBnujl9Wp95kFxIAKd+9WtjTGvEu712HxEo7kQP9IdubQb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721412968; c=relaxed/simple;
	bh=qNf5UpMd67REEcicZX3rLO8ek+sXJ1i60zkOjoh4XE8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkP+W5cBt0QOPcREh18V/0fPWubcpwHV9Iziec78WbXa+Cf38Y4P1NhIfiv5rYiF1m6wEXgDe6rXKPmMrypC2YeyPhMldmpJ9tIb+jVMGmZGyOukDhZYSTTgR8/zbl8ONwmZ/VxrXXFCdh0xSHmYi2z9Ns7tHOTIKUFse4kZGFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WQd9q016gz6JBkF;
	Sat, 20 Jul 2024 02:14:39 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F7D11408FE;
	Sat, 20 Jul 2024 02:16:04 +0800 (CST)
Received: from localhost (10.48.157.16) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 19 Jul
 2024 19:16:03 +0100
Date: Fri, 19 Jul 2024 19:16:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Borislav
 Petkov" <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand
	<david@redhat.com>, "David S. Miller" <davem@davemloft.net>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Heiko Carstens
	<hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, "John Paul Adrian
 Glaubitz" <glaubitz@physik.fu-berlin.de>, Michael Ellerman
	<mpe@ellerman.id.au>, Palmer Dabbelt <palmer@dabbelt.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>, "Thomas
 Bogendoerfer" <tsbogend@alpha.franken.de>, Thomas Gleixner
	<tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Will Deacon
	<will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<loongarch@lists.linux.dev>, <linux-mips@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<sparclinux@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<devicetree@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH 16/17] arch_numa: switch over to numa_memblks
Message-ID: <20240719191602.000075d2@Huawei.com>
In-Reply-To: <20240716111346.3676969-17-rppt@kernel.org>
References: <20240716111346.3676969-1-rppt@kernel.org>
	<20240716111346.3676969-17-rppt@kernel.org>
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
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 16 Jul 2024 14:13:45 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Until now arch_numa was directly translating firmware NUMA information
> to memblock.
> 
> Using numa_memblks as an intermediate step has a few advantages:
> * alignment with more battle tested x86 implementation
> * availability of NUMA emulation
> * maintaining node information for not yet populated memory
> 
> Replace current functionality related to numa_add_memblk() and
> __node_distance() with the implementation based on numa_memblks and add
> functions required by numa_emulation.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

One trivial comment inline,

Jonathan
>  /*
>   * Initialize NODE_DATA for a node on the local memory
>   */
> @@ -226,116 +204,9 @@ static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
>  	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
>  }

>  
> @@ -454,3 +321,54 @@ void __init arch_numa_init(void)
>  
>  	numa_init(dummy_numa_init);
>  }
> +
> +#ifdef CONFIG_NUMA_EMU
> +void __init numa_emu_update_cpu_to_node(int *emu_nid_to_phys,
> +					unsigned int nr_emu_nids)
> +{
> +	int i, j;
> +
> +	/*
> +	 * Transform __apicid_to_node table to use emulated nids by

Comment needs an update seeing as there is no __apicid_to_node table
here.

> +	 * reverse-mapping phys_nid.  The maps should always exist but fall
> +	 * back to zero just in case.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(cpu_to_node_map); i++) {
> +		if (cpu_to_node_map[i] == NUMA_NO_NODE)
> +			continue;
> +		for (j = 0; j < nr_emu_nids; j++)
> +			if (cpu_to_node_map[i] == emu_nid_to_phys[j])
> +				break;
> +		cpu_to_node_map[i] = j < nr_emu_nids ? j : 0;
> +	}
> +}
> +
> +u64 __init numa_emu_dma_end(void)
> +{
> +	return PFN_PHYS(memblock_start_of_DRAM() + SZ_4G);
> +}


