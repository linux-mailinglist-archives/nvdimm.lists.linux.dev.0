Return-Path: <nvdimm+bounces-870-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id CD62B3EB182
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Aug 2021 09:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id AE63B1C0FA1
	for <lists+linux-nvdimm@lfdr.de>; Fri, 13 Aug 2021 07:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11A66D24;
	Fri, 13 Aug 2021 07:30:06 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2E72
	for <nvdimm@lists.linux.dev>; Fri, 13 Aug 2021 07:30:04 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 958DD6736F; Fri, 13 Aug 2021 09:29:55 +0200 (CEST)
Date: Fri, 13 Aug 2021 09:29:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210813072955.GA27278@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <20210811003118.GT3601466@magnolia> <20210811053856.GA1934@lst.de> <20210811191708.GF3601443@magnolia> <20210812064914.GA27145@lst.de> <20210812182017.GX3601466@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812182017.GX3601466@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 12, 2021 at 11:20:17AM -0700, Darrick J. Wong wrote:
> The history of the gluecode that enables us to walk a bunch of extent
> mappings.  In the beginning it was the _apply function, but now in our
> spectre-weary world, you've switched it to a direct loop to reduce the
> number of indirect calls in the hot path by 30-50%.
> 
> As you correctly point out, there's no /code/ shared by the two
> implementations, but Dave and I would like to preserve the continuity
> from one to the next.
> 
> > > I'll send the updated patches as replies to this series to avoid
> > > spamming the list, since I also have a patchset of bugfixes to send out
> > > and don't want to overwhelm everyone.
> > 
> > Just as a clear statement:  I think this dance is obsfucation and doesn't
> > help in any way.  But if that's what it takes..
> 
> I /would/ appreciate it if you'd rvb (or at least ack) patch 31 so I can
> get the 5.15 iomap changes finalized next week.  Pretty please? :)

I think it is a really stupid idea, so certainly no rvb or ack from me.
If you feel you want to do it this way go ahead, but I do not in any
way approve of it.

