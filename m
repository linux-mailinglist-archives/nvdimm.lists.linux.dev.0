Return-Path: <nvdimm+bounces-4411-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A3357D17C
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Jul 2022 18:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF81280D25
	for <lists+linux-nvdimm@lfdr.de>; Thu, 21 Jul 2022 16:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51FE4697;
	Thu, 21 Jul 2022 16:29:56 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC00D4680
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658420994; x=1689956994;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jqHSf6nyknnzlc1k1AexH4Wj1153/8PnenWscKnJVPA=;
  b=NFANFVVdVwD49GJDVzvVai+/QPpQY1mpRrnh2kV/UBWwR+4dhZioK1Sk
   2rZFMGXBgVdRkoNzjmKGnsU6BvwR7s8EV98RcuqXkYWMXnHA/1AvpwUBS
   B/RpRa/pLEkQVe60pD3HJWUUajND6lQ33ej9ZZ9C6T2hvKZKSYSnJdVof
   R9yDUYv6POgCIjibFUI9NOLCE5DsngGDtjphn2e0FBN/VNIZFKpEBzG/4
   GbK9D4u5WPGSQNKsllHEbOGrv/w4UlL0ORPIfpjnGw0kpYnDZ8v/IG5bw
   w2BfwGhX8r3qGcrkzpt0mgiKRp1m2lDmjXy8cf+jW3qOfZH5BBid2cRDd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="273947481"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="273947481"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:29:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="656818927"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2022 09:29:53 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:29:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 09:29:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 09:29:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 09:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIpZlbcV8Yn9G7sH4gMx9ldttPzuFbAtnhFXuEKqNptmHz0zhBP8yC1K4eyK313Vt+xgav2wJeRrbUys5M1cFNEiHXkP2v1ecu6GO4xZaMyPgZb1joow1Ls2H9RhZF3kn2zAKQIE+ht3JvJ3MS5y2fnynOgl+spymQITHALkS/SIwx2faVSkWgbmQ8Zc56iVoQFcZUb+rkDiG/gNM+3y+tFblTI5eDSHG7rxGQ2Ore1yRPV0ziQRtWgYDn3QW9xNuvWiaI4sQB6o5ZyOI2yjLFFCVOYNbolC6HB3SZioaZ5gMZTvBEESGV9ATX9K41mV3yd165Y+i2hJg+t11UuceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEVRoAt7OGT6JrGzgYAHnGGT1M/cRgch8cn3Tgjdjj0=;
 b=TKFIfrfuwuO63A4X4jxZkRXtN7w9T/Dcv8/8hrmx8Ott3Z/MdsLYx49gx3cqO7X5mG8i5SSLxfqPa/BAGyTksaUDCz7n/dtumXJCa2DK6T2gXdXu9Ahz08iL7jOHM5VLcmwgQPUrHqTQwTNWUA5psshy2nDkyqFLOGH9rAkrz3FEiCe6w3I+LMDt/fEqXg6TDBprBrI99+1g+xH2c4C4JnoZOG0nXUeveYeo3piBt4ajgwzCoDiULXlWcKlBk34m8wvA8lCSHSldEMK/Ve1gVt1q7pH7bJxbL/UFku2xlbWJSTtmrVMwU0zc3TJe9w4PjAW24efRRFTBUoQh2mQIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 16:29:50 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5458.019; Thu, 21 Jul
 2022 16:29:50 +0000
Date: Thu, 21 Jul 2022 09:29:46 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Tony
 Luck" <tony.luck@intel.com>, Jason Gunthorpe <jgg@nvidia.com>, Ben Widawsky
	<bwidawsk@kernel.org>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 00/28] CXL PMEM Region Provisioning
Message-ID: <62d97efa7ec7a_17f3e8294b4@dwillia2-xfh.jf.intel.com.notmuch>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
 <20220721155907.0000708c@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220721155907.0000708c@huawei.com>
X-ClientProxiedBy: SJ0PR05CA0149.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::34) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 633c0e20-4293-4e96-feec-08da6b363bce
X-MS-TrafficTypeDiagnostic: DM6PR11MB4739:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vmFCFiJ8t+ECGinlqdUZq6OKNdu+D5ZI1eUvmfY8XQOi0zeeevYgAEANBHQxDzQ5A/aZFTwD5yCQ3o00pXGojnwJjNK1+/vhwTs5Wxzruv+UoI25P582MzuL0A/HtDn2ZCPfqIQiob+wK+lT12gQlJCTs1xDXXuvNtcylfK8nyer6thjQ6Ib1kI9Sd48wK472y5a3VHET9JmzLG+Muwxau9WI2u1FcvBS50HAjrNJ86kc1akKZ2iYBrUumXR4V1O2mkJPl5tFZUYGDDpMO/mC5L/eTapvUpRK6YU0iO3ngQeV4fyvS3kS12QbYeSJLgnQS87kvv9m2Ny/JmEdJdQgluZ7wFMBfhLiSCicPqehEESzIKXSmDzQTw04OwKYAmpLxuY7UDzckf1AyUktlPm/ufgarELLzlHY6THxygQ7L2Qlf14U9Ol/PUxcjZRmAbsO0SwkzUUppil3jGwKH7IQB0lN0E4wgLoRbKh2i0iB/fHoeN0cEDVFKVBTUIwI0HLlmSK7vepEBfda334wQCFnDvLw7C7iz74ns1PmkxZ2dTsbczd+ib3uL/YY+mU9z4c8fJr+GZ4MHjsK2T2LmVwC0QWUMLYx8+wh7GHi/4I4uHFfYu310MaEZFDSGQBTRaEPbYJ2go8NsotiDbYa0z0oEnySTWx72u6nKnNfah41eMfgqwsMafXn1oPCQbvQ0uXaaeSjpDdX5etUR7EbAe4HZzFJ5pomuRhaL7Mi2gr1FaTDRkE7glxb3Fzsm1RXOFj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(376002)(136003)(396003)(346002)(66946007)(5660300002)(83380400001)(186003)(7416002)(66476007)(8936002)(66556008)(8676002)(38100700002)(110136005)(4326008)(2906002)(478600001)(6486002)(82960400001)(54906003)(41300700001)(9686003)(316002)(6666004)(6506007)(26005)(6512007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7swiOUKy2BDIaNMNSa+e95VvBEO86q3x98VvhFagVUlL3PnfBrkT0gSb6upw?=
 =?us-ascii?Q?5A+XSleS1SiBlkTY128aSlyeZ1ZgW6+HxPYl1B74MfPaELEId2yTEuI1xsxp?=
 =?us-ascii?Q?G0JNZbFAQdrBx4ku5Ri2s1i9eruriLMiIakRNillf4JcBqjBXt5kXEFCTBwW?=
 =?us-ascii?Q?yKB9YRqGkphY5t8PqK8/KiLoXlbl5zzNgZEKI/CsLQ/Lr8u4f9Y3Y9ZWy4td?=
 =?us-ascii?Q?abhxR20uW6HWoRg87h9T9kvadrJzZ2vYjDtuW7Yu1NICLkxUHuJCOw/PmZKI?=
 =?us-ascii?Q?VFSI1pZkA7V/CdqfPHjaLHWPxNE8cZjZZsaVifQ8MnLw9Kia2+7GM0APSUM5?=
 =?us-ascii?Q?fouGQqsx607L4czpKCxqIZWYT9acwhmOVOYTBofdtxzjnfir/s6iqAhjnPFl?=
 =?us-ascii?Q?GIj5WNSQG/ooaC7FtICVeUITSQ+uE+kXt9/YvsYCqhTzeT/8vM2Z0jT2zQf1?=
 =?us-ascii?Q?LseMNlvq7WoFamUQih+Fq0R0MfRgiZtPvbxQUh7BmiT3OSv4+J6HiF+IOasb?=
 =?us-ascii?Q?j+i5UhqkKNhBAMYFVh5niaPZM7/qPB8WKoVGdcpbNSExY6kyBKD9Upi+btJU?=
 =?us-ascii?Q?X00Tx9ySxZjI399vKPBuwAHrp1+VS9xD/gIIm/jpNDPtmo1pVxmHBoXdpFg6?=
 =?us-ascii?Q?sFpC7UGRE4KlESMVBPM/ugs96BMYrFoRTM12BITv+0khZ4TWhlNwgRshcBi5?=
 =?us-ascii?Q?V5dMeRvXZ950Jvp7pFG368wBIDKabPFhulb8jCQ1S1STpTPQgtEBgeCQWwR+?=
 =?us-ascii?Q?p5qUSSaJy9uMAVQfcRNKkvoFkrR9eIyazkHQBpyvAew7S1gu8ngDXlZ1SUzx?=
 =?us-ascii?Q?WF9MJUfVxxs/7Wu8teZFaknkEKu7ilHFYXl3jxJGFwWACIgFkiGcVhU/G225?=
 =?us-ascii?Q?iQPZy1Xbvu9tcZSRDoLV24Nt+CK5V8eEpynraAYSVAanYy3CO6JiPiW4VEUA?=
 =?us-ascii?Q?JcJlKHEIciWrgjRxowqr2TydALQF10QztG1UKycetiYCzX77qBRUue+TeEVF?=
 =?us-ascii?Q?sbFo4meRM8pM4CP+qlKnQesh8eYKx/8/IkyluH57jwFnhHiiXklEM1LMxFDe?=
 =?us-ascii?Q?APMmxvpnq2agsHg83Xip7uH9bvinVm0OXN8S8HkFRFSnuZu71fBSAWECiMxx?=
 =?us-ascii?Q?j9Pt/5wd/I8jSIqOAW6MzuKUhb4hHuwsPf197/b9hanzhBrKlTX+Ne7oPl+j?=
 =?us-ascii?Q?UCrj/ychvBYW6eRxhcDBO5l6VNnJAVzpgP7W3ErSWGqKIBexGvvSvSoYRGh7?=
 =?us-ascii?Q?X8/EeU+ZtsET6Lq9tIzrlPzKXlAhlKi3ENseb+4aQX1TG+TDhZL0oa/dA3Tf?=
 =?us-ascii?Q?Hj7CZ7pFtnIKXt7Jts9SL8CLiNqWDTnF1LrxbJk7yesOAOZg6Iwk/qsSRR3Q?=
 =?us-ascii?Q?Dev0yvtVvU/N/dIigWMyCLwqkZXVnWeDbZ/rn5ZvZPDD2TSZONcoQ09Uk2kp?=
 =?us-ascii?Q?qboqCaBpKIRd83rmPR0RpsDHOHKW0kXYlzoOPBvmvmc8Cjy0P3AHIVqeMbDu?=
 =?us-ascii?Q?0HhBWTvHX/d0vCc6AryOAeKneDdOlQSdo6qd0qt+Qzy3QlUJXGY6UzDev74/?=
 =?us-ascii?Q?vf5Y0/zAaOvfHKhEu8mnZXMBKX2DHCHpFdFds4XNo1jjSDLO3BtR9YOBG7uk?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 633c0e20-4293-4e96-feec-08da6b363bce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:29:50.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFREOZYh05yLeD7A+WF5AUsfIHYUe5P/RW4XBPUFW+2nsN/z4JfPywoO3kogJt3WD37OJBTZmpJRv+Weu2nGwwDjBx1S2TonE4+y4wg8N3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4739
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 14 Jul 2022 17:00:41 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> 
> Hi Dan,
> 
> I'm low on time unfortunately and will be OoO for next week,
> But whilst fixing a bug in QEMU, I set up a test to exercise
> the high port target register on the hb with
> 
> CFMWS interleave ways = 1
> hb with 8 rp with a type3 device connected to each.
> 
> The resulting interleave granularity isn't what I'd expect to see.
> Setting region interleave to 1k (which happens to match the CFMWS)
> I'm getting 1k for the CFMWS, 2k for the hb and 256 bytes for the type3
> devices.  Which is crazy...  Now there may be another bug lurking
> in QEMU so this might not be a kernel issue at all.

Potentially, I will note that there seems to be a QEMU issue, that I
have not had time to dig into, that is preventing region creation
compared to other environments, maybe this is it...

> For this special case we should be ignoring the CFMWS IG
> as it's irrelevant if we aren't interleaving at that level.
> We also know we don't have any address bits used for interleave
> decoding until the HB.

...but I am certain that the drvier implementation is not accounting for
the freedom to specify any granularity when the CFMWS interleave is x1.
Will craft an incremental fix.

