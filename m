Return-Path: <nvdimm+bounces-10104-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE4AA72909
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Mar 2025 04:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52B551887489
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Mar 2025 03:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439CA1A8F7F;
	Thu, 27 Mar 2025 03:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KL8f+6gA"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CFCA32
	for <nvdimm@lists.linux.dev>; Thu, 27 Mar 2025 03:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045571; cv=fail; b=cIwyVu7zvC3UFTGiy5+UQ0RDLe/gIO86a5nP7K8+EdgJWK8qrYLwqASYEclCvRPxUb/mzvHXImz8egGeVjXWqyNcPTqWNnHqILtpVx3Wry7TEqWEotDPk8cqXclvo6iJmxPLQ6CrA19o8yiJn+ueCLSrqe746xslxGFKSZsYZRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045571; c=relaxed/simple;
	bh=dZ4zj1az35vJkBDZ65gVy6aoaKjLN8CdEKgQTE12MsI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CZ+asRh7y8J+8T5Gyobc0EOVxGw/nC4OQYWJ6B5B0o9a4Vb/zAP1O0cA7Zpmyqa47VFftsrKBDvoONz6ul059Ohcuhvrn9QwEO1me6LzvM93W8ngCyA0i2kEXfjREGqm+4TN3Z2u8xt/FC6xO+CIZSlklsIl/Qq4T13khXE4Hzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KL8f+6gA; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743045569; x=1774581569;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dZ4zj1az35vJkBDZ65gVy6aoaKjLN8CdEKgQTE12MsI=;
  b=KL8f+6gA3zeJB2E4C2XzBmuTZfA26hmrEPrnMEmiPIjhYU/B5awrhmle
   xBgTlFiRjSTgEy9hvDSKzBv1Yp9ve54TyfOfzC5bsad1IY7VtpvJ4NY7Y
   DRg4pTmBhmbg41pFXodoF6nzFzv6zfdLrXNL+aJ0LwUODO1m7Gehs9y0w
   Kqj0fQAlfFCYTRbnzOWcKDVFj1VY1RcrIGeSl1vfvK5jDX92jqcoqjd8E
   Kl6ZN1M9F6u6gQYxhB9HpqJvMPXo9pAP73wfP5r7NXh9k0J2D8VRWjRYG
   jWN1A0Q0ZELcj9L1KXuA/Sw/Ss4ShZBnBQqyAZEuZewjIP5hucrAErLWG
   g==;
X-CSE-ConnectionGUID: VprVkG98Sdy9dh800fAuxw==
X-CSE-MsgGUID: S2wzLxjpR5S8Ac+5+PPcog==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61886677"
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="61886677"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 20:19:28 -0700
X-CSE-ConnectionGUID: 7iv7S9TOQ/OfqpsxFfd6Ow==
X-CSE-MsgGUID: li7amm5wQa6LdUIxS75GIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="148192186"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 20:19:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Mar 2025 20:19:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 26 Mar 2025 20:19:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 26 Mar 2025 20:19:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJX2v9WECDv2l27HfmYnBULU+4MvrWnzPlIpjb9p3lIkGukfGnLSbJDDeEJzl1nD4vTHry1kcB/7YNioW6MdP1fZeAygher/J+jNuMYUvZNI3Rc1NW62joAvHYwqQ7U+kw45y+lRLewxXBtRchSBKBY/KmglcE2EjMRvKm+makPIx+qRoOVIOMBF87qYCu5DtIj5+OHA/am9wZGpJk7HppGJbMScER/z0rx4y5idYzKqWvaGJwK7VNnsEFZYTJGpsg61FjEm360OuFKo9IrrO5Vn/ykh+OO+NBX4w4tH1MKKp2K+X7t2cHGRT2BzyuD0CTa2WecywiRUZeBH+EvQUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDFDuI2E4idDnoNmZLkkmn7Ij+dDLdz3nyKbmNGs88I=;
 b=FrC+Nmlo79gicAPHq0iB9HeHvOfq+pmIrsCdEAxPdipZFdW4ID6bOXNADMBC1aKvx7UtGy1FwR01t76XpuV1RwrT/YFSrvrLGaW2Wp3dK22FCIGv9eKr9DUmePr0rCFUHXm28eyjz4m/vAFLMenKm9TK5fJ/Ky80Wi1fbZPDXRZneYiDBt/PMRwJogKVxAdCJZA7w51D64nV+IWosqGl0zT1MCJtRLmkWrG9rt2pFNKtsS2N1M7dI3S2MvtalXxEfg1ZJBf1TFGRWIrNh4a3KNff/CntZd7w9POTOhkhb/zRCtEKOWPEj1/eTAMyquu2O+vkTPfFXC+1hZhNbFyMfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by MW4PR11MB6619.namprd11.prod.outlook.com (2603:10b6:303:1eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 03:19:25 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 03:19:25 +0000
Date: Wed, 26 Mar 2025 22:19:44 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
	"Len Brown" <lenb@kernel.org>
CC: <nvdimm@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, "Gustavo A. R. Silva"
	<gustavoars@kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v2][next] acpi: nfit: intel: Avoid multiple
 -Wflex-array-member-not-at-end warnings
Message-ID: <67e4c3d073eb8_138d32947a@iweiny-mobl.notmuch>
References: <Z-QpUcxFCRByYcTA@kspp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-QpUcxFCRByYcTA@kspp>
X-ClientProxiedBy: MW2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:907:1::28) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|MW4PR11MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c843310-1578-43ac-b30f-08dd6cde2d0b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?I5NbnG6CRot8O9vVPD++luCg535h26en6mkTHA6Ty0FXD26Wd/L/1jxJvkjj?=
 =?us-ascii?Q?eXNPDxZxe+CWqxdlJdJEe70qtpY8DX0kSB/1PzzUCqoq1H+af0dB4dnmuEqx?=
 =?us-ascii?Q?uVZt1K1FtQIzNubwN2kcnVNffpCaHzioXwUhgVoZJ+SfdlqPP0z0prLSlFbq?=
 =?us-ascii?Q?3lnkIp6S0S/QlnKnqtgHzJSQ1BtffTK4PzWTMUw3qsROHOWIeErhfuIp0lcA?=
 =?us-ascii?Q?FYnSo6fsa3SKfhQq2M1og7dPUNXl6D4Dx/+CAsy7O7QAiYwMJ9vKwEOYc2dZ?=
 =?us-ascii?Q?UiLy/svmecu4n2VcmC44gDbGnJJ9cubc8akR/CTNPDLvyaH2fzSvv3KTW1uY?=
 =?us-ascii?Q?Vg3JrSJs+SQMrjj5CFbPhNpvbCyt+SKdI0ErCHEnS825go+IPkK7Fpvp2NmE?=
 =?us-ascii?Q?DmBZBlNhHvnZL1FEunC83l4luNrxocmgvoG5sZsgZ8SCCd6OSTJXa3rOMT0e?=
 =?us-ascii?Q?Gk3AvviD9dQwlghLYp2xBp6rhZgYORu2uMWw8T9Ln/agPEkDmIDozN4cCfj6?=
 =?us-ascii?Q?sBsScGkvhkPM15C4qpekzxICYTS9wU6G+hDd1yIkFweXaDbP0d29lQZs/RVh?=
 =?us-ascii?Q?22Uuc2ur3JywZqkbUgurH2Mqn1QQQVvKdLBcD2V60lOqN/UbV9XiS8iNkldj?=
 =?us-ascii?Q?jsCCREww0m9US/7SUnv/lYDe9NQEa7bBzGGupDysc3aybt5QZrOFvypVXBNe?=
 =?us-ascii?Q?vMfZLow7Ucw04v4YCPvvqvOikki5Z4oN4onl0Nv6lcr0qCql73yd24WEwIdF?=
 =?us-ascii?Q?G4Y+zNwz7Lf2WMB6FoBDQUW8Vk8qAqF8xdRs5cKUhfBp/k5fun6pzLKPSGBB?=
 =?us-ascii?Q?asVIh/5x5KWxyK55R+5HvR+nTFPMk6zTQy9nRzJiqp7bfxNnruUcKiSDryAz?=
 =?us-ascii?Q?nBiroeawZb+JJ91/791RjW54ODGpPDkwWSfAOWPTN5j1nex6ACyUTSl/uFyK?=
 =?us-ascii?Q?TY3NMFoJBrhCLwdtG5JavU9/ax739X3jDwclHvimz7L6A5s9eAEXIAwkFwf1?=
 =?us-ascii?Q?f5EEFF19yqh1tcWn2lNoSXj7AKf1IyoHpVQ6RNHnFipbV2BkZGvRr/g0cI2g?=
 =?us-ascii?Q?Fz1q5q7xESW1iIJeH3RVonvAL1/QvvUiZcoAMfH/jDOw2Cp4xqQ/5XlzVYuR?=
 =?us-ascii?Q?2nmxzZaMhdHPcuXI6WqjIS5LcCtCpXy4SRiWrR706F2z3ukCZktNTWXkAbNB?=
 =?us-ascii?Q?AVqJNL1b9Q1tYiO0B2xnYvNVRp8H69aNEtSWVbnjzLeVuLVSJ9ZE0FwhKToZ?=
 =?us-ascii?Q?9L95MwQqgjwZQ1Js78L3j45utgN1LXZWM8cqzZa/P26S/ycs0Jv3Ca/ys+ez?=
 =?us-ascii?Q?Yd947cHoaK0RtsfMtf2UQD0/EGwm8q/bmWgJds3yhEYkRahPLdsXKTf9v8LO?=
 =?us-ascii?Q?OdohRcJMVxMCQTyr+YD1wpnSlRU4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6AxnS6N1/gFLiuzJsHtKb4HVVOU7ye4i7OXDGzycPiERwD89ENABevTJROVc?=
 =?us-ascii?Q?t1O/MfpJ0UztVurUC4UucpPrLBeOI6vTmORr+IQ9pL/sHsu+dlGaL7e8Wdx2?=
 =?us-ascii?Q?jKeiCvo9oZz897M3+szLb/5e7xHVkz/NBNEdVby55SnnPow8hbTrsDWWzpQv?=
 =?us-ascii?Q?kpPCTUkkFRElPZsUkjivQir2Mk2SyY2PIKMrZPHXVs6u7fmcx2ngWmi3gMF+?=
 =?us-ascii?Q?FBBPi24zc9yeFRK2rq7HdLJ8X5sG/S3HV4vo9Sih+4qJ7a1n+XxOdlckSiMf?=
 =?us-ascii?Q?s14jaUzN5AtZeTbRoJA+1B+CLeMDA74HzmmXO/9cbZuRm9pvDGYgCySiFjSR?=
 =?us-ascii?Q?+UsAiwqa4jKUQT7jcfWF5dfLkK7Mg2yrWaUyll0iC3jzWmNKmkEb2UJ5p0Vp?=
 =?us-ascii?Q?pt4T/Ct99w7DQ+nlstJi+LnIgen9PgkuRXk5IP0bez12+IFyGc9pitM4rwx/?=
 =?us-ascii?Q?fidwmcPzTbLIIOqJ0FtSKG0xruyeuizweQ6xHQCDSm+6uB7C1wjjnaS48r0k?=
 =?us-ascii?Q?ScftN0PvbFc2JVci8Pbo+gh+G4xUs+xM9fzjMdiD/zx3npZjwo+Pne3fQrW0?=
 =?us-ascii?Q?szwu1iXTOlY7TOg0jlxaLTDmVjzCbByXuG+ZRrjjflQSdkkuQsu8qQngUZ5h?=
 =?us-ascii?Q?0oee2G4csfLSGR3/F05sbBrSN4leZc80hOcdIImt2C8gbHKf68Ak89SBi681?=
 =?us-ascii?Q?uzaw/XG8b1MCypzw+A4uR0SKuAJgmuLX1Dg/rPjEgp9xM0re7BaBoq0bVB5G?=
 =?us-ascii?Q?wuB0mdZDbKEbla9Q8hjgJxPG8vF83UvhPp4HMGrBFAZaSIGyAGVk/kgmF6Aw?=
 =?us-ascii?Q?VW6o3lP0D13/wo/s4llFnbqGz5aC/NIo+PgmzhxQkF3C4StozsBC6V92d6Ym?=
 =?us-ascii?Q?Aqu83Xtj7pHwxQE6I/XYLlX0ZYfGc625d6AiHkCXA/j7ao+wN02GX+BleZbU?=
 =?us-ascii?Q?jgNsuidiONQBVXuQ5CYT/vYXyVDXgg/15SwSPvLzBAusIKrps5t/oe4mhtdO?=
 =?us-ascii?Q?JXopPDn0TMLfZZPraRY5+sCadm9T0fAacBCmuwFWeVj0GKI4S7S5p79e+SOJ?=
 =?us-ascii?Q?wcRmlyhCrvZ9c09BqyGhEnugSOh2HSozMMEqRfBLo53SIZQutrT2NfE7ArTv?=
 =?us-ascii?Q?ox3ZP6iOtfhRSjy8eykgvoQCZqrPLVQLvWlKORIEysFLJSfAy+Xi2f3UBbtI?=
 =?us-ascii?Q?r+NDsm43EOOVQENrTpoaffhKQEnvsixR6RbWej2vAerZhhjhnivGsH2GlhMi?=
 =?us-ascii?Q?Eqx6lgOuTTgOH76KRI+X229vWPyOiG+rpxiUSqMIJeO/qogOukc4JKjxtjc1?=
 =?us-ascii?Q?fgjPSCJBzbMcyGIPN1Df0Sr4mso6HSyhzXSo+zEzwax4/6t+hu9ArIIBvN3O?=
 =?us-ascii?Q?VQSD3oI0eYi0eBWb0KpgWHrdSopgrm8DgDKnxUD9RFyWQr65V8MWK/L5kWn5?=
 =?us-ascii?Q?ByYn18ETR4aWZcUujYRUPA62Wx+QSmz2pPDr+XwI0WeRZigVkR9F9XcAjUT3?=
 =?us-ascii?Q?fCEHdB2REG6MWZmgpndFCxl3suKqckJiPeIBmVCPqrYfflAxnORE98lNgNt0?=
 =?us-ascii?Q?VKV64xENYsJV5PY9r9r48iR0RdMCEDifnqddWLll?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c843310-1578-43ac-b30f-08dd6cde2d0b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 03:19:25.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gso6ZWp9T3nWls9UygajyxDSGc43vtyEpP/RfqnSeipkmsSP/bouvPvlc6pH8MoRXLU0XwEQDBi7FFCzomjdsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6619
X-OriginatorOrg: intel.com

Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the `DEFINE_RAW_FLEX()` helper for on-stack definitions of
> a flexible structure where the size of the flexible-array member
> is known at compile-time, and refactor the rest of the code,
> accordingly.
> 
> So, with these changes, fix a dozen of the following warnings:
> 
> drivers/acpi/nfit/intel.c:692:35: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

