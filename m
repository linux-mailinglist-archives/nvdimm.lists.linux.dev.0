Return-Path: <nvdimm+bounces-2202-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B848246E25B
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 07:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id C869F1C043E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Dec 2021 06:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A726C2CB6;
	Thu,  9 Dec 2021 06:18:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7DA29CA
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 06:18:07 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7926C68B05; Thu,  9 Dec 2021 07:11:19 +0100 (CET)
Date: Thu, 9 Dec 2021 07:11:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dan.j.williams@intel.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into
 a ssize_t
Message-ID: <20211209061118.GA31368@lst.de>
References: <20211208091203.2927754-1-hch@lst.de> <20211209004846.GA69193@magnolia> <20211209005559.GB69193@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209005559.GB69193@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 08, 2021 at 04:55:59PM -0800, Darrick J. Wong wrote:
> Ok, so ... I don't know what I'm supposed to apply this to?  Is this
> something that should go in Christoph's development branch?

This is against the decouple DAX from block devices series, which also
decouples DAX zeroing from iomap buffered I/O zeroing.  It is in nvdimm.git
and has been reviewed by you as well:

https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending

