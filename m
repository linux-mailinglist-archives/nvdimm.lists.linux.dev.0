Return-Path: <nvdimm+bounces-1591-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F21430044
	for <lists+linux-nvdimm@lfdr.de>; Sat, 16 Oct 2021 06:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4FEF23E109E
	for <lists+linux-nvdimm@lfdr.de>; Sat, 16 Oct 2021 04:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AE12C87;
	Sat, 16 Oct 2021 04:39:42 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF22F2C80
	for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 04:39:40 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1695D68BEB; Sat, 16 Oct 2021 06:39:37 +0200 (CEST)
Date: Sat, 16 Oct 2021 06:39:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, geoff@infradead.org, mpe@ellerman.id.au,
	benh@kernel.crashing.org, paulus@samba.org, jim@jtan.com,
	minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
	richard@nod.at, miquel.raynal@bootlin.com, vigneshr@ti.com,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20211016043936.GB27339@lst.de>
References: <20211015235219.2191207-1-mcgrof@kernel.org> <20211015235219.2191207-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015235219.2191207-3-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Thanks,

applied to nvme-5.16.

