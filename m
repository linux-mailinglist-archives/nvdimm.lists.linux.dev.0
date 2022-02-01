Return-Path: <nvdimm+bounces-2743-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B42E74A5AD4
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 12:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D93C61C0A64
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 11:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A855A2CA6;
	Tue,  1 Feb 2022 11:03:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087A2CA1
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 11:03:49 +0000 (UTC)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp25G6BzCz67XhV;
	Tue,  1 Feb 2022 19:00:02 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 1 Feb 2022 12:03:47 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 11:03:47 +0000
Date: Tue, 1 Feb 2022 11:03:45 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 21/40] cxl/core: Generalize dport enumeration in the
 core
Message-ID: <20220201110345.0000689e@Huawei.com>
In-Reply-To: <164368114191.354031.5270501846455462665.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298423047.3018233.6769866347542494809.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164368114191.354031.5270501846455462665.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 31 Jan 2022 18:10:04 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> The core houses infrastructure for decoder resources. A CXL port's
> dports are more closely related to decoder infrastructure than topology
> enumeration. Implement generic PCI based dport enumeration in the core,
> i.e. arrange for existing root port enumeration from cxl_acpi to share
> code with switch port enumeration which just amounts to a small
> difference in a pci_walk_bus() invocation once the appropriate 'struct
> pci_bus' has been retrieved.
> 
> Set the convention that decoder objects are registered after all dports
> are enumerated. This enables userspace to know when the CXL core is
> finished establishing 'dportX' links underneath the 'portX' object.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>




