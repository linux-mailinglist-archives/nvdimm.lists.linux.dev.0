Return-Path: <nvdimm+bounces-365-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 726BB3BC707
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 09:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 77C721C0E17
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 07:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309862F80;
	Tue,  6 Jul 2021 07:21:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFC70
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 07:21:20 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16673LW4038582;
	Tue, 6 Jul 2021 03:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+tSYXNITpqcsEbNO1EVl+iFKtHcq1jgb/+boOFMvQC0=;
 b=r+qCSw9HWqt5CsplJnfNdMBfy0TWePM6XL5Heac1XDWTDHv7/jl/EPPC3lqW8bs7Hq75
 W82RwgyLs7mlEU8Md60unyWdOWkbgd3QOMtnm6vSo2ssx6WRQM26awI1QfVRU3WXE8KA
 dnI8QIA/2btfO2eOkbuSKi44EjAg9l7hlQ0AZX/CJrby475X/nJXbxwr/zt9DSZOn2+S
 fqBM+Hwuv1TXWmNJ9J+Bke2e0rF8jTMWYKocy2e+hO1//gs6vOZJ+PYOxvzn4hSxC+tN
 v21KuHHp8HVOS2ylwdl8dC3CI8STnbLST4HL8fOqxd5PXijJgLr74oy6XH+yQ8Ci8lXO NQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkdrtkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jul 2021 03:20:47 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
	by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667D0lA027420;
	Tue, 6 Jul 2021 07:20:46 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by ppma01wdc.us.ibm.com with ESMTP id 39jfhae369-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jul 2021 07:20:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667Kk6N6292072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Jul 2021 07:20:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5748AE068;
	Tue,  6 Jul 2021 07:20:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4314AAE062;
	Tue,  6 Jul 2021 07:20:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.34.44])
	by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
	Tue,  6 Jul 2021 07:20:39 +0000 (GMT)
Subject: Re: [PATCH v3 0/4] Add perf interface to expose nvdimm
To: Michael Ellerman <mpe@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, maddy@linux.vnet.ibm.com,
        santosh@fossix.org, aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
        ira.weiny@intel.com, atrajeev@linux.vnet.ibm.com, tglx@linutronix.de,
        rnsastry@linux.ibm.com
References: <20210617132617.99529-1-kjain@linux.ibm.com>
 <YNHiRO11E9yYS6mv@hirez.programming.kicks-ass.net>
 <cea827fe-62d4-95fe-b81f-5c7bebe4a6f0@linux.ibm.com>
 <YNLxRz1w9IeatIKW@hirez.programming.kicks-ass.net>
 <87fsx825lj.fsf@mpe.ellerman.id.au>
From: kajoljain <kjain@linux.ibm.com>
Message-ID: <96e9fa2e-fd8a-dc1a-9cbb-b515b8468867@linux.ibm.com>
Date: Tue, 6 Jul 2021 12:50:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87fsx825lj.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZTZGICHiuoHhKfhxOni8w9McQi0WG8ZU
X-Proofpoint-ORIG-GUID: ZTZGICHiuoHhKfhxOni8w9McQi0WG8ZU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060035



On 6/23/21 4:46 PM, Michael Ellerman wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>> On Wed, Jun 23, 2021 at 01:40:38PM +0530, kajoljain wrote:
>>>
>>> On 6/22/21 6:44 PM, Peter Zijlstra wrote:
>>>> On Thu, Jun 17, 2021 at 06:56:13PM +0530, Kajol Jain wrote:
>>>>> ---
>>>>> Kajol Jain (4):
>>>>>   drivers/nvdimm: Add nvdimm pmu structure
>>>>>   drivers/nvdimm: Add perf interface to expose nvdimm performance stats
>>>>>   powerpc/papr_scm: Add perf interface support
>>>>>   powerpc/papr_scm: Document papr_scm sysfs event format entries
>>>>
>>>> Don't see anything obviously wrong with this one.
>>>>
>>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>>>
>>>
>>> Hi Peter,
>>>     Thanks for reviewing the patch. Can you help me on how to take 
>>> these patches to linus tree or can you take it?
>>
>> I would expect either the NVDIMM or PPC maintainers to take this. Dan,
>> Michael ?
> 
> I can take it but would need Acks from nvdimm folks.

Hi Dan,
    Do you have any comments on this patchset. Please let me know.

Thanks,
Kajol jain

> 
> cheers
> 

