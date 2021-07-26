Return-Path: <nvdimm+bounces-610-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E48F13D5532
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 10:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 197EA3E0F60
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 08:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3BA2FB2;
	Mon, 26 Jul 2021 08:17:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1548F70
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 08:17:34 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id EC92468AFE; Mon, 26 Jul 2021 10:17:30 +0200 (CEST)
Date: Mon, 26 Jul 2021 10:17:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 08/27] iomap: add the new iomap_iter model
Message-ID: <20210726081730.GC14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-9-hch@lst.de> <20210719214838.GK664593@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719214838.GK664593@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 20, 2021 at 07:48:38AM +1000, Dave Chinner wrote:
> We should avoid namespace conflicts where function names shadow
> object types. iomap_iterate() is fine as the function name - there's
> no need for abbreviation here because it's not an overly long name.
> This will makes it clearly different to the struct iomap_iter that
> is passed to it and it will also make grep, cscope and other
> code searching tools much more precise...

Well, there isn't really a conflict by definition.  I actually like
this choice of names (stolen from the original patch from willy)
as it clearly indicates they go together.

But I'm happy to collect a few more opinions.

