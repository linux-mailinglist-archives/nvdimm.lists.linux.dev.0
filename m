Return-Path: <nvdimm+bounces-2508-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A2E4949DF
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 09:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 611203E0EB9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 08:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC692CAC;
	Thu, 20 Jan 2022 08:47:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6CE2CA7
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 08:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fNusMrWQ+iaAxCx5W24yZJ93BWZfAuFDm6S8/KGzbK0=; b=D39kfHS+T/0kWsqL02joFtiv09
	ubeTypbD4543NiZpFkfezmtBZWQPlrZpYwm/nLxZD9YK8pWH41dX2UJdscRc7NmMJvro+lxKIaBId
	K7jnSerZ73JAr+mJgGNAbVwjVHOW9sFo2xVDGlluJ5YFRPbCzMgZWrwNKA1PwHpa3SU0W6DbeyEZM
	8Jhb0XYD0mJ+HB19llClYpTW+tEqw/tkvKNOsFZfQsn8N3aCVrg/s/BVVvN1k/LtRGQa2vqe92Uv8
	WYO1RKbzkm+czYu/+x0/YVypor1v53PG6zh7AENpjveWc5STtRuijyEz/bq9rbZuNmyIZsgE89SL4
	P4DvTPTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nAT6S-009tud-Lg; Thu, 20 Jan 2022 08:47:32 +0000
Date: Thu, 20 Jan 2022 00:47:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v9 07/10] mm: move pgoff_address() to vma_pgoff_address()
Message-ID: <YekhpF0VS+OA4Yud@infradead.org>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-8-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226143439.3985960-8-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 26, 2021 at 10:34:36PM +0800, Shiyang Ruan wrote:
> Since it is not a DAX-specific function, move it into mm and rename it
> to be a generic helper.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

