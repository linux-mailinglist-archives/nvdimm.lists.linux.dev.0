Return-Path: <nvdimm+bounces-1982-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E939455126
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Nov 2021 00:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 37AC23E0ECC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 17 Nov 2021 23:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591A22C89;
	Wed, 17 Nov 2021 23:29:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA632C80
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 23:29:18 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="297496919"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="297496919"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 15:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="505333596"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 17 Nov 2021 15:29:17 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 15:29:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 15:29:16 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 15:29:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN91K2pOslproqqhjwz4e8CUVgnYMZ8jVvUIklBbaXTKnkwHOG075NbdMu0ey+CnV8stcM/jaOhuviBcGEc8i769imJt+0RdCIveeTftDtIklAOv0gEqO9KvgOL4CmmZdjC8iq3/IT15Tt+d4Gd+MjeyjyAqjd3Dl1+srPrAsifWgsLsD3pYkMXBHGxecxfimThdGCB2JQ8u9NKcETZmwPN1hspLMDiW/STJqRDgknG/qhlWTp11F9AjTHQTNxeCC+Sw4YItoCBOTHw0RJ8+rE3jBpO6g6JefdGqigUhrt2HYrF1XqpDC0ElHKiGbK3mGOwozgZB1riWLA5ehr41Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arUsuFJcrLp03LfRzEZj11DU6g8ZjAM3QthGbudnFvU=;
 b=WrSrUNX7E1Gea35A+KCfMlFhitIuEBixggy2lq1xisLFwZHrY1ZNNxY9eCyDvYsa1bzlty3UH/OXeBiWvB4nd29RyylpzynggHVDVIQqG7yqzHmGgiU4rmjTwHwxEn5hs1JILmJDoIDKxAtX+scDMnyObz2LWrTpa91QY3ZzjVfBZ0ovfKqUuYKVpzjKsaGgbSD3HZC/QYvG0N4ScaF+Gm1wjVIxX6I2+iZmH56Mu2eaiQLZpbzpvmB7K5iDJUSNssGZoaWa1GQyGsfJizMaiDzNzWh+XLUdqbGL0lSoBbIq1Plm9o1BAmyd1tNnfRcuX+PgnVhkoGYOUTs6I/Rlhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arUsuFJcrLp03LfRzEZj11DU6g8ZjAM3QthGbudnFvU=;
 b=DBCskSfzvQ/yJJTZ1FzRlvI2JzluaO6S2PhR4TbxBzwc/48EJW7xnSGKnHkvgcxk3lrYEPf9aaTHtzCIsNrXP+JdC0KUXemwviF9PPbmjzCQBJQdTUkBvjGhou77pD4JYSu3LSXF4qIGe+AZxposAPQXPEI/M+sbXv/D+SEq2Xk=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4015.namprd11.prod.outlook.com (2603:10b6:208:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 23:29:13 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 23:29:13 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Topic: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Index: AQHXnkdcR+7iu7dUgEeHv10lAG+fv6uooiiAgGA3IwA=
Date: Wed, 17 Nov 2021 23:29:13 +0000
Message-ID: <1efbd44270e7494dbe927ac6cf3273e63225ea36.camel@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
	 <20210831090459.2306727-8-vishal.l.verma@intel.com>
	 <CAPcyv4jYeu8y3t9Np495DVMyLt84jQy9EtQjdMDQ4fj91bnZgw@mail.gmail.com>
In-Reply-To: <CAPcyv4jYeu8y3t9Np495DVMyLt84jQy9EtQjdMDQ4fj91bnZgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71f2a896-d349-4553-a4bf-08d9aa2210d1
x-ms-traffictypediagnostic: MN2PR11MB4015:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB4015BCD347CFB97B9AA65848C79A9@MN2PR11MB4015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /N6SVK6c43NX/poWfXNS1zi+TUO4W+PwelA6pU6icqMBf7fI9btyPYSLnMWHdWAHhzFHYZG8/hXgFg9HbFKhmzV7mDV/WQMbXAoN4axiRgD7Ss2s2l4O1ENwugHUk8/Av2/UGKY+mBy8hmXcEuXt/zgD0NlfSLt7+oAUgP3Svz9jzYeJ1PfLlTaFF0HAY5aIK3URqtT1+2JfOFfgncHDxF0IGNWziVZn/l7DO6kuTatzUUyXFKQkqRVWMWzGNhjZZmR7jZRWxcXfS7orOV6unRHbAI4P4GuIj7RRru5FHi93zzovhYxWwcXX7JalKkGMCdPeUutRosIIdyV4CjFEDGrM+siZYyHXiLyRRcm2Bvb3e4OvrDercOHkUH/7Qf9o3+mlogjhHJA3bSfGvjz9VZtKJYL3gPtdkwuRIzUbdQ/mkYRkty+o3CB1D5hc9NOAKZnZgIKnnvin63vdPAnR2BNnGcuZfKCNp1YytOLxy24LPlt1fQhwHzdeATGg0TFdcx33M7mqjbLrUG2tDbs9921ivxUJ8GeiFhH/o6K+9XH2JaM01r9q/d7jW6SRjzOWiaKuq/dS103xU4xx7beRtm4apPNtcPJVRs7+Itc2Zw0+crjhS7TBd0iz0qB6ZPahpRAv7ZCdS76eMoWJPwJWx6VG0eAsatnSWEW3+e8vFdc6afz42hd90r8EBC754L6Wj6EoTML7aDk9Q2BkQJWPJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(122000001)(6506007)(76116006)(53546011)(6486002)(26005)(83380400001)(2906002)(36756003)(5660300002)(91956017)(66476007)(8676002)(508600001)(4326008)(6512007)(86362001)(66946007)(37006003)(2616005)(316002)(66556008)(6862004)(6636002)(8936002)(38070700005)(66446008)(54906003)(82960400001)(64756008)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXZPTjNXQlZOTmhpQXRzYmxEZyttdW1WODZKRksrOFVaYlpwNWVhU0xTSlJr?=
 =?utf-8?B?bEZFdWp6Q2o5OVdMa3ZwQXB5N0VjR3JrRXN1U1VQWlZ5ZHBQeko2SEZaK0Mx?=
 =?utf-8?B?SElyWGRnU2gxRUlPTEJSMENYOWxFUDlEbFR3ZEdSTXlqSVZuZDBXQ2V4c1hv?=
 =?utf-8?B?aFlxMFNiaFRjTmM5SmI4MTRDNDlBY08ramFlRFFOMGtiaVcxRzRVdWF4akJE?=
 =?utf-8?B?dGpTQmhabmlhUE01MXBjYkl4ck4rMVd3dkVyY2luSzhoNXpTeU5BUUhDM3lv?=
 =?utf-8?B?RjBZWHFLWHcrOFlYSFNpMm1RU3RXTnl6Q0VpSnRuSHduVDN1UnBwUGZKZk5s?=
 =?utf-8?B?ZTUxYnBUeGlqdjhocEVmT0ZCQ1c4VjhUV1VocXB1eUVRTC93RUdOc1AxQStC?=
 =?utf-8?B?NVRwTWdPY0wwdzd6YWFxZkVLbzduWnhRSGdRZjAyMjdRRndKUm8yV0ZHeVpR?=
 =?utf-8?B?b0VXOE04cDV0ZTA3bkVXZXV2QTZTNk5sekYyM2ZwY1JQdW9COTNCTVVDNlla?=
 =?utf-8?B?NXBNSWJyeXpFWXU4SHRKNGszd01EL1AxdTg5NDc5cCtPVm5xTFJPQ0NZRUpq?=
 =?utf-8?B?UEdURHlWblZqcW9kd200SStoVVhjMlVsbWtvanVXWXJIdGR3Wm5vL21kMWl3?=
 =?utf-8?B?VnFjUHlQU0NPRGZJZTduQVJCcTZCZ0pqZWVDY2k3UlJLZGZOZkx6ZnU3RW5v?=
 =?utf-8?B?TFFIR3k0OVlUc0hvRFlGMW5PTE5lODVjemYwTG0xQjFZWkVMd2VBbnl2YzJ0?=
 =?utf-8?B?NUpHRE5idW5LTStGMkhqSDhQWmJ5NjkzTWplZWMxNk5PZzFRNTlZd1hkbnlX?=
 =?utf-8?B?NEJHK3o3NSt3aDJTeStweWxNNUl1Nm1QYWNOZVMzNzRpYzFOenA0eUdrekhF?=
 =?utf-8?B?RDRLZTk3YzhUMmpEZ2EzWGxHRTNjUzBkNVcyZWdaUC9oc1BTOGRtTHdob0dn?=
 =?utf-8?B?dGhFekZxZHBSQkFWdm96MWhxN3B3RWZRa3N0OGxVRXIyRTk2WUtva3ZUOTJq?=
 =?utf-8?B?ekZKSVlJUmZwQk1EN3lVN1QyNXhMNHRUMXlrNWlRelo1czJVSTRMYkpjQjM2?=
 =?utf-8?B?b2dXSTRSeFcwTUlKL2hWNFE4TkdzN0I1dVdYOC9SRmNlSkRvY0dYdkhmZTVq?=
 =?utf-8?B?eUYvdGtNRVY5RVZ4YnhMOFVoV2F0aFFvY0UxbGhldDNCV2hhMGIwZkVlbjRE?=
 =?utf-8?B?OUMxWmdMbmZZR0FvVmRzejl5SFFKTGo5SGdiN041cHVGUVJQT3ljZjNsRXAr?=
 =?utf-8?B?TmVKbEJEVVQyMkt5NkVKSUdDYTJ6angwRWVsRHpCdWJyb3hmbjFkL1ZTRERs?=
 =?utf-8?B?WlBEeTVodS9XT0FqYit1SjdmdWNwRXROQWN4MGR5aGcvSkNTS0JjMHFQd1Ns?=
 =?utf-8?B?ZXFoRWxNNmZ6R3UxMDF6MStqNUJzb2lyNmdFQW5yTFNraE0yU09rVXZzazFC?=
 =?utf-8?B?M1BkdXFpUU91UVRoMEl0OVVNM1JoanlaSVpOOWpKSWt4by9XODI0cUwvZXMx?=
 =?utf-8?B?aWFtbXQxRkprSUdYN2piMldGanNZK0pYL25FVGpLRklHMkE3MG5qSG1lbHA4?=
 =?utf-8?B?UWRXVWdsSU4xZGZaRWVnZWtPdk84SXFmbUIvSzJwblZmTXZCN0dtZkJDVkx5?=
 =?utf-8?B?Zm9HbHJyK1p0SVdhc0kyYWdRci9DWHRpZXJqOUJibzU3aTFsOW9vNER4cmZk?=
 =?utf-8?B?UUhHeDFoTVBETmtyM1FLV3ZwVHBDZXdGd0tUTTFneUlLb0ZvUGJxWUNHNWUz?=
 =?utf-8?B?UzhmY1QySkl3enI3a056LzNMR2I0cUZ5VmdMdWxSM0h6TTRmU3VONEJ1TTZl?=
 =?utf-8?B?TE4xSFV5ZVNXRjI0SDlxNzR1RUdMM0ljRFpmbk1uOEhOM0pzSzdndE50dUhK?=
 =?utf-8?B?WDdxSmZVc3JOa3kxTG9JS2RpN0VRYkduOHNpSlJyLzIzUEQrOW1sKzVuQVFv?=
 =?utf-8?B?YWZoZTY5eXpIOEJFaVhWMzdNSm5YL1dvR3FNODNCalFhRmM5ckl6YWZ3TmZU?=
 =?utf-8?B?VVdtbEdXajIyVm9hK000eURTVzU4S2FIYmlhWU9OY2JLWTQveFYxNGZrNE5R?=
 =?utf-8?B?MDdUYnlOTUZkd0s4MXA4Q3g1NWM3NDM1dlVjd05VOEZYeFhLQU1KVkU2ZS9o?=
 =?utf-8?B?cndHVU9qRG9uWC9qVkErQWlSNS9CQlVLUXJCc05DMDBlaXVBNWpnbWhjRkRU?=
 =?utf-8?B?a1IzbFF1VHdrTHlZeG45bXB0a2c1dWJEUFZmQWhSRitkV3QzdGkrZlVUQUFQ?=
 =?utf-8?Q?Imum10fzZIB7W6mmIEs5gw+rBw+ihsoqD8Msmg0/34=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B43A1FF333327543A440111E89C42C59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f2a896-d349-4553-a4bf-08d9aa2210d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 23:29:13.6051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kFT5Uk5BmVWLvj3f85wsnC7rYG0v/hDxu08r+YMqPj1/+Rp26suDB1XnFcVjgrOEoejJyeMGsNvZ7Db7LTyOZE1DtlzE+lid/aOd7y7uvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4015
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIxLTA5LTE3IGF0IDExOjEwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDI6MDUgQU0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEluc3RhbGwgYSBoZWxwZXIgc2NyaXB0
IHRoYXQgY2FsbHMgZGF4Y3RsLXJlY29uZmlndXJlLWRldmljZSB3aXRoIHRoZQ0KPiA+IG5ldyAn
Y2hlY2stY29uZmlnJyBvcHRpb24gZm9yIGEgZ2l2ZW4gZGV2aWNlLiBUaGlzIGlzIG1lYW50IHRv
IGJlIGNhbGxlZA0KPiA+IHZpYSBhIHN5c3RlbWQgc2VydmljZS4NCj4gPiANCj4gPiBJbnN0YWxs
IGEgc3lzdGVtZCBzZXJ2aWNlIHRoYXQgY2FsbHMgdGhlIGFib3ZlIHdyYXBwZXIgc2NyaXB0IHdp
dGggYQ0KPiA+IGRheGN0bCBkZXZpY2UgcGFzc2VkIGluIHRvIGl0IHZpYSB0aGUgZW52aXJvbm1l
bnQuDQo+ID4gDQo+ID4gSW5zdGFsbCBhIHVkZXYgcnVsZSB0aGF0IGlzIHRyaWdnZXJlZCBmb3Ig
ZXZlcnkgZGF4Y3RsIGRldmljZSwgYW5kDQo+ID4gdHJpZ2dlcnMgdGhlIGFib3ZlIG9uZXNob3Qg
c3lzdGVtZCBzZXJ2aWNlLg0KPiA+IA0KPiA+IFRvZ2V0aGVyLCB0aGVzZSB0aHJlZSB0aGluZ3Mg
d29yayBzdWNoIHRoYXQgdXBvbiBib290LCB3aGVuZXZlciBhIGRheGN0bA0KPiA+IGRldmljZSBp
cyBmb3VuZCwgdWRldiB0cmlnZ2VycyBhIGRldmljZS1zcGVjaWZpYyBzeXN0ZW1kIHNlcnZpY2Ug
Y2FsbGVkLA0KPiA+IGZvciBleGFtcGxlOg0KPiA+IA0KPiA+ICAgZGF4ZGV2LXJlY29uZmlndXJl
QC1kZXYtZGF4MC4wLnNlcnZpY2UNCj4gDQo+IEknbSB0aGlua2luZyB0aGUgc2VydmljZSB3b3Vs
ZCBiZSBjYWxsZWQgZGF4ZGV2LWFkZCwgYmVjYXVzZSBpdCBpcw0KPiBzZXJ2aWNpbmcgS09CSl9B
REQgZXZlbnRzLCBvciBpcyB0aGUgY29udmVudGlvbiB0byBuYW1lIHRoZSBzZXJ2aWNlDQo+IGFm
dGVyIHdoYXQgaXQgZG9lcyB2cyB3aGF0IGl0IHNlcnZpY2VzPw0KPiANCj4gQWxzbywgSSdtIGN1
cmlvdXMgd2h5IHdvdWxkICJkYXgwLjAiIGJlIGluIHRoZSBzZXJ2aWNlIG5hbWUsIHNob3VsZG4n
dA0KPiB0aGlzIGJlIHNjYW5uaW5nIGFsbCBkYXggZGV2aWNlcyBhbmQgaW50ZXJuYWxseSBtYXRj
aGluZyBiYXNlZCBvbiB0aGUNCj4gY29uZmlnIGZpbGU/DQo+IA0KPiA+IA0KPiA+IFRoaXMgaW5p
dGlhdGVzIGEgZGF4Y3RsLXJlY29uZmlndXJlLWRldmljZSB3aXRoIGEgY29uZmlnIGxvb2t1cCBm
b3IgdGhlDQo+ID4gJ2RheDAuMCcgZGV2aWNlLiBJZiB0aGUgY29uZmlnIGhhcyBhbiAnW2F1dG8t
b25saW5lIDx1bmlxdWVfaWQ+XScNCj4gPiBzZWN0aW9uLCBpdCB1c2VzIHRoZSBpbmZvcm1hdGlv
biBpbiB0aGF0IHRvIHNldCB0aGUgb3BlcmF0aW5nIG1vZGUgb2YNCj4gPiB0aGUgZGV2aWNlLg0K
PiA+IA0KPiA+IElmIGFueSBkZXZpY2UgaXMgaW4gYW4gdW5leHBlY3RlZCBzdGF0dXMsICdqb3Vy
bmFsY3RsJyBjYW4gYmUgdXNlZCB0bw0KPiA+IHZpZXcgdGhlIHJlY29uZmlndXJhdGlvbiBsb2cg
Zm9yIHRoYXQgZGV2aWNlLCBmb3IgZXhhbXBsZToNCj4gPiANCj4gPiAgIGpvdXJuYWxjdGwgLS11
bml0IGRheGRldi1yZWNvbmZpZ3VyZUAtZGV2LWRheDAuMC5zZXJ2aWNlDQo+IA0KPiBUaGVyZSB3
aWxsIGJlIGEgbG9nIHBlci1kZXZpY2UsIG9yIG9ubHkgaWYgdGhlcmUgaXMgYSBzZXJ2aWNlIHBl
cg0KPiBkZXZpY2U/IE15IGFzc3VtcHRpb24gd2FzIHRoYXQgdGhpcyBzZXJ2aWNlIGlzIGZpcmlu
ZyBvZmYgZm9yIGFsbA0KPiBkZXZpY2VzIHNvIHlvdSB3b3VsZCBuZWVkIHRvIGZpbHRlciB0aGUg
bG9nIGJ5IHRoZSBkZXZpY2UtbmFtZSBpZiB5b3UNCj4ga25vdyBpdC4uLiBvciBtYXliZSBJJ20g
bWlzdW5kZXJzdGFuZGluZyBob3cgdGhpcyB1ZGV2IHNlcnZpY2Ugd29ya3MuDQo+IA0KPiA+IA0K
PiA+IFVwZGF0ZSB0aGUgUlBNIHNwZWMgZmlsZSB0byBpbmNsdWRlIHRoZSBuZXdseSBhZGRlZCBm
aWxlcyB0byB0aGUgUlBNDQo+ID4gYnVpbGQuDQo+ID4gDQo+ID4gQ2M6IFFJIEZ1bGkgPHFpLmZ1
bGlAZnVqaXRzdS5jb20+DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50
ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFA
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBjb25maWd1cmUuYWMgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDkgKysrKysrKystDQo+ID4gIGRheGN0bC85MC1kYXhjdGwtZGV2aWNlLnJ1bGVzICAg
ICAgfCAgMSArDQo+ID4gIGRheGN0bC9NYWtlZmlsZS5hbSAgICAgICAgICAgICAgICAgfCAxMCAr
KysrKysrKysrDQo+ID4gIGRheGN0bC9kYXhkZXYtYXV0by1yZWNvbmZpZ3VyZS5zaCAgfCAgMyAr
KysNCj4gPiAgZGF4Y3RsL2RheGRldi1yZWNvbmZpZ3VyZUAuc2VydmljZSB8ICA4ICsrKysrKysr
DQo+ID4gIG5kY3RsLnNwZWMuaW4gICAgICAgICAgICAgICAgICAgICAgfCAgMyArKysNCj4gPiAg
NiBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkYXhjdGwvOTAtZGF4Y3RsLWRldmljZS5ydWxlcw0KPiA+ICBjcmVh
dGUgbW9kZSAxMDA3NTUgZGF4Y3RsL2RheGRldi1hdXRvLXJlY29uZmlndXJlLnNoDQo+ID4gIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkYXhjdGwvZGF4ZGV2LXJlY29uZmlndXJlQC5zZXJ2aWNlDQo+ID4g
DQo+ID4gZGlmZiAtLWdpdCBhL2NvbmZpZ3VyZS5hYyBiL2NvbmZpZ3VyZS5hYw0KPiA+IGluZGV4
IDllMWM2ZGIuLmRmNmFiMTAgMTAwNjQ0DQo+ID4gLS0tIGEvY29uZmlndXJlLmFjDQo+ID4gKysr
IGIvY29uZmlndXJlLmFjDQo+ID4gQEAgLTE2MCw3ICsxNjAsNyBAQCBBQ19DSEVDS19GVU5DUyhb
IFwNCj4gPiANCj4gPiAgQUNfQVJHX1dJVEgoW3N5c3RlbWRdLA0KPiA+ICAgICAgICAgQVNfSEVM
UF9TVFJJTkcoWy0td2l0aC1zeXN0ZW1kXSwNCj4gPiAtICAgICAgICAgICAgICAgW0VuYWJsZSBz
eXN0ZW1kIGZ1bmN0aW9uYWxpdHkgKG1vbml0b3IpLiBAPDpAZGVmYXVsdD15ZXNAOj5AXSksDQo+
ID4gKyAgICAgICAgICAgICAgIFtFbmFibGUgc3lzdGVtZCBmdW5jdGlvbmFsaXR5LiBAPDpAZGVm
YXVsdD15ZXNAOj5AXSksDQo+ID4gICAgICAgICBbXSwgW3dpdGhfc3lzdGVtZD15ZXNdKQ0KPiA+
IA0KPiA+ICBpZiB0ZXN0ICJ4JHdpdGhfc3lzdGVtZCIgPSAieHllcyI7IHRoZW4NCj4gPiBAQCAt
MTgzLDYgKzE4MywxMyBAQCBkYXhjdGxfbW9kcHJvYmVfZGF0YT1kYXhjdGwuY29uZg0KPiA+ICBB
Q19TVUJTVChbZGF4Y3RsX21vZHByb2JlX2RhdGFkaXJdKQ0KPiA+ICBBQ19TVUJTVChbZGF4Y3Rs
X21vZHByb2JlX2RhdGFdKQ0KPiA+IA0KPiA+ICtBQ19BUkdfV0lUSCh1ZGV2cnVsZXNkaXIsDQo+
ID4gKyAgICBbQVNfSEVMUF9TVFJJTkcoWy0td2l0aC11ZGV2cnVsZXNkaXI9RElSXSwgW3VkZXYg
cnVsZXMuZCBkaXJlY3RvcnldKV0sDQo+ID4gKyAgICBbVURFVlJVTEVTRElSPSIkd2l0aHZhbCJd
LA0KPiA+ICsgICAgW1VERVZSVUxFU0RJUj0nJHtwcmVmaXh9L2xpYi91ZGV2L3J1bGVzLmQnXQ0K
PiA+ICspDQo+ID4gK0FDX1NVQlNUKFVERVZSVUxFU0RJUikNCj4gPiArDQo+ID4gIEFDX0FSR19X
SVRIKFtrZXl1dGlsc10sDQo+ID4gICAgICAgICAgICAgQVNfSEVMUF9TVFJJTkcoWy0td2l0aC1r
ZXl1dGlsc10sDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgW0VuYWJsZSBrZXl1dGlscyBm
dW5jdGlvbmFsaXR5IChzZWN1cml0eSkuICBAPDpAZGVmYXVsdD15ZXNAOj5AXSksIFtdLCBbd2l0
aF9rZXl1dGlscz15ZXNdKQ0KPiA+IGRpZmYgLS1naXQgYS9kYXhjdGwvOTAtZGF4Y3RsLWRldmlj
ZS5ydWxlcyBiL2RheGN0bC85MC1kYXhjdGwtZGV2aWNlLnJ1bGVzDQo+ID4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwLi5lZTA2NzBmDQo+ID4gLS0tIC9kZXYvbnVsbA0K
PiA+ICsrKyBiL2RheGN0bC85MC1kYXhjdGwtZGV2aWNlLnJ1bGVzDQo+ID4gQEAgLTAsMCArMSBA
QA0KPiA+ICtBQ1RJT049PSJhZGQiLCBTVUJTWVNURU09PSJkYXgiLCBUQUcrPSJzeXN0ZW1kIiwg
RU5We1NZU1RFTURfV0FOVFN9PSJkYXhkZXYtcmVjb25maWd1cmVAJGVudntERVZOQU1FfS5zZXJ2
aWNlIg0KPiA+IGRpZmYgLS1naXQgYS9kYXhjdGwvTWFrZWZpbGUuYW0gYi9kYXhjdGwvTWFrZWZp
bGUuYW0NCj4gPiBpbmRleCBmMzBjNDg1Li5kNTNiZGNmIDEwMDY0NA0KPiA+IC0tLSBhL2RheGN0
bC9NYWtlZmlsZS5hbQ0KPiA+ICsrKyBiL2RheGN0bC9NYWtlZmlsZS5hbQ0KPiA+IEBAIC0yOCwz
ICsyOCwxMyBAQCBkYXhjdGxfTERBREQgPVwNCj4gPiAgICAgICAgICQoVVVJRF9MSUJTKSBcDQo+
ID4gICAgICAgICAkKEtNT0RfTElCUykgXA0KPiA+ICAgICAgICAgJChKU09OX0xJQlMpDQo+ID4g
Kw0KPiA+ICtiaW5fU0NSSVBUUyA9IGRheGRldi1hdXRvLXJlY29uZmlndXJlLnNoDQo+ID4gK0NM
RUFORklMRVMgPSAkKGJpbl9TQ1JJUFRTKQ0KPiA+ICsNCj4gPiArdWRldnJ1bGVzZGlyID0gJChV
REVWUlVMRVNESVIpDQo+ID4gK3VkZXZydWxlc19EQVRBID0gOTAtZGF4Y3RsLWRldmljZS5ydWxl
cw0KPiA+ICsNCj4gPiAraWYgRU5BQkxFX1NZU1RFTURfVU5JVFMNCj4gPiArc3lzdGVtZF91bml0
X0RBVEEgPSBkYXhkZXYtcmVjb25maWd1cmVALnNlcnZpY2UNCj4gPiArZW5kaWYNCj4gPiBkaWZm
IC0tZ2l0IGEvZGF4Y3RsL2RheGRldi1hdXRvLXJlY29uZmlndXJlLnNoIGIvZGF4Y3RsL2RheGRl
di1hdXRvLXJlY29uZmlndXJlLnNoDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA3NTUNCj4gPiBpbmRl
eCAwMDAwMDAwLi5mNmRhNDNmDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RheGN0bC9k
YXhkZXYtYXV0by1yZWNvbmZpZ3VyZS5zaA0KPiA+IEBAIC0wLDAgKzEsMyBAQA0KPiA+ICsjIS9i
aW4vYmFzaA0KPiA+ICsNCj4gPiArZGF4Y3RsIHJlY29uZmlndXJlLWRldmljZSAtLWNoZWNrLWNv
bmZpZyAiJHsxIyMqL30iDQo+ID4gZGlmZiAtLWdpdCBhL2RheGN0bC9kYXhkZXYtcmVjb25maWd1
cmVALnNlcnZpY2UgYi9kYXhjdGwvZGF4ZGV2LXJlY29uZmlndXJlQC5zZXJ2aWNlDQo+ID4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwLi40NTFmZWYxDQo+ID4gLS0tIC9k
ZXYvbnVsbA0KPiA+ICsrKyBiL2RheGN0bC9kYXhkZXYtcmVjb25maWd1cmVALnNlcnZpY2UNCj4g
PiBAQCAtMCwwICsxLDggQEANCj4gPiArW1VuaXRdDQo+ID4gK0Rlc2NyaXB0aW9uPUF1dG9tYXRp
YyBkYXhjdGwgZGV2aWNlIHJlY29uZmlndXJhdGlvbg0KPiA+ICtEb2N1bWVudGF0aW9uPW1hbjpk
YXhjdGwtcmVjb25maWd1cmUtZGV2aWNlKDEpDQo+ID4gKw0KPiA+ICtbU2VydmljZV0NCj4gPiAr
VHlwZT1mb3JraW5nDQo+ID4gK0d1ZXNzTWFpblBJRD1mYWxzZQ0KPiA+ICtFeGVjU3RhcnQ9L2Jp
bi9zaCAtYyAiZXhlYyBkYXhkZXYtYXV0by1yZWNvbmZpZ3VyZS5zaCAlSSINCj4gDQo+IFdoeSBp
cyB0aGUgZGF4ZGV2LWF1dG8tcmVjb25maWd1cmUuc2ggaW5kaXJlY3Rpb24gbmVlZGVkPyBDYW4g
dGhpcyBub3QgYmU6DQo+IA0KPiBFeGVjU3RhcnQ9ZGF4Y3RsIHJlY29uZmlndXJlLWRldmljZSAt
QyAlSQ0KPiANCj4gLi4uaWYgdGhlIGZvcm1hdCBvZiAlbCBpcyB0aGUgaXNzdWUgSSB0aGluayBp
dCB3b3VsZCBiZSBnb29kIGZvcg0KPiByZWNvbmZpZ3VyZS1kZXZpY2UgdG8gYmUgdG9sZXJhbnQg
b2YgdGhpcyBmb3JtYXQuDQoNClllYWggaXQgd2FzIHRoZSBmb3JtYXQgb2YgJUkuIEkgZm9yZ2V0
IGV4YWN0bHkgd2hhdCBpdCB3YXMsIEkgdGhpbmsgaXQNCmNvbnRhaW5zIG1heWJlIGEgZnVsbCAv
ZGV2L2RheFguWSBwYXRoPyBTaW5jZSBpbiB0aGUgd3JhcHBlciBzY3JpcHQgSSdtDQpjbGlwcGlu
ZyBhd2F5IGV2ZXJ5dGhpbmcgdXB0byB0aGUgZmlyc3QgJy8nLiBTaG91bGQgd2UgbWFrZQ0KcmVj
b25maWd1cmUtZGV2aWNlIHVuZGVyc3RhbmQgL2Rldi9kYXhYLlk/DQoNCg==

