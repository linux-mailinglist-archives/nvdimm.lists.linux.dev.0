Return-Path: <nvdimm+bounces-5906-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A52A46CAFE4
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Mar 2023 22:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F5301C20939
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Mar 2023 20:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A52749F;
	Mon, 27 Mar 2023 20:24:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E77468
	for <nvdimm@lists.linux.dev>; Mon, 27 Mar 2023 20:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79299C4339C;
	Mon, 27 Mar 2023 20:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679948690;
	bh=N1WaErzy1aVrss+F2Tlq1e+e984QICgfVMB42UQuv/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b7ZC1e0rUfVUTI8qESO2ggXs1Z771nCiXAtpckba3SE1FkHYbuPf3FYmJybIDLZ/n
	 v++d9p2fLpS+QRbGM4XsvtNS/OprMVctCp3VYvWZSWZfasLLonROFN/LQ0oobNDVlV
	 lL6P7oViw+Is2VoYMQPfthpQVys5NHrvTq7gOQxI=
Date: Mon, 27 Mar 2023 13:24:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-xfs@vger.kernel.org>, <dan.j.williams@intel.com>,
 <willy@infradead.org>, <jack@suse.cz>, <djwong@kernel.org>
Subject: Re: [PATCH] fsdax: force clear dirty mark if CoW
Message-Id: <20230327132449.b7389c3c00602b8e0e0d8d3f@linux-foundation.org>
In-Reply-To: <05b9f49f-16ce-be40-4d42-049f8b3825c5@fujitsu.com>
References: <1679653680-2-1-git-send-email-ruansy.fnst@fujitsu.com>
	<20230324124242.c881cf384ab8a37716850413@linux-foundation.org>
	<05b9f49f-16ce-be40-4d42-049f8b3825c5@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 27 Mar 2023 11:19:01 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> 
> 
> 在 2023/3/25 3:42, Andrew Morton 写道:
> > On Fri, 24 Mar 2023 10:28:00 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > 
> >> XFS allows CoW on non-shared extents to combat fragmentation[1].  The
> >> old non-shared extent could be mwrited before, its dax entry is marked
> >> dirty.  To be able to delete this entry, clear its dirty mark before
> >> invalidate_inode_pages2_range().
> > 
> > What are the user-visible runtime effects of this flaw?
> 
> This bug won't leak or mess up the data of filesystem.  In dmesg it will 
> show like this:
> 
> [   28.512349] ------------[ cut here ]------------
> [   28.512622] WARNING: CPU: 2 PID: 5255 at fs/dax.c:390 
> dax_insert_entry+0x342/0x390
> 
> ...
>
>  >
>  > Are we able to identify a Fixes: target for this?  Perhaps
>  > f80e1668888f3 ("fsdax: invalidate pages when CoW")?
>  >
> 
> Yes, it is to fix this commit.

OK, thanks.  I added the extra changelog info, added the Fixes and a
cc:stable.

Some review from other fsdax developers would be helpful, please.


