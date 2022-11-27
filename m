Return-Path: <nvdimm+bounces-5252-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6383639C69
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Nov 2022 19:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFECF1C2093B
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Nov 2022 18:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1686AA9;
	Sun, 27 Nov 2022 18:38:24 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32BB3D61
	for <nvdimm@lists.linux.dev>; Sun, 27 Nov 2022 18:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA7C433D6;
	Sun, 27 Nov 2022 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669574302;
	bh=CYMIjb5gAdEwblJqPgCeMG3YnIc+UiEUP69wjHO+80o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bov49eJquLLRRRmcovLLKyCn5XGNT4v6cAjKYpQeQMZN6QS1FOZ1GCvIQ4K79Qc7u
	 rNph3AH9GRBVKGwSGBgmE3ypDFS4+QeCbhVnPS/gUaNXsEq9JJSVJQEznZFZGFvLwR
	 r2xvCv6vlXRWkySZ9ooh2kQyfyKmLYpvhb2o+UKJ3QE7xHJTfUvVkcqADvfLIuzDwL
	 Ql5tAoI6h07U8YEjYN3luBlaUILwEbX71G+vqYFopLnu6mIHpOWResh1kuPIeOFul4
	 MUU37iC+ujd8UPRbojG4gYzl1e2aBp1AzXgkVQ5ALtOfMgsflHzN6GYNycH7iC3ez7
	 YMNtJD1azIKEQ==
Date: Sun, 27 Nov 2022 10:38:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages
Message-ID: <Y4OuntOVjId9FLzL@magnolia>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>

On Thu, Nov 24, 2022 at 02:54:52PM +0000, Shiyang Ruan wrote:
> Many testcases failed in dax+reflink mode with warning message in dmesg.
> This also effects dax+noreflink mode if we run the test after a
> dax+reflink test.  So, the most urgent thing is solving the warning
> messages.
> 
> Patch 1 fixes some mistakes and adds handling of CoW cases not
> previously considered (srcmap is HOLE or UNWRITTEN).
> Patch 2 adds the implementation of unshare for fsdax.
> 
> With these fixes, most warning messages in dax_associate_entry() are
> gone.  But honestly, generic/388 will randomly failed with the warning.
> The case shutdown the xfs when fsstress is running, and do it for many
> times.  I think the reason is that dax pages in use are not able to be
> invalidated in time when fs is shutdown.  The next time dax page to be
> associated, it still remains the mapping value set last time.  I'll keep
> on solving it.
> 
> The warning message in dax_writeback_one() can also be fixed because of
> the dax unshare.

This cuts down the amount of test failures quite a bit, but I think
you're still missing a piece or two -- namely the part that refuses to
enable S_DAX mode on a reflinked file when the inode is being loaded
from disk.  However, thank you for fixing dax.c, because that was the
part I couldn't figure out at all. :)

--D

> 
> Shiyang Ruan (2):
>   fsdax,xfs: fix warning messages at dax_[dis]associate_entry()
>   fsdax,xfs: port unshare to fsdax
> 
>  fs/dax.c             | 166 ++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_iomap.c   |   6 +-
>  fs/xfs/xfs_reflink.c |   8 ++-
>  include/linux/dax.h  |   2 +
>  4 files changed, 129 insertions(+), 53 deletions(-)
> 
> -- 
> 2.38.1
> 

