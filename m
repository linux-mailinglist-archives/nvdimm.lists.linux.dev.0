Return-Path: <nvdimm+bounces-2627-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 3036149DA2F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jan 2022 06:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 96EE03E0F1C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Jan 2022 05:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBEB2CA9;
	Thu, 27 Jan 2022 05:29:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A547D2CA1;
	Thu, 27 Jan 2022 05:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643261385; x=1674797385;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ww+09sTb7e4s79AGYZepHOy9pqA7DxmaaqY66FD/KXg=;
  b=bjOwRBUqH1mnLA6NazkDHYtCxsIN0LccctMi7re53oJ9RoKeeTMUbgUl
   HCiHbQgc3dJeUCJ0LhOxS0bcMv0HvlUomdjBCy6ga3C1LwmtocbDYN9rw
   J26+RsKtLL9e979IIJBqHqsNpIHm2DGffhxva4NyXkbbFlL65kS3b/gmJ
   X4GmV7mMY/hf+DbkxgLbpGRss8oEREa8tHgXbQ9ogl71DEYq4pspOqwha
   cXWVm0ik5kuWhUfLczN0AJDdMPI0g4e0+jxj82G+Oyn0eVPeL2Cpn5gmU
   qv3KN9iPcuZBGU54ayOflIixvVD4Xbv6DwIRoSrZlAjEq8OKcRx3jKSVg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246531927"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="246531927"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 21:29:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="628560853"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Jan 2022 21:29:42 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nCxLp-000MAs-Sn; Thu, 27 Jan 2022 05:29:41 +0000
Date: Thu, 27 Jan 2022 13:29:00 +0800
From: kernel test robot <lkp@intel.com>
To: Jonghyeon Kim <tome01@ajou.ac.kr>, dan.j.williams@intel.com
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org, vishal.l.verma@intel.com,
	dave.jiang@intel.com, akpm@linux-foundation.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: Re: [PATCH 2/2] dax/kmem: Update spanned page stat of origin device
 node
Message-ID: <202201271342.1w9oD4VP-lkp@intel.com>
References: <20220126170002.19754-2-tome01@ajou.ac.kr>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126170002.19754-2-tome01@ajou.ac.kr>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jonghyeon,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on hnaz-mm/master]

url:    https://github.com/0day-ci/linux/commits/Jonghyeon-Kim/mm-memory_hotplug-Export-shrink-span-functions-for-zone-and-node/20220127-010219
base:   https://github.com/hnaz/linux-mm master
config: s390-randconfig-r044-20220124 (https://download.01.org/0day-ci/archive/20220127/202201271342.1w9oD4VP-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project f400a6012c668dfaa73462caf067ceb074e66c47)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/ef33cc7f7380ddd07a3fedb42f35c1f81de401a4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jonghyeon-Kim/mm-memory_hotplug-Export-shrink-span-functions-for-zone-and-node/20220127-010219
        git checkout ef33cc7f7380ddd07a3fedb42f35c1f81de401a4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/dax/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/dax/kmem.c:156:42: error: use of undeclared identifier 'ZONE_DEVICE'
                   struct zone *zone = &pgdat->node_zones[ZONE_DEVICE];
                                                          ^
   1 error generated.


vim +/ZONE_DEVICE +156 drivers/dax/kmem.c

    44	
    45	static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
    46	{
    47		struct device *dev = &dev_dax->dev;
    48		unsigned long total_len = 0;
    49		struct dax_kmem_data *data;
    50		int i, rc, mapped = 0;
    51		int numa_node;
    52		int dev_node;
    53	
    54		/*
    55		 * Ensure good NUMA information for the persistent memory.
    56		 * Without this check, there is a risk that slow memory
    57		 * could be mixed in a node with faster memory, causing
    58		 * unavoidable performance issues.
    59		 */
    60		numa_node = dev_dax->target_node;
    61		if (numa_node < 0) {
    62			dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
    63					numa_node);
    64			return -EINVAL;
    65		}
    66	
    67		for (i = 0; i < dev_dax->nr_range; i++) {
    68			struct range range;
    69	
    70			rc = dax_kmem_range(dev_dax, i, &range);
    71			if (rc) {
    72				dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
    73						i, range.start, range.end);
    74				continue;
    75			}
    76			total_len += range_len(&range);
    77		}
    78	
    79		if (!total_len) {
    80			dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
    81			return -EINVAL;
    82		}
    83	
    84		data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
    85		if (!data)
    86			return -ENOMEM;
    87	
    88		rc = -ENOMEM;
    89		data->res_name = kstrdup(dev_name(dev), GFP_KERNEL);
    90		if (!data->res_name)
    91			goto err_res_name;
    92	
    93		rc = memory_group_register_static(numa_node, total_len);
    94		if (rc < 0)
    95			goto err_reg_mgid;
    96		data->mgid = rc;
    97	
    98		for (i = 0; i < dev_dax->nr_range; i++) {
    99			struct resource *res;
   100			struct range range;
   101	
   102			rc = dax_kmem_range(dev_dax, i, &range);
   103			if (rc)
   104				continue;
   105	
   106			/* Region is permanently reserved if hotremove fails. */
   107			res = request_mem_region(range.start, range_len(&range), data->res_name);
   108			if (!res) {
   109				dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
   110						i, range.start, range.end);
   111				/*
   112				 * Once some memory has been onlined we can't
   113				 * assume that it can be un-onlined safely.
   114				 */
   115				if (mapped)
   116					continue;
   117				rc = -EBUSY;
   118				goto err_request_mem;
   119			}
   120			data->res[i] = res;
   121	
   122			/*
   123			 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
   124			 * so that add_memory() can add a child resource.  Do not
   125			 * inherit flags from the parent since it may set new flags
   126			 * unknown to us that will break add_memory() below.
   127			 */
   128			res->flags = IORESOURCE_SYSTEM_RAM;
   129	
   130			/*
   131			 * Ensure that future kexec'd kernels will not treat
   132			 * this as RAM automatically.
   133			 */
   134			rc = add_memory_driver_managed(data->mgid, range.start,
   135					range_len(&range), kmem_name, MHP_NID_IS_MGID);
   136	
   137			if (rc) {
   138				dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
   139						i, range.start, range.end);
   140				release_resource(res);
   141				kfree(res);
   142				data->res[i] = NULL;
   143				if (mapped)
   144					continue;
   145				goto err_request_mem;
   146			}
   147			mapped++;
   148		}
   149	
   150		dev_set_drvdata(dev, data);
   151	
   152		/* Update spanned_pages of the device numa node */
   153		dev_node = dev_to_node(dev);
   154		if (dev_node != numa_node && dev_node < numa_node) {
   155			struct pglist_data *pgdat = NODE_DATA(dev_node);
 > 156			struct zone *zone = &pgdat->node_zones[ZONE_DEVICE];
   157			unsigned long start_pfn = zone->zone_start_pfn;
   158			unsigned long nr_pages = NODE_DATA(numa_node)->node_spanned_pages;
   159	
   160			shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
   161			update_pgdat_span(pgdat);
   162		}
   163	
   164		return 0;
   165	
   166	err_request_mem:
   167		memory_group_unregister(data->mgid);
   168	err_reg_mgid:
   169		kfree(data->res_name);
   170	err_res_name:
   171		kfree(data);
   172		return rc;
   173	}
   174	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

