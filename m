Return-Path: <nvdimm+bounces-3291-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1C64D41A8
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 08:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 57C593E0F31
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 07:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7E1539F;
	Thu, 10 Mar 2022 07:18:55 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6017A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 07:18:53 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1652468B05; Thu, 10 Mar 2022 08:09:49 +0100 (CET)
Date: Thu, 10 Mar 2022 08:09:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, robert.hu@linux.intel.com,
	vishal.l.verma@intel.com, hch@lst.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/6] nvdimm/region: Fix default alignment for small
 regions
Message-ID: <20220310070948.GA25138@lst.de>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com> <164688416128.2879318.17890707310125575258.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164688416128.2879318.17890707310125575258.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 09, 2022 at 07:49:21PM -0800, Dan Williams wrote:
> In preparation for removing BLK aperture support the NVDIMM unit tests
> discovered that the default alignment can be set higher than the
> capacity of the region. Fall back to PAGE_SIZE in that case.
> 
> Given this has not been seen in the wild, elide notifying -stable.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

