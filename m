Return-Path: <nvdimm+bounces-7985-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D328B5F86
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Apr 2024 19:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0AFEB22FFE
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Apr 2024 17:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EA586634;
	Mon, 29 Apr 2024 17:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnssSQAP"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6438627A
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410290; cv=none; b=JwFxbUgziLSt3798dKj8TVP4e+NcAzgdQqGBhltT+KVGt+blzSTQf5bKHE1cnjkRPOy9syFCJmuNul8GEHUo/pk6YFRASh7jcR9EMbrAnaxqv/xsk4A8ZCKUYhRI7jQTBitvySlm4K7GG3io277/XpHyx43DZEymeeQzQ9EZ3iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410290; c=relaxed/simple;
	bh=DnBFz4/Se6xVWS99x9m7QEYEtuOZb/pR9I7lm8YTTnM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R7g/Sa69Z+NHRc3+ypRdlMwdZY7MVPe/1lGVJizmqLSka+8PxtlxKLSaMnRjSdC38Ezv1k4xg9gBcXxNFxnGf4AQxGKdKKf3unnODUD9I6raZHdt4u+r2g/Jg57CiWrQfLUrrafgJIyERYLfBE5oqz8xD72Mo4NsmIJ7XGeBk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnssSQAP; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ee2d64423cso896718a34.2
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410288; x=1715015088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhow96kP5BU3qcQBMxGZEfW9W+QoKa4rPIJ24CtlxHk=;
        b=GnssSQAPdRGbmDbWnDZsYYJ35u8r9r3/9vEsg+Xe0u9W1CRiN1m8xNkAjom6sRKkLT
         tP/MKl8sETKylE8rrqAPIX/PUcklGjp2L7d+Q5WyLRAlxHDXDaCIaBeSS0M+B7FcLFdD
         XKaUbBqhS2IJ6iNc1B6+7YzIvPRLOZ0r0rkjqYcuCfmhnV4fc9y37JC4laJ0CjsFDzYd
         AoWTH+X+h8/LBPUhlmDipIIJ0pc1+ICdKGWzfyzn80vqjA6KARV9+NwQOdVoW+otu1j3
         uEGqY60wS7ZL4ASEa1CTL4fGgDIbL94JFpipuq67zXPqv+S2XmYJjxKp7aLAOhzfau9p
         YL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410288; x=1715015088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jhow96kP5BU3qcQBMxGZEfW9W+QoKa4rPIJ24CtlxHk=;
        b=qiUS/IDJNyGPEHQxV58AbXK2p5MoRJmg/s7qpxYBYtwm/CIItFWmvTcU8hSGive4rJ
         Re28Lab+2eV5slDk/NaK06xfVg1zIBPzA+HonSc84GqWdw3tsGXcRGIdHTjpCNrugsFr
         HoF6ecKSoiav0LrrQoDLRf3t9TXyuo/bVELCEyyd2BeoohbBe7T3vLi/alodUmD9y+Cm
         fQfuSIiGl4HcmePdtBaqdt9jJNR2lc38c2dh1W2fWDqNcK5Pw6U8gxzcA6TYC+NSjjr5
         tqvvRYeODXVok4QN9KxWvDMYQDFweI0FKpL80YNl3N273SXV8NjM8BkwR+bnXitjLxi0
         pJmA==
X-Forwarded-Encrypted: i=1; AJvYcCX0kpWv0EqyJlcNFE5p6WLtnLDu3tG0DEBLtp+cWoAasTFZhdWBJA6FtHCtfG+Bk3FyQQmzbGywb7SSr2jbPTRKsZuosxmD
X-Gm-Message-State: AOJu0Yyzl3CDcpT42JnhXliQR1W+VmkxARfni1e4VKuj+SpaHehmJL71
	kBShqbulDTTBWeizAXcnNha7jlmZiuzTDM1l5YK6y56b0nm5WJUy
X-Google-Smtp-Source: AGHT+IFT0esK+nrgP4Zf50tdR4YgA9tgrSYLGG5TA0ZvSJostVvZqlCI2BgehfoxtpiJFe8p6wC3NQ==
X-Received: by 2002:a05:6830:19cc:b0:6eb:d847:ff8a with SMTP id p12-20020a05683019cc00b006ebd847ff8amr8346147otp.9.1714410288151;
        Mon, 29 Apr 2024 10:04:48 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.04.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:04:47 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 01/12] famfs: Introduce famfs documentation
Date: Mon, 29 Apr 2024 12:04:17 -0500
Message-Id: <0270b3e2d4c6511990978479771598ad62cf2ddd.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1714409084.git.john@groves.net>
References: <cover.1714409084.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* Introduce Documentation/filesystems/famfs.rst into the Documentation
  tree and filesystems index
* Add famfs famfs.rst to the filesystems doc index
* Add famfs' ioctl opcodes to ioctl-number.rst
* Update MAINTAINERS FILE

Signed-off-by: John Groves <john@groves.net>
---
 Documentation/filesystems/famfs.rst           | 135 ++++++++++++++++++
 Documentation/filesystems/index.rst           |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |   9 ++
 4 files changed, 146 insertions(+)
 create mode 100644 Documentation/filesystems/famfs.rst

diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst
new file mode 100644
index 000000000000..792785598d6a
--- /dev/null
+++ b/Documentation/filesystems/famfs.rst
@@ -0,0 +1,135 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _famfs_index:
+
+==================================================================
+famfs: The kernel component of the famfs shared memory file system
+==================================================================
+
+- Copyright (C) 2024 Micron Technology, Inc.
+
+Introduction
+============
+Compute Express Link (CXL) provides a mechanism for disaggregated or
+fabric-attached memory (FAM). This creates opportunities for data sharing;
+clustered apps that would otherwise have to shard or replicate data can
+share one copy in disaggregated memory.
+
+Famfs, which is not CXL-specific in any way, provides a mechanism for
+multiple hosts to use data in shared memory, by giving it a file system
+interface. With famfs, any app that understands files (which is almost
+all apps) can access data sets in shared memory. Although famfs
+supports read and write, the real point is to support mmap, which
+provides direct (dax) access to the memory - either writable or read-only.
+
+Shared memory can pose complex coherency and synchronization issues, but
+there are also simple cases. Two simple and eminently useful patterns that
+occur frequently in data analytics and AI are:
+
+* Serial Sharing - Only one host or process at a time has access to a file
+* Read-only Sharing - Multiple hosts or processes share read-only access
+  to a file
+
+The famfs kernel file system is part of the famfs framework; User space
+components [1] handle metadata allocation and distribution, and direct the
+famfs kernel module to instantiate files that map to specific memory.
+
+The famfs framework manages coherency of its own metadata and structures,
+but does not attempt to manage coherency for applications.
+
+Famfs also provides data isolation between files. That is, even though
+the host has access to an entire memory "device" (as a dax device), apps
+cannot write to memory for which the file is read-only, and mapping one
+file provides isolation from the memory of all other files. This is pretty
+basic, but some experimental shared memory usage patterns provide no such
+isolation.
+
+Principles of Operation
+=======================
+
+Without its user space components, the famfs kernel module doesn't do
+anything useful. The user space components maintain superblocks and
+metadata logs, and use the famfs kernel component to provide a file system
+view of shared memory across multiple hosts.
+
+Each host has an independent instance of the famfs kernel module. After
+mount, files are not visible until the user space component instantiates
+them (normally by playing the famfs metadata log).
+
+Once instantiated, files on each host can point to the same shared memory,
+but in-memory metadata (inodes, etc.) is ephemeral on each host that has a
+famfs instance mounted. Like ramfs, the famfs in-kernel file system has no
+backing store for metadata modifications. If metadata mutations are ever
+persisted, that must be done by the user space components. However,
+mutations to file data are saved to the shared memory - subject to write
+permission and processor cache behavior.
+
+
+Famfs is Not a Conventional File System
+---------------------------------------
+
+Famfs files can be accessed by conventional means, but there are
+limitations. The kernel component of famfs is not involved in the
+allocation of backing memory for files at all; the famfs user space
+creates files and passes the allocation extent lists into the kernel via
+the per-file FAMFSIOC_MAP_CREATE ioctl. A file that lacks this metadata is
+treated as invalid by the famfs kernel module. As a practical matter files
+must be created via the famfs library or cli, but they can be consumed as
+if they were conventional files.
+
+Famfs differs in some important ways from conventional file systems:
+
+* Files must be pre-allocated by the famfs framework; Allocation is never
+  performed on (or after) write.
+* Any operation that changes a file's size is considered to put the file
+  in an invalid state, disabling access to the data. It may be possible to
+  revisit this in the future. (Typically the famfs user space can restore
+  files to a valid state by replaying the famfs metadata log.)
+
+Famfs exists to apply the existing file system abstractions to shared
+memory so applications and workflows can more easily adapt to an
+environment with disaggregated shared memory.
+
+Memory Error Handling
+=====================
+
+Possible memory errors include timeouts, poison and unexpected
+reconfiguration of an underlying dax device. In all of these cases, famfs
+receives a call via its iomap_ops->notify_failure() function. If any
+memory errors have been detected, Access to the affected famfs mount is
+disabled to avoid further errors or corruption. Testing indicates that
+a famfs instance that has encountered errors can be unmounted cleanly, but
+Repairing memory errors or corruption is outside the scope of famfs.
+
+Key Requirements
+================
+
+The primary requirements for famfs are:
+
+1. Must support a file system abstraction backed by sharable dax memory
+2. Files must efficiently handle VMA faults
+3. Must support metadata distribution in a sharable way
+4. Must handle clients with a stale copy of metadata
+
+The famfs kernel component takes care of 1-2 above by caching each file's
+mapping metadata in the kernel.
+
+Requirements 3 and 4 are handled by the user space components, and are
+largely orthogonal to the functionality of the famfs kernel module.
+
+Requirements 3 and 4 cannot be met by conventional fs-dax file systems
+(e.g. xfs and ext4) because they use write-back metadata; it is not valid
+to mount such a file system on two hosts from the same in-memory image.
+
+
+Famfs Usage
+===========
+
+Famfs usage is documented at [1].
+
+
+References
+==========
+
+- [1] Famfs user space repository and documentation
+      https://github.com/cxl-micron-reskit/famfs
diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 1f9b4c905a6a..0fe2c70a106f 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -87,6 +87,7 @@ Documentation for filesystem implementations.
    ext3
    ext4/index
    f2fs
+   famfs
    gfs2
    gfs2-uevents
    gfs2-glocks
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index c472423412bf..ac407802cf10 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -289,6 +289,7 @@ Code  Seq#    Include File                                           Comments
 'u'   00-1F  linux/smb_fs.h                                          gone
 'u'   20-3F  linux/uvcvideo.h                                        USB video class host driver
 'u'   40-4f  linux/udmabuf.h                                         userspace dma-buf misc device
+'u'   50-5F  linux/famfs_ioctl.h                                     famfs shared memory file system
 'v'   00-1F  linux/ext2_fs.h                                         conflict!
 'v'   00-1F  linux/fs.h                                              conflict!
 'v'   00-0F  linux/sonypi.h                                          conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index ebf03f5f0619..3f2d847dcf01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8180,6 +8180,15 @@ F:	Documentation/networking/failover.rst
 F:	include/net/failover.h
 F:	net/core/failover.c
 
+FAMFS
+M:	John Groves <jgroves@micron.com>
+M:	John Groves <John@Groves.net>
+M:	John Groves <john@jagalactic.com>
+L:	linux-cxl@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	Documentation/filesystems/famfs.rst
+
 FANOTIFY
 M:	Jan Kara <jack@suse.cz>
 R:	Amir Goldstein <amir73il@gmail.com>
-- 
2.43.0


