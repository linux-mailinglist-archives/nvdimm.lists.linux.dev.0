Return-Path: <nvdimm+bounces-1814-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F7244588F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 18:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 227DD3E108F
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Nov 2021 17:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142092C9A;
	Thu,  4 Nov 2021 17:36:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134F2C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:36:02 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACAA76732D; Thu,  4 Nov 2021 18:35:59 +0100 (CET)
Date: Thu, 4 Nov 2021 18:35:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@sandeen.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: futher decouple DAX from block devices
Message-ID: <20211104173559.GB31740@lst.de>
References: <20211018044054.1779424-1-hch@lst.de> <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net> <20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104173417.GJ2237511@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 04, 2021 at 10:34:17AM -0700, Darrick J. Wong wrote:
> /me wonders, are block devices going away?  Will mkfs.xfs have to learn
> how to talk to certain chardevs?  I guess jffs2 and others already do
> that kind of thing... but I suppose I can wait for the real draft to
> show up to ramble further. ;)

Right now I've mostly been looking into the kernel side.  An no, I
do not expect /dev/pmem* to go away as you'll still need it for a
not DAX aware file system and/or application (such as mkfs initially).

But yes, just pointing mkfs to the chardev should be doable with very
little work.  We can point it to a regular file after all.

