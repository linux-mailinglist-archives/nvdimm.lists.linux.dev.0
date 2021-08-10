Return-Path: <nvdimm+bounces-617-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6252B3D6F80
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jul 2021 08:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 7F3C71C095C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jul 2021 06:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501652F80;
	Tue, 27 Jul 2021 06:31:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D10872
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 06:31:42 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0300B67373; Tue, 27 Jul 2021 08:31:39 +0200 (CEST)
Date: Tue, 27 Jul 2021 08:31:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 16/27] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210727063138.GA10143@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-17-hch@lst.de> <20210719170545.GF22402@magnolia> <20210726081942.GD14853@lst.de> <20210726163922.GA559142@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726163922.GA559142@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 26, 2021 at 09:39:22AM -0700, Darrick J. Wong wrote:
> The documentation needs to be much more explicit about the fact that you
> cannot "break;" your way out of an iomap_iter loop.  I think the comment
> should be rewritten along these lines:
> 
> "Iterate over filesystem-provided space mappings for the provided file
> range.  This function handles cleanup of resources acquired for
> iteration when the filesystem indicates there are no more space
> mappings, which means that this function must be called in a loop that
> continues as long it returns a positive value.  If 0 or a negative value
> is returned, the caller must not return to the loop body.  Within a loop
> body, there are two ways to break out of the loop body: leave
> @iter.processed unchanged, or set it to the usual negative errno."
> 
> Hm.

Yes, I'll update the documentation.

> Clunky, for sure, but at least we still get to use break as the language
> designers intended.

I can't see any advantage there over just proper documentation.  If you
are totally attached to a working break we might have to come up with
a nasty for_each macro that ensures we have a final iomap_apply, but I
doubt it is worth the effort.

