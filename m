Return-Path: <nvdimm+bounces-6393-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E1F75FE9F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jul 2023 19:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2969C281555
	for <lists+linux-nvdimm@lfdr.de>; Mon, 24 Jul 2023 17:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0982CFC0B;
	Mon, 24 Jul 2023 17:58:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB65CE574
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 17:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8E4C433C8;
	Mon, 24 Jul 2023 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1690221500;
	bh=u9D54zq4EdgBWh/eN7pPZ8Dj/7qWB0LLjRe/rMAT3ho=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cKcJFTHDevuSI0ZlnIWdCBK0O9NxDuj0WLboJT6+Zk0IyAg5JNx/x1ak2bOLT0Yjy
	 N/wiH824oULVzq+bSZPdotHXs1+XAYTcfybPV3Hd7k05viyvSDI54vGuE5Uj7OPwif
	 L/PmpnN8mGDvJZvy8hrWZdPxATu88KRrwWVVtkMU=
Date: Mon, 24 Jul 2023 10:58:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Wei Xu <weixugc@google.com>, Dan Williams
 <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Davidlohr
 Bueso <dave@stgolabs.net>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan
 Cameron <Jonathan.Cameron@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Yang Shi <shy828301@gmail.com>, Rafael J Wysocki
 <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH RESEND 0/4] memory tiering: calculate abstract distance
 based on ACPI HMAT
Message-Id: <20230724105818.6f7b10fc8c318ea5aae9e188@linux-foundation.org>
In-Reply-To: <875y6dj3ok.fsf@nvdebian.thelocal>
References: <20230721012932.190742-1-ying.huang@intel.com>
	<875y6dj3ok.fsf@nvdebian.thelocal>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Jul 2023 14:15:31 +1000 Alistair Popple <apopple@nvidia.com> wrote:

> Thanks for this Huang, I had been hoping to take a look at it this week
> but have run out of time. I'm keen to do some testing with it as well.

Thanks.  I'll queue this in mm-unstable for some testing.  Detailed
review and testing would be appreciated.

I made some adjustments to handle the renaming of destroy_memory_type()
to put_memory_type()
(https://lkml.kernel.org/r/20230706063905.543800-1-linmiaohe@huawei.com)

