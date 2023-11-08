Return-Path: <nvdimm+bounces-6900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1F27E5461
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Nov 2023 11:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 043F8B20E0B
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Nov 2023 10:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5183D14284;
	Wed,  8 Nov 2023 10:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIGuLH83"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB0B13ACC
	for <nvdimm@lists.linux.dev>; Wed,  8 Nov 2023 10:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6c343921866so1069542b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 08 Nov 2023 02:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699440473; x=1700045273; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbWdFo7miza+LJDE+FII5IkRlW+z6I8tgEOAp/fAi2E=;
        b=EIGuLH83P1w3TWWVQEMYTvmTRJpE7oujMWNKJSJUW+wCtD9D7TRzx0PlLVOw8YW09+
         8iobeQ8XrnTjMy5TLew0pDyvfGEMPtGiQcUgxi6G9PvKlRXjp4/y4jYbuILY04sGT6I2
         YFNUicKevOVZgPxOGNOFi6lPL6IybfRPklab9rrNy4IGv5mUw3bgku76h3+wzxfjnG7a
         8XGux/m3RbxGdzt7tSmwKNEPK/RZhmLBCAhokABw0OuknvvxSKnhIyaJzayF3UVQytEy
         3GnpFz5/tooaPhmrsn8CQ2iz/Ifoizyt003ZvYAqTMrE6wI3JBT57rGuA5IwEPDRCjnb
         0KDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699440473; x=1700045273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbWdFo7miza+LJDE+FII5IkRlW+z6I8tgEOAp/fAi2E=;
        b=QN5B4dHkB3I0V866Sg9HrLbIhCN+l6GKgsOUW1yO1DQyxZ1prHgDmsLseeriG9Ixbc
         STM1zPDel0O+jB2RivZv04NUL5ysVqIfuQ9WFB45kqthlSb2wrKe3oNUAOil915XEZBM
         kXWKh4xilmM8izHzU14woQhiNr1JNUiasDe9zQb3CwZarr5GRIrP9r8l+33G+dJPzJON
         44BcQpCHQtYPGjqoZOh5J6ImlCrvD7WyalCdy8k4EudX8CfJtIf2vfjM0OEo2v4jnDwx
         zrELOPpedF8LVPCuzB9TahZNQCmgCRqGhKzSyQwMHpLjfmb3UB63UXwmOKpMkZtez9Tc
         iSCA==
X-Gm-Message-State: AOJu0Yzj20r/tnRe09iAg41N3dc8jOcA3VgWlUdVNhm/FHNoPj0c8d9e
	rDQq//w2rqKkG0CEenX06PU=
X-Google-Smtp-Source: AGHT+IEakTnfI52C8pPf0ICMAQ0OdKNwvumwvOelYpYlFppmk3T3eTha1MxYy4JkbmVoaKhG3s9jxw==
X-Received: by 2002:a62:ab12:0:b0:68f:c8b3:3077 with SMTP id p18-20020a62ab12000000b0068fc8b33077mr1611102pff.1.1699440472652;
        Wed, 08 Nov 2023 02:47:52 -0800 (PST)
Received: from abhinav.. ([103.75.161.208])
        by smtp.gmail.com with ESMTPSA id fm26-20020a056a002f9a00b00694fee1011asm8617933pfb.208.2023.11.08.02.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 02:47:52 -0800 (PST)
From: Abhinav Singh <singhabhinav9051571833@gmail.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Abhinav Singh <singhabhinav9051571833@gmail.com>
Subject: [PATCH] fs : Fix warning using plain integer as NULL
Date: Wed,  8 Nov 2023 16:17:30 +0530
Message-Id: <20231108104730.1007713-1-singhabhinav9051571833@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231108101518.e4nriftavrhw45xk@quack3>
References: <20231108101518.e4nriftavrhw45xk@quack3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sparse static analysis tools generate a warning with this message
"Using plain integer as NULL pointer". In this case this warning is
being shown because we are trying to initialize  pointer to NULL using
integer value 0.

Signed-off-by: Abhinav Singh <singhabhinav9051571833@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c       | 2 +-
 fs/direct-io.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3380b43cb6bb..423fc1607dfa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1128,7 +1128,7 @@ static int dax_iomap_copy_around(loff_t pos, uint64_t length, size_t align_size,
 	/* zero the edges if srcmap is a HOLE or IOMAP_UNWRITTEN */
 	bool zero_edge = srcmap->flags & IOMAP_F_SHARED ||
 			 srcmap->type == IOMAP_UNWRITTEN;
-	void *saddr = 0;
+	void *saddr = NULL;
 	int ret = 0;
 
 	if (!zero_edge) {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 20533266ade6..60456263a338 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1114,7 +1114,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	loff_t offset = iocb->ki_pos;
 	const loff_t end = offset + count;
 	struct dio *dio;
-	struct dio_submit sdio = { 0, };
+	struct dio_submit sdio = { NULL, };
 	struct buffer_head map_bh = { 0, };
 	struct blk_plug plug;
 	unsigned long align = offset | iov_iter_alignment(iter);
-- 
2.39.2


