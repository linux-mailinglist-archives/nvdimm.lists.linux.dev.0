Return-Path: <nvdimm+bounces-598-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0E73D1991
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jul 2021 00:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 3D5613E104A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 21 Jul 2021 22:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA2B2FB6;
	Wed, 21 Jul 2021 22:08:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA15D70
	for <nvdimm@lists.linux.dev>; Wed, 21 Jul 2021 22:08:51 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 53AC920B7178; Wed, 21 Jul 2021 15:08:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 53AC920B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1626905331;
	bh=8OseoXILN4vqLqt6LUZc31dEZZN6YDFZTDi1RrRQrRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MR4eLP/K1Gt3KvhTJ5ZI/hWRufLYQpUa7GXhHrHr7cqiVDubimuESO40yCvIYO6mx
	 fpn59lEm+GT3Cg1v88yff5tlNaSFIDaACjwA3SDHOVoZDhBEJKVsUBQQOnrLOlzfBD
	 lfchgpO9Y/J4GMIyfCj+TA9SZR/HjHl4KihNGMAw=
Date: Wed, 21 Jul 2021 15:08:51 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: Pankaj Gupta <pankaj.gupta@ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, apais@microsoft.com, tyhicks@microsoft.com,
	jamorris@microsoft.com, benhill@microsoft.com,
	sunilmut@microsoft.com, grahamwo@microsoft.com,
	tstark@microsoft.com, "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
 <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 20, 2021 at 08:51:04AM +0200, Pankaj Gupta wrote:
> > > >
> > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > -                       start, &vpmem->start);
> > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > -                       size, &vpmem->size);
> > > > +       /* Retrieve the pmem device's address and size. It may have been supplied
> > > > +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > > > +        */
> > > > +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > > > +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> > >
> > > Current implementation of Virtio pmem device in Qemu does not expose
> > > it as PCI BAR.
> > > So, can't test it. Just curious if device side implementation is also
> > > tested for asynchronous
> > > flush case?
> > >
> > > Thanks,
> > > Pankaj
> >
> > Yes, I tested the async flush case as well. We basically call
> > FlushFileBuffers on the backing file, which is Windows' equivalent of
> > fsync. I also briefly tested with qemu to ensure that still works with
> > the patch.
> 
> Thank you for the confirmation. This sounds really good.
> I am also getting back to pending items for virtio-pmem.
> 
> On a side question: Do you guys have any or plan for Windows guest
> implementation
> for virtio-pmem?

Unfortunately, my team doesn't currently have any plans to add a Windows
virtio-pmem implementation. My team is primarily focused on virtualization
in client environments, which is a little different than server environments.
For our Windows-based scenarios, dynamically sized disks are important. It's
tricky to get that to work with pmem+DAX given that Windows isn't state separated.


