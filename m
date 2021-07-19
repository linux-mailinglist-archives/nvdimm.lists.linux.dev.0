Return-Path: <nvdimm+bounces-534-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 564443CD20D
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 12:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 675D41C0DF4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 10:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCB82FB6;
	Mon, 19 Jul 2021 10:38:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB7629D6
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=yT2CXMMsx2sRqeT3sBV0doChuK/7gNfIehR09yaKjtk=; b=SseK5rN1pYwOADWWQkUuBBEr9w
	RBhGBtkX8yWjc6uhWYo0bEdWXgADbD5qS/mgRlkrb3psoYpaKKNCLHNSINqmFRRgCn0o/CgD5upWq
	xBxyza/jdTzcPuTp+NRdGUAzWl+QCLsBTTAVSzP3Ez2M6Du0DanmkDls5OxHivXlPGVtBjd9Vfddc
	VmuIMwWadbMaJXyqNmJpLXJ+g3OSh/fWV81ObI+61vtjwltg56wR4gOQJOPVzY/FgKos4cgROyUnv
	4JDCnkgB49n1FMUcxoTUvsSKE91YtgeOp/caPzoZZd4YafMr0EH66Gxk/Jnz+H8UpYxieEF2QUXZ6
	8gMhODXw==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5Qcp-006kSn-7E; Mon, 19 Jul 2021 10:35:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com
Subject: [PATCH 01/27] iomap: fix a trivial comment typo in trace.h
Date: Mon, 19 Jul 2021 12:34:54 +0200
Message-Id: <20210719103520.495450-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index fdc7ae388476f5..e9cd5cc0d6ba40 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2009-2019 Christoph Hellwig
  *
- * NOTE: none of these tracepoints shall be consider a stable kernel ABI
+ * NOTE: none of these tracepoints shall be considered a stable kernel ABI
  * as they can change at any time.
  */
 #undef TRACE_SYSTEM
-- 
2.30.2


