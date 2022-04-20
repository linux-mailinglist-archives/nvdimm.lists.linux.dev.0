Return-Path: <nvdimm+bounces-3624-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8B8508EE1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Apr 2022 19:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 20C241C09E9
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Apr 2022 17:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F402D1873;
	Wed, 20 Apr 2022 17:53:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F31867
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 17:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D90C385A1;
	Wed, 20 Apr 2022 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1650477232;
	bh=rPJ14Ac12EFXoPf+Opo+3BFlBnnBFWwCWA10Yw/roM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DNJCvLcrczQXOR26pFils3zVtLSX+a22jx4HK/7JTzY0VRs1YnJUYbApEMP3PqiuO
	 htygMdsMH95ETCitJaEoVaHUfM7AO3em3vx2FrjIVfQLW+QjJZ8hO/BC2evMuPRso2
	 HNt6Cm9ixu01cWQrjkNlTJbny/ezw3kHmxEOcZMU4TxTOJoy07BP4YTSveRhrW5m86
	 w4m+vpYFWBy5Y6rKjRaQQoReY3y0rT6b1n0UfLvAGWJTNUhx93kzLRbXrxx3Iwm5i+
	 3vjQMEHpyrRDLyYMgIk0ADlpSsLo+uyt3DSecmRMNI6eY+hMbq3LW7M2FosswmmNPC
	 Ao9k2Wu7rcS7A==
Date: Wed, 20 Apr 2022 10:53:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v13 4/7] fsdax: Introduce dax_lock_mapping_entry()
Message-ID: <20220420175351.GX17025@magnolia>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220419045045.1664996-5-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419045045.1664996-5-ruansy.fnst@fujitsu.com>

On Tue, Apr 19, 2022 at 12:50:42PM +0800, Shiyang Ruan wrote:
> The current dax_lock_page() locks dax entry by obtaining mapping and
> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
> to lock a specific dax entry corresponding to this file's mapping,index.
> And output the page corresponding to the specific dax entry for caller
> use.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c            | 63 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 15 +++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 1ac12e877f4f..57efd3f73655 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -455,6 +455,69 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
>  	dax_unlock_entry(&xas, (void *)cookie);
>  }
>  
> +/*
> + * dax_lock_mapping_entry - Lock the DAX entry corresponding to a mapping
> + * @mapping: the file's mapping whose entry we want to lock
> + * @index: the offset within this file
> + * @page: output the dax page corresponding to this dax entry
> + *
> + * Return: A cookie to pass to dax_unlock_mapping_entry() or 0 if the entry
> + * could not be locked.
> + */
> +dax_entry_t dax_lock_mapping_entry(struct address_space *mapping, pgoff_t index,
> +		struct page **page)
> +{
> +	XA_STATE(xas, NULL, 0);
> +	void *entry;
> +
> +	rcu_read_lock();
> +	for (;;) {
> +		entry = NULL;
> +		if (!dax_mapping(mapping))
> +			break;
> +
> +		xas.xa = &mapping->i_pages;
> +		xas_lock_irq(&xas);
> +		xas_set(&xas, index);
> +		entry = xas_load(&xas);
> +		if (dax_is_locked(entry)) {
> +			rcu_read_unlock();
> +			wait_entry_unlocked(&xas, entry);
> +			rcu_read_lock();
> +			continue;
> +		}
> +		if (!entry ||
> +		    dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
> +			/*
> +			 * Because we are looking for entry from file's mapping
> +			 * and index, so the entry may not be inserted for now,
> +			 * or even a zero/empty entry.  We don't think this is
> +			 * an error case.  So, return a special value and do
> +			 * not output @page.
> +			 */
> +			entry = (void *)~0UL;

In this case we exit to the caller with the magic return value, having
not set *page.  Either the comment for this function should note that
the caller must set *page to a known value (NULL?) before the call, or
we should set *page = NULL here.

AFAICT the callers in this series initialize page to NULL before passing
in &page, so I think the comment update would be fine.

With the **page requirement documented,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +		} else {
> +			*page = pfn_to_page(dax_to_pfn(entry));
> +			dax_lock_entry(&xas, entry);
> +		}
> +		xas_unlock_irq(&xas);
> +		break;
> +	}
> +	rcu_read_unlock();
> +	return (dax_entry_t)entry;
> +}
> +
> +void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index,
> +		dax_entry_t cookie)
> +{
> +	XA_STATE(xas, &mapping->i_pages, index);
> +
> +	if (cookie == ~0UL)
> +		return;
> +
> +	dax_unlock_entry(&xas, (void *)cookie);
> +}
> +
>  /*
>   * Find page cache entry at given index. If it is a DAX entry, return it
>   * with the entry locked. If the page cache doesn't contain an entry at
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 9c426a207ba8..c152f315d1c9 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -143,6 +143,10 @@ struct page *dax_layout_busy_page(struct address_space *mapping);
>  struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
>  dax_entry_t dax_lock_page(struct page *page);
>  void dax_unlock_page(struct page *page, dax_entry_t cookie);
> +dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
> +		unsigned long index, struct page **page);
> +void dax_unlock_mapping_entry(struct address_space *mapping,
> +		unsigned long index, dax_entry_t cookie);
>  #else
>  static inline struct page *dax_layout_busy_page(struct address_space *mapping)
>  {
> @@ -170,6 +174,17 @@ static inline dax_entry_t dax_lock_page(struct page *page)
>  static inline void dax_unlock_page(struct page *page, dax_entry_t cookie)
>  {
>  }
> +
> +static inline dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
> +		unsigned long index, struct page **page)
> +{
> +	return 0;
> +}
> +
> +static inline void dax_unlock_mapping_entry(struct address_space *mapping,
> +		unsigned long index, dax_entry_t cookie)
> +{
> +}
>  #endif
>  
>  int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> -- 
> 2.35.1
> 
> 
> 

