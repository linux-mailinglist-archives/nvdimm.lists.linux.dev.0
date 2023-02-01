Return-Path: <nvdimm+bounces-5678-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDAEB67C793
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Jan 2023 10:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5718C1C208D2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 26 Jan 2023 09:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F343F1FCF;
	Thu, 26 Jan 2023 09:39:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4E1FAC;
	Thu, 26 Jan 2023 09:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1DBC433D2;
	Thu, 26 Jan 2023 09:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674725962;
	bh=ZVfkZK/3rtmQ0HI/dGtBJXuuEqesnN3UrC2d9Id/22U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jPHR1tsysvXfEcAXi3dVKJzUK+/pBcLMN81V0rrV3lmJSitmZ4dzX2dg51hi5IejN
	 7zEL7Xap67RZv3VIzSlaiGiUZdkRohbmuBt6g1G6k/ZDi5w4ErbGUQzamGymp/2NAN
	 /pJpCqLuAJbsS7TQBPReskyZpzFgV+3QY8OuQL/WhZVfC+T0+8u9vOvjEiG2Oyz3az
	 QJ0nBWa4aWc9iOXY1sXphvYX2+rpFeNABo5LS/x4hv9HRfZpwHSA0CMCq+G8UuXlKn
	 +pNbjyotsjQUd9+f7lksSfZ3pI2eP1YfAMNkOmd6YHDneNBbuqYHPRthY6aI1BzTUE
	 4YD93KKDkzx3g==
Date: Thu, 26 Jan 2023 11:39:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev, Shakeel Butt <shakeelb@google.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y9JKO7FITJQ7dxAv@kernel.org>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <Y84OyQSKHelPOkW3@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y84OyQSKHelPOkW3@casper.infradead.org>

On Mon, Jan 23, 2023 at 04:36:25AM +0000, Matthew Wilcox wrote:
> On Sat, Jan 21, 2023 at 11:03:05AM -0400, Jason Gunthorpe wrote:
> > I would like to have a session at LSF to talk about Matthew's
> > physr discussion starter:
> > 
> >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> 
> I'm definitely interested in discussing phyrs (even if you'd rather
> pronounce it "fizzers" than "fires" ;-)

I'm also interested in this discussion. With my accent it will be фыр,
though ;-)
 
> > I've been working on an implementation and hope to have something
> > draft to show on the lists in a few weeks. It is pretty clear there
> > are several interesting decisions to make that I think will benefit
> > from a live discussion.
> 
> Cool!  Here's my latest noodlings:
> https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/phyr
> 
> Just the top two commits; the other stuff is unrelated.  Shakeel has
> also been interested in this.
> 
> 

