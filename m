Return-Path: <nvdimm+bounces-3155-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A864C5C9D
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 16:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D96171C0C4E
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 15:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFF64A86;
	Sun, 27 Feb 2022 15:37:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70F2F27;
	Sun, 27 Feb 2022 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645976266; x=1677512266;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mqCX4AW2IZqk1TLXjEmwfMcxPfAOyzMgK8vuXtCajik=;
  b=GMlH+0vJbhWW3msywEMzVxL12bO7VRk8rDgkjm5bYsRDxS51Bd9UXvXk
   LGDWeE4n+H9y9URFDvVXZmOP2kQ6ZJpNGBaGkRWBsv52yPuXIMwnCOCtF
   3Ve4xUxTHLwf0xIdvBtrUo6mTZj9iBtD0GMHm9VDOPkEMN8av46SWIXLX
   isTZYHOh8W6uscJT8S4aj/39QMoVSlxPXwwOpvJZrlUtMk4LK397MrPJI
   U70kXnGxuX9AZ2WFBGy/NKlgjh2vayIAH8WGfMmCjLcHXj9k4omNrQ3lb
   VaWUJjmGuhTc/YUzzunnUtc6W/jCBYX/Eu5BhgH/6gOXZA3u3Ej5IyxZx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10270"; a="232716882"
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="232716882"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 07:37:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="507170607"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2022 07:37:35 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nOLc7-0006aE-7F; Sun, 27 Feb 2022 15:37:35 +0000
Date: Sun, 27 Feb 2022 23:36:38 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v11 7/8] xfs: Implement ->notify_failure() for XFS
Message-ID: <202202272333.bhLvmuHF-lkp@intel.com>
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
config: hexagon-buildonly-randconfig-r005-20220227 (https://download.01.org/0day-ci/archive/20220227/202202272333.bhLvmuHF-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
        git checkout 9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: dax_unregister_holder
   >>> referenced by xfs_buf.c
   >>> xfs/xfs_buf.o:(xfs_free_buftarg) in archive fs/built-in.a
   >>> referenced by xfs_buf.c
   >>> xfs/xfs_buf.o:(xfs_free_buftarg) in archive fs/built-in.a
--
>> ld.lld: error: undefined symbol: dax_holder
   >>> referenced by xfs_notify_failure.c
   >>> xfs/xfs_notify_failure.o:(xfs_dax_notify_failure) in archive fs/built-in.a
   >>> referenced by xfs_notify_failure.c
   >>> xfs/xfs_notify_failure.o:(xfs_dax_notify_failure) in archive fs/built-in.a

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

