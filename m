Return-Path: <nvdimm+bounces-2507-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 81FE04949D3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 09:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id AF5191C0A4D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 20 Jan 2022 08:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002442CAC;
	Thu, 20 Jan 2022 08:47:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB9C2CA7
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 08:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7GM0HQf9tPss24x1/mYICgALcB2ZyBdjeGTVOCICW9E=; b=eL9BOsWNbgECzttqklZYLdsSej
	v6CLpdwxnbZTGfeAsDpcDIJA0F9xwMJcOsdBch5qvVDMdgpYU0V7A3xTI60TXrnsJ2XbOSs54uBCA
	BwW/N13hfhrnbf6BYY/ZKy+5joy0zxM64YW89SeJjiu4Qswv42/RhTGli0tb18hGZ3XnOkKx/MLaQ
	JsuQSgBe/GG+pPRC1KuHXaqIlzc7FaDRxb+zXyDOpOL6SiEQ1pxR4jd2TNk6aFhnqcGpdXOcZ9aIz
	t/+qNmK1OkOpMrIzKa5RSba26vzKY0JzRWV4U5M0AzpgeL1BuDyH0zttuu2oF5DDe/FIZ/oIScpWX
	iM9DU0qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nAT62-009tcm-2s; Thu, 20 Jan 2022 08:47:06 +0000
Date: Thu, 20 Jan 2022 00:47:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v9 05/10] fsdax: fix function description
Message-ID: <YekhisDyJUmF/cQI@infradead.org>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226143439.3985960-6-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 26, 2021 at 10:34:34PM +0800, Shiyang Ruan wrote:
> The function name has been changed, so the description should be updated
> too.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Dan, can you send this to Linux for 5.17 so that we can get it out of
the way?

