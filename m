Return-Path: <nvdimm+bounces-1871-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 306CB44A8AE
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1CCC01C0BA1
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F5A2CAA;
	Tue,  9 Nov 2021 08:33:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D49F29CA
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ic2T9j1dV01vrbRbp14kmcdJ50GDWCWzLE3tdNoxo6s=; b=q9jK8+4QzqazcHke6j4emluPNp
	gvM4AQoU0if2PLeCTuSf52oHmL4S2x6bGaWf/FvEkzdXybaIPyiA9hqIkSq+7AyNYtp1zJGZrI3nw
	dvIrX50uqbaw/zv2juhsVeQxcvaEULYMkh9M4+iT8wg5aLZmoI6oFUA7GofhSvVSqGll8iElobfPx
	PBktYxovHBFjfoGN1EcqHm023qS4L+VqBjgU0VNI2UwCSlUVcXUSwATdtmmRWHd/SdUsOUdur/s68
	/9ydjmkZL5SbSFG5gc3wZJHqhdmUYCCAVUqkSiaxjvXx11f49n5l0WB5DRgDdn9TlS9PpVTO9InmS
	3jvYAVuQ==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZ3-000ry2-Kv; Tue, 09 Nov 2021 08:33:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: decouple DAX from block devices
Date: Tue,  9 Nov 2021 09:32:40 +0100
Message-Id: <20211109083309.584081-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi Dan,

this series decouples the DAX from the block layer so that the
block_device is not needed at all for the DAX I/O path.

