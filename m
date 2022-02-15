Return-Path: <nvdimm+bounces-3022-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA294B5E12
	for <lists+linux-nvdimm@lfdr.de>; Tue, 15 Feb 2022 00:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 180941C0A7F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Feb 2022 23:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8C9EC1;
	Mon, 14 Feb 2022 23:13:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0660EB8
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 23:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644880395; x=1676416395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hleKJXrUDhmmOrMMCvBDlVg74DPqUhOtXuvUOdPHjK0=;
  b=O+/rkhdIqVgBsNRGQX9n2Pwm+hbEf3gVogD2bnoPniZ82wK2Mvs9gSFd
   XYuRBcxNKh/XH6eSfXi5N1gv508Vxr03AdTRHl96cs722Mxd88dGNyeL7
   AGbVhR6A/IM3baMh4wEWPNlaTaktuDRctjXMvuHCCVwetEpiTJHol0c0F
   Pe2OOglIBV9D1ysmXWYmUh28PlXqN6NZEPqpyRBvU8f5YZCzd4dVjqIRN
   v9bu6ggK6xolQ2NPm5Cx93GU0tIY9kzPXVjJBe2o44cnsNX/Fy4DyKiC/
   +KaSHy4PJVbsEbKzhTOZ73rdHOB7ILnf2WXZpqE0tZob792Wc7e1FGvl3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="249953576"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="249953576"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 15:12:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="680755418"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 15:12:56 -0800
Date: Mon, 14 Feb 2022 15:12:56 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tong Zhang <ztong0001@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: make sure inodes are flushed before destroy cache
Message-ID: <20220214231256.GX785175@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
	Tong Zhang <ztong0001@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220212071111.148575-1-ztong0001@gmail.com>
 <20220214175905.GV785175@iweiny-DESK2.sc.intel.com>
 <CAPcyv4jrh5Xr3AnOj-YrOr3i4HTm=wVBuaQ1VBAxCoszHjHdfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jrh5Xr3AnOj-YrOr3i4HTm=wVBuaQ1VBAxCoszHjHdfA@mail.gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Feb 14, 2022 at 12:09:54PM -0800, Dan Williams wrote:
> On Mon, Feb 14, 2022 at 9:59 AM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > On Fri, Feb 11, 2022 at 11:11:11PM -0800, Tong Zhang wrote:
> > > A bug can be triggered by following command
> > >
> > > $ modprobe nd_pmem && modprobe -r nd_pmem
> > >
> > > [   10.060014] BUG dax_cache (Not tainted): Objects remaining in dax_cache on __kmem_cache_shutdown()
> > > [   10.060938] Slab 0x0000000085b729ac objects=9 used=1 fp=0x000000004f5ae469 flags=0x200000000010200(slab|head|node)
> > > [   10.062433] Call Trace:
> > > [   10.062673]  dump_stack_lvl+0x34/0x44
> > > [   10.062865]  slab_err+0x90/0xd0
> > > [   10.063619]  __kmem_cache_shutdown+0x13b/0x2f0
> > > [   10.063848]  kmem_cache_destroy+0x4a/0x110
> > > [   10.064058]  __x64_sys_delete_module+0x265/0x300
> > >
> > > This is caused by dax_fs_exit() not flushing inodes before destroy cache.
> > > To fix this issue, call rcu_barrier() before destroy cache.
> >
> > I don't doubt that this fixes the bug.  However, I can't help but think this is
> > hiding a bug, or perhaps a missing step, in the kmem_cache layer?  As far as I
> > can see dax does not call call_rcu() and only uses srcu not rcu?  I was tempted
> > to suggest srcu_barrier() but dax does not call call_srcu() either.
> 
> This rcu_barrier() is associated with the call_rcu() in destroy_inode().

Ok yea.

> 
> While kern_unmount() does a full sycnrhonize_rcu() after clearing
> ->mnt_ns. Any pending destroy_inode() callbacks need to be flushed
> before the kmem_cache is destroyed.
> 
> > So I'm not clear about what is really going on and why this fixes it.  I know
> > that dax is not using srcu is a standard way so perhaps this helps in a way I
> > don't quite grok?  If so perhaps a comment here would be in order?
> 
> Looks like a common pattern I missed that all filesystem exit paths implement.

I think a comment would be in order, especially since since it looks like every
other FS has one:

fs/ext4/super.c:

...
        /*
         * Make sure all delayed rcu free inodes are flushed before we
         * destroy cache.
         */
        rcu_barrier();  
...

Anyway ok.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks for looking Dan,
Ira

