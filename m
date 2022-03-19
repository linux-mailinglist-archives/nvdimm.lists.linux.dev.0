Return-Path: <nvdimm+bounces-3344-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 514944DE6EE
	for <lists+linux-nvdimm@lfdr.de>; Sat, 19 Mar 2022 09:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 4A58F1C09A7
	for <lists+linux-nvdimm@lfdr.de>; Sat, 19 Mar 2022 08:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A2C5391;
	Sat, 19 Mar 2022 08:14:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFC14C60
	for <nvdimm@lists.linux.dev>; Sat, 19 Mar 2022 08:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647677648; x=1679213648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5/j8SFIJOg+tuUIcMYd0AoAB00s/OJZR63GPCgz2T7U=;
  b=U4YSrE5Mg0nx1Wq/o9WH+DwwFaVml/4l3pxQVuzp7JdZb7uKR9IxDEoJ
   5FNCAnxBeWHZ8/0cNVdnhiCMY7SQqQaoTMjgdOX914n4ZGiDJG2pHu21n
   WMf8Yq3CsfZsoMq38GL68bO7lJ0kg3p8cJvItHZ4YcFpcfRdpuP8FmKYC
   fwYJPMHBwJbJyLhinsssercLcg5tz3s3T/4ZflY45p+hPMlysZxSHy4eK
   DP2iq8lt8JjYGHZqVhrvhzpBJsVWNjV2ojBaAVLsGzbB8JcIzAe9d6nyg
   KbRFn/hXQYFNeNHYZFpTgdupAGtaiy0naCVNX1KXnY5Rqa6gpjpIhZW9M
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237893098"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="237893098"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 01:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="691598370"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 19 Mar 2022 01:14:04 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nVUDr-000Fiu-9z; Sat, 19 Mar 2022 08:14:03 +0000
Date: Sat, 19 Mar 2022 16:13:44 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
	willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: kbuild-all@lists.01.org
Subject: Re: [PATCH v6 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <202203191637.PK2oJUeq-lkp@intel.com>
References: <20220319062833.3136528-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-3-jane.chu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jane,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nvdimm/libnvdimm-for-next]
[also build test WARNING on device-mapper-dm/for-next linus/master v5.17-rc8 next-20220318]
[cannot apply to tip/x86/mm]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jane-Chu/DAX-poison-recovery/20220319-143144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220319/202203191637.PK2oJUeq-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/71b9b09529b207ce15667c1f5fba4b727b6754e6
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 71b9b09529b207ce15667c1f5fba4b727b6754e6
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/mm/pat/ fs/fuse/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/mm/pat/set_memory.c:1935:5: warning: no previous prototype for 'set_mce_nospec' [-Wmissing-prototypes]
    1935 | int set_mce_nospec(unsigned long pfn, bool unmap)
         |     ^~~~~~~~~~~~~~
>> arch/x86/mm/pat/set_memory.c:1968:5: warning: no previous prototype for 'clear_mce_nospec' [-Wmissing-prototypes]
    1968 | int clear_mce_nospec(unsigned long pfn)
         |     ^~~~~~~~~~~~~~~~


vim +/set_mce_nospec +1935 arch/x86/mm/pat/set_memory.c

  1927	
  1928	#ifdef CONFIG_X86_64
  1929	/*
  1930	 * Prevent speculative access to the page by either unmapping
  1931	 * it (if we do not require access to any part of the page) or
  1932	 * marking it uncacheable (if we want to try to retrieve data
  1933	 * from non-poisoned lines in the page).
  1934	 */
> 1935	int set_mce_nospec(unsigned long pfn, bool unmap)
  1936	{
  1937		unsigned long decoy_addr;
  1938		int rc;
  1939	
  1940		/* SGX pages are not in the 1:1 map */
  1941		if (arch_is_platform_page(pfn << PAGE_SHIFT))
  1942			return 0;
  1943		/*
  1944		 * We would like to just call:
  1945		 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
  1946		 * but doing that would radically increase the odds of a
  1947		 * speculative access to the poison page because we'd have
  1948		 * the virtual address of the kernel 1:1 mapping sitting
  1949		 * around in registers.
  1950		 * Instead we get tricky.  We create a non-canonical address
  1951		 * that looks just like the one we want, but has bit 63 flipped.
  1952		 * This relies on set_memory_XX() properly sanitizing any __pa()
  1953		 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
  1954		 */
  1955		decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
  1956	
  1957		if (unmap)
  1958			rc = set_memory_np(decoy_addr, 1);
  1959		else
  1960			rc = set_memory_uc(decoy_addr, 1);
  1961		if (rc)
  1962			pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
  1963		return rc;
  1964	}
  1965	EXPORT_SYMBOL(set_mce_nospec);
  1966	
  1967	/* Restore full speculative operation to the pfn. */
> 1968	int clear_mce_nospec(unsigned long pfn)
  1969	{
  1970		return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
  1971	}
  1972	EXPORT_SYMBOL(clear_mce_nospec);
  1973	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

