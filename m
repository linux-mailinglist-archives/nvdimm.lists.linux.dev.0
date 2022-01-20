Return-Path: <nvdimm+bounces-2517-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 423ED494FE0
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 15:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id DA6C13E027B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 14:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4700A2CAB;
	Thu, 20 Jan 2022 14:12:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CAF2C82
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 14:12:26 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id B904E68C4E; Thu, 20 Jan 2022 15:12:20 +0100 (CET)
Date: Thu, 20 Jan 2022 15:12:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120141219.GB11707@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 11, 2022 at 12:17:18AM -0800, John Hubbard wrote:
> Zooming in on the pinning aspect for a moment: last time I attempted to
> convert O_DIRECT callers from gup to pup, I recall wanting very much to
> record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
> or some non-FOLL_PIN method. Because at the end of the IO, it is not
> easy to disentangle which pages require put_page() and which require
> unpin_user_page*().

I don't think that is a problem.  Pinning only need to happen for
ITER_IOVEC, and the only non-user pages there is the ZERO_PAGE added
for padding that can be special cased.

