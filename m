Return-Path: <nvdimm+bounces-3734-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDCF051348E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Apr 2022 15:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A566280ABB
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Apr 2022 13:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4010FEDE;
	Thu, 28 Apr 2022 13:09:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83564A3F
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 13:09:37 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 960D31EC04A6;
	Thu, 28 Apr 2022 15:09:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1651151370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=AZZoBR+MifOMfzpc2UaQXWXUtdGp5oejb9lwzXknN14=;
	b=YnotU1aVf2LVp6eHrZ4SvHyz1x/qggcQnfrKqLeECCiZH98kafs2LrLeGP8gIPG32sELFY
	cmmTBHwZNLqFvIyTDwKc/7JM/FwafuvK2fxVlVClL8amkJjpxNRLFYAGTiyTonTquX1PKm
	nAilvE/+vpeRCp7bKBu9Nq0dkU3sJYw=
Date: Thu, 28 Apr 2022 15:09:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, hch@infradead.org, dave.hansen@intel.com,
	peterz@infradead.org, luto@kernel.org, david@fromorbit.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	x86@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com
Subject: Re: [PATCH v9 2/7] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <YmqSC9K10Jlm5VFG@zn.tnic>
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220422224508.440670-3-jane.chu@oracle.com>

On Fri, Apr 22, 2022 at 04:45:03PM -0600, Jane Chu wrote:
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
> 
> While at it, fixup a function name in a comment.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 49 ++++++++++++++++++++++++++++-
>  include/linux/set_memory.h        |  8 ++---
>  3 files changed, 52 insertions(+), 57 deletions(-)

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

