Return-Path: <nvdimm+bounces-2008-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B357B459C00
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 06:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 6273F3E0F54
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Nov 2021 05:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29232C98;
	Tue, 23 Nov 2021 05:56:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643EA68
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 05:56:26 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97B5168AFE; Tue, 23 Nov 2021 06:56:16 +0100 (CET)
Date: Tue, 23 Nov 2021 06:56:16 +0100
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
Subject: Re: [PATCH 02/29] dm: make the DAX support dependend on
 CONFIG_FS_DAX
Message-ID: <20211123055616.GA13711@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de> <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com> <20211119065457.GA15524@lst.de> <CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 22, 2021 at 06:54:09PM -0800, Dan Williams wrote:
> On Thu, Nov 18, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Wed, Nov 17, 2021 at 09:23:44AM -0800, Dan Williams wrote:
> > > Applied, fixed the spelling of 'dependent' in the subject and picked
> > > up Mike's Ack from the previous send:
> > >
> > > https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com
> > >
> > > Christoph, any particular reason you did not pick up the tags from the
> > > last posting?
> >
> > I thought I did, but apparently I've missed some.
> 
> I'll reply with the ones I see missing that need carrying over and add
> my own reviewed-by then you can send me a pull request when ready,
> deal?

Ok.

