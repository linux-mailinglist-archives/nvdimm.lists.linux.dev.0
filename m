Return-Path: <nvdimm+bounces-1636-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA8B432F4A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Oct 2021 09:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 6D6611C0DD5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Oct 2021 07:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CE82C8B;
	Tue, 19 Oct 2021 07:23:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F772
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 07:23:37 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6E1568BFE; Tue, 19 Oct 2021 09:23:26 +0200 (CEST)
Date: Tue, 19 Oct 2021 09:23:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, no@lst.de, To-header@lst.de, on@lst.de,
	"input <"@lst.de;, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/11] xfs: factor out a xfs_setup_dax helper
Message-ID: <20211019072326.GA23171@lst.de>
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-7-hch@lst.de> <20211018164351.GT24307@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018164351.GT24307@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 18, 2021 at 09:43:51AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -339,6 +339,32 @@ xfs_buftarg_is_dax(
> >  			bdev_nr_sectors(bt->bt_bdev));
> >  }
> >  
> > +static int
> > +xfs_setup_dax(
> 
> /me wonders if this should be named xfs_setup_dax_always, since this
> doesn't handle the dax=inode mode?

Sure, why not.

> The only reason I bring that up is that Eric reminded me a while ago
> that we don't actually print any kind of EXPERIMENTAL warning for the
> auto-detection behavior.

Yes, I actually noticed that as well when preparing this series.

