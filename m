Return-Path: <nvdimm+bounces-2952-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 261E64B06F4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 08:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 38D471C0B8C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 07:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A502CA4;
	Thu, 10 Feb 2022 07:28:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344412F22
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L7OGejZbRu+QgE+4KbqRy4msYJogVFzOR8WFdCl8/80=; b=eKKKgKkuaE01+Nvoo8eKckwrla
	uHDvbQKsY1I+8rHUnmKTrANleI/peq39kFDeuY9tfC/pAUZX9+6Gh58/9sMa16SA31DFT/DHHENpA
	wB44giC+sRhFyvdNFVP150JQjHDq4ASoixuwQ+cJain6eH0Zdy5DudB1ke6SlJbIedExUtLO5vqmv
	qYigZr+KlRbUSfyG4YzU4u0fld+gt+XTEqror/Gjkqn5JzjKh6RYbq1mBq8PHl5lg0T0vZz0Cuoc/
	b87JAs/e+UYwAe7PWl2Tn7sLUeRU+VtT8yM7wXK7xM+5cuAJK4WWiFz4DBXUjNTK06Z70+5fWunTx
	pmaHhCvw==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3sY-002rl0-02; Thu, 10 Feb 2022 07:28:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 01/27] mm: remove a pointless CONFIG_ZONE_DEVICE check in memremap_pages
Date: Thu, 10 Feb 2022 08:28:02 +0100
Message-Id: <20220210072828.2930359-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210072828.2930359-1-hch@lst.de>
References: <20220210072828.2930359-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

memremap.c is only built when CONFIG_ZONE_DEVICE is set, so remove
the superflous extra check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/memremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index 6aa5f0c2d11fda..5f04a0709e436e 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -328,8 +328,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 		}
 		break;
 	case MEMORY_DEVICE_FS_DAX:
-		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
-		    IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
+		if (IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
-- 
2.30.2


