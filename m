Return-Path: <nvdimm+bounces-7995-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0731C8B5F9D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Apr 2024 19:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A92B728294C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 29 Apr 2024 17:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67637127E1C;
	Mon, 29 Apr 2024 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKB80pJz"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B786AE3
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410336; cv=none; b=elu80608TaYf+O28r/yVjrQeUVtOxGdEjKonZyHbIBbTWPlmONZsUMWLCnf0LrHDsdRvwLYsKd80Gv5lG2Tsd622cCD6OyWIrF1wm0Q1mSGIKzpZSg7aE5JeaTLbtt1QQyZkyyLzrxkdjIt6BRUY4XMCpINNmoZFEfiRI14Tvq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410336; c=relaxed/simple;
	bh=qYcyL0hIBedDSxOc4RRWxp74kl4dcZDEKqcuPynXMsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T8yWVlkUdqgf39Vign0UMW5iTW9FBD8aqA8i3sVe7NGsL6B4tKxUeoF4r3K8r8Z/WQMeHjshEYG+6n0unYVC9fyLpohOKeEVQRzqGXqKsbFa6XZMctQZE5ye8Fy+3qXZ03eRasfsGt7wwOhCHvrghKxgoctt6SSEMQn5pOaGH6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKB80pJz; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-23a6a8e9978so2061587fac.3
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410331; x=1715015131; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYsNSadbDL/XO8+Ce/eg3N1cTx7anq8xr5/2FvNISeg=;
        b=CKB80pJzIq4Kja1+ZWWHTT+ZmqGTEZkTZZJWS0TioPUOkzT6LrRdH91w3sImgw7euB
         oiF402N20et24biYj/8iaC6BaBLF6PUHBgEB3Q11yxq/osYVRur2kFEpQbOyMLdeVIlk
         zMGCBR3DG6fzvdnBmsUSYTGfGxYTDCZHu4OXWLi0CUAY0SaVLlVnxvMtqYlcQZONtzeI
         q3/g/aasjkzsX3yfYkV9gUiq2to57gfd2rUTkpwtO2IfQKqyqaIc57VGM2zx3rV9eMwV
         HmQFKqg5vupWO7sveqKbRb+Fp7r5tHiw0md8m/0Z546EppH944nZOw8Nnjvc2WwHPkEx
         G0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410331; x=1715015131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yYsNSadbDL/XO8+Ce/eg3N1cTx7anq8xr5/2FvNISeg=;
        b=tBNBQpW9T0GDVBIs8ppxM78kPJ+WrUX+VYGluTfDIEDrsC/DMgoSAqOJzLH5MEYZit
         3EJJkbha2DCOQc++damFZPkVqUXi6vyyJ/Z64DdU7kq/Gdei0YqR/Wh/zsd17ctCApzi
         ZtAj16IH7sck+9kYHv1/8RBQh7d4Ygkwga8gIaHXb3dxNLWby9GMlCCWqXFgf4fmoQAQ
         l5UAsL8B1hWDIFTt2hcaDsDAmXUv8ogCd9B5882ao04ApozMCLbuU/m7Ud/rgTAMJZ1K
         TAywgHK2PNNDr9Pw9uzOZQCIMTz9D1xZmaNxbNp8mtMAVnYjCDkSHWRwrRhDt4RZNdEe
         FsZg==
X-Forwarded-Encrypted: i=1; AJvYcCUeeiU1MMM/NBvbEQyFVsxEG/a0+WcOagIc0IWOw0fBgULARsLuVfRUFFwGD2UweDgb+wL7kwPJL1d9krGDKuLp7aS2Cpsi
X-Gm-Message-State: AOJu0YzSjywm4qNYUWNMrW7cXRqkfSBrW7dHZeiabyrbu2+K8j4gLQIf
	7jL+5IIlc3waWikwvQV4m1J8ceNRMR7v5nsu+VOeInpFzRSwKnvn
X-Google-Smtp-Source: AGHT+IHpy5rIS85sX04zYGzAy0Qk38IVj3GM56nKt2jdu2LLX/opQJ4URM6nJrxFSBqIHBiafXyrsQ==
X-Received: by 2002:a05:6871:408a:b0:21f:2b1:cdea with SMTP id kz10-20020a056871408a00b0021f02b1cdeamr14600153oab.57.1714410331618;
        Mon, 29 Apr 2024 10:05:31 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.05.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:05:31 -0700 (PDT)
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
Subject: [RFC PATCH v2 11/12] famfs: Introduce mmap and VM fault handling
Date: Mon, 29 Apr 2024 12:04:27 -0500
Message-Id: <744981e208f94d5fc12549e48b775d10cee550e8.1714409084.git.john@groves.net>
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

This commit adds vm_operations, plus famfs_mmap() and fault handlers.
It is still missing iomap_ops, iomap mapping resolution, and
famfs_ioctl() for setting up file-to-memory mappings.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_file.c | 108 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
index 48036c71d4ed..585b776dd73c 100644
--- a/fs/famfs/famfs_file.c
+++ b/fs/famfs/famfs_file.c
@@ -16,6 +16,88 @@
 
 #include "famfs_internal.h"
 
+/*********************************************************************
+ * vm_operations
+ */
+static vm_fault_t
+__famfs_filemap_fault(struct vm_fault *vmf, unsigned int pe_size,
+		      bool write_fault)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	vm_fault_t ret;
+	pfn_t pfn;
+
+	if (fsi->deverror)
+		return VM_FAULT_SIGBUS;
+
+	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
+		pr_err("%s: file not marked IS_DAX!!\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	if (write_fault) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vmf->vma->vm_file);
+	}
+
+	ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, NULL /*&famfs_iomap_ops */);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+
+	if (write_fault)
+		sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+
+static inline bool
+famfs_is_write_fault(struct vm_fault *vmf)
+{
+	return (vmf->flags & FAULT_FLAG_WRITE) &&
+	       (vmf->vma->vm_flags & VM_SHARED);
+}
+
+static vm_fault_t
+famfs_filemap_fault(struct vm_fault *vmf)
+{
+	return __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int pe_size)
+{
+	return __famfs_filemap_fault(vmf, pe_size, famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_page_mkwrite(struct vm_fault *vmf)
+{
+	return __famfs_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_pfn_mkwrite(struct vm_fault *vmf)
+{
+	return __famfs_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_map_pages(struct vm_fault	*vmf, pgoff_t start_pgoff,
+			pgoff_t	end_pgoff)
+{
+	return filemap_map_pages(vmf, start_pgoff, end_pgoff);
+}
+
+const struct vm_operations_struct famfs_file_vm_ops = {
+	.fault		= famfs_filemap_fault,
+	.huge_fault	= famfs_filemap_huge_fault,
+	.map_pages	= famfs_filemap_map_pages,
+	.page_mkwrite	= famfs_filemap_page_mkwrite,
+	.pfn_mkwrite	= famfs_filemap_pfn_mkwrite,
+};
+
 /*********************************************************************
  * file_operations
  */
@@ -25,7 +107,8 @@ static ssize_t
 famfs_file_invalid(struct inode *inode)
 {
 	if (!IS_DAX(inode)) {
-		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
+		pr_debug("%s: inode %llx IS_DAX is false\n",
+			 __func__, (u64)inode);
 		return -ENXIO;
 	}
 	return 0;
@@ -101,6 +184,27 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
 }
 
+static int
+famfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	ssize_t rc;
+
+	if (fsi->deverror)
+		return -ENODEV;
+
+	rc = famfs_file_invalid(inode);
+	if (rc)
+		return (int)rc;
+
+	file_accessed(file);
+	vma->vm_ops = &famfs_file_vm_ops;
+	vm_flags_set(vma, VM_HUGEPAGE);
+	return 0;
+}
+
 const struct file_operations famfs_file_operations = {
 	.owner             = THIS_MODULE,
 
@@ -108,7 +212,7 @@ const struct file_operations famfs_file_operations = {
 	.write_iter	   = famfs_dax_write_iter,
 	.read_iter	   = famfs_dax_read_iter,
 	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
-	.mmap		   = NULL /* famfs_file_mmap */,
+	.mmap		   = famfs_file_mmap,
 
 	/* Force PMD alignment for mmap */
 	.get_unmapped_area = thp_get_unmapped_area,
-- 
2.43.0


