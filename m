Return-Path: <nvdimm+bounces-613-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C26AC3D5595
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 10:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 18E4A3E0FA4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jul 2021 08:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741942FB2;
	Mon, 26 Jul 2021 08:25:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB5670
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 08:25:41 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66F7767373; Mon, 26 Jul 2021 10:25:38 +0200 (CEST)
Date: Mon, 26 Jul 2021 10:25:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 20/27] fsdax: switch dax_iomap_rw to use iomap_iter
Message-ID: <20210726082538.GF14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-21-hch@lst.de> <20210719221005.GL664593@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719221005.GL664593@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 20, 2021 at 08:10:05AM +1000, Dave Chinner wrote:
> At first I wondered "iomi? Strange name, why is this one-off name
> used?" and then I realised it's because this function also takes an
> struct iov_iter named "iter".
> 
> That's going to cause confusion in the long run - iov_iter and
> iomap_iter both being generally named "iter", and then one or the
> other randomly changing when both are used in the same function.
> 
> Would it be better to avoid any possible confusion simply by using
> "iomi" for all iomap_iter variables throughout the patchset from the
> start? That way nobody is going to confuse iov_iter with iomap_iter
> iteration variables and code that uses both types will naturally
> have different, well known names...

Hmm.  iomi comes from the original patch from willy and I kinda hate
it.  But given that we have this clash here (and in the direct I/O code)
I kept using it.

Does anyone have any strong opinions here?

