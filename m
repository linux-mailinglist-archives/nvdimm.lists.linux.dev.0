Return-Path: <nvdimm+bounces-1555-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EE942E416
	for <lists+linux-nvdimm@lfdr.de>; Fri, 15 Oct 2021 00:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 89BF23E0FF2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Oct 2021 22:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03C82C85;
	Thu, 14 Oct 2021 22:18:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDAA2C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 22:18:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="208602512"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="208602512"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 15:18:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="492214539"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Oct 2021 15:18:16 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 15:18:15 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 15:18:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 15:18:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 15:18:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf91ylw8500UmRYdZHpDemFZzGcM00TBmUEem4YADCPQd0D7jUJNp1VQFkkNIs7FFRZ88wlCTMlQd3dKoCfFSW1dxJzgT4UWpMZQci5b1FbAHdGpcWb9C596fwr54ijjcqO87f6c+KF3Rr1/ZSYwTdiJm6cf3zhbtSJBfjMO7CRdtrOmBL7tWsu0ayk87yZoyDvlpWPjY8e6l189Vhm0oZkVvav3RNAeWcqo71LhRWgLtXZ+jqMJvQiIaqeI/WJSVzXgVKR/Srcpmz/YOfmgSE4CbX71F7Oh2CA+dzS367R6/ot/X+XjuTwZdlDXRKo5sdXlojoqIMWgbK71xO84Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zrw/ucRH/OLPRcMGaFqxGPmmRPTj6Um2Zx6rnK0AA94=;
 b=bf0YbFozaPiVnIq6G4BspNI5qy+AkPZBfcgM28MbYyAPDHFVtjKZFMwOJ62d/H+mKsfvxC81dUHd9G+kEn/Ff5+/8Dph4BUkYNw4mHIPE83a5rJ8bd78wE+DXrP9cNjZ6SdD/euecS1VP5wtdLUQic4b5rYEYfoI1yDQptK76IT8CPo92RXroJvBpz9AqBaMb8uzZaHdXbWKdnIRWWZIFRHf6sERqp3tnh+bjOky2mx5KHnvVyi+IQD39+VVWgpyQ5M41eCHvb6xlreMvhbQTYaN1j1D/lPe9LKH3+RpsNKtln1EHnMeRyJ4Nzzmn84EsM525einBNx/sygRurmfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zrw/ucRH/OLPRcMGaFqxGPmmRPTj6Um2Zx6rnK0AA94=;
 b=Ms9XTIyN7SaVHpHnbI+HqL3vA9FCAVl6nq/yDq0U1ZJuKPZve0hAQr0Ki94spIpopDK8LULmZVNQ+E2jM2QAAqVzQLw5ohzUB7lty/FfDfimFh0CR+YhVrSbAIMZPzjHO2zxYm3S8dKVZwibGEPZY6ljmsRUL09BVjWK9ch3m+Y=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3823.namprd11.prod.outlook.com (2603:10b6:208:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 22:18:10 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 22:18:10 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 12/17] libcxl: add interfaces for label
 operations
Thread-Topic: [ndctl PATCH v4 12/17] libcxl: add interfaces for label
 operations
Thread-Index: AQHXu1Rq9q1X6I8ntkilD26l2D4w4qvTDdGAgAAOQQA=
Date: Thu, 14 Oct 2021 22:18:10 +0000
Message-ID: <0b63b6e4d89d13b3f52d2d6e94331da94a0370af.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-13-vishal.l.verma@intel.com>
	 <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
In-Reply-To: <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2f23875-ba21-48d9-1df3-08d98f6081d3
x-ms-traffictypediagnostic: MN2PR11MB3823:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3823994AE5A69538E1B13409C7B89@MN2PR11MB3823.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ygjIRAAkFy25z5VYcENLrOtTzrv6+HWMVuA8LX4x6Pnsuz9I+yQcejz/3BnCi52YxN/GMbSj6Ux7E68jtWPU/MXSG21JccZduYqFqIQa+wofPA17k5+w/vg4YLBVhQ46kuMlfp0mGCBavBsj8f72OsQbkozYzYYsoEQ0TaOkEbJboXZXb+CxpnExqqx2CI9NtoDjeDMb9t39sQl9vvR3FVjLYxZZ+Amnw4qH45Z9Tr6gmp/xgXhR2m68JIB4c2c0l8yW5Ee0wHQAZ5lr3gzLqRvMh9b74aqmsQF2TH6ZkXu7EUo6aqs7oSiX1nd53L7rVjy9JbA/ZLNWDwuzgtmlK2tb7ecs31obo4Tfe3V95jUW+Ncl8P0XV5I4JM3CYc3HfKwaZje+FxLN0FGKFPGi6bgbfztjY8SOz51mJsi/jQhoJ2ZntzGnL3BeR0JaZ6ixqVchZ41Mhr5yY93pckdbssLuDZOdz23i4ajl+M7DNBOfU/KXtr0PNwAEMvZyjlAeLlvvzALxZpOF4rC0hwfsaxZpG84h2n+USRVPdIHaqcxtBlpBe96GZMT4Luh2g9Vh7FLJKS+QnQDHD3pdkRnFmXlDg598Z/JhoNwY2SWAkH6Z+4XWVhDJTUYtR2mhaNQj52Zu5WsImnlX+L7MnIClY8QHxq6S1OrjHxqiUXhxq4UF7PR5kvG/nQzu00+u2OVHbsbTGqQfQ9SNpD6cmt5LGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6862004)(66556008)(66476007)(122000001)(38100700002)(38070700005)(82960400001)(83380400001)(508600001)(66946007)(54906003)(2616005)(37006003)(6636002)(316002)(8936002)(2906002)(36756003)(66446008)(64756008)(86362001)(5660300002)(4001150100001)(186003)(91956017)(4326008)(26005)(53546011)(6512007)(6486002)(76116006)(6506007)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmNzcUlpWnIwd1RRYXF3MFV2Z0gzN3Y4ZDhDclA4T083TFJkODNMa2RYNGFV?=
 =?utf-8?B?cS8wcEVWVmJHMEsxWis4dHhLRmZnOXUwSnJKaTZXbzloY1p6aTRvR3UwdWJn?=
 =?utf-8?B?YzM4RVRxWVNzVklhT25uNG1ndWZvYlpnREJTeFFHaE1HQ3A3dFZIWUd6MlEr?=
 =?utf-8?B?d0JkWXJ1MXQ4d1ltTHNGTEhSb0FVZXBsRW52ZWVNMVVCcDdiVmJEWFpTS05z?=
 =?utf-8?B?ZGxJV3BVcTRzWWtSVDlQdGlxVGlpOGkyZDJXVkI0eVdyN1JmVHF5NER1RjJ5?=
 =?utf-8?B?RExJTzZ1anBWRVYydDhyUjBnR3pvLzAzRHl5NEhYd3dzeFZzdFc4TkViVkVw?=
 =?utf-8?B?MmFtZmdja3ZtRXBQWVRnZ1AxNFgva0J0OVE1WHcwQWdIcGJmYlZ5YUZ2ejJz?=
 =?utf-8?B?Tmd1VnhMQW1Cd3Z0N0NWQ2dRY1k5dk9Fa3o4UFduNVFmMHdBVytick9kOXor?=
 =?utf-8?B?eXk4Z1lxYlE3UUdFV09Nb24xMDhaNkZ5c1c5OFlCK04yVVRibmpMbm4rdnRu?=
 =?utf-8?B?c1piZzV1YWg2WEk2RnZsb1lOQStrU1Q4c3g3UjFaRGhqVFBvMUllS01kWVdV?=
 =?utf-8?B?NDVVTm9UcnZuWFd2a0NlaWlKOFNZQ0hySXV4RnVXYWpEOWRxb1hTVWlrL1Zo?=
 =?utf-8?B?Z1lnakhwU2duQVpBOG9pN1h6S2I0d1M1RGdvaVBGRFoxSTZ1OHFhUzA3eWtQ?=
 =?utf-8?B?UmJSYi9adEs2YW90K29hY0tUV3REWnJZR01sZ0t6UllLSFZiNlpwUDh1ZmJh?=
 =?utf-8?B?NUc3NmJHUmdMK1BOakh6KzVqeHZ4VW94VmtjYzN6SzZaeFdiK3NjQjdKakh4?=
 =?utf-8?B?aXZVMWhHVVNMbTBIamltMHArNmYvd205ckVySGtnYWdjR1pTc2ozb1NZVXVB?=
 =?utf-8?B?bjZpeUprU1ZvZFpTb2IrZ002d3EvenVlcHdKY2Y3NlBpZzFzVktKUm5rSnJK?=
 =?utf-8?B?UlNTQ3haTnd3THFRTlFHM2JaWGJjK0N5Uk80UGlsRFhFVDNCMGMyZDF0WEpX?=
 =?utf-8?B?UXQyeEJ5YWJNampuUW9vdm1RbkE0Z1UxS1hQa0w0N01PTlcycEh1a05aRjhl?=
 =?utf-8?B?RlA1S1VVT0EydStIZWR6OGZiQk9tMVNkTFc0UmhxbmNvSUxBOFJTRkNoLy8r?=
 =?utf-8?B?R2VYT0NkTmtHOXlLa2lvWnhwbXRzbmVYTFBNNVNZZjBHdnhDdnhrUVU5My9k?=
 =?utf-8?B?eE5zZ3FMOSt3SGxPVFVtUTdXQXR3SDB5dHRMMzZiWVYwTWplNklTZFF0d2oz?=
 =?utf-8?B?c0RPQldOMDRCWUpqR2dCcHExVTNiZFZSUXRtZitOdVg5MXo3aVhjNUtGc2VW?=
 =?utf-8?B?MDVSOGZnczIxMzNXSmJldU43eGN0V0llWTFyVkVsY2xxa2tnL1V0NFNRTjM2?=
 =?utf-8?B?YkhYZForSnpwcStHTlhRMU9rb05PRnZLV09oOWNPdFpCWnBFeThkdkF5T3c0?=
 =?utf-8?B?WUdid2xhcjFGMkVWVG1XUGQ5cFF5SThjOTk1eUtncm5vdEQvekJNQUc1dTFN?=
 =?utf-8?B?Z2RCWVVBTThUVUVpR1c4Q2FLaWY0OThrVHFJUlM0LzF6aFFYdThvT2xNMXR1?=
 =?utf-8?B?czcvOTBNbFZkcVBpV0lhaU5RbXdsa2hMZ2JKaFBMdlo4Rkt2QjZxZktOeEJF?=
 =?utf-8?B?R1RDMUdNbmZlV0lqVWgzZHkxM0hJMkM3eXdhazNJQkMxeGVMUEl0aFdFSjl3?=
 =?utf-8?B?THlHWUVsNVQySGd6aHFHakhzTU53eGJwR0JCMXpVQWhXMDhUMFFScm5IM0VP?=
 =?utf-8?B?czhCWWgzODhTdEYrdFRDMFNVaFpvdE1IQzQxNVdBTEtxWGp0YWNNcnlkY3I2?=
 =?utf-8?B?QXZXeU0xMUxUODN0clY4UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26CABB77B9007446B35EB41D015635CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f23875-ba21-48d9-1df3-08d98f6081d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 22:18:10.6065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uvvhr8QoxY7DcUse0XFImIfMmkDpbjameW/iscmJYeZK5sJ/GbfDPfJ+Es7kYVbK+Z3x7n3h2BcWq6Pd7N4jKg0AF+O5sG8kNwlR4oA8xUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3823
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDE0OjI3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIGxpYmN4bCBpbnRlcmZhY2VzIHRv
IGFsbG93IHBlcmZvcm1pbmZnIGxhYmVsIChMU0EpIG1hbmlwdWxhdGlvbnMuDQo+ID4gQWRkIGEg
J2N4bF9jbWRfbmV3X3NldF9sc2EnIGludGVyZmFjZSB0byBjcmVhdGUgYSAnU2V0IExTQScgbWFp
bGJveA0KPiA+IGNvbW1hbmQgcGF5bG9hZCwgYW5kIGludGVyZmFjZXMgdG8gcmVhZCwgd3JpdGUs
IGFuZCB6ZXJvIHRoZSBMU0EgYXJlYSBvbg0KPiA+IGEgbWVtZGV2Lg0KPiA+IA0KPiA+IENjOiBE
YW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAg
Y3hsL2xpYi9wcml2YXRlLmggIHwgICA2ICsrDQo+ID4gIGN4bC9saWIvbGliY3hsLmMgICB8IDEz
NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgY3hs
L2xpYmN4bC5oICAgICAgIHwgICA3ICsrKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5zeW0gfCAgIDQg
KysNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNTQgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRp
ZmYgLS1naXQgYS9jeGwvbGliL3ByaXZhdGUuaCBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gaW5k
ZXggNjcxZjEyZi4uODkyMTJkZiAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL3ByaXZhdGUuaA0K
PiA+ICsrKyBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gQEAgLTc5LDYgKzc5LDEyIEBAIHN0cnVj
dCBjeGxfY21kX2dldF9sc2FfaW4gew0KPiA+ICAgICAgICAgbGUzMiBsZW5ndGg7DQo+ID4gIH0g
X19hdHRyaWJ1dGVfXygocGFja2VkKSk7DQo+ID4gDQo+ID4gK3N0cnVjdCBjeGxfY21kX3NldF9s
c2Egew0KPiA+ICsgICAgICAgbGUzMiBvZmZzZXQ7DQo+ID4gKyAgICAgICBsZTMyIHJzdmQ7DQo+
ID4gKyAgICAgICB1bnNpZ25lZCBjaGFyIGxzYV9kYXRhWzBdOw0KPiA+ICt9IF9fYXR0cmlidXRl
X18gKChwYWNrZWQpKTsNCj4gPiArDQo+ID4gIHN0cnVjdCBjeGxfY21kX2dldF9oZWFsdGhfaW5m
byB7DQo+ID4gICAgICAgICB1OCBoZWFsdGhfc3RhdHVzOw0KPiA+ICAgICAgICAgdTggbWVkaWFf
c3RhdHVzOw0KPiA+IGRpZmYgLS1naXQgYS9jeGwvbGliL2xpYmN4bC5jIGIvY3hsL2xpYi9saWJj
eGwuYw0KPiA+IGluZGV4IDU5ZDA5MWMuLjhkZDY5Y2YgMTAwNjQ0DQo+ID4gLS0tIGEvY3hsL2xp
Yi9saWJjeGwuYw0KPiA+ICsrKyBiL2N4bC9saWIvbGliY3hsLmMNCj4gPiBAQCAtMTEyNiwzICsx
MTI2LDE0MCBAQCBDWExfRVhQT1JUIGludCBjeGxfY21kX2dldF9vdXRfc2l6ZShzdHJ1Y3QgY3hs
X2NtZCAqY21kKQ0KPiA+ICB7DQo+ID4gICAgICAgICByZXR1cm4gY21kLT5zZW5kX2NtZC0+b3V0
LnNpemU7DQo+ID4gIH0NCj4gPiArDQo+ID4gK0NYTF9FWFBPUlQgc3RydWN0IGN4bF9jbWQgKmN4
bF9jbWRfbmV3X3dyaXRlX2xhYmVsKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYsDQo+ID4gKyAg
ICAgICAgICAgICAgIHZvaWQgKmxzYV9idWYsIHVuc2lnbmVkIGludCBvZmZzZXQsIHVuc2lnbmVk
IGludCBsZW5ndGgpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBjeGxfY3R4ICpjdHggPSBj
eGxfbWVtZGV2X2dldF9jdHgobWVtZGV2KTsNCj4gPiArICAgICAgIHN0cnVjdCBjeGxfY21kX3Nl
dF9sc2EgKnNldF9sc2E7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3hsX2NtZCAqY21kOw0KPiA+ICsg
ICAgICAgaW50IHJjOw0KPiA+ICsNCj4gPiArICAgICAgIGNtZCA9IGN4bF9jbWRfbmV3X2dlbmVy
aWMobWVtZGV2LCBDWExfTUVNX0NPTU1BTkRfSURfU0VUX0xTQSk7DQo+ID4gKyAgICAgICBpZiAo
IWNtZCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+ID4gKw0KPiA+ICsgICAg
ICAgLyogdGhpcyB3aWxsIGFsbG9jYXRlICdpbi5wYXlsb2FkJyAqLw0KPiA+ICsgICAgICAgcmMg
PSBjeGxfY21kX3NldF9pbnB1dF9wYXlsb2FkKGNtZCwgTlVMTCwgc2l6ZW9mKCpzZXRfbHNhKSAr
IGxlbmd0aCk7DQo+ID4gKyAgICAgICBpZiAocmMpIHsNCj4gPiArICAgICAgICAgICAgICAgZXJy
KGN0eCwgIiVzOiBjbWQgc2V0dXAgZmFpbGVkOiAlc1xuIiwNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICBjeGxfbWVtZGV2X2dldF9kZXZuYW1lKG1lbWRldiksIHN0cmVycm9yKC1yYykpOw0K
PiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dF9mYWlsOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsg
ICAgICAgc2V0X2xzYSA9ICh2b2lkICopY21kLT5zZW5kX2NtZC0+aW4ucGF5bG9hZDsNCj4gDQo+
IC4uLnRoZSBjYXN0IGlzIHN0aWxsIG5hZ2dpbmcgYXQgbWUgZXNwZWNpYWxseSB3aGVuIHRoaXMg
a25vd3Mgd2hhdCB0aGUNCj4gcGF5bG9hZCBpcyBzdXBwb3NlZCB0byBiZS4gV2hhdCBhYm91dCBh
IGhlbHBlciBwZXIgY29tbWFuZCB0eXBlIG9mIHRoZQ0KPiBmb3JtOg0KPiANCj4gc3RydWN0IGN4
bF9jbWRfJG5hbWUgKnRvX2N4bF9jbWRfJG5hbWUoc3RydWN0IGN4bF9jbWQgKmNtZCkNCj4gew0K
PiAgICAgaWYgKGNtZC0+c2VuZF9jbWQtPmlkICE9IENYTF9NRU1fQ09NTUFORF9JRF8kTkFNRSkN
Cj4gICAgICAgICByZXR1cm4gTlVMTDsNCj4gICAgIHJldHVybiAoc3RydWN0IGN4bF9jbWRfJG5h
bWUgKikgY21kLT5zZW5kX2NtZC0+aW4ucGF5bG9hZDsNCj4gfQ0KPiANCj4gPiArICAgICAgIHNl
dF9sc2EtPm9mZnNldCA9IGNwdV90b19sZTMyKG9mZnNldCk7DQo+ID4gKyAgICAgICBtZW1jcHko
c2V0X2xzYS0+bHNhX2RhdGEsIGxzYV9idWYsIGxlbmd0aCk7DQo+ID4gKw0KPiA+ICsgICAgICAg
cmV0dXJuIGNtZDsNCj4gPiArDQo+ID4gK291dF9mYWlsOg0KPiA+ICsgICAgICAgY3hsX2NtZF91
bnJlZihjbWQpOw0KPiA+ICsgICAgICAgcmV0dXJuIE5VTEw7DQo+ID4gK30NCj4gPiArDQo+ID4g
K2VudW0gbHNhX29wIHsNCj4gPiArICAgICAgIExTQV9PUF9HRVQsDQo+ID4gKyAgICAgICBMU0Ff
T1BfU0VULA0KPiA+ICsgICAgICAgTFNBX09QX1pFUk8sDQo+ID4gK307DQo+ID4gKw0KPiA+ICtz
dGF0aWMgaW50IGxzYV9vcChzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2LCBpbnQgb3AsIHZvaWQg
KipidWYsDQo+ID4gKyAgICAgICAgICAgICAgIHNpemVfdCBsZW5ndGgsIHNpemVfdCBvZmZzZXQp
DQo+ID4gK3sNCj4gPiArICAgICAgIGNvbnN0IGNoYXIgKmRldm5hbWUgPSBjeGxfbWVtZGV2X2dl
dF9kZXZuYW1lKG1lbWRldik7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3hsX2N0eCAqY3R4ID0gY3hs
X21lbWRldl9nZXRfY3R4KG1lbWRldik7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3hsX2NtZCAqY21k
Ow0KPiA+ICsgICAgICAgdm9pZCAqemVyb19idWYgPSBOVUxMOw0KPiA+ICsgICAgICAgc3NpemVf
dCByZXRfbGVuOw0KPiA+ICsgICAgICAgaW50IHJjID0gMDsNCj4gPiArDQo+ID4gKyAgICAgICBp
ZiAob3AgIT0gTFNBX09QX1pFUk8gJiYgKGJ1ZiA9PSBOVUxMIHx8ICpidWYgPT0gTlVMTCkpIHsN
Cj4gPiArICAgICAgICAgICAgICAgZXJyKGN0eCwgIiVzOiBMU0EgYnVmZmVyIGNhbm5vdCBiZSBO
VUxMXG4iLCBkZXZuYW1lKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+
ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgLyogVE9ETzogaGFuZGxlIHRoZSBjYXNl
IGZvciBvZmZzZXQgKyBsZW4gPiBtYWlsYm94IHBheWxvYWQgc2l6ZSAqLw0KPiA+ICsgICAgICAg
c3dpdGNoIChvcCkgew0KPiA+ICsgICAgICAgY2FzZSBMU0FfT1BfR0VUOg0KPiA+ICsgICAgICAg
ICAgICAgICBpZiAobGVuZ3RoID09IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgbGVu
Z3RoID0gbWVtZGV2LT5sc2Ffc2l6ZTsNCj4gDQo+IFdoYXQncyB0aGUgdXNlIGNhc2UgdG8gc3Vw
cG9ydCBhIGRlZmF1bHQgc2l6ZSBmb3IgZ2V0PyBJZiBzb21lb25lDQo+IHdhbnRzIHRvIGRvIGEg
emVybyBsZW5ndGggbHNhX29wIHNob3VsZG4ndCB0aGF0IGp1c3QgcmV0dXJuIGltbWVkaWF0ZQ0K
PiBzdWNjZXNzIGp1c3QgbGlrZSAwIGxlbmd0aCByZWFkKDIpPw0KDQpJIHdhcyBnb2luZyBmb3Ig
YSBjb252ZW5pZW5jZSBzaG9ydGN1dCB3aGVyZSBhIHVzZXIgY2FuIGdldCB0aGUgd2hvbGUNCnRo
aW5nIHdpdGhvdXQgbmVlZGluZyB0byB3b3JyeSBhYm91dCB3aGF0IHRoZSBtZW1kZXYncyBsc2Ff
c2l6ZSBpcywgYnV0DQppbiBoaW5kc2lnaHQsIHRoaXMgZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2Uu
IFRoZSBBUEkgY2FuIHRha2UgbGVuZ3RoIHRvDQpiZSBsaXRlcmFsIC0gYW5kIG5vdCBkbyBhbnkg
d29yayBmb3IgbGVuZ3RoID09IDAsIGFuZCB0aGUgY2xpIGNhbiBoYXZlDQp0aGUgY29udmVuaWVu
Y2UgZnVuY3Rpb24gb2YgaW1wbHlpbmcgYSBmdWxsIGxhYmVsIHJlYWQgaWYgbm8gbGVuZ3RoDQpv
cHRpb24gd2FzIHN1cHBsaWVkLg0KDQo+IA0KPiA+ICsgICAgICAgICAgICAgICBjbWQgPSBjeGxf
Y21kX25ld19yZWFkX2xhYmVsKG1lbWRldiwgb2Zmc2V0LCBsZW5ndGgpOw0KPiA+ICsgICAgICAg
ICAgICAgICBpZiAoIWNtZCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsNCj4gPiArICAgICAgICAgICAgICAgcmMgPSBjeGxfY21kX3NldF9vdXRwdXRfcGF5bG9h
ZChjbWQsICpidWYsIGxlbmd0aCk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChyYykgew0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGVycihjdHgsICIlczogY21kIHNldHVwIGZhaWxlZDog
JXNcbiIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIGN4bF9tZW1kZXZfZ2V0X2Rl
dm5hbWUobWVtZGV2KSwgc3RyZXJyb3IoLXJjKSk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgZ290byBvdXQ7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAg
YnJlYWs7DQo+ID4gKyAgICAgICBjYXNlIExTQV9PUF9aRVJPOg0KPiA+ICsgICAgICAgICAgICAg
ICBpZiAobGVuZ3RoID09IDApDQo+IA0KPiBUaGlzIG9uZSBtYWtlcyBzZW5zZSBiZWNhdXNlIHRo
ZSBjYWxsZXIganVzdCB3YW50cyB0aGUgd2hvbGUgYXJlYSB6ZXJvZWQuDQoNCkkgdGhpbmsgdGhl
IEFQSSBiZXR3ZWVuIGFsbCB0aHJlZSBvZiB0aGVzZSBzaG91bGQgYmUgY29uc2lzdGVudCBpbiBo
b3cNCidsZW5ndGgnIGlzIHRyZWF0ZWQuIEl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gemVybyBldmVy
eXRoaW5nIGlmIHRoZQ0KbGVuZ3RoIHdlcmUgcmVtb3ZlZCBmcm9tIHRoZSBBUEkgZW50aXJlbHks
IGJ1dCBpZiBpdCBpcyBwYXJ0IG9mIGl0LA0KdGhlbiB3ZSBzaG91bGQganVzdCBkbyB3aGF0IHJl
YWQvd3JpdGUgZG8uDQoNCj4gDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgbGVuZ3RoID0g
bWVtZGV2LT5sc2Ffc2l6ZTsNCj4gPiArICAgICAgICAgICAgICAgemVyb19idWYgPSBjYWxsb2Mo
MSwgbGVuZ3RoKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCF6ZXJvX2J1ZikNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gPiArICAgICAgICAgICAgICAg
YnVmID0gJnplcm9fYnVmOw0KPiANCj4gDQo+ID4gKyAgICAgICAgICAgICAgIC8qIGZhbGwgdGhy
b3VnaCAqLw0KPiA+ICsgICAgICAgY2FzZSBMU0FfT1BfU0VUOg0KPiANCj4gLi4uYW5kIGlmIGxl
bmd0aCA9PSAwIGhlcmUgdGhlcmUncyBubyBuZWVkIHRvIGdvIGFueSBmdXJ0aGVyLCB3ZSdyZSBk
b25lLg0KDQpZZXAgd2lsbCBjaGFuZ2UuDQoNCj4gDQo+ID4gKyAgICAgICAgICAgICAgIGNtZCA9
IGN4bF9jbWRfbmV3X3dyaXRlX2xhYmVsKG1lbWRldiwgKmJ1Ziwgb2Zmc2V0LCBsZW5ndGgpOw0K
PiA+ICsgICAgICAgICAgICAgICBpZiAoIWNtZCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgIHJjID0gLUVOT01FTTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9m
cmVlOw0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgIGJyZWFrOw0K
PiA+ICsgICAgICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RT
VVBQOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgIHJjID0gY3hsX2NtZF9zdWJt
aXQoY21kKTsNCj4gPiArICAgICAgIGlmIChyYyA8IDApIHsNCj4gPiArICAgICAgICAgICAgICAg
ZXJyKGN0eCwgIiVzOiBjbWQgc3VibWlzc2lvbiBmYWlsZWQ6ICVzXG4iLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgIGRldm5hbWUsIHN0cmVycm9yKC1yYykpOw0KPiA+ICsgICAgICAgICAg
ICAgICBnb3RvIG91dDsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICByYyA9IGN4
bF9jbWRfZ2V0X21ib3hfc3RhdHVzKGNtZCk7DQo+ID4gKyAgICAgICBpZiAocmMgIT0gMCkgew0K
PiA+ICsgICAgICAgICAgICAgICBlcnIoY3R4LCAiJXM6IGZpcm13YXJlIHN0YXR1czogJWRcbiIs
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2bmFtZSwgcmMpOw0KPiA+ICsgICAgICAg
ICAgICAgICByYyA9IC1FTlhJTzsNCj4gPiArICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4g
KyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKG9wID09IExTQV9PUF9HRVQpIHsNCj4g
PiArICAgICAgICAgICAgICAgcmV0X2xlbiA9IGN4bF9jbWRfcmVhZF9sYWJlbF9nZXRfcGF5bG9h
ZChjbWQsICpidWYsIGxlbmd0aCk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXRfbGVuIDwg
MCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJjID0gcmV0X2xlbjsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+
ICsgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgIC8qDQo+ID4gKyAgICAgICAgKiBUT0RPOiBJ
ZiB3cml0aW5nLCB0aGUgbWVtZGV2IG1heSBuZWVkIHRvIGJlIGRpc2FibGVkL3JlLWVuYWJsZWQg
dG8NCj4gPiArICAgICAgICAqIHJlZnJlc2ggYW55IGNhY2hlZCBMU0EgZGF0YSBpbiB0aGUga2Vy
bmVsLg0KPiA+ICsgICAgICAgICovDQo+IA0KPiBJIHRoaW5rIHdlJ3JlIHN1ZmZpY2llbnRseSBw
cm90ZWN0ZWQgYnkgdGhlIG52ZGltbS1icmlkZ2UgdXAvZG93bg0KPiBkZXBlbmRlbmN5LiBJLmUu
IGlmIHRoZSBhYm92ZSBjb21tYW5kcyBhY3R1YWxseSB3b3JrZWQgdGhlbiBub3RoaW5nDQo+IHNo
b3VsZCBoYXZlIGhhZCB0aGUgbGFiZWxzIGNhY2hlZCBpbiB0aGUga2VybmVsLg0KDQpZZXAgbWFr
ZXMgc2Vuc2UsIEknbGwgZHJvcCB0aGlzLg0KDQo+IA0KPiBBZnRlciBmaXhpbmcgdGhlIHRoZSBs
ZW5ndGggPT0gMCBjYXNlIHlvdSBjYW4gYWRkOg0KPiANCj4gUmV2aWV3ZWQtYnk6IERhbiBXaWxs
aWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KDQo=

