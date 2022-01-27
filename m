Return-Path: <nvdimm+bounces-2647-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4862149EE11
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jan 2022 23:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 62DDA1C0A77
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jan 2022 22:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385282CAC;
	Thu, 27 Jan 2022 22:27:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB582CA0
	for <nvdimm@lists.linux.dev>; Thu, 27 Jan 2022 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643322457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0FA5WCPvNytSlh5Kpb7PaP0H/+ZX/zbZ764R+kzAQc=;
	b=WYUxAE27dCCGGjjDh6KZdAqm8l8cGhcH2lK5PNGMgGD+u2vZ/jvbyghHc0e92/YP9qWiRs
	lVimEqCiT3wggcFnSEA66WBBgLu9MrIgNuyjy6ALlQHiNN9iycKb458o3Yht9IcEhQWc2b
	Nkho++ONliiKZSMzo4HCCLkpM8ZJeSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-w_CT1qgDNuS0vl85_t44_Q-1; Thu, 27 Jan 2022 17:27:31 -0500
X-MC-Unique: w_CT1qgDNuS0vl85_t44_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35AD314751;
	Thu, 27 Jan 2022 22:27:29 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D80D576606;
	Thu, 27 Jan 2022 22:27:27 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: "Li\, Zhijian" <lizhijian@cn.fujitsu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,  <linux-rdma@vger.kernel.org>,  <zyjzyj2000@gmail.com>,  <aharonl@nvidia.com>,  <leon@kernel.org>,  <linux-kernel@vger.kernel.org>,  <mbloch@nvidia.com>,  <liangwenpeng@huawei.com>,  <yangx.jy@cn.fujitsu.com>,  <rpearsonhpe@gmail.com>,  <y-goto@fujitsu.com>,  <dan.j.williams@intel.com>,  "nvdimm\@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [RFC PATCH rdma-next 01/10] RDMA: mr: Introduce is_pmem
References: <20211228080717.10666-1-lizhijian@cn.fujitsu.com>
	<20211228080717.10666-2-lizhijian@cn.fujitsu.com>
	<20220106002130.GP6467@ziepe.ca>
	<bf038e6c-66db-50ca-0126-3ad4ac1371e7@fujitsu.com>
	<4e679df5-633d-cd0c-9de3-16348b2cef35@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Thu, 27 Jan 2022 17:30:08 -0500
In-Reply-To: <4e679df5-633d-cd0c-9de3-16348b2cef35@cn.fujitsu.com> (Zhijian
	Li's message of "Fri, 14 Jan 2022 16:10:33 +0800")
Message-ID: <x49mtjgg6bz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

"Li, Zhijian" <lizhijian@cn.fujitsu.com> writes:

> Copied to nvdimm list
>
> Thanks
>
> Zhijian
>
>
> on 2022/1/6 14:12, Li Zhijian wrote:
>>
>> Add Dan to the party :)
>>
>> May i know whether there is any existing APIs to check whether
>> a va/page backs to a nvdimm/pmem ?

I don't know of one.  You could try walk_system_ram_range looking for
IORES_DESC_PERSISTENT_MEMORY, but that's not very efficient.

>>> You need to get Dan to check this out, but I'm pretty sure this should
>>> be more like this:
>>>
>>> if (is_zone_device_page(page) && page->pgmap->type ==
>>> MEMORY_DEVICE_FS_DAX)

You forgot MEMORY_DEVICE_GENERIC.  However, this doesn't guarantee the
memory belongs to persistent memory, only that it is direct access
capable.

Dan, any ideas?

-Jeff


