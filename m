Return-Path: <nvdimm+bounces-5785-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D49C6975A1
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Feb 2023 06:00:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BE9728098A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 15 Feb 2023 05:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9F217F5;
	Wed, 15 Feb 2023 05:00:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF81CBA5
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 05:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676437233; x=1707973233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A/XmETmA5xo0aTAPIkuTZQeqWDt6uK8Iu2Q1xlydZYI=;
  b=K5sEZ7xACpHiCiTjxJOijFKp3JcTGvTKukUgZd24WzbCxjZUMAzvM7TA
   UPTnKY3R/OoTz2+X9I4CNBtiN/u8FP0b/dx7S0IdI6Mujd7ZtrHJRir+8
   kFlzVGEiUBz8jHTCiZsNul8zRV8BFq3lmdEn6SxKqAQww6Fn+3b+eWRrC
   fTUqAZ0B/nTx16WetVwxD53k9mdSzyIDk8XnOoA5x+WJD1Hpvu8HU1P/J
   TPpOSVs8COKB1x/4K7vuYAbFQnqZuM8Xyla0vOEfyZbdYzz4XnTThFPJM
   Nw3JOpOkj0WW7tl+Kl51ZvmS326x+sXHNFelUCCNp8x/UKrxaFgXaUFXs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331347861"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="331347861"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 21:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="812296568"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="812296568"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 21:00:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 21:00:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 21:00:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 21:00:31 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 21:00:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLaQSw9adaaCxGzapEXuD0x84REWBX+GBtWrd78R59PDzDiA6E40w/nza0Ywocw24PwIvJhinqLoftFKE/velq63lxqmG2hP4KoypWzvq2j3fpz582qiAqvOSr5SW2Z1u7fkyLEl89DiseHs21LJSxLzt/9ovYqF3vG8GP7eEOEAqPmTIYuqGwKzwhdjj5MXwDioolk+ieY4G6zdv7mkPl3KRqI1AGl7C6IKZazSvnFadPhOQt3ottk5B1mBhrTmK/IH0uBCVs6ODpcCTrZFJZUB8W4uwR8O/zySxO0ldKK1EDHyyXqCQ8/0zOY5hitIyjV45DSKJLiGbf5d5IGLzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/XmETmA5xo0aTAPIkuTZQeqWDt6uK8Iu2Q1xlydZYI=;
 b=XnPfgL2EbS2Zrf8F1Nypdh+EtbzJuMkqbgdy636t/TXHzhH6nNGKaZzOD7QX1fAZ1gVkbbmwH5BODciFrJyopJnRWrnzHjnD5ZK+j4adM0gBmnOiXdc3KTtAINgjXON4U1eDldJBFEAwEIsUnbUdBRxDVOuGTZ93+no2GNa9xgX32QRR1s3sQTvvIApzMQXkacNvT6lmrgxvUJxJuJLnaJVPA0xqoW5Uu04H5+3ukVUlE15/smyM/oALusiNqEA42CUGDwd+QqY7NEQn8RCZmS4qAWMK7d21CoG1zRRGBDsaTuF2Y0z/evSpOb7r8ipu/hP/cQKmnReGPSYafjrUbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA0PR11MB4686.namprd11.prod.outlook.com (2603:10b6:806:97::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 05:00:29 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 05:00:29 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "motin, alexander" <mav@ixsystems.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Lijun.Pan@dell.com"
	<Lijun.Pan@dell.com>
Subject: Re: [ndctl PATCH 1/2 v2 RESEND] libndctl/msft: Cleanup the code
Thread-Topic: [ndctl PATCH 1/2 v2 RESEND] libndctl/msft: Cleanup the code
Thread-Index: AQHZJ3SPO+WGQ6pvNEKjW7CA4KF0gq7Ppe2A
Date: Wed, 15 Feb 2023 05:00:29 +0000
Message-ID: <f92606c0b951f23e2cc4db641f6c18cbb6647804.camel@intel.com>
References: <20230113172732.1122643-1-mav@ixsystems.com>
In-Reply-To: <20230113172732.1122643-1-mav@ixsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SA0PR11MB4686:EE_
x-ms-office365-filtering-correlation-id: de99321d-dc60-4cb2-6bd2-08db0f118f08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RS3PTnPOcNyApCjnZ8c6smdFSA63r/fciMFliN37t90X6DSudEBaAb3G32V3LPSVi4KrS2GmpjA5JaWtq+bXcbqgGWW7H+mMio7H0U/y9+CT36GgzN6Ey3OnPt0EahBDAAa6HxnOpFdCZnN+1pflxg+69MsV5vVIe9kEQXkoXKxGkfWKtiX4FTQN3gUhndmC4zv24b5sRSogj25uzXjUkmRczsGJjy1QGpEsnSqsgmIbmg52k/cLOrphjO0yr5cPCy0VG5V2sUtG4IdSRddNrRt3gECwC07E0EBJk99uxwniulB7i6TRXrRXh0LWDqDv05feSgc08SK4bIGzIlIT4ncLCPp19ETUwihRj1xesviAw9jRzLizo5x2Q4vzc2GFJhn2/IcOOz4Ew/6EpiiBNU+R3EkAAvTWrYRVrm3RVMKK59yQpCiu43e1vTlrQ+1t7tW7uvS/xiwsQ8I9hJtFXC8xb9hKdHyqFE0YyTyGIAb4G8BHmAcVozWU6q3gEm5E/WblNNfSckPiMSztgYAjaQrC/hn9eYFe8rajJ5nTYSGAbmcf+iyewn+ZQYIygv8tosVKH3dL7CBgljMcbmKYdieIIv9eEX6sgr9kIsVuro05V7beMfMM7dR7CwmQiXD98/zw1ZONfLXfLY3LkQGfwNEyDYEtSRUH1ROodwVyxsyG9pgoJwlT3xqb29jwPc9Acv2b3+xlEDq3hSZloVIIOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(54906003)(110136005)(83380400001)(478600001)(2616005)(6486002)(71200400001)(6506007)(36756003)(186003)(26005)(6512007)(38100700002)(41300700001)(82960400001)(5660300002)(86362001)(8936002)(38070700005)(316002)(76116006)(66476007)(2906002)(66556008)(66946007)(66446008)(91956017)(64756008)(4326008)(8676002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c04xbXFWRDR6R1IySHFiZUlCeGFIWktGOGZZQWRKY0FhbldXZC9oS2VxMFRj?=
 =?utf-8?B?YmFvZXpNS09PMVY4cHQwRXEyM0JRakVoa2V3ZHY3MVBRYWpsb0lPL1VIYzEv?=
 =?utf-8?B?QVpQZ09STG1iTGxNMGUyQjRKdGxzUWpSSXR3RnplUUNFWStwMDdxUnRybS9o?=
 =?utf-8?B?K2YxcU9xZXdIZGxvUVl1Si96ajVlNFJIaFdFZ0tEVmR6UzdCQzY4NkdRN1g3?=
 =?utf-8?B?b21XNGYzZ3d2ZjMrTmh6MTZ4MnVENy9WQ2xsSU8xWFgranVNRjFzNjE4ZmNr?=
 =?utf-8?B?VTVVV1M4WEhxS01hZUpuVDJ0NENoNmZmZnZPSjVETHpuYllYWWY2YzV2b2hQ?=
 =?utf-8?B?a1dvUlpWUldWR3pZbWpkSDVXNGxpUFdTOVRPMktBSytlcmduRWJIVHB4QUZL?=
 =?utf-8?B?SnZwT2grM0RBNE1sVkhpd1dHalZGRkVFUjlHOE5RWUdxZVF6Y2pMTTg5bFZR?=
 =?utf-8?B?eC9jRGxHS2xnc3V6V0FVdk9LR0RESEFNZ1VUU3dWd0x2eDBlQitOQ3BMaHl6?=
 =?utf-8?B?TlhZV0RxcW55ZEJOUVloakVKcjFXZEY2L3U2bU1ldUxld2xqaE90VzRhWmJm?=
 =?utf-8?B?LzRHSitBanFpZGZMdXJKSmw3aEdWczQwM1c3SGt2L0E3aW9pU0l0SkU0eTlv?=
 =?utf-8?B?NXF5RlQ2bmJCcEhCczAwYWdkNmo5emhDTXZyNW1reXQrd1duR0pvQ1phL2Jh?=
 =?utf-8?B?dXlka1dKcmZUQm9qUXZPekVNbjduWndzRzQzK09zUWlWcmNuL2xtb0laZTQy?=
 =?utf-8?B?cUx3TWl0SHIzWXJHN3E3YjRaZUdGY25JY1BjRkJHd0QwRjZlOWIyVkRlYTBX?=
 =?utf-8?B?SURTTFZOeDhTd3l6R2hOU3dETE4wRDg1T05IcFFHOE4rU1htdHhPN1phUWRB?=
 =?utf-8?B?NFNZcEd1ZnkrT3l1TEJrMVBSWTBxNUliZHR4M1FCeWY1b2EzVEZMZ3FaRm1n?=
 =?utf-8?B?d1dVYWlZMVdBYkU2aDgxRWhEWWFrNXdMOXFNWi9YYkpRMkV5blBHMkZTbkkx?=
 =?utf-8?B?K2xaRW9JZFZSQ29FWTdxand5U0NTNUMvdzF3WFVsaVBlQTRsUVBtQ0pZVS8w?=
 =?utf-8?B?Z2FUOTN5dXFtZTFmSEVPbjA3UWJiSzhFN1VVeUZpeE5SaG5RSURab1JPOS9Z?=
 =?utf-8?B?NGExTnZGcHM3dlRFTjBCQ3dGTnJ1Wlp5OEx2ZFVBV29QZnFDQzZnTWpPcWpv?=
 =?utf-8?B?RitsdTdZS2JudEt6MWdxcEZvb1l0VnR4U1ROZVZMNmE4NStSZSsreUlVVG5k?=
 =?utf-8?B?MVNRY1lKYitHdHVGT2l2bHN3dllHUURDM0Q3SVNtRGVQZG9UdkIzK3NwVVJo?=
 =?utf-8?B?SHlyV0IvekNWZGt2TFN2bWR1N21rQnN2ZUdlVU9rNFFOcUkwR09PUW52d1Jz?=
 =?utf-8?B?K1FTbHVIZHppNUpxU1FPMHB5bUNBdmt1Sno1SC9pSytpWGhWQkNaZWtRSjEy?=
 =?utf-8?B?YWo1TlZGRkprRUdjNjQvTEIwckZ5a1lZNXNqNlFaaG9oS0FKRzZoVUFEMDRG?=
 =?utf-8?B?U3J1Ymx6UGsrUC94MXlueENOM054SGRYRHdNMHRUd1E3TjNTMlVFUHZsZHJm?=
 =?utf-8?B?Y0lNVkZvL2VPRGt2TDNhSE5mamZ1VkF2LzFMODJyR2xyc0JRTEpzNGo1cnps?=
 =?utf-8?B?RjBqZWFpckxIdnh0ZU0wWTlxNkppSkFWY0dsU3krTHI2blN5UGlqN1FROU9P?=
 =?utf-8?B?YVYraEpTSGw5RnFmSUV4NC82VWtaRm5CVGp4NzZqRGRwKzl0ZHFtQXFKSk9X?=
 =?utf-8?B?bng1MzRPOEpsVktYaVNzZzd6YVpodWtQKzN4c0w1aDZ5c0VIMFpSUzk4Q2VG?=
 =?utf-8?B?MWk3UEowVzdyUXgvS2ZvRmo3eXlwZVgrcFROUUFielB6dXdwcGtKSHdjRzY1?=
 =?utf-8?B?ajF6NnI2R1JKb1UxcXcyVERXRVJzZ2V4TXpkK0UvRkJRRjVveXllUlpZbUh4?=
 =?utf-8?B?KzZaUk9CcUN5UWtlc1BzVHoyR1FEL3k2aHpjRmpydk1QeDNOdWwwTmY3c3pL?=
 =?utf-8?B?dkdvY0NUMnB3QXZxYXNqdWFadTN3c043a2ZxT0xJT01GTFl2OUU3TVFnZUFC?=
 =?utf-8?B?YjNOYjRVeVFWeEFrZ2orajVaVURhRi8xdEw2UGhIdVlzbnpuRTZFUTdNbmh1?=
 =?utf-8?B?YjkrUVBIbEhqWUZnQlQ1bXJ2aW1oZnpIaTZUQ05waW10NzNYblEydFhIbUQv?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BF90D8CC21D4143AC47DF838C00BCBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de99321d-dc60-4cb2-6bd2-08db0f118f08
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 05:00:29.1455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qp7TqPcF0EB0NiygfNSap7rZ6myZM6wRdrNWeotN+YS1qQcZKHvxjqxqlA4o/OPdRRszq5IaR40w5rWApcnyIGPNVXsMUU0acyWbc7pGrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4686
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTAxLTEzIGF0IDEyOjI3IC0wNTAwLCBBbGV4YW5kZXIgTW90aW4gd3JvdGU6
Cj4gQ2xlYW4gdXAgdGhlIGNvZGUsIG1ha2luZyBpdCBtb3JlIHVuaWZvcm0gd2l0aCBvdGhlcnMg
YW5kCj4gYWxsb3dpbmcgbW9yZSBtZXRob2RzIHRvIGJlIGltcGxlbWVudGVkIGxhdGVyOgo+IMKg
LSByZW1vdmUgbm9uc2Vuc2UgTkROX01TRlRfQ01EX1NNQVJUIGRlZmluaXRpb24sIHJlcGxhY2lu
ZyBpdAo+IHdpdGggcmVhbCBjb21tYW5kcywgcHJpbWFyaXR5IE5ETl9NU0ZUX0NNRF9OSEVBTFRI
Owo+IMKgLSBhbGxvdyBzZW5kaW5nIGFyYml0cmFyeSBjb21tYW5kcyBhbmQgYWRkIHRoZWlyIGRl
c2NyaXB0aW9uczsKPiDCoC0gYWRkIGN1c3RvbSBjbWRfaXNfc3VwcG9ydGVkIG1ldGhvZCB0byBh
bGxvdyBtb25pdG9yIG1vZGUuCgpIaSBBbGV4YW5kZXIsCgpJIHRoaW5rIEkgaGFkIHNpbWlsYXIg
ZmVlZGJhY2sgZWFybGllciwgYnV0IHRoZXNlIHdvdWxkIGJlIHJldmlld2FibGUKbW9yZSBlYXNp
bHkgaWYgdGhlc2UgdGhyZWUgdW5yZWxhdGVkIHRoaW5ncyBhcmUgYnJva2VuIHVwIGludG8gdGhy
ZWUKc2VwYXJhdGUgcGF0Y2hlcy4KCkEgZmV3IG90aGVyIG1pbm9yIGNvbW1lbnRzIGJlbG93LgoK
PiAKPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgTW90aW4gPG1hdkBpeHN5c3RlbXMuY29tPgo+
IC0tLQo+IMKgbmRjdGwvbGliL21zZnQuYyB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLQo+IMKgbmRjdGwvbGliL21zZnQuaCB8IDEzICsrKystLS0t
LS0tCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDUwIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygt
KQo+IAo+IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvbXNmdC5jIGIvbmRjdGwvbGliL21zZnQuYwo+
IGluZGV4IDMxMTI3OTkuLmVmYzdmZTEgMTAwNjQ0Cj4gLS0tIGEvbmRjdGwvbGliL21zZnQuYwo+
ICsrKyBiL25kY3RsL2xpYi9tc2Z0LmMKPiBAQCAtMiw2ICsyLDcgQEAKPiDCoC8vIENvcHlyaWdo
dCAoQykgMjAxNi0yMDE3IERlbGwsIEluYy4KPiDCoC8vIENvcHlyaWdodCAoQykgMjAxNiBIZXds
ZXR0IFBhY2thcmQgRW50ZXJwcmlzZSBEZXZlbG9wbWVudCBMUAo+IMKgLy8gQ29weXJpZ2h0IChD
KSAyMDE2LTIwMjAsIEludGVsIENvcnBvcmF0aW9uLgo+ICsvKiBDb3B5cmlnaHQgKEMpIDIwMjIg
aVhzeXN0ZW1zLCBJbmMuICovCj4gwqAjaW5jbHVkZSA8c3RkbGliLmg+Cj4gwqAjaW5jbHVkZSA8
bGltaXRzLmg+Cj4gwqAjaW5jbHVkZSA8dXRpbC9sb2cuaD4KPiBAQCAtMTIsMTIgKzEzLDM5IEBA
Cj4gwqAjZGVmaW5lIENNRF9NU0ZUKF9jKSAoKF9jKS0+bXNmdCkKPiDCoCNkZWZpbmUgQ01EX01T
RlRfU01BUlQoX2MpIChDTURfTVNGVChfYyktPnUuc21hcnQuZGF0YSkKPiDCoAo+ICtzdGF0aWMg
Y29uc3QgY2hhciAqbXNmdF9jbWRfZGVzYyhpbnQgZm4pCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBz
dGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGRlc2NzW10gPSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoFtORE5fTVNGVF9DTURfQ0hFQUxUSF0gPSAiY3JpdGljYWxfaGVhbHRoIiwK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgW05ETl9NU0ZUX0NNRF9OSEVBTFRIXSA9
ICJudmRpbW1faGVhbHRoIiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgW05ETl9N
U0ZUX0NNRF9FSEVBTFRIXSA9ICJlc19oZWFsdGgiLAo+ICvCoMKgwqDCoMKgwqDCoH07Cj4gK8Kg
wqDCoMKgwqDCoMKgY29uc3QgY2hhciAqZGVzYzsKPiArCj4gK8KgwqDCoMKgwqDCoMKgaWYgKGZu
ID49IChpbnQpIEFSUkFZX1NJWkUoZGVzY3MpKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gInVua25vd24iOwo+ICvCoMKgwqDCoMKgwqDCoGRlc2MgPSBkZXNjc1tmbl07
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFkZXNjKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gInVua25vd24iOwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBkZXNjOwo+ICt9
Cj4gKwo+ICtzdGF0aWMgYm9vbCBtc2Z0X2NtZF9pc19zdXBwb3J0ZWQoc3RydWN0IG5kY3RsX2Rp
bW0gKmRpbW0sIGludCBjbWQpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqAvKiBIYW5kbGUgdGhpcyBz
ZXBhcmF0ZWx5IHRvIHN1cHBvcnQgbW9uaXRvciBtb2RlICovCj4gK8KgwqDCoMKgwqDCoMKgaWYg
KGNtZCA9PSBORF9DTURfU01BUlQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiB0cnVlOwo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gISEoZGltbS0+Y21kX21hc2sg
JiAoMVVMTCA8PCBjbWQpKTsKPiArfQo+ICsKPiDCoHN0YXRpYyB1MzIgbXNmdF9nZXRfZmlybXdh
cmVfc3RhdHVzKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIGNtZC0+bXNmdC0+dS5zbWFydC5zdGF0dXM7Cj4gwqB9Cj4gwqAKPiAtc3RhdGljIHN0
cnVjdCBuZGN0bF9jbWQgKm1zZnRfZGltbV9jbWRfbmV3X3NtYXJ0KHN0cnVjdCBuZGN0bF9kaW1t
ICpkaW1tKQo+ICtzdGF0aWMgc3RydWN0IG5kY3RsX2NtZCAqYWxsb2NfbXNmdF9jbWQoc3RydWN0
IG5kY3RsX2RpbW0gKmRpbW0sCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVuc2ln
bmVkIGludCBmdW5jLCBzaXplX3QgaW5fc2l6ZSwgc2l6ZV90IG91dF9zaXplKQo+IMKgewo+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbmRjdGxfYnVzICpidXMgPSBuZGN0bF9kaW1tX2dldF9idXMo
ZGltbSk7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBuZGN0bF9jdHggKmN0eCA9IG5kY3RsX2J1
c19nZXRfY3R4KGJ1cyk7Cj4gQEAgLTMwLDEyICs1OCwxMiBAQCBzdGF0aWMgc3RydWN0IG5kY3Rs
X2NtZCAqbXNmdF9kaW1tX2NtZF9uZXdfc21hcnQoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiDCoMKgwqDCoMKg
wqDCoMKgfQo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgaWYgKHRlc3RfZGltbV9kc20oZGltbSwgTkRO
X01TRlRfQ01EX1NNQVJUKSA9PSBESU1NX0RTTV9VTlNVUFBPUlRFRCkgewo+ICvCoMKgwqDCoMKg
wqDCoGlmICh0ZXN0X2RpbW1fZHNtKGRpbW0sIGZ1bmMpID09IERJTU1fRFNNX1VOU1VQUE9SVEVE
KSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkYmcoY3R4LCAidW5zdXBwb3J0
ZWQgZnVuY3Rpb25cbiIpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IE5VTEw7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHNpemUgPSBz
aXplb2YoKmNtZCkgKyBzaXplb2Yoc3RydWN0IG5kbl9wa2dfbXNmdCk7Cj4gK8KgwqDCoMKgwqDC
oMKgc2l6ZSA9IHNpemVvZigqY21kKSArIHNpemVvZihzdHJ1Y3QgbmRfY21kX3BrZykgKyBpbl9z
aXplICsgb3V0X3NpemU7Cj4gwqDCoMKgwqDCoMKgwqDCoGNtZCA9IGNhbGxvYygxLCBzaXplKTsK
PiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFjbWQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gTlVMTDsKPiBAQCAtNDUsMjUgKzczLDMwIEBAIHN0YXRpYyBzdHJ1Y3QgbmRj
dGxfY21kICptc2Z0X2RpbW1fY21kX25ld19zbWFydChzdHJ1Y3QgbmRjdGxfZGltbSAqZGltbSkK
PiDCoMKgwqDCoMKgwqDCoMKgY21kLT50eXBlID0gTkRfQ01EX0NBTEw7Cj4gwqDCoMKgwqDCoMKg
wqDCoGNtZC0+c2l6ZSA9IHNpemU7Cj4gwqDCoMKgwqDCoMKgwqDCoGNtZC0+c3RhdHVzID0gMTsK
PiArwqDCoMKgwqDCoMKgwqBjbWQtPmdldF9maXJtd2FyZV9zdGF0dXMgPSBtc2Z0X2dldF9maXJt
d2FyZV9zdGF0dXM7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgbXNmdCA9IENNRF9NU0ZUKGNtZCk7
Cj4gwqDCoMKgwqDCoMKgwqDCoG1zZnQtPmdlbi5uZF9mYW1pbHkgPSBOVkRJTU1fRkFNSUxZX01T
RlQ7Cj4gLcKgwqDCoMKgwqDCoMKgbXNmdC0+Z2VuLm5kX2NvbW1hbmQgPSBORE5fTVNGVF9DTURf
U01BUlQ7Cj4gK8KgwqDCoMKgwqDCoMKgbXNmdC0+Z2VuLm5kX2NvbW1hbmQgPSBmdW5jOwo+IMKg
wqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4ubmRfZndfc2l6ZSA9IDA7Cj4gLcKgwqDCoMKgwqDCoMKg
bXNmdC0+Z2VuLm5kX3NpemVfaW4gPSBvZmZzZXRvZihzdHJ1Y3QgbmRuX21zZnRfc21hcnQsIHN0
YXR1cyk7Cj4gLcKgwqDCoMKgwqDCoMKgbXNmdC0+Z2VuLm5kX3NpemVfb3V0ID0gc2l6ZW9mKG1z
ZnQtPnUuc21hcnQpOwo+ICvCoMKgwqDCoMKgwqDCoG1zZnQtPmdlbi5uZF9zaXplX2luID0gaW5f
c2l6ZTsKPiArwqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4ubmRfc2l6ZV9vdXQgPSBvdXRfc2l6ZTsK
PiDCoMKgwqDCoMKgwqDCoMKgbXNmdC0+dS5zbWFydC5zdGF0dXMgPSAwOwo+IC3CoMKgwqDCoMKg
wqDCoGNtZC0+Z2V0X2Zpcm13YXJlX3N0YXR1cyA9IG1zZnRfZ2V0X2Zpcm13YXJlX3N0YXR1czsK
Ck1vdmluZyB0aGlzIGxpbmUgdXAgc2VlbXMgdW5uZWNlc3Nhcnk/Cgo+IMKgCj4gwqDCoMKgwqDC
oMKgwqDCoHJldHVybiBjbWQ7Cj4gwqB9Cj4gwqAKPiArc3RhdGljIHN0cnVjdCBuZGN0bF9jbWQg
Km1zZnRfZGltbV9jbWRfbmV3X3NtYXJ0KHN0cnVjdCBuZGN0bF9kaW1tICpkaW1tKQo+ICt7Cj4g
K8KgwqDCoMKgwqDCoMKgcmV0dXJuIChhbGxvY19tc2Z0X2NtZChkaW1tLCBORE5fTVNGVF9DTURf
TkhFQUxUSCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oDAsIHNpemVvZihzdHJ1Y3QgbmRuX21zZnRfc21hcnQpKSk7CgpUaGUgb3V0ZXJtb3N0IHBhcmVu
dGhlc2lzIGhlcmUgYXJlIHVubmVjZXNzYXJ5IGFuZCB1bmNvbnZlbnRpb25hbCBmb3IKdGhlIGNv
ZGUgYmFzZS4KCkFsc28gc2l6ZW9mKCpmb29fcHRyKSBpcyBtb3JlIGNhbm9uaWNhbCB0aGFuIHNp
emVvZihzdHJ1Y3QgZm9vKS4KQ2hlY2twYXRjaCBzaG91bGQgd2FybiBhYm91dCB0aGlzLgoKPiAr
fQo+ICsKPiDCoHN0YXRpYyBpbnQgbXNmdF9zbWFydF92YWxpZChzdHJ1Y3QgbmRjdGxfY21kICpj
bWQpCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChjbWQtPnR5cGUgIT0gTkRfQ01EX0NBTEwg
fHwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqAgY21kLT5zaXplICE9IHNpemVvZigqY21kKSArIHNp
emVvZihzdHJ1Y3QgbmRuX3BrZ19tc2Z0KSB8fAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQ01E
X01TRlQoY21kKS0+Z2VuLm5kX2ZhbWlseSAhPSBOVkRJTU1fRkFNSUxZX01TRlQgfHwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqAgQ01EX01TRlQoY21kKS0+Z2VuLm5kX2NvbW1hbmQgIT0gTkROX01T
RlRfQ01EX1NNQVJUIHx8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIENNRF9NU0ZUKGNtZCktPmdl
bi5uZF9jb21tYW5kICE9IE5ETl9NU0ZUX0NNRF9OSEVBTFRIIHx8Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjbWQtPnN0YXR1cyAhPSAwKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGNtZC0+c3RhdHVzIDwgMCA/IGNtZC0+c3RhdHVzIDogLUVJTlZBTDsKPiDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gQEAgLTgwLDkgKzExMyw4IEBAIHN0YXRpYyB1bnNpZ25l
ZCBpbnQgbXNmdF9jbWRfc21hcnRfZ2V0X2ZsYWdzKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkKPiDC
oMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoC8qIGJlbG93IGhlYWx0aCBk
YXRhIGNhbiBiZSByZXRyaWV2ZWQgdmlhIE1TRlQgX0RTTSBmdW5jdGlvbiAxMSAqLwo+IC3CoMKg
wqDCoMKgwqDCoHJldHVybiBORE5fTVNGVF9TTUFSVF9IRUFMVEhfVkFMSUQgfAo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBORE5fTVNGVF9TTUFSVF9URU1QX1ZBTElEIHwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTkROX01TRlRfU01BUlRfVVNFRF9WQUxJRDsKPiAr
wqDCoMKgwqDCoMKgwqByZXR1cm4gTkRfU01BUlRfSEVBTFRIX1ZBTElEIHwgTkRfU01BUlRfVEVN
UF9WQUxJRCB8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIE5EX1NNQVJUX1VTRURfVkFMSUQ7Cj4g
wqB9Cj4gwqAKPiDCoHN0YXRpYyB1bnNpZ25lZCBpbnQgbnVtX3NldF9iaXRfaGVhbHRoKF9fdTE2
IG51bSkKPiBAQCAtMTcxLDYgKzIwMyw4IEBAIHN0YXRpYyBpbnQgbXNmdF9jbWRfeGxhdF9maXJt
d2FyZV9zdGF0dXMoc3RydWN0IG5kY3RsX2NtZCAqY21kKQo+IMKgfQo+IMKgCj4gwqBzdHJ1Y3Qg
bmRjdGxfZGltbV9vcHMgKiBjb25zdCBtc2Z0X2RpbW1fb3BzID0gJihzdHJ1Y3QgbmRjdGxfZGlt
bV9vcHMpIHsKPiArwqDCoMKgwqDCoMKgwqAuY21kX2Rlc2MgPSBtc2Z0X2NtZF9kZXNjLAo+ICvC
oMKgwqDCoMKgwqDCoC5jbWRfaXNfc3VwcG9ydGVkID0gbXNmdF9jbWRfaXNfc3VwcG9ydGVkLAo+
IMKgwqDCoMKgwqDCoMKgwqAubmV3X3NtYXJ0ID0gbXNmdF9kaW1tX2NtZF9uZXdfc21hcnQsCj4g
wqDCoMKgwqDCoMKgwqDCoC5zbWFydF9nZXRfZmxhZ3MgPSBtc2Z0X2NtZF9zbWFydF9nZXRfZmxh
Z3MsCj4gwqDCoMKgwqDCoMKgwqDCoC5zbWFydF9nZXRfaGVhbHRoID0gbXNmdF9jbWRfc21hcnRf
Z2V0X2hlYWx0aCwKPiBkaWZmIC0tZ2l0IGEvbmRjdGwvbGliL21zZnQuaCBiL25kY3RsL2xpYi9t
c2Z0LmgKPiBpbmRleCA5NzhjYzExLi44ZDI0NmE1IDEwMDY0NAo+IC0tLSBhL25kY3RsL2xpYi9t
c2Z0LmgKPiArKysgYi9uZGN0bC9saWIvbXNmdC5oCj4gQEAgLTIsMjEgKzIsMTYgQEAKPiDCoC8q
IENvcHlyaWdodCAoQykgMjAxNi0yMDE3IERlbGwsIEluYy4gKi8KPiDCoC8qIENvcHlyaWdodCAo
QykgMjAxNiBIZXdsZXR0IFBhY2thcmQgRW50ZXJwcmlzZSBEZXZlbG9wbWVudCBMUCAqLwo+IMKg
LyogQ29weXJpZ2h0IChDKSAyMDE0LTIwMjAsIEludGVsIENvcnBvcmF0aW9uLiAqLwo+ICsvKiBD
b3B5cmlnaHQgKEMpIDIwMjIgaVhzeXN0ZW1zLCBJbmMuICovCj4gwqAjaWZuZGVmIF9fTkRDVExf
TVNGVF9IX18KPiDCoCNkZWZpbmUgX19ORENUTF9NU0ZUX0hfXwo+IMKgCj4gwqBlbnVtIHsKPiAt
wqDCoMKgwqDCoMKgwqBORE5fTVNGVF9DTURfUVVFUlkgPSAwLAo+IC0KPiAtwqDCoMKgwqDCoMKg
wqAvKiBub24tcm9vdCBjb21tYW5kcyAqLwo+IC3CoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9T
TUFSVCA9IDExLAo+ICvCoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9DSEVBTFRIID0gMTAsCj4g
K8KgwqDCoMKgwqDCoMKgTkROX01TRlRfQ01EX05IRUFMVEggPSAxMSwKPiArwqDCoMKgwqDCoMKg
wqBORE5fTVNGVF9DTURfRUhFQUxUSCA9IDEyLAo+IMKgfTsKPiDCoAo+IC0vKiBORE5fTVNGVF9D
TURfU01BUlQgKi8KPiAtI2RlZmluZSBORE5fTVNGVF9TTUFSVF9IRUFMVEhfVkFMSUTCoMKgwqDC
oE5EX1NNQVJUX0hFQUxUSF9WQUxJRAo+IC0jZGVmaW5lIE5ETl9NU0ZUX1NNQVJUX1RFTVBfVkFM
SUTCoMKgwqDCoMKgwqBORF9TTUFSVF9URU1QX1ZBTElECj4gLSNkZWZpbmUgTkROX01TRlRfU01B
UlRfVVNFRF9WQUxJRMKgwqDCoMKgwqDCoE5EX1NNQVJUX1VTRURfVkFMSUQKPiAtCj4gwqAvKgo+
IMKgICogVGhpcyBpcyBhY3R1YWxseSBmdW5jdGlvbiAxMSBkYXRhLAo+IMKgICogVGhpcyBpcyB0
aGUgY2xvc2VzdCBJIGNhbiBmaW5kIHRvIG1hdGNoIHNtYXJ0Cgo=

