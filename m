Return-Path: <nvdimm+bounces-749-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4783E3F9B
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 08:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 32ACA3E0A11
	for <lists+linux-nvdimm@lfdr.de>; Mon,  9 Aug 2021 06:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450092FBF;
	Mon,  9 Aug 2021 06:15:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996562FB6
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2gvNBXa/RtMfuB6kAqzw5OYEfdfqHSHwb+TmOW0ljdM=; b=asO6OWZjk9BxMTqTBz8uIz468+
	NX7aOW2CVvFpxnmy93Nb/qH11qA3xGLqse61y2XZmH/DHE6FHT0lE7omdCOQk2dz+AJWgo6OVtg6M
	0UBL/y1Cj9y0uu9UvXpAiWeLeQtG2oMlFBGC2rJnI8FzF5BJ5eMhXwKxrJHi2AqF0ybjoES1t56PC
	W3c6SZxIbFVj7Ao79P7Loqi+tjHmqRm9hp5q+vQcvtDMlsjLT0ZHMGJM6+eedonF00iHVPsLgd+vW
	BnnhNaIRrU0LfVPXkJXHvsW9uYO3fCn/sJnsPg9TA6WXa6XMBEoC/ilapSLsEqANPxV/5xrtz8ylH
	mM3Pafyw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyXG-00AgMX-Ru; Mon, 09 Aug 2021 06:13:37 +0000
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
Subject: [PATCH 01/30] iomap: fix a trivial comment typo in trace.h
Date: Mon,  9 Aug 2021 08:12:15 +0200
Message-Id: <20210809061244.1196573-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809061244.1196573-1-hch@lst.de>
References: <20210809061244.1196573-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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


