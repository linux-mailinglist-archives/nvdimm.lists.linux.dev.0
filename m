Return-Path: <nvdimm+bounces-1989-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id A11BD456A86
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Nov 2021 07:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id EBF1C3E1055
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Nov 2021 06:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260032C87;
	Fri, 19 Nov 2021 06:56:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8548768
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 06:56:49 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id F18E168AFE; Fri, 19 Nov 2021 07:56:45 +0100 (CET)
Date: Fri, 19 Nov 2021 07:56:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 01/29] nvdimm/pmem: move dax_attribute_group from dax
 to pmem
Message-ID: <20211119065645.GB15524@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-2-hch@lst.de> <CAPcyv4ijKTcABMs2tZEuPWo1WDOux+4XWN=DNF5v8SrQRSbfDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ijKTcABMs2tZEuPWo1WDOux+4XWN=DNF5v8SrQRSbfDg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 17, 2021 at 09:44:25AM -0800, Dan Williams wrote:
> On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > dax_attribute_group is only used by the pmem driver, and can avoid the
> > completely pointless lookup by the disk name if moved there.  This
> > leaves just a single caller of dax_get_by_host, so move dax_get_by_host
> > into the same ifdef block as that caller.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Link: https://lore.kernel.org/r/20210922173431.2454024-3-hch@lst.de
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> This one already made v5.16-rc1.

Yes, but 5.16-rc1 did not exist yet when I pointed the series.

Note that the series also has a conflict against 5.16-rc1 in pmem.c,
and buildbot pointed out the file systems need explicit dax.h
includes in a few files for some configurations.

The current branch is here, I just did not bother to repost without
any comments:

   http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-block-cleanup

no functional changes.

