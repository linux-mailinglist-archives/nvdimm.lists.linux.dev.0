Return-Path: <nvdimm+bounces-8262-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3EA903944
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 12:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF8DC1C214C9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 11 Jun 2024 10:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0066E179954;
	Tue, 11 Jun 2024 10:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y4gAfx6F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="znrZMK8y"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA447178CD9;
	Tue, 11 Jun 2024 10:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718103044; cv=fail; b=BGtxbFW2rgMfABana6tEXTRaKn0qNbL0DUuJHZion2xwe97anBvNFHlcUNt5gLxo2ow/nwLlyc3+8FVXbUcrxC71cH/jGgLwGudEySuxv+SuFob1/g+pMoLufzj9RaiQGiLB4MN8Ywqlh0FtrLeyqzN6kRBYOxmGh3gSSlZQ5x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718103044; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jTUy3O1FqrYQjzwormAmn6iD2dGFkqTe0TFosJvXMoeTPzBO3SiR4RzR0qLNE3l06V4RuUCnvVJ8OQgI5OIDOcLP/6bYCLAa3IKYG/059vbCyM1QveY3nvywxdeXZ8l0UJ1d7opqEsDutXgy52RKNEgh3RcGjJg7VNid8bUAtQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Y4gAfx6F; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=znrZMK8y; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718103042; x=1749639042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Y4gAfx6FnT0f2DGT+rv5pVNCGvGtYJ3yopeW52V69LlBpLFs6BOIklyj
   TatnxlwRpr6PnqJH2reboyH2kt3Sl5Z8sNbnp/M7Krj0SPnxhsoIHp2K/
   nUbdk0MttXVMBROltj3q/Rm91l5dLc9cZfzsrUL74SZ8c+w1eQTBVeR3G
   Kj671z74S0nQtVjXB4jpOKsNtMIs4+Y8CPzg3ISECO+XeOQBzBf65CnbW
   jiNgqEk1XSi92C8d3LTXFKR1UPPmauwsS7s7Xx7Ia9Gepx1XVIj3rLz8P
   ZCixlCaxQgSwp4wIXQb8nZp2Sl910pHxO91nK/zht2Gr4FTneAAa2ZZzf
   Q==;
X-CSE-ConnectionGUID: XG+0u+qGSs+VPGBVXSu+Jw==
X-CSE-MsgGUID: lJhORMbQS2qna7/3Ae/3wg==
X-IronPort-AV: E=Sophos;i="6.08,229,1712592000"; 
   d="scan'208";a="18778899"
Received: from mail-mw2nam04lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jun 2024 18:50:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUihhz3g+A+tDgcMN9MzwA6oRuJjRvXkvgrDXfFqbucwUirvj3o4xSkgyx7/Rj/q5KYqVvGfl+MuZyw2WSfB/FOlnoegfk8LNyWjQa0iZSTvdNBXsGky/cwBMSpA+qfrxLna97BWmriowlXIEfNQ0/S7e2hLBkhU8jiv6z3k0VpXCdktJn7AhDsBy2MS2YH5/hVluHaYvVUpDWjxk/ih8E9C/GKZCH9W2Gj7nzjHPbzF727uTHGxnSA851e6g2DIzjC+9zAY+aLLUCxD0Yqjpdxyxj8n5bnOZD7PXR5jYsjxV/tHXJ1L4Hmv8Xaj+92bcDp035JOhMRi+1TlbbdsdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=XwRa0j5isF/hrxxLzPEzdp44syZkcaRZZMJD677zGfHK+5qyWbaDeTF+ifg9M9J3/Df4M5k2kEzTmC2pG1PdEA2bflM+rzgnT/mgMuC+LJDhyIK/fbkr4yHXgRJQU7AG2IGPeB5buQigXmDKZkfxWyJAaeZ8GNOxD9/NVTKcPFn5EzjIlwZt7tHMri05vwryBTc+/g4Uo/kQan9yzTEPVspq6pSVYWXFjlPxP07d2FB9o1CTKTjAAGA8sezAg29zEEGNYiTKnZ9ZC4hb37FBdxsCfHRIO2bVXJs5MRRI/LVlRQv7H7puYmwyFY7xw0oeGDPM5VH7u/7oqmhBiBCWdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=znrZMK8y8asm9X0HR3CeoUK6jORYAI3cBWQ0FKAOqYtYtrF8+kyZzZ4MHhibIxobwDEu9di1W5sV4XQlZ7emhPRpmehE4lH42iaM9svQFJA4v90WR8PJlsv1J9SsFhleFjFiyG18lzu8XLQlAIT072gkkOa4HR1uwX5WptUX7qg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB7105.namprd04.prod.outlook.com (2603:10b6:a03:222::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Tue, 11 Jun
 2024 10:50:30 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 10:50:30 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Richard Weinberger
	<richard@nod.at>, Philipp Reisner <philipp.reisner@linbit.com>, Lars
 Ellenberg <lars.ellenberg@linbit.com>,
	=?utf-8?B?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>, "Michael
 S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	=?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>, Alasdair Kergon
	<agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, "linux-m68k@lists.linux-m68k.org"
	<linux-m68k@lists.linux-m68k.org>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "drbd-dev@lists.linbit.com"
	<drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 01/26] sd: fix sd_is_zoned
Thread-Topic: [PATCH 01/26] sd: fix sd_is_zoned
Thread-Index: AQHau78EzIfqHhndw06EBBro2gSZqbHCYtuA
Date: Tue, 11 Jun 2024 10:50:30 +0000
Message-ID: <b9b02f22-6835-4a9c-a1b7-790fa6c0afb5@wdc.com>
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-2-hch@lst.de>
In-Reply-To: <20240611051929.513387-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB7105:EE_
x-ms-office365-filtering-correlation-id: e237afd1-1a8b-4420-23ed-08dc8a044fef
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?VUlMbFE1dU1sbTQycXpML2VXUTJBWDk5YTdZNDdrVGVuckQ2YTk1ZTZCQXcw?=
 =?utf-8?B?Y3daN2hMOWtGbEpkK0NJTVdFMDlGQS9oTUtRbjFCRVJqb3JSdjd2Vk5YQ0Zk?=
 =?utf-8?B?ZGN2Y3ZUZTVzTEFhVUF6SDFjY1lDU2MveWRpQ3pyTG41bE8xcFFtSGgzc2JW?=
 =?utf-8?B?WTN2MVE4cHhjOTZtakM5RTRmSDdvRlN5Qk5zTWVPeXFBQlpOUVl5YnJRcFZp?=
 =?utf-8?B?TTE0Q2VpZkd5djFiSktGR0RFNzNmSHZxdmNaV2UvVEY2QWU4dFNsdzNxUmNt?=
 =?utf-8?B?M0FIOHhIRmVheGtNZlNSNEgyNzVNOTI0VHJNSDEwcWpaenYyelZ5QThNQWhx?=
 =?utf-8?B?akJjcy9zeXBZa3hXa2NvN24rOHhSVkkxVUJ3Y3F4amlrVG5EQzlDUW9TY0Nt?=
 =?utf-8?B?aWJFMEhBRGo0NDFIZmFHWUJPdENTSzN4QXVudXRvTlFnbFU4UkRlRW04ZkRE?=
 =?utf-8?B?ZkFISTY4SmVtaFhhZTVGWkUwWHFURUJZOVZsWnord2xaS3h3Y0w1M2tERUN5?=
 =?utf-8?B?elpwekp6cU8rbTgxYXVXNHV2eG5XOTFZVGZqYnJXbjF0cGNLcWwvdXg2dkxX?=
 =?utf-8?B?aXQ4YXFxczMyOHFkM3lKWXlxZ3lsRHAwakJlVi8zcnRST1NQZlBSeStRNVpk?=
 =?utf-8?B?UDc1RGsraW0vMktoS2V2S25qRVNOdmhFWHJyLzk0aWFwbFVkYUkwdUt6TUk5?=
 =?utf-8?B?ZnFXdHY1Uk5scVVhMkx0VTQzZUpXUWlpTUhmOE9yQ0FtenZuU01zWjRlMi9a?=
 =?utf-8?B?WTl5YzdGczhMR0lhUEtuSUtEZFVrRis0K0cwMkdyVkx2ZzNvNGZ3Z0VKNUY2?=
 =?utf-8?B?aVRCcjEraG5XV04vZzRxU1FORnBVUE9MTlpleEI5dHJwUFpOZkw4L3dQbjQy?=
 =?utf-8?B?VzBQNS9rL2NzUjR0NTJ6cWJBSWhCY3JSNUxVZTRyUWpReTJxd25nL000Sm5J?=
 =?utf-8?B?OGFCNG52ckVJSnR5dklvbU9BQkEvSEtidVJhSUpQcHVlaE54cktLR0tuNkh5?=
 =?utf-8?B?ck1VNHprSEdmdWRGQndkMFhHb3BacUJvVWhaZCtMOFN6NkhmNWhWT3JNWEd6?=
 =?utf-8?B?ckJzUWJ0eFArODVza1Bnd1RwbUpJbWRXV3cyWkFRUTg2NldxVFFidDZhcDVC?=
 =?utf-8?B?a2xrdHkySjEyRVgySCtBMEZEdy9kQ0QrUS9ialIvYTI5a2N1a2lKQjkwbml3?=
 =?utf-8?B?R2I2REd3ODg2Vkxwa1U4ZnQ4czJRNUdSZTJ5aUxwdG0xd3NOcnR0WHdMTjFv?=
 =?utf-8?B?UzM1MlJGaVZnWEhMOEd3T0VWTEwrS0U2SWRPT2NtdGwySXBYbkhBTWN2ajYw?=
 =?utf-8?B?dGVONytuT1BxZ1dMbTRqMVQ5QlU0ZUYra2lhQjJMTnRXZU9TNjlDSUU5NEdu?=
 =?utf-8?B?WkFEVm5xYzlNWkJlaVJ0dWFrRGYxOHY0UjRVeFhZK05mTnY2MklNUDdxZkJs?=
 =?utf-8?B?R2ppVHd1emlIOGRJZG9ScVFHT0NtL2ZPUjh6ampyVzM5M0hTL3Q2ZlBJQ3Ji?=
 =?utf-8?B?SlM2WmJSRGlZTXlHR05ZOVlWRVZDMmtNRXk2K3BnNWJPTS9kMG4yZVpac3hp?=
 =?utf-8?B?NVQ5ckpkcnFIdUlXZW52TjRkYXZjQ2dNTlM1MmJ5Z3NsZGVUeVo3Tk5hMWFo?=
 =?utf-8?B?TURUYXNmTVlsZjJPZC90eUNqcGFONUpYSnZrcDJEc1RPWEp6UXl6Y1RTUDlJ?=
 =?utf-8?B?cDhvSHNRM3B2VjF6OXJkVkF6SytkZS80aDl3d1RwYS9NTUwrelRTNGh5dDNF?=
 =?utf-8?B?YVFneTlheXdmbVgwUHZnd1FKRk0wVmFjd2NHZ0k0V3E4NVk3ZmZTQ09NU0lY?=
 =?utf-8?Q?yz/Jix8RL8kb6p4H32wmC4RaO75IJtq1sGJFk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SytxU2YyN0lwYW1lMW5BdHkrVkJnWGhseUQ0YW5rcEFJODVycHpkMXIwck5o?=
 =?utf-8?B?YnA4UjV4dnIvZjlJZ0h2Y0FKSElMYkIrUGc0ZlpzTy9YTEdiUVJzL0E4Sm4x?=
 =?utf-8?B?WkNBeEdVcG9OZGhRZ00wUEhwdm9nZWh6V1lZSHV0UGliejBoT3RRK3cxcVRv?=
 =?utf-8?B?cERsZkI5VkxFdVpObEowdytneTVrWnlkNTJuaGwzVFlSYlZJZUtxeW54N2dH?=
 =?utf-8?B?Mjd1T0dYeHMvWWoySDBHNllxUm9SclI1V3JxNjhjanhsQ3FzdTRMNE8wcnhL?=
 =?utf-8?B?WHJUeEdESW5YRnU3V25TZWYwa0plNnNxQmpBbjdITTYwdmljZzdEWmJDZ1pv?=
 =?utf-8?B?TnZIZ1dabEtSaHJaVUtnOTBzNHBNOC9STnZrU2EvNjczQXF2WmovdXJVbUpC?=
 =?utf-8?B?cElGTDZxMWVBeEF2aUI5MHV2MnMyUE42cnBLQkRhY1BVa044ck9xejh4RXE5?=
 =?utf-8?B?T21iK1M0N01YYTZlc1hFNFhuYlZOMkIwMmsrQkQrZzBlRGVINmJuUnRZSU1w?=
 =?utf-8?B?UXc5UGs2ZnJ1WXhDbHpnREd5SjRETGNmT3NsUGgwNDdUVVl6MEt5ejA2THBT?=
 =?utf-8?B?cHhpZkpIOE1MUFhJMFJUSjBNZEVDM0MybGd0ZXVFeGVtLzhJcFRiQnFYOFRu?=
 =?utf-8?B?YkgwUEdpWFczLzZ3YlZEcG1rdUhKK0N1ZHg5czNaa1BtKzVmZHdFcHpPYWFI?=
 =?utf-8?B?U3hEaWRjK3dqMksvcEtHYUhqVTg3Sko3cjhtTjlBNmRTS2ZaYkoyMlVUbGpQ?=
 =?utf-8?B?SE5oSmVxVlBrMW1PVU13aTh2ZDBZYkluVnp2Nlo1M0U3aTU4N1VJbE5SeUZ6?=
 =?utf-8?B?VTV5V1BkRjZSSmVlVmU3ak43Q0FRQm9NT2RyRUZiMmNDRmhTNzZubjlzQ2ls?=
 =?utf-8?B?UG81bFUyT2M3YkR2QXI3WWlmdlBvdDRiM080clY0NXg3bldOZEUrbldibU9N?=
 =?utf-8?B?aHRMeVE1T0pMZ05ybE10YncxWE5ETStpb2t5SWdCNmtRYVFOZ2cyak9Lb3l0?=
 =?utf-8?B?MHhKRjh4cDBMbGxFbDAxdTFsUUdObTRXSm1MZXRKRFJuWHV2ekdRREU3TTk5?=
 =?utf-8?B?V1ltaWFDSWRBQ1hIeFcybXMrSW5kenNSbk5mc0tyR2pGMTBEWW1TVTNxQktj?=
 =?utf-8?B?anMrUXlzYVR6OFB3bGYwS2psSTc2NXczVTRoa3RzNFZURDVlbGVmTVMzRlNw?=
 =?utf-8?B?amZ6c2k4S09YNjNrTG1OS3hxNms2NERDU3pGazJPVU05VXN3MnlNWS9FVmFC?=
 =?utf-8?B?d0U1VHNLdmp5bmtmVU1FVE1KUVhJaXlZWTR2ZVQ0bzBvTnMyekU3WisrNitk?=
 =?utf-8?B?aC9EcmlHcWl1Rm95UHN6UGw5ODV6L3VXUG9hbWZKZk1vYWVzclZCdXR0cURl?=
 =?utf-8?B?N3UzaTUvL0lPRFQwOTFKWnNydDREbjIwVi9HcTdhYkhhcmJmOVp0OGxoZUl2?=
 =?utf-8?B?S1hXUnlLbUdJdStVYTdLZXdjaFpiYnBud2tqb0M3VS9HQkFyeGt4aGdOaWIx?=
 =?utf-8?B?RWZMV3JLVVBNWENyZTY2NzN4ajBveTZPcFc0aGVGbVNaNjM5bUVZU1VzQkxw?=
 =?utf-8?B?WDNlb1VkY3VTTktOM1NnVjhhZ2hjWC9aNitVU0g5c1VvS1l0MklMUGlKOVBx?=
 =?utf-8?B?Mzd0T1l3eTR0NFp5V1FrZVBqeGIzcEdNUVZib0ZWOFpFb2d1ZFcrR0QzTGRJ?=
 =?utf-8?B?TkhmcENNWXRqUDVPcVc3dVhNRDhhL2hheUlWVDl2VFpHQ0k0Y3FFS2pFVDQv?=
 =?utf-8?B?LzdRRUhPNkVHbGI4ZjBIUVFyY1dhT2pYQVJ4K0o4WjdCR3dtc04xZ3pFQkxK?=
 =?utf-8?B?NjJkTndla3dsUW5JWDlKNzhHMU1Dd25qTDV4ak5JN2oyZk9FU1dMQWF4UDln?=
 =?utf-8?B?R2xzclVHczJnaDRSd3pvMStuOXREM0dDZlZ2VHVFQlZUTFVKMU9HeEd0M3ll?=
 =?utf-8?B?Wmd0UW15cEZ4UE0rWnEvV0psZFBYUDRzSVpuMXJUdHlMQVRIQ3Q2YkQxck1X?=
 =?utf-8?B?eHBhdmRZK1BTenF6TGdrV1hBN1NSRHlKaUw1TXZEdS9KdjBWRGRsUUlCcjgv?=
 =?utf-8?B?UGRRZ2RIanpLMDR5N1dnOXkzY01JMStZNWpvMFNtUWFDTnE1OU1TamgwS2Vz?=
 =?utf-8?B?VUgweXo0Ym5LV2t2bElnMk5nWGZkZWozd2I1MjVyZTNqS056WllNNDR2L0d2?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <050DDD6DB6C2124FA3F8ED9DC37A34A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LfuiCTpDV1XOT4min+jpdGv1cOG53qf/Q7eW4YiZtziNslRG+ShEQZksWk80HEYuizltKxkMxDdRAi92tlukC6fPY08stsD1AFiR8q5dcPaUjfhCVkxTz1GRNMXeAudEibPoIbaIWkYZsSCzYTdjDfc61lgCtjki4/DajHKJCNAizeTL6t1cNq6wiVZasLSVeEHHMzNwuCS2tuli9A8FSCT/jfgm8fqgwdVPMD5FuYDdPEvTH56REV8q59Sz5PCyjlcpZxqePWF4adEtwUM8z3mLnp3mB8GXhnJfb/vV0T0IORhI0HP0y4RW9cjlEh+iu23fRBh5nUesGFph+Xwv56yYa5bScPxAai2sPSNb7j6be1Ua9GBROYt/Q57kmwD7aIZTq9oY37Cl7phWHKxXwZssZWCUreXwzWb1IEZVpsan78HTrIf3H73Cqn/JdNYi8kdj3Af580J05ZSjdeFYFAsVbWar6s/6xFKA2AzvK4phK0+HoW7DKhXB6OrE3Te9tIY3TMs6J0DwvPDKt23P3kZFzvhhkxo4pmNLrNSVKgv8ZbYAIVKmatK7gtF0BwhKcZWZcaARVTecPT7id+s8udrnl6Jbf8PlKnL6eiji048gEWH6MT3gXWC45w4r+2wx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e237afd1-1a8b-4420-23ed-08dc8a044fef
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2024 10:50:30.5035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VchCIwENkr4e2H1VYqeq5y2OZY6ymUDk/J+o1F4FeS5WEBurkzCTAaST9NPyVE7GAux24AcOpdHQLISKmapiuwi1arY6kL+cBMh9dVTsntY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7105

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K

