Return-Path: <nvdimm+bounces-4642-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFE95AC55A
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Sep 2022 18:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E44B9280BE6
	for <lists+linux-nvdimm@lfdr.de>; Sun,  4 Sep 2022 16:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A2B33E3;
	Sun,  4 Sep 2022 16:18:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F401333DF;
	Sun,  4 Sep 2022 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662308289; x=1693844289;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+dB9LL7EeJed87igxILfGGCGqx09Wbnoy3k0RadLndU=;
  b=UoTfryXHIFBxahAwcsZ+kjU2lWjywxSspAZNI49VEZvQj9Gx7OA0BU2o
   tbdt56oxDUOQ1zzPmLQzQLG2/a5Qc9qKN4adNmMfisF6z7EpB6MtZoyjh
   6pmjnF7ZQBCVz61Bltsm05Hz4kKvTRynGFQD8XwBgf6z2zkLwn7hqSfHU
   mQjCVsZ3I4ldj49EqAJovOuDiOu6PkA6IUfy9ARy8aw47fIBC/Uq3wn0j
   GX3kM6Ia/GCRGZm4+hkizilrf0qXCmTwaYaA9kMpFwilSfeRLt5SrHNJP
   8pmJtSre8qLmu7l+Olmntc4jsOglnBFiM6XJn+cbCauJSqCPUkiTigb9K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="357968565"
X-IronPort-AV: E=Sophos;i="5.93,289,1654585200"; 
   d="scan'208";a="357968565"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 09:18:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,289,1654585200"; 
   d="scan'208";a="941847924"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 04 Sep 2022 09:18:06 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1oUsJy-0003Eh-0u;
	Sun, 04 Sep 2022 16:18:06 +0000
Date: Mon, 5 Sep 2022 00:17:35 +0800
From: kernel test robot <lkp@intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] nvdimm: Avoid wasting some memory.
Message-ID: <202209050000.tAI7TSe5-lkp@intel.com>
References: <8355cb2b720f8cd0f1315b06d70b541ba38add30.1662299370.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355cb2b720f8cd0f1315b06d70b541ba38add30.1662299370.git.christophe.jaillet@wanadoo.fr>

Hi Christophe,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v6.0-rc3]
[also build test WARNING on linus/master next-20220901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-JAILLET/nvdimm-Avoid-wasting-some-memory/20220904-215140
base:    b90cb1053190353cc30f0fef0ef1f378ccc063c5
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220905/202209050000.tAI7TSe5-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/af94e709929390501b3d2f6e933fa0c1244a2029
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christophe-JAILLET/nvdimm-Avoid-wasting-some-memory/20220904-215140
        git checkout af94e709929390501b3d2f6e933fa0c1244a2029
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/nvdimm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/nvdimm/btt_devs.c:335:6: warning: no previous prototype for function 'nd_btt_free' [-Wmissing-prototypes]
   void nd_btt_free(void *data)
        ^
   drivers/nvdimm/btt_devs.c:335:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void nd_btt_free(void *data)
   ^
   static 
   1 warning generated.


vim +/nd_btt_free +335 drivers/nvdimm/btt_devs.c

   334	
 > 335	void nd_btt_free(void *data)
   336	{
   337		kfree(data);
   338	}
   339	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

