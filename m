Return-Path: <nvdimm+bounces-4216-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9DC572F86
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Jul 2022 09:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87F2C1C20958
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Jul 2022 07:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8BF23C8;
	Wed, 13 Jul 2022 07:47:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF007A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 07:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698466; x=1689234466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XH4Los7bnfxeU1uc2HVOXC8+YdybjvaYumQ1X7gGHNw=;
  b=WSw/0pPSCWLfEYh5yaurHsInIH3Cf4M7bZcWHVXvxkdiVRXeFBKQHrur
   2IGugpBaGzeengpGBtqlODbe8GdU2fH05aVpE5kUBA9OED3TkH7vQwTmO
   BS27PKqI5/rQsiJkfBzVoyDSko8+7C5WuostfHpAQeC8UqUdeosJxZR+S
   Qp3mGa5GVOrKyZcKDun9GV7ssN3BHfjqnhGiqHPTez0YpteguK6V+VRQd
   6FxjCfyhkbEONEwhgby2f2Ltbg1BYDfxBX433rpRh9KlWI7dLbBlisHS6
   eIvFco3IByQyFMAZgRf1UX6OTQB0h61GkKdpIz3FMjK8rO/O2mvu3EidN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="283895800"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="283895800"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:47:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="685067078"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2022 00:47:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 00:47:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 00:47:45 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 00:47:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npVDisCCYlES977qhEXLwk9QhhqCH1xvWIRhU2J6ogTbWe6G75uebH9H7MHgpH0a0d1ddbmZZGpfXbwaF8yQ+ViQb/3ozQj/iwA0WU/Sa9DT4fwSyvy+9ZHbszO1emCcL8Szs0NwSjVDP3OJswlLDS028L4BK2FcnqoTQTxFvyGIvh1cKr61ONlXwg5xasJ3GyjV3zu6fjVRdqiyQr1nqKEk6wmyMf5F63yQgHg5nOAowtd0DwYMBrNT98/MTX6vJ/3TRbHZaaNx5G8nbFz2aycU81oPaWego4TgvS/D2QD8O8BQfklp/z6BC7kRLSf/KIdUtTF6R6c9I5mT479O2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH4Los7bnfxeU1uc2HVOXC8+YdybjvaYumQ1X7gGHNw=;
 b=c8S4i4olkN0gIFvZjxeS4xLuVbJCXEvG/1D3DtFXRP5Gmi0WRpfw5zEFwYCOH7HJr5zfZS0kfJlGpGioy37j37katsSIIYz0EOqntAOW2vs17HVymKmUg6CR1CmrsVPg8J99B/r4FiqVbkP9xuO5J7vgnh3lM7PNG97CdB6SmGBM0L7i/INGF9wpg9gXuKBMEsGm0BtXvukcoq05NUXcf0LSCPyfNkNualpZFPzGvn/cU5+oHieja06oZrCwPEqdJtDkyi0yZuxPbruPV0QaBEm13/4ezlmtnykpCGndwRenSmMF12AtB98ygXy/+taXX59HOljBwrP9sX0Z3U9VZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by IA1PR11MB6395.namprd11.prod.outlook.com (2603:10b6:208:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 07:47:43 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 07:47:43 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Thread-Topic: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Thread-Index: AQHYliLJusWL0T7kEkWsmynRroPu0q177WOA
Date: Wed, 13 Jul 2022 07:47:42 +0000
Message-ID: <4c3074a5393a5d3758ac58028e047edf43f84115.camel@intel.com>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
	 <165765290724.435671.2335548848278684605.stgit@dwillia2-xfh>
In-Reply-To: <165765290724.435671.2335548848278684605.stgit@dwillia2-xfh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86bb12ee-a5de-4069-5cec-08da64a3f7fe
x-ms-traffictypediagnostic: IA1PR11MB6395:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uggw3LLeEN8qU0Cfetw8QLoou/kTvYyoFnI6wgcGxTC5GxzEovTpQtFDLzJLlYb9xxgSaOmuVbTMaX/b4pk8YN/ILo2obklHFfEVPlAvyTJRAvdATz8EywGADiJYc3NHlvIGuZjNjcaKrBW29oW4400rjsz8QqA041fUwER9ne43B2CujS3NsBBbTcBGYc/iFHv8N5U0LlKrfGZI62U+ZFJWJIm3XmcCHyjPnobnwwBbbSQjRUdJ3o1UvEs8UdJGaLdY1VDNofD3O0tys98jdXonAZNACN3XmakKrdobM71sagE8JT07FnOVpli8Ds2NPuAPpkj/wQiP0JXURqqrl8tQJ56n1GYSmAF88QrQKq/QbQv/FNawNfQPzjqfIaQVEcbRov04xnXkv6OtaKIxyQMkpERtKK3dU/8X5JmBHELKbq3AEzSHbVQEKIAlA96qzZRM/CC/C1lnCSr26OLTtAu5rc++KQKzris8q/EQI2fB+rM/6SrHKHMYFnE5yBi2fX/PoKkHphMdheE6mzAegD+sswtl7KQhr004br2KMoBW33+PDsceTceFVPTEh39AQOx2P5z15D6spZUADdTBbG6mRHJlsrM4hpd333uIQdxHr9CfabRBw4J3PZPipuP4Tdtym+ZVsE6cYBjwFokQG7llHbxdF3elQbaOy/I7dUIOfWmPFJcBd0r4Z1kS/6gAfN/5O15JCvVoTTNq7enV8lyy5Aq7+RcK1sEsI264r5IwW8ojkhszmrQgljpEiC6stE6rr94yIRai9Yb7bi+mM+2LL90ZjecE8kOqwAEmaODANVCixIBkrJX59rP44wFH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(366004)(346002)(396003)(122000001)(6512007)(26005)(478600001)(83380400001)(6486002)(2906002)(36756003)(38070700005)(66556008)(82960400001)(38100700002)(66476007)(76116006)(8936002)(4326008)(37006003)(86362001)(91956017)(64756008)(6862004)(54906003)(66446008)(6636002)(8676002)(186003)(6506007)(71200400001)(5660300002)(66946007)(316002)(41300700001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEFaZnpjdHRvS1dLM2dUcjZUaENwNFdtVmlJdU1QTWI1QitvZTF2MGw1allz?=
 =?utf-8?B?ZEhYRzdMczRXLzkybW9iTGhxdExzeTM0Z3ZzVlhkSmlQY3RCNjZKQVZIMFVr?=
 =?utf-8?B?YlNMNk9FVEtNWEprejl2UDFtOFJJMVhrQ0pXZHRGWW00Q1grb2c5a0NUc0VX?=
 =?utf-8?B?Z05Ick5hQlM1ZEN3VFEyN3I4SjlGcWRQQ29CZklnYXhMelU5elZ3RkpBZXNV?=
 =?utf-8?B?K2hTbGt3M1o5SzhueVd6eTBhb3NtMWdnUHh1ZjQ2L2U0enFUdS8zUXZHamlE?=
 =?utf-8?B?cU1xM0VXdWNPU0dLN0EwRkFsaDlQNGtNcFFyMVBHUzlNWFBXQmVyZVFncXFN?=
 =?utf-8?B?WkpPK1gyY3hjYmNYK0FWeVB0bVpmSkQ1SGN3TTV6QmlaaldrRGJiQzBWeFNS?=
 =?utf-8?B?Z212WTVQYlRKV01hbytwbnBpaVU1ckU0VHR0M1VzT0lETFZNendDVHhkWjZC?=
 =?utf-8?B?a1EwWlhrY0trQ3lRMVVFanJSQTNadkwvdVBoMmRQUkVLQWRMQXdQUW4zMG9W?=
 =?utf-8?B?V1ZNZW9lOG54aWJJaHczbml6UmhKNGQreU9ocHovV2R5MUNJWjE4eU9pMmY0?=
 =?utf-8?B?bkpZY0NDVEViaXJZYVVhR1RCRGtUS0p2UjRSbnZPZXcxak5adzlSTDE4UzVr?=
 =?utf-8?B?RXkza05kV3VwQVY3dllaSzdYb016QlN5SU8vRDBscU0yVytLWU9UVE9oWXpC?=
 =?utf-8?B?Rkh6eXhKeUFGYjRFTWRRN1RTOWZOYWtzVHlRb1ZGLzAwZXFieml5RnQvdzlS?=
 =?utf-8?B?MzkzNnJFNEtiaUFlOFdwRXR6SUFFdDZyQy9pOGkzek9xTGxVa04yekgxdmZK?=
 =?utf-8?B?SFN0TFc1bElTUjM2aG01N3poSFUrTDFMVDZPYUMxOGt6cndpVmVSZ3lpbEs5?=
 =?utf-8?B?N2lkNjZpSmZLRmpPVmxlWjFZZE10eEhER0RIYXljUUNMa3NuNVRzRWluRVNn?=
 =?utf-8?B?UHhsV3FocjNNUmRmMkZzWEw5SlNkeURZa3UxR2wvVHRLMU03QXNIMjNHc1NH?=
 =?utf-8?B?LzluUHhzZXFjYnBCanRLZFdMbnpIVjdMQzMvZXhUMEl5R0VKL01MRkQzbFR2?=
 =?utf-8?B?azBSVnBGbVFNN1FLKzQxNmJ3T215WGF2WEF5M0RWQWtyVkFVMVBMbnNIT0Nn?=
 =?utf-8?B?dnNlUmgrbS9lMUsxNXQ2dVFZaEExM1BhckJDbFhBbHFFbUxkMmRCc3E2TWow?=
 =?utf-8?B?aitIWUlnN2VkWWlsWlltRTB6dnFQR0ozVHBRMGRuM3BsU3V6UHo2RUdvR0Fz?=
 =?utf-8?B?S2ZHblI0SGFHMmwrNGFtdU8vNnI1alJVZ1FEaklNVGRJNE5XR2toYXBpQ0dw?=
 =?utf-8?B?bzFaNUFBdzQ3MVlLMmlwNlFiV05qWi9ENEdiY1lONlZUbnBuUjl0dVdnUmhM?=
 =?utf-8?B?VHN0YXBqNEJwMVdpQ05ZcnlQMjZrNU5nMm53USs1dkw2OHhTdTBXeVhyK0pn?=
 =?utf-8?B?bVdnbEJITGtmY0grTjNpOWJBOS9JRzZIdTBWZ3FzSnpvbUZPbnpYMFpnYm0w?=
 =?utf-8?B?dTdHSDhLRnY5WXArc1JMc05WODdLK3o5a0VxODcvR0EyNmlLK0JJVzNtRlN2?=
 =?utf-8?B?UHB2d1VlUTdoMmFkMFpZbHJNaU9PMU9JRVlYamp0Rzd0QVM5WlZ4eUtlVjJU?=
 =?utf-8?B?SjRlVkhsNzJWQysvU1NGMzF3YjUzVWJ2UnA5bG0xbzdQaDR4WElUdEVGK2Nj?=
 =?utf-8?B?YWhVc3EvbU9UNERnWHdGS0ZMeGZGR3M0OXcvZnVoZ2hqdWZkZkRNb3kzS3Jr?=
 =?utf-8?B?ck5uV01RZXdrTXVaMm15bEtoTW1tQkY3MFh4UGRwNFlMU0ZuUDB2MXNoNlk3?=
 =?utf-8?B?UlJrd1FTMXdjQTByNmNqWlN6MUFhWDlQS2VMbGtDSDNGamJKWlpwMmgyb0dl?=
 =?utf-8?B?UnVhWXl3a00yYWg1ZGJVZkJua1pZSFdtZCtQaWFlZ0pXcEw1eUNGTHVGWGNB?=
 =?utf-8?B?K3ByUzhlcnI3K2V0OXRoMlJNSUFMV1dzMDZERjBvaFI2VkJzMkh5d0M2MHlk?=
 =?utf-8?B?NjV5VDBOUDBjNk9KZkF0U0tuS29HMUN5bmx2UE0waVlLTnhZVzZZby9ITVZ3?=
 =?utf-8?B?NmR1M3NHNWljSWY5UnpDRWdGUDRTczRja1pUVGZCZlBUVlE1d1RMTFViNDBv?=
 =?utf-8?B?YVJVTzVrNGF0SExMTE9BOVJ2QmFRbDd1cUJGakdid09kV2pJbUMycDRmQ0dj?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33F0234D752B8C4CA3D8ACF0820B7C59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86bb12ee-a5de-4069-5cec-08da64a3f7fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 07:47:42.8810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3vMwNldEKa0o3seiLTk4GxbbhYHm7FnnMUsBAO7B4Ly9e/Rsyv/lc0o88gYlHUAaPu1M+ZVInx69gpKZSIO1LKtkqLXVnFZXdx06b90/LA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6395
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTA3LTEyIGF0IDEyOjA4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEV4ZXJjaXNlIHRoZSBmdW5kYW1lbnRhbCByZWdpb24gcHJvdmlzaW9uaW5nIHN5c2ZzIG1lY2hh
bmlzbXMgb2YgZGlzY292ZXJpbmcNCj4gYXZhaWxhYmxlIERQQSBjYXBhY2l0eSwgYWxsb2NhdGlu
ZyBEUEEgdG8gYSByZWdpb24sIGFuZCBwcm9ncmFtbWluZyBIRE0NCj4gZGVjb2RlcnMuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cj4gLS0tDQo+IMKgdGVzdC9jeGwtcmVnaW9uLWNyZWF0ZS5zaCB8wqAgMTIyICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoHRlc3QvbWVzb24uYnVpbGTC
oMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAyICsNCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDEyNCBp
bnNlcnRpb25zKCspDQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3QvY3hsLXJlZ2lvbi1jcmVh
dGUuc2gNCg0KU2luY2UgdGhpcyBpc24ndCBhY3R1YWxseSBjcmVhdGluZyBhIHJlZ2lvbiwgc2hv
dWxkIHRoaXMgYmUgbmFtZWQNCmN4bC1yZXNlcnZlLWRwYS5zaCA/DQoNCkFsdGVybmF0aXZlbHkg
LSBJIGd1ZXNzIHRoaXMgdGVzdCBjb3VsZCBqdXN0IGJlIGV4dGVuZGVkIHRvIGRvIGFjdHVhbA0K
cmVnaW9uIGNyZWF0aW9uIG9uY2UgdGhhdCBpcyBhdmFpbGFibGUgaW4gY3hsLWNsaT8NCg0KPiAN
Cj4gZGlmZiAtLWdpdCBhL3Rlc3QvY3hsLXJlZ2lvbi1jcmVhdGUuc2ggYi90ZXN0L2N4bC1yZWdp
b24tY3JlYXRlLnNoDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAw
MC4uMzg5OTg4NzU5YjA4DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVzdC9jeGwtcmVnaW9u
LWNyZWF0ZS5zaA0KPiBAQCAtMCwwICsxLDEyMiBAQA0KPiArIyEvYmluL2Jhc2gNCj4gKyMgU1BE
WC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKyMgQ29weXJpZ2h0IChDKSAyMDIyIElu
dGVsIENvcnBvcmF0aW9uLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KPiArDQo+ICsuICQoZGlybmFt
ZSAkMCkvY29tbW9uDQo+ICsNCj4gK3JjPTENCj4gKw0KPiArc2V0IC1leA0KPiArDQo+ICt0cmFw
ICdlcnIgJExJTkVOTycgRVJSDQo+ICsNCj4gK2NoZWNrX3ByZXJlcSAianEiDQo+ICsNCj4gK21v
ZHByb2JlIC1yIGN4bF90ZXN0DQo+ICttb2Rwcm9iZSBjeGxfdGVzdA0KPiArdWRldmFkbSBzZXR0
bGUNCj4gKw0KPiArIyBUSEVPUlkgT0YgT1BFUkFUSU9OOiBDcmVhdGUgYSB4OCBpbnRlcmxlYXZl
IGFjcm9zcyB0aGUgcG1lbSBjYXBhY2l0eQ0KPiArIyBvZiB0aGUgOCBlbmRwb2ludHMgZGVmaW5l
ZCBieSBjeGxfdGVzdCwgY29tbWl0IHRoZSBkZWNvZGVycyAod2hpY2gNCj4gKyMganVzdCBzdHVi
cyBvdXQgdGhlIGFjdHVhbCBoYXJkd2FyZSBwcm9ncmFtbWluZyBhc3BlY3QsIGJ1dCB1cGRhdGVz
IHRoZQ0KPiArIyBkcml2ZXIgc3RhdGUpLCBhbmQgdGhlbiB0ZWFyIGl0IGFsbCBkb3duIGFnYWlu
LiBBcyB3aXRoIG90aGVyIGN4bF90ZXN0DQo+ICsjIHRlc3RzIGlmIHRoZSBDWEwgdG9wb2xvZ3kg
aW4gdG9vbHMvdGVzdGluZy9jeGwvdGVzdC9jeGwuYyBldmVyIGNoYW5nZXMNCj4gKyMgdGhlbiB0
aGUgcGFpcmVkIHVwZGF0ZSBtdXN0IGJlIG1hZGUgdG8gdGhpcyB0ZXN0Lg0KPiArDQo+ICsjIGZp
bmQgdGhlIHJvb3QgZGVjb2RlciB0aGF0IHNwYW5zIGJvdGggdGVzdCBob3N0LWJyaWRnZXMgYW5k
IHN1cHBvcnQgcG1lbQ0KPiArZGVjb2Rlcj0kKGN4bCBsaXN0IC1iIGN4bF90ZXN0IC1EIC1kIHJv
b3QgfCBqcSAtciAiLltdIHwNCg0KVGhpcyBhbmQgYWxsIGZvbGxvd2luZyAnY3hsJyBpbnZvY2F0
aW9ucyBzaG91bGQgYmUgIiRDWEwiIHdoaWNoIHdlIGdldA0KZnJvbSB0ZXN0L2NvbW1vbg0KDQo+
ICvCoMKgwqDCoMKgwqDCoMKgIHNlbGVjdCgucG1lbV9jYXBhYmxlID09IHRydWUpIHwNCj4gK8Kg
wqDCoMKgwqDCoMKgwqAgc2VsZWN0KC5ucl90YXJnZXRzID09IDIpIHwNCj4gK8KgwqDCoMKgwqDC
oMKgwqAgLmRlY29kZXIiKQ0KPiArDQo+ICsjIGZpbmQgdGhlIG1lbWRldnMgbWFwcGVkIGJ5IHRo
YXQgZGVjb2Rlcg0KPiArcmVhZGFycmF5IC10IG1lbSA8IDwoY3hsIGxpc3QgLU0gLWQgJGRlY29k
ZXIgfCBqcSAtciAiLltdLm1lbWRldiIpDQo+ICsNCj4gKyMgYXNrIGN4bCByZXNlcnZlLWRwYSB0
byBhbGxvY2F0ZSBwbWVtIGNhcGFjaXR5IGZyb20gZWFjaCBvZiB0aG9zZSBtZW1kZXZzDQo+ICty
ZWFkYXJyYXkgLXQgZW5kcG9pbnQgPCA8KGN4bCByZXNlcnZlLWRwYSAtdCBwbWVtICR7bWVtWypd
fSAtcyAkKCgyNTY8PDIwKSkgfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGpxIC1yICIuW10gfCAuZGVjb2Rlci5kZWNvZGVyIikNCj4gKw0KPiAr
IyBpbnN0YW50aWF0ZSBhbiBlbXB0eSByZWdpb24NCj4gK3JlZ2lvbj0kKGNhdCAvc3lzL2J1cy9j
eGwvZGV2aWNlcy8kZGVjb2Rlci9jcmVhdGVfcG1lbV9yZWdpb24pDQo+ICtlY2hvICRyZWdpb24g
PiAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kZGVjb2Rlci9jcmVhdGVfcG1lbV9yZWdpb24NCj4gK3V1
aWRnZW4gPiAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kcmVnaW9uL3V1aWQNCj4gKw0KPiArIyBzZXR1
cCBpbnRlcmxlYXZlIGdlb21ldHJ5DQo+ICtucl90YXJnZXRzPSR7I2VuZHBvaW50W0BdfQ0KPiAr
ZWNobyAkbnJfdGFyZ2V0cyA+IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRyZWdpb24vaW50ZXJsZWF2
ZV93YXlzDQo+ICtnPSQoY2F0IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRkZWNvZGVyL2ludGVybGVh
dmVfZ3JhbnVsYXJpdHkpDQo+ICtlY2hvICRnID4gL3N5cy9idXMvY3hsL2RldmljZXMvJHJlZ2lv
bi9pbnRlcmxlYXZlX2dyYW51bGFyaXR5DQo+ICtlY2hvICQoKG5yX3RhcmdldHMgKiAoMjU2PDwy
MCkpKSA+IC9zeXMvYnVzL2N4bC9kZXZpY2VzLyRyZWdpb24vc2l6ZQ0KPiArDQo+ICsjIGdyYWIg
dGhlIGxpc3Qgb2YgbWVtZGV2cyBncm91cGVkIGJ5IGhvc3QtYnJpZGdlIGludGVybGVhdmUgcG9z
aXRpb24NCj4gK3BvcnRfZGV2MD0kKGN4bCBsaXN0IC1UIC1kICRkZWNvZGVyIHwganEgLXIgIi5b
XSB8DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCAudGFyZ2V0cyB8IC5bXSB8IHNlbGVjdCgucG9z
aXRpb24gPT0gMCkgfCAudGFyZ2V0IikNCj4gK3BvcnRfZGV2MT0kKGN4bCBsaXN0IC1UIC1kICRk
ZWNvZGVyIHwganEgLXIgIi5bXSB8DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCAudGFyZ2V0cyB8
IC5bXSB8IHNlbGVjdCgucG9zaXRpb24gPT0gMSkgfCAudGFyZ2V0IikNCj4gK3JlYWRhcnJheSAt
dCBtZW1fc29ydDAgPCA8KGN4bCBsaXN0IC1NIC1wICRwb3J0X2RldjAgfCBqcSAtciAiLltdIHwg
Lm1lbWRldiIpDQo+ICtyZWFkYXJyYXkgLXQgbWVtX3NvcnQxIDwgPChjeGwgbGlzdCAtTSAtcCAk
cG9ydF9kZXYxIHwganEgLXIgIi5bXSB8IC5tZW1kZXYiKQ0KPiArDQo+ICsjIFRPRE86IGFkZCBh
IGN4bCBsaXN0IG9wdGlvbiB0byBsaXN0IG1lbWRldnMgaW4gdmFsaWQgcmVnaW9uIHByb3Zpc2lv
bmluZw0KPiArIyBvcmRlciwgaGFyZGNvZGUgZm9yIG5vdy4NCj4gK21lbV9zb3J0PSgpDQo+ICtt
ZW1fc29ydFswXT0ke21lbV9zb3J0MFswXX0NCj4gK21lbV9zb3J0WzFdPSR7bWVtX3NvcnQxWzBd
fQ0KPiArbWVtX3NvcnRbMl09JHttZW1fc29ydDBbMl19DQo+ICttZW1fc29ydFszXT0ke21lbV9z
b3J0MVsyXX0NCj4gK21lbV9zb3J0WzRdPSR7bWVtX3NvcnQwWzFdfQ0KPiArbWVtX3NvcnRbNV09
JHttZW1fc29ydDFbMV19DQo+ICttZW1fc29ydFs2XT0ke21lbV9zb3J0MFszXX0NCj4gK21lbV9z
b3J0WzddPSR7bWVtX3NvcnQxWzNdfQ0KPiArDQo+ICsjIFRPRE86IHVzZSB0aGlzIGFsdGVybmF0
aXZlIG1lbWRldiBvcmRlcmluZyB0byB2YWxpZGF0ZSBhIG5lZ2F0aXZlIHRlc3QgZm9yDQo+ICsj
IHNwZWNpZnlpbmcgaW52YWxpZCBwb3NpdGlvbnMgb2YgbWVtZGV2cw0KPiArI21lbV9zb3J0WzJd
PSR7bWVtX3NvcnQwWzBdfQ0KPiArI21lbV9zb3J0WzFdPSR7bWVtX3NvcnQxWzBdfQ0KPiArI21l
bV9zb3J0WzBdPSR7bWVtX3NvcnQwWzJdfQ0KPiArI21lbV9zb3J0WzNdPSR7bWVtX3NvcnQxWzJd
fQ0KPiArI21lbV9zb3J0WzRdPSR7bWVtX3NvcnQwWzFdfQ0KPiArI21lbV9zb3J0WzVdPSR7bWVt
X3NvcnQxWzFdfQ0KPiArI21lbV9zb3J0WzZdPSR7bWVtX3NvcnQwWzNdfQ0KPiArI21lbV9zb3J0
WzddPSR7bWVtX3NvcnQxWzNdfQ0KPiArDQo+ICsjIHJlLWdlbmVyYXRlIHRoZSBsaXN0IG9mIGVu
ZHBvaW50IGRlY29kZXJzIGluIHJlZ2lvbiBwb3NpdGlvbiBwcm9ncmFtbWluZyBvcmRlcg0KPiAr
ZW5kcG9pbnQ9KCkNCj4gK2ZvciBpIGluICR7bWVtX3NvcnRbQF19DQo+ICtkbw0KPiArwqDCoMKg
wqDCoMKgwqByZWFkYXJyYXkgLU8gJHsjZW5kcG9pbnRbQF19IC10IGVuZHBvaW50IDwgPChjeGwg
bGlzdCAtRGkgLWQgZW5kcG9pbnQgLW0gJGkgfCBqcSAtciAiLltdIHwNCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWxlY3QoLm1vZGUgPT0gXCJwbWVt
XCIpIHwgLmRlY29kZXIiKQ0KPiArZG9uZQ0KPiArDQo+ICsjIGF0dGFjaCBhbGwgZW5kcG9pbnQg
ZGVjb2RlcnMgdG8gdGhlIHJlZ2lvbg0KPiArcG9zPTANCj4gK2ZvciBpIGluICR7ZW5kcG9pbnRb
QF19DQo+ICtkbw0KPiArwqDCoMKgwqDCoMKgwqBlY2hvICRpID4gL3N5cy9idXMvY3hsL2Rldmlj
ZXMvJHJlZ2lvbi90YXJnZXQkcG9zDQo+ICvCoMKgwqDCoMKgwqDCoHBvcz0kKChwb3MrMSkpDQo+
ICtkb25lDQo+ICtlY2hvICIkcmVnaW9uIGFkZGVkICR7I2VuZHBvaW50W0BdfSB0YXJnZXRzOiAk
e2VuZHBvaW50W0BdfSINCj4gKw0KPiArIyB3YWxrIHVwIHRoZSB0b3BvbG9neSBhbmQgY29tbWl0
IGFsbCBkZWNvZGVycw0KPiArZWNobyAxID4gL3N5cy9idXMvY3hsL2RldmljZXMvJHJlZ2lvbi9j
b21taXQNCj4gKw0KPiArIyB3YWxrIGRvd24gdGhlIHRvcG9sb2d5IGFuZCBkZS1jb21taXQgYWxs
IGRlY29kZXJzDQo+ICtlY2hvIDAgPiAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kcmVnaW9uL2NvbW1p
dA0KPiArDQo+ICsjIHJlbW92ZSBlbmRwb2ludHMgZnJvbSB0aGUgcmVnaW9uDQo+ICtwb3M9MA0K
PiArZm9yIGkgaW4gJHtlbmRwb2ludFtAXX0NCj4gK2RvDQo+ICvCoMKgwqDCoMKgwqDCoGVjaG8g
IiIgPiAvc3lzL2J1cy9jeGwvZGV2aWNlcy8kcmVnaW9uL3RhcmdldCRwb3MNCj4gK8KgwqDCoMKg
wqDCoMKgcG9zPSQoKHBvcysxKSkNCj4gK2RvbmUNCj4gKw0KPiArIyByZWxlYXNlIERQQSBjYXBh
Y2l0eQ0KPiArcmVhZGFycmF5IC10IGVuZHBvaW50IDwgPChjeGwgZnJlZS1kcGEgLXQgcG1lbSAk
e21lbVsqXX0gfA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGpxIC1yICIuW10gfCAuZGVjb2Rlci5kZWNvZGVyIikNCj4gK2VjaG8gIiRyZWdpb24g
cmVsZWFzZWQgJHsjZW5kcG9pbnRbQF19IHRhcmdldHM6ICR7ZW5kcG9pbnRbQF19Ig0KPiArDQo+
ICsjIHZhbGlkYXRlIG5vIFdBUk4gb3IgbG9ja2RlcCByZXBvcnQgZHVyaW5nIHRoZSBydW4NCj4g
K2xvZz0kKGpvdXJuYWxjdGwgLXIgLWsgLS1zaW5jZSAiLSQoKFNFQ09ORFMrMSkpcyIpDQo+ICtn
cmVwIC1xICJDYWxsIFRyYWNlIiA8PDwgJGxvZyAmJiBlcnIgIiRMSU5FTk8iDQo+ICsNCj4gK21v
ZHByb2JlIC1yIGN4bF90ZXN0DQo+IGRpZmYgLS1naXQgYS90ZXN0L21lc29uLmJ1aWxkIGIvdGVz
dC9tZXNvbi5idWlsZA0KPiBpbmRleCAyMTBkY2IwYjVmZjEuLmZiY2ZjMDhkMDNlZSAxMDA2NDQN
Cj4gLS0tIGEvdGVzdC9tZXNvbi5idWlsZA0KPiArKysgYi90ZXN0L21lc29uLmJ1aWxkDQo+IEBA
IC0xNTEsNiArMTUxLDcgQEAgbWF4X2V4dGVudCA9IGZpbmRfcHJvZ3JhbSgnbWF4X2F2YWlsYWJs
ZV9leHRlbnRfbnMuc2gnKQ0KPiDCoHBmbl9tZXRhX2Vycm9ycyA9IGZpbmRfcHJvZ3JhbSgncGZu
LW1ldGEtZXJyb3JzLnNoJykNCj4gwqB0cmFja191dWlkID0gZmluZF9wcm9ncmFtKCd0cmFjay11
dWlkLnNoJykNCj4gwqBjeGxfdG9wbyA9IGZpbmRfcHJvZ3JhbSgnY3hsLXRvcG9sb2d5LnNoJykN
Cj4gK2N4bF9yZWdpb24gPSBmaW5kX3Byb2dyYW0oJ2N4bC1yZWdpb24tY3JlYXRlLnNoJykNCj4g
wqANCj4gwqB0ZXN0cyA9IFsNCj4gwqDCoCBbICdsaWJuZGN0bCcswqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBsaWJuZGN0bCzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICdu
ZGN0bCcgXSwNCj4gQEAgLTE3Niw2ICsxNzcsNyBAQCB0ZXN0cyA9IFsNCj4gwqDCoCBbICdwZm4t
bWV0YS1lcnJvcnMuc2gnLMKgwqDCoMKgIHBmbl9tZXRhX2Vycm9ycyzCoMKgICduZGN0bCcgXSwN
Cj4gwqDCoCBbICd0cmFjay11dWlkLnNoJyzCoMKgwqDCoMKgwqDCoMKgwqAgdHJhY2tfdXVpZCzC
oMKgwqDCoMKgwqDCoCAnbmRjdGwnIF0sDQo+IMKgwqAgWyAnY3hsLXRvcG9sb2d5LnNoJyzCoMKg
wqDCoMKgwqAgY3hsX3RvcG8swqDCoMKgwqDCoMKgwqDCoMKgwqAgJ2N4bCfCoMKgIF0sDQo+ICvC
oCBbICdjeGwtcmVnaW9uLWNyZWF0ZS5zaCcswqDCoCBjeGxfcmVnaW9uLMKgwqDCoMKgwqDCoMKg
ICdjeGwnwqDCoCBdLA0KPiDCoF0NCj4gwqANCj4gwqBpZiBnZXRfb3B0aW9uKCdkZXN0cnVjdGl2
ZScpLmVuYWJsZWQoKQ0KPiANCg0K

