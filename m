Return-Path: <nvdimm+bounces-3788-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [139.178.84.19])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0E15210F7
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 May 2022 11:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 17C372E09D8
	for <lists+linux-nvdimm@lfdr.de>; Tue, 10 May 2022 09:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7280A23D6;
	Tue, 10 May 2022 09:32:47 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980423C2
	for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 09:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G7+t/cAdYkqhs1QKuzowXwkwfS2OErx0X9UCnaiTRWU=; b=VgR1nQ1NVLWRbOgBvrbdCW/4tg
	ychxbwVZwl2wzAJjDn82fADKlUzvqITtssspoU+g2VDWJfuI9SKZDpw4BVKWlWrDTU0XfqXhbQrYZ
	WKsLZ/tHz1Oj9CIASd5pspPSEvR6ACnPwg6AFRYXHa3oDOfrd5yuWvTM17QxpTXCOioNjdDjldZ6d
	vyJ2XQVtb61LMMqHRwqmMMmqq8uttx8xIsYIvQWU3SR3NetOIhVS0qBwW4byGtvMzw6EzmDwGsyuN
	QHgviNlvIN8gesVdFW+7rdefORH7XD1/y3kq+w19jJFGCFb2ZW8B+r+RVhAarU07kW0L4Y5OwN5Ss
	mMbcdJaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1noMER-000qQy-Rm; Tue, 10 May 2022 09:32:39 +0000
Date: Tue, 10 May 2022 02:32:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, naoya.horiguchi@nec.com, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <YnoxN0T/RBbxsqI7@infradead.org>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The patch numbering due looks odd due to the combination of the
two series.  But otherwise this looks good to me modulo the one
minor nitpick.

