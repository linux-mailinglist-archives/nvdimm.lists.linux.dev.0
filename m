Return-Path: <nvdimm+bounces-1339-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F07A40ED9A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Sep 2021 00:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 45F773E1095
	for <lists+linux-nvdimm@lfdr.de>; Thu, 16 Sep 2021 22:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0C93FFB;
	Thu, 16 Sep 2021 22:55:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A753FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 22:55:44 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 638966120D;
	Thu, 16 Sep 2021 22:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1631832944;
	bh=Qtgnrd0YPVAr2zlL6IUZFeYfRseNXkgr+H5O7DMcsvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IruaNQLOcPcBjEa1TTQJ1qU1CKtSO+cLnFJOEWnfVAsTMmnrz/FK8k8v92oRSqecJ
	 xj9sH4laL059Kl7hPi/wRY3YaJBng+9mm8xH3l4DPbMbkc0vJTrx3b7jeEYhrMA41X
	 3bSgNzpaaAL30E3pQxyjQNMr4SAUzAvXDD+VLrhHOgEy3/Eyfuw8eW7bL5AKviBcKC
	 Z5jehyPhGtV9cDX0MhL56mMHpKeWxywJz2IvIrLavQvWyZ97JzmmvdcE/9uxy5rvOA
	 mxBZp8Of4szPkZX4+d85TuxzX9JRr9r+OE0AX/6HxezW4w2jupW0xML+oDJtPg51L2
	 rTBZreAOWoh9g==
Date: Thu, 16 Sep 2021 15:55:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH v9 5/8] fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
Message-ID: <20210916225544.GF34830@magnolia>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com>
 <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
 <20210916061654.GB13306@lst.de>
 <9fb0c82f-b2ae-82e3-62df-f0a473ed6395@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fb0c82f-b2ae-82e3-62df-f0a473ed6395@fujitsu.com>

On Thu, Sep 16, 2021 at 04:49:19PM +0800, Shiyang Ruan wrote:
> 
> 
> On 2021/9/16 14:16, Christoph Hellwig wrote:
> > On Wed, Sep 15, 2021 at 06:44:58PM +0800, Shiyang Ruan wrote:
> > > +	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
> > > +	if (rc < 0)
> > > +		goto out;
> > > +	memset(kaddr + offset, 0, size);
> > > +	if (srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {
> > 
> > Should we also check that ->dax_dev for iomap and srcmap are different
> > first to deal with case of file system with multiple devices?
> 
> I have not thought of this case.  Isn't it possible to CoW between different
> devices?

There's nothing in the iomap API that prevents a filesystem from doing
that, though there are no filesystems today that do such a thing.

That said, if btrfs ever joins the fold (and adds DAX support) then they
could totally COW to a different device.

--D

> 
> 
> --
> Thanks,
> Ruan
> 
> > 
> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> 

