Return-Path: <nvdimm+bounces-3156-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id B38C14C5CA8
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 16:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 778003E0F2D
	for <lists+linux-nvdimm@lfdr.de>; Sun, 27 Feb 2022 15:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F574A88;
	Sun, 27 Feb 2022 15:47:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D084A83
	for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645976871; x=1677512871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7b9BDhbjud7dhVrRlKFY10rdSWsGIJjgZpLuh4LfgKA=;
  b=I4XkLaScbl6iVYjejqNU+sd9KvfNxPFrcF7zEleBqca9ncQxxXDTux7o
   ozlW4XCMy94G+IxVJ06/TQcBvwV7HqOqXcmezjlXwkZcqrbOBpMXES/9F
   s/d/2UllhF1yf0UHfFd9aSJqoWfY3VNu1NK1VXacSQ7gpFMxh1PHIZKyi
   SXh0Ba2vR/UoM/16zL2uGSknGALX6IiPgpe07+vazVlf9z39xUGSoMVww
   81Lp/DqLabvzNawVF6tLi45Pa2xNtKyEq1rooBSLUz0KnPjLNVRUtgioF
   aY5D0hr+TpkSARIq+K0EcpUmAResQEbsTtIS7+CDobWWdbs9is42N8s9l
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="232717490"
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="232717490"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 07:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="640629548"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Feb 2022 07:47:36 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nOLln-0006aw-Er; Sun, 27 Feb 2022 15:47:35 +0000
Date: Sun, 27 Feb 2022 23:46:56 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v11 7/8] xfs: Implement ->notify_failure() for XFS
Message-ID: <202202272331.SP0o3f9L-lkp@intel.com>
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
config: riscv-randconfig-p001-20220227 (https://download.01.org/0day-ci/archive/20220227/202202272331.SP0o3f9L-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
        git checkout 9f4bfbd2bae60e9f172e0b7332b2af32aa5baa87
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   riscv64-linux-ld: fs/xfs/xfs_buf.o: in function `.L828':
>> xfs_buf.c:(.text+0x3f7c): undefined reference to `dax_unregister_holder'
   riscv64-linux-ld: fs/xfs/xfs_notify_failure.o: in function `xfs_dax_notify_failure':
>> xfs_notify_failure.c:(.text+0x2b0): undefined reference to `dax_holder'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

