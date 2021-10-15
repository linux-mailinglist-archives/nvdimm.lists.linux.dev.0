Return-Path: <nvdimm+bounces-1569-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3170942E900
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Oct 2021 08:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 28BFF1C0F29
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Oct 2021 06:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15F32C85;
	Fri, 15 Oct 2021 06:30:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3432C83
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 06:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nv5FQ/6vTqDP+uvH/XRZgii5X0jrEJS0CQSXWJp5LYY=; b=AgLYGCmRq2PJF2LjCKSd3i9+8e
	dHwI13PRvpN84mnLWiuxm2DChcEhVcL2j5+G1MpSJir3s0No/Qfr1Rc8t6UEqhTNN8Yl8OhMq9idC
	OUkFJTOu8aJEH16iajD3jt8dTV51n6PDAj57s5WW6B+W+QaO8+c+gGeHVuwm4Lmk/DSqA7AEi81Cl
	UncMAun5PjoNTSZUZzmqUtS8j8fowmcifrwLlRcsWWfNhYX+YuGfzYVV+e/Kri4YxoQewkvDHMDGv
	Lm0Hnnnj3TVXzQyCyBTnNCY6cTlzXqxT1AGI3g+zWo6TmUYKE045vQecRQ5rjR3xUGmEWkdrRSJfn
	tAXfOAvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbGjD-005WWo-Bs; Fri, 15 Oct 2021 06:30:03 +0000
Date: Thu, 14 Oct 2021 23:30:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v7 1/8] dax: Use rwsem for dax_{read,write}_lock()
Message-ID: <YWkf63g44Puobxrp@infradead.org>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
 <20210924130959.2695749-2-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924130959.2695749-2-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 24, 2021 at 09:09:52PM +0800, Shiyang Ruan wrote:
> In order to introduce dax holder registration, we need a write lock for
> dax.  Because of the rarity of notification failures and the infrequency
> of registration events, it would be better to be a global lock rather
> than per-device.  So, change the current lock to rwsem and introduce a
> write lock for registration.

I don't think taking the rw_semaphore everywhere will scale, as
basically any DAX based I/O will take it (in read mode).

So at a minimum we'd need a per-device percpu_rw_semaphore if we want
to go there.

