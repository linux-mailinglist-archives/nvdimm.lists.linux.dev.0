Return-Path: <nvdimm+bounces-4853-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 240C75E5715
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Sep 2022 02:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7EF1280D40
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Sep 2022 00:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC5D185D;
	Thu, 22 Sep 2022 00:15:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2187B
	for <nvdimm@lists.linux.dev>; Thu, 22 Sep 2022 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663805758; x=1695341758;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VNziUwgzcET52uESg6HbcA9c3rRb+oe1qqAYTaWfjkM=;
  b=DTpGSW/hJPYWjh3js3ww7gwtv1v6kYhulYsjKWs3YOlkhQ6WA0jtUW5d
   8OO5afjWHy4RVvbrzNACD2fBOLQehHys1/H7bJCAaMiGeHyIuvQBKN+mw
   UYng5C/cA0xxRDZpx6p+F1u7FjVy8SvkNQOvritgQXMjY+xGfGcXi52BU
   pQ7v8oyY+5tMx/feDRHbCVZFzyj4MI0AzHTjxV/LN+aXDguQMQL+dh9Yg
   jDzk6jxoBucGjfPdrkF2tbRzLE0AbI49rmwVhQB3oqPsvb67dd0pPxLZq
   Nx6Bdptr+3KGwEUDyBQ5Dx0vgUG+9vTj59yo2QdpJHpNumc5CCAVnf+WO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301563376"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="301563376"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 17:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="615007945"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 21 Sep 2022 17:15:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 17:15:58 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 17:15:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 17:15:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 17:15:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiFf6afNgknaScdB/u+bxYpxNBeT3IozP8nNyt1ve3kdAu4bAOxTkVTxs0p6QH9U37nDpzdWCHpysqipvqiBJ+9ky5ufzlfM8gcTqisox8LskWb+ETA/93X403uplBwz2p8c6QuhXwLhI0h+FEopp+f40sVfHPvxB8OviNPEKBdNOivCQdohj5iJekJP0H7hshIYtTdAcPBCsrcINolWAlYM8nM09kR8dGVmpAsd237UXoR3FI+nq4dKFjA+w27JtmTWmu16RqnyCuJopc8cyVC2t3qm/Rduzs2f/emHnnX7Vt8aWQzGoP3YQm2SuxtkvZHCDwO1CRzImc/r5TMwHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9oKcurAi+dmDSEDbVyWTRn2SmyppmGMlOykNZEFL9Q=;
 b=Lk7KiDkI2qu/xjXRLU0amBs0qQEz5kADnMt3N4elvn1NHO2maLB3HPP5a6E08mPhzb21DxlAaSflYCGMWswYzpfx88tExEb81wIbhz/scbUArJffvSmdyPVBdzvzZfgfs6k3gRkXV1eJ629icOdGGR1heoRlpMhK7EL8w2j4naB3z5HJup2d6MZcSfVvP1fHJ3R4FVuz8qjmMW7WtmIs1ZaTzptjRv03C8SdRUtugIgnwQxy0On/rZb6HOwsAVD4M4kNdxS4WWCsNbOOr0IWjEeYc8V/ZOLxB9Ho3kiIQS5h9KQtH492XeWGXUseBUxjSpyP4weh+XrLmglSfb9ybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY5PR11MB6365.namprd11.prod.outlook.com
 (2603:10b6:930:3b::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Thu, 22 Sep
 2022 00:15:55 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 00:15:55 +0000
Date: Wed, 21 Sep 2022 17:15:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Dan Williams <dan.j.williams@intel.com>
CC: <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-xfs@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2 15/18] devdax: Use dax_insert_entry() +
 dax_delete_mapping_entry()
Message-ID: <632ba938754b5_349629486@dwillia2-xfh.jf.intel.com.notmuch>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
 <166329939733.2786261.13946962468817639563.stgit@dwillia2-xfh.jf.intel.com>
 <YysbXPnA3Z6AzWCw@nvidia.com>
 <632b3246548ff_66d1a29431@dwillia2-xfh.jf.intel.com.notmuch>
 <YyuO0ZL0HG6zZ9PI@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YyuO0ZL0HG6zZ9PI@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CY5PR11MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c2f261-a439-43f2-a721-08da9c2f9dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWxtdj54ccX6ydelQ3muMkn/9cnsKSCkDtlsYvf+X3pl6fIbNhP6dOKfxDcKtS/SCpxemXZ2H3Gulm5NVImKCV5iuw6LnQLwthZAfRhs41GL6hFAXIBnaNxpAoHG5dCZvoZdlQJpkz9zGSo5fqOWdODycPcRFuVckj3FHtkMy/VgshpN8P6tAPvHkIMIozXmSHwaUVOGM6tPnxB7uC7+0auWtkWFIcJssgftsWc09Z19vON1mipi5GO1aw1aOBs2ULPc8MPGRwYH8GZV2vy7+K/HqWiYDWmQhooT6LUvVYVJ0ZayQ0kvzaeMPQXtz/Rck4SR9raqqlaUAXE+vKhELq4R1PYrrFJ12T6W0ER4/2Rauc4Nv9h9spTx64rJxixvZJU/K3EqmsNj8Y0djv7asAfc+UUwHXv6ubhSY/l6jujDWysff5Gc2Wq+zkvVt0IsEF+9tmcPJ8YncpqtobBbZKoaG4FsXfYPh+NYOeewH3m2fgW4miXaSrA9DYflD61aGKRJibr91u2/GWHxjCaa3WUDyYviQEdaTysf1xy/WJcWpfPt4I21eCc8w0CvGtr3o4Uip1d+CvS+3nfRLrNX5lw2EQ0OXsPbJRDspmNFGOitEQzRyIf83YbI3ZHqQJFCwX3l2sPhKlOQ/UBjj8IMlzsRXOt93mas/EMw3n8r4N3f9Z76Jb9OSOVHDLCKYQX/XtlJbkCsPoM+KL+2REeTyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199015)(316002)(54906003)(86362001)(5660300002)(7416002)(83380400001)(6486002)(2906002)(4744005)(8936002)(41300700001)(9686003)(66556008)(4326008)(66476007)(6506007)(8676002)(82960400001)(38100700002)(110136005)(66946007)(186003)(26005)(6666004)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iEqcyxN6juwnwm5lTL/Mmn0x37qDOgIf4jP8QbvhGeLl6Y9nKatfIP+deqdj?=
 =?us-ascii?Q?ozrt0JUC8oHmmzBF/C4Ynjk3IoNLkkaP/w/zmUQLQQhtYKma0uKC89VBXmNs?=
 =?us-ascii?Q?RZPXYz9eP8qeB5svQruzSdzv48gBfcpn+/OBnDfAY9ATtI6R73/sl0O6qNZd?=
 =?us-ascii?Q?FV82owWYEI+GO6KoeHFlyvVMIKcMfJ6/2xsRCOa9zX3dkskSEJzs8sKYeW61?=
 =?us-ascii?Q?NmomMbas/wj6RckGTRU6Wsh6wJ6QIVUEmJNaY0NRGzC43z896VCfUHnDdIlo?=
 =?us-ascii?Q?1NDsGCPOe+dsuD+jJj30d8VvIsctbc0G9DGj02i3jhx9fMmMOpN1DPgj09Oc?=
 =?us-ascii?Q?tFR1WVRntskU6jdROhE6IkzAuef86e3FLKs046x4bMEDECLHAo82viV+KxXA?=
 =?us-ascii?Q?rjZ5RJ5VO6E7+ldY3FZuW4qUdrg1Ly/+eYYh40EI4pk91Pi9AQFBTthTP3BS?=
 =?us-ascii?Q?hhLf/DFVk0toBum891VH0OUocfE3N9p1NyFNHiHwgOJdGU7ktUt/CAeTzuO2?=
 =?us-ascii?Q?PCIuNNvUGW7Y3+/AgO5rlMytqlmHtzJq3zv4TeOMk2cvO02YFogctCOv6zmO?=
 =?us-ascii?Q?6uXuNIN+am2GWM8UchU8gzXJLfB1CZOPYfNuI6MmyLN/Cm8pD2cETB17XHCw?=
 =?us-ascii?Q?nmYNHnVy4UX6ENP9/g5OrDdGjn1prgQkO5el948z76yrJCStBQ70Nj9+VPya?=
 =?us-ascii?Q?YH/C0bDZXdDj5c7Gh0jXO/xt+/wzLqw4SPLQW3hY7RAHUYdfhuk20Stm3cst?=
 =?us-ascii?Q?o/gUeB/7qIkSaJLDYvhg1xKllE1DyyQD4F9YM/V+NZ/kNpfAxnF305n8mBKe?=
 =?us-ascii?Q?6Zuiusl1vkrWH7zhHPMPGKVb5fj92sjynXSr1M+UonDUr/EeVDVeaEwDdoku?=
 =?us-ascii?Q?1yPCb++cmEE+hUs4U1adV4kmo81GdFsrnKDDBecAI7iO95AUJ/rl4z7YcfTZ?=
 =?us-ascii?Q?vFibGZbEOLSY4MEkbHRExL80B1Ki/H2FDslVsan9+1wY5e8p6lULgDDFULDt?=
 =?us-ascii?Q?X3vSps5GZcSOmcKUm6s+CA/zDfklfPI2nXtCXk/FY3xW15S95gPA9kgAt+x5?=
 =?us-ascii?Q?Zt/Ryx7uyCI37uBbFQ0M6ukqwGkHpIMd1diJBZArAReq4T05/UKTrDAhEz0N?=
 =?us-ascii?Q?ONP0ieuxfoQ8Wzczp9eqjQzM3A3Vf43qSe8E+Lpv/bs44O9qrToH1yBcJw3f?=
 =?us-ascii?Q?wO84TQexP3Lx0nyRvJnIJZPBG1Gxjh29hHoGuSV8/7jqOkisCkOghyoOizAg?=
 =?us-ascii?Q?Ka8QnBQrQnku87ba9F0NV+j33DMIQzJ3VDfwADi8Pz+ckq3WH9oM4OeAJUzn?=
 =?us-ascii?Q?AqIQm/vwPo9lFNircIhoZrMsmVeSAdNnesKf5FD2cGfCbe9djSWjG6wfTRUX?=
 =?us-ascii?Q?y7O3b95cvUlTODMOIZ5NT+j1uhzuZwqo6AVdOxbN1BgqZuIu+SqwQhzPukS8?=
 =?us-ascii?Q?uV0tDNSxS3NxsomUeCXnOvmzfPRmFl/whCNCQieBcaM1Vvhdtu8R0rslNxig?=
 =?us-ascii?Q?xvtLefFKlhnl8Mo8LEOnbBMkWeTToLNmVVwipKbi1hCrvIpaC14pwRtMqVKx?=
 =?us-ascii?Q?lWlW/kSn5cM/BPCpm+GCUr3KG/XOwnaekLH4dx4dVM4rcU1XTS/2PFenSev1?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c2f261-a439-43f2-a721-08da9c2f9dae
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 00:15:55.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xoJKYDmelX4kZrdZHWrQ9MrQrwzcsQ+sid2cyI9gg0DdHCHSmrqOAJdzbuMzEE0r21lozVEwNppKTfys/CB0w6kd00bvb1A3l90SxkMRYkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6365
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
> On Wed, Sep 21, 2022 at 08:48:22AM -0700, Dan Williams wrote:
> 
> > The fsdax core now manages pgmap references when servicing faults that
> > install new mappings, and elevates the page reference until it is
> > zapped. It coordinates with the VFS to make sure that all page
> > references are dropped before the hosting inode goes out of scope
> > (iput_final()).
> >
> > In order to delete the unnecessary pgmap reference taking in mm/gup.c
> > devdax needs to move to the same model.
> 
> I think this patch is more about making devdax and fsdax use the same
> set of functions and logic so that when it gets to patch 16/17 devdax
> doesn't break. That understanding matches the first paragraph, at
> least.
> 
> I would delete the remark about gup since it is really patch 17 that
> allows gup to be fixed by making it so that refcount == 0 means not to
> look at the pgmap (instead of refcount == 1 as is now) ?

Yeah, makes sense.

