Return-Path: <nvdimm+bounces-267-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43BC3B09DF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Jun 2021 18:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 2C68F3E0FFA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 22 Jun 2021 16:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C645A2FB5;
	Tue, 22 Jun 2021 16:04:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BCC173
	for <nvdimm@lists.linux.dev>; Tue, 22 Jun 2021 16:04:20 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id d9so6964725qtx.8
        for <nvdimm@lists.linux.dev>; Tue, 22 Jun 2021 09:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=entKCWTDI9Bsx8G18PcOmZjK1E0yazSY3D3dLmYcAtQ=;
        b=m6F2DQsuLQmIwxjZ2P6To3E2S1tzE/qmUOh/wVNuWDOoyynxL7ExI2EsNSqjtogUDL
         CSf0i4/IYS9fGrXm9hfo/JCfkfWRdFmwVp7DdfTdjM0ciYuRXwidipCciIfVhPVHeF6n
         YyU9S7BkDc4NuJrPKWPq8xoglzrJ6WzgrFVlPULgYzEkiQK2Q1ClNl+I/bAajzolr4f+
         g7O1ljrlaYI1DGp7D5tRbrYKam1Dfj5CkrkTl0LMipuCWVhT/4ASAeKEL1cmamNcxmQz
         k2cx/HfaAbyB+QkjnVRJPptlQqq9ILHARSsaQ85TpZB2Eye1HWRSEArIB4vVb6hMRlkB
         sEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=entKCWTDI9Bsx8G18PcOmZjK1E0yazSY3D3dLmYcAtQ=;
        b=SgffoLDB2nlN34WfIOrdDBYr4TDi/FwABNy2Hd3qTNwLrDEsnT5zfYQQ8jIY3RLV0n
         Hzq75tgDslt3hCepRAXNSNWp5BbpMJDbS6y7QP1BZrJvz5w++zex9j5JS5dcNYRePT7F
         NMMHQZg1Vb0fDvj3w4Qy3DwO2/MR9VpaZeRbZ3Iflj0SimFrLQ2MGOOAqa0GYrZinXD5
         8SK7pTUtQUuxRVsXGN+xvOgBpKSuBKJ7xem26Rk/JJMFDVn3O0CcFMNRB7LlE2Vxu8lP
         1EjJWT2K9rzsWzM+0AN3liVTc5BK/fWpYl21cnJA6liR5JRQyKI5lo8oF140bh0Oe1Q5
         BaHA==
X-Gm-Message-State: AOAM532DjJ5MNtYzhzVGSR/BrVFwdHnkO/20ls1+lPX03pf/6RdzA1BF
	6Mj5mHdiz0NU6OXCx0s+Vv4=
X-Google-Smtp-Source: ABdhPJzmbO1PeH1ptJ21Np2FuC+8Yx5Y24XBZOPpIKg7ohwAZiJc2nsExXKAOkdAcvpxr9wci8MLgA==
X-Received: by 2002:ac8:5994:: with SMTP id e20mr2961807qte.262.1624377858768;
        Tue, 22 Jun 2021 09:04:18 -0700 (PDT)
Received: from ?IPv6:2804:431:c7c6:59e4:b479:6e4f:abba:619e? ([2804:431:c7c6:59e4:b479:6e4f:abba:619e])
        by smtp.gmail.com with ESMTPSA id z6sm12945610qke.24.2021.06.22.09.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:04:18 -0700 (PDT)
Subject: Re: [PATCH v4 7/7] powerpc/pseries: Add support for FORM2
 associativity
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc: Nathan Lynch <nathanl@linux.ibm.com>,
 David Gibson <david@gibson.dropbear.id.au>, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20210617165105.574178-1-aneesh.kumar@linux.ibm.com>
 <20210617165105.574178-8-aneesh.kumar@linux.ibm.com>
 <e500697d-1866-538c-eaff-613e04a92c93@gmail.com>
 <87mtrihzl0.fsf@linux.ibm.com>
From: Daniel Henrique Barboza <danielhb413@gmail.com>
Message-ID: <f3e9ac91-fcaa-4ab5-efc8-71f3576b1e96@gmail.com>
Date: Tue, 22 Jun 2021 13:04:14 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87mtrihzl0.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit



On 6/22/21 9:07 AM, Aneesh Kumar K.V wrote:
> Daniel Henrique Barboza <danielhb413@gmail.com> writes:
> 
>> On 6/17/21 1:51 PM, Aneesh Kumar K.V wrote:
>>> PAPR interface currently supports two different ways of communicating resource
>>> grouping details to the OS. These are referred to as Form 0 and Form 1
>>> associativity grouping. Form 0 is the older format and is now considered
>>> deprecated. This patch adds another resource grouping named FORM2.
>>>
>>> Signed-off-by: Daniel Henrique Barboza <danielhb413@gmail.com>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>>> ---
>>>    Documentation/powerpc/associativity.rst   | 135 ++++++++++++++++++++
>>>    arch/powerpc/include/asm/firmware.h       |   3 +-
>>>    arch/powerpc/include/asm/prom.h           |   1 +
>>>    arch/powerpc/kernel/prom_init.c           |   3 +-
>>>    arch/powerpc/mm/numa.c                    | 149 +++++++++++++++++++++-
>>>    arch/powerpc/platforms/pseries/firmware.c |   1 +
>>>    6 files changed, 286 insertions(+), 6 deletions(-)
>>>    create mode 100644 Documentation/powerpc/associativity.rst
>>>
>>> diff --git a/Documentation/powerpc/associativity.rst b/Documentation/powerpc/associativity.rst
>>> new file mode 100644
>>> index 000000000000..93be604ac54d
>>> --- /dev/null
>>> +++ b/Documentation/powerpc/associativity.rst
>>> @@ -0,0 +1,135 @@
>>> +============================
>>> +NUMA resource associativity
>>> +=============================
>>> +
>>> +Associativity represents the groupings of the various platform resources into
>>> +domains of substantially similar mean performance relative to resources outside
>>> +of that domain. Resources subsets of a given domain that exhibit better
>>> +performance relative to each other than relative to other resources subsets
>>> +are represented as being members of a sub-grouping domain. This performance
>>> +characteristic is presented in terms of NUMA node distance within the Linux kernel.
>>> +From the platform view, these groups are also referred to as domains.
>>> +
>>> +PAPR interface currently supports different ways of communicating these resource
>>> +grouping details to the OS. These are referred to as Form 0, Form 1 and Form2
>>> +associativity grouping. Form 0 is the older format and is now considered deprecated.
>>> +
>>> +Hypervisor indicates the type/form of associativity used via "ibm,arcitecture-vec-5 property".
>>> +Bit 0 of byte 5 in the "ibm,architecture-vec-5" property indicates usage of Form 0 or Form 1.
>>> +A value of 1 indicates the usage of Form 1 associativity. For Form 2 associativity
>>> +bit 2 of byte 5 in the "ibm,architecture-vec-5" property is used.
>>> +
>>> +Form 0
>>> +-----
>>> +Form 0 associativity supports only two NUMA distance (LOCAL and REMOTE).
>>> +
>>> +Form 1
>>> +-----
>>> +With Form 1 a combination of ibm,associativity-reference-points and ibm,associativity
>>> +device tree properties are used to determine the NUMA distance between resource groups/domains.
>>> +
>>> +The “ibm,associativity” property contains one or more lists of numbers (domainID)
>>> +representing the resource’s platform grouping domains.
>>> +
>>> +The “ibm,associativity-reference-points” property contains one or more list of numbers
>>> +(domainID index) that represents the 1 based ordinal in the associativity lists.
>>> +The list of domainID index represnets increasing hierachy of resource grouping.
>>> +
>>> +ex:
>>> +{ primary domainID index, secondary domainID index, tertiary domainID index.. }
>>> +
>>> +Linux kernel uses the domainID at the primary domainID index as the NUMA node id.
>>> +Linux kernel computes NUMA distance between two domains by recursively comparing
>>> +if they belong to the same higher-level domains. For mismatch at every higher
>>> +level of the resource group, the kernel doubles the NUMA distance between the
>>> +comparing domains.
>>> +
>>> +Form 2
>>> +-------
>>> +Form 2 associativity format adds separate device tree properties representing NUMA node distance
>>> +thereby making the node distance computation flexible. Form 2 also allows flexible primary
>>> +domain numbering. With numa distance computation now detached from the index value of
>>> +"ibm,associativity" property, Form 2 allows a large number of primary domain ids at the
>>> +same domainID index representing resource groups of different performance/latency characteristics.
>>> +
>>> +Hypervisor indicates the usage of FORM2 associativity using bit 2 of byte 5 in the
>>> +"ibm,architecture-vec-5" property.
>>> +
>>> +"ibm,numa-lookup-index-table" property contains one or more list numbers representing
>>> +the domainIDs present in the system. The offset of the domainID in this property is considered
>>> +the domainID index.
>>> +
>>> +prop-encoded-array: The number N of the domainIDs encoded as with encode-int, followed by
>>> +N domainID encoded as with encode-int
>>> +
>>> +For ex:
>>> +ibm,numa-lookup-index-table =  {4, 0, 8, 250, 252}, domainID index for domainID 8 is 1.
>>> +
>>> +"ibm,numa-distance-table" property contains one or more list of numbers representing the NUMA
>>> +distance between resource groups/domains present in the system.
>>> +
>>> +prop-encoded-array: The number N of the distance values encoded as with encode-int, followed by
>>> +N distance values encoded as with encode-bytes. The max distance value we could encode is 255.
>>> +
>>> +For ex:
>>> +ibm,numa-lookup-index-table =  {3, 0, 8, 40}
>>> +ibm,numa-distance-table     =  {9, 10, 20, 80, 20, 10, 160, 80, 160, 10}
>>> +
>>> +  | 0    8   40
>>> +--|------------
>>> +  |
>>> +0 | 10   20  80
>>> +  |
>>> +8 | 20   10  160
>>> +  |
>>> +40| 80   160  10
>>> +
>>> +
>>> +"ibm,associativity" property for resources in node 0, 8 and 40
>>> +
>>> +{ 3, 6, 7, 0 }
>>> +{ 3, 6, 9, 8 }
>>> +{ 3, 6, 7, 40}
>>> +
>>> +With "ibm,associativity-reference-points"  { 0x3 }
>>
>> With this configuration, would the following ibm,associativity arrays
>> also be valid?
>>
>>
>> { 3, 0, 0, 0 }
>> { 3, 0, 0, 8 }
>> { 3, 0, 0, 40}
>>
> 
> Yes
> 
>> If yes, then we need a way to tell that the associativity domains assignment
>> are optional, and FORM2 relies solely on finding out the domainID of the
>> resource (0, 8 and 40) to retrieve the domainID index, and with this
>> index all performance metrics can be retrieved from the numa-* properties
>> (numa-distance-table, numa-bandwidth-table ...).
>>
> 
> Where do you suggest we clarify that? I agree that it is not explicitly
> mentioned. But we describe the details of how we find the numa distance
> with example in the document.


Perhaps something like this, right in the middle of the example:


----------------

(...)

+  | 0    8   40
+--|------------
+  |
+0 | 10   20  80
+  |
+8 | 20   10  160
+  |
+40| 80   160  10
+
+

With "ibm,associativity-reference-points" equal to { 0x3 }, the domainID of
each resource is located at index 3 of each ibm,associativity property:

+{ 3, 6, 7, 0 }
+{ 3, 6, 9, 8 }
+{ 3, 6, 7, 40 }


FORM2 requires the ibm,associativity array to contain the domainID of the
resource, which is defined by the ibm,associativity-reference-points.
Calculating the associativity domains of the remaining ibm,associativity
elements is not obligatory. In this example, the following ibm,associativity
arrays are also valid:

{ 3, 0, 0, 0 }
{ 3, 0, 0, 8 }
{ 3, 0, 0, 40 }

(...)

-------------


> 
>> Retrieving the resource domainID is done by using ibm,associativity-reference-points.
>>
>> This will allow the platform to implement FORM2 such as:
>>
>> { 1, 0 }
>> { 1, 8 }
>> { 1, 40 }
>>    
>> - ref-points: { 0x1 }
>>
>> If the platform chooses to do so.
>>
> 
> That is correct.
> 
>>
>>> +
>>> +Each resource (drcIndex) now also supports additional optional device tree properties.
>>> +These properties are marked optional because the platform can choose not to export
>>> +them and provide the system topology details using the earlier defined device tree
>>> +properties alone. The optional device tree properties are used when adding new resources
>>> +(DLPAR) and when the platform didn't provide the topology details of the domain which
>>> +contains the newly added resource during boot.
>>> +
>>> +"ibm,numa-lookup-index" property contains a number representing the domainID index to be used
>>> +when building the NUMA distance of the numa node to which this resource belongs. This can
>>> +be looked at as the index at which this new domainID would have appeared in
>>> +"ibm,numa-lookup-index-table" if the domain was present during boot. The domainID
>>> +of the new resource can be obtained from the existing "ibm,associativity" property. This
>>> +can be used to build distance information of a newly onlined NUMA node via DLPAR operation.
>>> +The value is 1 based array index value.
>>> +
>>> +prop-encoded-array: An integer encoded as with encode-int specifying the domainID index
>>> +
>>> +"ibm,numa-distance" property contains one or more list of numbers presenting the NUMA distance
>>> +from this resource domain to other resources.
>>> +
>>> +prop-encoded-array: The number N of the distance values encoded as with encode-int, followed by
>>> +N distance values encoded as with encode-bytes. The max distance value we could encode is 255.
>>> +
>>> +For ex:
>>> +ibm,associativity     = { 4, 5, 10, 50}
>>> +ibm,numa-lookup-index = { 4 }
>>> +ibm,numa-distance   =  {8, 160, 255, 80, 10, 160, 255, 80, 10}
>>> +
>>> +resulting in a new toplogy as below.
>>> +  | 0    8   40   50
>>> +--|------------------
>>> +  |
>>> +0 | 10   20  80   160
>>> +  |
>>> +8 | 20   10  160  255
>>> +  |
>>> +40| 80   160  10  80
>>> +  |
>>> +50| 160  255  80  10
>>> +
>>
>> I see there is no mention of the special PAPR SCM handling. I saw in
>> one of the your replies of v1:
>>
>> "Another option is to make sure that numa-distance-value is populated
>> such that PMEMB distance indicates it is closer to node0 when compared
>> to node1. ie, node_distance[40][0] < node_distance[40][1]. One could
>> possibly infer the grouping based on the distance value and not deepend
>> on ibm,associativity for that purpose."
>>
>>
>> Is that was we're supposed to do with PAPR SCM? I'm not sure how that
>> affects NVDIMM support in QEMU with FORM2.
>>
>>
> 
> yes that is what we are doing with this version of the patchset (v4)
> version. We can drop the nvdimm specific changes from Qemu.


I see. I'll drop the NVDIMM changes in the QEMU POC of FORM2 then.



Thanks,


Daniel

> 
> -aneesh
> 

