Return-Path: <nvdimm+bounces-1985-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186234552D4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Nov 2021 03:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4B16F3E0E9F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 18 Nov 2021 02:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA572C97;
	Thu, 18 Nov 2021 02:40:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146B072
	for <nvdimm@lists.linux.dev>; Thu, 18 Nov 2021 02:40:50 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="320317328"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="320317328"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 18:40:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="549711244"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 17 Nov 2021 18:40:50 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 18:40:49 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 18:40:49 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 18:40:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAfZsdCvyFSebNja11eS+rGf5piz8dsDzCNxbZx3MNXA0BjQDLiwj6vZ+gXt6TP6M6saimQmZBfWZBQgrQIEmY0M6pGREXt9I0B7fqE0bBYAaHKtLd/2TpNQz1wRoE6b+x298Cdhp6/ulObtUsiIdK6Fm1kNS4y+hcwWebV6w+9PW85OOomqagEKjIRjob1ZivEOpS+2ROvTUsr4+uUp4K6oZ9LRkALeFeWC0AMNKjA4Rai+W+ZdaWlbDZuGEOQ5X8l23Y5KJot54IT5YhQPfDhLPXBMw33LqjhEAYORV4uWVysRCD4k7QRp5pBHk7J7EI9WP/6AXULigVrPRK0/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DS+ZpWYsNMzrCeuNdCixtO5N/TVX7sUUpqWqLtKmvdc=;
 b=gMEea/Lj7oPUTcN97BAeqKcFptGzFnJDbQEDP4IYm5DkjFm1rAhr7ZlwHWO6ZRIkWyyN8U+NjnjRKee8r/F6bb+2lMz9LzS3rAGT7lWcmFxTs1fhsFp8bBeaWjF9J2sPAAi/4yTyZUO9fDHtkiWe/qmeGxNlbSCcoO+D+YzZWKzu3QqArGGqBj8aXsQ4npWItwVpe9oAHucHXpC2KofrIRo3g5FF/V17w62QIq98g2npEv2Yc2iTQGaikqPdYLQDlZ9nn7WYbA5Djdmy0xjFuR155IzzpkiqrOdSg56GEZazleRnAI5Ei3sCl/j9H76hMN4T8zsLj6bTAqrk82zamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS+ZpWYsNMzrCeuNdCixtO5N/TVX7sUUpqWqLtKmvdc=;
 b=MDuVint6HuR2KxRFNNB3zqq08ELL0Uyl9AflOa/UROH8Snj4m2GRYo7BuPx+DUsFFss6m/SW1hvbIuLSrK8D88Fl1kBaFB+imm1nMpfimj5diLzqU7Oyuhjc6bb7+8bc8xe8NuhYgeWQdOuScCuP9PZ4Ov4dCsNaCCyHOzoq/Ks=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3854.namprd11.prod.outlook.com (2603:10b6:208:f0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Thu, 18 Nov
 2021 02:40:38 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 02:40:38 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>, "Hu, Fenghua" <fenghua.hu@intel.com>,
	"qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Topic: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Index: AQHXnkdcR+7iu7dUgEeHv10lAG+fv6uooiiAgGBsn4A=
Date: Thu, 18 Nov 2021 02:40:38 +0000
Message-ID: <bb9ea18f9845ec93ae72f77a42c563693ac8aaab.camel@intel.com>
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
x-ms-office365-filtering-correlation-id: 4f7df0d4-342f-46c3-0ef3-08d9aa3cce54
x-ms-traffictypediagnostic: MN2PR11MB3854:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB385489A904EDB36D089D05FCC79B9@MN2PR11MB3854.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2g/01I/88giqZra1zaDzy+nJ9Mlmhqlbn4e+H/7NQLs6QQXPVOlXfDY4h8wCGVEvLM10BDXyNAqkM11lGhiXGwy/eIOk0x6ZU6BCPcR+15tLWGCd9S9hkCkCCFPaemi5dx1+hOJ/uYZHiGPBdx+i1IuWnFCt0qRBhdWKNM+u0hKibtTBuM2S0b9BRIhFCvoWIwrw6XOUjfTXx98sfIxv2smBqYyeRZoPohGjzv0GOD4TonH3WB7Mj0yRuuG5lGkv930rVB+/K31/ue4I5Siw26KyNmsgrVZFeWf7jrUwb0B582miXs2VrHo741G4kqvXtHNYxq771jVQPKe+D37sYxBMZRLFfdTKTYkVGb3ptHehCfF+dLlXQVHqHkZXjo1V1E2EpTeBrNqS0GN20bbLNIQ5cDu2Wbe1LW/uYV9VDw7fAyigpToSpICmkvUdQb5ttF2acRzpUkJeBAJco0DRFsCoTigLs16v/FQeFF96VLgpVcxPZv1CsQF91dp/ncTHcGH4g08m0hM4o2fYctcwmD4Ndo2HoYUfr0DJL+cchk/VSVVW0un1HKkzJobyJ43ONKKuZJAiJ+EZKehWh85An3Frl1Uh7hKneWZEZQebOed0opF9GzNTIvY9vb10KfzvBBIz7fqy+OV6jMncUSn00rl848yDvW0WclWIijLaCCE12sGOOI7+fnM4JCnv+VT4SOhgYpEJwiUvV59cWYFZ/wHuaAxQVsBz/ur/C80loUsriEGCTsuamNk2RsQC7Hzq1B2TMYlDiLoJMhfVbBHgoNi2LmRsk+FZuk20skL/Drnw1OOOGtxhGSH8HmXXpu6x6O6HiYGJC2hIJdWHUb7WHBWGmJHAuOrq18TsgECSe3Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(6506007)(82960400001)(83380400001)(316002)(5660300002)(37006003)(8936002)(36756003)(4326008)(54906003)(8676002)(508600001)(966005)(53546011)(64756008)(76116006)(6862004)(66946007)(6486002)(66446008)(122000001)(6512007)(66556008)(91956017)(38100700002)(6636002)(66476007)(26005)(19273905006)(2906002)(2616005)(38070700005)(71200400001)(86362001)(562404015)(563064011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anNzbFFVeHRFby9Lb1ppcTQ2QkdmN2Z5UUN2ekQwVDF3NWorazYySE5wc0Y5?=
 =?utf-8?B?MnpaVmY0RjJGekRpQm51ck1hK2ZiSVBTZDZlSXI4bU5HRDVoOEFsQUhUK01X?=
 =?utf-8?B?U3U0VEZrZEdVWFlPVVRIQld2eWVTaU5ZSm9DUFczelEranZoM2dwbC9ZdjNk?=
 =?utf-8?B?TytUVUxVbGtjOEoyKzZRTlp0WjNFTUtuSjV4M3AxbFR1ajIzaTNLQlVwVzZW?=
 =?utf-8?B?SlVLUHIybjlhODNIQjQxdjI5amdnQ3MrdkZ6WnBobXEzemE3WFZmbmpCRVly?=
 =?utf-8?B?NWFlWkJ0T1dLQk4veU1nWlFXcjRsS3hGelFqZmZIS2g0Z3A3MUIxTnVKQVZI?=
 =?utf-8?B?bE1TMGNwTXNVY0pGTmw1eHF6UXhlbm5uRmhVN1RPVXBmMmZBcVBTM3hLcmhZ?=
 =?utf-8?B?eVZIY0YydkVkbGRJWkYyYjdpLzkxallxM0ZsaHJPUVIxWW53KzRXOG9rdmJ2?=
 =?utf-8?B?NlNLUDdiTEUwTkNSMDAzTDE1U0pQeFJIVDVrWVRUQkVUb2owN2JEekFVczZC?=
 =?utf-8?B?NDBxcXp5NDRaTHFVWWp5Z01nTjZzRk5EbWxXUEpSSG9kVE1kVWdDK1QrcmRG?=
 =?utf-8?B?czUzQVB5UVozd2ttZkFLY0VlZXhPWkxPTTdvTGIyeXU0VVdhSXZYR0t1Q3dM?=
 =?utf-8?B?ekgzd09zaHhJZlAvajBOMVZtZnBYZmxwSi9WNEJNMkFoMUNNUGx6eWNKc3NQ?=
 =?utf-8?B?d1o2dEFTcDJiUXpoS2p3TDdXMDVDRnRYdGlCWUFMZWFiaUFYTmFuQ3hULytY?=
 =?utf-8?B?YzdYYzhhRzJBL0FCbXVWUFZWNHVGWHNWVnhYMDdZd2FMdWowdXVYbEtOOU1T?=
 =?utf-8?B?czBmYnQwRjMvSXpvUE41dE9PL0RnM2E4c0lNTGF4SnNqRHVWaktrczVTci9r?=
 =?utf-8?B?Qm1UUGljS0YzQlpiOVJibEVrSU5rdERHTlVWdnUzWEd3ZkNxQ0RtM25jd3Q2?=
 =?utf-8?B?Y1UraDFTeks2bUw4ek4yNXh0a01WVkJ3TmZPY0dhR3lqU0hZSjdYRDVSd3VH?=
 =?utf-8?B?eUtueEZHNFlydnkvUk9uZlpwR2lBeGJZSGxHNXM5dkx4L1NSZnZVWGlidlVt?=
 =?utf-8?B?ajRXTm1QSndHbGZQQWEyU3RwNVk2NXBNakEzeHpkaHRJSzdpMUdRRlpIZ0VB?=
 =?utf-8?B?RUtHRUpCSi9RUFR1V0tNdzBseDYxQklEcE12RVU3TlBZNnlDVk54Ukx4SHJX?=
 =?utf-8?B?NHdqTXg2QW1RNThaQkNHN3k0S0dYeWpxUEUwaTMzcEM4dXYzWjBrZmw2OGl5?=
 =?utf-8?B?aFo1ZU83b3dPeXlZZFRudkR1elVSVnRqSGRHdzdkTjNkRkh2d0dsYWV3RytJ?=
 =?utf-8?B?M1FSL3lUK0UrZTlDbnhmS0pnU3FNTTFJKzlRQS9pTkMwcUZzWTdrNUlOOFZs?=
 =?utf-8?B?QkUreVFNWkxFRTZVTHRJc3VRY2c5YXZPL3RUcHlnRkkyeXN4aS9wL1Z4ZGti?=
 =?utf-8?B?R25QRGovSm53Y1VaejZhQkt0NWhMRHpxNHdtbGtwdWFQLytxOUJHNzZnZTFI?=
 =?utf-8?B?aDJGOGpMRThORXRtYkcva0RCalpYcXRraTNqb3V1MHJ2NExDRkVubEQ4Z2t0?=
 =?utf-8?B?S0xuRXllRURZS2FpMlNySStDK3FMU0x4RU5oRE5MZFVTd0krT2EzekZxbWJa?=
 =?utf-8?B?UDhwWUFLR1o2TU9RY1dkbkVqVW5KVkw3YWdyT2JCbi81NVN1SXdsSndiRFl2?=
 =?utf-8?B?M2RPaTNuc3AvZEFCT2g2RUtic054RzM3aEkyNlE2Z3owRkZvenNVWFc2MGFv?=
 =?utf-8?B?Y1M0b0dtTjJwN242N1BZa0crZXN4bXRWU1FLdUtvNUNUNERGenQ3cUZjdlpj?=
 =?utf-8?B?RjhNT1ZVNTBRY0lraWtJaVgxZUF0QWtjcGU2TkREMGp5OGdFUER3b1M2NS9i?=
 =?utf-8?B?TGwvTVM3aGVvMzZGVGJIQTNrS01VYU4vNWloNlltRzFjdDdBaUVycGVNTXN5?=
 =?utf-8?B?ZXJYSFZuaGlVdTJoZEtZVEp3UnQ3TUJ6K1JqYyszQXY4VjVXUjZ6dFZ6NzFa?=
 =?utf-8?B?MUJzMVFCVXFYclFucmYwV0R0NDJXSHFnWmVBL3Q1ZGxVK3BwMGt4enFPVjJ0?=
 =?utf-8?B?YnAxNWRoWkIrQ2MwUStLa1ZXVzIzekFwQWRkY2grL2FMOFQyVmpoRStERFZK?=
 =?utf-8?B?MCt0UTgvS1NhVG93Ymo2SHNsd3g2ZGY1L2p0MVFabWVoYWdETis3WlRXOWNo?=
 =?utf-8?B?VnNNenB5amgreEhmc3ltanZQL2czWUhBZlRwVHhvdDA1dkxuY3FieEJIeW4x?=
 =?utf-8?Q?iLzlaqDEQiERIsz8KY9xKACrp8I4jRM4SJ7BHUSHwA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC34A4BA9F2FA340A14BAA85A166520C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7df0d4-342f-46c3-0ef3-08d9aa3cce54
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 02:40:38.4581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2l3+G0BeVP3yKt3POr/svqkHsUnNqCABvYSJDeOnRzXfx8BxkCOyhiTxUYbSm9l52p0kP+zGBHjdEFnmZveMDeNdG3JE+4DYx4XyqtN+0gI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3854
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
dGVyIHdoYXQgaXQgZG9lcyB2cyB3aGF0IGl0IHNlcnZpY2VzPw0KDQpJIGRvbid0IGtub3cgb2Yg
YSBjb252ZW50aW9uIC0gYnV0ICd3aGF0IGl0IGRvZXMnIHNlZW1lZCBtb3JlIG5hdHVyYWwNCmZv
ciBhIHNlcnZpY2UgdGhhbiAnd2hlbiBpdCdzIGNhbGxlZCcuIEl0IGFsc28gY29ycmVsYXRlcyBi
ZXR0ZXIgd2l0aA0KdXN1YWwgc3lzdGVtIHNlcnZpY2UgbmFtZXMgKGkuZS4gdGhleSBhcmUgbmFt
ZWQgYWZ0ZXIgd2hhdCB0aGV5IGRvKS4NCg0KPiANCj4gQWxzbywgSSdtIGN1cmlvdXMgd2h5IHdv
dWxkICJkYXgwLjAiIGJlIGluIHRoZSBzZXJ2aWNlIG5hbWUsIHNob3VsZG4ndA0KPiB0aGlzIGJl
IHNjYW5uaW5nIGFsbCBkYXggZGV2aWNlcyBhbmQgaW50ZXJuYWxseSBtYXRjaGluZyBiYXNlZCBv
biB0aGUNCj4gY29uZmlnIGZpbGU/DQoNClN5c3RlbWQgYmxhY2sgbWFnaWM/IHRoZSBkYXgwLjAg
ZG9lc24ndCBjb21lIGZyb20gYW55dGhpbmcgSSBjb25maWd1cmUNCi0gdGhhdCdzIGp1c3QgaG93
IHN5c3RlbWQncyAnaW5zdGFudGlhdGVkIHNlcnZpY2VzJyB3b3JrLiBFYWNoIG5ld2x5DQphZGRl
ZCBkZXZpY2UgZ2V0cyBpdCdzIG93biBzZXJ2aWNlIHRpZWQgdG8gYSB1bmlxdWUgaWRlbnRpZmll
ciBmb3IgdGhlDQpkZXZpY2UuIEZvciB0aGVzZSwgaXQgaGFwcGVucyB0byBiZSAvZGV2L2RheDAu
MCwgd2hpY2ggZ2V0cyBlc2NhcGVkIHRvDQotZGV2LWRheDAuMC4NCg0KTW9yZSByZWFkaW5nIGhl
cmU6DQpodHRwOi8vMHBvaW50ZXIuZGUvYmxvZy9wcm9qZWN0cy9pbnN0YW5jZXMuaHRtbA0KDQo+
IA0KPiA+IA0KPiA+IFRoaXMgaW5pdGlhdGVzIGEgZGF4Y3RsLXJlY29uZmlndXJlLWRldmljZSB3
aXRoIGEgY29uZmlnIGxvb2t1cCBmb3IgdGhlDQo+ID4gJ2RheDAuMCcgZGV2aWNlLiBJZiB0aGUg
Y29uZmlnIGhhcyBhbiAnW2F1dG8tb25saW5lIDx1bmlxdWVfaWQ+XScNCj4gPiBzZWN0aW9uLCBp
dCB1c2VzIHRoZSBpbmZvcm1hdGlvbiBpbiB0aGF0IHRvIHNldCB0aGUgb3BlcmF0aW5nIG1vZGUg
b2YNCj4gPiB0aGUgZGV2aWNlLg0KPiA+IA0KPiA+IElmIGFueSBkZXZpY2UgaXMgaW4gYW4gdW5l
eHBlY3RlZCBzdGF0dXMsICdqb3VybmFsY3RsJyBjYW4gYmUgdXNlZCB0bw0KPiA+IHZpZXcgdGhl
IHJlY29uZmlndXJhdGlvbiBsb2cgZm9yIHRoYXQgZGV2aWNlLCBmb3IgZXhhbXBsZToNCj4gPiAN
Cj4gPiAgIGpvdXJuYWxjdGwgLS11bml0IGRheGRldi1yZWNvbmZpZ3VyZUAtZGV2LWRheDAuMC5z
ZXJ2aWNlDQo+IA0KPiBUaGVyZSB3aWxsIGJlIGEgbG9nIHBlci1kZXZpY2UsIG9yIG9ubHkgaWYg
dGhlcmUgaXMgYSBzZXJ2aWNlIHBlcg0KPiBkZXZpY2U/IE15IGFzc3VtcHRpb24gd2FzIHRoYXQg
dGhpcyBzZXJ2aWNlIGlzIGZpcmluZyBvZmYgZm9yIGFsbA0KPiBkZXZpY2VzIHNvIHlvdSB3b3Vs
ZCBuZWVkIHRvIGZpbHRlciB0aGUgbG9nIGJ5IHRoZSBkZXZpY2UtbmFtZSBpZiB5b3UNCj4ga25v
dyBpdC4uLiBvciBtYXliZSBJJ20gbWlzdW5kZXJzdGFuZGluZyBob3cgdGhpcyB1ZGV2IHNlcnZp
Y2Ugd29ya3MuDQoNClRoZXJlIHdpbGwgYmUgYm90aCBhIGxvZyBhbmQgYSBzZXJ2aWNlIHBlciBk
ZXZpY2UgLSB0aGUgdW5pdCBmaWxlIHdlDQpzdXBwbHkvaW5zdGFsbCBpcyBlc3NlbnRpYWxseSBh
IHRlbXBsYXRlIGZvciB0aGVzZSBpbnN0YW50aWF0ZWQNCnNlcnZpY2VzLCBidXQgdGhlIGFjdHVh
bCBzZXJ2aWNlIGtpY2tlZCBvZmYgaXMgPGZvbz5APGRldmljZS0NCmlkPi5zZXJ2aWNlDQoNCj4g
DQo+ID4gDQo+ID4gVXBkYXRlIHRoZSBSUE0gc3BlYyBmaWxlIHRvIGluY2x1ZGUgdGhlIG5ld2x5
IGFkZGVkIGZpbGVzIHRvIHRoZSBSUE0NCj4gPiBidWlsZC4NCj4gPiANCj4gPiBDYzogUUkgRnVs
aSA8cWkuZnVsaUBmdWppdHN1LmNvbT4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwu
bC52ZXJtYUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGNvbmZpZ3VyZS5hYyAgICAgICAgICAg
ICAgICAgICAgICAgfCAgOSArKysrKysrKy0NCj4gPiAgZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2Uu
cnVsZXMgICAgICB8ICAxICsNCj4gPiAgZGF4Y3RsL01ha2VmaWxlLmFtICAgICAgICAgICAgICAg
ICB8IDEwICsrKysrKysrKysNCj4gPiAgZGF4Y3RsL2RheGRldi1hdXRvLXJlY29uZmlndXJlLnNo
ICB8ICAzICsrKw0KPiA+ICBkYXhjdGwvZGF4ZGV2LXJlY29uZmlndXJlQC5zZXJ2aWNlIHwgIDgg
KysrKysrKysNCj4gPiAgbmRjdGwuc3BlYy5pbiAgICAgICAgICAgICAgICAgICAgICB8ICAzICsr
Kw0KPiA+ICA2IGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRheGN0bC85MC1kYXhjdGwtZGV2aWNlLnJ1bGVzDQo+
ID4gIGNyZWF0ZSBtb2RlIDEwMDc1NSBkYXhjdGwvZGF4ZGV2LWF1dG8tcmVjb25maWd1cmUuc2gN
Cj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRheGN0bC9kYXhkZXYtcmVjb25maWd1cmVALnNlcnZp
Y2UNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvY29uZmlndXJlLmFjIGIvY29uZmlndXJlLmFjDQo+
ID4gaW5kZXggOWUxYzZkYi4uZGY2YWIxMCAxMDA2NDQNCj4gPiAtLS0gYS9jb25maWd1cmUuYWMN
Cj4gPiArKysgYi9jb25maWd1cmUuYWMNCj4gPiBAQCAtMTYwLDcgKzE2MCw3IEBAIEFDX0NIRUNL
X0ZVTkNTKFsgXA0KPiA+IA0KPiA+ICBBQ19BUkdfV0lUSChbc3lzdGVtZF0sDQo+ID4gICAgICAg
ICBBU19IRUxQX1NUUklORyhbLS13aXRoLXN5c3RlbWRdLA0KPiA+IC0gICAgICAgICAgICAgICBb
RW5hYmxlIHN5c3RlbWQgZnVuY3Rpb25hbGl0eSAobW9uaXRvcikuIEA8OkBkZWZhdWx0PXllc0A6
PkBdKSwNCj4gPiArICAgICAgICAgICAgICAgW0VuYWJsZSBzeXN0ZW1kIGZ1bmN0aW9uYWxpdHku
IEA8OkBkZWZhdWx0PXllc0A6PkBdKSwNCj4gPiAgICAgICAgIFtdLCBbd2l0aF9zeXN0ZW1kPXll
c10pDQo+ID4gDQo+ID4gIGlmIHRlc3QgIngkd2l0aF9zeXN0ZW1kIiA9ICJ4eWVzIjsgdGhlbg0K
PiA+IEBAIC0xODMsNiArMTgzLDEzIEBAIGRheGN0bF9tb2Rwcm9iZV9kYXRhPWRheGN0bC5jb25m
DQo+ID4gIEFDX1NVQlNUKFtkYXhjdGxfbW9kcHJvYmVfZGF0YWRpcl0pDQo+ID4gIEFDX1NVQlNU
KFtkYXhjdGxfbW9kcHJvYmVfZGF0YV0pDQo+ID4gDQo+ID4gK0FDX0FSR19XSVRIKHVkZXZydWxl
c2RpciwNCj4gPiArICAgIFtBU19IRUxQX1NUUklORyhbLS13aXRoLXVkZXZydWxlc2Rpcj1ESVJd
LCBbdWRldiBydWxlcy5kIGRpcmVjdG9yeV0pXSwNCj4gPiArICAgIFtVREVWUlVMRVNESVI9IiR3
aXRodmFsIl0sDQo+ID4gKyAgICBbVURFVlJVTEVTRElSPScke3ByZWZpeH0vbGliL3VkZXYvcnVs
ZXMuZCddDQo+ID4gKykNCj4gPiArQUNfU1VCU1QoVURFVlJVTEVTRElSKQ0KPiA+ICsNCj4gPiAg
QUNfQVJHX1dJVEgoW2tleXV0aWxzXSwNCj4gPiAgICAgICAgICAgICBBU19IRUxQX1NUUklORyhb
LS13aXRoLWtleXV0aWxzXSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBbRW5hYmxlIGtl
eXV0aWxzIGZ1bmN0aW9uYWxpdHkgKHNlY3VyaXR5KS4gIEA8OkBkZWZhdWx0PXllc0A6PkBdKSwg
W10sIFt3aXRoX2tleXV0aWxzPXllc10pDQo+ID4gZGlmZiAtLWdpdCBhL2RheGN0bC85MC1kYXhj
dGwtZGV2aWNlLnJ1bGVzIGIvZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMNCj4gPiBuZXcg
ZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLmVlMDY3MGYNCj4gPiAtLS0gL2Rl
di9udWxsDQo+ID4gKysrIGIvZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMNCj4gPiBAQCAt
MCwwICsxIEBADQo+ID4gK0FDVElPTj09ImFkZCIsIFNVQlNZU1RFTT09ImRheCIsIFRBRys9InN5
c3RlbWQiLCBFTlZ7U1lTVEVNRF9XQU5UU309ImRheGRldi1yZWNvbmZpZ3VyZUAkZW52e0RFVk5B
TUV9LnNlcnZpY2UiDQo+ID4gZGlmZiAtLWdpdCBhL2RheGN0bC9NYWtlZmlsZS5hbSBiL2RheGN0
bC9NYWtlZmlsZS5hbQ0KPiA+IGluZGV4IGYzMGM0ODUuLmQ1M2JkY2YgMTAwNjQ0DQo+ID4gLS0t
IGEvZGF4Y3RsL01ha2VmaWxlLmFtDQo+ID4gKysrIGIvZGF4Y3RsL01ha2VmaWxlLmFtDQo+ID4g
QEAgLTI4LDMgKzI4LDEzIEBAIGRheGN0bF9MREFERCA9XA0KPiA+ICAgICAgICAgJChVVUlEX0xJ
QlMpIFwNCj4gPiAgICAgICAgICQoS01PRF9MSUJTKSBcDQo+ID4gICAgICAgICAkKEpTT05fTElC
UykNCj4gPiArDQo+ID4gK2Jpbl9TQ1JJUFRTID0gZGF4ZGV2LWF1dG8tcmVjb25maWd1cmUuc2gN
Cj4gPiArQ0xFQU5GSUxFUyA9ICQoYmluX1NDUklQVFMpDQo+ID4gKw0KPiA+ICt1ZGV2cnVsZXNk
aXIgPSAkKFVERVZSVUxFU0RJUikNCj4gPiArdWRldnJ1bGVzX0RBVEEgPSA5MC1kYXhjdGwtZGV2
aWNlLnJ1bGVzDQo+ID4gKw0KPiA+ICtpZiBFTkFCTEVfU1lTVEVNRF9VTklUUw0KPiA+ICtzeXN0
ZW1kX3VuaXRfREFUQSA9IGRheGRldi1yZWNvbmZpZ3VyZUAuc2VydmljZQ0KPiA+ICtlbmRpZg0K
PiA+IGRpZmYgLS1naXQgYS9kYXhjdGwvZGF4ZGV2LWF1dG8tcmVjb25maWd1cmUuc2ggYi9kYXhj
dGwvZGF4ZGV2LWF1dG8tcmVjb25maWd1cmUuc2gNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDc1NQ0K
PiA+IGluZGV4IDAwMDAwMDAuLmY2ZGE0M2YNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIv
ZGF4Y3RsL2RheGRldi1hdXRvLXJlY29uZmlndXJlLnNoDQo+ID4gQEAgLTAsMCArMSwzIEBADQo+
ID4gKyMhL2Jpbi9iYXNoDQo+ID4gKw0KPiA+ICtkYXhjdGwgcmVjb25maWd1cmUtZGV2aWNlIC0t
Y2hlY2stY29uZmlnICIkezEjIyovfSINCj4gPiBkaWZmIC0tZ2l0IGEvZGF4Y3RsL2RheGRldi1y
ZWNvbmZpZ3VyZUAuc2VydmljZSBiL2RheGN0bC9kYXhkZXYtcmVjb25maWd1cmVALnNlcnZpY2UN
Cj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLjQ1MWZlZjENCj4g
PiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZGF4Y3RsL2RheGRldi1yZWNvbmZpZ3VyZUAuc2Vy
dmljZQ0KPiA+IEBAIC0wLDAgKzEsOCBAQA0KPiA+ICtbVW5pdF0NCj4gPiArRGVzY3JpcHRpb249
QXV0b21hdGljIGRheGN0bCBkZXZpY2UgcmVjb25maWd1cmF0aW9uDQo+ID4gK0RvY3VtZW50YXRp
b249bWFuOmRheGN0bC1yZWNvbmZpZ3VyZS1kZXZpY2UoMSkNCj4gPiArDQo+ID4gK1tTZXJ2aWNl
XQ0KPiA+ICtUeXBlPWZvcmtpbmcNCj4gPiArR3Vlc3NNYWluUElEPWZhbHNlDQo+ID4gK0V4ZWNT
dGFydD0vYmluL3NoIC1jICJleGVjIGRheGRldi1hdXRvLXJlY29uZmlndXJlLnNoICVJIg0KPiAN
Cj4gV2h5IGlzIHRoZSBkYXhkZXYtYXV0by1yZWNvbmZpZ3VyZS5zaCBpbmRpcmVjdGlvbiBuZWVk
ZWQ/IENhbiB0aGlzIG5vdCBiZToNCj4gDQo+IEV4ZWNTdGFydD1kYXhjdGwgcmVjb25maWd1cmUt
ZGV2aWNlIC1DICVJDQo+IA0KPiAuLi5pZiB0aGUgZm9ybWF0IG9mICVsIGlzIHRoZSBpc3N1ZSBJ
IHRoaW5rIGl0IHdvdWxkIGJlIGdvb2QgZm9yDQo+IHJlY29uZmlndXJlLWRldmljZSB0byBiZSB0
b2xlcmFudCBvZiB0aGlzIGZvcm1hdC4NCg0K

