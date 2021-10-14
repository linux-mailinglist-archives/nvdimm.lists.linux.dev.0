Return-Path: <nvdimm+bounces-1547-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE0142E202
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Oct 2021 21:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id AE5851C0F62
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Oct 2021 19:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218AE2C85;
	Thu, 14 Oct 2021 19:24:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA2272
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 19:24:50 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954A6611CC;
	Thu, 14 Oct 2021 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1634239490;
	bh=/k5KYCjk5tBAznS4xo9xEcQ0vWOZVh8Gj3SS5M1JqdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u2nJBb+NcNRXUNZln3GTsnxIJozf4aDRJsh+TkJ6pI8fKn9Om8o1gA7/ZrmTHjJGr
	 ODJSgnw1b6EucFSq8fokmlVDzZtcLOO1QizNQ7I20DSwPqlpuvzwsBrszozzwTOXg2
	 EiPQK8u9h5L1tDfwE8Aq+5I16og4Zf62C7mhWS5biFExqQUPZspiBfqKiFJ1uCuQg8
	 88+jsbbSQiOiLlslxGXEH51nupTh7ROBSOuHQG9Ys//HCWfAt0rEDgbgyxzh0b+3zP
	 O/gvbdPvykkXtFqfSLOdjpRXMRc/Ati3KOuhb4FoKLGFKBq4baBd7ZrzB8eRecf9xc
	 H6bley9Eo1T4Q==
Date: Thu, 14 Oct 2021 12:24:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v7 8/8] fsdax: add exception for reflinked files
Message-ID: <20211014192450.GJ24307@magnolia>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
 <20210924130959.2695749-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924130959.2695749-9-ruansy.fnst@fujitsu.com>

On Fri, Sep 24, 2021 at 09:09:59PM +0800, Shiyang Ruan wrote:
> For reflinked files, one dax page may be associated more than once with
> different fime mapping and index.  It will report warning.  Now, since
> we have introduced dax-RMAP for this case and also have to keep its
> functionality for other filesystems who are not support rmap, I add this
> exception here.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 2536c105ec7f..1a57211b1bc9 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -352,9 +352,10 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  	for_each_mapped_pfn(entry, pfn) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		WARN_ON_ONCE(page->mapping);
> -		page->mapping = mapping;
> -		page->index = index + i++;
> +		if (!page->mapping) {
> +			page->mapping = mapping;
> +			page->index = index + i++;

It feels a little dangerous to have page->mapping for shared storage
point to an actual address_space when there are really multiple
potential address_spaces out there.  If the mm or dax folks are ok with
doing this this way then I'll live with it, but it seems like you'd want
to leave /some/ kind of marker once you know that the page has multiple
owners and therefore regular mm rmap via page->mapping won't work.

--D

> +		}
>  	}
>  }
>  
> @@ -370,9 +371,10 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  		struct page *page = pfn_to_page(pfn);
>  
>  		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> -		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
> -		page->mapping = NULL;
> -		page->index = 0;
> +		if (page->mapping == mapping) {
> +			page->mapping = NULL;
> +			page->index = 0;
> +		}
>  	}
>  }
>  
> -- 
> 2.33.0
> 
> 
> 

