Return-Path: <nvdimm+bounces-1947-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2E044EEEB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Nov 2021 22:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id A8B2D3E10A0
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Nov 2021 21:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5592C86;
	Fri, 12 Nov 2021 21:54:12 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A068
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 21:54:10 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10166"; a="233458781"
X-IronPort-AV: E=Sophos;i="5.87,230,1631602800"; 
   d="scan'208";a="233458781"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 13:54:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,230,1631602800"; 
   d="scan'208";a="547118609"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 12 Nov 2021 13:54:05 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 12 Nov 2021 13:54:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 12 Nov 2021 13:54:05 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 12 Nov 2021 13:54:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koLL4J0P5UQrhUj6watJ53ZfUWDJOAmI2o2JTOfwURkWSnZ2M9a480/C5RkWQnCY8NFUzGKtG95xNTVuMy5AzXUsRjcJuxypnWRyXRpBSGYeH2sdVvi8NsNIarCFeIFuelOaJfzJKCNJFUPMQ4nwhPHa0dHYuFIYnRLh5UGZwUkt8bNpIarbEpxlyQhIE3UCeJ1v6qzEwEIM0ehR/2ImfK7lI3uNVtbUFnjj0XokKe+K1XHDdf6YglycH6N1eMpw5OkiJPkus1GO9pe1AQvlvd9HdXyYVkRcoBUjj2/CvHd39/f7eN9Yhv9zufRHNXj1r6FpYJeZFTDgiC7XY8hUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6Eg1ZW7XPoUXdROwdiyDGpSCtcqpS0+bko92gYFnH0=;
 b=ITGtI1Jxyq+wMh6B+V6mhMF1IK4Id8qS4MsBpumeF4pQpEQy3OLu796EES7temF8o5UVi1/M/6AzIYUHVEidkC2V/uWkqYP9sfcwy9PyLjjwkaXG2s8D3KXoejbpzJ2TVXd5TQtzZsE5P8ik1hH0V7uhzy4JB1Pv02N47fvJpYGy/cCMpOOUsi+3lpcJ8+mk9OOH0XUjaCA6rt3nNQ2+japVqPjgwkre9x6LpZHcJCg5UmFQS3h5k2tRVGT83hafF8vxeTCUKnscjpRSpxnQ+0khdsy/dB03LOUZ9fZl4qHhw5OkRiR8q9+GbJnMBsWwEKTqZANfc2q2rPMFHLP7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6Eg1ZW7XPoUXdROwdiyDGpSCtcqpS0+bko92gYFnH0=;
 b=ChrRmammUoa69PtJAxZk6HqyxK4gtp7TdkbaAoFeUp2W76plBb379fIpgqWyaDIfl10AXgQpO7z47+UUE4TSxPmGQJxATGV/0nyGy4zC27FCp5bc4qU1gpsJ0z1Jxg7W07jLYS8OmgDJzYGI+xwISaaaM74uo2Om2YqxvdWO2E8=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3869.namprd11.prod.outlook.com (2603:10b6:208:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 12 Nov
 2021 21:53:59 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 21:53:59 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v5 10/16] libcxl: add representation for an nvdimm
 bridge object
Thread-Topic: [ndctl PATCH v5 10/16] libcxl: add representation for an nvdimm
 bridge object
Thread-Index: AQHX1z0A34ChUwTcWkKBLdEDiBtcoav+/wKAgAFyGYA=
Date: Fri, 12 Nov 2021 21:53:59 +0000
Message-ID: <1e94a2007f9b657faa1c49a6c317bfc6a51a6f81.camel@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
	 <20211111204436.1560365-11-vishal.l.verma@intel.com>
	 <CAPcyv4j760G=RFkBVy5rB_dOOV3Vj1cL+LvdVzwLS1rT81vZ=A@mail.gmail.com>
In-Reply-To: <CAPcyv4j760G=RFkBVy5rB_dOOV3Vj1cL+LvdVzwLS1rT81vZ=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de8b4f81-3950-4f52-b0c5-08d9a626eeb5
x-ms-traffictypediagnostic: MN2PR11MB3869:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB38699B32FC6FE9A780D11EA0C7959@MN2PR11MB3869.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lI9FGeXnhUvS5eMAntx7ecQDigoM62l6iNZGGR+rBd9xwOs5LgxrtVx0tg7JhV8hlwJBew2Zm7+nh4aBr9c1UECYY9/NX35d1FY1MjutQOYbX/bBUhvI1fvYn2R3nfqFRrCmkzP2P2WxQF9Pgn8kLDTK0urvC+tNV8vpWcgX4vlN9ao3zjKhpTxfuVA6FrBpPaoFLCcP8HbWrQo6rZGHtWtDgoxzv5sPRQ7Ovqc6AJjhSUNZr9WcKqByVV82qej05+M4Vo6PHiJpnNfOM4auEV73t8miGbkKnqjta37+UaKUosthF9pE8RPVH5TY9vm/Z0VQ5ETci4j0UezJp3tjEzbhJeMa4JO2KmngwqxzTs1dTPcXJKbo+YnoVg5GpZ3w5rsT0sA1w21EIbgZeH50x2CUwARs1BYQFSZFh6BuVIm/vS/nWTTT0OGUSMi66CmcOYsVZ6knMjbdeHkTNfCQ5Ah70PsIS4XN3s6NS/GJjKltSv2+3A7HUruvlVCxEmI/9vV18sGaJXGi8mCQdBd4oJU0GNpheMSDXWdzPMy8OpX3TgaCvYEONSi6kFnF8n/9x3la8g0iWsmxDbMW3AU4suzt36E/+TgVkY2QgumwNw3e/MbN6BkaqDZoGjQlMi5uppUoy0nhx14+cU2ZTwKqiKQGs74DN33iPDFxQA/WZ4CnDe174Nhjpt+qdgx0M8uQebEELld6b19M7s1gL0G+mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(64756008)(66556008)(66476007)(5660300002)(66946007)(26005)(6512007)(8936002)(86362001)(316002)(6636002)(6486002)(54906003)(2616005)(38100700002)(53546011)(66446008)(76116006)(36756003)(38070700005)(91956017)(37006003)(122000001)(82960400001)(4001150100001)(4326008)(2906002)(6506007)(6862004)(71200400001)(508600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVhjVlN5SjNNQmJyNCtQM3lqdnVlSDRlZjM3YWU2YTBpcHRVbjIzd3NCSmlu?=
 =?utf-8?B?Q0ZhSkt3TitXM0ZJbUNPajJET1JqcnAxODdISXJkSDVvSUFqYTFnTTVWTFJF?=
 =?utf-8?B?bTJjb0xvRFNZbndGSXlrYkpzMFdyL1V0d3l3Nmp3VjJZUy8ySWtXZGd3TkJO?=
 =?utf-8?B?Si93YUpFYXZHVlpzY05BY2dVdFpzV25ad1BiMVJGK0FLMitBSCsrczQ1QlNm?=
 =?utf-8?B?L3U5djVqcGZDRXMycGFPMFNFNWtkYmFtSmhodGI2dE5NUW81bzZGWU50RU4x?=
 =?utf-8?B?UFlpMFM4S2MyV0dLalFCUEJUcXM5Mis0Z2xQdkZsNXZNL2I3bUQ4QlRYbHAx?=
 =?utf-8?B?NXJyc1ROL2tHcHhGT2hSTU80SUlFWVU5Ky8vZk14VXZiVUVBaWNjZ0RzOCs3?=
 =?utf-8?B?QzVnUURyRytjRHdZWUlwb0dHc24xMFZSWmRkMU5ET1JETHZIK3BFeDhDMVF4?=
 =?utf-8?B?Rno3TlNEUHFMTkRQVzFKZThxeXNDT080aGNYNWpiVVhhWXBQZVpneDUrVXdh?=
 =?utf-8?B?ZjB0RENiamxxT1BPUy9FcTFKUXk5M3ZUZllHZkdYU2h4aDFEWVJ6dXZaNGxw?=
 =?utf-8?B?NGFhdHpNRVBta0lVNklSMTNwM2hDUTBBa0xpZHR1NEpYRzRmMXVZT2wwc3R5?=
 =?utf-8?B?amc5Rk1PUGFES0lBdFNUMHdRS2QwdU9meDJuUHVuNUZGWnBuWFNBY3RaYTdp?=
 =?utf-8?B?S0Rjc0RESzhIalZDVTU0RUNZcGpXOGVvdk5DM0lBNXFpNWNGTnJDbUlEczdo?=
 =?utf-8?B?dVdSTHpNR0pyVGFYaVpZSmpQdjRDOEk4Rit5TVZlQzJXOTFoZEFYbWpvcWtG?=
 =?utf-8?B?VkI5eVNQVVRHNWtYY2ZwcFZTOUhpdWc0UDlzYzRzbEI0U1Bva0x3dWwwa2Rw?=
 =?utf-8?B?MzJFWExNYWRDWEdHUS9BdXVQNlhJR2VKKzJJZmxFdkJpVC9qY04yeldWVmU5?=
 =?utf-8?B?aFl1d0RwdHJlN29XMmhUYml2MFdKTXlOSU1KRDErK1lBNVNQU0VGNnRGbmJh?=
 =?utf-8?B?M1NXS0s0R0Y5V3Z5b1owb1JERnVReWlsOVBlVkZtMkk2V0hXMXRIUFNFYml4?=
 =?utf-8?B?V3VCQi9ZQVQxWXExYW1UYUtaK1JPZ2JBZUNjdnFYdXhkSk9RdEl1aG1Lellx?=
 =?utf-8?B?MGgxTFdBenVjTkllYXhVcy8yK3VmT2V0MzVIbEh1OEgrRWZkS3pPM0pVYzV0?=
 =?utf-8?B?YTNwMTJFdTlPQUhMQXFCMWVGeHh4V3NqUEswaFhIWHd5T1EwUWhwSE1Ld0ln?=
 =?utf-8?B?OWFNWHNuQ3VZMUZYUXRRUUFGWERCaDdTWXZQZmYvYnRxaDhRZitiRWF5bk93?=
 =?utf-8?B?VVdLd0ZlaDVuUXFWM3E3UEVDLzNRVTNzcENwZHdScnRvT0ttU1pEUmNFYkw5?=
 =?utf-8?B?OUppQnBsQ0pxTHBLQytDL3BMcDFzMXU5WmVCd1dqUFhuVGV1SHY2V0NxRnEv?=
 =?utf-8?B?QlU5b3ZEd2pNOFVIWUR2UDhka3JYYmMvQkFwU29WUWxLV21qVFpYQ3gxWS9S?=
 =?utf-8?B?WWwyT3plWlBwbGZnMjN6UzFwRUF2MFc5UEN3czBNMW9VWlZsc0RIcHJuM3Jr?=
 =?utf-8?B?Y1oyTmJ5YlRHZ0ViYnBVa2ZCa05LZFpPV1pmS0E5RVZ5QTQwc1JqNm85Zjlq?=
 =?utf-8?B?TU5Uam9iWjMrajdIenBBRW9jaXVWRElpaW80aTlGY0V5VEdNYmxQcmtpV2Fv?=
 =?utf-8?B?Mk9ZZjRqbE4yQVpQVzFPZnFBRXNYV1d5N3pIUGUzUGdhVlZxczhOMi9TclZw?=
 =?utf-8?B?R29TSnN2ZnFsUEdTanNNMi9WVTY2UUhlb09yOTlDdldOMW9TNTdVU3lQUnNY?=
 =?utf-8?B?b1Z6elJaYWh4VU1LZCtpU01nTVNlZnVLc20rVk1PK1pIQ3I0QTFadXpLRmR6?=
 =?utf-8?B?UXhyaHdsSTVBWTRMOVVPOVlyQUtqd1M4WlN0eGtHY0l1cjRJWDd3MDBFNUlY?=
 =?utf-8?B?cTArZHBGNkFGZmhMeEFpZ0NCNHJ4Z050cHhIcGtRc0l0RnVLSDlBQk9FZ2Vs?=
 =?utf-8?B?cndLbWxMYzMwUGc2d0llaFB2UUVaaHpCbkVIYnBNMW1zQ1NKMnNFSW9GOGtG?=
 =?utf-8?B?SEptcm1TV29PcU9Iekk2M2w5K3VUOVFqeGNmM3dNdTJrdUY3M0FtNDFLRy9G?=
 =?utf-8?B?YXVvR1pzdjkySllDSVV4bmhYRHZ3M0lYMzF3cjNQKzE2WlVzMm5WOFNVcjBQ?=
 =?utf-8?B?d3l5R3dSSnA4a0FJS0NIR2VrU1Z1RGlJbXVnYlFrbWNUckVWeU1WUFZjZ2FI?=
 =?utf-8?Q?xGRSt4113VBgR8O3ZzAF/Z/c/NSM188HW9ljnU6gFY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BAC0C97A102F64496D09DAB12CFB0A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8b4f81-3950-4f52-b0c5-08d9a626eeb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 21:53:59.2079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kAnCMzOXMppjqYadGkfCLpu8KACvyK6bjeawHAI5kP+lKSiMAw+uyEVYZljW6RQW41kSO4ykZ/4g+E3qS1SA+p18DSRlck7BIv7S8rpTG9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3869
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTExLTExIGF0IDE1OjQ5IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgTm92IDExLCAyMDIxIGF0IDEyOjQ1IFBNIFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiBBZGQgYW4gbnZkaW1tIGJyaWRnZSBv
YmplY3QgcmVwcmVzZW50YXRpb24gaW50ZXJuYWwgdG8gbGliY3hsLiBBIGJyaWRnZQ0KPiA+IG9i
amVjdCBpcyBpdGVkIHRvIGl0cyBwYXJlbnQgbWVtZGV2IG9iamVjdCwgYW5kIHRoaXMgcGF0Y2gg
YWRkcyBpdHMNCj4gDQo+IHMvaXRlZC90aWVkLw0KPiANCj4gPiBmaXJzdCBpbnRlcmZhY2UsIHdo
aWNoIGNoZWNrcyB3aGV0aGVyIGEgYnJpZGdlIGlzICdhY3RpdmUnIC0gaS5lLg0KPiA+IGltcGx5
aW5nIHRoZSBsYWJlbCBzcGFjZSBvbiB0aGUgbWVtZGV2IGlzIG93bmVkIGJ5IHRoZSBrZXJuZWwu
DQo+IA0KPiBKdXN0IHNvbWUgbWlub3IgZml4dXBzIGJlbG93IGFuZCB5b3UgY2FuIGFkZDoNCg0K
VGhhbmtzIERhbiAtIGZpeGVkIGFsbCB0aGVzZSB1cCBpbiB2Ng0KDQo+IA0KPiBSZXZpZXdlZC1i
eTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IA0KPiA+IA0KPiA+
IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiAtLS0N
Cj4gPiAgY3hsL2xpYi9wcml2YXRlLmggIHwgIDkgKysrKysrDQo+ID4gIGN4bC9saWIvbGliY3hs
LmMgICB8IDczICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4gPiAgY3hsL2xpYmN4bC5oICAgICAgIHwgIDEgKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5zeW0g
fCAgMSArDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgODQgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+
IGRpZmYgLS1naXQgYS9jeGwvbGliL3ByaXZhdGUuaCBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4g
aW5kZXggYzRlZDc0MS4uMmYwYjZlYSAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL3ByaXZhdGUu
aA0KPiA+ICsrKyBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gQEAgLTEwLDYgKzEwLDE0IEBADQo+
ID4gDQo+ID4gICNkZWZpbmUgQ1hMX0VYUE9SVCBfX2F0dHJpYnV0ZV9fICgodmlzaWJpbGl0eSgi
ZGVmYXVsdCIpKSkNCj4gPiANCj4gPiArDQo+ID4gK3N0cnVjdCBjeGxfbnZkaW1tX2JyIHsNCj4g
DQo+IE1pZ2h0IGFzIHdlbGwgc3BlbGwgb3V0ICJicmlkZ2UiLg0KPiANCj4gPiArICAgICAgIGlu
dCBpZDsNCj4gPiArICAgICAgIHZvaWQgKmRldl9idWY7DQo+ID4gKyAgICAgICBzaXplX3QgYnVm
X2xlbjsNCj4gPiArICAgICAgIGNoYXIgKmRldl9wYXRoOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAg
c3RydWN0IGN4bF9tZW1kZXYgew0KPiA+ICAgICAgICAgaW50IGlkLCBtYWpvciwgbWlub3I7DQo+
ID4gICAgICAgICB2b2lkICpkZXZfYnVmOw0KPiA+IEBAIC0yMyw2ICszMSw3IEBAIHN0cnVjdCBj
eGxfbWVtZGV2IHsNCj4gPiAgICAgICAgIGludCBwYXlsb2FkX21heDsNCj4gPiAgICAgICAgIHNp
emVfdCBsc2Ffc2l6ZTsNCj4gPiAgICAgICAgIHN0cnVjdCBrbW9kX21vZHVsZSAqbW9kdWxlOw0K
PiA+ICsgICAgICAgc3RydWN0IGN4bF9udmRpbW1fYnIgKmJyaWRnZTsNCj4gPiAgfTsNCj4gPiAN
Cj4gPiAgZW51bSBjeGxfY21kX3F1ZXJ5X3N0YXR1cyB7DQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9s
aWIvbGliY3hsLmMgYi9jeGwvbGliL2xpYmN4bC5jDQo+ID4gaW5kZXggZGVmM2E5Ny4uN2JjMDY5
NiAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL2xpYmN4bC5jDQo+ID4gKysrIGIvY3hsL2xpYi9s
aWJjeGwuYw0KPiA+IEBAIC00NSwxMSArNDUsMTkgQEAgc3RydWN0IGN4bF9jdHggew0KPiA+ICAg
ICAgICAgdm9pZCAqcHJpdmF0ZV9kYXRhOw0KPiA+ICB9Ow0KPiA+IA0KPiA+ICtzdGF0aWMgdm9p
ZCBmcmVlX2JyaWRnZShzdHJ1Y3QgY3hsX252ZGltbV9iciAqYnJpZGdlKQ0KPiA+ICt7DQo+ID4g
KyAgICAgICBmcmVlKGJyaWRnZS0+ZGV2X2J1Zik7DQo+ID4gKyAgICAgICBmcmVlKGJyaWRnZS0+
ZGV2X3BhdGgpOw0KPiA+ICsgICAgICAgZnJlZShicmlkZ2UpOw0KPiA+ICt9DQo+ID4gKw0KPiA+
ICBzdGF0aWMgdm9pZCBmcmVlX21lbWRldihzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2LCBzdHJ1
Y3QgbGlzdF9oZWFkICpoZWFkKQ0KPiA+ICB7DQo+ID4gICAgICAgICBpZiAoaGVhZCkNCj4gPiAg
ICAgICAgICAgICAgICAgbGlzdF9kZWxfZnJvbShoZWFkLCAmbWVtZGV2LT5saXN0KTsNCj4gPiAg
ICAgICAgIGttb2RfbW9kdWxlX3VucmVmKG1lbWRldi0+bW9kdWxlKTsNCj4gPiArICAgICAgIGZy
ZWVfYnJpZGdlKG1lbWRldi0+YnJpZGdlKTsNCj4gPiAgICAgICAgIGZyZWUobWVtZGV2LT5maXJt
d2FyZV92ZXJzaW9uKTsNCj4gPiAgICAgICAgIGZyZWUobWVtZGV2LT5kZXZfYnVmKTsNCj4gPiAg
ICAgICAgIGZyZWUobWVtZGV2LT5kZXZfcGF0aCk7DQo+ID4gQEAgLTIwNSw2ICsyMTMsNDAgQEAg
Q1hMX0VYUE9SVCB2b2lkIGN4bF9zZXRfbG9nX3ByaW9yaXR5KHN0cnVjdCBjeGxfY3R4ICpjdHgs
IGludCBwcmlvcml0eSkNCj4gPiAgICAgICAgIGN0eC0+Y3R4LmxvZ19wcmlvcml0eSA9IHByaW9y
aXR5Ow0KPiA+ICB9DQo+ID4gDQo+ID4gK3N0YXRpYyB2b2lkICphZGRfY3hsX2JyaWRnZSh2b2lk
ICpwYXJlbnQsIGludCBpZCwgY29uc3QgY2hhciAqYnJfYmFzZSkNCj4gPiArew0KPiA+ICsgICAg
ICAgY29uc3QgY2hhciAqZGV2bmFtZSA9IGRldnBhdGhfdG9fZGV2bmFtZShicl9iYXNlKTsNCj4g
PiArICAgICAgIHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYgPSBwYXJlbnQ7DQo+ID4gKyAgICAg
ICBzdHJ1Y3QgY3hsX2N0eCAqY3R4ID0gbWVtZGV2LT5jdHg7DQo+ID4gKyAgICAgICBzdHJ1Y3Qg
Y3hsX252ZGltbV9iciAqYnJpZGdlOw0KPiA+ICsNCj4gPiArICAgICAgIGRiZyhjdHgsICIlczog
YnJpZGdlX2Jhc2U6IFwnJXNcJ1xuIiwgZGV2bmFtZSwgYnJfYmFzZSk7DQo+ID4gKw0KPiA+ICsg
ICAgICAgYnJpZGdlID0gY2FsbG9jKDEsIHNpemVvZigqYnJpZGdlKSk7DQo+ID4gKyAgICAgICBp
ZiAoIWJyaWRnZSkNCj4gPiArICAgICAgICAgICAgICAgZ290byBlcnJfZGV2Ow0KPiA+ICsgICAg
ICAgYnJpZGdlLT5pZCA9IGlkOw0KPiA+ICsNCj4gPiArICAgICAgIGJyaWRnZS0+ZGV2X3BhdGgg
PSBzdHJkdXAoYnJfYmFzZSk7DQo+ID4gKyAgICAgICBpZiAoIWJyaWRnZS0+ZGV2X3BhdGgpDQo+
ID4gKyAgICAgICAgICAgICAgIGdvdG8gZXJyX3JlYWQ7DQo+ID4gKw0KPiA+ICsgICAgICAgYnJp
ZGdlLT5kZXZfYnVmID0gY2FsbG9jKDEsIHN0cmxlbihicl9iYXNlKSArIDUwKTsNCj4gPiArICAg
ICAgIGlmICghYnJpZGdlLT5kZXZfYnVmKQ0KPiA+ICsgICAgICAgICAgICAgICBnb3RvIGVycl9y
ZWFkOw0KPiA+ICsgICAgICAgYnJpZGdlLT5idWZfbGVuID0gc3RybGVuKGJyX2Jhc2UpICsgNTA7
DQo+ID4gKw0KPiA+ICsgICAgICAgbWVtZGV2LT5icmlkZ2UgPSBicmlkZ2U7DQo+ID4gKyAgICAg
ICByZXR1cm4gYnJpZGdlOw0KPiA+ICsNCj4gPiArIGVycl9yZWFkOg0KPiA+ICsgICAgICAgZnJl
ZShicmlkZ2UtPmRldl9idWYpOw0KPiA+ICsgICAgICAgZnJlZShicmlkZ2UtPmRldl9wYXRoKTsN
Cj4gPiArICAgICAgIGZyZWUoYnJpZGdlKTsNCj4gPiArIGVycl9kZXY6DQo+ID4gKyAgICAgICBy
ZXR1cm4gTlVMTDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIHZvaWQgKmFkZF9jeGxfbWVt
ZGV2KHZvaWQgKnBhcmVudCwgaW50IGlkLCBjb25zdCBjaGFyICpjeGxtZW1fYmFzZSkNCj4gPiAg
ew0KPiA+ICAgICAgICAgY29uc3QgY2hhciAqZGV2bmFtZSA9IGRldnBhdGhfdG9fZGV2bmFtZShj
eGxtZW1fYmFzZSk7DQo+ID4gQEAgLTI3MSw2ICszMTMsOCBAQCBzdGF0aWMgdm9pZCAqYWRkX2N4
bF9tZW1kZXYodm9pZCAqcGFyZW50LCBpbnQgaWQsIGNvbnN0IGNoYXIgKmN4bG1lbV9iYXNlKQ0K
PiA+ICAgICAgICAgICAgICAgICBnb3RvIGVycl9yZWFkOw0KPiA+ICAgICAgICAgbWVtZGV2LT5i
dWZfbGVuID0gc3RybGVuKGN4bG1lbV9iYXNlKSArIDUwOw0KPiA+IA0KPiA+ICsgICAgICAgc3lz
ZnNfZGV2aWNlX3BhcnNlKGN0eCwgY3hsbWVtX2Jhc2UsICJwbWVtIiwgbWVtZGV2LCBhZGRfY3hs
X2JyaWRnZSk7DQo+ID4gKw0KPiA+ICAgICAgICAgY3hsX21lbWRldl9mb3JlYWNoKGN0eCwgbWVt
ZGV2X2R1cCkNCj4gPiAgICAgICAgICAgICAgICAgaWYgKG1lbWRldl9kdXAtPmlkID09IG1lbWRl
di0+aWQpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBmcmVlX21lbWRldihtZW1kZXYs
IE5VTEwpOw0KPiA+IEBAIC0zNjIsNiArNDA2LDM1IEBAIENYTF9FWFBPUlQgc2l6ZV90IGN4bF9t
ZW1kZXZfZ2V0X2xhYmVsX3NpemUoc3RydWN0IGN4bF9tZW1kZXYgKm1lbWRldikNCj4gPiAgICAg
ICAgIHJldHVybiBtZW1kZXYtPmxzYV9zaXplOw0KPiA+ICB9DQo+ID4gDQo+ID4gK3N0YXRpYyBp
bnQgaXNfZW5hYmxlZChjb25zdCBjaGFyICpkcnZwYXRoKQ0KPiA+ICt7DQo+ID4gKyAgICAgICBz
dHJ1Y3Qgc3RhdCBzdDsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAobHN0YXQoZHJ2cGF0aCwgJnN0
KSA8IDAgfHwgIVNfSVNMTksoc3Quc3RfbW9kZSkpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVy
biAwOw0KPiA+ICsgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4g
PiArfQ0KPiA+ICsNCj4gPiArQ1hMX0VYUE9SVCBpbnQgY3hsX21lbWRldl9udmRpbW1fYnJpZGdl
X2FjdGl2ZShzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBz
dHJ1Y3QgY3hsX2N0eCAqY3R4ID0gY3hsX21lbWRldl9nZXRfY3R4KG1lbWRldik7DQo+ID4gKyAg
ICAgICBzdHJ1Y3QgY3hsX252ZGltbV9iciAqYnJpZGdlID0gbWVtZGV2LT5icmlkZ2U7DQo+ID4g
KyAgICAgICBjaGFyICpwYXRoID0gbWVtZGV2LT5kZXZfYnVmOw0KPiANCj4gU2hvdWxkIHRoaXMg
YmU6IGJyaWRnZS0+ZGV2X2J1Zj8NCj4gDQo+ID4gKyAgICAgICBpbnQgbGVuID0gbWVtZGV2LT5i
dWZfbGVuOw0KPiANCj4gLi4uYW5kIHRoaXMgc2hvdWxkIGJyaWRnZS0+YnVmX2xlbj8NCj4gDQo+
IE5vdCBzdHJpY3RseSBhIGJ1ZywgYnV0IG1pZ2h0IGFzIHdlbGwgdXNlIHRoZSAnYnJpZGdlJyB2
ZXJzaW9uIG9mDQo+IHRoZXNlIGF0dHJpYnV0ZXMsIHJpZ2h0Pw0KPiANCj4gPiArDQo+ID4gKyAg
ICAgICBpZiAoIWJyaWRnZSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gKw0K
PiA+ICsgICAgICAgaWYgKHNucHJpbnRmKHBhdGgsIGxlbiwgIiVzL2RyaXZlciIsIGJyaWRnZS0+
ZGV2X3BhdGgpID49IGxlbikgew0KPiA+ICsgICAgICAgICAgICAgICBlcnIoY3R4LCAiJXM6IG52
ZGltbSBicmlkZ2UgYnVmZmVyIHRvbyBzbWFsbCFcbiIsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjeGxfbWVtZGV2X2dldF9kZXZuYW1lKG1lbWRldikpOw0KPiA+ICsgICAg
ICAgICAgICAgICByZXR1cm4gMDsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICBy
ZXR1cm4gaXNfZW5hYmxlZChwYXRoKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgQ1hMX0VYUE9SVCB2
b2lkIGN4bF9jbWRfdW5yZWYoc3RydWN0IGN4bF9jbWQgKmNtZCkNCj4gPiAgew0KPiA+ICAgICAg
ICAgaWYgKCFjbWQpDQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWJjeGwuaCBiL2N4bC9saWJjeGwu
aA0KPiA+IGluZGV4IGQzYjk3YTEuLjUzNWUzNDkgMTAwNjQ0DQo+ID4gLS0tIGEvY3hsL2xpYmN4
bC5oDQo+ID4gKysrIGIvY3hsL2xpYmN4bC5oDQo+ID4gQEAgLTQzLDYgKzQzLDcgQEAgdW5zaWdu
ZWQgbG9uZyBsb25nIGN4bF9tZW1kZXZfZ2V0X3BtZW1fc2l6ZShzdHJ1Y3QgY3hsX21lbWRldiAq
bWVtZGV2KTsNCj4gPiAgdW5zaWduZWQgbG9uZyBsb25nIGN4bF9tZW1kZXZfZ2V0X3JhbV9zaXpl
KHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYpOw0KPiA+ICBjb25zdCBjaGFyICpjeGxfbWVtZGV2
X2dldF9maXJtd2FyZV92ZXJpc29uKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYpOw0KPiA+ICBz
aXplX3QgY3hsX21lbWRldl9nZXRfbGFiZWxfc2l6ZShzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2
KTsNCj4gPiAraW50IGN4bF9tZW1kZXZfbnZkaW1tX2JyaWRnZV9hY3RpdmUoc3RydWN0IGN4bF9t
ZW1kZXYgKm1lbWRldik7DQo+ID4gDQo+ID4gICNkZWZpbmUgY3hsX21lbWRldl9mb3JlYWNoKGN0
eCwgbWVtZGV2KSBcDQo+ID4gICAgICAgICAgZm9yIChtZW1kZXYgPSBjeGxfbWVtZGV2X2dldF9m
aXJzdChjdHgpOyBcDQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGliY3hsLnN5bSBiL2N4bC9s
aWIvbGliY3hsLnN5bQ0KPiA+IGluZGV4IDg1OGU5NTMuLmYzYjBjNjMgMTAwNjQ0DQo+ID4gLS0t
IGEvY3hsL2xpYi9saWJjeGwuc3ltDQo+ID4gKysrIGIvY3hsL2xpYi9saWJjeGwuc3ltDQo+ID4g
QEAgLTY1LDYgKzY1LDcgQEAgZ2xvYmFsOg0KPiA+ICAgICAgICAgY3hsX2NtZF9uZXdfcmVhZF9s
YWJlbDsNCj4gPiAgICAgICAgIGN4bF9jbWRfcmVhZF9sYWJlbF9nZXRfcGF5bG9hZDsNCj4gPiAg
ICAgICAgIGN4bF9tZW1kZXZfZ2V0X2xhYmVsX3NpemU7DQo+ID4gKyAgICAgICBjeGxfbWVtZGV2
X252ZGltbV9icmlkZ2VfYWN0aXZlOw0KPiA+ICBsb2NhbDoNCj4gPiAgICAgICAgICAqOw0KPiA+
ICB9Ow0KPiA+IC0tDQo+ID4gMi4zMS4xDQo+ID4gDQoNCg==

