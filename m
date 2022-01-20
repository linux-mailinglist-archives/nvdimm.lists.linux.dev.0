Return-Path: <nvdimm+bounces-2509-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 43973494A24
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 09:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id E8FC93E0ECC
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 08:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CDC2CAC;
	Thu, 20 Jan 2022 08:55:27 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C22CA7
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 08:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m3ABMTZ0MqErW8PpbsHm9RBDGHUsM/mvFKByXoormFo=; b=SxEy3X14fIKUJuIVsOyebOtHH3
	sCqrNsrU7uE7l+o3d7nKHHDUetnw9U4hDvA6eBMxhiWfpVGpZrqJyRA0tQvp9ijhHmgKxbPW7OJ6w
	FXyUz8QAZRmZiTnwCnNeFfvf3WvAwMJTXYmqVTenYPkw+eKdFbO+WVJO5h2nwBnpsPL/EpbkwnDXd
	oiYjBb+Pv5nCVlHsD2xl6fcXaGkAp6dvS/B8COFSRJSjp0CHovZdCUqJMXgAjKRxeo68YKCsmj919
	ofA6bccFpyXfML557aIivCGOZTab0MieYiVvRV2WV5QCu2thOPA/kElA4+f8IFd8PaXb0oI22Vupu
	dzeu+kaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nATE4-009xcp-3W; Thu, 20 Jan 2022 08:55:24 +0000
Date: Thu, 20 Jan 2022 00:55:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v9 08/10] mm: Introduce mf_dax_kill_procs() for fsdax case
Message-ID: <YekjfDJOz2bXgKqv@infradead.org>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226143439.3985960-9-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please only build the new DAX code if CONFIG_FS_DAX is set.

