Return-Path: <nvdimm+bounces-1782-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C08E44373B
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Nov 2021 21:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 8335D3E0FAE
	for <lists+linux-nvdimm@lfdr.de>; Tue,  2 Nov 2021 20:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391DF2CA3;
	Tue,  2 Nov 2021 20:22:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E12C80
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 20:22:48 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="230083132"
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="230083132"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 13:22:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="599643015"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 02 Nov 2021 13:22:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 13:22:47 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 13:22:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 2 Nov 2021 13:22:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 2 Nov 2021 13:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWR7P3N7/KJe9W/4wR1qxkGo9WKl46kdf4xzKxMBtTUu9OPtRrQ+ld8/ZmxIM9sPpPzDibWVL1Gd4wB0Qyia2oi0TR/PLenzw01574WUHTKyWm/b6KjUrwqF2pRfgUKk+M/NVo6dl7qoeL40hvAD04HH6Biv59VmoOaBiLSC9JIj9DlDZTYWCF5uquy2EZZQqJKVZbsxKUMH+imhiKL4rCWH2P7WhCI09om7931cAzTQYcHLxhB79E9on3iL1DMwjPsRt3xFonZPs/ClVvY7Fm4Xry02hwnWsapBiXEBRJOPS+XPgHzwCzTbxz0ZGORrApBi3lkSObWeXKJQNOqldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/zp4AuCZL1n1PgUiFGmgLe+0NXqDVf3DdJwJ5Z5nUU=;
 b=XoisEej8jlSm8BPynAHElmDrErLswvb/a+IlQJ/QgRFI4X2E2Vaqr5Xd7Zx+Qj8nOBgCovmuRbpkm8kxNMhj6e7rVJqfzzYkJgrtkkJSmHc+qN/JjsKNKvIoznTO8UMc0IBD0ex7seiWiNQ6eQhFGwAi7EgRQGImqY3YmVVIuQjCF4t1NWVGylod2nAaU5S5dlYOU7KLESIgWEmlmqRh8ML5jEMtZoREF1uYyDXTuEBw4cBoOofb4ao5jWnn2pvE2j0qNKmpBntBRD9DnaHe2CAV+KY4pkexpfLi++mwTQ5DzQP4oc+InLDaZWeq3G6tMau6gS8OGERjQs6yE1bchA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/zp4AuCZL1n1PgUiFGmgLe+0NXqDVf3DdJwJ5Z5nUU=;
 b=Y3M/DlCPqUS7GxZoazpqZ+5PZEih0LMFxFPY/M6uL1Q+UT4nPuuyab0N+Mz3mryUCggrWLf0+Ed5UODicsMYtdfkCAL3US/R/L1SPY47P4GvjVzycQR1NIMqbAOp3e0Fn+I4kil3jSkW69wEfCEJbRx5uEsuVf3g7tVZ/epxe7A=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3582.namprd11.prod.outlook.com (2603:10b6:208:ec::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 20:22:45 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 20:22:45 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 07/17] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
Thread-Topic: [ndctl PATCH v4 07/17] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
Thread-Index: AQHXu1Rol2hun0tLokiAkQpm3BzyS6vSss2AgB4lUwA=
Date: Tue, 2 Nov 2021 20:22:45 +0000
Message-ID: <fc7be48811b489b24f0287764d421e7482219638.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-8-vishal.l.verma@intel.com>
	 <CAPcyv4ifss448zuSRphx4d5RAtjZkgiBQirbLPMAJF04NPnZLg@mail.gmail.com>
In-Reply-To: <CAPcyv4ifss448zuSRphx4d5RAtjZkgiBQirbLPMAJF04NPnZLg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d795343-fb8e-4795-36f8-08d99e3e87ca
x-ms-traffictypediagnostic: MN2PR11MB3582:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB3582194DC4370CAE9E9AD2D1C78B9@MN2PR11MB3582.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: saSGEw/I5Wzh7NUJ4rzXX1fJgEYxaLAJv57zdkc5Rs4dHYCvRi2f8YZPFKqFrqs98adcP+hL2wQd1zqgPl9YhY/G09ZF6JVc4ZNUu5EGRHd3m+i0nJmWeIpKSno+B0rPjlqkWR3R/pjtyXkHDsmA8RjPLMESl6HB4RapuV3Oz6uuQXfixsGRY6w3lzq+R70wBXpizwfr7XoyxDgN0+8AbNXRA1Lii49lseaaX9amV/tSLxl4F5/Xm5bqw2wwu7TG+ltjCCVwzfW3agQDME/trLjzQam5BN3Ejpk38xKy5JEtw1MuHxb79e1lpdG2+jgaPgdHwxI8KOyHbPBmBCNagODsNM4F+CisEEuQna8J/5oMA3td1RHvMrk2u5G4qHTwx6uVWWcLSOyFzDKIecsQ6/ppSJNi5a1Ma2k6Ivd4+9yj9eCoGZQ0DgRFn5mbCbujVMdAoWvc8Fzj3SoME6NaOnXSok7AKtb5w7wpvhdnOYJ1bToJCg4lW9vx3dvWa5KEo+7u6ubTZiQ/dQnfAI5MbtRMAerjRTmT6qVSyPGVtey1qdd1qpKZGR/DKjiEzA0V5QhJiEo3OBKPljsGW8SIJawug/YSguPAI0/m0hwjIbPzVsAmGIFWYzE1zQo0Q4SLxD7DdKihStkw8XHxg2tI33qHQUyVSqJGDEYbzoNwZ9hW7hquc1l+dpTkMHMefpMYuRTrJfe71OcNbOJasA0e+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(91956017)(38100700002)(122000001)(36756003)(66446008)(186003)(66946007)(6862004)(66556008)(64756008)(76116006)(66476007)(6512007)(6486002)(2906002)(71200400001)(26005)(2616005)(508600001)(53546011)(86362001)(15650500001)(8676002)(6636002)(54906003)(316002)(38070700005)(5660300002)(83380400001)(6506007)(4326008)(4001150100001)(8936002)(37006003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUNmOVRYVXl2VnJwaEVpZ0puZlFkODVzVGRPUnAxNnZibEhnSTBiazlEcG9D?=
 =?utf-8?B?YmFMZ1lseUYvdE81cUpoNmM2SisvQUVuSzExWmQ0b0J3ZXRndHBHS0F1Sk8r?=
 =?utf-8?B?WXJQTDhQdndjZHhISVp6WmFwdzV2MmI4KzJyQmh1c0dQUnJqdUpFOEhnMUdK?=
 =?utf-8?B?T09Ha3gvdE95MVZTbndHbUR0OVdVQlJIbEtlNkRaSTNBV2pjY3dMNjU0aEh2?=
 =?utf-8?B?VFNObkpmT3ZFZ2FUcDVZSmVKYnpGYzVOa3huWnJNTEZXeVlGcmdwdkFzdnZV?=
 =?utf-8?B?WTlxUTlScXIyMkNRbnFFNzFHanBKRkI1QlpiaDgyMERxTGNkYytDVmt5RURN?=
 =?utf-8?B?R0dGdi8wbUduWkpGMmJxQVJsaTBkQlh6d3VWbFVtdEluVktSeHNKdDNSVXJj?=
 =?utf-8?B?cUVjZ2ZKek5aUTk2Ky9HSnNlWnZrOXdNTVVMcndtSmNKd2hoeXNtNlFNUTVs?=
 =?utf-8?B?OWZBc2dyOEJmQU9hUnBJZHU2RXRIVWM0bkNWbktVYkxodVJsYlZMb0dMSWli?=
 =?utf-8?B?LysxL0x4TEhVN1d0bDR0YnNyTnZTSFRNMWpNdmFhUFNkamRjSDBiSWp3VTlI?=
 =?utf-8?B?M2J5Ry9DVFYzdk5zdXpuWXQ2bXRSSkUwZkM2L1djZjdPeHdKUEhoVmRCa3FZ?=
 =?utf-8?B?VjZWdjJCSTVlSjEzRk9RZUxoVEpuR1V1OURSTHdraVNmd01GN284ZXJQRVVL?=
 =?utf-8?B?N21udy9aZzR6WnBMcnNnV05VTXBSSy9zR0htQjBodWlUQ2RFNnorcTQrSlpm?=
 =?utf-8?B?d2JSWTJvYWVWT0RhQkw5VnlMcm9wZVQ2MkxSNU03YXVya0MyaXV5eUVIZjAv?=
 =?utf-8?B?bDk3TTBtdU5lQ0xvdk91YnRhN0VScTdKbEhrejdSR1NiUS9JbGxDbXJmUlU1?=
 =?utf-8?B?aDZHb0RLem16cml4RGYzbno2cFRwU09sZHFOSzJFais2TGhSVmlUb1ROME5s?=
 =?utf-8?B?V3RXOTBXMXoxTGlyaW5lNXJ6U3hIWkJaUTcyUEFTbmdlUVFzNWk1VnR1RXBZ?=
 =?utf-8?B?cW4vMmlCMzlYTnFlMVhHMmRmVVB3bnk2WWhEZkpqRHIrVGFRQXlBVDd0SXEv?=
 =?utf-8?B?a09YYWREeVJyc3ltNUJlZTJCUmcraTJzeUw1LzBUMXFrMDVVVUJaeFJNVVNt?=
 =?utf-8?B?UDgrOXlybTBVMnZIRk5tcUtKUTRtZzYrcE84Y2Zja09yRWxEN1hNSWFTTSsy?=
 =?utf-8?B?eW82eVpNTXpaMjBLbDFtVkFDRU9uVmxrc1FOckRkRFdGRG1wUElwajBmQldP?=
 =?utf-8?B?cEdNQ2R4MVFyRGxyQjgrUnNPcy9oUERudVAwQTA1NHVLdldJUUhxMUZIU3Nw?=
 =?utf-8?B?ZkRMeTNrbHFCTy9qM0JxTGoxaVg0Zk80WlF5VVhVNUN3NU1YeDg5OW9SMHpx?=
 =?utf-8?B?RlBEbUp2V0kvb0xrK3F3Z2V6ZDZwOHJjZXE5OE54Y3NMelhQam5tTEEwVHY5?=
 =?utf-8?B?QUxhLzVwYU93ZGcwNXN5MzNUQlZjUlFEQ2xYWklxNVR6NGRKbC8yV2pIN25r?=
 =?utf-8?B?RDc5QUpWVmpJRUxMVUZvSGs1ZHVSKzZRN2wzcHdhMGE5c2ljdEZVLy9JcEw3?=
 =?utf-8?B?Q0I3U2VLMkRPSDhFRTdjTnJ0MkZVYnFWRkJDdjVGV1hXYXRIRkpqN0M5N1Zu?=
 =?utf-8?B?RkduZUdzdHBUMEFxbkFuNFdqSVhoYTduTlRtcDhrWVc5K1huZERxdHFRTjFT?=
 =?utf-8?B?ekc1ZnpUNElzOVdJSFZwZWxzUmJJUXlEVUdCa0VRb3h0d05mUUZEc2RTSjlM?=
 =?utf-8?B?eGFHUzRHRnJ0L3VIOFJlUjlmQTRGOThvMnFJZXdXb2xmSlhSZUlVS3FrRnl3?=
 =?utf-8?B?VG9XR3c4UHBWdTBjekhaY3UyT3NIQytQbjl0cElML1Ezdkx3YW9odUdURXZz?=
 =?utf-8?B?ZkhvZnBGU2krRE1UQ0FlQ2s4R05BYzlQYTI5aGVaTlBRa3NKRitVNjN4bkVn?=
 =?utf-8?B?MnFZODFwZllJRUdHSktKL2ZPN3pXQ1BIb0VNOXJFRndPTGRTRU1Tdmtqb1Ny?=
 =?utf-8?B?eWxBdCt1WjV4NVBveDNZM011UjE0bkQ4ZmRBOUtZMDZQVW5FWkRiVXhsdnhs?=
 =?utf-8?B?M2tkVmtBN3lvSTFHa1cvV2JpWXpvVC8yczlYU29SZmpiNFZWZExndXg4azdl?=
 =?utf-8?B?akNUM3dVU2ZSMzJkY2lMa2U3NW1nWUtadDFJNFo0UStqbU9MNXlOTC8wWVJP?=
 =?utf-8?B?bkg2WkY5S3l6OWdvZnlSanlrV2pCbFV1TXFPMStCR1VwM1dJOHgwYUZYRGZo?=
 =?utf-8?Q?jE6lCHa08RA42HkspZ/L30S6t8h7TxN3F1vrF+d060=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A16691E55C44F4FA2AD7C20AEA58331@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d795343-fb8e-4795-36f8-08d99e3e87ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 20:22:45.1574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TI64TI3UUWaIXOtmXo1ihIwpQdn2zia8t+C80AEyDLJy2FQsD9BjYdy25C922MuF8B2JECsDRKYqS7GoJuT61KQA4t/0uuBF6wT8bmkdLxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3582
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDA5OjAxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
ICkNCj4gDQo+IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZp
c2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIGxpYmN4bCBBUElz
IHRvIGNyZWF0ZSBhIG5ldyBHRVRfSEVBTFRIX0lORk8gbWFpbGJveCBjb21tYW5kLCB0aGUNCj4g
PiBjb21tYW5kIG91dHB1dCBkYXRhIHN0cnVjdHVyZSAocHJpdmF0ZWx5KSwgYW5kIGFjY2Vzc29y
IEFQSXMgdG8gcmV0dXJuDQo+ID4gdGhlIGRpZmZlcmVudCBmaWVsZHMgaW4gdGhlIGhlYWx0aCBp
bmZvIG91dHB1dC4NCj4gPiANCj4gPiBDYzogQmVuIFdpZGF3c2t5IDxiZW4ud2lkYXdza3lAaW50
ZWwuY29tPg0KPiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNv
bT4NCj4gPiAtLS0NCj4gPiAgY3hsL2xpYi9wcml2YXRlLmggIHwgIDQ3ICsrKysrKysrDQo+ID4g
IGN4bC9saWIvbGliY3hsLmMgICB8IDI4NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gPiAgY3hsL2xpYmN4bC5oICAgICAgIHwgIDM4ICsrKysrKw0KPiA+
ICB1dGlsL2JpdG1hcC5oICAgICAgfCAgMjMgKysrKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5zeW0g
fCAgMzEgKysrKysNCj4gPiAgNSBmaWxlcyBjaGFuZ2VkLCA0MjUgaW5zZXJ0aW9ucygrKQ0KPiA+
IA0KPiA+IGRpZmYgLS1naXQgYS9jeGwvbGliL3ByaXZhdGUuaCBiL2N4bC9saWIvcHJpdmF0ZS5o
DQo+ID4gaW5kZXggMzI3M2YyMS4uZjc2YjUxOCAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL3By
aXZhdGUuaA0KPiA+ICsrKyBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gQEAgLTczLDYgKzczLDUz
IEBAIHN0cnVjdCBjeGxfY21kX2lkZW50aWZ5IHsNCj4gPiAgICAgICAgIHU4IHFvc190ZWxlbWV0
cnlfY2FwczsNCj4gPiAgfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsNCj4gPiANCj4gPiArc3Ry
dWN0IGN4bF9jbWRfZ2V0X2hlYWx0aF9pbmZvIHsNCj4gPiArICAgICAgIHU4IGhlYWx0aF9zdGF0
dXM7DQo+ID4gKyAgICAgICB1OCBtZWRpYV9zdGF0dXM7DQo+ID4gKyAgICAgICB1OCBleHRfc3Rh
dHVzOw0KPiA+ICsgICAgICAgdTggbGlmZV91c2VkOw0KPiA+ICsgICAgICAgbGUxNiB0ZW1wZXJh
dHVyZTsNCj4gPiArICAgICAgIGxlMzIgZGlydHlfc2h1dGRvd25zOw0KPiA+ICsgICAgICAgbGUz
MiB2b2xhdGlsZV9lcnJvcnM7DQo+ID4gKyAgICAgICBsZTMyIHBtZW1fZXJyb3JzOw0KPiA+ICt9
IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpOw0KPiA+ICsNCj4gPiArLyogQ1hMIDIuMCA4LjIuOS41
LjMgQnl0ZSAwIEhlYWx0aCBTdGF0dXMgKi8NCj4gPiArI2RlZmluZSBDWExfQ01EX0hFQUxUSF9J
TkZPX1NUQVRVU19NQUlOVEVOQU5DRV9ORUVERURfTUFTSyAgICAgICAgICAgICBCSVQoMCkNCj4g
PiArI2RlZmluZSBDWExfQ01EX0hFQUxUSF9JTkZPX1NUQVRVU19QRVJGT1JNQU5DRV9ERUdSQURF
RF9NQVNLICAgICAgICAgICBCSVQoMSkNCj4gPiArI2RlZmluZSBDWExfQ01EX0hFQUxUSF9JTkZP
X1NUQVRVU19IV19SRVBMQUNFTUVOVF9ORUVERURfTUFTSyAgICAgICAgICBCSVQoMikNCj4gPiAr
DQo+ID4gKy8qIENYTCAyLjAgOC4yLjkuNS4zIEJ5dGUgMSBNZWRpYSBTdGF0dXMgKi8NCj4gPiAr
I2RlZmluZSBDWExfQ01EX0hFQUxUSF9JTkZPX01FRElBX1NUQVRVU19OT1JNQUwgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIDB4MA0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lO
Rk9fTUVESUFfU1RBVFVTX05PVF9SRUFEWSAgICAgICAgICAgICAgICAgICAgIDB4MQ0KPiA+ICsj
ZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fTUVESUFfU1RBVFVTX1BFUlNJU1RFTkNFX0xPU1Qg
ICAgICAgICAgICAgIDB4Mg0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fTUVESUFf
U1RBVFVTX0RBVEFfTE9TVCAgICAgICAgICAgICAgICAgICAgIDB4Mw0KPiA+ICsjZGVmaW5lIENY
TF9DTURfSEVBTFRIX0lORk9fTUVESUFfU1RBVFVTX1BPV0VSTE9TU19QRVJTSVNURU5DRV9MT1NT
ICAgIDB4NA0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fTUVESUFfU1RBVFVTX1NI
VVRET1dOX1BFUlNJU1RFTkNFX0xPU1MgICAgIDB4NQ0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVB
TFRIX0lORk9fTUVESUFfU1RBVFVTX1BFUlNJU1RFTkNFX0xPU1NfSU1NSU5FTlQgICAgIDB4Ng0K
PiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fTUVESUFfU1RBVFVTX1BPV0VSTE9TU19E
QVRBX0xPU1MgICAgICAgICAgIDB4Nw0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9f
TUVESUFfU1RBVFVTX1NIVVRET1dOX0RBVEFfTE9TUyAgICAgICAgICAgIDB4OA0KPiA+ICsjZGVm
aW5lIENYTF9DTURfSEVBTFRIX0lORk9fTUVESUFfU1RBVFVTX0RBVEFfTE9TU19JTU1JTkVOVCAg
ICAgICAgICAgIDB4OQ0KPiA+ICsNCj4gPiArLyogQ1hMIDIuMCA4LjIuOS41LjMgQnl0ZSAyIEFk
ZGl0aW9uYWwgU3RhdHVzICovDQo+ID4gKyNkZWZpbmUgQ1hMX0NNRF9IRUFMVEhfSU5GT19FWFRf
TElGRV9VU0VEX01BU0sgICAgICAgICAgICAgICAgICAgICAgICAgR0VOTUFTSygxLCAwKQ0KPiA+
ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fRVhUX0xJRkVfVVNFRF9OT1JNQUwgICAgICAg
ICAgICAgICAgICAgICAgIDB4MA0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fRVhU
X0xJRkVfVVNFRF9XQVJOSU5HICAgICAgICAgICAgICAgICAgICAgIDB4MQ0KPiA+ICsjZGVmaW5l
IENYTF9DTURfSEVBTFRIX0lORk9fRVhUX0xJRkVfVVNFRF9DUklUSUNBTCAgICAgICAgICAgICAg
ICAgICAgIDB4Mg0KPiA+ICsjZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fRVhUX1RFTVBFUkFU
VVJFX01BU0sgICAgICAgICAgICAgICAgICAgICAgIEdFTk1BU0soMywgMikNCj4gPiArI2RlZmlu
ZSBDWExfQ01EX0hFQUxUSF9JTkZPX0VYVF9URU1QRVJBVFVSRV9OT1JNQUwgICAgICAgICAgICAg
ICAgICAgICAoMHgwIDw8IDIpDQo+ID4gKyNkZWZpbmUgQ1hMX0NNRF9IRUFMVEhfSU5GT19FWFRf
VEVNUEVSQVRVUkVfV0FSTklORyAgICAgICAgICAgICAgICAgICAgKDB4MSA8PCAyKQ0KPiA+ICsj
ZGVmaW5lIENYTF9DTURfSEVBTFRIX0lORk9fRVhUX1RFTVBFUkFUVVJFX0NSSVRJQ0FMICAgICAg
ICAgICAgICAgICAgICgweDIgPDwgMikNCj4gDQo+IFNvIHRoZSBrZXJuZWwgc3R5bGUgZm9yIHRo
aXMgd291bGQgYmUgdG8gaGF2ZToNCj4gDQo+ICNkZWZpbmUgQ1hMX0NNRF9IRUFMVEhfSU5GT19F
WFRfVEVNUEVSQVRVUkVfTk9STUFMICAgICAgICAgICAgICAgICAgICAoMCkNCj4gI2RlZmluZSBD
WExfQ01EX0hFQUxUSF9JTkZPX0VYVF9URU1QRVJBVFVSRV9XQVJOSU5HICAgICAgICAgICAgICAg
ICAgKDEpDQo+ICNkZWZpbmUgQ1hMX0NNRF9IRUFMVEhfSU5GT19FWFRfVEVNUEVSQVRVUkVfQ1JJ
VElDQUwgICAgICAgICAgICAgICAgICAgKDIpDQo+IA0KPiAuLi5hbmQgdGhlbiB0byBjaGVjayB0
aGUgdmFsdWUgaXQgd291bGQgYmU6DQo+IA0KPiBGSUVMRF9HRVQoQ1hMX0NNRF9IRUFMVEhfSU5G
T19FWFRfVEVNUEVSQVRVUkVfTUFTSywgYy0+ZXh0X3N0YXR1cykgPT0NCj4gQ1hMX0NNRF9IRUFM
VEhfSU5GT19FWFRfVEVNUEVSQVRVUkVfTk9STUFMDQo+IA0KPiAuLi50aGF0IHdheSBpZiB3ZSBl
dmVyIHdhbnRlZCB0byBjb3B5IGxpYmN4bCBiaXRzIGludG8gdGhlIGtlcm5lbCBpdA0KPiB3aWxs
IGFscmVhZHkgYmUgaW4gdGhlIG1hdGNoaW5nIHN0eWxlIHRvIG90aGVyIENYTCBiaXR3aXNlDQo+
IGRlZmluaXRpb25zLg0KPiANCj4gSSB0aGluayBGSUVMRF9HRVQoKSB3b3VsZCBhbHNvIGNsYXJp
ZnkgYSBmZXcgb2YgeW91ciBoZWxwZXJzIGJlbG93LA0KPiBidXQgeWVhaCBhIGJpdCBtb3JlIGlu
ZnJhc3RydWN0dXJlIHRvIGltcG9ydC4NCg0KTG9va2luZyBhdCBwb3J0aW5nIG92ZXIgRklFTERf
R0VULi4gSXQgd2FudHMgdG8gZG8NCidfX0JGX0ZJRUxEX0NIRUNLKCknLCB3aGljaCBwdWxscyBp
biBhIGxvdCBvZiB0aGUgY29tcGlsZXRpbWVfYXNzZXJ0DQpzdHVmZiB0byBiZSBhYmxlIHRvIEJV
SUxEX0JVR19PTiB3aXRoIGEgbWVzc2FnZS4NCg0KQW55IHN1Z2dlc3Rpb25zIG9uIGhvdyBtdWNo
IHdlIHdhbnQgdG8gYnJpbmcgaW4/ICBJIGNvdWxkIGRyb3AgdGhlDQpfX0JGX0ZJRUxEX0NIRUNL
IGNoZWNrcywgYW5kIHRoZW4gaXQncyB2ZXJ5IHN0cmFpZ2h0Zm9yd2FyZC4gT3IgYnJpbmcNCmlu
IHRoZSBjaGVja3MsIGJ1dCB3aXRoIGEgcGxhaW4gQlVJTERfQlVHX09OIGluc3RlYWQgb2YNCkJV
SUxEX0JVR19PTl9NU0cuLg0KDQo+IA0KPiBUaGUgcmVzdCBvZiB0aGlzIGxvb2tzIG9rIHRvIG1l
Lg0KDQo=

