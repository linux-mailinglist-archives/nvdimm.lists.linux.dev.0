Return-Path: <nvdimm+bounces-6264-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE0B743B62
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 14:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE5A82810B8
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 12:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F8014AB4;
	Fri, 30 Jun 2023 12:03:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6814289
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688126586; x=1719662586;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J+Wg7cbMlnzlKcSqhCEoFIYLTPr4fU77zqbYoT90shM=;
  b=RWc//v01BQ9L0XCEBjYkpm0EK9h9a6MOYFtqKz1cC+Pg82wf1wln/U2+
   laZ1l6EcySS04++/ve34LY6O5Y8VSBlmq+b4C8sDm3dmukLyhtbSCqe9a
   qB4rlmoTdmiiXM4jmGVyyYr+yJedvxpNpnw1g2HEQEwq9c4Djfn5oPqeW
   5WcHhTrdF+heDC0RNUZfOTR/CupW+735+ovmd9eCWnODY8Z0R2dcS64hI
   hSCSLZpk5ANODMvftDky9XWf24ZJeOSzaXLqXoSWUzbkh0Dl7b3jab8xY
   KQDHwRkH/Q5F0WlYK0ICVVT781aeGTQPdNvussUygp9fL691pVd9T81d0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="364954458"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="364954458"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 05:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="717789060"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="717789060"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 30 Jun 2023 05:03:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 05:02:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 05:02:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 05:02:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 05:02:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6bfTin8hXdbdEJi/hBHj1Vbb3wzehHwYgsGFuieKy8kCdeHKe07XvjbDEURMbJLN4mR+yTLfhkzPpegUCK2uRbHYWfnSQoh4ZS7ZrJqRaHB1zMvksU+R8y9tsu5LSZpQ6AAKVR2+q+/Vnx6cv4hoGfFUiQd56YHltEziM1LagsTX0g+/oq9cJ7qapqCEaApxFEEJcs57mmb5qYASa7h8Ft5c1acbcY2gLYBeCT15evqAeK5MffEpO0hvF/lcFuKPu9H9w4rCIVTmOmSGYHxtGa4SfGIw1m8XEhEkkxBL070FcB8OoJ/+qnDxlkmlBe7x+Q7Ju8Ynt0/jgxDxu+f4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFPhI3MiV5u92DlwvDs+cP1+3FbMVaZogGZ9DyfsKzU=;
 b=ncrDpmsvoRDWmYyh9lA8XCTMa+zHgQhGTY2+4l/QvcJ+S2Dx9sWQlKxTBVLvey3q8t9TyoO+iSqh5Vb5ZbCG2OY5leQbcT5H60OZuPfJ1tH/mPqPQN5xPSfS/Ymu11dZgpdV3itLi7Xe3+EHejev75rzxFyDlQGFJzMQ5JU8Bmv1jX1wSixMklMjxMsFREG4DxIBPsfNLpEbQIjg9y0jpq0be1XWmSD5ja/68Q+uOI3v0TGHa13w3o8BeOPKzGXM6MUYv2NLzzq9H6lIZUMHuVOC7/guJXNUwG8PIVLcCMDTvtqTw+8kAcSrWwO1Py2qmeRzBRaQ8jY6vVGI2Mp78Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by BL3PR11MB6339.namprd11.prod.outlook.com (2603:10b6:208:3b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 12:02:47 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 12:02:47 +0000
Message-ID: <070718c8-aea5-10e9-5891-f8a05a5f8f53@intel.com>
Date: Fri, 30 Jun 2023 14:02:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v5 08/10] acpi/nfit: Improve terminator line in
 acpi_nfit_ids
Content-Language: en-US
To: "Rafael J. Wysocki" <rafael@kernel.org>
CC: <linux-acpi@vger.kernel.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <lenb@kernel.org>, <dave.jiang@intel.com>,
	<ira.weiny@intel.com>, <rui.zhang@intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-9-michal.wilczynski@intel.com>
 <CAJZ5v0hPY=nermvRKiyqGg4R+jLW13B-MUr0exEuEnw33VUj7g@mail.gmail.com>
 <699b327d-acea-c51d-874a-85133b74a73c@intel.com>
 <CAJZ5v0jpcas1TLGVR5Cic-bz4YkkAVypShj0sfEKUmy+930vVA@mail.gmail.com>
 <CAJZ5v0hUiZy+yxd9mZoLM99194N0u42+UCms8Fm8s4YpkM1yFg@mail.gmail.com>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <CAJZ5v0hUiZy+yxd9mZoLM99194N0u42+UCms8Fm8s4YpkM1yFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::16) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|BL3PR11MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: de664b91-0e89-463c-efc1-08db7961ebb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +bmQXzfcYfrBNRGYkthsaRcCs6ozuLppQMR7K+qapkK+4HgDMeahHockQOF9YcmG30DOu+vtCtsflaJtH7fiMH3lAB5TbfFYHFou8XwgUmUDiyJophi3Hnrjsj1iQvHDJiXqt2+C1k0mrSF2erQsNFu32tWRf9p7EzHc2k2AKWgCAt2hl5cxDu20h5CxhbnbxpwUlIYAkjLI0cNhdIKFnjxpCRqS7TL4+A5ap/jep4lP2FiKDWVV8IOXkmgQwNDPvB+ypzM1qLqrpdTDWZxBgc5CMavI2Sx24swlxM9z2SrOAMXJy1HkHyFPPwbrwjIE+2WW15N07GtQTvBp7rbspKDGYfKyYKUuYgh2Tm6yJjv8B/Hp+DwXmJgc5VipLHsNplYlHTQ7Zg3D+/KUczz5vDdDvv5rhkFajTCQ/YfJsNJcZUxae/5GvJFHpudJ5J8xtfLlb9E58H5tpnSWK9y9OEiaoopac2cZTscTDgleoS90AJAHqbgh+6xGJhYhyNF3Ls5Zy0LAEMoaPhjjevduaXKvV9RF8F23S/p0uKNBMSmmZlJ8lgxXdiqp028msFFfnsj8FjRscTmUYBweoE+Wyry+tq9kySPdcp5150sFEJKWu5P5lgYk/nDrHr4j8B8s152bqcJJFYc4Ut+RCfBZKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199021)(31686004)(66946007)(66556008)(66476007)(2906002)(36756003)(478600001)(8936002)(316002)(38100700002)(41300700001)(4326008)(6916009)(83380400001)(6486002)(82960400001)(966005)(6666004)(5660300002)(86362001)(6512007)(31696002)(8676002)(26005)(2616005)(186003)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVZjQ0JjREJ5Mm5iN0tieFRTUFl1cXBBdlQ0cThDTi91RnVGYk1lemVQLzMy?=
 =?utf-8?B?dUlmek1IT1ViOWYrSmFZdjROcU9DakZTa1k4WGdQc0FGcEVTS2RIYnlsTFRV?=
 =?utf-8?B?dnNKMkw1UWtOVXVMeUo5RnQ0KzNuSnRQZlNqWjVFb1h2YWh2TU9RbTNrS1VE?=
 =?utf-8?B?cmluZVpKWENmSjBuMEFhMFNGS1RGNlVzMXJaRU9pNVlJYzg1aEhLUkttRGNi?=
 =?utf-8?B?NmlhdDNwMkdhRCtGSUV1djhyR2YzNDhVa3lDREF4Yzl5ZDlkbnNmTVlZbXVI?=
 =?utf-8?B?VWx3bHkvSHlUayt2U0VlalFXSVdvZDZXUVdQTitQMnpsTi9HYkFrTkNOY3pQ?=
 =?utf-8?B?NmpRNkM0OVdWYnh4YnVaMWJVV0JrS0d5Nncra0lIU0wrOUNQYWZRY3JKZ2My?=
 =?utf-8?B?RXBYanBOOFQrNHdWZWp1VitzdlVDbDJ4OGk0M2I2NEtKWXJweFI2aFFOWE8w?=
 =?utf-8?B?UkNmVDZ4ai92c2kvcnZwT1lFcWkydlcxUUVGbDEwcWdpeDNZaklRR1h4RzRT?=
 =?utf-8?B?WnVQbnpkR1ZjU0dVam1yVU5BZCtTOEJiMFdCNjFzN1F6Q1hDeWZLSlR6anhK?=
 =?utf-8?B?L1I4WTR3TFNwNlhvQUtuN1U3MVVxUXI0L01mRVRDSEdneEFPd3VIOG5wRmdV?=
 =?utf-8?B?QTJacTRsUGh4VEgrSFdXKzEvNDMyNStVcmcrZE9HdWxyMThCZnZKZkpvZWs0?=
 =?utf-8?B?K3NIRHptdG5vak5waUpLOFc5bVFZZ3BOQkFIc2xGSzcyL1JvN3pCaG1RRlpy?=
 =?utf-8?B?OFJoZTAxa0h2YVdXZkx0UUhuSjRiVFpGclNZQ213aTBEWTFrTHVMWVBQYVFm?=
 =?utf-8?B?MmdBeERvWEY0U0tuVUIxMlY4NW52a2xLYkhwcVJ3Y1VYbHVLK3FPdEdyQTNC?=
 =?utf-8?B?bW5tVmVnTlhCS2JoTlBXZXNTRmZzODBIMFpQRUdac1c4ck52TCtpZjkwKzF5?=
 =?utf-8?B?dlJJQ294OTZnWHIrZzk1Z1ArdkRuZUxBaVJZZVFLRmVINUYwaS9DdXgrSVp6?=
 =?utf-8?B?YXZXWFhXUTQ0NzdQMUVjNzRJT2FVWUl5Wi96UDAxVi9oNEJvMXptdkFNN2Zt?=
 =?utf-8?B?UHZuVzVCdC9Ed2wzZWpjTGJDUHVjVEJCOGZsYlU5YUZ4WWJPZ2MxMEtNSWhv?=
 =?utf-8?B?WWdKQ3RoWlc0b1FyaitDSVdsVUMrbU52VGMxZHZVQUcwUlVtWkJJc2prYksv?=
 =?utf-8?B?NmV6RDd0WHREcWlrQmdWT2FiZzZ5RFlGT1VGZTJ1QXhTTkg4cVA1UWQ2SG4x?=
 =?utf-8?B?Zkp6RUtuZExISnRqbmdiU0t6a3gvVUJBazRkSURoQjhzenlQRG8xSW8vRnhw?=
 =?utf-8?B?anFuUmtseStvK3NvbWxzaFlJMnE0NVJVdHpmclRacXhiUitEclhBbFZ5UUw2?=
 =?utf-8?B?QkdsR3RGUEVaQlpzc0RHM3B0dlNDTWZOU2VWMWhhNS9Ib1dWeTZBdkRCRkZr?=
 =?utf-8?B?emVhaDlRd1NGS2FnZXV2WWZpc1FrRHhQL09uN01oandRSlhmV2xoQXJ6ZkZo?=
 =?utf-8?B?Zkd6R3FjMDVpM1p5WEpyZmd6Sm42OHhTb0lzRG1kZC9BeWRHL1hKRHNCNGNS?=
 =?utf-8?B?MUtacVkyZytNMjNpOHRsRklSc2FHdThtM0FJeVQ1Qnd4R1VEWGxKMGVUb051?=
 =?utf-8?B?RGlDZHN5a0ZFNVd6RXUvcFgxRjg0TjhZNUhldlExUUkwMnFOTTF4R1JvYllQ?=
 =?utf-8?B?U3JRVFdzdFdvS3dKTENvWitGbVZJZUQvZFFQeU45dUliam9abWcxRnNSNmJy?=
 =?utf-8?B?bVQwK2RaRVRVZ01pY212d2hmOXU1WURSaEkzbkJ1ZW1ZTlBTRTd6VnpNR0RT?=
 =?utf-8?B?RVRBRTduRXluWnBPTzR4RmxaTWppenc2OWdwa28yU2pvSzRMeG9DYlozVDBX?=
 =?utf-8?B?d28yaVpIdU45NHhOTTdZVWxuM050d1dseGVpS3ExTFhWbkVLMzJFM295Qmh5?=
 =?utf-8?B?eUs0ZnRwQ2NxbDl5WVNoNXlIVXZjbko1cnptbEpKVlVkdXhvekprQ3RUN3p6?=
 =?utf-8?B?bmhjZTgvQ3BvZmVpN0RnZGxpVTJPd1pCU1BxZnhVbTJmbytiSTljS0pBWm55?=
 =?utf-8?B?QXNRYXZTZmJzbnR2UUR2QUNsTUV0SEovTTlWUi9rSlVGVXpJbW00UEhGZ1NF?=
 =?utf-8?B?YWJPYThGUWtFcHR6aGNVcTR0bk5mWTZlWXZKRnhHUDd6dWoxazlJN2hkVmV3?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de664b91-0e89-463c-efc1-08db7961ebb0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 12:02:47.8672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4v2GQqdBmFnul3dAIvUBD0Zqst2UBsg1bn8GEcd/erSp3NI3+Beh51i4FUEEJm+ijSsJbJQed3LNH22yYI6tAugUDJm6PEQN31I1p+A8IpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6339
X-OriginatorOrg: intel.com



On 6/30/2023 1:13 PM, Rafael J. Wysocki wrote:
> On Fri, Jun 30, 2023 at 1:04 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>> On Fri, Jun 30, 2023 at 11:52 AM Wilczynski, Michal
>> <michal.wilczynski@intel.com> wrote:
>>>
>>>
>>> On 6/29/2023 6:14 PM, Rafael J. Wysocki wrote:
>>>> On Fri, Jun 16, 2023 at 6:51 PM Michal Wilczynski
>>>> <michal.wilczynski@intel.com> wrote:
>>>>> Currently terminator line contains redunant characters.
>>>> Well, they are terminating the list properly AFAICS, so they aren't
>>>> redundant and the size of it before and after the change is actually
>>>> the same, isn't it?
>>> This syntax is correct of course, but we have an internal guidelines specifically
>>> saying that terminator line should NOT contain a comma at the end. Justification:
>>>
>>> "Terminator line is established for the data structure arrays which may have unknown,
>>> to the caller, sizes. The purpose of it is to stop iteration over an array and avoid
>>> out-of-boundary access. Nevertheless, we may apply a bit more stricter rule to avoid
>>> potential, but unlike, event of adding the entry after terminator, already at compile time.
>>> This will be achieved by not putting comma at the end of terminator line"
>> This certainly applies to any new code.
>>
>> The existing code, however, is what it is and the question is how much
>> of an improvement the given change makes.
>>
>> So yes, it may not follow the current rules for new code, but then it
>> may not be worth changing to follow these rules anyway.
> This is a bit like housing in a city.
>
> Usually, there are strict requirements that must be followed while
> constructing a new building, but existing buildings are not
> reconstructed to follow them in the majority of cases.  It may not
> even be a good idea to do that.

Thanks, great explanation ! I think it's a shared sentiment among maintainers.
I've been watching upstreaming effort of intel new idpf driver, and it got rejected
basically because new drivers are held to a higher standard (they didn't modernize
their code to use new page pool API).

https://lore.kernel.org/netdev/20230621122106.56cb5bf1@kernel.org/#t



