Return-Path: <nvdimm+bounces-2263-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E89047440B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Dec 2021 14:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id B01F43E0E4A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Dec 2021 13:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CBF42CA9;
	Tue, 14 Dec 2021 13:59:08 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158329CA
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639490345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m/5pRcl9h3yj8MAkqvRPCHvPcL0c1vkmrKvq7UUnKBk=;
	b=UzRdxE/mQTqhVgFF+18bIUa2Tn92UKJxfy17YFX3FmarrZuOVDsoyISMWw4MFQpBWRe4EI
	+LrPqx9CtcLCnsu8CxCKZcTnRW3oviixIMI+HvwRlyPS7C7JtBSU4sfTwNVILPe/IqXSqm
	4L11ggliQUMqUeeFcI4ym2sO6+YPmNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-0kDh8FCsOqi2t6NYQJXz-g-1; Tue, 14 Dec 2021 08:59:04 -0500
X-MC-Unique: 0kDh8FCsOqi2t6NYQJXz-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA20F1966320;
	Tue, 14 Dec 2021 13:59:01 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.33.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25B375BE02;
	Tue, 14 Dec 2021 13:59:01 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id A5F242233DF; Tue, 14 Dec 2021 08:59:00 -0500 (EST)
Date: Tue, 14 Dec 2021 08:59:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] dax: always use _copy_mc_to_iter in dax_copy_to_iter
Message-ID: <YbijJOjhLAwvyNag@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
 <20211209063828.18944-6-hch@lst.de>
 <YbNejVRF5NQB0r83@redhat.com>
 <CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

On Sun, Dec 12, 2021 at 06:48:05AM -0800, Dan Williams wrote:
> On Fri, Dec 10, 2021 at 6:05 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> > > While using the MC-safe copy routines is rather pointless on a virtual device
> > > like virtiofs,
> >
> > I was wondering about that. Is it completely pointless.
> >
> > Typically we are just mapping host page cache into qemu address space.
> > That shows as virtiofs device pfn in guest and that pfn is mapped into
> > guest application address space in mmap() call.
> >
> > Given on host its DRAM, so I would not expect machine check on load side
> > so there was no need to use machine check safe variant.
> 
> That's a broken assumption, DRAM experiences multi-bit ECC errors.
> Machine checks, data aborts, etc existed before PMEM.

So we should use MC safe variant when loading from DRAM as well?
(If needed platoform support is there).

Vivek


