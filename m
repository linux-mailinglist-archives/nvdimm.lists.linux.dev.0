Return-Path: <nvdimm+bounces-611-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CF83D5534
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 10:19:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E14F93E0F56
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 08:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B8C2FB2;
	Mon, 26 Jul 2021 08:19:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D78170
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 08:19:45 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFDB567373; Mon, 26 Jul 2021 10:19:42 +0200 (CEST)
Date: Mon, 26 Jul 2021 10:19:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 16/27] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210726081942.GD14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-17-hch@lst.de> <20210719170545.GF22402@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719170545.GF22402@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 19, 2021 at 10:05:45AM -0700, Darrick J. Wong wrote:
> >  	bno = 0;
> > -	ret = iomap_apply(inode, pos, blocksize, 0, ops, &bno,
> > -			  iomap_bmap_actor);
> > +	while ((ret = iomap_iter(&iter, ops)) > 0) {
> > +		if (iter.iomap.type != IOMAP_MAPPED)
> > +			continue;
> 
> There isn't a mapped extent, so return 0 here, right?

We can't just return 0, we always need the final iomap_iter() call
to clean up in case a ->iomap_end method is supplied.  No for bmap
having and needing one is rather theoretical, but people will copy
and paste that once we start breaking the rules.

