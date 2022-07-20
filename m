Return-Path: <nvdimm+bounces-4379-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C232157BBF2
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 18:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E57BF1C20996
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 16:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3106038;
	Wed, 20 Jul 2022 16:51:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDBC602F
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 16:51:33 +0000 (UTC)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp1nZ2S9mz67xNS;
	Thu, 21 Jul 2022 00:46:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 20 Jul 2022 18:51:30 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 17:51:30 +0100
Date: Wed, 20 Jul 2022 17:51:26 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 09/28] cxl/hdm: Add support for allocating DPA to an
 endpoint decoder
Message-ID: <20220720175126.00005a7d@Huawei.com>
In-Reply-To: <165784329399.1758207.16732038126938632700.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784329399.1758207.16732038126938632700.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:01:34 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The region provisioning flow will roughly follow a sequence of:
> 
> 1/ Allocate DPA to a set of decoders
> 
> 2/ Allocate HPA to a region
> 
> 3/ Associate decoders with a region and validate that the DPA allocations
>    and topologies match the parameters of the region.
> 
> For now, this change (step 1) arranges for DPA capacity to be allocated
> and deleted from non-committed decoders based on the decoder's mode /
> partition selection. Capacity is allocated from the lowest DPA in the
> partition and any 'pmem' allocation blocks out all remaining ram
> capacity in its 'skip' setting. DPA allocations are enforced in decoder
> instance order. I.e. decoder N + 1 always starts at a higher DPA than
> instance N, and deleting allocations must proceed from the
> highest-instance allocated decoder to the lowest.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


