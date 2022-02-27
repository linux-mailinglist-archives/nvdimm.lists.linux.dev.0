Return-Path: <nvdimm+bounces-3154-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 476024C5BDF
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 15:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id C8C583E0FF3
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 14:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DE448CF;
	Sun, 27 Feb 2022 14:05:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F38323A
	for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645970738; x=1677506738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7Na9jV/JaJdKSHTdHA9OjHjzc4QU+Y7l02g7Nwi+qMM=;
  b=PEGTURFqMP7AE9QojVWqET+o8FMIpHzDVfJ4pImKdFaqVQvUzQo74zrF
   CiVBHzYpRI4XMZWvGJ8C0GdPwKvawHI4UbpmX3EmULThboNjr/e5lpIjl
   0xtqkLc+ZJPTN+qAKtTPqChQZYHO0v/3on3vBuQcethjTmIYOx7lmVz9H
   gLovvB4yaaOZExz9U+ve8ksXMfnQV6K+obzbDMrMHaHTzjvWlkbn9re7P
   sMlAiwbGu/hKbbTUoAyw4+sUS9g12SGbVLf+kJFNGd3BdQp51Man+yTgQ
   r22NR5bkKWMu3VR/6A5RBkxt9xpef6UDwU6eaxu0dUehHao5StWgbRhEO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10270"; a="252466237"
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="252466237"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 06:05:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="708357100"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2022 06:05:34 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nOKB3-0006Xh-VQ; Sun, 27 Feb 2022 14:05:33 +0000
Date: Sun, 27 Feb 2022 22:05:14 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v11 7/8] xfs: Implement ->notify_failure() for XFS
Message-ID: <202202272203.U7VlQY3B-lkp@intel.com>
References: <20220227120747.711169-8-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227120747.711169-8-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Shiyang,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linux/master]
[cannot apply to hnaz-mm/master linus/master v5.17-rc5 next-20220225]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220227/202202272203.U7VlQY3B-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
        git checkout 9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: fs/xfs/xfs_buf.o: in function `xfs_free_buftarg':
>> fs/xfs/xfs_buf.c:1897: undefined reference to `dax_unregister_holder'
   ld: fs/xfs/xfs_notify_failure.o: in function `xfs_dax_notify_failure':
>> fs/xfs/xfs_notify_failure.c:187: undefined reference to `dax_holder'


vim +1897 fs/xfs/xfs_buf.c

  1885	
  1886	void
  1887	xfs_free_buftarg(
  1888		struct xfs_buftarg	*btp)
  1889	{
  1890		unregister_shrinker(&btp->bt_shrinker);
  1891		ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
  1892		percpu_counter_destroy(&btp->bt_io_count);
  1893		list_lru_destroy(&btp->bt_lru);
  1894	
  1895		blkdev_issue_flush(btp->bt_bdev);
  1896		if (btp->bt_daxdev)
> 1897			dax_unregister_holder(btp->bt_daxdev, btp->bt_mount);
  1898		fs_put_dax(btp->bt_daxdev);
  1899	
  1900		kmem_free(btp);
  1901	}
  1902	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

