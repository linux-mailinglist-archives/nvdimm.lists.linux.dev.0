Return-Path: <nvdimm+bounces-4712-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 197AE5B571C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Sep 2022 11:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4D71C20932
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Sep 2022 09:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A496E1FBC;
	Mon, 12 Sep 2022 09:22:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3B7F
	for <nvdimm@lists.linux.dev>; Mon, 12 Sep 2022 09:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1662974548; x=1694510548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/uSm+ZwQnZVn5yD1BeNQ35GYB5av+Hs69k8+nuTxINQ=;
  b=wiIwWUbDiE/s4AiHC94HBYH0bfqkI2npUinK7rV+SOfeBQab9+Xn2X2t
   dqewSG1ef9jhbxAguU0bcpdSIEwAvBu9jNTz3zgdpo8q0kPhBJDs7O2nS
   Mk/+tVqZfOHPp+TFTBMhXI9ExsaF2zfsBOT+JwNtLchsPkjHWUM1GI0cU
   FpRJCUxQUWwmRtv+LSSSbwqA/SvMldPI2hdC6vgm+MaKhe/CQg7QNugwf
   S6By0qu7HxQwEBT9MPBlpMxAM6HY5Js2E4tw+PMGDswCTMP6SD13nwY+k
   610pnt0EbS5FRBaYlQG4NMD0Wtwp9NRzNP/koJB9Ca07FVzB7Gs6U4Pu4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="64998592"
X-IronPort-AV: E=Sophos;i="5.93,308,1654527600"; 
   d="scan'208";a="64998592"
Received: from mail-os0jpn01lp2107.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.107])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:21:16 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ/EsGVcBEiEj2Hhc21SRqltuOYjjtqdpkD0Ym6VbzCVd83BW08gY0RaFY7/nTtexRl2on8A9NIE0qbF08RENl+ExwTA6NIKkiVHHyJ5YAmCDRgYhR1CZLRtu6A+3R8k1x4tdDAAhjeuM1muiBbcvpEghYi0QTvOZpw9IovnThgtgvnPkAMpHD4CviDlSrLZCi9rV+S8kTXYxA4jxWES3Hvj39KRB/qE1fkqJ42wcPb4NKHF8yiluzDQJeNnKQzHaYzYOaFeZFy4B4CSev3G4H0NojgbB8wwd7XDqn/wD/k/8cVTyrdNG4QN/XStLpckBvosYvs0ZvGuU9Xjy/ix8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uSm+ZwQnZVn5yD1BeNQ35GYB5av+Hs69k8+nuTxINQ=;
 b=HZJcjTbLojCcAE9v+vwybvu8WNCGWcWBdx9ru31vSXftEgunFBNOCYLTcXR27o8Kt5iOa26jt2sl5AnwA+GF/OMm7h1jCDH5CwjKpRVdEn6AHHuD5HP1ZBurYTswluOLUdHmXnrQvtOPTfYOKD8+ky6U3FKt8/PVErwxpJibLogc7K6lSVEYtDvEjKnEZxMbMarxrLML8ADZU0KATBNZI8D16bQhQi7tMA8YpKayWhbC9mTQ9XYVAWFWWAi/gwJKeb1KLnPwNETLu2UZepu4EArIzorLpPsOGNpOrGkZ5O1SGJItvasJIdikKiwZtzqbY0eVB1SE1Wgqo/5EGXvqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB8455.jpnprd01.prod.outlook.com (2603:1096:400:15d::13)
 by TY3PR01MB10516.jpnprd01.prod.outlook.com (2603:1096:400:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 09:21:13 +0000
Received: from TYCPR01MB8455.jpnprd01.prod.outlook.com
 ([fe80::d023:d89d:54f5:631a]) by TYCPR01MB8455.jpnprd01.prod.outlook.com
 ([fe80::d023:d89d:54f5:631a%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 09:21:12 +0000
From: "matsuda-daisuke@fujitsu.com" <matsuda-daisuke@fujitsu.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"leonro@nvidia.com" <leonro@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rpearsonhpe@gmail.com" <rpearsonhpe@gmail.com>, "yangx.jy@fujitsu.com"
	<yangx.jy@fujitsu.com>, "y-goto@fujitsu.com" <y-goto@fujitsu.com>
Subject: RE: [RFC PATCH 0/7] RDMA/rxe: On-Demand Paging on SoftRoCE
Thread-Topic: [RFC PATCH 0/7] RDMA/rxe: On-Demand Paging on SoftRoCE
Thread-Index: AQHYwmOzpZdRkdIQi0a3gnTpfBllbK3WbdSAgAUcRmA=
Date: Mon, 12 Sep 2022 09:21:12 +0000
Message-ID:
 <TYCPR01MB8455E233E662F1B5C305A020E5449@TYCPR01MB8455.jpnprd01.prod.outlook.com>
References: <cover.1662461897.git.matsuda-daisuke@fujitsu.com>
 <f4da3894-488b-fc6a-fa04-482f1354865a@fujitsu.com>
In-Reply-To: <f4da3894-488b-fc6a-fa04-482f1354865a@fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-securitypolicycheck: OK by SHieldMailChecker v2.5.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20170217
x-shieldmailcheckermailid: d9db9688db934c66a8fc587abc50bb59
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfRW5hYmxlZD10cnVlOyBNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJh?=
 =?utf-8?B?Yy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRlPTIwMjItMDktMTJUMDk6MjE6?=
 =?utf-8?B?MDlaOyBNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0?=
 =?utf-8?B?ZmVjZTA1MF9NZXRob2Q9U3RhbmRhcmQ7IE1TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?utf-8?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX05hbWU9RlVKSVRTVS1SRVNU?=
 =?utf-8?B?UklDVEVE4oCLOyBNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9TaXRlSWQ9YTE5ZjEyMWQtODFlMS00ODU4LWE5ZDgt?=
 =?utf-8?B?NzM2ZTI2N2ZkNGM3OyBNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1h?=
 =?utf-8?B?YjRkLTNiMGY0ZmVjZTA1MF9BY3Rpb25JZD0xODFiYTc4Mi0wNGVhLTQzNzUt?=
 =?utf-8?B?OTI2Ny01MDM5ZDJkMjEzNDQ7IE1TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00?=
 =?utf-8?B?MmFjLWFiNGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA=?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB8455:EE_|TY3PR01MB10516:EE_
x-ms-office365-filtering-correlation-id: 22517ba4-e94c-422a-075b-08da94a022ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 vHsYlwF/BriQxJOvnriiBFh6jH1oFjhCMI2Lj8YldD2UwuVi9Lx3EW2A8BfWOVZqY65q7ZWYJD9Hn2SRzAQXVnavWPO0o9Fg27Nawuh5QajEl+rvOj53CMRfNqL/ovvs//W/1+nz6Fs0JRPx2uFtwlK3T9szbBUAlJ4mrkva24xrkXFYNiGr+wys9aMztEgQuA+ig2n3fqvWZTEor07ZaMgQqoVR4BWqs4U37dFq5nhmed746ZejzGAmK3YK+gJxAVu3FTjHIPnJ4g6NDFqXhjC4WMotsxeIZvVETOi0VDSEhbJVjnLNxwGv+ijoWJUh3GAC3jKAiVOHT7hNUAzpFpvm2ngDFqWCEXucdKnJYn64G4Nv4htRkiX4+ENG2EkJH77lZtAy80Ml6M6DjYUeKJCy0exZYUkzdiZKpgyp+VZ9uJls2EFYnf9tOaJlAe8p4EOo0jP9HGsDZM6sjJgG1p2mvEOteE0He6Rd5a84Ti4MQ6tBCmJHxI4AzXKPhkRHu2hyikQ4CTAjBbtV1J/wm8kBz7lvu3EVvQXBLT+f1dlrLH76D5g4n0rERHhIkp7jVBnsb8gotNQ1Xn+gVeae73XQNuVxdnsgr/fPDK49VJRUngM9nqhaKsh3Ruv7bJUMvFVweDVIyAAT8sK2L7RgACZ93aOnfbie4e6qy9dE7Tm1WP1SvN0fHYFX9Vr8bviHqxRuAEaN5roYZLtd/NEsPTVfpdRG9bKjJrFoxLdFgTzJyk25o1ZGvHm4WDabBu7u11ETDgwqUZwbmxJza7kRo5t8LGzMFLi6CRvhb5p4ZdMT7mSscK01UPHc9lOnjuf2h+ShR5wzCscBQI06x7oNzwgMGO0GQADImImDoHv2T+A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB8455.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(6029001)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(1590799006)(8936002)(2906002)(33656002)(82960400001)(186003)(83380400001)(8676002)(64756008)(85182001)(66476007)(4326008)(52536014)(66556008)(55016003)(76116006)(66946007)(110136005)(54906003)(66446008)(38100700002)(316002)(5660300002)(41300700001)(6506007)(1580799003)(478600001)(966005)(71200400001)(38070700005)(26005)(9686003)(53546011)(86362001)(107886003)(7696005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?djVoS2ZiMHltaWR1NjhCYjg0NU9HS0kxbGFWbkt4SG5MN2psSHRpSnNRakxl?=
 =?utf-8?B?bmRaSkJPTWFtVnc2YzlSYjNZSytjRFB5c2ZtN2YrU0xtcmMwcEJGRHpKTWFV?=
 =?utf-8?B?Z3VmT3RpMEM3M3hHcmJxSWZvUndzV3d4UGFicTRWditqNFc4a085ZC9UOXQx?=
 =?utf-8?B?d0crWCtESmVCcGRVUC9MMU9RUHpTWVdaRlg4UCtPZ2NYbzFkSjZwR2t1TEg4?=
 =?utf-8?B?a2MzTTFiSjU0dDc1c01tKzhDMWZ1STY1dmtwR2dzM0tvSHYvMU9MdVp6Qnly?=
 =?utf-8?B?em0wQTQ5MzBNNUVGcTVGaHM0NXQrdzc3b1hYVE5WcmRnaWE1OFBGZFNnT3E0?=
 =?utf-8?B?dkRPa2NGYmM1V0tHMzR2UE0zai9FQUliRDlleW9BQzlJSHRQNTRlSHZydGlQ?=
 =?utf-8?B?VlNzc1cxM3pORTZmRTc5R0tHMUgwTVRwQUVsZlNCR0lOazJqUUtrMUJIVndB?=
 =?utf-8?B?NFhVaTY3UGNIU3dNMDV5VUd5ZDFoWTllTkNmU3QzSElFT2Y1SFJ0d3dTejlo?=
 =?utf-8?B?a3d1NC9mWlVDVDJzYnIrbXZwNERmU0pNM29xT3FZNWlNd2huNjZTanQzQ2xW?=
 =?utf-8?B?Rm1ncW9lNE1uMiswcmlreC9abFc4a2huOFYxeEZ5RkhtSXk1bndBQ0NDa0FN?=
 =?utf-8?B?NDRsMUxpeXlhQjlLM3pHcVBHRXgwdEpuWG9rbEUwclFxWkxJTXQyTEdadlNq?=
 =?utf-8?B?ZHYvNm5zaHhyVkx6ak5VaHMzd1RISU1VSzdvSlorblZxL0JuWlRmNHhZRDVx?=
 =?utf-8?B?czZFTjVsbjJXUGNNY1lYc3NmUytkSGY0S2IrRzNCSTVrU09YYzFXZUNGQkdz?=
 =?utf-8?B?QVFkZW1jVTQ4NzIyM2JWQzQwR1RlMS9Ndnp1VG1rZk9XejdwUC90UXFldjFj?=
 =?utf-8?B?YnJxS0lqTlB5N2VWellvWlJ2VjVZMU5jZ3NsU2hocHdYdy9hbktSSUhabFNa?=
 =?utf-8?B?Y1ZjaVI0OUI3Q2ExaFRVb3FyZk5KM0RZcEpvSjZubkhuVTRoMHFWQTZpYlk0?=
 =?utf-8?B?VDBEQnJudDA0YjRoaU5sbDNXM2h1TkRPVEFSNVBzRWJiOXNMK3RVZUZtTjNE?=
 =?utf-8?B?OFdjR3pvdDMwOFA5VEdXOTQ3NzRCOEk0MGkwTzRJQ3JXRWIya1VvSHR6ZWtD?=
 =?utf-8?B?UlZVNll3eE5rdUJGVTBDUjlUWUJPcFU3a1pQU0E3WlVFaTRzS2pWb2p2SlNI?=
 =?utf-8?B?bDR4Wjg4cW4wRVFXQWhLY3NHWUlBOG5INDVlWlBXSzUrblkybzR4TGpDWTIy?=
 =?utf-8?B?cGRpNmticElaWE9XUUI2NVFqUzdpSU83ZElLSDR0ZWFLMkp3SE9lWjJ5UUlI?=
 =?utf-8?B?Z3FNaGtobGhyYzJoaVFRTUxnRFBiK3ZLd1pnVFlhNWplT3hkbVhvY25KZmF1?=
 =?utf-8?B?cjNrY0pEOWx1UUx4S1B1djFXQnRkQkxUcWEyUUUzandrV1BFR1U1b2wvMmV3?=
 =?utf-8?B?cjdmY1VkOVdMbEMwcUcvdjJicHh0OTJRZDE5T21uN0FzdldXaGJtT2J1Wi95?=
 =?utf-8?B?UHMzRTVoNE9pVkdpVCs4aVcyWXZIR0RPWlI1WHdyMmI3Mm9Wdzdva3lyTTc1?=
 =?utf-8?B?NTdPSUw2U2hvb3RpU1FabjBiV3V4ZThHK1llMnB5Zjg1N1ZlTGlGU01TTlBq?=
 =?utf-8?B?Z0s5ak5aL2drWWYwb3hCQXEzeUZMQjJIMGVPQ2NGa0hVQStNK3Nmc0dLQm9q?=
 =?utf-8?B?blZRMTRtd2NySzB3RkVDQmFHZkpZU2xjVFNRWDNVV2lOOGJ1cVVKVVRIcW5Z?=
 =?utf-8?B?TWNWWkRVWHMvQkpyVE9BRHRJMzlNZGxzR0pXS2xCWkdnL3FGbFhKL0daTXNp?=
 =?utf-8?B?Nm5kVFp3dWZTMTZzY1Z2YjNZaTZLbzJVV05EdzVaMzkxMGFHMVM0a0RjSXdW?=
 =?utf-8?B?UE4wZWVqeDh0VTRISTZFUFlYTkhZMk5zTEdEcnhwVXVJZUgwVGhjc2FVUXRK?=
 =?utf-8?B?MGV5cGh6VlBpL0FVbnpuQ00xbmZZc2tkd1l6OVEzc3UvOS9jdGdnYkdPY3JF?=
 =?utf-8?B?b29aYS84bGZweUtDaDRQNlIzMWNEaDByRm5ScFF5WDdEWlpVbmdyRVNtbG50?=
 =?utf-8?B?Z2V0N2l5djJtRmZZREhWcGwvalY4dGhYRk5FQnVNa1BQYTFqRkNodUFkMGpv?=
 =?utf-8?B?ajBDcVZCR3pwcW40a1EzWjk4M09wZFF2ditmZzEyU3c1bTFGV0ZBOGphWTJa?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB8455.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22517ba4-e94c-422a-075b-08da94a022ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 09:21:12.7424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQwvSdG9GOl8a/1n3PaUZEGClhB5YFRT4d6WcB7NWz7Hz1ZXWdznPUhAFOsPggBitZSQ3dG6A8NRwlku6+BP7cjMyGQBxSvb9YYP25AF6M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10516

T24gRnJpLCBTZXAgOSwgMjAyMiAxMjowOCBQTSBMaSwgWmhpamlhbiB3cm90ZToNCj4gDQo+IERh
aXN1a2UNCj4gDQo+IEdyZWF0IGpvYi4NCj4gDQo+IEkgbG92ZSB0aGlzIGZlYXR1cmUsIGJlZm9y
ZSBzdGFydGluZyByZXZpZXdpbmcgeW91IHBhdGNoZXMsIGkgdGVzdGVkIGl0IHdpdGggUUVNVSh3
aXRoIGZzZGF4IG1lbW9yeS1iYWNrZW5kKSBtaWdyYXRpb24NCj4gb3ZlciBSRE1BIHdoZXJlIGl0
IHdvcmtlZCBmb3IgTUxYNSBiZWZvcmUuDQoNClRoYW5rIHlvdSBmb3IgdGhlIHRyeSENCkFueWJv
ZHkgaW50ZXJlc3RlZCBpbiB0aGUgZmVhdHVyZSBjYW4gZ2V0IHRoZSBSRkMgdHJlZSBmcm9tIG15
IGdpdGh1Yi4NCmh0dHBzOi8vZ2l0aHViLmNvbS9kYWltYXRzdWRhL2xpbnV4L3RyZWUvb2RwX3Jm
Yw0KDQo+IA0KPiBUaGlzIHRpbWUsIHdpdGggeW91IE9EUCBwYXRjaGVzLCBpdCB3b3JrcyBvbiBS
WEUgdGhvdWdoIGlidl9hZHZpc2VfbXIgbWF5IGJlIG5vdCB5ZXQgcmVhZHkuDQoNCmlidl9hZHZp
c2VfbXIoMykgaXMgd2hhdCBJIHJlZmVycmVkIHRvIGFzIHByZWZldGNoIGZlYXR1cmUuIEN1cnJl
bnRseSwgbGliaWJ2ZXJicyBhbHdheXMgcmV0dXJucw0KRU9QTk9UU1VQUCBlcnJvci4gV2UgbmVl
ZCB0byBpbXBsZW1lbnQgdGhlIGZlYXR1cmUgaW4gcnhlIGRyaXZlciBhbmQgYWRkIGEgaGFuZGxl
ciB0byB1c2UNCml0IGZyb20gbGlicnhlIGluIHRoZSBmdXR1cmUuDQoNClRoYW5rcywNCkRhaXN1
a2UNCg0KPiANCj4gDQo+IFRoYW5rcw0KPiBaaGlqaWFuDQo+IA0KPiANCj4gT24gMDcvMDkvMjAy
MiAxMDo0MiwgRGFpc3VrZSBNYXRzdWRhIHdyb3RlOg0KPiA+IEhpIGV2ZXJ5b25lLA0KPiA+DQo+
ID4gVGhpcyBwYXRjaCBzZXJpZXMgaW1wbGVtZW50cyB0aGUgT24tRGVtYW5kIFBhZ2luZyBmZWF0
dXJlIG9uIFNvZnRSb0NFKHJ4ZSkNCj4gPiBkcml2ZXIsIHdoaWNoIGhhcyBiZWVuIGF2YWlsYWJs
ZSBvbmx5IGluIG1seDUgZHJpdmVyWzFdIHNvIGZhci4NCj4gPg0KPiA+IFtPdmVydmlld10NCj4g
PiBXaGVuIGFwcGxpY2F0aW9ucyByZWdpc3RlciBhIG1lbW9yeSByZWdpb24oTVIpLCBSRE1BIGRy
aXZlcnMgbm9ybWFsbHkgcGluDQo+ID4gcGFnZXMgaW4gdGhlIE1SIHNvIHRoYXQgcGh5c2ljYWwg
YWRkcmVzc2VzIGFyZSBuZXZlciBjaGFuZ2VkIGR1cmluZyBSRE1BDQo+ID4gY29tbXVuaWNhdGlv
bi4gVGhpcyByZXF1aXJlcyB0aGUgTVIgdG8gZml0IGluIHBoeXNpY2FsIG1lbW9yeSBhbmQNCj4g
PiBpbmV2aXRhYmx5IGxlYWRzIHRvIG1lbW9yeSBwcmVzc3VyZS4gT24gdGhlIG90aGVyIGhhbmQs
IE9uLURlbWFuZCBQYWdpbmcNCj4gPiAoT0RQKSBhbGxvd3MgYXBwbGljYXRpb25zIHRvIHJlZ2lz
dGVyIE1ScyB3aXRob3V0IHBpbm5pbmcgcGFnZXMuIFRoZXkgYXJlDQo+ID4gcGFnZWQtaW4gd2hl
biB0aGUgZHJpdmVyIHJlcXVpcmVzIGFuZCBwYWdlZC1vdXQgd2hlbiB0aGUgT1MgcmVjbGFpbXMu
IEFzIGENCj4gPiByZXN1bHQsIGl0IGlzIHBvc3NpYmxlIHRvIHJlZ2lzdGVyIGEgbGFyZ2UgTVIg
dGhhdCBkb2VzIG5vdCBmaXQgaW4gcGh5c2ljYWwNCj4gPiBtZW1vcnkgd2l0aG91dCB0YWtpbmcg
dXAgc28gbXVjaCBwaHlzaWNhbCBtZW1vcnkuDQo+ID4NCj4gPiBbV2h5IHRvIGFkZCB0aGlzIGZl
YXR1cmU/XQ0KPiA+IFdlLCBGdWppdHN1LCBoYXZlIGNvbnRyaWJ1dGVkIHRvIFJETUEgd2l0aCBh
IHZpZXcgdG8gdXNpbmcgaXQgd2l0aA0KPiA+IHBlcnNpc3RlbnQgbWVtb3J5LiBQZXJzaXN0ZW50
IG1lbW9yeSBjYW4gaG9zdCBhIGZpbGVzeXN0ZW0gdGhhdCBhbGxvd3MNCj4gPiBhcHBsaWNhdGlv
bnMgdG8gcmVhZC93cml0ZSBmaWxlcyBkaXJlY3RseSB3aXRob3V0IGludm9sdmluZyBwYWdlIGNh
Y2hlLg0KPiA+IFRoaXMgaXMgY2FsbGVkIEZTLURBWChmaWxlc3lzdGVtIGRpcmVjdCBhY2Nlc3Mp
IG1vZGUuIFRoZXJlIGlzIGEgcHJvYmxlbQ0KPiA+IHRoYXQgZGF0YSBvbiBEQVgtZW5hYmxlZCBm
aWxlc3lzdGVtIGNhbm5vdCBiZSBkdXBsaWNhdGVkIHdpdGggc29mdHdhcmUgUkFJRA0KPiA+IG9y
IG90aGVyIGhhcmR3YXJlIG1ldGhvZHMuIERhdGEgcmVwbGljYXRpb24gd2l0aCBSRE1BLCB3aGlj
aCBmZWF0dXJlcw0KPiA+IGhpZ2gtc3BlZWQgY29ubmVjdGlvbnMsIGlzIHRoZSBiZXN0IHNvbHV0
aW9uIGZvciB0aGUgcHJvYmxlbS4NCj4gPg0KPiA+IEhvd2V2ZXIsIHRoZXJlIGlzIGEga25vd24g
aXNzdWUgdGhhdCBoaW5kZXJzIHVzaW5nIFJETUEgd2l0aCBGUy1EQVguIFdoZW4NCj4gPiBSRE1B
IG9wZXJhdGlvbnMgdG8gYSBmaWxlIGFuZCB1cGRhdGUgb2YgdGhlIGZpbGUgbWV0YWRhdGEgYXJl
IHByb2Nlc3NlZA0KPiA+IGNvbmN1cnJlbnRseSBvbiB0aGUgc2FtZSBub2RlLCBpbGxlZ2FsIG1l
bW9yeSBhY2Nlc3NlcyBjYW4gYmUgZXhlY3V0ZWQsDQo+ID4gZGlzcmVnYXJkaW5nIHRoZSB1cGRh
dGVkIG1ldGFkYXRhLiBUaGlzIGlzIGJlY2F1c2UgUkRNQSBvcGVyYXRpb25zIGRvIG5vdA0KPiA+
IGdvIHRocm91Z2ggcGFnZSBjYWNoZSBidXQgYWNjZXNzIGRhdGEgZGlyZWN0bHkuIFRoZXJlIHdh
cyBhbiBlZmZvcnRbMl0gdG8NCj4gPiBzb2x2ZSB0aGlzIHByb2JsZW0sIGJ1dCBpdCB3YXMgcmVq
ZWN0ZWQgaW4gdGhlIGVuZC4gVGhvdWdoIHRoZXJlIGlzIG5vDQo+ID4gZ2VuZXJhbCBzb2x1dGlv
biBhdmFpbGFibGUsIGl0IGlzIHBvc3NpYmxlIHRvIHdvcmsgYXJvdW5kIHRoZSBwcm9ibGVtIHVz
aW5nDQo+ID4gdGhlIE9EUCBmZWF0dXJlIHRoYXQgaGFzIGJlZW4gYXZhaWxhYmxlIG9ubHkgaW4g
bWx4NS4gT0RQIGVuYWJsZXMgZHJpdmVycw0KPiA+IHRvIHVwZGF0ZSBtZXRhZGF0YSBiZWZvcmUg
cHJvY2Vzc2luZyBSRE1BIG9wZXJhdGlvbnMuDQo+ID4NCj4gPiBXZSBoYXZlIGVuaGFuY2VkIHRo
ZSByeGUgdG8gZXhwZWRpdGUgdGhlIHVzYWdlIG9mIHBlcnNpc3RlbnQgbWVtb3J5LiBPdXINCj4g
PiBjb250cmlidXRpb24gdG8gcnhlIGluY2x1ZGVzIFJETUEgQXRvbWljIHdyaXRlWzNdIGFuZCBS
RE1BIEZsdXNoWzRdLiBXaXRoDQo+ID4gdGhlbSBiZWluZyBtZXJnZWQgdG8gcnhlIGFsb25nIHdp
dGggT0RQLCBhbiBlbnZpcm9ubWVudCB3aWxsIGJlIHJlYWR5IGZvcg0KPiA+IGRldmVsb3BlcnMg
dG8gY3JlYXRlIGFuZCB0ZXN0IHNvZnR3YXJlIGZvciBSRE1BIHdpdGggRlMtREFYLiBUaGVyZSBp
cyBhDQo+ID4gbGlicmFyeShsaWJycG1hKVs1XSBiZWluZyBkZXZlbG9wZWQgZm9yIHRoaXMgcHVy
cG9zZS4gVGhpcyBlbnZpcm9ubWVudA0KPiA+IGNhbiBiZSB1c2VkIGJ5IGFueWJvZHkgd2l0aG91
dCBhbnkgc3BlY2lhbCBoYXJkd2FyZSBidXQgYW4gb3JkaW5hcnkNCj4gPiBjb21wdXRlciB3aXRo
IGEgbm9ybWFsIE5JQyB0aG91Z2ggaXQgaXMgaW5mZXJpb3IgdG8gaGFyZHdhcmUNCj4gPiBpbXBs
ZW1lbnRhdGlvbnMgaW4gdGVybXMgb2YgcGVyZm9ybWFuY2UuDQo+ID4NCj4gPiBbRGVzaWduIGNv
bnNpZGVyYXRpb25zXQ0KPiA+IE9EUCBoYXMgYmVlbiBhdmFpbGFibGUgb25seSBpbiBtbHg1LCBi
dXQgZnVuY3Rpb25zIGFuZCBkYXRhIHN0cnVjdHVyZXMNCj4gPiB0aGF0IGNhbiBiZSB1c2VkIGNv
bW1vbmx5IGFyZSBwcm92aWRlZCBpbiBpYl91dmVyYnMoaW5maW5pYmFuZC9jb3JlKS4gVGhlDQo+
ID4gaW50ZXJmYWNlIGlzIGhlYXZpbHkgZGVwZW5kZW50IG9uIEhNTSBpbmZyYXN0cnVjdHVyZVs2
XSwgYW5kIHRoaXMgcGF0Y2hzZXQNCj4gPiB1c2UgdGhlbSBhcyBtdWNoIGFzIHBvc3NpYmxlLiBX
aGlsZSBtbHg1IGhhcyBib3RoIEV4cGxpY2l0IGFuZCBJbXBsaWNpdCBPRFANCj4gPiBmZWF0dXJl
cyBhbG9uZyB3aXRoIHByZWZldGNoIGZlYXR1cmUsIHRoaXMgcGF0Y2hzZXQgaW1wbGVtZW50cyB0
aGUgRXhwbGljaXQNCj4gPiBPRFAgZmVhdHVyZSBvbmx5Lg0KPiA+DQo+ID4gQXMgYW4gaW1wb3J0
YW50IGNoYW5nZSwgaXQgaXMgbmVjZXNzYXJ5IHRvIGNvbnZlcnQgdHJpcGxlIHRhc2tsZXRzDQo+
ID4gKHJlcXVlc3RlciwgcmVzcG9uZGVyIGFuZCBjb21wbGV0ZXIpIHRvIHdvcmtxdWV1ZXMgYmVj
YXVzZSB0aGV5IG11c3QgYmUNCj4gPiBhYmxlIHRvIHNsZWVwIGluIG9yZGVyIHRvIHRyaWdnZXIg
cGFnZSBmYXVsdCBiZWZvcmUgYWNjZXNzaW5nIE1Scy4gSSBkaWQgYQ0KPiA+IHRlc3Qgc2hvd24g
aW4gdGhlIDJuZCBwYXRjaCBhbmQgZm91bmQgdGhhdCB0aGUgY2hhbmdlIG1ha2VzIHRoZSBsYXRl
bmN5DQo+ID4gaGlnaGVyIHdoaWxlIGltcHJvdmluZyB0aGUgYmFuZHdpZHRoLiBUaG91Z2ggaXQg
bWF5IGJlIHBvc3NpYmxlIHRvIGNyZWF0ZSBhDQo+ID4gbmV3IGluZGVwZW5kZW50IHdvcmtxdWV1
ZSBmb3IgcGFnZSBmYXVsdCBleGVjdXRpb24sIGl0IGlzIGEgbm90IHZlcnkNCj4gPiBzZW5zaWJs
ZSBzb2x1dGlvbiBzaW5jZSB0aGUgdGFza2xldHMgaGF2ZSB0byBidXN5LXdhaXQgaXRzIGNvbXBs
ZXRpb24gaW4NCj4gPiB0aGF0IGNhc2UuDQo+ID4NCj4gPiBJZiByZXNwb25kZXIgYW5kIGNvbXBs
ZXRlciBzbGVlcCwgaXQgYmVjb21lcyBtb3JlIGxpa2VseSB0aGF0IHBhY2tldCBkcm9wDQo+ID4g
b2NjdXJzIGJlY2F1c2Ugb2Ygb3ZlcmZsb3cgaW4gcmVjZWl2ZXIgcXVldWUuIFRoZXJlIGFyZSBt
dWx0aXBsZSBxdWV1ZXMNCj4gPiBpbnZvbHZlZCwgYnV0LCBhcyBTb2Z0Um9DRSB1c2VzIFVEUCwg
dGhlIG1vc3QgaW1wb3J0YW50IG9uZSB3b3VsZCBiZSB0aGUNCj4gPiBVRFAgYnVmZmVycy4gVGhl
IHNpemUgY2FuIGJlIGNvbmZpZ3VyZWQgaW4gbmV0LmNvcmUucm1lbV9kZWZhdWx0IGFuZA0KPiA+
IG5ldC5jb3JlLnJtZW1fbWF4IHN5c2NvbmZpZyBwYXJhbWV0ZXJzLiBVc2VycyBzaG91bGQgY2hh
bmdlIHRoZXNlIHZhbHVlcyBpbg0KPiA+IGNhc2Ugb2YgcGFja2V0IGRyb3AsIGJ1dCBwYWdlIGZh
dWx0IHdvdWxkIGJlIHR5cGljYWxseSBub3Qgc28gbG9uZyBhcyB0bw0KPiA+IGNhdXNlIHRoZSBw
cm9ibGVtLg0KPiA+DQo+ID4gW0hvdyBkb2VzIE9EUCB3b3JrP10NCj4gPiAic3RydWN0IGliX3Vt
ZW1fb2RwIiBpcyB1c2VkIHRvIG1hbmFnZSBwYWdlcy4gSXQgaXMgY3JlYXRlZCBmb3IgZWFjaA0K
PiA+IE9EUC1lbmFibGVkIE1SIG9uIGl0cyByZWdpc3RyYXRpb24uIFRoaXMgc3RydWN0IGhvbGRz
IGEgcGFpciBvZiBhcnJheXMNCj4gPiAoZG1hX2xpc3QvcGZuX2xpc3QpIHRoYXQgc2VydmUgYXMg
YSBkcml2ZXIgcGFnZSB0YWJsZS4gRE1BIGFkZHJlc3NlcyBhbmQNCj4gPiBQRk5zIGFyZSBzdG9y
ZWQgaW4gdGhlIGRyaXZlciBwYWdlIHRhYmxlLiBUaGV5IGFyZSB1cGRhdGVkIG9uIHBhZ2UtaW4g
YW5kDQo+ID4gcGFnZS1vdXQsIGJvdGggb2Ygd2hpY2ggdXNlIHRoZSBjb21tb24gaW50ZXJmYWNl
IGluIGliX3V2ZXJicy4NCj4gPg0KPiA+IFBhZ2UtaW4gY2FuIG9jY3VyIHdoZW4gcmVxdWVzdGVy
LCByZXNwb25kZXIgb3IgY29tcGxldGVyIGFjY2VzcyBhbiBNUiBpbg0KPiA+IG9yZGVyIHRvIHBy
b2Nlc3MgUkRNQSBvcGVyYXRpb25zLiBJZiB0aGV5IGZpbmQgdGhhdCB0aGUgcGFnZXMgYmVpbmcN
Cj4gPiBhY2Nlc3NlZCBhcmUgbm90IHByZXNlbnQgb24gcGh5c2ljYWwgbWVtb3J5IG9yIHJlcXVp
c2l0ZSBwZXJtaXNzaW9ucyBhcmUNCj4gPiBub3Qgc2V0IG9uIHRoZSBwYWdlcywgdGhleSBwcm92
b2tlIHBhZ2UgZmF1bHQgdG8gbWFrZSBwYWdlcyBwcmVzZW50IHdpdGgNCj4gPiBwcm9wZXIgcGVy
bWlzc2lvbnMgYW5kIGF0IHRoZSBzYW1lIHRpbWUgdXBkYXRlIHRoZSBkcml2ZXIgcGFnZSB0YWJs
ZS4gQWZ0ZXINCj4gPiBjb25maXJtaW5nIHRoZSBwcmVzZW5jZSBvZiB0aGUgcGFnZXMsIHRoZXkg
ZXhlY3V0ZSBtZW1vcnkgYWNjZXNzIHN1Y2ggYXMNCj4gPiByZWFkLCB3cml0ZSBvciBhdG9taWMg
b3BlcmF0aW9ucy4NCj4gPg0KPiA+IFBhZ2Utb3V0IGlzIHRyaWdnZXJlZCBieSBwYWdlIHJlY2xh
aW0gb3IgZmlsZXN5c3RlbSBldmVudHMgKGUuZy4gbWV0YWRhdGENCj4gPiB1cGRhdGUgb2YgYSBm
aWxlIHRoYXQgaXMgYmVpbmcgdXNlZCBhcyBhbiBNUikuIFdoZW4gY3JlYXRpbmcgYW4gT0RQLWVu
YWJsZWQNCj4gPiBNUiwgdGhlIGRyaXZlciByZWdpc3RlcnMgYW4gTU1VIG5vdGlmaWVyIGNhbGxi
YWNrLiBXaGVuIHRoZSBrZXJuZWwgaXNzdWVzIGENCj4gPiBwYWdlIGludmFsaWRhdGlvbiBub3Rp
ZmljYXRpb24sIHRoZSBjYWxsYmFjayBpcyBwcm92b2tlZCB0byB1bm1hcCBETUENCj4gPiBhZGRy
ZXNzZXMgYW5kIHVwZGF0ZSB0aGUgZHJpdmVyIHBhZ2UgdGFibGUuIEFmdGVyIHRoYXQsIHRoZSBr
ZXJuZWwgcmVsZWFzZXMNCj4gPiB0aGUgcGFnZXMuDQo+ID4NCj4gPiBbU3VwcG9ydGVkIG9wZXJh
dGlvbnNdDQo+ID4gQWxsIG9wZXJhdGlvbnMgYXJlIHN1cHBvcnRlZCBvbiBSQyBjb25uZWN0aW9u
LiBBdG9taWMgd3JpdGVbM10gYW5kIEZsdXNoWzRdDQo+ID4gb3BlcmF0aW9ucywgd2hpY2ggYXJl
IHN0aWxsIHVuZGVyIGRpc2N1c3Npb24sIGFyZSBhbHNvIGdvaW5nIHRvIGJlDQo+ID4gc3VwcG9y
dGVkIGFmdGVyIHRoZWlyIHBhdGNoZXMgYXJlIG1lcmdlZC4gT24gVUQgY29ubmVjdGlvbiwgU2Vu
ZCwgUmVjdiwNCj4gPiBTUlEtUmVjdiBhcmUgc3VwcG9ydGVkLiBCZWNhdXNlIG90aGVyIG9wZXJh
dGlvbnMgYXJlIG5vdCBzdXBwb3J0ZWQgb24gbWx4NSwNCj4gPiBJIHRha2UgYWZ0ZXIgdGhlIGRl
Y2lzaW9uIHJpZ2h0IG5vdy4NCj4gPg0KPiA+IFtIb3cgdG8gdGVzdCBPRFA/XQ0KPiA+IFRoZXJl
IGFyZSBvbmx5IGEgZmV3IHJlc291cmNlcyBhdmFpbGFibGUgZm9yIHRlc3RpbmcuIHB5dmVyYnMg
dGVzdGNhc2VzIGluDQo+ID4gcmRtYS1jb3JlIGFuZCBwZXJmdGVzdFs3XSBhcmUgcmVjb21tZW5k
YWJsZSBvbmVzLiBOb3RlIHRoYXQgeW91IG1heSBoYXZlIHRvDQo+ID4gYnVpbGQgcGVyZnRlc3Qg
ZnJvbSB1cHN0cmVhbSBzaW5jZSBvbGRlciB2ZXJzaW9ucyBkbyBub3QgaGFuZGxlIE9EUA0KPiA+
IGNhcGFiaWxpdGllcyBjb3JyZWN0bHkuDQo+ID4NCj4gPiBbRnV0dXJlIHdvcmtdDQo+ID4gTXkg
bmV4dCB3b3JrIHdpbGwgYmUgdGhlIHByZWZldGNoIGZlYXR1cmUuIEl0IGFsbG93cyBhcHBsaWNh
dGlvbnMgdG8NCj4gPiB0cmlnZ2VyIHBhZ2UgZmF1bHQgdXNpbmcgaWJ2X2FkdmlzZV9tcigzKSB0
byBvcHRpbWl6ZSBwZXJmb3JtYW5jZS4gU29tZQ0KPiA+IGV4aXN0aW5nIHNvZnR3YXJlIGxpa2Ug
bGlicnBtYSB1c2UgdGhpcyBmZWF0dXJlLiBBZGRpdGlvbmFsbHksIEkgdGhpbmsgd2UNCj4gPiBj
YW4gYWxzbyBhZGQgdGhlIGltcGxpY2l0IE9EUCBmZWF0dXJlIGluIHRoZSBmdXR1cmUuDQo+ID4N
Cj4gPiBbMV0gW1JGQyAwMC8yMF0gT24gZGVtYW5kIHBhZ2luZw0KPiA+IGh0dHBzOi8vd3d3LnNw
aW5pY3MubmV0L2xpc3RzL2xpbnV4LXJkbWEvbXNnMTg5MDYuaHRtbA0KPiA+DQo+ID4gWzJdIFtS
RkMgUEFUQ0ggdjIgMDAvMTldIFJETUEvRlMgREFYIHRydW5jYXRlIHByb3Bvc2FsIFYxLDAwMCww
MDIgOy0pDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbnZkaW1tLzIwMTkwODA5MjI1ODMz
LjY2NTctMS1pcmEud2VpbnlAaW50ZWwuY29tLw0KPiA+DQo+ID4gWzNdIFtSRVNFTkQgUEFUQ0gg
djUgMC8yXSBSRE1BL3J4ZTogQWRkIFJETUEgQXRvbWljIFdyaXRlIG9wZXJhdGlvbg0KPiA+IGh0
dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXJkbWEvbXNnMTExNDI4Lmh0bWwNCj4g
Pg0KPiA+IFs0XSBbUEFUQ0ggdjQgMC82XSBSRE1BL3J4ZTogQWRkIFJETUEgRkxVU0ggb3BlcmF0
aW9uDQo+ID4gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva2VybmVsL21zZzQ0NjIwNDUu
aHRtbA0KPiA+DQo+ID4gWzVdIGxpYnJwbWE6IFJlbW90ZSBQZXJzaXN0ZW50IE1lbW9yeSBBY2Nl
c3MgTGlicmFyeQ0KPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL3JwbWENCj4gPg0KPiA+IFs2
XSBIZXRlcm9nZW5lb3VzIE1lbW9yeSBNYW5hZ2VtZW50IChITU0pDQo+ID4gaHR0cHM6Ly93d3cu
a2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvbW0vaG1tLmh0bWwNCj4gPg0KPiA+IFs3XSBsaW51
eC1yZG1hL3BlcmZ0ZXN0OiBJbmZpbmliYW5kIFZlcmJzIFBlcmZvcm1hbmNlIFRlc3RzDQo+ID4g
aHR0cHM6Ly9naXRodWIuY29tL2xpbnV4LXJkbWEvcGVyZnRlc3QNCj4gPg0KPiA+IERhaXN1a2Ug
TWF0c3VkYSAoNyk6DQo+ID4gICAgSUIvbWx4NTogQ2hhbmdlIGliX3VtZW1fb2RwX21hcF9kbWFf
c2luZ2xlX3BhZ2UoKSB0byByZXRhaW4gdW1lbV9tdXRleA0KPiA+ICAgIFJETUEvcnhlOiBDb252
ZXJ0IHRoZSB0cmlwbGUgdGFza2xldHMgdG8gd29ya3F1ZXVlcw0KPiA+ICAgIFJETUEvcnhlOiBD
bGVhbnVwIGNvZGUgZm9yIHJlc3BvbmRlciBBdG9taWMgb3BlcmF0aW9ucw0KPiA+ICAgIFJETUEv
cnhlOiBBZGQgcGFnZSBpbnZhbGlkYXRpb24gc3VwcG9ydA0KPiA+ICAgIFJETUEvcnhlOiBBbGxv
dyByZWdpc3RlcmluZyBNUnMgZm9yIE9uLURlbWFuZCBQYWdpbmcNCj4gPiAgICBSRE1BL3J4ZTog
QWRkIHN1cHBvcnQgZm9yIFNlbmQvUmVjdi9Xcml0ZS9SZWFkIG9wZXJhdGlvbnMgd2l0aCBPRFAN
Cj4gPiAgICBSRE1BL3J4ZTogQWRkIHN1cHBvcnQgZm9yIHRoZSB0cmFkaXRpb25hbCBBdG9taWMg
b3BlcmF0aW9ucyB3aXRoIE9EUA0KPiA+DQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvY29yZS91
bWVtX29kcC5jICAgIHwgICA2ICstDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9v
ZHAuYyAgICAgIHwgICA0ICstDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL01ha2Vm
aWxlICAgIHwgICA1ICstDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZS5jICAg
ICAgIHwgIDE4ICsrDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9jb21wLmMg
IHwgIDQyICsrKy0NCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX2xvYy5oICAg
fCAgMTEgKy0NCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX21yLmMgICAgfCAg
IDcgKy0NCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX25ldC5jICAgfCAgIDQg
Ky0NCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX29kcC5jICAgfCAzMjkgKysr
KysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUv
cnhlX3BhcmFtLmggfCAgIDIgKy0NCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhl
X3FwLmMgICAgfCAgNjggKysrLS0tDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4
ZV9yZWN2LmMgIHwgICAyICstDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9y
ZXEuYyAgIHwgIDE0ICstDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9yZXNw
LmMgIHwgMTc1ICsrKysrKystLS0tLS0tDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhl
L3J4ZV9yZXNwLmggIHwgIDQ0ICsrKysNCj4gPiAgIGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUv
cnhlX3Rhc2suYyAgfCAxNTIgLS0tLS0tLS0tLS0tDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQv
c3cvcnhlL3J4ZV90YXNrLmggIHwgIDY5IC0tLS0tLQ0KPiA+ICAgZHJpdmVycy9pbmZpbmliYW5k
L3N3L3J4ZS9yeGVfdmVyYnMuYyB8ICAxNiArLQ0KPiA+ICAgZHJpdmVycy9pbmZpbmliYW5kL3N3
L3J4ZS9yeGVfdmVyYnMuaCB8ICAxMCArLQ0KPiA+ICAgZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4
ZS9yeGVfd3EuYyAgICB8IDE2MSArKysrKysrKysrKysrDQo+ID4gICBkcml2ZXJzL2luZmluaWJh
bmQvc3cvcnhlL3J4ZV93cS5oICAgIHwgIDcxICsrKysrKw0KPiA+ICAgMjEgZmlsZXMgY2hhbmdl
ZCwgODI0IGluc2VydGlvbnMoKyksIDM4NiBkZWxldGlvbnMoLSkNCj4gPiAgIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9vZHAuYw0KPiA+ICAgY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3Jlc3AuaA0KPiA+ICAg
ZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3Rhc2suYw0K
PiA+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3Rh
c2suaA0KPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUv
cnhlX3dxLmMNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2luZmluaWJhbmQvc3cv
cnhlL3J4ZV93cS5oDQo+ID4NCg0K

