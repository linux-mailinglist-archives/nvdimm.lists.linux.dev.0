Return-Path: <nvdimm+bounces-3363-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE27F4E415E
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Mar 2022 15:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D55391C0DCC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Mar 2022 14:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBFAC87;
	Tue, 22 Mar 2022 14:31:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0BBC6A
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 14:31:35 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MDflFa018361;
	Tue, 22 Mar 2022 14:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HmdeA+97pLDLpIBbR2lwhbFwlcQt9yd22PsW4CzjZOQ=;
 b=Y90eVlONL6xwBEjwpuBZrYqPr8jyhh/Am1A0PjQh3L1pscOHKTIx+iczyivVEr1bwNfU
 CT3MclqvYJ1MucvSwGnaj7vlMc70I4qWbwZO7fr3UsG4oe/pDjTVeXQSfWLrMoVYqcZJ
 ZmnpkDeSZ4mDF6cRBofD3/rnoPdfCP44tyUr8yeb+KcUjGP0tC07qHq5nh3HEaMs5RJl
 dk30hW1n7/8PQvC3l85GES+TwRfZh7Pq0faHLYtwFqb+qbpHOzmDycNWlep4kLSFf3Qn
 TBWF2sKIyENDf0Iq31zZSRlYEMgxb9TjPJvl4snF0x2NrgmJlxkDFIRATh/0A6nFuYM5 hg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautr1cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Mar 2022 14:30:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MEHRgU009937;
	Tue, 22 Mar 2022 14:30:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8xdca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Mar 2022 14:30:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MEUrJQ43843854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Mar 2022 14:30:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 183A24C040;
	Tue, 22 Mar 2022 14:30:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E760E4C04A;
	Tue, 22 Mar 2022 14:30:47 +0000 (GMT)
Received: from [9.43.105.112] (unknown [9.43.105.112])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 22 Mar 2022 14:30:47 +0000 (GMT)
Message-ID: <19bb75d2-63a3-7927-115c-6f5c0103fb88@linux.ibm.com>
Date: Tue, 22 Mar 2022 20:00:46 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] powerpc/papr_scm: Fix build failure when
 CONFIG_PERF_EVENTS is not set
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Santosh Sivaraj
 <santosh@fossix.org>, maddy@linux.ibm.com,
        rnsastry@linux.ibm.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        atrajeev@linux.vnet.ibm.com, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Linux MM <linux-mm@kvack.org>
References: <20220318114133.113627-1-kjain@linux.ibm.com>
 <20220318114133.113627-2-kjain@linux.ibm.com>
 <CAPcyv4iqpTn89WLOW1XjFXGZEYG_MmPg+VQbcDJ9ygJ4Jaybtw@mail.gmail.com>
 <CAPcyv4iNy-RqKgwc61c+hL9g1zAE_tL5r_mqUQwCiKTzevjoDA@mail.gmail.com>
From: kajoljain <kjain@linux.ibm.com>
In-Reply-To: <CAPcyv4iNy-RqKgwc61c+hL9g1zAE_tL5r_mqUQwCiKTzevjoDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XDE74WRamQEl1IZRUeCaSfw9m_9vbgew
X-Proofpoint-ORIG-GUID: XDE74WRamQEl1IZRUeCaSfw9m_9vbgew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_06,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220082



On 3/22/22 07:15, Dan Williams wrote:
> On Mon, Mar 21, 2022 at 2:39 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> On Fri, Mar 18, 2022 at 4:42 AM Kajol Jain <kjain@linux.ibm.com> wrote:
>>>
>>> The following build failure occures when CONFIG_PERF_EVENTS is not set
>>> as generic pmu functions are not visible in that scenario.
>>>
>>> arch/powerpc/platforms/pseries/papr_scm.c:372:35: error: ‘struct perf_event’ has no member named ‘attr’
>>>          p->nvdimm_events_map[event->attr.config],
>>>                                    ^~
>>> In file included from ./include/linux/list.h:5,
>>>                  from ./include/linux/kobject.h:19,
>>>                  from ./include/linux/of.h:17,
>>>                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
>>> arch/powerpc/platforms/pseries/papr_scm.c: In function ‘papr_scm_pmu_event_init’:
>>> arch/powerpc/platforms/pseries/papr_scm.c:389:49: error: ‘struct perf_event’ has no member named ‘pmu’
>>>   struct nvdimm_pmu *nd_pmu = to_nvdimm_pmu(event->pmu);
>>>                                                  ^~
>>> ./include/linux/container_of.h:18:26: note: in definition of macro ‘container_of’
>>>   void *__mptr = (void *)(ptr);     \
>>>                           ^~~
>>> arch/powerpc/platforms/pseries/papr_scm.c:389:30: note: in expansion of macro ‘to_nvdimm_pmu’
>>>   struct nvdimm_pmu *nd_pmu = to_nvdimm_pmu(event->pmu);
>>>                               ^~~~~~~~~~~~~
>>> In file included from ./include/linux/bits.h:22,
>>>                  from ./include/linux/bitops.h:6,
>>>                  from ./include/linux/of.h:15,
>>>                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
>>>
>>> Fix the build issue by adding check for CONFIG_PERF_EVENTS config option
>>> and disabling the papr_scm perf interface support incase this config
>>> is not set
>>>
>>> Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support") (Commit id
>>> based on linux-next tree)
>>> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
>>> ---
>>>  arch/powerpc/platforms/pseries/papr_scm.c | 15 +++++++++++++++
>>
>> This is a bit messier than I would have liked mainly because it dumps
>> a bunch of ifdefery into a C file contrary to coding style, "Wherever
>> possible, don't use preprocessor conditionals (#if, #ifdef) in .c
>> files". I would expect this all to move to an organization like:
>>
>> arch/powerpc/platforms/pseries/papr_scm/main.c
>> arch/powerpc/platforms/pseries/papr_scm/perf.c
>>
>> ...and a new config symbol like:
>>
>> config PAPR_SCM_PERF
>>        depends on PAPR_SCM && PERF_EVENTS
>>        def_bool y
>>
>> ...with wrappers in header files to make everything compile away
>> without any need for main.c to carry an ifdef.
>>
>> Can you turn a patch like that in the next couple days? Otherwise, I
>> think if Linus saw me sending a late breaking compile fix that threw
>> coding style out the window he'd have cause to just drop the pull
>> request entirely.
> 
> Also, please base it on the current state of the libnvdimm-for-next
> branch as -next includes some of the SMART health changes leading to
> at least one conflict.

Ok Dan, I will rebase my changes on top of libnvdimm-for-next branch.

Thanks,
Kajol Jain

