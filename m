Return-Path: <nvdimm+bounces-1800-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E95BF44501B
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 09:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 65EBE3E1010
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 08:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772C82C9D;
	Thu,  4 Nov 2021 08:22:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF992C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NUHSkPZKdCeYjtK4gysRgJLuWX7RQNT/5Sx0eDpMchA=; b=4xLVQ8osQ9u7MwgQvsr3sqrJeD
	9TeLt91+NwT0iLut4BXjRJBcxw0lMeMSqiRjYh4XgkE1PQrRNl08jVT9JyFpmlQhBpgZwpNzC7xMI
	hiC6iZUM3mkSSQST7ZxjYHy/5jXDxo6QvvmqFEvKsvTfyAex0tERVVtpRaOXUU61g/oG5RkjZoFeB
	TZrKDRAjsajsqkt0olW0LX+JQ39We/7NFqZyULyX2fndDMXdWifE2lk1vC5WUjxhfmhGKc/1zjGn3
	QYyApkpEieQ+jUMzVI3qcKfDa/jRt9Z2WGjepJzjmpfamFUU+6n6un4hPFOb/Yv5OXa76e+SB76Db
	LPxk7IwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1miY00-008HaJ-Ih; Thu, 04 Nov 2021 08:21:28 +0000
Date: Thu, 4 Nov 2021 01:21:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YYOYCMqc5kOoRvcE@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 03, 2021 at 06:09:57PM +0000, Jane Chu wrote:
> This is clearer, I've looked at your 'dax-devirtualize' patch which 
> removes pmem_copy_to/from_iter, and as you mentioned before,
> a separate API for poison-clearing is needed. So how about I go ahead
> rebase my earlier patch
>  
> https://lore.kernel.org/lkml/20210914233132.3680546-2-jane.chu@oracle.com/
> on 'dax-devirtualize', provide dm support for clear-poison?
> That way, the non-dax 99% of the pwrite use-cases aren't impacted at all
> and we resolve the urgent pmem poison-clearing issue?

FYI, I really do like the in-kernel interface in that series.  And
now that we discussed all the effects I also think that automatically
doing the clear on EIO is a good idea.

I'll go back to the series and will reply with a few nitpicks.

