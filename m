Return-Path: <nvdimm+bounces-5006-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA91360EAF2
	for <lists+linux-nvdimm@lfdr.de>; Wed, 26 Oct 2022 23:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A261C2092D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 26 Oct 2022 21:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A22AD5A;
	Wed, 26 Oct 2022 21:50:11 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2754AD59
	for <nvdimm@lists.linux.dev>; Wed, 26 Oct 2022 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666821009; x=1698357009;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qtfmaMfSjeTMfBv/58FlNjYnQ8+E5wpnC1joWShglqM=;
  b=j3lmXtH8gzFth3W1l5+j2GhxlgvVFoxLJn7PmmwCrxnItB8N1TTbqI0S
   hlCMFxwj+divuBi6CElK/ZsebedHpeAx7XaTIA2kgs3tqLwZsBgiceF60
   v2uKGVmpOWsbEkfhYkWfRcKktal6m8MD5BJKm8c+pnxh/4VlMvGsH7b/0
   sDAXTDfGz7MFNrKRPC2NU2Q7g8brOwgVIFPDqCObrtpipcNxSmN1cuP19
   iBJcU7NaFPcHFpjAOPBoSffZKUQAfZiNKWKvqeFnYjIQFzfNLcmOUYLhZ
   fNgCdH+G/zUk+5agStMUCEhgEjEeAwCv6Mt1AhUMD2tfOkwnYChhCnvkH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="372278959"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="372278959"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 14:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="774760396"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="774760396"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 26 Oct 2022 14:50:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 14:50:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 26 Oct 2022 14:50:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 26 Oct 2022 14:50:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOztYwLfTg9mdL7qc/A+FVjrFPP8HNEhET6kIwc67ZMQ5FHSyMNBVwjSRl62+6yg+6WxCp/23SYsClUmkJph6NBh9rUxW2Fl8/tyghFBKGR8yNVXvsDa3TKSDyo7I1Rysby5kP3d6fBXTTjILeNZUTY12/0g10nxAvjKBzBwBU/0OAGewNPhMpbwQuT85gfj4LBYhDIW+bBSJSaB8CKnYK1EuuzKbjOCugz+3R0+GzxWj8rNY9HWR8bmdBM0MQs6fPhe1l3+FqVpc3Qr/Lv3ZpJP3MT41qAY/awsg2vcdSFVVIHg156ccun9od6BGpdDFTCeyYfd5JqZN7LjjV7QSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMGBayx4hiWAUzoqmqITh0V9W4VNjoGd4id+A+g60Fo=;
 b=JtcX00fSuApDRnCrXlEuEPofINzkZ84bpt9Y+Gh37Hn+zZKnScrdRuRqXctFIEbv6Eec/EqGzwRSYFkAXpXIiraFPkB+8P0a9ZwjN+aoQEc4C5aNlnkmbTKwQqlq1FVlpvQiDhcFMT6SlARHIR80c7A7LJESFWy+bDsnaXsZRYIYwIVbIcnNkRpAQWh1mtHTW7Dpf287zHmufoOK17OVhxWDOb2cEjxdyZiPcJaN87U9RONmbKjIZoT3CYLKHYNmt7558gjxDgMahtPg/UxfHn1/FbGQB8P+i59RH8q85IRwTxJy0GjYAK28b/5YwH4PM+RcxO0cKsPgpSrsfu8s+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB4966.namprd11.prod.outlook.com
 (2603:10b6:510:42::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 21:49:58 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83%12]) with mapi id 15.20.5746.023; Wed, 26 Oct
 2022 21:49:58 +0000
Date: Wed, 26 Oct 2022 14:49:55 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Michael Sammler
	<sammler@google.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
Message-ID: <6359ab83d6e4d_4da3294d0@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221017171118.1588820-1-sammler@google.com>
 <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
 <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
 <CAM9Jb+hk0ZRtXnF+WVj0LiRiO7uH-jDydJrnUQ_57yTEcs--Dw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM9Jb+hk0ZRtXnF+WVj0LiRiO7uH-jDydJrnUQ_57yTEcs--Dw@mail.gmail.com>
X-ClientProxiedBy: BY5PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:a03:180::38) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH0PR11MB4966:EE_
X-MS-Office365-Filtering-Correlation-Id: 40851ac4-c396-4eec-1a97-08dab79c06c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UvwVg19Ez0WKmT5zRcubF7soPrOF0jXBW93Mx5rwWI9RNg6fILzadNxlZWFMHu7z8pPd3AePlI9ozbgHKxegb6+zUpiChqOfdYCRGnm489gwGeI7oIiHPJmYAoXp+b7BJhCy5UyeqNTub3EDuMfR+Q3EyA8GCwNLqCgicTIf5IffMRjdQn6L+n4hFl768DCgt0FphU26NciioqwiVlGqywt9hlQ+hivsRqNztoP5joDYlOKCsO3hA2i0TDqbxmmtyEfLdr5FB3A/blXSDYROkUA8sG3pGzzyz416L2Ubm56Aq+BQ04Q99rx64Vcu5uUrCNvJzaTmklEjEjYNCfTZ/iD7uTDfeNc/JOOpqmsspDAF0bCk0eKfHDrOg+B3fl4/9ZujiRJaAbt8DTuAJA2BCpYn3dtk1rvVG0iyh2YH3S7tYEk1s0n000gGkO8oJS3nnLTKNtmD4qss2LQOq99hsnRcl958mbOs19v0P5WnG9jzBnLUS9dTpVqTqXPY1Dgq6TAzSjJbc/SXuRVF8nKRgFW7ibvGxbizOdaLTo6DsiAp7ipndCk3m98svnXdlkQFiJOjlXsXAB/oHZgCEPOeDwgOWK1c/sWhYoX/cGtJjoM9d+MJ+JYSmsCynq276Vo162QINadGaAGuq0YVf71duyY7kB+qNQ2usL9HUkk+J7BFRBDyVz246LBA+ElejsTDt/TcyaTrBMK+CfsAoMHfMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199015)(41300700001)(5660300002)(6666004)(66556008)(66476007)(2906002)(4326008)(66946007)(8676002)(186003)(316002)(110136005)(8936002)(54906003)(83380400001)(26005)(6506007)(6512007)(82960400001)(6486002)(38100700002)(9686003)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9hdz3jN44KQDz55zJKGgWkZKHo6q3uUNTv4Yivyn0yh8mRUQZxOt6brLtnsi?=
 =?us-ascii?Q?nD9T3DvrcryFgjx/vygYRyXe4lrMXBY9VP7pKpSXn7WtDEbGfPMY/ey0kRQG?=
 =?us-ascii?Q?l6nYSTeC3HXp45NTLHjDiTkyrok7aYTZG0YhYVKuDLqoNU+3jPBknb8H/vXW?=
 =?us-ascii?Q?5URrhZdxIkC5mniJCn3OmuUVc+0p7qnmpRAffSgR7lthU3kKx6SslDMpMKk9?=
 =?us-ascii?Q?0eHfl0nA43YVm83wMTaGOGjJvMqe2M3wncp89P9LoTuMpazQbYhAmnypZwN0?=
 =?us-ascii?Q?EuIK6vDV3Df4U65ts33xTLYWlh/Wa44pPafj/jyI8CJw4GM//GVV+SUuTrEp?=
 =?us-ascii?Q?i/Puc9zExWPRmUEqh3Ieq71ekXBsZHcG6RncrmKw1qeVW6eIgZ1E30+m1J/h?=
 =?us-ascii?Q?IaNXaF1XQqOonQs3Xnd8RVoqSRHvYxBCQpNAYWY/2RoPOQuaoI5C1leFaghM?=
 =?us-ascii?Q?447M8jJOiZmvKyeDbPrhTUCf6zrLJiqiwj4DBZuZQWmBwXgnVGWWC7keW1zd?=
 =?us-ascii?Q?J6MM8Dvk3cKKkeypwLJIXv1IUhMMJdKvs19QwyweC4TL9MQ0k8Y9k+GgxOn2?=
 =?us-ascii?Q?nOvDyarBkSyuiQIji9vYVfcMEPFaCHVtDEBZ/1ekaHUq4R1C56lBdx9wswih?=
 =?us-ascii?Q?+EbT+GZwRT+SmRpZltX4smUz4+EmKJ/hnpcfaAz6rIoO41Rc7BnCF36DENHq?=
 =?us-ascii?Q?ii4fqMOT9llXkANNi5Vcd+Tyac8CwkSA4xvEhLf3txwGaUvZgCaxiBGWC7eG?=
 =?us-ascii?Q?5zbeB5L08eQ9dekJNFavMhQGIkHvQ3EkZ3+hoK/el1VS+ahGE95Iyh7aDCDA?=
 =?us-ascii?Q?CtqGuPqJVh+BuriDLBXZ+I5jlalTLE5+f60v+Pgd2HR82DNWgFuME3ZvSEIq?=
 =?us-ascii?Q?JLq1UvPpi3h2ua1lTmPIaKveiw4sRhQzbV4pC7m+CJdjdzGssT1/U6Ws0mPk?=
 =?us-ascii?Q?cma2YI1FKVCHmnoyKMPqqMzPjw01vfnpupYnZ/VTtfZBZ2UibsEJDkrg/bgE?=
 =?us-ascii?Q?chCib19RPesJMZtbUsbPkmrV7uGE3xzc4QJEgg83mW900vLh8njo1dVo3WdT?=
 =?us-ascii?Q?yc2sC7SD1j1rgBWj0U0+yMEYE128CRTC2HVdFeNMW0BOcttxyvZVLXbYFQQR?=
 =?us-ascii?Q?e4c5Gh/WkYydJP/Ojzqm13GpisUF6AqhIHiW2v5vXN+JzhaE6lHUcvo7nYXD?=
 =?us-ascii?Q?P5zB+IbBb329whmDuwGvGeQFsnJ02lh4+FowMEngPu74r0tU3jS3+kk8NQSE?=
 =?us-ascii?Q?xYwXu8y6dcOX3aVhPm6ERAsLy/pmK+IE38DQMk7YoluAKsHeWnl7ttEUyD6E?=
 =?us-ascii?Q?AAdNWmCvFAu4qie1z6LKhZfo0Pc410DVZrgtClus/BAG45VrpxYKtJWaNFhA?=
 =?us-ascii?Q?x9Ul/QJDgtNOPhR7TiXwqphWkVmvpSTbQ1e4v6h3BO2zMFG1UzI9D90KEoqF?=
 =?us-ascii?Q?/CfLrcSDewHEQGBX/v5huSnxytwzSiJhKCmI4/v7Sf0bTI999K6B0Qk0Vmpj?=
 =?us-ascii?Q?GLMfoyODbZ/5ODSHooAbP3aSmtSol5tL0qBUu3exx38iwxt8c+ddEHbZrv+B?=
 =?us-ascii?Q?ag2uIlWHpN/LQ8caQ5ettwyr2LNBqfCWeeuWRMpQSHxW+nNyHCHiQgbI5VgV?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40851ac4-c396-4eec-1a97-08dab79c06c4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 21:49:58.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf8hKAjxtGBjHTcZ4si1Dey/b+19ETQ4HuaupDrIP7R5NzbAp+4t5VbNSiVSy66RLzviEmUFUl3ifYa4yYUYOpNQOYQNN81zipSVtIy97rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4966
X-OriginatorOrg: intel.com

Pankaj Gupta wrote:
> > > > Compute the numa information for a virtio_pmem device from the memory
> > > > range of the device. Previously, the target_node was always 0 since
> > > > the ndr_desc.target_node field was never explicitly set. The code for
> > > > computing the numa node is taken from cxl_pmem_region_probe in
> > > > drivers/cxl/pmem.c.
> > > >
> > > > Signed-off-by: Michael Sammler <sammler@google.com>
> > > > ---
> > > >  drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
> > > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > > index 20da455d2ef6..a92eb172f0e7 100644
> > > > --- a/drivers/nvdimm/virtio_pmem.c
> > > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > > @@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
> > > >  static int virtio_pmem_probe(struct virtio_device *vdev)
> > > >  {
> > > >         struct nd_region_desc ndr_desc = {};
> > > > -       int nid = dev_to_node(&vdev->dev);
> > > >         struct nd_region *nd_region;
> > > >         struct virtio_pmem *vpmem;
> > > >         struct resource res;
> > > > @@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > >         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
> > > >
> > > >         ndr_desc.res = &res;
> > > > -       ndr_desc.numa_node = nid;
> > > > +
> > > > +       ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
> > > > +       ndr_desc.target_node = phys_to_target_node(res.start);
> > > > +       if (ndr_desc.target_node == NUMA_NO_NODE) {
> > > > +               ndr_desc.target_node = ndr_desc.numa_node;
> > > > +               dev_dbg(&vdev->dev, "changing target node from %d to %d",
> > > > +                       NUMA_NO_NODE, ndr_desc.target_node);
> > > > +       }
> > >
> > > As this memory later gets hotplugged using "devm_memremap_pages". I don't
> > > see if 'target_node' is used for fsdax case?
> > >
> > > It seems to me "target_node" is used mainly for volatile range above
> > > persistent memory ( e.g kmem driver?).
> > >
> > I am not sure if 'target_node' is used in the fsdax case, but it is
> > indeed used by the devdax/kmem driver when hotplugging the memory (see
> > 'dev_dax_kmem_probe' and '__dax_pmem_probe').
> 
> Yes, but not currently for FS_DAX iiuc.

The target_node is only used by the dax_kmem driver. In the FSDAX case
the memory (persistent or otherwise) is mapped behind a block-device.
That block-device has affinity to a CPU initiator, but that memory does
not itself have any NUMA affinity or identity as a target.

So:

block-device NUMA node == closest CPU initiator node to the device

dax-device target node == memory only NUMA node target, after onlining

