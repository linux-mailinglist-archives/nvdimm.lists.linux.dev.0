Return-Path: <nvdimm+bounces-2288-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB36476B25
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Dec 2021 08:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 522451C0A20
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Dec 2021 07:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3F42CA7;
	Thu, 16 Dec 2021 07:46:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BA168
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 07:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=/KAkd7ayUP/AjC9UKcxkNCC72YBc5E46xyfAFBsG3Kc=; b=cRRVbigsH/pXmcZncjRPpkoNw7
	iGkWGZMDkG8n4ABIh6CyZadqnPfVHz07VFFy2U7nKJmcK6yoU3llI51NTXnqEHj6sS3YoYJFvey72
	OGTESfvUTllzClgAbjF4tOV03NkTVCyBYsG4SyeWLhYKO5DypgApwuXgq5vDfaXUoDnkwS9QemGeS
	wII7rRfJSeJ7wuRDa6e/Sp4X+zllP4ZUWi8UxFn9QpBKl904UjObggEC2KCYENPHsfsKvt/Kz+XXF
	AcKNdmCagQbpXHZtg7NVu3q9J1hS9aQyHTZkHu6Ge4WQ12S5ky7XbTtI4VyyipzREqe7zLMaC3ltV
	0aVQWvTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mxlSn-0040NQ-W8; Thu, 16 Dec 2021 07:46:05 +0000
Date: Wed, 15 Dec 2021 23:46:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, dan.j.williams@intel.com, david@fromorbit.com,
	jane.chu@oracle.com
Subject: Re: [PATCH v8 1/9] dax: Use percpu rwsem for dax_{read,write}_lock()
Message-ID: <YbruvTOVwwRhRLU8@infradead.org>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
 <20211202084856.1285285-2-ruansy.fnst@fujitsu.com>
 <Ybi69MCK5sP4ebwG@infradead.org>
 <bc5743cb-f79e-2f67-d594-85b56f05bda3@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc5743cb-f79e-2f67-d594-85b56f05bda3@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 15, 2021 at 10:06:29AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2021/12/14 23:40, Christoph Hellwig 写道:
> > On Thu, Dec 02, 2021 at 04:48:48PM +0800, Shiyang Ruan wrote:
> > > In order to introduce dax holder registration, we need a write lock for
> > > dax.  Change the current lock to percpu_rw_semaphore and introduce a
> > > write lock for registration.
> > 
> > Why do we need to change the existing, global locking for that?
> 
> I think we have talked about this in the previous v7 patchset:
> 
> 
> https://lore.kernel.org/nvdimm/20210924130959.2695749-1-ruansy.fnst@fujitsu.com/T/#m4031bc3dc49dcbaac6f8d99877f910fa9a6f998a

Any kind of rationale needs to go into the patch description.

> I didn't test in benchmarks for now.  Could you show me which one I should
> test this code on?  I am not familiar with this...

Just normal read/write I/O on a DAX device.

