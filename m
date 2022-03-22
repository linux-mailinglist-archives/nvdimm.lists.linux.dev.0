Return-Path: <nvdimm+bounces-3355-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B1D4E3AC5
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Mar 2022 09:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 599521C0648
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Mar 2022 08:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEEBA34;
	Tue, 22 Mar 2022 08:37:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11FFA31
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dM4Devf9AxYRsJbry+GdljYWNC1RVwNRs/wmrQdV5X0=; b=F7D+qgEn0hYzxLExaBQdxlCTo7
	+Nzq36CHgpBmxsqxnHpmCLkzUrhOvePCCPAWtfbSGjKobx5cSHnL74IWm0cFRv8z+kJaFY0fDCbPD
	XmS2uP+/64IE9eeKEUHpwXN3RTN0Epc9SfCmR81EfmjgDaG6RdRPh4zbxoC4/kuEv/C+wS0KpGpof
	PllcHUQ46QDdKv/LYXQggc87GTszPdWrb5EEkEcVllPvuBFDNbdQzl7SzFECUcQ+XfE4qpFlCBV7X
	WFSz3lzoTDVpRPg+1VXBTlioMvfgERhyIoFAmmDcPo4TyCPy9aeGsKAZ06Kv2hUubDr5goafl6Lq8
	jPxEabuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWa1J-00ARWh-66; Tue, 22 Mar 2022 08:37:37 +0000
Date: Tue, 22 Mar 2022 01:37:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com, smuchun@gmail.com
Subject: Re: [PATCH v5 5/6] dax: fix missing writeprotect the pte entry
Message-ID: <YjmK0aaCu/FI/t7T@infradead.org>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <20220318074529.5261-6-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074529.5261-6-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static void dax_entry_mkclean(struct address_space *mapping, unsigned long pfn,
> +			      unsigned long npfn, pgoff_t start)
>  {
>  	struct vm_area_struct *vma;
> +	pgoff_t end = start + npfn - 1;
>  
>  	i_mmap_lock_read(mapping);
> +	vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
> +		pfn_mkclean_range(pfn, npfn, start, vma);
>  		cond_resched();
>  	}
>  	i_mmap_unlock_read(mapping);


Is there any point in even keeping this helper vs just open coding it
in the only caller below?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

