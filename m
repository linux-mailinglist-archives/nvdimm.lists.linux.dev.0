Return-Path: <nvdimm+bounces-3475-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B474FB0EB
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Apr 2022 01:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 297301C09C2
	for <lists+linux-nvdimm@lfdr.de>; Sun, 10 Apr 2022 23:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C8933C0;
	Sun, 10 Apr 2022 23:55:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDFD1843
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 23:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649634902; x=1681170902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Mx4eKFVr0fQGB09ANO23LBc1IXsd9gKMI9x9LYS73M=;
  b=LNb5ZL84tjldElOS+0guow77CiFCLXnUqkVR6Cby4rVOSgrkGy65lNqE
   yxcDqIPbOOqHuXLujgigi8CSDinL6JDRsPbpeFUlfeQfdVWy7hI7lFmig
   D/wrb750kQHivH/5XneoK1YfIiXlNg4PlKe7jc65hr8xV+gNQa38t8v7w
   SCbvfjQVk1NRTRxUbEKbd0hITLLph8/DzndZDoY5s99K93M29Lztzkr9n
   9wPB4V2uZlxxhaDIq7Cgj8IHhJLxFh10IWfjTUHkNoudm05tHfTIa+ber
   SuLRAoMxCEjl+oD0b6dek47+kLifpLtwItFzqoYnFl8FJIe3RLxciKYyR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="348439700"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="348439700"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 16:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="853691241"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2022 16:54:58 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
	(envelope-from <lkp@intel.com>)
	id 1ndhOU-0001CJ-3b;
	Sun, 10 Apr 2022 23:54:58 +0000
Date: Mon, 11 Apr 2022 07:54:32 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v12 6/7] xfs: Implement ->notify_failure() for XFS
Message-ID: <202204110700.66Eh1XZg-lkp@intel.com>
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
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20220411/202204110700.66Eh1XZg-lkp@intel.com/config)
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
>> xfs_buf.c:(.text+0x9920): undefined reference to `xfs_dax_holder_operations'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

