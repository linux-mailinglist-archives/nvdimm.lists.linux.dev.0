Return-Path: <nvdimm+bounces-3472-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A52634FAF9A
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 20:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 157E11C0C58
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 18:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB6A138C;
	Sun, 10 Apr 2022 18:58:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9E6ED0
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 18:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649617098; x=1681153098;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IdHg/Ig/+ixkBlzgiOkyOvi9xgI0/Xn8sOZpY2V2oac=;
  b=dcFNJkROxLaUUQVibVXL2Os1iUj1/JnYavA3BZRvUmxVaYBUItB7FanN
   xnSjK+SVhkMCxGOgmIkEW18A8ICPd/25rVO5Mbnib3zTyhZbSHVH0oAtF
   w7g7KuZYK7yv+TcJqbk5bj76udG5Hr9BWTxjPZBqiD78RCBKWFjYJ52Qp
   xztzSmCq/cbiGQBI8SwefTB0Fio/r8+CyPfanVADd7FjVRkzi7YBcgick
   cP0yy3eR+BXjhv1MrezMgo+Is9G3MOALySHhzrYFvoFEAmYsz++Hfy5tw
   aReCaTqcyOHZlqpKwjrheQfSbSvi0viYSzKIq0UygeUf3TjMBKSUqDASB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="324902491"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="324902491"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 11:58:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="643813247"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2022 11:58:14 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
	(envelope-from <lkp@intel.com>)
	id 1ndclJ-00012d-Um;
	Sun, 10 Apr 2022 18:58:13 +0000
Date: Mon, 11 Apr 2022 02:58:09 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v12 6/7] xfs: Implement ->notify_failure() for XFS
Message-ID: <202204110240.oa3G7lsW-lkp@intel.com>
References: <20220410160904.3758789-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-7-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Shiyang,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on hnaz-mm/master]
[also build test ERROR on next-20220408]
[cannot apply to xfs-linux/for-next linus/master linux/master v5.18-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220411-001048
base:   https://github.com/hnaz/linux-mm master
config: s390-defconfig (https://download.01.org/0day-ci/archive/20220411/202204110240.oa3G7lsW-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/bf68be0c39b8ecc4223b948a9ee126af167d74f0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220411-001048
        git checkout bf68be0c39b8ecc4223b948a9ee126af167d74f0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   s390-linux-ld: fs/xfs/xfs_buf.o: in function `xfs_alloc_buftarg':
>> fs/xfs/xfs_buf.c:1968: undefined reference to `xfs_dax_holder_operations'
   pahole: .tmp_vmlinux.btf: No such file or directory
   .btf.vmlinux.bin.o: file not recognized: file format not recognized


vim +1968 fs/xfs/xfs_buf.c

  1955	
  1956	struct xfs_buftarg *
  1957	xfs_alloc_buftarg(
  1958		struct xfs_mount	*mp,
  1959		struct block_device	*bdev)
  1960	{
  1961		xfs_buftarg_t		*btp;
  1962	
  1963		btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
  1964	
  1965		btp->bt_mount = mp;
  1966		btp->bt_dev =  bdev->bd_dev;
  1967		btp->bt_bdev = bdev;
> 1968		btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off, mp,
  1969						    &xfs_dax_holder_operations);
  1970	
  1971		/*
  1972		 * Buffer IO error rate limiting. Limit it to no more than 10 messages
  1973		 * per 30 seconds so as to not spam logs too much on repeated errors.
  1974		 */
  1975		ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
  1976				     DEFAULT_RATELIMIT_BURST);
  1977	
  1978		if (xfs_setsize_buftarg_early(btp, bdev))
  1979			goto error_free;
  1980	
  1981		if (list_lru_init(&btp->bt_lru))
  1982			goto error_free;
  1983	
  1984		if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
  1985			goto error_lru;
  1986	
  1987		btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
  1988		btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
  1989		btp->bt_shrinker.seeks = DEFAULT_SEEKS;
  1990		btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
  1991		if (register_shrinker(&btp->bt_shrinker))
  1992			goto error_pcpu;
  1993		return btp;
  1994	
  1995	error_pcpu:
  1996		percpu_counter_destroy(&btp->bt_io_count);
  1997	error_lru:
  1998		list_lru_destroy(&btp->bt_lru);
  1999	error_free:
  2000		kmem_free(btp);
  2001		return NULL;
  2002	}
  2003	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

