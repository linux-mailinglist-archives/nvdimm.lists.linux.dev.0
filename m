Return-Path: <nvdimm+bounces-4183-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8C056D245
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Jul 2022 02:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613611C2095B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Jul 2022 00:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28311847;
	Mon, 11 Jul 2022 00:47:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AB71389;
	Mon, 11 Jul 2022 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657500435; x=1689036435;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PVK9RHUw1b7gAb5pU7AUwK3Nd9IclgR+QU1i3hK0UIo=;
  b=jjdaQpLQ+KPJT1AC1HsPGgE7eBMAeiCNeSdiduZvYiweK1XzumaH2Zn7
   nyINbz+rsn3JxcPNeqIE5FzYKPbgtWGma+6zAzs91WmZ+12pV3L/a+IXP
   VXFCNzniezriCJ0h4rCmYz/ytNv2H2LsRt5acRUU8rWZ/j3/TlsY7aFcr
   n+KTygOzFHJML1HhHujniqJqqAKoZCm/ue3qVgAW9Nrc125+nbYCtfMtM
   +hbLNJRB5KTCqlz2rZzFHqgpqtkfQHe6lgGd0FpEPKSwmJqiunNgouNoy
   oyu78rweoT4nXeSaiBeQXjUp0eeldIYM7mBGri7pHb+j7jTEcRUG6VJue
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="348533215"
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="348533215"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 17:47:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="840844845"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jul 2022 17:47:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 10 Jul 2022 17:47:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 10 Jul 2022 17:47:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 10 Jul 2022 17:47:13 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 10 Jul 2022 17:47:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPua90/1r0L7x1eBDHHlCi6Kmdj16XwXwl7LJaomFhsDeILKnc2fxAGSM3h4A5HK8OYsX9uztzB4HDeDy4Kd/zlJYf/07gzHYuFvOqDB9PsUkaHdf7FFRMUPOaQDDJIPqZKTEWHiEXTry7B1vEIQL88RmTyVmAFKR/u1iOdKryUGMhnUnqWcvv7th1qEfKLJixSrY6Cu3gNViYbr20c+MXP9uLOkywMrrSrnrXa9m+P9tASkJvIYZRDuQMZX/uHTCWKEX8rrr7iEFqx4VnvRwDxp6RAMwZGpmppsXyCcEEpTR3n3Fe0aNkTM3e3ktUOlY89z3rqrXF8bMP+cbDb75g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CdFEhvFCfkzMu0fZkqvC3VWE5BEZ2pV9nk25Q4j7qM=;
 b=Tt6K1s9toWOQuDWB21CYzcA1HvVoFa44McX4PPMIiosrVN5H/f4loN5BvAtShXId1kdjj4i7zt8LrH8BF47zBswlv1/iw0Udni1GWrq6OSQhx+8KZ9zzoeSz7uEPZCqBve6G2UNPLwhXY2ze30l2el+u5m8H4P9X/JTzbThWcZcMqkGkB+1Jg94aGURCFSPiZnkNfOaXDstNbllKkSp0jwJaEelLmit7nRC9eNJfSevExz7ZXwpA200J73X/G2uPs4mZXR+D5szhqOawTOVicaLIHFIlwuOz9E2HrX8VhKQeaqBLt9AUSpMucwmSDQNK1y1Ifn2aa6LPAm0fVagnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB4331.namprd11.prod.outlook.com
 (2603:10b6:5:203::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 00:47:12 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Mon, 11 Jul
 2022 00:47:11 +0000
Date: Sun, 10 Jul 2022 17:47:09 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Ben
 Widawsky" <bwidawsk@kernel.org>
Subject: Re: [PATCH 37/46] cxl/region: Allocate host physical address (HPA)
 capacity to new regions
Message-ID: <62cb730ddec26_35351629437@dwillia2-xfh.notmuch>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
 <20220624041950.559155-12-dan.j.williams@intel.com>
 <20220630145636.00002f12@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220630145636.00002f12@Huawei.com>
X-ClientProxiedBy: CO2PR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:104:1::15) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bd4ff81-ba72-4d64-8f38-08da62d6e435
X-MS-TrafficTypeDiagnostic: DM6PR11MB4331:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tT2PNC/Ru1CQJ11MI6YF6vWaatShFlo1GJglGoSdx5T1aPoa1vY5sOzGbIJ/bB9CBFQnm5ezmLrPUeONW0YnIig+WWTO9ix0QOjiwetQ8vD5c0EH3yRxlCdOUi4aBsWCTqaM+7fyf4IJsSjSm17S1dmH32d0gyKaytoWgCm4C5EL2AKASe+Pqpq6s0dUm9v3xzH2Bm+tkONmVhMztxFt71ICle7ZguUBQDeKeMbeFbaM8V47GzPlvoo16fLK/fcrKmj0OwdSk2GJWGv3RyUxdFBxuqNmqqCo6A+wiU6DvVgX9V0qKbu1niOLnWsPSFhic1Vq2ILq4Pp3NZArKFrXcDj6alHNfgtFJI1OIIs65bMs8CeFMave5nSY2GDbeAi2YozduuWJUT7rAUoPoKetE3Dd5j9xrVkR9IYv2kE9HxitiFQKwheyfSDLkugWpzNHsLbPW6GhTJ6wojD0F4nX561IcRL98Jf34kShiu1VXPV2qXQ2snhw9YPD9azd1DsERZSct1nIKWs6Yus+g+X92i8W5cN1WFNZOg2MGYaJOk3R6OxauWKsbXDNfKlz3aUAXFgpr+w7ollCddvdNX1E5ICgl/tMWQgHed/XYeojSS1ViG0Skt/gdpIt9g3B8D1yeHjob2lI8fqFLs+aX/hCcOM2mLWerI7hynnPdnpNCIOd3YcqNfp9UT3ezeZmBgqqeo2vxYfiX7dHMblEMf1Pyaekmoy8U/jJVrCjphUrRyWeyk/4xarUFMoyq0AppQoTOSVhfvP220NTK0wnD76SoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(396003)(366004)(346002)(38100700002)(110136005)(6506007)(82960400001)(86362001)(41300700001)(2906002)(186003)(4326008)(316002)(66556008)(66946007)(478600001)(6512007)(26005)(8676002)(83380400001)(9686003)(6486002)(66476007)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d5xrBXpQZk30LHt2QwSRiylqj19PqcqA3CiFyD4g2GIO3M336TwxlQnPTQ9P?=
 =?us-ascii?Q?Ktq7Q4ywb8lBlnWeN9q9eWXvAEKuMwAQ+aKp9boc0se2SbJj472FXjzG0Tjs?=
 =?us-ascii?Q?+IKn4MzVydNWs6UE7fi01ipdV+dLgeyJBXxyW2Ybo6gh4UU0NlU+07sDZAUt?=
 =?us-ascii?Q?yEX9ngt4T8hGjZFLK5bi+FmdFwwfGBli8HekZETMRlJHGnM49RraQWqW9eNi?=
 =?us-ascii?Q?fA2sWpA6+j+Qgz6MVkhOUnnN1V2c/YZZJCKntcbBWE/aPty1ZRC4enQQRM29?=
 =?us-ascii?Q?gu6nTXZR5laJjRjIX6epOMiDtGXuG66oP2vmop3RFkZJyOiQgLU3Z01PyjPB?=
 =?us-ascii?Q?bHlueRu73XlPwNcf9pOk0lZI+hLjbco3WUmOxep17mZG5Q7Zcsfba7p6rd6W?=
 =?us-ascii?Q?8sHXbC/SOlXY37KUU1CFg6Y/ACNncGdGI6B4f45rCT5/mK2MxaMBi8Wr2uE0?=
 =?us-ascii?Q?ZadLeB1Cl/e2Qi09Rli4M+qE9B9XrJ0yalfPKwxyeCY9SMx7vrkN9Ryvk6Zm?=
 =?us-ascii?Q?/8NKHWFG/vlQuZL/jUpQKnlc6jtmBbCV52UcxvMsuo7V52dwE9SZ4VxzwzGj?=
 =?us-ascii?Q?qXdXIqqs16fvUbdL/HL85/qXGaAw1YCRvZqJSCCEhLhZ6E267sqS/EwDQA5x?=
 =?us-ascii?Q?ve6ZW2qxHShoxEao57bicu9P38bUyat2fA/Jb6V+DQKS8kQ73605/LF2HMp4?=
 =?us-ascii?Q?OyPsDpi6H82ImGxfc8wlsnId5TG+WHs/2IT7SwpU79h46BCmm+rswvZAZk8x?=
 =?us-ascii?Q?/u8+rXuMv4eyphnXeUGxN+6TJErzIrSSYPWbXETKWp0fb6NoUFnksAN+ftA2?=
 =?us-ascii?Q?9NlfXGYjpMmQGMO5SrcMFavBhS3OzGyl98zRg2Z95Eqf7ibHEDFOY19rYBLH?=
 =?us-ascii?Q?TxrBMbIuyIyqcqU7iXkeOAr60+qDm3ZUis236MTF0hTNK1kVvbO+J3TYiB1B?=
 =?us-ascii?Q?nXjj+G0ajxeyrTeaDwsYa00nFcGzl7sjms/q7ooqlJ1EMGqdktW8p+jQTJAr?=
 =?us-ascii?Q?7ueV6cVxfIp+ZlOdyhQYy5kpDEKEz8d+yQlZjOi0k2HiNdg0Bwc+J4okh+Fd?=
 =?us-ascii?Q?BHB7oIy0FQUH7aFvqzij8MOgfa6GY6rDD2oXXO+EpfeALC/UfMVRHTN6Fewk?=
 =?us-ascii?Q?GZ5p6HJjux6ADeqykHqaeZu+4d8R2qfipNZcwtarILG+BSGtxzBea8uHl9iw?=
 =?us-ascii?Q?auN51t/GiWdQw43A5BLpm26EgDj7eXAAkcTFVmO5sGvDrdOWHEWvQsoxCnPS?=
 =?us-ascii?Q?QfrGbpujrCpvk/5tpzQHLevPu73KM8+wrOPniwvlBWzu1lzudMxz8kqUZGA7?=
 =?us-ascii?Q?mWh+XVV2rDDTfx4vLE8IAMTx9P0myVEFteCEKRj17iwGDb7ir6NacFhdu7PJ?=
 =?us-ascii?Q?3Bi9uZNrzZHFvju54Nk7hBLU+UN5H28ZfsD6uusRUzcAExIKENzK4pTFgm+w?=
 =?us-ascii?Q?n+Lx0ncA1mZmJpKUlxLUwx/NqAViIJhgdPQEwm+W2VOrQ4Y8E3ugdze5+iCA?=
 =?us-ascii?Q?24sDjG7R7gN1xR/07HpI5nGPR1OBdVOn7YaWPxGp1MpBcsjhcoQe07DgmT9T?=
 =?us-ascii?Q?ozkw/YCuJ1MAPiNMCacBOD9iymBiGgQTSLNVWcnK+rBHD/oYTr5vF6fl5xcB?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd4ff81-ba72-4d64-8f38-08da62d6e435
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 00:47:11.8991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYxbY8T2TiWStDTpUB8CiTZ9DGcbmo5zS8A+CjOM3w4LFC7wQp4ZhgjiVTkYoBdconIsb+YubgCzE/OThd58nSbz/R4fN00u+46wutCn1q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4331
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 23 Jun 2022 21:19:41 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > After a region's interleave parameters (ways and granularity) are set,
> > add a way for regions to allocate HPA from the free capacity in their
> > decoder. The allocator for this capacity reuses the 'struct resource'
> > based allocator used for CONFIG_DEVICE_PRIVATE.
> > 
> > Once the tuple of "ways, granularity, and size" is set the
> > region configuration transitions to the CXL_CONFIG_INTERLEAVE_ACTIVE
> > state which is a precursor to allowing endpoint decoders to be added to
> > a region.
> > 
> > Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
> > Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> A few comments on the interface inline.
> 
> Thanks,
> 
> Jonathan
> 
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl |  25 ++++
> >  drivers/cxl/Kconfig                     |   3 +
> >  drivers/cxl/core/region.c               | 148 +++++++++++++++++++++++-
> >  drivers/cxl/cxl.h                       |   2 +
> >  4 files changed, 177 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 46d5295c1149..3658facc9944 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -294,3 +294,28 @@ Description:
> >  		(RW) Configures the number of devices participating in the
> >  		region is set by writing this value. Each device will provide
> >  		1/interleave_ways of storage for the region.
> > +
> > +
> > +What:		/sys/bus/cxl/devices/regionZ/size
> > +Date:		May, 2022
> > +KernelVersion:	v5.20
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RW) System physical address space to be consumed by the region.
> > +		When written to, this attribute will allocate space out of the
> > +		CXL root decoder's address space. When read the size of the
> > +		address space is reported and should match the span of the
> > +		region's resource attribute. Size shall be set after the
> > +		interleave configuration parameters.
> 
> There seem to be constraints that say you have to set this to 0 and then something
> else later to force a resize. That should be mentioned here or gotten rid of.

Yes, a constraint that precludes questions about what happens to
existing data during a resize. The force trip through a zero allocation
is to help codify that the kernel makes no guarantees about the state of
data over a resize.

Updated the text to:

    (RW) System physical address space to be consumed by the region.
    When written trigger the driver to allocate space out of the
    parent root decoder's address space. When read the size of the
    address space is reported and should match the span of the
    region's resource attribute. Size shall be set after the
    interleave configuration parameters. Once set it cannot be
    changed, only freed by writing 0. The kernel makes no guarantees
    that data is maintained over an address space freeing event, and
    there is no guarantee that a free followed by an allocate
    results in the same address being allocated.

> 
> 
> > +
> > +
> > +What:		/sys/bus/cxl/devices/regionZ/resource
> > +Date:		May, 2022
> > +KernelVersion:	v5.20
> > +Contact:	linux-cxl@vger.kernel.org
> > +Description:
> > +		(RO) A region is a contiguous partition of a CXL root decoder
> > +		address space. Region capacity is allocated by writing to the
> > +		size attribute, the resulting physical address space determined
> > +		by the driver is reflected here. It is therefore not useful to
> > +		read this before writing a value to the size attribute.
> 
> I don't much like naming a "base address" resource.  I'd expect resource to contain
> both base and size whereas this only has the base address of the region.

I think there is too much precedent to rename at this point.

