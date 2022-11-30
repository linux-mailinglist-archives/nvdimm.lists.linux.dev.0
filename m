Return-Path: <nvdimm+bounces-5333-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDB863E2B2
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 22:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D921C20970
	for <lists+linux-nvdimm@lfdr.de>; Wed, 30 Nov 2022 21:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD96D505;
	Wed, 30 Nov 2022 21:27:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A3EAD46
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 21:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810BEC433C1;
	Wed, 30 Nov 2022 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1669843646;
	bh=Me74CDiIx+Q+XRS5mMt1qSL0e6bltCo47J3Coh+n4hM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q2mXTk0p2zy6/1HD7HyVu619wMEov6pcnZ7f8uEgBh097J80RsmrYbNUTgSI9hGXV
	 MejslMnnmwGxr2BT0FwC7rwZt2PnAJF2fotqyOSsNHNb2SvDa38WclPQrHU5rL7zFg
	 TaSDMI8IAkXB1nf7HaKhlJNkUvOy4sUrgJ8gSk/A=
Date: Wed, 30 Nov 2022 13:27:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, <linux-kernel@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>, <david@fromorbit.com>
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages
Message-Id: <20221130132725.cd332f03ad3fb5902a54c919@linux-foundation.org>
In-Reply-To: <6386d512ce3fc_c9572944e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
	<6386d512ce3fc_c9572944e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Nov 2022 19:59:14 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> [ add Andrew ]
> 
> Shiyang Ruan wrote:
> > Many testcases failed in dax+reflink mode with warning message in dmesg.
> > This also effects dax+noreflink mode if we run the test after a
> > dax+reflink test.  So, the most urgent thing is solving the warning
> > messages.
> > 
> > Patch 1 fixes some mistakes and adds handling of CoW cases not
> > previously considered (srcmap is HOLE or UNWRITTEN).
> > Patch 2 adds the implementation of unshare for fsdax.
> > 
> > With these fixes, most warning messages in dax_associate_entry() are
> > gone.  But honestly, generic/388 will randomly failed with the warning.
> > The case shutdown the xfs when fsstress is running, and do it for many
> > times.  I think the reason is that dax pages in use are not able to be
> > invalidated in time when fs is shutdown.  The next time dax page to be
> > associated, it still remains the mapping value set last time.  I'll keep
> > on solving it.
> > 
> > The warning message in dax_writeback_one() can also be fixed because of
> > the dax unshare.
> 
> Thank you for digging in on this, I had been pinned down on CXL tasks
> and worried that we would need to mark FS_DAX broken for a cycle, so
> this is timely.
> 
> My only concern is that these patches look to have significant collisions with
> the fsdax page reference counting reworks pending in linux-next. Although,
> those are still sitting in mm-unstable:
> 
> http://lore.kernel.org/r/20221108162059.2ee440d5244657c4f16bdca0@linux-foundation.org

As far as I know, Dan's "Fix the DAX-gup mistake" series is somewhat
stuck.  Jan pointed out:

https://lore.kernel.org/all/20221109113849.p7pwob533ijgrytu@quack3/T/#u

or have Jason's issues since been addressed?

> My preference would be to move ahead with both in which case I can help
> rebase these fixes on top. In that scenario everything would go through
> Andrew.
> 
> However, if we are getting too late in the cycle for that path I think
> these dax-fixes take precedence, and one more cycle to let the page
> reference count reworks sit is ok.

That sounds a decent approach.  So we go with this series ("fsdax,xfs:
fix warning messages") and aim at 6.3-rc1 with "Fix the DAX-gup
mistake"?

