Return-Path: <nvdimm+bounces-2178-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 3448646AE46
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Dec 2021 00:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 4727A3E0E7A
	for <lists+linux-nvdimm@lfdr.de>; Mon,  6 Dec 2021 23:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFE02CB1;
	Mon,  6 Dec 2021 23:11:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAF02C80
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 23:11:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="218114933"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="218114933"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 15:11:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="611422682"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 06 Dec 2021 15:11:00 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 15:11:00 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 15:11:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 6 Dec 2021 15:11:00 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 6 Dec 2021 15:10:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqjpmZqx7BmfzNuk0iUJrI9ltvgXDtz//EVTvax2QbNd9Ls7Epv7qcIZqGsvwvusCkOnt+GiBLIA3ps/uKriT0CAorZAOsH7S/xvIRy0XtNLKlHNulAXf+CMPMWWq0dS4XxXb1k2LK76th5E0hGCA7eEqczPa/ZigYoseqauK2v1RyibaOCUhjeVvuFt02i3/3lIfZJ4O6XJo8EOS2rgLpQPlfhND6iruXKk/bcWpuDtknH736k2qJjE1L3noSijPRvKPhrDLWpKz2dUwTtPpATRPEVx+SSOlsOs9FbOEJGpwzda72ZP1ta9XEBq40aOo2lk5Bb00vf3IoalAc6LOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JE8dh79iTd+uFXgY5lj5eXWGCm5sTUkhcJIWJb1xqVo=;
 b=BNN0RAxyGMJZ4o1ea5E61ld6Dv2ThokIbWSmxRtEywfL4QSDHS1nEUFh2Wqpp5HNoJAh6g4HkDjXM1FoD8524z8aNdCLFRQaa0liVFUd4NnoyVaOD0vFpucUPM3dfzqs6dIyJC6cxvhgyb1iOUm0tzMP1YrBnFo6MR9HuK/mFdNDXCELjPVP62ubkTXpCnE64ExqwQ2Ab9uc4ZYMkwSCivSGthcppCSp4vDspi2gZGruxTO6epIXPYsDP68VMMnvY8CGGUjJx7xuy86OqLDtJ68rZ8tKy1YrdHu8N2PM03KGZm46qmkCuBAwkBqIKjDCB8pXNDC+ZhDghYQNYKZVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JE8dh79iTd+uFXgY5lj5eXWGCm5sTUkhcJIWJb1xqVo=;
 b=iGAyjt37Ug2ONdrxee/1+Kj0ZIiEimOzXMgsLoOAIEU2TFg6BG422wPlQQZ0X3BAZq6Isk/3ouNeKcb+5y8B/xftVCNh0JczVcJl930YbsJnswoE39VfClcYOvHSWFA0+F5aWRSLJuzdov04IUKj2m2A3KmmxKJts0GGpjPSA3c=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3871.namprd11.prod.outlook.com (2603:10b6:208:13c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 23:10:58 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:10:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Hu, Fenghua"
	<fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxctl
Thread-Topic: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxctl
Thread-Index: AQHX6vCmi7ScPiO9TU6cyRQO6ymY4qwmFymA
Date: Mon, 6 Dec 2021 23:10:58 +0000
Message-ID: <a99313fe975700d548f5a689cd6b5316356571d4.camel@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.1 (3.42.1-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67cd576d-5eee-43de-918e-08d9b90da9c5
x-ms-traffictypediagnostic: MN2PR11MB3871:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB3871D27D96515DEB1B99EAADC76D9@MN2PR11MB3871.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 09iFAd96FpgT3EUuhwQaiPze1c0NwS/zX2bS+ILPw/pUpBgRCTzZjpo2yWW6/brD5NxIgY/OP7UAzOv3Hpto4TN/GW+SrkAYH0ONjxk2T1UtKOwl5DkhRaU65lGVV/dvZC2P6IKmwylj2bEtmXDRzUi43cWIzirBQP8GkXBnHugTKrwUo+R7oar5iVCcsLOvK1IReto8hLewmluXV6NbrFooUZUSrvyxmEptb0LNrMHDknqJlQUBuhVca4Mh9/11PznCZ+S5IzlxKsJU5pr9aA4A0SaIoRWm00uJBQbZabH0TaGz9NnxjSvi4dKqwJjBKRJ3YkAMzT+xZhkn9ng1UE+T+aRiRgpxEqAtxQNy0uu8aL6dvIBzDHU4qdDgd55U5WJTeKgWvRJWNTtWz2iUzZxvzEURG3kdJ8pVFIYLZ2bYD5x8M59QRC/ghG/3cZChgliRsTWw9jfjRgWlO91rd5YVmylyGFcGG111x7/UO8Sdw/dcFJ4RKlqtt3BXGxttiema8DMe4pNJYGT4qqsMO0qj3gFGIV1fjJ/7npWmePB/kH/qcnw3YykyApKuuWgaRzu3AMrnQ++KMzCM8kzOZMsN6foDOe/UiWYJUzyL76yOKOHYzVmdaeyUXLTmuZnzyHqgHYzcdNv/gbu5EUilFuPaFMUxcgkfMQm4tmsRRwQtmeXb9/sYjkX/oRVWh36R21MbMqHX/IfUGQLNBvGTKDNoYG4j+waiZ57il6hwxRQWSSJqulx2BJmDYaBAJyEc8ka2eoKEer50Q6u8BT7jFj6RhUsWYl5ubABs67zo9Hc/r1t1pxEAkJ86BI7FoFVjc+cTqWj3yD7R9eT3/qAcKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(66556008)(66476007)(6486002)(6506007)(83380400001)(76116006)(91956017)(26005)(66446008)(316002)(71200400001)(86362001)(6512007)(36756003)(186003)(66946007)(64756008)(6916009)(54906003)(8936002)(4326008)(82960400001)(5660300002)(2616005)(8676002)(38100700002)(122000001)(966005)(2906002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnZSbmRqRVZ2QXNKRVp6aGV4Zi9KaFFJWEdpRHFrUzZ6aFBrTFVnS1FYRWpT?=
 =?utf-8?B?Qm5iRUl3aFVCclEwRjZjZFY1d05XN0k5b0w1RXBSNFFkdVNDTUM1N3dpeTJm?=
 =?utf-8?B?SlBkY3o5dHVpN3V5TXBOUVA4ZENTMVk4dWh3c1M3VWhmdnhKb2JPeEE5OU9o?=
 =?utf-8?B?MmZRMUlsMnBWdkdBOG9yanpvR1A4aS8wWjVHdkI3QVZhNlkyMDJBWnZaK2Qx?=
 =?utf-8?B?a3pyQmxOeldocWU5b24wbUhGcExyNWdpRWtMbkNmb2J5azdxcWFBeGJxdk1p?=
 =?utf-8?B?bUFRSFpqb1VVT1pJYXJoL2tmbFNJZVpybDhqdTIyNnhmbG5VN1ZkN0Vxb1dM?=
 =?utf-8?B?Q3FUMzNld0RmWWcvVFgwMTVzUysxR3g0ZXFxVjh1Y1FlbTQxY3hnM012R1VS?=
 =?utf-8?B?U3gvd1RYd3NISnNHQVdVRUtPcTkrdEJPcklKM0U0WitPTFRlV2oxb2VYNVhH?=
 =?utf-8?B?eE1tU1BmSTUxM1lZVEZIdzJFMU54VnZwWWk2YmhxT0VjZVF6NkhEZ3Q0bHRq?=
 =?utf-8?B?ZHpTazhRSzJGM1pSaXpuS01DNmFubzNKT1ZZZXlSS3Q0MnBZQm5BTWdUMEZk?=
 =?utf-8?B?eWRIbmV1d1dJSWR2SGtlNlZpRHhQSHhpbjlOSDgxVW16SlhqSGJGUVE0Zm9k?=
 =?utf-8?B?dGtHWUczYUxhdzJHSUhYVFlzQy80MDQ2UGhVTERTM1NuOWd0ZlFBTlUvZVFL?=
 =?utf-8?B?R09saEFEWmpqYWw5WDFhU0R6bk45NUt5bUI4L04rdlJZZ1hVdENuaFc2OTNs?=
 =?utf-8?B?b3RzZDJEV1lVT255bVhJSjNJUWNjRDdtaFJEUndYcVZqdUwzek5mSUladlhR?=
 =?utf-8?B?N1pmc0JqaHFHWkNDeDdHS3M3RmkwMXBOWnV5eFhmZ1R0ZHl3Z2xYWXFuWVpE?=
 =?utf-8?B?VkhibzdpZmlWYmZlYk8xVkt6aVNKV3Nsc00raUJQZEx4dTdVb2FWZ3NqaHJL?=
 =?utf-8?B?NEtGWEZ1Y0tXeGhYbEprOWNreG9IUldUOW4vYVRCVTYyVE91bkduUDRXanJ4?=
 =?utf-8?B?ODFzUVRqOVRpVW83UzJTT0ZtV0VnRkozRkkzMGU2Zm1zYW1nN3BEak5IRi80?=
 =?utf-8?B?V1FqTndlZHlNWjc3Tk1pN0hhc1h6a1puTnU4Q0RsOGVpNm44a2czaFhaR2h0?=
 =?utf-8?B?RjdqTnZlY0tmZjllL0FwTElUWEdhbGVBOUpCdDU3MW5GdmNJd0hWZ3ZQc0wx?=
 =?utf-8?B?SXg4SG90S1A3OUVVc01MT1Vjek1UUUlwVm9Jc216RWtIYTNvV0VYRWpYelhv?=
 =?utf-8?B?UDBxM3JqL0NZcUhHVEd6OGs5VG52YklFQno5bmJxUEpVZVB2OGxqZ3gxVkdU?=
 =?utf-8?B?VThiNEVacWdxWHN2Tm5tMVNpc0l1UzlXZ3ZjakJWcE0yY3JKOEJuU1RSNnN6?=
 =?utf-8?B?d2VEbWFjWnFianhwdm1TWDFtOTZhRlRQS3NNMjgwT0RmdTB1TWhTMTNvdTlI?=
 =?utf-8?B?ZkwwWng0RnkwMWZJclFXVnRoZDV5emZLVC9mQkRQVEpSNzJTdjRHc3VRNy9J?=
 =?utf-8?B?QnBmZWc4cTExYUJDb01UL2llNUpkcis3MEJsL0pUVTJPQXBGUTVBOFQrMVFW?=
 =?utf-8?B?amdJQjR4c1lQSGFrZ0cxRThCQkVDZlp5dGxqSU5YSFBtdVVsZzVDZjdTMk51?=
 =?utf-8?B?OEthbEFSbG9WaHAxcng2NnJRZHlTVEJWTWtsVXJ1MjRaaVNiMjRPRDNzajBp?=
 =?utf-8?B?aDJOMytDdmxZU3F5cy9sQnBsbXV6NDVvTVhHT0ltdDB1d0ZFNHhnWDMvaFRw?=
 =?utf-8?B?bFo0VXBsUndlOC9XWmVxNSszT2ZsNFphNy80UFMzKzJOdTBWOUhMVUZ0SW5R?=
 =?utf-8?B?cU11Z0pleENXZ3RzdERBYmpNOGplQyt1aHRlR29JSU5tU2RoU09DNXZSMDFk?=
 =?utf-8?B?VXJiTDJUdlc4dWtKYnZXVGxqU2dtVG5XSWF2aUhqZmtpSURlWUtoWVlyUXY4?=
 =?utf-8?B?OHErdXpyY2swcEQ0dHhKV3hCb1N1QnhPREhxYUVoTFh2cWpkWjE2Nk5tYTVR?=
 =?utf-8?B?Tm9nbW5XUkJNZjVHaHpDcEhjZ3hBZ2dEcmo4SXJqbFE3aE0yNnF5T3hlREIz?=
 =?utf-8?B?b25KOGoyR09RRThHRmt5Z3lnQU9zWE1iKzJJS2NnbEt4SDBVZWM1S1dYYkFj?=
 =?utf-8?B?RjJSUzJCT1k5a0xyaEtBYkFHYmN1TDNKQ0RaRGtyMmJEMDVRTWVuREVIZnFl?=
 =?utf-8?B?ZGR1c05YdGxFYmVoZVlaTnFNQ0gzZnBSU2JxTW1YdWNCOUZQNFJGeHZMQnQ2?=
 =?utf-8?Q?vlrWYydtf+4oIOErKXZ3qTy4Ip7LMUjpRe3fRu0TLY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B96A508C07D07438DD07B3ED660893B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cd576d-5eee-43de-918e-08d9b90da9c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 23:10:58.2027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OqFF27RIB7yANTsNxuaMXHW7XXDtTQnF5NK8JxuysJE3HnC/eNVsPQMujVD7Wc/htVIGxZab96ncuX5NMrq3Og22f8Svq/jcwKLO1ucUsic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3871
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIxLTEyLTA2IGF0IDE1OjI4IC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IENoYW5nZXMgc2luY2UgdjFbMV06DQo+IC0gQ29sbGVjdCByZXZpZXcgdGFncw0KPiAtIEZpeCAn
bWFrZSBjbGVhbicgcmVtb3ZpbmcgdGhlIHJlY29uZmlndXJlIHNjcmlwdCBmcm9tIHRoZSBzb3Vy
Y2UgdHJlZQ0KPiAgIChGZW5naHVhLCBRaSkNCj4gLSBEb2N1bWVudGF0aW9uIHdvcmRzbWl0aGlu
ZyAoRGFuKQ0KPiAtIEZpeCBsaW5lIGJyZWFrIGFmdGVyIGRlY2xhcmF0aW9ucyBpbiBwYXJzZS1j
b25maWdzLmMgKERhbikNCj4gLSBNb3ZlIGRheGN0bCBjb25maWcgZmlsZXMgdG8gaXRzIG93biBk
aXJlY3RvcnksIC9ldGMvZGF4Y3RsLyAoRGFuKQ0KPiAtIEltcHJvdmUgZmFpbHVyZSBtb2RlIGlu
IHRoZSBhYnNlbmNlIG9mIGEgY29uZmlncyBkaXJlY3RvcnkNCj4gLSBSZW5hbWUge25kLGRheH1j
dGxfe2dldHxzZXR9X2NvbmZpZ3MgdG8NCj4gICB7bmQsZGF4fWN0bF97Z2V0fHNldH1fY29uZmln
c19kaXINCj4gLSBFeGl0IHdpdGggc3VjY2VzcyBpZiAtQyBpcyBzcGVjaWZpZWQsIGJ1dCBubyBt
YXRjaGluZyBjb25maWcgc2VjdGlvbg0KPiAgIGlzIGZvdW5kLg0KPiAtIFJlZnVzZSB0byBwcm9j
ZWVkIGlmIENMSSBvcHRpb25zIGFyZSBwYXNzZWQgaW4gYWxvbmcgd2l0aCAtQyAoRGFuKQ0KPiAt
IEluIHRoZSBjb25maWcgZmlsZSwgcmVuYW1lOiBzL1thdXRvLW9ubGluZSBmb29dL1tyZWNvbmZp
Z3VyZS1kZXZpY2UgZm9vLw0KPiAgIGFuZCBzL3V1aWQvbnZkaW1tLnV1aWQvIChEYW4pDQo+IC0g
VGVhY2ggZGV2aWNlLmMgdG8gYWNjZXB0IC9kZXYvZGF4WC5ZIGluc3RlYWQgb2Ygb25seSBkYXhY
LlkgYW5kIHRodXMNCj4gICByZW1vdmUgdGhlIG5lZWQgZm9yIGEgd3JhcHBlciBzY3JpcHQgdGhh
dCBzeXN0ZW1kIGludm9rZXMgKERhbikNCj4gDQo+IFRoZXNlIHBhdGNoZXMgYWRkIHBvbGljeSAo
Y29uZmlnIGZpbGUpIHN1cHBvcnQgdG8gZGF4Y3RsLiBUaGUNCj4gaW50cm9kdWN0b3J5IHVzZXIg
aXMgZGF4Y3RsLXJlY29uZmlndXJlLWRldmljZS4gU3lzYWRtaW5zIG1heSB3aXNoIHRvDQo+IHVz
ZSBkYXhjdGwgZGV2aWNlcyBhcyBzeXN0ZW0tcmFtLCBidXQgaXQgbWF5IGJlIGN1bWJlcnNvbWUg
dG8gYXV0b21hdGUNCj4gdGhlIHJlY29uZmlndXJhdGlvbiBzdGVwIGZvciBldmVyeSBkZXZpY2Ug
dXBvbiBib290Lg0KPiANCj4gSW50cm9kdWNlIGEgbmV3IG9wdGlvbiBmb3IgZGF4Y3RsLXJlY29u
ZmlndXJlLWRldmljZSwgLS1jaGVjay1jb25maWcuDQo+IFRoaXMgaXMgYXQgdGhlIGhlYXJ0IG9m
IHBvbGljeSBiYXNlZCByZWNvbmZpZ3VyYXRpb24sIGFzIGl0IGFsbG93cw0KPiBkYXhjdGwgdG8g
bG9vayB1cCByZWNvbmZpZ3VyYXRpb24gcGFyYW1ldGVycyBmb3IgYSBnaXZlbiBkZXZpY2UgZnJv
bSB0aGUNCj4gY29uZmlnIHN5c3RlbSBpbnN0ZWFkIG9mIHRoZSBjb21tYW5kIGxpbmUuDQo+IA0K
PiBTb21lIHN5c3RlbWQgYW5kIHVkZXYgZ2x1ZSB0aGVuIGF1dG9tYXRlcyB0aGlzIGZvciBldmVy
eSBuZXcgZGF4IGRldmljZQ0KPiB0aGF0IHNob3dzIHVwLCBwcm92aWRpbmcgYSB3YXkgZm9yIHRo
ZSBhZG1pbmlzdHJhdG9yIHRvIHNpbXBseSBsaXN0IGFsbA0KPiB0aGUgJ3N5c3RlbS1yYW0nIFVV
SURzIGluIGEgY29uZmlnIGZpbGUsIGFuZCBub3QgaGF2ZSB0byB3b3JyeSBhYm91dA0KPiBhbnl0
aGluZyBlbHNlLg0KPiANCj4gQW4gZXhhbXBsZSBjb25maWcgZmlsZSBjYW4gYmU6DQo+IA0KPiAg
ICMgY2F0IC9ldGMvbmRjdGwvZGF4Y3RsLmNvbmYNCg0KTWlzc2VkIHVwZGF0aW5nIHRoaXMsIGl0
IHNob3VsZCBiZSAvZXRjL2RheGN0bC9kYXhjdGwuY29uZg0KDQo+IA0KPiAgIFtyZWNvbmZpZ3Vy
ZS1kZXZpY2UgdW5pcXVlX2lkZW50aWZpZXJfZm9vXQ0KPiAgIG52ZGltbS51dWlkID0gNDhkOGU0
MmMtYTJmMC00MzEyLTllNzAtYTgzN2ZhYWZlODYyDQo+ICAgbW9kZSA9IHN5c3RlbS1yYW0NCj4g
ICBvbmxpbmUgPSB0cnVlDQo+ICAgbW92YWJsZSA9IGZhbHNlDQo+IA0KPiBBbnkgZmlsZSB1bmRl
ciAnL2V0Yy9uZGN0bC8nIGNhbiBiZSB1c2VkIC0gYWxsIGZpbGVzIHdpdGggYSAnLmNvbmYnIHN1
ZmZpeA0KDQpBbmQgdGhpcyBzaG91bGQgYmUgJy9ldGMvZGF4Y3RsLycNCg0KPiB3aWxsIGJlIGNv
bnNpZGVyZWQgd2hlbiBsb29raW5nIGZvciBtYXRjaGVzLg0KPiANCj4gVGhlc2UgcGF0Y2hlcyBk
ZXBlbmQgb24gdGhlIGluaXRpYWwgY29uZmlnIGZpbGUgc3VwcG9ydCBmcm9tIFFpIEZ1bGlbMl0u
DQo+IA0KPiBJJ3ZlIHJlLXJvbGxlZCBRaSdzIG9yaWdpbmFsIHBhdGNoZXMgYXMgdGhlIGZpcnN0
IGZpdmUgcGF0Y2hlcyBpbiB0aGlzDQo+IHNlcmllcyBiZWNhdXNlIG9mIGEgY2hhbmdlIEkgbWFk
ZSBmb3IgZ3JhY2VmdWwgaGFuZGxpbmcgaW4gdGhlIGNhc2Ugb2YgYQ0KPiBtaXNzaW5nIGNvbmZp
Z3MgZGlyZWN0b3J5LCBhbmQgYWxzbyB0byBpbmNvcnBvcmF0ZSByZXZpZXcgZmVlZGJhY2sgdGhh
dA0KPiBhcHBsaWVkIHRvIHRoZSBkZXBlbmRhbnQgcGF0Y2hlcy4gUGF0Y2ggNiBvbndhcmRzIGlz
IHRoZSBhY3R1YWwgdjIgb2YNCj4gdGhlIGRheGN0bCBwb2xpY3kgd29yay4NCj4gDQo+IEEgYnJh
bmNoIGNvbnRhaW5pbmcgdGhlc2UgcGF0Y2hlcyBpcyBhdmFpbGFibGUgYXQgWzNdLg0KPiANCj4g
WzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9udmRpbW0vMjAyMTA4MzEwOTA0NTkuMjMwNjcy
Ny0xLXZpc2hhbC5sLnZlcm1hQGludGVsLmNvbS8NCj4gWzJdOiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9udmRpbW0vMjAyMTA4MjQwOTUxMDYuMTA0ODA4LTEtcWkuZnVsaUBmdWppdHN1LmNvbS8N
Cj4gWzNdOiBodHRwczovL2dpdGh1Yi5jb20vcG1lbS9uZGN0bC90cmVlL3Z2L2RheGN0bF9jb25m
aWdfdjINCj4gDQo+IFFJIEZ1bGkgKDUpOg0KPiAgIG5kY3RsLCB1dGlsOiBhZGQgaW5pcGFyc2Vy
IGhlbHBlcg0KPiAgIG5kY3RsLCB1dGlsOiBhZGQgcGFyc2UtY29uZmlncyBoZWxwZXINCj4gICBu
ZGN0bDogbWFrZSBuZGN0bCBzdXBwb3J0IGNvbmZpZ3VyYXRpb24gZmlsZXMNCj4gICBuZGN0bCwg
Y29uZmlnOiBhZGQgdGhlIGRlZmF1bHQgbmRjdGwgY29uZmlndXJhdGlvbiBmaWxlDQo+ICAgbmRj
dGwsIG1vbml0b3I6IHJlZmF0b3IgbW9uaXRvciBmb3Igc3VwcG9ydGluZyBtdWx0aXBsZSBjb25m
aWcgZmlsZXMNCj4gDQo+IFZpc2hhbCBWZXJtYSAoNyk6DQo+ICAgbmRjdGw6IFVwZGF0ZSBuZGN0
bC5zcGVjLmluIGZvciAnbmRjdGwuY29uZicNCj4gICBkYXhjdGw6IERvY3VtZW50YXRpb24gdXBk
YXRlcyBmb3IgcGVyc2lzdGVudCByZWNvbmZpZ3VyYXRpb24NCj4gICB1dGlsL3BhcnNlLWNvbmZp
ZzogcmVmYWN0b3IgZmlsdGVyX2NvbmZfZmlsZXMgaW50byB1dGlsLw0KPiAgIGRheGN0bDogYWRk
IGJhc2ljIGNvbmZpZyBwYXJzaW5nIHN1cHBvcnQNCj4gICB1dGlsL3BhcnNlLWNvbmZpZ3M6IGFk
ZCBhIGtleS92YWx1ZSBzZWFyY2ggaGVscGVyDQo+ICAgZGF4Y3RsL2RldmljZS5jOiBhZGQgYW4g
b3B0aW9uIGZvciBnZXR0aW5nIHBhcmFtcyBmcm9tIGEgY29uZmlnIGZpbGUNCj4gICBkYXhjdGw6
IGFkZCBzeXN0ZW1kIHNlcnZpY2UgYW5kIHVkZXYgcnVsZSBmb3IgYXV0b21hdGljDQo+ICAgICBy
ZWNvbmZpZ3VyYXRpb24NCj4gDQo+ICAuLi4vZGF4Y3RsL2RheGN0bC1yZWNvbmZpZ3VyZS1kZXZp
Y2UudHh0ICAgICAgfCAgNzUgKysNCj4gIERvY3VtZW50YXRpb24vbmRjdGwvbmRjdGwtbW9uaXRv
ci50eHQgICAgICAgICB8ICAgOCArLQ0KPiAgY29uZmlndXJlLmFjICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDE4ICstDQo+ICBNYWtlZmlsZS5hbSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgIDggKy0NCj4gIG5kY3RsL2xpYi9wcml2YXRlLmggICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBkYXhjdGwvbGliL2xpYmRheGN0bC5jICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgMzkgKw0KPiAgbmRjdGwvbGliL2xpYm5kY3RsLmMgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDM5ICsNCj4gIGRheGN0bC9saWJkYXhjdGwuaCAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+ICBuZGN0bC9saWJuZGN0bC5oICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKw0KPiAgdXRpbC9kaWN0aW9uYXJ5LmggICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTc1ICsrKysNCj4gIHV0aWwvaW5pcGFyc2VyLmgg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDM2MCArKysrKysrKw0KPiAgdXRpbC9wYXJz
ZS1jb25maWdzLmggICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDUzICsrDQo+ICBkYXhjdGwv
ZGF4Y3RsLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgZGF4Y3Rs
L2RldmljZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTc0ICsrKy0NCj4gIG5k
Y3RsL21vbml0b3IuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3MyArLQ0KPiAg
bmRjdGwvbmRjdGwuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4g
IHV0aWwvZGljdGlvbmFyeS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDM4MyArKysr
KysrKw0KPiAgdXRpbC9pbmlwYXJzZXIuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ODM4ICsrKysrKysrKysrKysrKysrKw0KPiAgdXRpbC9wYXJzZS1jb25maWdzLmMgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgMTUwICsrKysNCj4gIERvY3VtZW50YXRpb24vZGF4Y3RsL01ha2Vm
aWxlLmFtICAgICAgICAgICAgICB8ICAxMSArLQ0KPiAgRG9jdW1lbnRhdGlvbi9uZGN0bC9NYWtl
ZmlsZS5hbSAgICAgICAgICAgICAgIHwgICAyICstDQo+ICBkYXhjdGwvOTAtZGF4Y3RsLWRldmlj
ZS5ydWxlcyAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgZGF4Y3RsL01ha2VmaWxlLmFtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA5ICsNCj4gIGRheGN0bC9kYXhkZXYtcmVjb25m
aWd1cmVALnNlcnZpY2UgICAgICAgICAgICB8ICAgOCArDQo+ICBkYXhjdGwvbGliL01ha2VmaWxl
LmFtICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDYgKw0KPiAgZGF4Y3RsL2xpYi9saWJkYXhj
dGwuc3ltICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsNCj4gIG5kY3RsLnNwZWMuaW4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ICBuZGN0bC9NYWtlZmlsZS5h
bSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDkgKy0NCj4gIG5kY3RsL2xpYi9NYWtl
ZmlsZS5hbSAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNiArDQo+ICBuZGN0bC9saWIvbGli
bmRjdGwuc3ltICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKw0KPiAgbmRjdGwvbmRjdGwu
Y29uZiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDU2ICsrDQo+ICAzMSBmaWxlcyBj
aGFuZ2VkLCAyNDY3IGluc2VydGlvbnMoKyksIDQ5IGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHV0aWwvZGljdGlvbmFyeS5oDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdXRpbC9p
bmlwYXJzZXIuaA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHV0aWwvcGFyc2UtY29uZmlncy5oDQo+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgdXRpbC9kaWN0aW9uYXJ5LmMNCj4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCB1dGlsL2luaXBhcnNlci5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdXRpbC9wYXJzZS1j
b25maWdzLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkYXhjdGwvOTAtZGF4Y3RsLWRldmljZS5y
dWxlcw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRheGN0bC9kYXhkZXYtcmVjb25maWd1cmVALnNl
cnZpY2UNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBuZGN0bC9uZGN0bC5jb25mDQo+IA0KPiANCj4g
YmFzZS1jb21taXQ6IDRlNjQ2ZmE0OTBiYTRiNzgyYWZhMTg4ZGQ4ODE4Yjk0YzQxOTkyNGUNCg0K

