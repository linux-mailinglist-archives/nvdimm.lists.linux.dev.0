Return-Path: <nvdimm+bounces-7533-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3086861D3F
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Feb 2024 21:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8496B28384B
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Feb 2024 20:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C7A14535D;
	Fri, 23 Feb 2024 20:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RL/NOuho"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4808284FA7
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 20:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708718706; cv=fail; b=BKIkJ0LsdN7Gspu9Es+XOivl1/FrhTA5bSPg96Qlr36MCuQRMgsVYBN32k5at1WBJ5y77RrETysV4KqcKkBoti+co7eyCAX8Lq5tHwGdZBLSyc4BSKt+NGp4TUIteL9jz+OSk2jdgERUQKPByX/3jUrjwfc3EpFrR8vOzzb/Z7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708718706; c=relaxed/simple;
	bh=XoQ9t7Y468KAB7Wi1W2vlBFJSm0x7+/H1b7uakl4rG8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LkSPHUoRvAGmJqjNciSMbpPyxUDR1ZQFNcWUjhqPUfoPxicRmavGhX9Ks0WuqJDvOafwUaREFUhvL9ZF79CKNPYAyB57aKBfp6TSO/1rQayd6lDxGJTsQio+k/N+FPxq1OwvJm3VF4rY1kXHOCJsGiYIoYbXcOe05dfecB+ST+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RL/NOuho; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708718704; x=1740254704;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XoQ9t7Y468KAB7Wi1W2vlBFJSm0x7+/H1b7uakl4rG8=;
  b=RL/NOuhoQVEB9d1/ZMqPHMM5u/22kWp6HSg683ihSdZjfJ4E8kv5N5EH
   VMdYTL5kfnrinLwjtFsKXpe01nMCnZ6YlSZdEgHz1NO9uXFGWGY0hRET+
   UiDo2s1g18mYsbqGi1iLZIgCy3DJdDJ2VPIeWMFAdsAGElpAeega36vup
   ADWhZJJnIXV1ZbTgdTk9+MggnYgEsDxq8OamlBOW0B3eN9TvIwtWHWs0K
   v5kMa/YIZp7P78Ig1BWXM5wln9GsgivXNa+zGKlanUdidh7zWNxzqhIy1
   jGVlweeW9CkXwbGgYg7Cp+z71WcJdxbBT2YcEh7oVznIEzi4A7Jt6x2DY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="14464981"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="14464981"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 12:05:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10707108"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Feb 2024 12:05:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 23 Feb 2024 12:05:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 23 Feb 2024 12:05:02 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 23 Feb 2024 12:05:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha2ElRtT+6M5ly9054tFfsfKUFB85fT5l8yU3A0mO0ZHs6h2DKhmHQQecxL2Qg1oyIJ31iMi68uhe0iPhFjcfbAgTmL7bQA1Lazrx701y/pIP28tFRgp1rIG5oGtiN5iOgIX+EGxP1C5kO7ac023oAfUdVhZc7VQgZH3TmDbFHrREupy605TXxbx4P3l4g1PQRFIiKFaA1rDqgK6DBEneTtRArf+fq7ac6uGspREQzizBqeZ52BZD0N9QAzO2EhZqRImQQG0UmUsfCg8jhFGr2yzUK/hoPFj+VgnC6DgRFxncdvvKNBIuq7Jw7j67NAWdY9j23hb4YNk32JmAtHFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUSmRUIjpUGISQE+Xe+ZZdgKjxg3pehX3VxgGWN4dso=;
 b=IDXt4/i7ZQng2FUBwrSQrqJY0OVit90jMgYf5N6hprglRQ/UOb7j1mCyiEygAt3Q0G/eLx4oye3FvhtwkpHlLuZxrcSIO7vQPQ6HSqlknl/M8coJHR4gdHtphHaN7qY5y1HzZJ4lBj9bQAEgQN/DMR47JnlK0fTaw3j/JmeEKzvUYv0xRo+3GZOrI0g4Ni1zo+GA235ELGhwuiG16VdyROF0Pl4QdLZ7un6BgCHht2AxzZ4CHhXVREk5xN4dHDLeWOAxVyxD2ZL74tVux3zO4VmXypTXRaJUg8vmy5TIHuxayovr88++hc/hCsTsZQb/2jrYdy6za4/qtw4QLH8m0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BN0PR11MB5693.namprd11.prod.outlook.com (2603:10b6:408:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.10; Fri, 23 Feb
 2024 20:04:59 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::da43:97f6:814c:4dc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::da43:97f6:814c:4dc%7]) with mapi id 15.20.7316.018; Fri, 23 Feb 2024
 20:04:59 +0000
Date: Fri, 23 Feb 2024 12:04:55 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: John Groves <John@groves.net>, Dave Hansen <dave.hansen@intel.com>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, "Matthew Wilcox" <willy@infradead.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <john@jagalactic.com>, Dave Chinner
	<david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	<dave.hansen@linux.intel.com>, <gregory.price@memverge.com>
Subject: Re: [RFC PATCH 16/20] famfs: Add fault counters
Message-ID: <65d8fa6736a18_2509b29410@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1708709155.git.john@groves.net>
 <43245b463f00506016b8c39c0252faf62bd73e35.1708709155.git.john@groves.net>
 <05a12c0b-e3e3-4549-b02e-442e4b48a86d@intel.com>
 <l66vdkefx4ut73jis52wvn4j6hzj5omvrtpsoda6gbl27d4uwg@yolm6jx4yitn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <l66vdkefx4ut73jis52wvn4j6hzj5omvrtpsoda6gbl27d4uwg@yolm6jx4yitn>
X-ClientProxiedBy: MW4PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:303:86::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BN0PR11MB5693:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e1bf2d-8154-4e62-3804-08dc34aab67e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JWTEYgCqM5o9fBste/9UlNQgyAQSnlu3Z3ZjJvPjpttA4DN3ZyCC5IoWajH/mhWjxgpCi1nip0U2eRwsHf0BDTXocp0RAdZDwTaAQfrspzjZoaZY8+x5nDlaCfghDU3EMLH++SrN7wol9vJ8wM6a9YeSJUuN/p1jh+PF5EUQ9EoMrznSQYsnQ27sFXWAHA9SZg7OdHg2mIegsiAu3jKQ3i02eP7s1IawcYGVy1AloIO4RpFFgwYWNoYqRnxEPMygYv717z2T0vTuuSl5nKpWUKhSXCOGAmS61iur558/eeFRKlYBHPBTK2L7F/G3j4N4LpwHUL7MYbCfeJprqUaCQQDontoSKH/BUHm4jFjRdnM5eW3SKIMGeDjeGBHfEuSb6w84+ixbrV5sYIu7alJ4/LHDEDS9u/iexsAwDlFBV9ijFPfv/2l7JaEA8mBLpZdMelaWfsWTUx5YTGU2aKpT5Xe455HU/X/djhqHt7IHu/IQfgXrZjF0xDbZggGYpfHOs7ru5LSknLbJQXEFvuz+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jXrq9gLNUO8LPHFSjKmoUxQFVyyGAC5YFOb3tht7XS/JxNKpiYzpUfM4pRYw?=
 =?us-ascii?Q?i2zMbk8sR+yv4deCZBHhUqhsbJl7MNHFapUw35PJWtHDUfbDoX3+m5cRQ7bo?=
 =?us-ascii?Q?s7l3xu13gDFwDyvk9ZmnUrTea7uG+l59rtny2yv1eN2zNJX6e4TIzmvdMVtd?=
 =?us-ascii?Q?cNm3PIcWBsw0Sk/1FAm/m19GAXkOSv3VjhBm57YgcRtKIC2GUfVi1mNcxBry?=
 =?us-ascii?Q?wPhz4VOjTk8a1+8LX0Udw6R25ZZjfkWVS0ItGYLzB0cXhqIv3z+AHIoMGzGg?=
 =?us-ascii?Q?Rr2HIcIAynE1TX/PL8H6kr6+rWlEWm5/gITacSusWSi5TYdlwkY4Sn8N4WK8?=
 =?us-ascii?Q?IIVT95evdPF0bwtCVHSKmq3nRUP70IGhS02a5gnUDuxBG7I4rLdrC8F48hdp?=
 =?us-ascii?Q?5tyem+hZERGbKxGrODC/JhmFAVRPOt620VAu+WnkeiRFb/1/e2tKGECYhh9A?=
 =?us-ascii?Q?XGl75y1TCkn4V8OqKXqRkBmMNprx5dRxz+VLX2woG5RUl7mNDmfyducwk9xJ?=
 =?us-ascii?Q?8+im1MhK6FDqCBwpHv5vrDcOsSddgaOKQ0BDTET8qe269Ns7y2F98QQDTUWj?=
 =?us-ascii?Q?AYVcqdUitlJjd6Xa5dTVoCqFnU1VPiKiculyTKH9CVkMicvDWVQJL70oKPA+?=
 =?us-ascii?Q?37a2hpkO/zVoZQItgKw+7iFcazmtGw2Y3ruDnXA05UZKX+ybi5bR2CH/GGq/?=
 =?us-ascii?Q?tPpjAxlthOKTTzOuBj90tfjFD0roto8ITooM13I0UFEwwRT2cxIKM145CgR/?=
 =?us-ascii?Q?amtSlgeS6rCqLtHegxCsd7j0UxAY3U92qJPacdcCAk5D+Q9vsUjgY6ms4PyQ?=
 =?us-ascii?Q?gnvCLPdHC6tr/c+MHdlFRkLauhDS5HjjmILUbdt6XS5q9PZYDPsuWOECxHBx?=
 =?us-ascii?Q?EGi6Xk2ELV0qCx2MQpu+9acihvOvlvZIDgc0+pvWmd7X+vpIaLWStEVj5PzD?=
 =?us-ascii?Q?whnFmF2lAAbInxW9dy1Tg8rNZ592ooNNxBP/mSxu2xUwYX5la7jUGUIdu7wf?=
 =?us-ascii?Q?QgOip4K2dm4fWQOWVk+kkyEjDlurWnFugEwR1PObm4ii6XdoLQ6/oQSydZUA?=
 =?us-ascii?Q?jkTKOq+KY6Zyea5ylQfe/rXbW46vFyTbcVauaRLaTafxWMTNzxSxPXz7Q0gC?=
 =?us-ascii?Q?0AvgMyAMP+Mt+N8bT2SwVbtF65WLhRHfYGFPKK8+d3SvsyCiXEg0/2gQ2qYj?=
 =?us-ascii?Q?QYTdVAvh0jV6n7/ICQfS6Jx34GB4b0jIBGrK6sBAQfcN+nI7MNA/qTixPF2W?=
 =?us-ascii?Q?deB4SEtNUHLc+Np2ZYXvZp1j4m9TnFuzd5A/1QDehqckpt69yJ86ukvDP1AO?=
 =?us-ascii?Q?2qkvp/6pkKzafnnxhsOXBvwbnj6hPVDIDxwlGKBEp96lPs720Ihsrv72kg/M?=
 =?us-ascii?Q?fhvr/uryw5NVyjYeHKXydbzfSWrb7j2WRLILWI0xNJ/A2rOGSEauCXpgFBjE?=
 =?us-ascii?Q?qUiyOuVtswPQU0wV54uF8V3g6oF1BvmLSndGNMIluNv91/YBltIVTvZFBAgD?=
 =?us-ascii?Q?ngKrVuhh3G/dzkYnZe0OJOUqkpLh/1wVRg4pyBLkEOONzUar3NSU5Mv6zpDn?=
 =?us-ascii?Q?kPj4tpWQCjrc3Bl2Ftv1JXXErZoJW70aznzypYAw30ZlfFb9TXx1DK5dOwCZ?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e1bf2d-8154-4e62-3804-08dc34aab67e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 20:04:59.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvCypRCm3PWiSj1zRFQ7p1cJaszMHWkK3n4mlYFHjB2FwyZgEG0x4qa9yiEnQL2nmw2QbMEM5GdqsiUEHkTf4K2SLHtNHveFIkzgFAp0mYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5693
X-OriginatorOrg: intel.com

John Groves wrote:
> On 24/02/23 10:23AM, Dave Hansen wrote:
> > On 2/23/24 09:42, John Groves wrote:
> > > One of the key requirements for famfs is that it service vma faults
> > > efficiently. Our metadata helps - the search order is n for n extents,
> > > and n is usually 1. But we can still observe gnarly lock contention
> > > in mm if PTE faults are happening. This commit introduces fault counters
> > > that can be enabled and read via /sys/fs/famfs/...
> > > 
> > > These counters have proved useful in troubleshooting situations where
> > > PTE faults were happening instead of PMD. No performance impact when
> > > disabled.
> > 
> > This seems kinda wonky.  Why does _this_ specific filesystem need its
> > own fault counters.  Seems like something we'd want to do much more
> > generically, if it is needed at all.
> > 
> > Was the issue here just that vm_ops->fault() was getting called instead
> > of ->huge_fault()?  Or something more subtle?
> 
> Thanks for your reply Dave!
> 
> First, I'm willing to pull the fault counters out if the brain trust doesn't
> like them.
> 
> I put them in because we were running benchmarks of computational data
> analytics and and noted that jobs took 3x as long on famfs as raw dax -
> which indicated I was doing something wrong, because it should be equivalent
> or very close.
> 
> The the solution was to call thp_get_unmapped_area() in
> famfs_file_operations, and performance doesn't vary significantly from raw
> dax now. Prior to that I wasn't making sure the mmap address was PMD aligned.
> 
> After that I wanted a way to be double-secret-certain that it was servicing
> PMD faults as intended. Which it basically always is, so far. (The smoke
> tests in user space check this.)

We had similar unit test regression concerns with fsdax where some
upstream change silently broke PMD faults. The solution there was trace
points in the fault handlers and a basic test that knows apriori that it
*should* be triggering a certain number of huge faults:

https://github.com/pmem/ndctl/blob/main/test/dax.sh#L31

