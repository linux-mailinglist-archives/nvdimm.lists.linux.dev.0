Return-Path: <nvdimm+bounces-1963-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE16F45298D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 16 Nov 2021 06:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id EB0843E103F
	for <lists+linux-nvdimm@lfdr.de>; Tue, 16 Nov 2021 05:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBF82C86;
	Tue, 16 Nov 2021 05:23:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C8C68
	for <nvdimm@lists.linux.dev>; Tue, 16 Nov 2021 05:23:18 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AG3gdZp006366;
	Tue, 16 Nov 2021 04:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/IiP3OJn3/x2BE7U7GqNBNSQHO3LlVNZfJj+YeFRfp0=;
 b=ZBoYc9/DKHdhgl1HFTsLjiOx2oxQOlKsBZHpOyI0/lRGUnVlXf7cc8Etxy/A7POsZR2v
 Ks3eojG6rlweEMjuL+D52EoJ6hw8VOK/RIIf27N/Uf30CFraYbEWtM1e5OguYVt2ZSON
 FyM/ofxEn+XuAC5xsAwkUUGYmixY5kbqRoPAVPMBUkINTAApQxguIxDZJngtCJOr5y4v
 8KkD8hkH6ykvrUXoan6+yEZFWuH4hIRX0Rl6YYhw4HJ5o1LzWKE7vEw8p+8Xz9f5TraW
 Ke5KZaRg3iu9YYEEilCG4DXofS/gppFcWaVg1bGkgUboAlCcSjQhSVLNk6Y1Ccc3Kceo cg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3cc4yr0wrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Nov 2021 04:49:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AG4ghtC000721;
	Tue, 16 Nov 2021 04:49:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3ca4mjkbrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Nov 2021 04:49:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AG4gPQg63701320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Nov 2021 04:42:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F370142041;
	Tue, 16 Nov 2021 04:49:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C31A42047;
	Tue, 16 Nov 2021 04:49:16 +0000 (GMT)
Received: from li-e8dccbcc-2adc-11b2-a85c-bc1f33b9b810.ibm.com.com (unknown [9.43.127.103])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 16 Nov 2021 04:49:15 +0000 (GMT)
From: Kajol Jain <kjain@linux.ibm.com>
To: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: santosh@fossix.org, maddy@linux.ibm.com, rnsastry@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        vaibhav@linux.ibm.com, kjain@linux.ibm.com
Subject: [RESEND PATCH v5 0/4] Add perf interface to expose nvdimm
Date: Tue, 16 Nov 2021 10:19:00 +0530
Message-Id: <20211116044904.48718-1-kjain@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IKOvPVtZdbC7CVoCd5xM3ObBko36qe5k
X-Proofpoint-GUID: IKOvPVtZdbC7CVoCd5xM3ObBko36qe5k
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_16,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160023

Patchset adds performance stats reporting support for nvdimm.
Added interface includes support for pmu register/unregister
functions. A structure is added called nvdimm_pmu to be used for
adding arch/platform specific data such as cpumask, nvdimm device
pointer and pmu event functions like event_init/add/read/del.
User could use the standard perf tool to access perf events
exposed via pmu.

Interface also defines supported event list, config fields for the
event attributes and their corresponding bit values which are exported
via sysfs. Patch 3 exposes IBM pseries platform nmem* device
performance stats using this interface.

Result from power9 pseries lpar with 2 nvdimm device:

Ex: List all event by perf list

command:# perf list nmem

  nmem0/cache_rh_cnt/                                [Kernel PMU event]
  nmem0/cache_wh_cnt/                                [Kernel PMU event]
  nmem0/cri_res_util/                                [Kernel PMU event]
  nmem0/ctl_res_cnt/                                 [Kernel PMU event]
  nmem0/ctl_res_tm/                                  [Kernel PMU event]
  nmem0/fast_w_cnt/                                  [Kernel PMU event]
  nmem0/host_l_cnt/                                  [Kernel PMU event]
  nmem0/host_l_dur/                                  [Kernel PMU event]
  nmem0/host_s_cnt/                                  [Kernel PMU event]
  nmem0/host_s_dur/                                  [Kernel PMU event]
  nmem0/med_r_cnt/                                   [Kernel PMU event]
  nmem0/med_r_dur/                                   [Kernel PMU event]
  nmem0/med_w_cnt/                                   [Kernel PMU event]
  nmem0/med_w_dur/                                   [Kernel PMU event]
  nmem0/mem_life/                                    [Kernel PMU event]
  nmem0/poweron_secs/                                [Kernel PMU event]
  ...
  nmem1/mem_life/                                    [Kernel PMU event]
  nmem1/poweron_secs/                                [Kernel PMU event]

Patch1:
        Introduces the nvdimm_pmu structure
Patch2:
        Adds common interface to add arch/platform specific data
        includes nvdimm device pointer, pmu data along with
        pmu event functions. It also defines supported event list
        and adds attribute groups for format, events and cpumask.
        It also adds code for cpu hotplug support.
Patch3:
        Add code in arch/powerpc/platform/pseries/papr_scm.c to expose
        nmem* pmu. It fills in the nvdimm_pmu structure with pmu name,
        capabilities, cpumask and event functions and then registers
        the pmu by adding callbacks to register_nvdimm_pmu.
Patch4:
        Sysfs documentation patch

Changelog
---
v4 -> v5:
- Remove multiple variables defined in nvdimm_pmu structure include
  name and pmu functions(event_int/add/del/read) as they are just
  used to copy them again in pmu variable. Now we are directly doing
  this step in arch specific code as suggested by Dan Williams.

- Remove attribute group field from nvdimm pmu structure and
  defined these attribute groups in common interface which
  includes format, event list along with cpumask as suggested by
  Dan Williams.
  Since we added static defination for attrbute groups needed in
  common interface, removes corresponding code from papr.

- Add nvdimm pmu event list with event codes in the common interface.

- Remove Acked-by/Reviewed-by/Tested-by tags as code is refactored
  to handle review comments from Dan.

- Make nvdimm_pmu_free_hotplug_memory function static as reported
  by kernel test robot, also add corresponding Reported-by tag.

- Link to the patchset v4: https://lkml.org/lkml/2021/9/3/45

v3 -> v4
- Rebase code on top of current papr_scm code without any logical
  changes.

- Added Acked-by tag from Peter Zijlstra and Reviewed by tag
  from Madhavan Srinivasan.

- Link to the patchset v3: https://lkml.org/lkml/2021/6/17/605

v2 -> v3
- Added Tested-by tag.

- Fix nvdimm mailing list in the ABI Documentation.

- Link to the patchset v2: https://lkml.org/lkml/2021/6/14/25

v1 -> v2
- Fix hotplug code by adding pmu migration call
  incase current designated cpu got offline. As
  pointed by Peter Zijlstra.

- Removed the retun -1 part from cpu hotplug offline
  function.

- Link to the patchset v1: https://lkml.org/lkml/2021/6/8/500

Kajol Jain (4):
  drivers/nvdimm: Add nvdimm pmu structure
  drivers/nvdimm: Add perf interface to expose nvdimm performance stats
  powerpc/papr_scm: Add perf interface support
  docs: ABI: sysfs-bus-nvdimm: Document sysfs event format entries for
    nvdimm pmu

 Documentation/ABI/testing/sysfs-bus-nvdimm |  35 +++
 arch/powerpc/include/asm/device.h          |   5 +
 arch/powerpc/platforms/pseries/papr_scm.c  | 225 ++++++++++++++
 drivers/nvdimm/Makefile                    |   1 +
 drivers/nvdimm/nd_perf.c                   | 328 +++++++++++++++++++++
 include/linux/nd.h                         |  41 +++
 6 files changed, 635 insertions(+)
 create mode 100644 drivers/nvdimm/nd_perf.c

-- 
2.26.2


