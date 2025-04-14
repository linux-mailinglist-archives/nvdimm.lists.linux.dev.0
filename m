Return-Path: <nvdimm+bounces-10208-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D70CBA8755E
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Apr 2025 03:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D219116F82B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Apr 2025 01:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0506B2B9CF;
	Mon, 14 Apr 2025 01:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UDMZP1m1"
X-Original-To: nvdimm@lists.linux.dev
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5CD7DA82
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595124; cv=none; b=nvAY222HXCe5rKVcGbTGfXVsA07Fi+Cr1A3wGAFf+d7Evk8GsobNY2R+YTVMW4Y53CyjNmNGPykqM3k5GS2xFhjkSLJZT8Nsq7mwaOeV/zAP8K9XW/WeFXhjB67acUR04e2V6tnW48ZhXAxZKl7hcedyL1q92KC8JVkcIPrkJm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595124; c=relaxed/simple;
	bh=VDotD7oSieRhWwt3FOJbrqG71tCS1rEtkkGWAJQolBU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=A7wYKT0VW+Wb6cpeg2adcJsjpOzUb3UodKLKihFdRrV6/1Lgtg3JaIY9ee7TWFos+SInWr6dC35HI7LZMEGLl3VCYr20EzLkqJ2GgglUw9Su5e5lkeFRmZe9VdwFfcWR0GjRlpGlSPpjOvfcLr0vO+ddnjWwI4XkUbvk0nd9ljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UDMZP1m1; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WN8BMkg2EfJd25dvCHhmAO8SWHxStxQWrlaYsrb/zVg=;
	b=UDMZP1m15JLJ325YbSLgvsNJmmIJmWrgryBWzUGVYnp9qtAmf209U3nRjJBa/gwalcjVT/
	WRDLS6HyP2VMZWpl4udBq192pdEeAzY1zygvzeRcLu9hXcw5Nhlgxx5gxLLMYT4M1te399
	AKGga+oXa7LWVmcsx6+jlqZF6wdZ29w=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	gregory.price@memverge.com,
	John@groves.net,
	Jonathan.Cameron@Huawei.com,
	bbhushan2@marvell.com,
	chaitanyak@nvidia.com,
	rdunlap@infradead.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block Devices
Date: Mon, 14 Apr 2025 01:44:54 +0000
Message-Id: <20250414014505.20477-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi All,

    This patchset introduces a new Linux block layer module called
**pcache**, which uses persistent memory (pmem) as a cache for block
devices.

Originally, this functionality was implemented as `cbd_cache` within the
CBD (CXL Block Device). However, after thorough consideration,
it became clear that the cache design was not limited to CBD's pmem
device or infrastructure. Instead, it is broadly applicable to **any**
persistent memory device that supports DAX. Therefore, I have split
pcache out of cbd and refactored it into a standalone module.

Although Intel's Optane product line has been discontinued, the Storage
Class Memory (SCM) field continues to evolve. For instance, Numemory
recently launched their Optane successor product, the NM101 SCM:
https://www.techpowerup.com/332914/numemory-releases-optane-successor-nm101-storage-class-memory

### About pcache

+-------------------------------+------------------------------+------------------------------+------------------------------+
| Feature                       | pcache                       | bcache                       | dm-writecache                |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| pmem access method            | DAX                          | bio                          | DAX                          |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Write Latency (4K randwrite)  | ~7us                         | ~20us                        | ~7us                         |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Concurrency                   | Multi-tree per backend,      | Shared global index tree,    | single indexing tree and     |
|                               | fully utilizing pmem         |                              | global wc_lock               |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| IOPS (4K randwrite 32 numjobs)| 2107K                        | 352K                         | 283K                         |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Read Cache Support            | YES                          | YES                          | NO                           |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Deployment Flexibility        | No reformat needed           | Requires formatting backend  | Depends on dm framework,     |
|                               |                              | devices                      | less intuitive to deploy     |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Writeback Model               | log-structure; preserves     | no guarantee between         | no guarantee writeback       |
|                               | backing crash-consistency;   | flush order and app IO order;| ordering                     |
|                               | important for checkpoint     | may lose ordering in backing |                              |
+-------------------------------+------------------------------+------------------------------+------------------------------+
| Data Integrity                | CRC on both metadata and     | CRC on metadata only         | No CRC                       |
|                               | data (data crc is optional)  |                              |                              |
+-------------------------------+------------------------------+------------------------------+------------------------------+

### Repository

- Kernel code: https://github.com/DataTravelGuide/linux/tree/pcache
- Userspace tool: https://github.com/DataTravelGuide/pcache-utils

### Example Usage

```bash
$ insmod /workspace/linux_compile/drivers/block/pcache/pcache.ko
$ pcache cache-start --path /dev/pmem1 --format --force
$ pcache backing-start --path /dev/vdh --cache-size 50G --queues 16
/dev/pcache0
$ pcache backing-list
[
    {
        "backing_id": 0,
        "backing_path": "/dev/vdh",
        "cache_segs": 3200,
        "cache_gc_percent": 70,
        "cache_used_segs": 2238,
        "logic_dev": "/dev/pcache0"
    }
]
```

Thanks for reviewing!

Dongsheng Yang (11):
  pcache: introduce cache_dev for managing persistent memory-based cache
    devices
  pcache: introduce segment abstraction
  pcache: introduce meta_segment abstraction
  pcache: introduce cache_segment abstraction
  pcache: introduce lifecycle management of pcache_cache
  pcache: gc and writeback
  pcache: introduce cache_key infrastructure for persistent metadata
    management
  pcache: implement request processing and cache I/O path in cache_req
  pcache: introduce logic block device and request handling
  pcache: add backing device management
  block: introduce pcache (persistent memory to be cache for block
    device)

 MAINTAINERS                            |   8 +
 drivers/block/Kconfig                  |   2 +
 drivers/block/Makefile                 |   2 +
 drivers/block/pcache/Kconfig           |  16 +
 drivers/block/pcache/Makefile          |   4 +
 drivers/block/pcache/backing_dev.c     | 593 +++++++++++++++++
 drivers/block/pcache/backing_dev.h     | 105 +++
 drivers/block/pcache/cache.c           | 394 +++++++++++
 drivers/block/pcache/cache.h           | 612 +++++++++++++++++
 drivers/block/pcache/cache_dev.c       | 808 ++++++++++++++++++++++
 drivers/block/pcache/cache_dev.h       |  81 +++
 drivers/block/pcache/cache_gc.c        | 150 +++++
 drivers/block/pcache/cache_key.c       | 885 +++++++++++++++++++++++++
 drivers/block/pcache/cache_req.c       | 812 +++++++++++++++++++++++
 drivers/block/pcache/cache_segment.c   | 247 +++++++
 drivers/block/pcache/cache_writeback.c | 183 +++++
 drivers/block/pcache/logic_dev.c       | 348 ++++++++++
 drivers/block/pcache/logic_dev.h       |  73 ++
 drivers/block/pcache/main.c            | 194 ++++++
 drivers/block/pcache/meta_segment.c    |  61 ++
 drivers/block/pcache/meta_segment.h    |  46 ++
 drivers/block/pcache/pcache_internal.h | 185 ++++++
 drivers/block/pcache/segment.c         | 175 +++++
 drivers/block/pcache/segment.h         |  78 +++
 24 files changed, 6062 insertions(+)
 create mode 100644 drivers/block/pcache/Kconfig
 create mode 100644 drivers/block/pcache/Makefile
 create mode 100644 drivers/block/pcache/backing_dev.c
 create mode 100644 drivers/block/pcache/backing_dev.h
 create mode 100644 drivers/block/pcache/cache.c
 create mode 100644 drivers/block/pcache/cache.h
 create mode 100644 drivers/block/pcache/cache_dev.c
 create mode 100644 drivers/block/pcache/cache_dev.h
 create mode 100644 drivers/block/pcache/cache_gc.c
 create mode 100644 drivers/block/pcache/cache_key.c
 create mode 100644 drivers/block/pcache/cache_req.c
 create mode 100644 drivers/block/pcache/cache_segment.c
 create mode 100644 drivers/block/pcache/cache_writeback.c
 create mode 100644 drivers/block/pcache/logic_dev.c
 create mode 100644 drivers/block/pcache/logic_dev.h
 create mode 100644 drivers/block/pcache/main.c
 create mode 100644 drivers/block/pcache/meta_segment.c
 create mode 100644 drivers/block/pcache/meta_segment.h
 create mode 100644 drivers/block/pcache/pcache_internal.h
 create mode 100644 drivers/block/pcache/segment.c
 create mode 100644 drivers/block/pcache/segment.h

-- 
2.34.1


