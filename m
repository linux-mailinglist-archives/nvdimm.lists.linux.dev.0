Return-Path: <nvdimm+bounces-7882-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76842899ED8
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Apr 2024 15:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 312EE28319C
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Apr 2024 13:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C880A16D9B0;
	Fri,  5 Apr 2024 13:56:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A0F16D309
	for <nvdimm@lists.linux.dev>; Fri,  5 Apr 2024 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712325389; cv=none; b=k8o0kyIXvfT4QFPyu2sru04A/xES+YltT85omRU8E8ArCcLCPfchtLBeV2eZOdrub51L2aB3VdMxeD9RkwwAl5GXM3tfLSPhnwP5vsM8vAw12WECX5cD+ocYbPnZTTk4fY5Q/61SqNk2uPVn3i7ZMNLYqqFz48oIktBYxeT4TuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712325389; c=relaxed/simple;
	bh=w+JtL2IWPbD3Av4ZJi5FOYcsvgEQMF3c4SDgRYwLT1g=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gdf3crJb1k4y1aW7oOCPh3Rh6/4RiNAdflhJXIUDiClbCnHNkNJcx4DdV/FASiBXzHoPWBsCt5rEs/0qJ7j22fCxP6CG0jUo7sb1ZaE9QLUKQCz1s02DFT5KOKBpsYA2mdiQKsv8+VMpW47OX6i0kKg0lii/Ahtz+W8a0X+l7Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VB0Jx1Q6qz67FR3;
	Fri,  5 Apr 2024 21:51:45 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id D9EF71400D1;
	Fri,  5 Apr 2024 21:56:25 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 5 Apr
 2024 14:56:25 +0100
Date: Fri, 5 Apr 2024 14:56:24 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
CC: "Huang, Ying" <ying.huang@intel.com>, Gregory Price
	<gourry.memverge@gmail.com>, <aneesh.kumar@linux.ibm.com>, <mhocko@suse.com>,
	<tj@kernel.org>, <john@jagalactic.com>, Eishan Mirakhur
	<emirakhur@micron.com>, Vinicius Tavares Petrucci <vtavarespetr@micron.com>,
	Ravis OpenSrc <Ravis.OpenSrc@micron.com>, Alistair Popple
	<apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, SeongJae
 Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, "Dave Jiang" <dave.jiang@intel.com>, Andrew
 Morton <akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, "Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack)
 Chuang" <horenchuang@gmail.com>, <qemu-devel@nongnu.org>
Subject: Re: [PATCH v11 1/2] memory tier: dax/kmem: introduce an abstract
 layer for finding, allocating, and putting memory types
Message-ID: <20240405145624.00000b31@Huawei.com>
In-Reply-To: <20240405000707.2670063-2-horenchuang@bytedance.com>
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
	<20240405000707.2670063-2-horenchuang@bytedance.com>
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
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri,  5 Apr 2024 00:07:05 +0000
"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:

> Since different memory devices require finding, allocating, and putting
> memory types, these common steps are abstracted in this patch,
> enhancing the scalability and conciseness of the code.
> 
> Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawie.com>


