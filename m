Return-Path: <nvdimm+bounces-3346-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2D84DE70D
	for <lists+linux-nvdimm@lfdr.de>; Sat, 19 Mar 2022 09:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id D36443E05CC
	for <lists+linux-nvdimm@lfdr.de>; Sat, 19 Mar 2022 08:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F85539B;
	Sat, 19 Mar 2022 08:25:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9A45391
	for <nvdimm@lists.linux.dev>; Sat, 19 Mar 2022 08:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647678309; x=1679214309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i+1zm1x8DRcSoIN75++M5iWMiGIew0eux02TG+zKjXU=;
  b=lCAyfGQKb1EYRJ3s0T/pZv/U4CH9c9HCROuuzrfGGH8x9LTX3hJ0buU9
   cxRW/tzUmhpY6j2+/FKl4kKhoydkLDXkY0a5iYbm8RMQCVrCexAdu53Nb
   mYSRd5JwQZodfZAL59IRSgOaqDU3QxIn08gpaS1xPQfkeulGzOFAUq02t
   DhVVQCtOp50IVZsUHK9Yt+TBw1xMIlHLq1GHi5JlI72vUblP2orjK6MjG
   KgCmy9T/b4kC5u4yhLTgQqgEIRUKBwwRnvIw75P86ogX+5u+/QhqjCNg8
   tL3Ha9kQ8mY+cOey9vdbCE4J8F0LVgM/Ceq1Wu71mv695dSbPvx5L3m6n
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237893611"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="237893611"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 01:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="647829406"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 19 Mar 2022 01:25:04 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nVUOV-000FjS-DO; Sat, 19 Mar 2022 08:25:03 +0000
Date: Sat, 19 Mar 2022 16:24:04 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
	willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: kbuild-all@lists.01.org
Subject: Re: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Message-ID: <202203191610.umg0CGkh-lkp@intel.com>
References: <20220319062833.3136528-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-5-jane.chu@oracle.com>
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
config: s390-randconfig-r044-20220317 (https://download.01.org/0day-ci/archive/20220319/202203191610.umg0CGkh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/203570f765a6ad07eb5809850478a25a5257f7e2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 203570f765a6ad07eb5809850478a25a5257f7e2
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash fs/fuse/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/fuse/virtio_fs.c: In function 'virtio_fs_zero_page_range':
>> fs/fuse/virtio_fs.c:774:58: warning: passing argument 4 of 'dax_direct_access' makes integer from pointer without a cast [-Wint-conversion]
     774 |         rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
         |                                                          ^~~~~~
         |                                                          |
         |                                                          void **
   In file included from fs/fuse/virtio_fs.c:8:
   include/linux/dax.h:187:21: note: expected 'int' but argument is of type 'void **'
     187 |                 int flags, void **kaddr, pfn_t *pfn);
         |                 ~~~~^~~~~
   fs/fuse/virtio_fs.c:774:14: error: too few arguments to function 'dax_direct_access'
     774 |         rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
         |              ^~~~~~~~~~~~~~~~~
   In file included from fs/fuse/virtio_fs.c:8:
   include/linux/dax.h:186:6: note: declared here
     186 | long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
         |      ^~~~~~~~~~~~~~~~~
   fs/fuse/virtio_fs.c: At top level:
   fs/fuse/virtio_fs.c:783:26: error: initialization of 'long int (*)(struct dax_device *, long unsigned int,  long int,  int,  void **, pfn_t *)' from incompatible pointer type 'long int (*)(struct dax_device *, long unsigned int,  long int,  void **, pfn_t *)' [-Werror=incompatible-pointer-types]
     783 |         .direct_access = virtio_fs_direct_access,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~
   fs/fuse/virtio_fs.c:783:26: note: (near initialization for 'virtio_fs_dax_ops.direct_access')
   cc1: some warnings being treated as errors


vim +/dax_direct_access +774 fs/fuse/virtio_fs.c

22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  767  
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  768  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  769  				     pgoff_t pgoff, size_t nr_pages)
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  770  {
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  771  	long rc;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  772  	void *kaddr;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  773  
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19 @774  	rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  775  	if (rc < 0)
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  776  		return rc;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  777  	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  778  	dax_flush(dax_dev, kaddr, nr_pages << PAGE_SHIFT);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  779  	return 0;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  780  }
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  781  

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

