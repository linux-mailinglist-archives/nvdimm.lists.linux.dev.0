Return-Path: <nvdimm+bounces-2506-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBDC4949C6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 09:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A47001C068B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 08:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B1C2CAC;
	Thu, 20 Jan 2022 08:46:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F49C2CA7
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 08:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fc144p+00WPTTP0zDhiznn2Saihska6K3bXQ86DJDN8=; b=zvTVKUKQd9PEBeP/epohTKoS+l
	or0ElzDA6K1hJ+W7u12fMmcQpP7gHqMjL3UzuuGFGloW2ww1X/tKQiBNw7gj+Fj7abYWevriIOS6H
	1GzCib8DXwF5Hr1I6wLxqUm6hPlDb58oR7iQ5ohv5nmbRvA7GXelUVCdaF4HjMlyS7E+/ZxcG9XH0
	09qYIkZ//VSEouo9f4Uy3qffJOfHEiW1mS8AfmNQpZTvyqZPB4iNotwURjoiG8xOk9mM4ndDLy1sp
	z3qtmtboIzdqQc863Ssh+x57Dn1FKDdh26S8CkLMnfMD5neyvmq3y7BR5cJwcJb9R0BU973hNaXU2
	r6+tKmWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nAT5I-009tD3-5C; Thu, 20 Jan 2022 08:46:20 +0000
Date: Thu, 20 Jan 2022 00:46:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
Message-ID: <YekhXENAEYJJNy7e@infradead.org>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-3-ruansy.fnst@fujitsu.com>
 <20220105181230.GC398655@magnolia>
 <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com>
 <20220105185626.GE398655@magnolia>
 <CAPcyv4h3M9f1-C5e9kHTfPaRYR_zN4gzQWgR+ZyhNmG_SL-u+A@mail.gmail.com>
 <20220105224727.GG398655@magnolia>
 <CAPcyv4iZ88FPeZC1rt_bNdWHDZ5oh7ua31NuET2-oZ1UcMrH2Q@mail.gmail.com>
 <20220105235407.GN656707@magnolia>
 <CAPcyv4gUmpDnGkhd+WdhcJVMP07u+CT8NXRjzcOTp5KF-5Yo5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gUmpDnGkhd+WdhcJVMP07u+CT8NXRjzcOTp5KF-5Yo5g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 05, 2022 at 04:12:04PM -0800, Dan Williams wrote:
> We ended up with explicit callbacks after hch balked at a notifier
> call-chain, but I think we're back to that now. The partition mistake
> might be unfixable, but at least bdev_dax_pgoff() is dead. Notifier
> call chains have their own locking so, Ruan, this still does not need
> to touch dax_read_lock().

I think we have a few options here:

 (1) don't allow error notifications on partitions.  And error return from
     the holder registration with proper error handling in the file
     system would give us that
 (2) extent the holder mechanism to cover a range
 (3) bite the bullet and create a new stacked dax_device for each
     partition

I think (1) is the best option for now.  If people really do need
partitions we'll have to go for (3)

