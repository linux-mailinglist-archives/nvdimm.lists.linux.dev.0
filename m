Return-Path: <nvdimm+bounces-865-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC973E9ED2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 12 Aug 2021 08:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0156C1C0F6A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 12 Aug 2021 06:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74602F80;
	Thu, 12 Aug 2021 06:49:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889372
	for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 06:49:24 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 39FE567373; Thu, 12 Aug 2021 08:49:15 +0200 (CEST)
Date: Thu, 12 Aug 2021 08:49:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210812064914.GA27145@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <20210811003118.GT3601466@magnolia> <20210811053856.GA1934@lst.de> <20210811191708.GF3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191708.GF3601443@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 11, 2021 at 12:17:08PM -0700, Darrick J. Wong wrote:
> > iter.c is also my preference, but in the end I don't care too much.
> 
> Ok.  My plan for this is to change this patch to add the new iter code
> to apply.c, and change patch 24 to remove iomap_apply.  I'll add a patch
> on the end to rename apply.c to iter.c, which will avoid breaking the
> history.

What history?  There is no shared code, so no shared history and.

> 
> I'll send the updated patches as replies to this series to avoid
> spamming the list, since I also have a patchset of bugfixes to send out
> and don't want to overwhelm everyone.

Just as a clear statement:  I think this dance is obsfucation and doesn't
help in any way.  But if that's what it takes..

