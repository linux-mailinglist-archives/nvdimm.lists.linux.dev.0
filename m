Return-Path: <nvdimm+bounces-1169-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id A36D3400A21
	for <lists+linux-nvdimm@lfdr.de>; Sat,  4 Sep 2021 08:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9CFDB1C0F57
	for <lists+linux-nvdimm@lfdr.de>; Sat,  4 Sep 2021 06:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BDF3FCD;
	Sat,  4 Sep 2021 06:39:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4170C3FC0
	for <nvdimm@lists.linux.dev>; Sat,  4 Sep 2021 06:39:30 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1846XOTW018101;
	Sat, 4 Sep 2021 02:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DU9459HyLfoFSrkTE5ucAOWmbmD78IKFAVxR3c5PQIc=;
 b=o2uj8e/EgwtVfEwTJSp/BIGOHnFh+dBgSkkOnSr49aKgQUWXAHa3aP3TKF9yUbkCoeH5
 CORsN87w1FDWFAfmkR3b83DKvGyPppG6VO78Da6KE4cp4c6jqONSXdtIwWg0ylcgDl+Z
 8r+XGeP9TtCKmDlNNXmXVY4Sg5t5YOR+qKXTWHf0q3IvNjb/L948sp/l9uXS8KA0KMK7
 70MMxGFX8t+901oekv8gZwJ2JXwKXIZSVrLY4nOO71L+2IVy/EQSOI/UpUFTkCNd1Qiy
 6+3i8DiV1Jmf25VpEuRu8fzTEpmGav64xcV6CvJFObRZzRKHpYgfYp8OuIMc1n57fCh2 ag== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3av3m6g2th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 04 Sep 2021 02:39:07 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
	by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1846Y0bS026010;
	Sat, 4 Sep 2021 06:39:07 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by ppma03dal.us.ibm.com with ESMTP id 3av0e8tepe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 04 Sep 2021 06:39:07 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1846d6Ah18023150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 4 Sep 2021 06:39:06 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D845136061;
	Sat,  4 Sep 2021 06:39:06 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E74C513605D;
	Sat,  4 Sep 2021 06:39:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.43.55.112])
	by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
	Sat,  4 Sep 2021 06:39:01 +0000 (GMT)
Subject: Re: [RESEND PATCH v4 2/4] drivers/nvdimm: Add perf interface to
 expose nvdimm performance stats
To: kernel test robot <lkp@intel.com>, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: kbuild-all@lists.01.org, maddy@linux.ibm.com, santosh@fossix.org
References: <20210903050914.273525-3-kjain@linux.ibm.com>
 <202109032341.mgqAHURT-lkp@intel.com>
From: kajoljain <kjain@linux.ibm.com>
Message-ID: <b18af051-1652-baba-5a6e-95a4194d6ef1@linux.ibm.com>
Date: Sat, 4 Sep 2021 12:08:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <202109032341.mgqAHURT-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GrcAAByAMKRhtspIanR6z6Pc1uPv3DoW
X-Proofpoint-ORIG-GUID: GrcAAByAMKRhtspIanR6z6Pc1uPv3DoW
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-04_02:2021-09-03,2021-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1011
 mlxlogscore=999 adultscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109040044



On 9/3/21 8:49 PM, kernel test robot wrote:
> Hi Kajol,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
> [also build test WARNING on powerpc/next linus/master v5.14 next-20210903]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Kajol-Jain/Add-perf-interface-to-expose-nvdimm/20210903-131212
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
> config: x86_64-randconfig-s021-20210903 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-rc1-dirty
>         # https://github.com/0day-ci/linux/commit/f841601cc058e6033761bd2157b886a30190fc3a
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Kajol-Jain/Add-perf-interface-to-expose-nvdimm/20210903-131212
>         git checkout f841601cc058e6033761bd2157b886a30190fc3a
>         # save the attached .config to linux build tree
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/nvdimm/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
>>> drivers/nvdimm/nd_perf.c:159:6: sparse: sparse: symbol 'nvdimm_pmu_free_hotplug_memory' was not declared. Should it be static?
> 
> Please review and possibly fold the followup patch.

Hi,
  Sure I will correct it and send follow-up patchset.

Thanks,
Kajol Jain

> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

