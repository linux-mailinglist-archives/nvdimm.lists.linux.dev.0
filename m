Return-Path: <nvdimm+bounces-3474-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4F94FB00C
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 22:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 055A41C0C4E
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 20:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EC21394;
	Sun, 10 Apr 2022 20:20:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE51389
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 20:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649622019; x=1681158019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UscGsrAGjlAv+f9uzKoiFn5jCFB2+hLMUS0kEAG2tv4=;
  b=emzhzkohq7O8A6is5C32vp/3SZC+qmJjNbtPlGh06raDq5QGL1exn75+
   TPz0Kdd4ePo1FB2z50mYqj15gk4ayu6hF5M3WI8a63dms4MwOGZnqz8Z8
   SDNFvmr7ww6ETzq7R6WRTHEtO+oTFQ8+MUR2aXYB5cXuf70rWSKmwmNlx
   xGOp6a+lGuy3C76fs3+M/lvhWiWp+f1yQ3bt84prp/F5Z3CEq3Kriieti
   3670dIcLnE1/bmDgWjC+x8vGjVVSsbFFiz4Prw0Nv0Cqq7U13p/0gLT81
   wvSoE9DJdEyMcCiMLeSna1Ac5265O5mHw0rnAwrV22Kh1x13Tmjvz3pR9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="286999774"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="286999774"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 13:20:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="699115255"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 10 Apr 2022 13:20:16 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
	(envelope-from <lkp@intel.com>)
	id 1nde2h-000159-MD;
	Sun, 10 Apr 2022 20:20:15 +0000
Date: Mon, 11 Apr 2022 04:19:41 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v12 2/7] mm: factor helpers for memory_failure_dev_pagemap
Message-ID: <202204110420.O844CZYb-lkp@intel.com>
References: <20220410160904.3758789-3-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-3-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Shiyang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on hnaz-mm/master]
[also build test WARNING on next-20220408]
[cannot apply to xfs-linux/for-next linus/master linux/master v5.18-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220411-001048
base:   https://github.com/hnaz/linux-mm master
config: x86_64-randconfig-a011 (https://download.01.org/0day-ci/archive/20220411/202204110420.O844CZYb-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/9ab00d3f6d4d9d3d2e4446480567af17c8726bd2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220411-001048
        git checkout 9ab00d3f6d4d9d3d2e4446480567af17c8726bd2
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   mm/memory-failure.c: In function 'mf_generic_kill_procs':
>> mm/memory-failure.c:1533:13: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
    1533 |         int rc = 0;
         |             ^~


vim +/rc +1533 mm/memory-failure.c

  1526	
  1527	static int mf_generic_kill_procs(unsigned long long pfn, int flags,
  1528			struct dev_pagemap *pgmap)
  1529	{
  1530		struct page *page = pfn_to_page(pfn);
  1531		LIST_HEAD(to_kill);
  1532		dax_entry_t cookie;
> 1533		int rc = 0;
  1534	
  1535		/*
  1536		 * Pages instantiated by device-dax (not filesystem-dax)
  1537		 * may be compound pages.
  1538		 */
  1539		page = compound_head(page);
  1540	
  1541		/*
  1542		 * Prevent the inode from being freed while we are interrogating
  1543		 * the address_space, typically this would be handled by
  1544		 * lock_page(), but dax pages do not use the page lock. This
  1545		 * also prevents changes to the mapping of this pfn until
  1546		 * poison signaling is complete.
  1547		 */
  1548		cookie = dax_lock_page(page);
  1549		if (!cookie)
  1550			return -EBUSY;
  1551	
  1552		if (hwpoison_filter(page)) {
  1553			rc = -EOPNOTSUPP;
  1554			goto unlock;
  1555		}
  1556	
  1557		if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
  1558			/*
  1559			 * TODO: Handle HMM pages which may need coordination
  1560			 * with device-side memory.
  1561			 */
  1562			return -EBUSY;
  1563		}
  1564	
  1565		/*
  1566		 * Use this flag as an indication that the dax page has been
  1567		 * remapped UC to prevent speculative consumption of poison.
  1568		 */
  1569		SetPageHWPoison(page);
  1570	
  1571		/*
  1572		 * Unlike System-RAM there is no possibility to swap in a
  1573		 * different physical page at a given virtual address, so all
  1574		 * userspace consumption of ZONE_DEVICE memory necessitates
  1575		 * SIGBUS (i.e. MF_MUST_KILL)
  1576		 */
  1577		flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
  1578		collect_procs(page, &to_kill, true);
  1579	
  1580		unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
  1581	unlock:
  1582		dax_unlock_page(page, cookie);
  1583		return 0;
  1584	}
  1585	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

