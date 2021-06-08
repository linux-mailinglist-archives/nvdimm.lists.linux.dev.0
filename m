Return-Path: <nvdimm+bounces-150-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 080B339EE33
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Jun 2021 07:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2E6911C0E14
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Jun 2021 05:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8480F2FB4;
	Tue,  8 Jun 2021 05:36:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFB872
	for <nvdimm@lists.linux.dev>; Tue,  8 Jun 2021 05:36:36 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23B5C67373; Tue,  8 Jun 2021 07:36:28 +0200 (CEST)
Date: Tue, 8 Jun 2021 07:36:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Sachin Sant <sachinp@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Ulf Hansson <ulf.hansson@linaro.org>, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] libnvdimm/pmem: Fix blk_cleanup_disk() usage
Message-ID: <20210608053627.GB14116@lst.de>
References: <162310861219.1571453.6561642225122047071.stgit@dwillia2-desk3.amr.corp.intel.com> <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Thanks Dan, this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Jens, can you quickly pick this up?

