Return-Path: <nvdimm+bounces-5538-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BD764C12D
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Dec 2022 01:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96ED01C20955
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Dec 2022 00:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8788219E;
	Wed, 14 Dec 2022 00:33:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF897F
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977998; x=1702513998;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=lITBPHy7Jymez71xCurVlWU8JGptlNSFP3RIgLeZaVI=;
  b=UP3Vp8c5H3NT9SMOz/9IIXBFY9nOwIPesiT/lWb89+ohASjRNMksMKp1
   oxCRSitkX8D+vUGIB1jP+l2b3z/M/3k3jqsSed19A/ircVB2BqNocte7X
   LmGIH4kbAGyobC83imh4jbSm3VseEfk7yk9dJZudNfzyzL4URAGfjGRtc
   OXWueeUwYwlJr/Zdd62/VVlTIaz61butwsHoVJmS6GzdLCyw/Gq4p4uTF
   iQXsckwcRQ5iI/6W1xCL1kb8mGDmVRy8P6QReriP038Vh5BaibjB7cZkA
   TPdlg5DBQ6XReSNPYZFm6JMiYMITkaIBiQ8bbxsLmPTEsrekvfaaQkDoz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316976610"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="316976610"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823085839"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823085839"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 13 Dec 2022 16:33:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 16:33:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 16:33:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 16:33:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 16:33:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUExJCeUwdIUpEGw6prSuAoocG8Yg99EzxHLpPaOtrRjPSeAlGAOpBimKWyDO8jD3ALUFs55jPc6JIt0oxm+m3ckq3R/zJzb05J5SV9131AlHigN8hcUaaKDX1u6HC5A8SpFKGA9NV69te9fABz3MryyBRxDris+dQuDJPXPg5cMmBy/PLzPc/XJt+42H1dO3Zyl1XqwJtFGew7HhNDGHVf1O2o+M9sObP/8LYjTcNA0UfiwT0R3m9V0lqIxcCQJmdoW5Ypnc2zvQxrgYktNenkKV/eC2RTl3ym3AI2V7v8M2EbO/BiVvpJ2lWOR/UNdYBVKpKLcBmM6sRBYEDU+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lITBPHy7Jymez71xCurVlWU8JGptlNSFP3RIgLeZaVI=;
 b=lI5FyqcGjcULdSe7L7BQd10fZ2MY/nJguVXLNJI/jJD6NIffd5GvMQjky8XLd7/D1Up8EIb2tMpWqEbLOOIb1NcqEAVIHngR1sdmB/lNqGPEiPbgJxRKGj5Xj/XZWlRFNQ6VOtHqTL6NKid0OlrXjl17TcVzFO7GGoOA1dxDNV15L+B4dmK1YQorZKYEn+aQs4llDhuDOxy69Ynt+lmDoVeX2pTCgyFF5Tur0VRkhfGR61danKjnnZCE4YYaCwWFwnjuaRCNdo0iN9B2FLp4EBz9oecaYJvC4ZZs04WhWOV/Ipbu4xMUVcAx2OYS+BJkBFHqk7n39bI64UrkyQGyJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA1PR11MB6847.namprd11.prod.outlook.com (2603:10b6:806:29e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 00:33:01 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 00:33:01 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "motin, alexander" <mav@ixsystems.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/2 v2] libndctl/msft: Cleanup the code
Thread-Topic: [ndctl PATCH 1/2 v2] libndctl/msft: Cleanup the code
Thread-Index: AQHY+tVkk6Xs1MtOwEahljgBKFyr265ssY8A
Date: Wed, 14 Dec 2022 00:33:01 +0000
Message-ID: <4a1be8d5db0cd8ad36bb43a55d2e3dc1825d3af1.camel@intel.com>
References: <20221117223749.6783-1-mav@ixsystems.com>
In-Reply-To: <20221117223749.6783-1-mav@ixsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SA1PR11MB6847:EE_
x-ms-office365-filtering-correlation-id: 8dcfd7ef-e938-4e99-5f2f-08dadd6ac198
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kThLgH/QnUkiq1KPa8ki8JP/45fXDdMKm2lYAPz1ntdi9iywKBcmHGCb0g8epoAKI0PGqt3GLUMgNqLkWkngMA5kaskcJeTFdVzl6BXpQLwkrl5G0pIv28it+CvAia7IAbxaZKiYeNe/WqL0wL+gxD9N4SO1P+xZjHXiCyT7QP9otqmgZ+QGE9H/JY/BToek9ga8MdwGoe08f/w+Ql1LjfryGeNbGC9Pr1OwwPT2mP17VLBh4ZJyazT6/bodkxtyxLEIm6LPMA7/7eWHa0jXjBW0Njjsv0rQDJs642clCav8VfGnF1s2qSpc/cvK4zBszw37GmWaUUotiRfCmnMKyDXEKSusg6eP8AA40brvnZ0kJ8vuf6NLayOBwkn01T79bO+bO0L1VKueQVe+wOJuMWlRP6EqdzxA7eQ9DBurEi2feWEqmZcgtawcGZprt8BiU69KAAjOSZi3QQXh76metd2OYfmttJQRA+zk7bxol8ttTIbRzMa/7BDwJonGEyQWxPD/Ocld4fW8kbItukstM88C1psW5GKtzlM+vY63o5EqwEul+Abrx2N0IcNKV+hd8Czb0O5L6K1XLpWasTnIJMIm/lywnllg5if8OfJx2uJpfIY+WFvnLl5Xwcb6N1O9PDS2IYlv0059FQHM1VQe/0LU89iWjFlseWKXXtNG7zdosCbYfEdjg7n4tQf0s8EH6GOAkxZ+10YFbXJ7CVmPvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(8676002)(64756008)(91956017)(66446008)(66476007)(76116006)(66946007)(66556008)(5660300002)(26005)(41300700001)(36756003)(186003)(6486002)(478600001)(71200400001)(6506007)(6512007)(86362001)(110136005)(316002)(83380400001)(2616005)(82960400001)(8936002)(38100700002)(4001150100001)(122000001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVBONjI5ZmxXNk9iMStNQ25NZTM3dTdKRDFuWGtnWWprUTJDcUlxVXpQZCt2?=
 =?utf-8?B?SlJ2R2hMU0ljbXJrV0ZQUWk5aUZ6c2pIYlRqSXJWcHdmV0I3NTVIV2VzQjZY?=
 =?utf-8?B?UE9Cb1pVa3Z2UWNRSG9nMERrY214VTAxWXVLRmh0VWZrRHd5MWhyWEhQaDFu?=
 =?utf-8?B?TU1YSmxFRWhkbmE1MTFrK3Brd0NSTmdLdzNudkNJamlRNk55cWVkUzBrbWVU?=
 =?utf-8?B?T0NSajgwek1RcnQ1NzJ0VzloZSt0a3JsR3FmQ0lmNjBSRllVeDloSXc1V3Bh?=
 =?utf-8?B?RkMvQjh5d2dudnZDaDVqQ1kzcUQ5K0p6Wnk3eGl0ZlQyODhHR0t4bnNDS0px?=
 =?utf-8?B?WmFOMEl3b1VuZVhzakRLNFgxTTBBaWd1MGthbDNzeFJSZnlJMzdDQy9ZUndl?=
 =?utf-8?B?Z3JvMUs5SVArUURMRzZTY3E0VG1VNVJnKytjbWI0QllXeGs0N1Z4cU94ME94?=
 =?utf-8?B?S08reEpWbk9CZmV0OVBuOHk3Y1c0cDFzTXRZdU00c2pNeUJ1Nmw4dnk3L0xR?=
 =?utf-8?B?RkQ1clF6eEtaRVN6QzB3U3E0RXhBc2JxM01ZSkJDQ2ZLWDlkSkpXcnlUL2li?=
 =?utf-8?B?R1J6aGRuTG80MXIvWHZCRlBucXNLejgzT0FvRHlRSlBNM3pvU0tpNEpTakxE?=
 =?utf-8?B?NHlLenpPU2R2ZWpUeS9vOU10cmtoVXBrOGVyRTFOQXFTeHRNSXFEVThmQzh1?=
 =?utf-8?B?N2R5SFZTZElXMEFIOUVJUGNEQm43a2l2SXZybHFNNlN6cWZ1NkZWaTJ1UmNy?=
 =?utf-8?B?eDBjbmszVWJNV3FBWndQWWsyeEJnV1pUNmRHUXlVSE9UdGlnVVNRL0hFRnFZ?=
 =?utf-8?B?dlB1OGQyLzJHMEVmVGdWTm55bUVteDZpVnVUdHM0NHRBWW0zUStsckd6dWhv?=
 =?utf-8?B?NmdqYk1zYmlvd0RSeWMydG5zbm9pQTdtaUVkMTVaOXI0aGh3b3VTUzUrSnph?=
 =?utf-8?B?Uk5sYWR1eU9LY0dEU0xFL1ovY0s5MU9uUXBteG8zWUo3MjJMSFpVeGpQdVd3?=
 =?utf-8?B?K2tZYjExMDZxMUFTaG1wQmpLb2VaMi9aWVlZVHVoYzQrSTVCNWU4TWcrZzQw?=
 =?utf-8?B?Ynpac0dPWjBZYlBzMjRnbVpEd3RUVTZrQUpZdzJ6dnkxalBFWHNTWllJeHhL?=
 =?utf-8?B?THlPRzZoZXAwcEt2Nm41N24wZWw1YUpFb2luUG15NVI0LzlXWHdHcE1EMmhv?=
 =?utf-8?B?dHAyQ25MOVhCeU82YUEzRDdXM3hXTmQ3ejdiUzVtZ0V6cE1QVDBDYkFZOWdU?=
 =?utf-8?B?cjNJSzFuKzhhdTYyRXZEUHlTcE42T20rZ3pCN0R4QXBvSFZUalZiRy84SUUz?=
 =?utf-8?B?d2JiNVBKY2kwVmg2ejZtSldKSWFhdlIxRlFydHFFaGZCd3BBV3BGRDVYM1Vn?=
 =?utf-8?B?MkNQdVc4djUyM0xHVmplTlB2VzJaNTQzeCtNakk1TERkeHlXcTA4S3B4emJY?=
 =?utf-8?B?TG12SVVRWUYrOG1KRjVrMkw4cDFZTnJtN2FSbWFrNlhtRnorZlB3emVuKzVz?=
 =?utf-8?B?QUcxbnZvTEk3azFGZjZZWTBVN1JmMkZGTDZPQnlpUWdkYmtXdktEb1dXcXlu?=
 =?utf-8?B?QksxSWYzQ1czRTNrcldZZlhsNDVxVXRhckVXcE02V1NyZmdGWERsQUFxY3g4?=
 =?utf-8?B?Ly9PK3ErYnNZTkxkYkZqQUVTRGUwQjBUelJWR0MyRnY2QkVHVW5XZHdGZGo3?=
 =?utf-8?B?dWMwLy92NG5VNmxGMTVUOE5BSStMWE9yVk9wUVMxT3EwdkNmbk1zOFdqUElp?=
 =?utf-8?B?UzdXQnF5YnZrYXlsRGkzMFpZUXpRNzVSZmVYV3YvNjlnOVZKY0Q1QzExQ2VW?=
 =?utf-8?B?YlFzcE5CK3M3VGs1T0dja3dWRVRMU0dyOTM4SUZsdk5pR3QxMWJRb3NpOFdj?=
 =?utf-8?B?Nit0dGVISWZsbkFjU2dDQVlQZTlyT1VvTlNRWk1rbHhkRXRxdkx1VFgvYXEr?=
 =?utf-8?B?Y29raUR6MGphcmZTUlUxcVZaZFJqNkI4WFdWNFkyNEF0UDFaNi9hWGJqOHVT?=
 =?utf-8?B?NVZVcllmeVBzZXcyTlFCaUxtMnhrdXk2TlFFNUt4Rzh5MTdlWUVYcXZHUDVt?=
 =?utf-8?B?Z0lVWjNtVlVuWkFUMDVQT05aTWRmTE9Gelg3K0dVVk5sUkNuV2ppTDlOVXZT?=
 =?utf-8?B?Z2loKzlxTVBxWXFCSjNqNFh5QjFnYjBqU3B2NmtkbmNkcjR5Y244aExxYXdh?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82FBC357F15C584181D557668A7667F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcfd7ef-e938-4e99-5f2f-08dadd6ac198
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 00:33:01.0450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5MISXZWhc4A15QreSV/8yjEyanjha6tvZJ9b2S26J4lKXZLu7jSOOLYdTPgfw4YhDb+zceyxuLMGnoMut41cTmDH5Lz+MhI20XRHQZEf/O4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6847
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTExLTE3IGF0IDE3OjM3IC0wNTAwLCBBbGV4YW5kZXIgTW90aW4gd3JvdGU6
Cj4gQ2xlYW4gdXAgdGhlIGNvZGUsIG1ha2luZyBpdCBtb3JlIHVuaWZvcm0gd2l0aCBvdGhlcnMg
YW5kCj4gYWxsb3dpbmcgbW9yZSBtZXRob2RzIHRvIGJlIGltcGxlbWVudGVkIGxhdGVyLgoKSGkg
QWxleGFuZGVyLAoKSSB0aGluayB0aGlzIHdvdWxkIGJlIGVhc2llciB0byByZXZpZXcgaWYgdGhl
IHRoZSBjbGVhbnVwcyB3ZXJlCnN1bW1hcml6ZWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIC0gYW5k
IGlmIHRoZXJlIGFyZSBkaWZmZXJlbnQgdHlwZXMgb2YKY2xlYW51cHMsIHRoZW4gcG9zc2libHkg
YnJlYWsgdGhlbSBkb3duIGludG8gYSBkaWZmZXJlbnQgcGF0Y2ggcGVyIHR5cGUuCgpJJ2QgYWxz
byBjb25zaWRlciBDQydpbmcgdGhlIG9yaWdpbmFsIGF1dGhvcnMgb2YgdGhpcyBmaWxlIGZvciBz
b21lIEFja3MKYW5kIHJldmlld3MuCgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBNb3Rp
biA8bWF2QGl4c3lzdGVtcy5jb20+Cj4gLS0tCj4gwqBuZGN0bC9saWIvbXNmdC5jIHwgNTggKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tCj4gwqBuZGN0bC9s
aWIvbXNmdC5oIHwgMTMgKysrKy0tLS0tLS0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgNTAgaW5zZXJ0
aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9tc2Z0
LmMgYi9uZGN0bC9saWIvbXNmdC5jCj4gaW5kZXggMzExMjc5OS4uZWZjN2ZlMSAxMDA2NDQKPiAt
LS0gYS9uZGN0bC9saWIvbXNmdC5jCj4gKysrIGIvbmRjdGwvbGliL21zZnQuYwo+IEBAIC0yLDYg
KzIsNyBAQAo+IMKgLy8gQ29weXJpZ2h0IChDKSAyMDE2LTIwMTcgRGVsbCwgSW5jLgo+IMKgLy8g
Q29weXJpZ2h0IChDKSAyMDE2IEhld2xldHQgUGFja2FyZCBFbnRlcnByaXNlIERldmVsb3BtZW50
IExQCj4gwqAvLyBDb3B5cmlnaHQgKEMpIDIwMTYtMjAyMCwgSW50ZWwgQ29ycG9yYXRpb24uCj4g
Ky8qIENvcHlyaWdodCAoQykgMjAyMiBpWHN5c3RlbXMsIEluYy4gKi8KPiDCoCNpbmNsdWRlIDxz
dGRsaWIuaD4KPiDCoCNpbmNsdWRlIDxsaW1pdHMuaD4KPiDCoCNpbmNsdWRlIDx1dGlsL2xvZy5o
Pgo+IEBAIC0xMiwxMiArMTMsMzkgQEAKPiDCoCNkZWZpbmUgQ01EX01TRlQoX2MpICgoX2MpLT5t
c2Z0KQo+IMKgI2RlZmluZSBDTURfTVNGVF9TTUFSVChfYykgKENNRF9NU0ZUKF9jKS0+dS5zbWFy
dC5kYXRhKQo+IMKgCj4gK3N0YXRpYyBjb25zdCBjaGFyICptc2Z0X2NtZF9kZXNjKGludCBmbikK
PiArewo+ICvCoMKgwqDCoMKgwqDCoHN0YXRpYyBjb25zdCBjaGFyICogY29uc3QgZGVzY3NbXSA9
IHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgW05ETl9NU0ZUX0NNRF9DSEVBTFRI
XSA9ICJjcml0aWNhbF9oZWFsdGgiLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBb
TkROX01TRlRfQ01EX05IRUFMVEhdID0gIm52ZGltbV9oZWFsdGgiLAo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBbTkROX01TRlRfQ01EX0VIRUFMVEhdID0gImVzX2hlYWx0aCIsCj4g
K8KgwqDCoMKgwqDCoMKgfTsKPiArwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpkZXNjOwo+ICsK
PiArwqDCoMKgwqDCoMKgwqBpZiAoZm4gPj0gKGludCkgQVJSQVlfU0laRShkZXNjcykpCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAidW5rbm93biI7Cj4gK8KgwqDCoMKg
wqDCoMKgZGVzYyA9IGRlc2NzW2ZuXTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoIWRlc2MpCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAidW5rbm93biI7Cj4gK8KgwqDCoMKg
wqDCoMKgcmV0dXJuIGRlc2M7Cj4gK30KPiArCj4gK3N0YXRpYyBib29sIG1zZnRfY21kX2lzX3N1
cHBvcnRlZChzdHJ1Y3QgbmRjdGxfZGltbSAqZGltbSwgaW50IGNtZCkKPiArewo+ICvCoMKgwqDC
oMKgwqDCoC8qIEhhbmRsZSB0aGlzIHNlcGFyYXRlbHkgdG8gc3VwcG9ydCBtb25pdG9yIG1vZGUg
Ki8KPiArwqDCoMKgwqDCoMKgwqBpZiAoY21kID09IE5EX0NNRF9TTUFSVCkKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHRydWU7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJl
dHVybiAhIShkaW1tLT5jbWRfbWFzayAmICgxVUxMIDw8IGNtZCkpOwo+ICt9Cj4gKwo+IMKgc3Rh
dGljIHUzMiBtc2Z0X2dldF9maXJtd2FyZV9zdGF0dXMoc3RydWN0IG5kY3RsX2NtZCAqY21kKQo+
IMKgewo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gY21kLT5tc2Z0LT51LnNtYXJ0LnN0YXR1czsK
PiDCoH0KPiDCoAo+IC1zdGF0aWMgc3RydWN0IG5kY3RsX2NtZCAqbXNmdF9kaW1tX2NtZF9uZXdf
c21hcnQoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pCj4gK3N0YXRpYyBzdHJ1Y3QgbmRjdGxfY21k
ICphbGxvY19tc2Z0X2NtZChzdHJ1Y3QgbmRjdGxfZGltbSAqZGltbSwKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50IGZ1bmMsIHNpemVfdCBpbl9zaXplLCBzaXpl
X3Qgb3V0X3NpemUpCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBuZGN0bF9idXMgKmJ1
cyA9IG5kY3RsX2RpbW1fZ2V0X2J1cyhkaW1tKTsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IG5k
Y3RsX2N0eCAqY3R4ID0gbmRjdGxfYnVzX2dldF9jdHgoYnVzKTsKPiBAQCAtMzAsMTIgKzU4LDEy
IEBAIHN0YXRpYyBzdHJ1Y3QgbmRjdGxfY21kICptc2Z0X2RpbW1fY21kX25ld19zbWFydChzdHJ1
Y3QgbmRjdGxfZGltbSAqZGltbSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiBOVUxMOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBpZiAo
dGVzdF9kaW1tX2RzbShkaW1tLCBORE5fTVNGVF9DTURfU01BUlQpID09IERJTU1fRFNNX1VOU1VQ
UE9SVEVEKSB7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHRlc3RfZGltbV9kc20oZGltbSwgZnVuYykg
PT0gRElNTV9EU01fVU5TVVBQT1JURUQpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGRiZyhjdHgsICJ1bnN1cHBvcnRlZCBmdW5jdGlvblxuIik7Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4g
LcKgwqDCoMKgwqDCoMKgc2l6ZSA9IHNpemVvZigqY21kKSArIHNpemVvZihzdHJ1Y3QgbmRuX3Br
Z19tc2Z0KTsKPiArwqDCoMKgwqDCoMKgwqBzaXplID0gc2l6ZW9mKCpjbWQpICsgc2l6ZW9mKHN0
cnVjdCBuZF9jbWRfcGtnKSArIGluX3NpemUgKyBvdXRfc2l6ZTsKPiDCoMKgwqDCoMKgwqDCoMKg
Y21kID0gY2FsbG9jKDEsIHNpemUpOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIWNtZCkKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBOVUxMOwo+IEBAIC00NSwyNSArNzMs
MzAgQEAgc3RhdGljIHN0cnVjdCBuZGN0bF9jbWQgKm1zZnRfZGltbV9jbWRfbmV3X3NtYXJ0KHN0
cnVjdCBuZGN0bF9kaW1tICpkaW1tKQo+IMKgwqDCoMKgwqDCoMKgwqBjbWQtPnR5cGUgPSBORF9D
TURfQ0FMTDsKPiDCoMKgwqDCoMKgwqDCoMKgY21kLT5zaXplID0gc2l6ZTsKPiDCoMKgwqDCoMKg
wqDCoMKgY21kLT5zdGF0dXMgPSAxOwo+ICvCoMKgwqDCoMKgwqDCoGNtZC0+Z2V0X2Zpcm13YXJl
X3N0YXR1cyA9IG1zZnRfZ2V0X2Zpcm13YXJlX3N0YXR1czsKPiDCoAo+IMKgwqDCoMKgwqDCoMKg
wqBtc2Z0ID0gQ01EX01TRlQoY21kKTsKPiDCoMKgwqDCoMKgwqDCoMKgbXNmdC0+Z2VuLm5kX2Zh
bWlseSA9IE5WRElNTV9GQU1JTFlfTVNGVDsKPiAtwqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4ubmRf
Y29tbWFuZCA9IE5ETl9NU0ZUX0NNRF9TTUFSVDsKPiArwqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4u
bmRfY29tbWFuZCA9IGZ1bmM7Cj4gwqDCoMKgwqDCoMKgwqDCoG1zZnQtPmdlbi5uZF9md19zaXpl
ID0gMDsKPiAtwqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4ubmRfc2l6ZV9pbiA9IG9mZnNldG9mKHN0
cnVjdCBuZG5fbXNmdF9zbWFydCwgc3RhdHVzKTsKPiAtwqDCoMKgwqDCoMKgwqBtc2Z0LT5nZW4u
bmRfc2l6ZV9vdXQgPSBzaXplb2YobXNmdC0+dS5zbWFydCk7Cj4gK8KgwqDCoMKgwqDCoMKgbXNm
dC0+Z2VuLm5kX3NpemVfaW4gPSBpbl9zaXplOwo+ICvCoMKgwqDCoMKgwqDCoG1zZnQtPmdlbi5u
ZF9zaXplX291dCA9IG91dF9zaXplOwo+IMKgwqDCoMKgwqDCoMKgwqBtc2Z0LT51LnNtYXJ0LnN0
YXR1cyA9IDA7Cj4gLcKgwqDCoMKgwqDCoMKgY21kLT5nZXRfZmlybXdhcmVfc3RhdHVzID0gbXNm
dF9nZXRfZmlybXdhcmVfc3RhdHVzOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBjbWQ7
Cj4gwqB9Cj4gwqAKPiArc3RhdGljIHN0cnVjdCBuZGN0bF9jbWQgKm1zZnRfZGltbV9jbWRfbmV3
X3NtYXJ0KHN0cnVjdCBuZGN0bF9kaW1tICpkaW1tKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0
dXJuIChhbGxvY19tc2Z0X2NtZChkaW1tLCBORE5fTVNGVF9DTURfTkhFQUxUSCwKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDAsIHNpemVvZihzdHJ1Y3Qg
bmRuX21zZnRfc21hcnQpKSk7Cj4gK30KPiArCj4gwqBzdGF0aWMgaW50IG1zZnRfc21hcnRfdmFs
aWQoc3RydWN0IG5kY3RsX2NtZCAqY21kKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoY21k
LT50eXBlICE9IE5EX0NNRF9DQUxMIHx8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgIGNtZC0+c2l6
ZSAhPSBzaXplb2YoKmNtZCkgKyBzaXplb2Yoc3RydWN0IG5kbl9wa2dfbXNmdCkgfHwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIENNRF9NU0ZUKGNtZCktPmdlbi5uZF9mYW1pbHkgIT0gTlZESU1N
X0ZBTUlMWV9NU0ZUIHx8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgIENNRF9NU0ZUKGNtZCktPmdl
bi5uZF9jb21tYW5kICE9IE5ETl9NU0ZUX0NNRF9TTUFSVCB8fAo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoCBDTURfTVNGVChjbWQpLT5nZW4ubmRfY29tbWFuZCAhPSBORE5fTVNGVF9DTURfTkhFQUxU
SCB8fAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY21kLT5zdGF0dXMgIT0gMCkKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBjbWQtPnN0YXR1cyA8IDAgPyBjbWQtPnN0
YXR1cyA6IC1FSU5WQUw7Cj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+IEBAIC04MCw5ICsx
MTMsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IG1zZnRfY21kX3NtYXJ0X2dldF9mbGFncyhzdHJ1
Y3QgbmRjdGxfY21kICpjbWQpCj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDC
oMKgwqAvKiBiZWxvdyBoZWFsdGggZGF0YSBjYW4gYmUgcmV0cmlldmVkIHZpYSBNU0ZUIF9EU00g
ZnVuY3Rpb24gMTEgKi8KPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4gTkROX01TRlRfU01BUlRfSEVB
TFRIX1ZBTElEIHwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTkROX01TRlRfU01B
UlRfVEVNUF9WQUxJRCB8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoE5ETl9NU0ZU
X1NNQVJUX1VTRURfVkFMSUQ7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIE5EX1NNQVJUX0hFQUxU
SF9WQUxJRCB8IE5EX1NNQVJUX1RFTVBfVkFMSUQgfAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBO
RF9TTUFSVF9VU0VEX1ZBTElEOwo+IMKgfQo+IMKgCj4gwqBzdGF0aWMgdW5zaWduZWQgaW50IG51
bV9zZXRfYml0X2hlYWx0aChfX3UxNiBudW0pCj4gQEAgLTE3MSw2ICsyMDMsOCBAQCBzdGF0aWMg
aW50IG1zZnRfY21kX3hsYXRfZmlybXdhcmVfc3RhdHVzKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkK
PiDCoH0KPiDCoAo+IMKgc3RydWN0IG5kY3RsX2RpbW1fb3BzICogY29uc3QgbXNmdF9kaW1tX29w
cyA9ICYoc3RydWN0IG5kY3RsX2RpbW1fb3BzKSB7Cj4gK8KgwqDCoMKgwqDCoMKgLmNtZF9kZXNj
ID0gbXNmdF9jbWRfZGVzYywKPiArwqDCoMKgwqDCoMKgwqAuY21kX2lzX3N1cHBvcnRlZCA9IG1z
ZnRfY21kX2lzX3N1cHBvcnRlZCwKPiDCoMKgwqDCoMKgwqDCoMKgLm5ld19zbWFydCA9IG1zZnRf
ZGltbV9jbWRfbmV3X3NtYXJ0LAo+IMKgwqDCoMKgwqDCoMKgwqAuc21hcnRfZ2V0X2ZsYWdzID0g
bXNmdF9jbWRfc21hcnRfZ2V0X2ZsYWdzLAo+IMKgwqDCoMKgwqDCoMKgwqAuc21hcnRfZ2V0X2hl
YWx0aCA9IG1zZnRfY21kX3NtYXJ0X2dldF9oZWFsdGgsCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xp
Yi9tc2Z0LmggYi9uZGN0bC9saWIvbXNmdC5oCj4gaW5kZXggOTc4Y2MxMS4uOGQyNDZhNSAxMDA2
NDQKPiAtLS0gYS9uZGN0bC9saWIvbXNmdC5oCj4gKysrIGIvbmRjdGwvbGliL21zZnQuaAo+IEBA
IC0yLDIxICsyLDE2IEBACj4gwqAvKiBDb3B5cmlnaHQgKEMpIDIwMTYtMjAxNyBEZWxsLCBJbmMu
ICovCj4gwqAvKiBDb3B5cmlnaHQgKEMpIDIwMTYgSGV3bGV0dCBQYWNrYXJkIEVudGVycHJpc2Ug
RGV2ZWxvcG1lbnQgTFAgKi8KPiDCoC8qIENvcHlyaWdodCAoQykgMjAxNC0yMDIwLCBJbnRlbCBD
b3Jwb3JhdGlvbi4gKi8KPiArLyogQ29weXJpZ2h0IChDKSAyMDIyIGlYc3lzdGVtcywgSW5jLiAq
Lwo+IMKgI2lmbmRlZiBfX05EQ1RMX01TRlRfSF9fCj4gwqAjZGVmaW5lIF9fTkRDVExfTVNGVF9I
X18KPiDCoAo+IMKgZW51bSB7Cj4gLcKgwqDCoMKgwqDCoMKgTkROX01TRlRfQ01EX1FVRVJZID0g
MCwKPiAtCj4gLcKgwqDCoMKgwqDCoMKgLyogbm9uLXJvb3QgY29tbWFuZHMgKi8KPiAtwqDCoMKg
wqDCoMKgwqBORE5fTVNGVF9DTURfU01BUlQgPSAxMSwKPiArwqDCoMKgwqDCoMKgwqBORE5fTVNG
VF9DTURfQ0hFQUxUSCA9IDEwLAo+ICvCoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9OSEVBTFRI
ID0gMTEsCj4gK8KgwqDCoMKgwqDCoMKgTkROX01TRlRfQ01EX0VIRUFMVEggPSAxMiwKPiDCoH07
Cj4gwqAKPiAtLyogTkROX01TRlRfQ01EX1NNQVJUICovCj4gLSNkZWZpbmUgTkROX01TRlRfU01B
UlRfSEVBTFRIX1ZBTElEwqDCoMKgwqBORF9TTUFSVF9IRUFMVEhfVkFMSUQKPiAtI2RlZmluZSBO
RE5fTVNGVF9TTUFSVF9URU1QX1ZBTElEwqDCoMKgwqDCoMKgTkRfU01BUlRfVEVNUF9WQUxJRAo+
IC0jZGVmaW5lIE5ETl9NU0ZUX1NNQVJUX1VTRURfVkFMSUTCoMKgwqDCoMKgwqBORF9TTUFSVF9V
U0VEX1ZBTElECj4gLQo+IMKgLyoKPiDCoCAqIFRoaXMgaXMgYWN0dWFsbHkgZnVuY3Rpb24gMTEg
ZGF0YSwKPiDCoCAqIFRoaXMgaXMgdGhlIGNsb3Nlc3QgSSBjYW4gZmluZCB0byBtYXRjaCBzbWFy
dAoK

