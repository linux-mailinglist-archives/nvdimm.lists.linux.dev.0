Return-Path: <nvdimm+bounces-3375-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 9008E4E4C69
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Mar 2022 06:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A49881C0BB1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Mar 2022 05:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F6E136F;
	Wed, 23 Mar 2022 05:46:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD41360
	for <nvdimm@lists.linux.dev>; Wed, 23 Mar 2022 05:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7ZAsD6U+OpZrl9q+vvF5BO0Ld/peFEuasZX9wg8w/7c=; b=nlGt60I9cy8CABM8dFM997RIev
	lf+Vu/g9DqcVUJgBuwjYjHU9jOV3QQCh4gomYHEWmUbee1hju7Vb6RO0DEA9S5CmbmQe/zXKweFXn
	8EVK7EgUoutyRvQb8bI9IhY1/UZJtuu/qqg9kSmpHJ1YGuAsMtO/ZauNT7m3eiq2M7Urm1DDCQ6cy
	u9yF+0Tbj77cKFKrTYwHSOfN80W+1eYN9ITP5OdtfmjQfHxk1qXo0WX7STlhFRN4cS2UgCMWDrFen
	cyC6TLzVbiAgxvrwxolPd8ULMLpgLYxqVhw8SAFfUge+NFNrjR50q2wFlEV6DOACqQ0c/5lF0epQv
	0VigWM/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWtok-00CoLR-Fp; Wed, 23 Mar 2022 05:45:58 +0000
Date: Tue, 22 Mar 2022 22:45:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
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
Subject: Re: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Message-ID: <Yjq0FspfsLrN/mrx@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
 <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 22, 2022 at 11:05:09PM +0000, Jane Chu wrote:
> > This DAX_RECOVERY doesn't actually seem to be used anywhere here or
> > in the subsequent patches.  Did I miss something?
> 
> dax_iomap_iter() uses the flag in the same patch,
> +               if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
> +                       flags |= DAX_RECOVERY;
> +                       map_len = dax_direct_access(dax_dev, pgoff, nrpg,
> +                                               flags, &kaddr, NULL);

Yes, it passes it on to dax_direct_access, and dax_direct_access passes
it onto ->direct_access.  But nothing in this series actually checks
for it as far as I can tell.

> >> Also introduce a new dev_pagemap_ops .recovery_write function.
> >> The function is applicable to FSDAX device only. The device
> >> page backend driver provides .recovery_write function if the
> >> device has underlying mechanism to clear the uncorrectable
> >> errors on the fly.
> > 
> > Why is this not in struct dax_operations?
> 
> Per Dan's comments to the v5 series, adding .recovery_write to
> dax_operations causes a number of trivial dm targets changes.
> Dan suggested that adding .recovery_write to pagemap_ops could
> cut short the logistics of figuring out whether the driver backing
> up a page is indeed capable of clearing poison. Please see
> https://lkml.org/lkml/2022/2/4/31

But at least in this series there is  1:1 association between the
pgmap and the dax_device so that scheme won't work.   It would
have to lookup the pgmap based on the return physical address from
dax_direct_access.  Which sounds more complicated than just adding
the (annoying) boilerplate code to DM.

> include/linux/memremap.h doesn't know struct iov_iter which is defined 
> in include/linux/uio.h,  would you prefer to adding include/linux/uio.h 
> to include/linux/memremap.h ?

As it is not derefences just adding a

struct iov_iter;

line to memremap.h below the includes should be all that is needed.

