Return-Path: <nvdimm+bounces-5760-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C1E569111E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Feb 2023 20:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 218C5280C17
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Feb 2023 19:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD21A933;
	Thu,  9 Feb 2023 19:18:22 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DD62F29
	for <nvdimm@lists.linux.dev>; Thu,  9 Feb 2023 19:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675970300; x=1707506300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8erhFvrZ3oVJW3s5Qo6QkYWeXA1a1dyamOcKYBS1pRY=;
  b=YENm06P8RsyG0Frp1qVaoauvPx5XFad6H7XXWWLe9rIsQMfK45WKqcDd
   BzjpBgWD407f4kzf+2j4y30ltqjUOMpoF6LgpiQypd1R2tQ7oQCB1c+eD
   MxfLY0FMSuk/w+JVA6QQ/yo47HNmCyUc5HOoS1Pp5UyN2R960RqhQqHA+
   MWtH7gk4zBgHfKmvsrKKVI0bWmnegjlY6RXPyeTg3e+h5NgmXp23ID7ae
   6WOLPgOms902H+Pz9r38AvdC9+FsiVFCEuGvpfhVCexBfVZm7+yzKbbgq
   2+2awhemdZNzafUINc5z7cUZ3MF+UWCiejrcb624+Kjs2pFtG5QWzu2WQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394817662"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="394817662"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 11:17:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="791707327"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="791707327"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 09 Feb 2023 11:17:55 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 11:17:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 11:17:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 11:17:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 11:17:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCvg0vHaqh56X1wcL5Yl0RE1qri9uJv0/p74BGSYyzmyTJM60P/JbTcnfGe9i6kSp7UNLbWBxA+H51WSRHEckBuD9w4OYpfanCxy2YLszq0gAl/3lMVAep5zxH33/sK+nC21rqs42Xepy4ewAWPIBeIdatquFKNRGepnENkzw0HDnzTYvPIxy7ZNyBb4N9C9LGbB5B2Ouj7T2fGbytsIAdP3JKaSX/x1+2de/UFHBa0QP29mJeH+MkwiKPPTIyH8KdrogKqPu+WhCW8ilBu3EyNkj7jud0YYjyVclwcSdJznFXMHvzktAxfpbj+r1P0pNooaUP89/Qwzo1PNH7pdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8erhFvrZ3oVJW3s5Qo6QkYWeXA1a1dyamOcKYBS1pRY=;
 b=cTTPWU8244vvsDki7/ujcTITrW19cV2lKIUKT6AIiiZ757O08fQsYWJbkuuRA5/QxM5Rrk4KobYez6aicCh+Wq8CYmGbBZvXlo83JBR1nLPghtLtvR3tMB22cM2Fqtf3BNPsI/6syi2Exizs705JCq/no8KwFTLUr5u3HfuDl41IawmtKQA5FGrUCiISLKIEuK4Tg/ebizsAkk8T12mz4CGfTBemaKBn2UtbXJqXzum3wdpU4TwvE39iNkRDQXoxVg0sRw6ZdeU06icG1WmjhKUIItY8Oi8kRj17NQ7bwIFlY97M7KgzFdYOlTWmD/Ojeq2Xgduq3jlt6F2GFxpB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH7PR11MB7429.namprd11.prod.outlook.com (2603:10b6:510:270::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 19:17:52 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 19:17:52 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Brice.Goglin@inria.fr" <Brice.Goglin@inria.fr>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "Jonathan.Cameron@Huawei.com"
	<Jonathan.Cameron@Huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Thread-Topic: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Thread-Index: AQHZO/gbBJC7CY/oZUetvSQPmVeN9a7GdLSAgACJwgA=
Date: Thu, 9 Feb 2023 19:17:52 +0000
Message-ID: <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
	 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
In-Reply-To: <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH7PR11MB7429:EE_
x-ms-office365-filtering-correlation-id: d10ea2b4-7b16-4273-17dd-08db0ad25716
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVJ2/oyB3OaMH/csMisZErnhJteCQZ0FSk9sbts2gJ7bH2h+K1B7doLh5M8GhDlIXIAQVFBcVdhH0Z/T1WckQCh/HM6iyk+ki82zBOPk4LBAGUosu4IBF/+XLA+xT+FXCR7pEBP9QfX/SLg+wEU22fOHcTj182VMnieaFYQaGAVzOxDFmO1+rSgPcL4LLzugnpkzZcRmDYsRIrP3VsKaMSZycgcCpXZkM4E8hghkbmV28+1UAZI7jQSsxPBEHH4RBa9B6SGdq+xXfK2MBwYF8tCsUTHey15WCHZKd3cuQ2gb//pDy/hq4WxZ5yKnQPotXLNUx5rgixPJ316WtM0h9pLh6qF35pSw8wyghY8zcI3+6e+HUEnly22JkRM65qZR8OrkKFBx38jaELtG03ji8u6ZHOuQJ70fH8lHTl9KemE6aVKPmKALIFZxNknixCjcIEH11YX7P8rZsZwzPnTihYeQFAe6jEQXbPpqe0lxHv/bifPMV9JhQlGP/7JZDbICc2Q7MbjiueB9ZMZGR6KAi+FaOry8KfvqddiInwHrIvpO+PAyEW6ZkRr4YZGmAPYMyTdoMa0QlAY+tmmOdl8a/34G369H7wEaG9NZOlgS59wBXo9IEIDow55mxnjhh9E10v55tFvcgotNlcrPFdqfAU9YUSmODgIdQH50zm6MlYGIzAL/3OQZ2FzoHMBXNkFrC/36L+UYRCJE0HxIiX+q6DFzoHM0//tuMiAx0HmX99ChetJ2fcj5/Byp1qxonnp25TwN1Q7hiRH/odbRIVYwlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199018)(6506007)(316002)(8936002)(107886003)(6512007)(26005)(186003)(478600001)(38070700005)(2906002)(71200400001)(83380400001)(54906003)(110136005)(5660300002)(36756003)(6486002)(966005)(66476007)(66446008)(64756008)(66946007)(91956017)(76116006)(66556008)(84970400001)(41300700001)(86362001)(8676002)(66574015)(4326008)(38100700002)(82960400001)(2616005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnZsWDFGQWtPa3VyZng3bVdOUjRUSjd3Z1drK1pqNncvTzVBMHBwelc4VFpn?=
 =?utf-8?B?dVplem5zWHppSVhHaS9jZ0l1RVdXVUNwWGd4UHR5a2JMZ2JwdW9ZZ09rYy9t?=
 =?utf-8?B?eWRvZW0vNGR4dlBkZnR2UkNYRFJMZDYxcUw1SUtISnlvNHJkbnZNMnNMUVlV?=
 =?utf-8?B?Q3FlRjBNTDRwZDNEemdjOE14bE9LalNiamlPbjdNVlBpWGFGcTYrUW1lVFNE?=
 =?utf-8?B?MHZIcFZMdkM5T2tLODdMMXFtbHBNbEw1elRDdXlsWDh6Nlp5VWpNSXhDTTlM?=
 =?utf-8?B?N1pmVy8yZ0hUUlByWU1yU2FNTkxwUkoyRTA1Y0pmeWt1dEc0WE51dzE0ZGZy?=
 =?utf-8?B?UXhHcGszMzFsaHpEYmdtRDBGU01ncnNDZUk3Y1QvSnVPOVFTRjZQUnpXQkFJ?=
 =?utf-8?B?M0RTaTNJMll1U1ltM2IzNU1EbmdNWGRwOWx2WE5YTDdQa21FRWVLYWJMODBG?=
 =?utf-8?B?OUkyZWhFVjU2bzZ0Q212ZG9XekZUVlNTTURnUXhMSkJxZit3VjJMbDF4ZDRy?=
 =?utf-8?B?V0duNTRQWm9ONkFwNjhmY0FnbHZLcHdKRG9SVTU5YkpFQXNiaUNQR295Y2Za?=
 =?utf-8?B?SlkyNG9iRUZ4WDV2aGt6bTFrbGt2Wk1MRjFrOFdKenh6NnVhak9ZNFdJTGVZ?=
 =?utf-8?B?SDNPUExNTCttRjUwV01ndklpT0dNbmNvQVNiOWlGZ0YrVkZrWGU2R0Q5bVdJ?=
 =?utf-8?B?aDhNUGdvU2VJaUhndW5ubmVlWUZieDVJK0ltQUYzekw5TkpNN21JU3pVYjY5?=
 =?utf-8?B?VCttK2ZsM0FhQmpEbjAyOTZNZjJTU2g5aVJXYjVZUjRKS09pOHVaOTlJMnVQ?=
 =?utf-8?B?M0EraERKVjZ6SGdpdWJjeFEzTTJnaXBqYzhDVkVEUUlPbjNtTUxQODJWQlNU?=
 =?utf-8?B?QkE0WkkxcUk5ZnQ0SDVrcjVjMHJwV2EwaWlrazR5cXFIYVE4WkdIdWxHaXJr?=
 =?utf-8?B?eVZ6cjdVMUpZbGxDdlFSU2RMTmtpS0pjM3ZZRlRKTUVzNndGUGhkWFNtbHNq?=
 =?utf-8?B?YkVhQWlBL0haeW1XVExnbVp6dnJvWXFOUGNySyt4aGJ1Z2hTMDJhcnVOWkJv?=
 =?utf-8?B?NVFmbWxETFdCRG9JcmFCNlJSanJsOTFyZCtQZkhmaTRjekxxbkxpRFFNSXlu?=
 =?utf-8?B?ckRzQXJxdUE0TUNZUm94UldXSjUwNmZHYlRNWVBQd28yMXltOUtraG9vZE0r?=
 =?utf-8?B?S3ZlMGtVNWtTVnNTLzdLNjlFODdwcDBaSHZmdms1SHV3N2tQL2NCNDZzVTE3?=
 =?utf-8?B?d1hNUE5icmtGMU1PNDByeFQzOG9pUlFaS0hvMFR2SlBpVDNrZnNReXF2OUc0?=
 =?utf-8?B?UnFvb21DY3NyR29mYjhwUnNTMHV4MXpmb3Zyc1ZPTDBvL3gxcjBRcURVdnp0?=
 =?utf-8?B?cTEwUVhLMFk2T0xscTdjME1Vc0RJVWdxU2pIWVFXOE03TGhqZEVwR3NqUDkw?=
 =?utf-8?B?WHY0aDV1RGRiMENLU1EveVg4Mlhtc0VPTG9lZmkvNTJVSHcrOFhuOStDcld2?=
 =?utf-8?B?b0FzRmJMQkVKaFpIYVBhMHk3eGZIdHV3elR6d1hXZHdFcmZTK3BkT3NMcGhw?=
 =?utf-8?B?cjRzaGkzVEhEVXV1b2crZE8waGlPc09XMDZ5cmhacnhZeDZLTWR5MHZIaTlB?=
 =?utf-8?B?NnpTWjBURldkNDY4Z2U4MnRoYWNUL2N5R0IybGJMMW1CYnRSMSs1aFBncjFk?=
 =?utf-8?B?Y1dHY0lxY20vakpwMVZWQzB0TzI2aXZhK3hvQzBxVDlLYzduVnlOUDJERUIv?=
 =?utf-8?B?cFhuc3NhbmY2dzl2bWZwZytobTBFWTdrVGkreVEyME9iV1VwYXkxTitFQ2Mw?=
 =?utf-8?B?eEo2cDlwUGNoM0pEVlRPbXUxSXRsSmJuOWUyZnVNRFN6M0hxSy8rSlJlYmFQ?=
 =?utf-8?B?ZVo0ZS9BSUhreHlHUGM0Q3VYcWp0aG54SHF1WkI5dC9xd3MxYk03S21NRzBH?=
 =?utf-8?B?elNZMnRhbjVjTkY1cUJzVzhYdVVwNVhKTHBPWkVmRTRMcnVTc3dYdUdkUUJ0?=
 =?utf-8?B?SHc0aldVejVNaDg5cHYxK2tVTXpsbGxBdUg4MEF1UWUyVjMyN2Zkejg1eHVt?=
 =?utf-8?B?d2s5S2VheHVsUDJ5QmpoMGpnUjNWaVpUNnM1MkxXd2pUc3FBdlE4UFFPalZp?=
 =?utf-8?B?WDM0Tm9UZlpHMjNNc3pOWHRDSXI2eG1yVVY5UWxTakwvQWxOdTZKaEMyK28w?=
 =?utf-8?B?anc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEF974DCE0F41A4ABA3CC6AC0F8C5CC5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10ea2b4-7b16-4273-17dd-08db0ad25716
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 19:17:52.3376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cIUXlCfUO6FcNYDtzppbx19300trnNU2YvxvnpewaluDn1NHsXwgvvWKK53ksnGtjjKvVqZoVBwdEqXwCKhw0c/h8G/9DjDV3Jf6JIT2G00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7429
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTAyLTA5IGF0IDEyOjA0ICswMTAwLCBCcmljZSBHb2dsaW4gd3JvdGU6DQo+
IA0KPiBMZSAwOC8wMi8yMDIzIMOgIDIxOjAwLCBWaXNoYWwgVmVybWEgYSDDqWNyaXTCoDoNCj4g
PiBXaGlsZSBlbnVtZXJhdGlvbiBvZiByYW0gdHlwZSByZWdpb25zIGFscmVhZHkgd29ya3MgaW4g
bGliY3hsIGFuZA0KPiA+IGN4bC1jbGksIGl0IGxhY2tlZCBhbiBhdHRyaWJ1dGUgdG8gaW5kaWNh
dGUgcG1lbSB2cy4gcmFtLiBBZGQgYSBuZXcNCj4gPiAndHlwZScgYXR0cmlidXRlIHRvIHJlZ2lv
biBsaXN0aW5ncyB0byBhZGRyZXNzIHRoaXMuIEFkZGl0aW9uYWxseSwgYWRkDQo+ID4gc3VwcG9y
dCBmb3IgY3JlYXRpbmcgcmFtIHJlZ2lvbnMgdG8gdGhlIGN4bC1jcmVhdGUtcmVnaW9uIGNvbW1h
bmQuIFRoZQ0KPiA+IHJlZ2lvbiBsaXN0aW5ncyBhcmUgYWxzbyB1cGRhdGVkIHdpdGggZGF4LXJl
Z2lvbiBpbmZvcm1hdGlvbiBmb3INCj4gPiB2b2xhdGlsZSByZWdpb25zLg0KPiA+IA0KPiA+IFRo
aXMgYWxzbyBpbmNsdWRlcyBmaXhlZCBmb3IgYSBmZXcgYnVncyAvIHVzYWJpbGl0eSBpc3N1ZXMg
aWRlbnRpZmllZA0KPiA+IGFsb25nIHRoZSB3YXkgLSBwYXRjaGVzIDEsIDQsIGFuZCA2LiBQYXRj
aCA1IGlzIGEgdXNhYmlsaXR5IGltcHJvdmVtZW50DQo+ID4gd2hlcmUgYmFzZWQgb24gZGVjb2Rl
ciBjYXBhYmlsaXRpZXMsIHRoZSB0eXBlIG9mIGEgcmVnaW9uIGNhbiBiZQ0KPiA+IGluZmVycmVk
IGZvciB0aGUgY3JlYXRlLXJlZ2lvbiBjb21tYW5kLg0KPiA+IA0KPiA+IFRoZXNlIGhhdmUgYmVl
biB0ZXN0ZWQgYWdhaW5zdCB0aGUgcmFtLXJlZ2lvbiBhZGRpdGlvbnMgdG8gY3hsX3Rlc3QNCj4g
PiB3aGljaCBhcmUgcGFydCBvZiB0aGUga2VybmVsIHN1cHBvcnQgcGF0Y2ggc2V0WzFdLg0KPiA+
IEFkZGl0aW9uYWxseSwgdGVzdGVkIGFnYWluc3QgcWVtdSB1c2luZyBhIFdJUCBicmFuY2ggZm9y
IHZvbGF0aWxlDQo+ID4gc3VwcG9ydCBmb3VuZCBoZXJlWzJdLiBUaGUgJ3J1bl9xZW11JyBzY3Jp
cHQgaGFzIGEgYnJhbmNoIHRoYXQgY3JlYXRlcw0KPiA+IHZvbGF0aWxlIG1lbWRldnMgaW4gYWRk
aXRpb24gdG8gcG1lbSBvbmVzLiBUaGlzIGlzIGFsc28gaW4gYSBicmFuY2hbM10NCj4gPiBzaW5j
ZSBpdCBkZXBlbmRzIG9uIFsyXS4NCj4gPiANCj4gPiBUaGVzZSBjeGwtY2xpIC8gbGliY3hsIHBh
dGNoZXMgdGhlbXNlbHZlcyBhcmUgYWxzbyBhdmFpbGFibGUgaW4gYQ0KPiA+IGJyYW5jaCBhdCBb
NF0uDQo+ID4gDQo+ID4gWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jeGwvMTY3
NTY0NTM0ODc0Ljg0NzE0Ni41MjIyNDE5NjQ4NTUxNDM2NzUwLnN0Z2l0QGR3aWxsaWEyLXhmaC5q
Zi5pbnRlbC5jb20vDQo+ID4gWzJdOiBodHRwczovL2dpdGxhYi5jb20vamljMjMvcWVtdS8tL2Nv
bW1pdHMvY3hsLTIwMjMtMDEtMjYNCj4gPiBbM106IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL3J1
bl9xZW11L2NvbW1pdHMvdnYvcmFtLW1lbWRldnMNCj4gPiBbNF06IGh0dHBzOi8vZ2l0aHViLmNv
bS9wbWVtL25kY3RsL3RyZWUvdnYvdm9sYXRpbGUtcmVnaW9ucw0KPiANCj4gDQo+IEhlbGxvIFZp
c2hhbA0KPiANCj4gSSBhbSB0cnlpbmcgdG8gcGxheSB3aXRoIHRoaXMgYnV0IGFsbCBteSBhdHRl
bXB0cyBmYWlsZWQgc28gZmFyLiBDb3VsZCANCj4geW91IHByb3ZpZGUgUWVtdSBhbmQgY3hsLWNs
aSBjb21tYW5kLWxpbmVzIHRvIGdldCBhIHZvbGF0aWxlIHJlZ2lvbiANCj4gZW5hYmxlZCBpbiBh
IFFlbXUgVk0/DQoNCkhpIEJyaWNlLA0KDQpHcmVnIGhhZCBwb3N0ZWQgaGlzIHdvcmtpbmcgY29u
ZmlnIGluIGFub3RoZXIgdGhyZWFkOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hs
L1k5c01zMEZHdWxRU0llOXRAbWVtdmVyZ2UuY29tLw0KDQpJJ3ZlIGFsc28gcGFzdGVkIGJlbG93
LCB0aGUgcWVtdSBjb21tYW5kIGxpbmUgZ2VuZXJhdGVkIGJ5IHRoZSBydW5fcWVtdQ0Kc2NyaXB0
IEkgcmVmZXJlbmNlZC4gKE5vdGUgdGhhdCB0aGlzIGFkZHMgYSBidW5jaCBvZiBzdHVmZiBub3Qg
c3RyaWN0bHkNCm5lZWRlZCBmb3IgYSBtaW5pbWFsIENYTCBjb25maWd1cmF0aW9uIC0geW91IGNh
biBjZXJ0YWlubHkgdHJpbSBhIGxvdA0Kb2YgdGhhdCBvdXQgLSB0aGlzIGlzIGp1c3QgdGhlIGRl
ZmF1bHQgc2V0dXAgdGhhdCBpcyBnZW5lcmF0ZWQgYW5kIEkNCnVzdWFsbHkgcnVuKS4NCg0KRmVl
bCBmcmVlIHRvIHBvc3Qgd2hhdCBlcnJvcnMgLyBwcm9ibGVtcyB5b3UncmUgaGl0dGluZyBhbmQg
d2UgY2FuDQpkZWJ1ZyBmdXJ0aGVyIGZyb20gdGhlcmUuDQoNClRoYW5rcw0KVmlzaGFsDQoNCg0K
JCBydW5fcWVtdS5zaCAtZyAtLWN4bCAtLWN4bC1kZWJ1ZyAtLXJ3IC1yIG5vbmUgLS1jbWRsaW5l
DQovaG9tZS92dmVybWE3L2dpdC9xZW11L2J1aWxkL3FlbXUtc3lzdGVtLXg4Nl82NCANCi1tYWNo
aW5lIHEzNSxhY2NlbD1rdm0sbnZkaW1tPW9uLGN4bD1vbiANCi1tIDgxOTJNLHNsb3RzPTQsbWF4
bWVtPTQwOTY0TSANCi1zbXAgOCxzb2NrZXRzPTIsY29yZXM9Mix0aHJlYWRzPTIgDQotZW5hYmxl
LWt2bSANCi1kaXNwbGF5IG5vbmUgDQotbm9ncmFwaGljIA0KLWRyaXZlIGlmPXBmbGFzaCxmb3Jt
YXQ9cmF3LHVuaXQ9MCxmaWxlPU9WTUZfQ09ERS5mZCxyZWFkb25seT1vbiANCi1kcml2ZSBpZj1w
Zmxhc2gsZm9ybWF0PXJhdyx1bml0PTEsZmlsZT1PVk1GX1ZBUlMuZmQgDQotZGVidWdjb24gZmls
ZTp1ZWZpX2RlYnVnLmxvZyANCi1nbG9iYWwgaXNhLWRlYnVnY29uLmlvYmFzZT0weDQwMiANCi1k
cml2ZSBmaWxlPXJvb3QuaW1nLGZvcm1hdD1yYXcsbWVkaWE9ZGlzayANCi1rZXJuZWwgLi9ta29z
aS5leHRyYS9saWIvbW9kdWxlcy82LjIuMC1yYzYrL3ZtbGludXogDQotaW5pdHJkIG1rb3NpLmV4
dHJhL2Jvb3QvaW5pdHJhbWZzLTYuMi4wLXJjMisuaW1nIA0KLWFwcGVuZCBzZWxpbnV4PTAgYXVk
aXQ9MCBjb25zb2xlPXR0eTAgY29uc29sZT10dHlTMCByb290PS9kZXYvc2RhMiBpZ25vcmVfbG9n
bGV2ZWwgcncgY3hsX2FjcGkuZHluZGJnPStmcGxtIGN4bF9wY2kuZHluZGJnPStmcGxtIGN4bF9j
b3JlLmR5bmRiZz0rZnBsbSBjeGxfbWVtLmR5bmRiZz0rZnBsbSBjeGxfcG1lbS5keW5kYmc9K2Zw
bG0gY3hsX3BvcnQuZHluZGJnPStmcGxtIGN4bF9yZWdpb24uZHluZGJnPStmcGxtIGN4bF90ZXN0
LmR5bmRiZz0rZnBsbSBjeGxfbW9jay5keW5kYmc9K2ZwbG0gY3hsX21vY2tfbWVtLmR5bmRiZz0r
ZnBsbSBtZW1tYXA9MkchNEcgZWZpX2Zha2VfbWVtPTJHQDZHOjB4NDAwMDAgDQotZGV2aWNlIGUx
MDAwLG5ldGRldj1uZXQwLG1hYz01Mjo1NDowMDoxMjozNDo1NiANCi1uZXRkZXYgdXNlcixpZD1u
ZXQwLGhvc3Rmd2Q9dGNwOjoxMDAyMi06MjIgDQotb2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZpbGUs
aWQ9Y3hsLW1lbTAsc2hhcmU9b24sbWVtLXBhdGg9Y3hsdGVzdDAucmF3LHNpemU9MjU2TSANCi1v
YmplY3QgbWVtb3J5LWJhY2tlbmQtZmlsZSxpZD1jeGwtbWVtMSxzaGFyZT1vbixtZW0tcGF0aD1j
eGx0ZXN0MS5yYXcsc2l6ZT0yNTZNIA0KLW9iamVjdCBtZW1vcnktYmFja2VuZC1maWxlLGlkPWN4
bC1tZW0yLHNoYXJlPW9uLG1lbS1wYXRoPWN4bHRlc3QyLnJhdyxzaXplPTI1Nk0gDQotb2JqZWN0
IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9Y3hsLW1lbTMsc2hhcmU9b24sbWVtLXBhdGg9Y3hsdGVz
dDMucmF3LHNpemU9MjU2TSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPWN4bC1tZW00
LHNoYXJlPW9uLHNpemU9MjU2TSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPWN4bC1t
ZW01LHNoYXJlPW9uLHNpemU9MjU2TSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPWN4
bC1tZW02LHNoYXJlPW9uLHNpemU9MjU2TSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlk
PWN4bC1tZW03LHNoYXJlPW9uLHNpemU9MjU2TSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtZmls
ZSxpZD1jeGwtbHNhMCxzaGFyZT1vbixtZW0tcGF0aD1sc2EwLnJhdyxzaXplPTFLIA0KLW9iamVj
dCBtZW1vcnktYmFja2VuZC1maWxlLGlkPWN4bC1sc2ExLHNoYXJlPW9uLG1lbS1wYXRoPWxzYTEu
cmF3LHNpemU9MUsgDQotb2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9Y3hsLWxzYTIsc2hh
cmU9b24sbWVtLXBhdGg9bHNhMi5yYXcsc2l6ZT0xSyANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQt
ZmlsZSxpZD1jeGwtbHNhMyxzaGFyZT1vbixtZW0tcGF0aD1sc2EzLnJhdyxzaXplPTFLIA0KLWRl
dmljZSBweGItY3hsLGlkPWN4bC4wLGJ1cz1wY2llLjAsYnVzX25yPTUzIA0KLWRldmljZSBweGIt
Y3hsLGlkPWN4bC4xLGJ1cz1wY2llLjAsYnVzX25yPTE5MSANCi1kZXZpY2UgY3hsLXJwLGlkPWhi
MHJwMCxidXM9Y3hsLjAsY2hhc3Npcz0wLHNsb3Q9MCxwb3J0PTAgDQotZGV2aWNlIGN4bC1ycCxp
ZD1oYjBycDEsYnVzPWN4bC4wLGNoYXNzaXM9MCxzbG90PTEscG9ydD0xIA0KLWRldmljZSBjeGwt
cnAsaWQ9aGIwcnAyLGJ1cz1jeGwuMCxjaGFzc2lzPTAsc2xvdD0yLHBvcnQ9MiANCi1kZXZpY2Ug
Y3hsLXJwLGlkPWhiMHJwMyxidXM9Y3hsLjAsY2hhc3Npcz0wLHNsb3Q9Myxwb3J0PTMgDQotZGV2
aWNlIGN4bC1ycCxpZD1oYjFycDAsYnVzPWN4bC4xLGNoYXNzaXM9MCxzbG90PTQscG9ydD0wIA0K
LWRldmljZSBjeGwtcnAsaWQ9aGIxcnAxLGJ1cz1jeGwuMSxjaGFzc2lzPTAsc2xvdD01LHBvcnQ9
MSANCi1kZXZpY2UgY3hsLXJwLGlkPWhiMXJwMixidXM9Y3hsLjEsY2hhc3Npcz0wLHNsb3Q9Nixw
b3J0PTIgDQotZGV2aWNlIGN4bC1ycCxpZD1oYjFycDMsYnVzPWN4bC4xLGNoYXNzaXM9MCxzbG90
PTcscG9ydD0zIA0KLWRldmljZSBjeGwtdHlwZTMsYnVzPWhiMHJwMCxtZW1kZXY9Y3hsLW1lbTAs
aWQ9Y3hsLWRldjAsbHNhPWN4bC1sc2EwIA0KLWRldmljZSBjeGwtdHlwZTMsYnVzPWhiMHJwMSxt
ZW1kZXY9Y3hsLW1lbTEsaWQ9Y3hsLWRldjEsbHNhPWN4bC1sc2ExIA0KLWRldmljZSBjeGwtdHlw
ZTMsYnVzPWhiMXJwMCxtZW1kZXY9Y3hsLW1lbTIsaWQ9Y3hsLWRldjIsbHNhPWN4bC1sc2EyIA0K
LWRldmljZSBjeGwtdHlwZTMsYnVzPWhiMXJwMSxtZW1kZXY9Y3hsLW1lbTMsaWQ9Y3hsLWRldjMs
bHNhPWN4bC1sc2EzIA0KLWRldmljZSBjeGwtdHlwZTMsYnVzPWhiMHJwMix2b2xhdGlsZS1tZW1k
ZXY9Y3hsLW1lbTQsaWQ9Y3hsLWRldjQgDQotZGV2aWNlIGN4bC10eXBlMyxidXM9aGIwcnAzLHZv
bGF0aWxlLW1lbWRldj1jeGwtbWVtNSxpZD1jeGwtZGV2NSANCi1kZXZpY2UgY3hsLXR5cGUzLGJ1
cz1oYjFycDIsdm9sYXRpbGUtbWVtZGV2PWN4bC1tZW02LGlkPWN4bC1kZXY2IA0KLWRldmljZSBj
eGwtdHlwZTMsYnVzPWhiMXJwMyx2b2xhdGlsZS1tZW1kZXY9Y3hsLW1lbTcsaWQ9Y3hsLWRldjcg
DQotTSBjeGwtZm13LjAudGFyZ2V0cy4wPWN4bC4wLGN4bC1mbXcuMC5zaXplPTRHLGN4bC1mbXcu
MC5pbnRlcmxlYXZlLWdyYW51bGFyaXR5PThrLGN4bC1mbXcuMS50YXJnZXRzLjA9Y3hsLjAsY3hs
LWZtdy4xLnRhcmdldHMuMT1jeGwuMSxjeGwtZm13LjEuc2l6ZT00RyxjeGwtZm13LjEuaW50ZXJs
ZWF2ZS1ncmFudWxhcml0eT04ayANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPW1lbTAs
c2l6ZT0yMDQ4TSANCi1udW1hIG5vZGUsbm9kZWlkPTAsbWVtZGV2PW1lbTAsIA0KLW51bWEgY3B1
LG5vZGUtaWQ9MCxzb2NrZXQtaWQ9MCANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPW1l
bTEsc2l6ZT0yMDQ4TSANCi1udW1hIG5vZGUsbm9kZWlkPTEsbWVtZGV2PW1lbTEsIA0KLW51bWEg
Y3B1LG5vZGUtaWQ9MSxzb2NrZXQtaWQ9MSANCi1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlk
PW1lbTIsc2l6ZT0yMDQ4TSANCi1udW1hIG5vZGUsbm9kZWlkPTIsbWVtZGV2PW1lbTIsIA0KLW9i
amVjdCBtZW1vcnktYmFja2VuZC1yYW0saWQ9bWVtMyxzaXplPTIwNDhNIA0KLW51bWEgbm9kZSxu
b2RlaWQ9MyxtZW1kZXY9bWVtMywgDQotbnVtYSBub2RlLG5vZGVpZD00LCANCi1vYmplY3QgbWVt
b3J5LWJhY2tlbmQtZmlsZSxpZD1udm1lbTAsc2hhcmU9b24sbWVtLXBhdGg9bnZkaW1tLTAsc2l6
ZT0xNjM4NE0sYWxpZ249MUcgDQotZGV2aWNlIG52ZGltbSxtZW1kZXY9bnZtZW0wLGlkPW52MCxs
YWJlbC1zaXplPTJNLG5vZGU9NCANCi1udW1hIG5vZGUsbm9kZWlkPTUsIA0KLW9iamVjdCBtZW1v
cnktYmFja2VuZC1maWxlLGlkPW52bWVtMSxzaGFyZT1vbixtZW0tcGF0aD1udmRpbW0tMSxzaXpl
PTE2Mzg0TSxhbGlnbj0xRyANCi1kZXZpY2UgbnZkaW1tLG1lbWRldj1udm1lbTEsaWQ9bnYxLGxh
YmVsLXNpemU9Mk0sbm9kZT01IA0KLW51bWEgZGlzdCxzcmM9MCxkc3Q9MCx2YWw9MTAgDQotbnVt
YSBkaXN0LHNyYz0wLGRzdD0xLHZhbD0yMSANCi1udW1hIGRpc3Qsc3JjPTAsZHN0PTIsdmFsPTEy
IA0KLW51bWEgZGlzdCxzcmM9MCxkc3Q9Myx2YWw9MjEgDQotbnVtYSBkaXN0LHNyYz0wLGRzdD00
LHZhbD0xNyANCi1udW1hIGRpc3Qsc3JjPTAsZHN0PTUsdmFsPTI4IA0KLW51bWEgZGlzdCxzcmM9
MSxkc3Q9MSx2YWw9MTAgDQotbnVtYSBkaXN0LHNyYz0xLGRzdD0yLHZhbD0yMSANCi1udW1hIGRp
c3Qsc3JjPTEsZHN0PTMsdmFsPTEyIA0KLW51bWEgZGlzdCxzcmM9MSxkc3Q9NCx2YWw9MjggDQot
bnVtYSBkaXN0LHNyYz0xLGRzdD01LHZhbD0xNyANCi1udW1hIGRpc3Qsc3JjPTIsZHN0PTIsdmFs
PTEwIA0KLW51bWEgZGlzdCxzcmM9Mixkc3Q9Myx2YWw9MjEgDQotbnVtYSBkaXN0LHNyYz0yLGRz
dD00LHZhbD0yOCANCi1udW1hIGRpc3Qsc3JjPTIsZHN0PTUsdmFsPTI4IA0KLW51bWEgZGlzdCxz
cmM9Myxkc3Q9Myx2YWw9MTAgDQotbnVtYSBkaXN0LHNyYz0zLGRzdD00LHZhbD0yOCANCi1udW1h
IGRpc3Qsc3JjPTMsZHN0PTUsdmFsPTI4IA0KLW51bWEgZGlzdCxzcmM9NCxkc3Q9NCx2YWw9MTAg
DQotbnVtYSBkaXN0LHNyYz00LGRzdD01LHZhbD0yOCANCi1udW1hIGRpc3Qsc3JjPTUsZHN0PTUs
dmFsPTEwIA0KDQo=

