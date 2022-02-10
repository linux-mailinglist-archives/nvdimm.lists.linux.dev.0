Return-Path: <nvdimm+bounces-2979-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3624B0748
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 08:31:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1D1813E1476
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Feb 2022 07:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66ABC2F5C;
	Thu, 10 Feb 2022 07:29:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0F76D22
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WUHmc3dSNcUNqOsNJ/yfYus8kADkbxrTR1ASOELOLwk=; b=tR+LnJoC7w5g1gHletQUyisSha
	psPuJRmTU97k6ChwYiq94y5OUxVAu3yqd+upJEkbmKMiEavQ78bRGTs9SKf5NVuTHQZAiWMqit4I0
	tx3suf2lropDxJIW/JfY5dFG4SnpDLYV628vFgZdCCMeesad8J6qJKleEg9+DDBlZH3/COFZvUyEa
	cWNzZhvWegX4levw9i1cSVWpMPSh3kO2WIKLxgKnbJ4+TdVQrGiHGGXUiZ+uauTGBOUuBPJMIB9Tg
	aq/NGHBFNDYZr6zconCPgtuOyTA+frhWJcAM/q076dr8KmT7jHJLhsSjeP0vS+8UL8HGz3SbnzzvC
	Gu5+QKWw==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3tj-002sT3-TU; Thu, 10 Feb 2022 07:29:48 +0000
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
	Alex Sierra <alex.sierra@amd.com>
Subject: [PATCH 27/27] tools: add hmm gup test for long term pinned device pages
Date: Thu, 10 Feb 2022 08:28:28 +0100
Message-Id: <20220210072828.2930359-28-hch@lst.de>
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

From: Alex Sierra <alex.sierra@amd.com>

The intention is to test device coherent type pages that have been
called through get user pages with PIN_LONGTERM flag set. These pages
should get migrated back to normal system memory.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tools/testing/selftests/vm/Makefile    |  2 +-
 tools/testing/selftests/vm/hmm-tests.c | 81 ++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 1607322a112c91..58c8427114f0c2 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -142,7 +142,7 @@ $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
 $(OUTPUT)/gup_test: ../../../../mm/gup_test.h
 
-$(OUTPUT)/hmm-tests: local_config.h
+$(OUTPUT)/hmm-tests: local_config.h ../../../../mm/gup_test.h
 
 # HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftests/vm/hmm-tests.c
index 84ec8c4a1dc7b6..11b83a8084fee2 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -36,6 +36,7 @@
  * in the usual include/uapi/... directory.
  */
 #include "../../../../lib/test_hmm_uapi.h"
+#include "../../../../mm/gup_test.h"
 
 struct hmm_buffer {
 	void		*ptr;
@@ -60,6 +61,8 @@ enum {
 #define NTIMES		10
 
 #define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
+/* Just the flags we need, copied from mm.h: */
+#define FOLL_WRITE	0x01	/* check pte is writable */
 
 FIXTURE(hmm)
 {
@@ -1766,4 +1769,82 @@ TEST_F(hmm, exclusive_cow)
 	hmm_buffer_free(buffer);
 }
 
+/*
+ * Test get user device pages through gup_test. Setting PIN_LONGTERM flag.
+ * This should trigger a migration back to system memory for both, private
+ * and coherent type pages.
+ * This test makes use of gup_test module. Make sure GUP_TEST_CONFIG is added
+ * to your configuration before you run it.
+ */
+TEST_F(hmm, hmm_gup_test)
+{
+	struct hmm_buffer *buffer;
+	struct gup_test gup;
+	int gup_fd;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+	unsigned char *m;
+
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (gup_fd == -1)
+		SKIP(return, "Skipping test, could not find gup_test driver");
+
+	npages = 4;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	gup.nr_pages_per_call = npages;
+	gup.addr = (unsigned long)buffer->ptr;
+	gup.gup_flags = FOLL_WRITE;
+	gup.size = size;
+	/*
+	 * Calling gup_test ioctl. It will try to PIN_LONGTERM these device pages
+	 * causing a migration back to system memory for both, private and coherent
+	 * type pages.
+	 */
+	if (ioctl(gup_fd, PIN_LONGTERM_BENCHMARK, &gup)) {
+		perror("ioctl on PIN_LONGTERM_BENCHMARK\n");
+		goto out_test;
+	}
+
+	/* Take snapshot to make sure pages have been migrated to sys memory */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+	m = buffer->mirror;
+	for (i = 0; i < npages; i++)
+		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE);
+out_test:
+	close(gup_fd);
+	hmm_buffer_free(buffer);
+}
 TEST_HARNESS_MAIN
-- 
2.30.2


