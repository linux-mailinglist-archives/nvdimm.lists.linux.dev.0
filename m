Return-Path: <nvdimm+bounces-1867-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B6C44A837
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 09:15:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 32D0E1C0A20
	for <lists+linux-nvdimm@lfdr.de>; Tue,  9 Nov 2021 08:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DBE2C9A;
	Tue,  9 Nov 2021 08:14:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC932C80
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:14:55 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4D6F167373; Tue,  9 Nov 2021 09:14:46 +0100 (CET)
Date: Tue, 9 Nov 2021 09:14:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Huaisheng Ye <huaisheng.ye@intel.com>
Cc: dan.j.williams@intel.com, hch@lst.de, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add ro state control function for nvdimm drivers
Message-ID: <20211109081446.GE28785@lst.de>
References: <20211027120937.1163744-1-huaisheng.ye@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027120937.1163744-1-huaisheng.ye@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

