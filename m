Return-Path: <nvdimm+bounces-1991-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 38788457481
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Nov 2021 17:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id BDC6D3E1036
	for <lists+linux-nvdimm@lfdr.de>; Fri, 19 Nov 2021 16:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A132E2C87;
	Fri, 19 Nov 2021 16:55:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE42C82
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 16:55:33 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id 132so10788676qkj.11
        for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 08:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j4dfJtf70H4e5UXonwq16orQKWpXO+x06fxvhJKJ7d8=;
        b=d87IlRRZKxrvd7rCs0G5HYyKNpAqIXCVJoLZSm40EGxgBivy7DVYHW9jl8PdV3f0t9
         uwh/0iLvXQfUE7gyV+yNM/B1VnvpEjlz94DfCQigJ+VVzR4T2y7neyZ1lkAmoNsCOWH6
         oTZ5n6l+382na/fld2stLaq6r5mpXpViiMsdXA+yCjNagxbTD7ViK7JyltyY4cVIWVU2
         T5fgYQWE0dQuWycS+LyQbQdaOsrC/7FUGemwET72O3Mn/EdKwGEX3ycQoJe0r801wXfw
         XgUuUYuo2ScFvmkD3BmxdnfomW4S3/fBTbfTxFKjmhk7E+ZAgCVCyg+IkHNk6QUPHgiv
         FYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4dfJtf70H4e5UXonwq16orQKWpXO+x06fxvhJKJ7d8=;
        b=nfksuTeINbVDqoIUJE5yQZfvIKIC80vh5t1ykdpfMSzBi6j34lWfqhwdAr3waDe0CT
         qTsVFTg7jLsfQ5RjaX3PBPD4IDBEWfWyW37KTsis0Iw/yT6vg/LY89Q84Z4mZy3X/z8d
         L/E3bkdiWPZVJf40QEhDaC1neAUe3yMuYTWMiEu45ChZkHCaz5kO4hJzBKE5vuruWbmH
         IfgLwN0jn9ijdVvsvXdZo/Z1KQ4yJb735Q+K7igAzGus+l2JFbWUvb7fiePVDnSmeULg
         0ViNx+CoWQsAo1+3BnJtdSejmiN6ekN809oJn+laIDdAPXzWnk8MWZp8DNb0kS3SLft/
         anDw==
X-Gm-Message-State: AOAM530Kz5N/mD+KydwgAYCHNS0e8X+1QP0/mntT2VAsCnUnLZ2F2JoV
	xRh6WTsMbfrB8ToWGK9izwSTQA==
X-Google-Smtp-Source: ABdhPJxfzDa4XFzVN+Q5DxUZdjyMbl60WnM/StRJKUaZ2kCpuPhcN98F/USjrTo6H/4XkB1Jf6THKw==
X-Received: by 2002:a05:620a:2805:: with SMTP id f5mr29033952qkp.151.1637340932761;
        Fri, 19 Nov 2021 08:55:32 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id k8sm123840qko.130.2021.11.19.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:55:31 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mo7Ag-00CLb6-N5; Fri, 19 Nov 2021 12:55:30 -0400
Date: Fri, 19 Nov 2021 12:55:30 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Message-ID: <20211119165530.GJ876299@ziepe.ca>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-9-joao.m.martins@oracle.com>
 <20211112153404.GD876299@ziepe.ca>
 <01f36268-4010-ecea-fee5-c128dd8bb179@oracle.com>
 <20211115164909.GF876299@ziepe.ca>
 <4d74bfb8-2cff-237b-321b-05aff34c1e5d@oracle.com>
 <3b7f9516-a35a-e46e-83d4-3059a959d221@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b7f9516-a35a-e46e-83d4-3059a959d221@oracle.com>

On Fri, Nov 19, 2021 at 04:12:18PM +0000, Joao Martins wrote:

> > Dan, any thoughts (see also below) ? You probably hold all that
> > history since its inception on commit 2232c6382a4 ("device-dax: Enable page_mapping()")
> > and commit 35de299547d1 ("device-dax: Set page->index").
> > 
> Below is what I have staged so far as a percursor patch (see below scissors mark).
> 
> It also lets me simplify compound page case for __dax_set_mapping() in this patch,
> like below diff.
> 
> But I still wonder whether this ordering adjustment of @mapping setting is best placed
> as a percursor patch whenever pgmap/page refcount changes happen. Anyways it's just a
> thought.

naively I would have thought you'd set the mapping on all pages when
you create the address_space and allocate pages into it. AFAIK devmap
assigns all pages to a single address_space, so shouldn't the mapping
just be done once?

Jason

