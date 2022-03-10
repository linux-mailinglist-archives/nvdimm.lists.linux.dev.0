Return-Path: <nvdimm+bounces-3288-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 508494D419A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 08:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 48EB71C0C60
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 07:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F4B539D;
	Thu, 10 Mar 2022 07:11:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DC7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 07:11:02 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DF5068AFE; Thu, 10 Mar 2022 08:10:59 +0100 (CET)
Date: Thu, 10 Mar 2022 08:10:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, robert.hu@linux.intel.com,
	vishal.l.verma@intel.com, hch@lst.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/6] nvdimm/namespace: Delete nd_namespace_blk
Message-ID: <20220310071059.GD25138@lst.de>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com> <164688417727.2879318.11691110761800109662.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164688417727.2879318.11691110761800109662.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 09, 2022 at 07:49:37PM -0800, Dan Williams wrote:
> Now that none of the configuration paths consider BLK namespaces, delete
> the BLK namespace data and supporting code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

