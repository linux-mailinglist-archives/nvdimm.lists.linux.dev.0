Return-Path: <nvdimm+bounces-2381-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 5290B486379
	for <lists+linux-nvdimm@lfdr.de>; Thu,  6 Jan 2022 12:07:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 8A8D81C0B8E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  6 Jan 2022 11:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBE22CA5;
	Thu,  6 Jan 2022 11:07:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C8C168
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 11:07:19 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AYmzJM62YYsxXXLP6vfbD5bhwkn2cJEfYwER7XOP?=
 =?us-ascii?q?LsXnJ1m8g3zIFx2scC2yEOarYNzPxftEkat+//UgAvpDcxoI2QQE+nZ1PZygU8?=
 =?us-ascii?q?JKaX7x1DatR0xu6d5SFFAQ+hyknQoGowPscEzmM9n9BDpC79SMmjfjQGOKlYAL?=
 =?us-ascii?q?5EnsZqTFMGX5JZS1Ly7ZRbr5A2bBVMivV0T/Ai5S31GyNh1aYBlkpB5er83uDi?=
 =?us-ascii?q?hhdVAQw5TTSbdgT1LPXeuJ84Jg3fcldJFOgKmVY83LTegrN8F251juxExYFAdX?=
 =?us-ascii?q?jnKv5c1ERX/jZOg3mZnh+AvDk20Yd4HdplPtT2Pk0MC+7jx2Tgtl308QLu5qrV?=
 =?us-ascii?q?S8nI6/NhP8AFRJfFkmSOIUfoueffSfj4Zb7I0ruNiGEL+9VJE0/I4wU0uhtBmR?=
 =?us-ascii?q?J7/YZNHYGaRXrr+K9wJq6TOd2j8guJcWtO5kQ0llsxDefD7A5QJTHQqzP/vdZ2?=
 =?us-ascii?q?is9goZFGvO2T8Ybdj1pYzzDbgdJN1NRD4gx9M+sh3/iY3hdrXqWu6M84C7U1gM?=
 =?us-ascii?q?Z+L7zPNvQf/SORN5JhQCcp2Tb7yL1Dw9yHN6WzzfD+XKxrujVlCj/VcQZE7jQ3?=
 =?us-ascii?q?vprhkCDg2IIBBAIWF+Tv/a0kAi9VshZJkhS/TAhxYA29Uq2Xpz+Uge+rXqsoBE?=
 =?us-ascii?q?RQZxTHvc85QXLzbDbiy6dB24ZXntRZscOqsA7X3op20WPktevAiZg2IB541r1G?=
 =?us-ascii?q?qy89Gv0YHZKazRZI3JscOfM2PG7yKlbs/4FZo8L/HaJs+DI?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A5LJymaEMSmrMc5oMpLqE1MeALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKOHhom6mj+vxG88506faKslwssR0b+OxoW5PwJE80l6QFgrX5VI3KNGbbUQ?=
 =?us-ascii?q?CTXeNfBOXZowHIKmnX8+5x8eNaebFiNduYNzNHpPe/zA6mM9tI+rW6zJw=3D?=
X-IronPort-AV: E=Sophos;i="5.88,266,1635177600"; 
   d="scan'208";a="120047482"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Jan 2022 19:06:07 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 950D24D15A4E;
	Thu,  6 Jan 2022 19:06:04 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 6 Jan 2022 19:06:05 +0800
Received: from [192.168.22.28] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 6 Jan 2022 19:06:02 +0800
Message-ID: <0b765c02-942b-7e7a-63ca-5ee83b33991a@fujitsu.com>
Date: Thu, 6 Jan 2022 19:06:03 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 01/10] dax: Use percpu rwsem for
 dax_{read,write}_lock()
To: Dan Williams <dan.j.williams@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs
	<linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM
	<linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick
 J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, Christoph Hellwig
	<hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4gkxuFRGh57nYrpS8mXo+5j-7=KGNn-gULgLGthZQPo2g@mail.gmail.com>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <CAPcyv4gkxuFRGh57nYrpS8mXo+5j-7=KGNn-gULgLGthZQPo2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 950D24D15A4E.AF7EC
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/1/5 6:44, Dan Williams 写道:
> On Sun, Dec 26, 2021 at 6:35 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> In order to introduce dax holder registration, we need a write lock for
>> dax.
> 
> As far as I can see, no, a write lock is not needed while the holder
> is being registered.
> 
> The synchronization that is needed is to make sure that the device
> stays live over the registration event, and that any in-flight holder
> operations are flushed before the device transitions from live to
> dead, and that in turn relates to the live state of the pgmap.
> 
> The dax device cannot switch from live to dead without first flushing
> all readers, so holding dax_read_lock() over the register holder event
> should be sufficient. If you are worried about 2 or more potential
> holders colliding at registration time, I would expect that's already
> prevented by block device exclusive holder synchronization, but you
> could also use cmpxchg and a single pointer to a 'struct dax_holder {
> void *holder_data, struct dax_holder_operations *holder_ops }'. If you
> are worried about memory_failure triggering while the filesystem is
> shutting down it can do a synchronize_srcu(&dax_srcu) if it really
> needs to ensure that the notify path is idle after removing the holder
> registration.
> 
> ...are there any cases remaining not covered by the above suggestions?

OK, I think I didn't get what actual role does the dax lock play 
before...  So, the modification of the lock is unnecessary.  I'll take 
your two suggestions into consideration.


--
Thanks,
Ruan.



