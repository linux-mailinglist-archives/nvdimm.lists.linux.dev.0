Return-Path: <nvdimm+bounces-1054-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 868EE3F996D
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 15:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1F0883E11A4
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Aug 2021 13:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0883FCD;
	Fri, 27 Aug 2021 13:17:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883693FC6
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 13:16:59 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id 14so7094901qkc.4
        for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 06:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Zqlt5DZ1Ie+aRGdbfLW2zyrhesPZ9ELRKv5093QWQzY=;
        b=A8ot+uWHG4LrZwrNa6kGY0narHhP5ggNFnjAilhm8jZpcFm2ioqX3LcFxnsDJVt+FF
         VvwQHbSZ/tCYA9lxuRmw5JO/KG7fMKAy01yLLAFO7fGw709UTjqRb1x86xGkPUFNuJzO
         lDrAyqzzI8iJaHo2YbTxMEbUjJc0lRCsEvMng/sjHvrqTRjS1MN6ky/CSWSIQZkh6wjV
         +qZ/1eRUZ5Sh1aab6QVbWBdk283G9EnO+/SXrg7Ci+I3HvEE4x3EFW/KiFn+49mx8zlj
         HyxScQm9yiId27Su4Pun7/2Kk6MZAGLpFMqN9FE+pt2L8XPClmEy7ph+tQ91sf2tcVl0
         69WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Zqlt5DZ1Ie+aRGdbfLW2zyrhesPZ9ELRKv5093QWQzY=;
        b=IDkIIVjV44TeYKaodly1TZ7eEzAIfB8+slA/0ADCqqUZj+IDCS58u5/nnWULI28Gy5
         nZsEMPUF+FxHoHEBKkYVfyCakZVnaX83Hgy7uHIZ90ZXN81vYNuUzRJZX+pxyk38jEFm
         ueoRlZ4BaP+nzvE02xE+4fwKeieelUTmRz0NPfWG57TIKlqwIt8qPc4LRQ6MoYg+KzfU
         PnzfVULc3x8ifx1Iq+HTRFk/kNZzJqZ2MfQYxcYRN5MUA3fxjFc+P7ey69xHAgWFoKtp
         LUtVsRyvFxjBlwNluNY5uUbQrrrKvHBigWiwLkrMKFvQaqj0jqIpJXiSt5Ad8sSAKGB+
         GYlQ==
X-Gm-Message-State: AOAM5310pxQlucfRKYpkN00YkJVYcPGTLretfu6qTcOPJlBQR1vYYCtV
	taEx/3XahfghU1Gqw78bNMpMCA==
X-Google-Smtp-Source: ABdhPJwTXS6LDXSWwyXTzKjKsscU+JjEZ5464lBBMs/dmejvN86JgWQ5uX9I9OQt4qJNt460/Ct+Lg==
X-Received: by 2002:a05:620a:1210:: with SMTP id u16mr8837124qkj.390.1630070218370;
        Fri, 27 Aug 2021 06:16:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id w18sm3322867qto.91.2021.08.27.06.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 06:16:57 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mJbj7-005giR-Ak; Fri, 27 Aug 2021 10:16:57 -0300
Date: Fri, 27 Aug 2021 10:16:57 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Li, Zhijian" <lizhijian@cn.fujitsu.com>
Cc: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	Yishai Hadas <yishaih@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
Subject: Re: RDMA/rpma + fsdax(ext4) was broken since 36f30e486d
Message-ID: <20210827131657.GI1200268@ziepe.ca>
References: <8b2514bb-1d4b-48bb-a666-85e6804fbac0@cn.fujitsu.com>
 <68169bc5-075f-8260-eedc-80fdf4b0accd@cn.fujitsu.com>
 <20210806014559.GM543798@ziepe.ca>
 <b5e6c4cd-8842-59ef-c089-2802057f3202@cn.fujitsu.com>
 <10c4bead-c778-8794-f916-80bf7ba3a56b@fujitsu.com>
 <20210827121034.GG1200268@ziepe.ca>
 <d276eeda-7f30-6c91-24cd-a40916fcc4c8@cn.fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d276eeda-7f30-6c91-24cd-a40916fcc4c8@cn.fujitsu.com>

On Fri, Aug 27, 2021 at 09:05:21PM +0800, Li, Zhijian wrote:
> 
> on 2021/8/27 20:10, Jason Gunthorpe wrote:
> > On Fri, Aug 27, 2021 at 08:15:40AM +0000, lizhijian@fujitsu.com wrote:
> > > i looked over the change-log of hmm_vma_handle_pte(), and found that before
> > > 4055062 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
> > > 
> > > hmm_vma_handle_pte() will not check pte_special(pte) if pte_devmap(pte) is true.
> > > 
> > > when we reached
> > > "if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {"
> > > the pte have already presented and its pte's flag already fulfilled the request flags.
> > > 
> > > 
> > > My question is that
> > > Per https://01.org/blogs/dave/2020/linux-consumption-x86-page-table-bits,
> > > pte_devmap(pte) and pte_special(pte) could be both true in fsdax user case, right ?
> > How? what code creates that?
> > 
> > I see:
> > 
> > insert_pfn():
> > 	/* Ok, finally just insert the thing.. */
> > 	if (pfn_t_devmap(pfn))
> > 		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
> > 	else
> > 		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
> > 
> > So what code path ends up setting both bits?
> 
>  pte_mkdevmap() will set both _PAGE_SPECIAL | PAGE_DEVMAP
> 
>  395 static inline pte_t pte_mkdevmap(pte_t pte)
>  396 {
>  397         return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
>  398 }
> 
> below is a calltrace example
> 
> [  400.728559] Call Trace:
> [  400.731595] dump_stack+0x6d/0x8b
> [  400.735536] insert_pfn+0x16c/0x180
> [  400.739596] __vm_insert_mixed+0x84/0xc0
> [  400.744144] dax_iomap_pte_fault+0x845/0x870
> [  400.749089] ext4_dax_huge_fault+0x171/0x1e0
> [  400.754096] __do_fault+0x31/0xe0
> [  400.758090]  ? pmd_devmap_trans_unstable+0x37/0x90
> [  400.763541] handle_mm_fault+0x11b1/0x1680
> [  400.768260] exc_page_fault+0x2f4/0x570
> [  400.772788]  ? asm_exc_page_fault+0x8/0x30
> [  400.777539]  asm_exc_page_fault+0x1e/0x30
> 
> 
> So is my previous change reasonable ?

Yes, can you send a proper patch and include the mm mailing list?

Jason

