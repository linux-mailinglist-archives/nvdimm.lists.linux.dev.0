Return-Path: <nvdimm+bounces-5858-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8FC6AD946
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Mar 2023 09:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83822280A7E
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Mar 2023 08:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3373291F;
	Tue,  7 Mar 2023 08:31:07 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2077.outbound.protection.outlook.com [40.107.255.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF228F4
	for <nvdimm@lists.linux.dev>; Tue,  7 Mar 2023 08:31:04 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjShs7rO0QUqyjkh1Gbu6PRznWjzcBImPGz4lU+RI6oay1zjRqaYOh1sWt87tgEhU5fgT6XsOCva6ZnUmrPmUws436oaetPh5gbTZoGjiC+tfVZXElkGs+xZ28Fdrplhm0laKJdBgAf6STguYkL99+iC7q87D5/pm/ALySnk4dLF4CfPLA2LfRo5hytkKN/kwAafAINgFHhWN8FCwRqjNJCKGZHTcqdOS8mWiPd+sw81i6sIgVm+HzoGTznR7uTFEEvVRnn+DK49KZwf8yUFOofpYuCzTWg/7eqRduBnQyBzGOa5DwSmLsup/S2KMNXLFLPag1HPIqDUZmzr+IiGlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVYC/ATmOlI03Qy58c4yBzp3ZGWyKhQ8HcGK6Dw537I=;
 b=C1WDjmgNwhQ++SdwODXQKLjJXKLNcKaohL4te81h0jflVVMIHqwb8mSVzcE+tAJ5O/tTeZIc0h4qPrOCY56aQxtDEaLXLM1kLN6VdoO9vBlrps+0y2E3yQRiVwpaxP3GpSZJ3ONNtMXahiIOfo7OJr0c/ZlNN7lKccX/jTaRf5+cU08NtbSy5bpnKvstMS085vHY5RFIssXJ3GjaeXwF38iwDfvBEupnaTBh/6q758vuPv60ID6MRYns0Px3qtTQ8Ug3aeWP3ZXTPpRlBjsWj4dxb+46z1hsnADDt0Ov8NK4Pr2EAjuyG1e5OMjY0dZ5hpYZS4Da5s491zktOlIWyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVYC/ATmOlI03Qy58c4yBzp3ZGWyKhQ8HcGK6Dw537I=;
 b=XTSsJTuEfu+zzBVQ4HioiYuJulwTj0ku+kqtUUhJ0Bg22Nr+zrxhcB6QYGJb2izl9uxUm6d5AgYD6dTTDE0mSXkSKMhoW3piMSp/w5g/50n34Y6+gtF8EZPQdGqdqgpV2/+V2vjra8ebFvsWYZIwg/sXiTMdwcdyoLtaa4D4+0E=
Received: from TYYPR01MB6777.jpnprd01.prod.outlook.com (2603:1096:400:cc::9)
 by OSRPR01MB11660.jpnprd01.prod.outlook.com (2603:1096:604:232::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Tue, 7 Mar
 2023 08:31:02 +0000
Received: from TYYPR01MB6777.jpnprd01.prod.outlook.com
 ([fe80::f6f9:d4c2:1196:131e]) by TYYPR01MB6777.jpnprd01.prod.outlook.com
 ([fe80::f6f9:d4c2:1196:131e%8]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 08:31:01 +0000
From: =?utf-8?B?SEFHSU8gS0FaVUhJVE8o6JCp5bC+44CA5LiA5LuBKQ==?=
	<k-hagio-ab@nec.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
CC: Baoquan He <bhe@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Topic: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Index: AQHZR0+Bi1lA/ErA5EK0zxLjybbH0K7uo9aAgAAMWACAAF99AA==
Date: Tue, 7 Mar 2023 08:31:01 +0000
Message-ID: <c269bea4-ef81-f66f-e171-435175468229@nec.com>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <1fecbb60-d9f1-908c-31c9-16a3c890cf3f@nec.com>
 <19f1578d-476d-53cd-a9ff-166ff3d2bc80@fujitsu.com>
In-Reply-To: <19f1578d-476d-53cd-a9ff-166ff3d2bc80@fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYYPR01MB6777:EE_|OSRPR01MB11660:EE_
x-ms-office365-filtering-correlation-id: 62c83ef4-10b2-4021-b7ec-08db1ee648fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 yidzfoqhoUoQrtgWrF3QeJsF38xCyRPf/5riUtntOEYXfO1rv+OmV3M1oXry683qDf5XBMI+rnuNDcaxaIBOs+rHnchblqkZLEZRwq1QQKe9XcBcpp2bKGvgnWLHnnT0mzibjhD0KxYTdkoeIef23Pg1tgZzoEbpG+h8YczrmcANuvto/EBRs56WVh5QwTgRwwxtdqS8OZycku0PaSIHQgKJN6BvxIRLcfzWKCwrv9tAvkOjetergvPCgTp7IoPxT/c54qxqcRbEJX4nrj0sJF/LH8JeZmgAqtK2vHzDubl866nRuKejYVi3N77cyy1A7kyiMEyKy0Xc7kIQ61lcNC5ulnJGXyqFAJYOdA1fsdooixEEzZz6cl5ApgAxLYwxt62eR6PHfSTQyfKShvAsRdmiXO9mcG7bO83BNHjjBR9QGNWBztZZVMK3PIOjwzChEsC8kROKUZnL45swbwxuRydlY/T4R4Cj6KQkV5sGURGJxUH7XfLwJwjRsFBSc+AZXbegP+hCc5pkDhOg5nUmdBYf2Typc+RqgguofQbeF5JuREcrX4r9ycDO5EqeouNmNM3uqYwntXKmsU2ZmoaGOfQvL0m+I8za2D4/k8x9ZJNplf/avFDcsA3eKSeOcZI2/m0JBOqVFEi5Inncv02U6FB7yeXetcSoNTF3Pdvy4Ksseb97aWkqAKmZ6mRB33KJ9QgWdrsodD76BD14KUEtgLkt+G/bQwJBtwk84b2uSb0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB6777.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(55236004)(966005)(2616005)(53546011)(6512007)(6506007)(76116006)(186003)(31686004)(478600001)(26005)(6486002)(64756008)(316002)(66946007)(66556008)(66446008)(110136005)(8676002)(4326008)(66476007)(54906003)(83380400001)(41300700001)(122000001)(2906002)(5660300002)(38100700002)(7416002)(82960400001)(8936002)(85182001)(38070700005)(66899018)(31696002)(71200400001)(36756003)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cTNWeE5FT0xLSlYrYWFCRzRicmdZRjNHajFoNng5dnR0QUUzRzNIQVU4bk1U?=
 =?utf-8?B?WXgzanJwWmc0Yi95NnBSWWloRzBIUklLWGV3dmdMQ3RNVDIrb0V3Uk5jOTBm?=
 =?utf-8?B?cnMzOWtGcDJDRDVZSTF6eER5QXNJL2NwV210QTh1YnNHWDg4eGxwaGpNdXdB?=
 =?utf-8?B?T1Awc29ldHNXM2lKRHZVV2dGb3RKTmxTTDFVZGhhZ2NIZE5jVTVoVmhOQWlw?=
 =?utf-8?B?NWg4dGpQMDJEQWVDT2pwVFJVdFF2ZEVQWVFiQVN4OGUrUjU4WWJHMncxOVVw?=
 =?utf-8?B?ZnU5bTdtSmZndVY5Qnc0Q3ZsbnAzRGx5TmdlUm1MN25mblFKSTY4c3FiZ0pY?=
 =?utf-8?B?c1JNNXgvVjdWMXorbis1VVh3TXJ1K1hFZzFXcEpUOW9UUFd3TzEwcjFMVnFF?=
 =?utf-8?B?ZFlaL3NqOGJ1K3QvQlZHRWZuVDU0aGs5VkQ3cGQ2Vlh5YldaTWFlSXVlb3g1?=
 =?utf-8?B?aEJRRFcxSTBsYXR3VDZqME8raDJ5ZGdhcWxrS1NPL1ZpdzlaaVlqUGp1ODY1?=
 =?utf-8?B?TTBtbjJ0UmorZG5tWFk4UTMwZXgrUGl3OHhaWTNSK291QWlFK1FCUXErakNt?=
 =?utf-8?B?aE4yRkE4M0VzeDFyOU5PaUwySWU4NDZqUmVReUZ4M2dhSzJjelFTVFB0a0U1?=
 =?utf-8?B?dzc2U1FZMWpVQXZXd2xhK21IWE9DWmYycy9QY3FTTm5manhzSDI2WHRRWVZj?=
 =?utf-8?B?NElPVU51cE81QWRuSlEwSW8xZmNmcHMyTGlVMktmSmN3SmJNL2l2RjRHVjVs?=
 =?utf-8?B?Q1M1bFdzNjZFaXhkY2xCMXZXYVQxa09QbllTNWNjRVlVSDRkaFpRK3NZZU5O?=
 =?utf-8?B?U1Frcit1bDQvUUx1UW44N1pHTVd0aFlpeVk3NXp0OVdxa1JwQW83TEQzMFFt?=
 =?utf-8?B?VE1YdzY3RXdHcHZJRzhQVEFBc3hsVEZQckEvUTI4cGNWSjNSOGNWUCtLbE05?=
 =?utf-8?B?WGo5RFdXLzhZTjJuUGc3VVpPbm5XdUc5ZTJkUVUrZ2lHR2RQYUZtVGZpcVFa?=
 =?utf-8?B?eWNWTmkvMkJKSkRMalVsQlJaR2ozbXYrZUtZdmt0MFVzZ1cxNmRzTXZVSm5P?=
 =?utf-8?B?ZkdGOXJic3p6VDRzQjZ0R0FEb2ZYVk0zM3paenRIbU1acnN1TE9qZWhQZzFN?=
 =?utf-8?B?THppREE5MnFzWEp4OWRRekZqck5uTk1waFovWVBaOUsxY1FPaWswd1pQM2dO?=
 =?utf-8?B?dVg0dFJqUnd4ZEduOGQ2RXA0a2pzYlIxcTUzRldEL3hUdGNhMlNKSXlud3Nj?=
 =?utf-8?B?dXpYNWhzTCs1Tk4rZ0NGSEpYNGxhandQVW9UZUtQNTFKaG1XNkZSdHJ1dEkw?=
 =?utf-8?B?eEtDVnJ6b2dRM1BMdXA2K1djbkxFUEJ5OGY5dnlvVHp5d3lFUUF2UjhQTFM1?=
 =?utf-8?B?d2Y4UXlGUmVJeUU3WEE5V0x0a2l1dnJDSFhLbThVQUJQc0NYWFBPYk92cGFT?=
 =?utf-8?B?QUxkRUM3ZkprSTI0RmdvajU1c04vZ3FMeEJPdnN5TEhYdktPKzlvRWhXOHdO?=
 =?utf-8?B?amhhRVFoMTBSbXlkcWtGK01jR2d4VW56bUR2WDhaWXUvN3NWTFI1Vm1XdlA0?=
 =?utf-8?B?cVh5T1pVSS9GZWgxNjRKa1FWaXZJV2E2NXIvbGlqc09lSThhWnorTlhMV01Y?=
 =?utf-8?B?aWlqN0Rod29tZTkyenJXYjhSRjNtMFdncWpKWUZmVHpkQmhURnNHNlVMMFJH?=
 =?utf-8?B?ZkRqVXY3dDlmd3BRTTY4cWF2aXlaZCswKzNzUUlDMG9JUWh6bEgwNHJIT3J4?=
 =?utf-8?B?ZWN0S3NEMGE0akxDcERPZjJwMSs0U3M4SjRJc01rWDVidGhObFZ5amRFZHpw?=
 =?utf-8?B?SWV0d0xFVm5TVjdBSzBjTVh1NzZuUXRjVmhOOGV3WUNQUEJ3b2dLSitna0Vn?=
 =?utf-8?B?cXhJWXpXd0paRWhGMXRQM3dhYk9qNTBrbTExeDNYaTB5Q0ZDZkFlcUs3eCsr?=
 =?utf-8?B?ZUJoUUhoWHRISjlZOXNNQUQwVlhjUnpuV3BxT0Y3NGFSKzIrSVRJclJsQ09h?=
 =?utf-8?B?WXhoaGwvVVI4OW1mbE00TlZBbTZJdWZPVjV6UThZUGVPamFnbHh3aHJZK1Qy?=
 =?utf-8?B?ZEI5cysyZzN5M2ZnTTkzVGJDZ0xSeFlTN2EwY0NURGpuOUhaYWNYRmhpa3M4?=
 =?utf-8?B?NnFSQUgzUGNuSWpiZ2gva3pmUExTc2lLbG9zTjN6WmY0OW5pektId05wZ2ND?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB0CD447A9211246B2A0889A02691461@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB6777.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c83ef4-10b2-4021-b7ec-08db1ee648fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 08:31:01.8396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoP9nHiQ14Yi3/iNLN/gWvaBMcrb598gSe4OqrEINMKejzMDwwveZ74DpSe3VJaAb32ihLlOXW6JIqEMBFDR8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSRPR01MB11660

T24gMjAyMy8wMy8wNyAxMTo0OSwgbGl6aGlqaWFuQGZ1aml0c3UuY29tIHdyb3RlOg0KPiBPbiAw
Ny8wMy8yMDIzIDEwOjA1LCBIQUdJTyBLQVpVSElUTyjokKnlsL4g5LiA5LuBKSB3cm90ZToNCj4+
IE9uIDIwMjMvMDIvMjMgMTU6MjQsIGxpemhpamlhbkBmdWppdHN1LmNvbSB3cm90ZToNCj4+PiBI
ZWxsbyBmb2xrcywNCj4+Pg0KPj4+IFRoaXMgbWFpbCByYWlzZXMgYSBwbWVtIG1lbW1hcCBkdW1w
IHJlcXVpcmVtZW50IGFuZCBwb3NzaWJsZSBzb2x1dGlvbnMsIGJ1dCB0aGV5IGFyZSBhbGwgc3Rp
bGwgcHJlbWF0dXJlLg0KPj4+IEkgcmVhbGx5IGhvcGUgeW91IGNhbiBwcm92aWRlIHNvbWUgZmVl
ZGJhY2suDQo+Pj4NCj4+PiBwbWVtIG1lbW1hcCBjYW4gYWxzbyBiZSBjYWxsZWQgcG1lbSBtZXRh
ZGF0YSBoZXJlLg0KPj4+DQo+Pj4gIyMjIEJhY2tncm91bmQgYW5kIG1vdGl2YXRlIG92ZXJ2aWV3
ICMjIw0KPj4+IC0tLQ0KPj4+IENyYXNoIGR1bXAgaXMgYW4gaW1wb3J0YW50IGZlYXR1cmUgZm9y
IHRyb3VibGUgc2hvb3Rpbmcgb2Yga2VybmVsLiBJdCBpcyB0aGUgZmluYWwgd2F5IHRvIGNoYXNl
IHdoYXQNCj4+PiBoYXBwZW5lZCBhdCB0aGUga2VybmVsIHBhbmljLCBzbG93ZG93biwgYW5kIHNv
IG9uLiBJdCBpcyB0aGUgbW9zdCBpbXBvcnRhbnQgdG9vbCBmb3IgY3VzdG9tZXIgc3VwcG9ydC4N
Cj4+PiBIb3dldmVyLCBhIHBhcnQgb2YgZGF0YSBvbiBwbWVtIGlzIG5vdCBpbmNsdWRlZCBpbiBj
cmFzaCBkdW1wLCBpdCBtYXkgY2F1c2UgZGlmZmljdWx0eSB0byBhbmFseXplDQo+Pj4gdHJvdWJs
ZSBhcm91bmQgcG1lbSAoZXNwZWNpYWxseSBGaWxlc3lzdGVtLURBWCkuDQo+Pj4NCj4+Pg0KPj4+
IEEgcG1lbSBuYW1lc3BhY2UgaW4gImZzZGF4IiBvciAiZGV2ZGF4IiBtb2RlIHJlcXVpcmVzIGFs
bG9jYXRpb24gb2YgcGVyLXBhZ2UgbWV0YWRhdGFbMV0uIFRoZSBhbGxvY2F0aW9uDQo+Pj4gY2Fu
IGJlIGRyYXduIGZyb20gZWl0aGVyIG1lbShzeXN0ZW0gbWVtb3J5KSBvciBkZXYocG1lbSBkZXZp
Y2UpLCBzZWUgYG5kY3RsIGhlbHAgY3JlYXRlLW5hbWVzcGFjZWAgZm9yDQo+Pj4gbW9yZSBkZXRh
aWxzLiBJbiBmc2RheCwgc3RydWN0IHBhZ2UgYXJyYXkgYmVjb21lcyB2ZXJ5IGltcG9ydGFudCwg
aXQgaXMgb25lIG9mIHRoZSBrZXkgZGF0YSB0byBmaW5kDQo+Pj4gc3RhdHVzIG9mIHJldmVyc2Ug
bWFwLg0KPj4+DQo+Pj4gU28sIHdoZW4gbWV0YWRhdGEgd2FzIHN0b3JlZCBpbiBwbWVtLCBldmVu
IHBtZW0ncyBwZXItcGFnZSBtZXRhZGF0YSB3aWxsIG5vdCBiZSBkdW1wZWQuIFRoYXQgbWVhbnMN
Cj4+PiB0cm91Ymxlc2hvb3RlcnMgYXJlIHVuYWJsZSB0byBjaGVjayBtb3JlIGRldGFpbHMgYWJv
dXQgcG1lbSBmcm9tIHRoZSBkdW1wZmlsZS4NCj4+Pg0KPj4+ICMjIyBNYWtlIHBtZW0gbWVtbWFw
IGR1bXAgc3VwcG9ydCAjIyMNCj4+PiAtLS0NCj4+PiBPdXIgZ29hbCBpcyB0aGF0IHdoZXRoZXIg
bWV0YWRhdGEgaXMgc3RvcmVkIG9uIG1lbSBvciBwbWVtLCBpdHMgbWV0YWRhdGEgY2FuIGJlIGR1
bXBlZCBhbmQgdGhlbiB0aGUNCj4+PiBjcmFzaC11dGlsaXRpZXMgY2FuIHJlYWQgbW9yZSBkZXRh
aWxzIGFib3V0IHRoZSBwbWVtLiBPZiBjb3Vyc2UsIHRoaXMgZmVhdHVyZSBjYW4gYmUgZW5hYmxl
ZC9kaXNhYmxlZC4NCj4+Pg0KPj4+IEZpcnN0LCBiYXNlZCBvbiBvdXIgcHJldmlvdXMgaW52ZXN0
aWdhdGlvbiwgYWNjb3JkaW5nIHRvIHRoZSBsb2NhdGlvbiBvZiBtZXRhZGF0YSBhbmQgdGhlIHNj
b3BlIG9mDQo+Pj4gZHVtcCwgd2UgY2FuIGRpdmlkZSBpdCBpbnRvIHRoZSBmb2xsb3dpbmcgZm91
ciBjYXNlczogQSwgQiwgQywgRC4NCj4+PiBJdCBzaG91bGQgYmUgbm90ZWQgdGhhdCBhbHRob3Vn
aCB3ZSBtZW50aW9uZWQgY2FzZSBBJkIgYmVsb3csIHdlIGRvIG5vdCB3YW50IHRoZXNlIHR3byBj
YXNlcyB0byBiZQ0KPj4+IHBhcnQgb2YgdGhpcyBmZWF0dXJlLCBiZWNhdXNlIGR1bXBpbmcgdGhl
IGVudGlyZSBwbWVtIHdpbGwgY29uc3VtZSBhIGxvdCBvZiBzcGFjZSwgYW5kIG1vcmUgaW1wb3J0
YW50bHksDQo+Pj4gaXQgbWF5IGNvbnRhaW4gdXNlciBzZW5zaXRpdmUgZGF0YS4NCj4+Pg0KPj4+
ICstLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KPj4+IHxcKy0tLS0tLS0t
K1wgICAgIG1ldGFkYXRhIGxvY2F0aW9uICAgfA0KPj4+IHwgICAgICAgICAgICArKy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tKw0KPj4+IHwgZHVtcCBzY29wZSAgfCAgbWVtICAgICB8ICAgUE1FTSAg
ICAgfA0KPj4+ICstLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KPj4+IHwg
ZW50aXJlIHBtZW0gfCAgICAgQSAgICB8ICAgICBCICAgICAgfA0KPj4+ICstLS0tLS0tLS0tLS0t
Ky0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KPj4+IHwgbWV0YWRhdGEgICAgfCAgICAgQyAgICB8
ICAgICBEICAgICAgfA0KPj4+ICstLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
Kw0KPj4+DQo+Pj4gQ2FzZSBBJkI6IHVuc3VwcG9ydGVkDQo+Pj4gLSBPbmx5IHRoZSByZWdpb25z
IGxpc3RlZCBpbiBQVF9MT0FEIGluIHZtY29yZSBhcmUgZHVtcGFibGUuIFRoaXMgY2FuIGJlIHJl
c29sdmVkIGJ5IGFkZGluZyB0aGUgcG1lbQ0KPj4+IHJlZ2lvbiBpbnRvIHZtY29yZSdzIFBUX0xP
QURzIGluIGtleGVjLXRvb2xzLg0KPj4+IC0gRm9yIG1ha2VkdW1wZmlsZSB3aGljaCB3aWxsIGFz
c3VtZSB0aGF0IGFsbCBwYWdlIG9iamVjdHMgb2YgdGhlIGVudGlyZSByZWdpb24gZGVzY3JpYmVk
IGluIFBUX0xPQURzDQo+Pj4gYXJlIHJlYWRhYmxlLCBhbmQgdGhlbiBza2lwcy9leGNsdWRlcyB0
aGUgc3BlY2lmaWMgcGFnZSBhY2NvcmRpbmcgdG8gaXRzIGF0dHJpYnV0ZXMuIEJ1dCBpbiB0aGUg
Y2FzZQ0KPj4+IG9mIHBtZW0sIDFzdCBrZXJuZWwgb25seSBhbGxvY2F0ZXMgcGFnZSBvYmplY3Rz
IGZvciB0aGUgbmFtZXNwYWNlcyBvZiBwbWVtLCBzbyBtYWtlZHVtcGZpbGUgd2lsbCB0aHJvdw0K
Pj4+IGVycm9yc1syXSB3aGVuIHNwZWNpZmljIC1kIG9wdGlvbnMgYXJlIHNwZWNpZmllZC4NCj4+
PiBBY2NvcmRpbmdseSwgd2Ugc2hvdWxkIG1ha2UgbWFrZWR1bXBmaWxlIHRvIGlnbm9yZSB0aGVz
ZSBlcnJvcnMgaWYgaXQncyBwbWVtIHJlZ2lvbi4NCj4+Pg0KPj4+IEJlY2F1c2UgdGhlc2UgYWJv
dmUgY2FzZXMgYXJlIG5vdCBpbiBvdXIgZ29hbCwgd2UgbXVzdCBjb25zaWRlciBob3cgdG8gcHJl
dmVudCB0aGUgZGF0YSBwYXJ0IG9mIHBtZW0NCj4+PiBmcm9tIHJlYWRpbmcgYnkgdGhlIGR1bXAg
YXBwbGljYXRpb24obWFrZWR1bXBmaWxlKS4NCj4+Pg0KPj4+IENhc2UgQzogbmF0aXZlIHN1cHBv
cnRlZA0KPj4+IG1ldGFkYXRhIGlzIHN0b3JlZCBpbiBtZW0sIGFuZCB0aGUgZW50aXJlIG1lbS9y
YW0gaXMgZHVtcGFibGUuDQo+Pj4NCj4+PiBDYXNlIEQ6IHVuc3VwcG9ydGVkICYmIG5lZWQgeW91
ciBpbnB1dA0KPj4+IFRvIHN1cHBvcnQgdGhpcyBzaXR1YXRpb24sIHRoZSBtYWtlZHVtcGZpbGUg
bmVlZHMgdG8ga25vdyB0aGUgbG9jYXRpb24gb2YgbWV0YWRhdGEgZm9yIGVhY2ggcG1lbQ0KPj4+
IG5hbWVzcGFjZSBhbmQgdGhlIGFkZHJlc3MgYW5kIHNpemUgb2YgbWV0YWRhdGEgaW4gdGhlIHBt
ZW0gW3N0YXJ0LCBlbmQpDQo+Pj4NCj4+PiBXZSBoYXZlIHRob3VnaHQgb2YgYSBmZXcgcG9zc2li
bGUgb3B0aW9uczoNCj4+Pg0KPj4+IDEpIEluIHRoZSAybmQga2VybmVsLCB3aXRoIHRoZSBoZWxw
IG9mIHRoZSBpbmZvcm1hdGlvbiBmcm9tIC9zeXMvYnVzL25kL2RldmljZXMve25hbWVzcGFjZVgu
WSwgZGF4WC5ZLCBwZm5YLll9DQo+Pj4gZXhwb3J0ZWQgYnkgcG1lbSBkcml2ZXJzLCBtYWtlZHVt
cGZpbGUgaXMgYWJsZSB0byBjYWxjdWxhdGUgdGhlIGFkZHJlc3MgYW5kIHNpemUgb2YgbWV0YWRh
dGENCj4+PiAyKSBJbiB0aGUgMXN0IGtlcm5lbCwgYWRkIGEgbmV3IHN5bWJvbCB0byB0aGUgdm1j
b3JlLiBUaGUgc3ltYm9sIGlzIGFzc29jaWF0ZWQgd2l0aCB0aGUgbGF5b3V0IG9mDQo+Pj4gZWFj
aCBuYW1lc3BhY2UuIFRoZSBtYWtlZHVtcGZpbGUgcmVhZHMgdGhlIHN5bWJvbCBhbmQgZmlndXJl
cyBvdXQgdGhlIGFkZHJlc3MgYW5kIHNpemUgb2YgdGhlIG1ldGFkYXRhLg0KPj4NCj4+IEhpIFpo
aWppYW4sDQo+Pg0KPj4gc29ycnksIHByb2JhYmx5IEkgZG9uJ3QgdW5kZXJzdGFuZCBlbm91Z2gs
IGJ1dCBkbyB0aGVzZSBtZWFuIHRoYXQNCj4+ICAgICAxLiAvcHJvYy92bWNvcmUgZXhwb3J0cyBw
bWVtIHJlZ2lvbnMgd2l0aCBQVF9MT0FEcywgd2hpY2ggY29udGFpbg0KPj4gICAgICAgIHVucmVh
ZGFibGUgb25lcywgYW5kDQo+PiAgICAgMi4gbWFrZWR1bXBmaWxlIGdldHMgdG8ga25vdyB0aGUg
cmVhZGFibGUgcmVnaW9ucyBzb21laG93Pw0KPiANCj4gS2F6dSwNCj4gDQo+IEdlbmVyYWxseSwg
b25seSBtZXRhZGF0YSBvZiBwbWVtIGlzIHJlYWRhYmxlIGJ5IGNyYXNoLXV0aWxpdGllcywgYmVj
YXVzZSBtZXRhZGF0YSBjb250YWlucyBpdHMgb3duIG1lbW1hcChwYWdlIGFycmF5KS4NCj4gVGhl
IHJlc3QgcGFydCBvZiBwbWVtIHdoaWNoIGNvdWxkIGJlIHVzZWQgYXMgYSBibG9jayBkZXZpY2Uo
REFYIGZpbGVzeXN0ZW0pIG9yIG90aGVyIHB1cnBvc2UsIHNvIGl0J3Mgbm90IG11Y2ggaGVscGZ1
bA0KPiBmb3IgdGhlIHRyb3VibGVzaG9vdGluZy4NCj4gDQo+IEluIG15IHVuZGVyc3RhbmRpbmcs
IFBUX0xPQURzIGlzIHBhcnQgb2YgRUxGIGZvcm1hdCwgaXQgY29tcGxpZXMgd2l0aCB3aGF0IGl0
J3MuDQo+IEluIG15IGN1cnJlbnQgdGhvdWdodHMsDQo+IDEuIGNyYXNoLXRvb2wgd2lsbCBleHBv
cnQgdGhlIGVudGlyZSBwbWVtIHJlZ2lvbiB0byAvcHJvYy92bWNvcmUuIG1ha2VkdW1wZmlsZS9j
cCBldGMgY29tbWFuZHMgY2FuIHJlYWQgdGhlIGVudGlyZQ0KPiBwbWVtIHJlZ2lvbiBkaXJlY3Rs
eS4NCj4gMi4gZXhwb3J0IHRoZSBuYW1lc3BhY2UgbGF5b3V0IHRvIHZtY29yZSBhcyBhIHN5bWJv
bCwgdGhlbiBkdW1waW5nIGFwcGxpY2F0aW9ucyhtYWtlZHVtcGZpbGUpIGNhbiBmaWd1cmUgb3V0
IHdoZXJlDQo+IHRoZSBtZXRhZGF0YSBpcywgYW5kIHJlYWQgbWV0YWRhdGEgb25seS4NCg0KQWgg
Z290IGl0LCBUaGFua3MhDQoNCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBtYWtlZHVtcGZpbGUv
Y3Agd2lsbCBiZSBhYmxlIHRvIHJlYWQgdGhlIGVudGlyZQ0KcG1lbSwgYnV0IHdpdGggc29tZSBt
YWtlZHVtcGZpbGUgLWQgb3B0aW9uIHZhbHVlcyBpdCBjYW5ub3QgZ2V0IHRoZQ0KcGh5c2ljYWwg
YWRkcmVzcyBvZiBzdHJ1Y3QgcGFnZSBmb3IgZGF0YSBwYWdlcyBhbmQgdGhyb3dzIGFuIGVycm9y
LiAgU28NCnlvdSB0aGluayB0aGVyZSB3aWxsIGJlIG5lZWQgdG8gZXhwb3J0IHRoZSByYW5nZXMg
b2YgYWxsb2NhdGVkIG1ldGFkYXRhLg0KDQpUaGFua3MsDQpLYXp1DQoNCj4gDQo+IE5vdCBzdXJl
IHdoZXRoZXIgdGhlIHJlcGx5IGlzIGhlbHBmdWwsIGlmIHlvdSBoYXZlIGFueSBvdGhlciBxdWVz
dGlvbnMsIGZlZWwgZnJlZSB0byBsZXQgbWUga25vdy4gOikNCj4gDQo+IA0KPiBUaGFua3MNCj4g
Wmhpamlhbg0KPiANCj4+DQo+PiBUaGVuIC9wcm9jL3ZtY29yZSB3aXRoIHBtZW0gY2Fubm90IGJl
IGNhcHR1cmVkIGJ5IG90aGVyIGNvbW1hbmRzLA0KPj4gZS5nLiBjcCBjb21tYW5kPw0KPj4NCj4+
IFRoYW5rcywNCj4+IEthenUNCj4+DQo+Pj4gMykgb3RoZXJzID8NCj4+Pg0KPj4+IEJ1dCB0aGVu
IHdlIGZvdW5kIHRoYXQgd2UgaGF2ZSBhbHdheXMgaWdub3JlZCBhIHVzZXIgY2FzZSwgdGhhdCBp
cywgdGhlIHVzZXIgY291bGQgc2F2ZSB0aGUgZHVtcGZpbGUNCj4+PiB0byB0aGUgcG1lbS4gTmVp
dGhlciBvZiB0aGVzZSB0d28gb3B0aW9ucyBjYW4gc29sdmUgdGhpcyBwcm9ibGVtLCBiZWNhdXNl
IHRoZSBwbWVtIGRyaXZlcnMgd2lsbA0KPj4+IHJlLWluaXRpYWxpemUgdGhlIG1ldGFkYXRhIGR1
cmluZyB0aGUgcG1lbSBkcml2ZXJzIGxvYWRpbmcgcHJvY2Vzcywgd2hpY2ggbGVhZHMgdG8gdGhl
IG1ldGFkYXRhDQo+Pj4gd2UgZHVtcGVkIGlzIGluY29uc2lzdGVudCB3aXRoIHRoZSBtZXRhZGF0
YSBhdCB0aGUgbW9tZW50IG9mIHRoZSBjcmFzaCBoYXBwZW5pbmcuDQo+Pj4gU2ltcGx5LCBjYW4g
d2UganVzdCBkaXNhYmxlIHRoZSBwbWVtIGRpcmVjdGx5IGluIDJuZCBrZXJuZWwgc28gdGhhdCBw
cmV2aW91cyBtZXRhZGF0YSB3aWxsIG5vdCBiZQ0KPj4+IGRlc3Ryb3llZD8gQnV0IHRoaXMgb3Bl
cmF0aW9uIHdpbGwgYnJpbmcgdXMgaW5jb252ZW5pZW5jZSB0aGF0IDJuZCBrZXJuZWwgZG9lc27i
gJl0IGFsbG93IHVzZXIgc3RvcmluZw0KPj4+IGR1bXBmaWxlIG9uIHRoZSBmaWxlc3lzdGVtL3Bh
cnRpdGlvbiBiYXNlZCBvbiBwbWVtLg0KPj4+DQo+Pj4gU28gaGVyZSBJIGhvcGUgeW91IGNhbiBw
cm92aWRlIHNvbWUgaWRlYXMgYWJvdXQgdGhpcyBmZWF0dXJlL3JlcXVpcmVtZW50IGFuZCBvbiB0
aGUgcG9zc2libGUgc29sdXRpb24NCj4+PiBmb3IgdGhlIGNhc2VzIEEmQiZEIG1lbnRpb25lZCBh
Ym92ZSwgaXQgd291bGQgYmUgZ3JlYXRseSBhcHByZWNpYXRlZC4NCj4+Pg0KPj4+IElmIEnigJlt
IG1pc3Npbmcgc29tZXRoaW5nLCBmZWVsIGZyZWUgdG8gbGV0IG1lIGtub3cuIEFueSBmZWVkYmFj
ayAmIGNvbW1lbnQgYXJlIHZlcnkgd2VsY29tZS4NCj4+Pg0KPj4+DQo+Pj4gWzFdIFBtZW0gcmVn
aW9uIGxheW91dDoNCj4+PiAgICAgICBePC0tbmFtZXNwYWNlMC4wLS0tLT5ePC0tbmFtZXNwYWNl
MC4xLS0tLS0tPl4NCj4+PiAgICAgICB8ICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgIHwNCj4+PiAgICAgICArLS0rbS0tLS0tLS0tLS0tLS0tLS0rLS0rbS0tLS0tLS0t
LS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0rLSthDQo+Pj4gICAgICAgfCsrfGUgICAg
ICAgICAgICAgICAgfCsrfGUgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAg
fCt8bA0KPj4+ICAgICAgIHwrK3x0ICAgICAgICAgICAgICAgIHwrK3x0ICAgICAgICAgICAgICAg
ICAgfCAgICAgICAgICAgICAgICAgICAgIHwrfGkNCj4+PiAgICAgICB8Kyt8YSAgICAgICAgICAg
ICAgICB8Kyt8YSAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xnDQo+
Pj4gICAgICAgfCsrfGQgIG5hbWVzcGFjZTAuMCAgfCsrfGQgIG5hbWVzcGFjZTAuMSAgICB8ICAg
ICB1bi1hbGxvY2F0ZWQgICAgfCt8bg0KPj4+ICAgICAgIHwrK3xhICAgIGZzZGF4ICAgICAgIHwr
K3xhICAgICBkZXZkYXggICAgICAgfCAgICAgICAgICAgICAgICAgICAgIHwrfG0NCj4+PiAgICAg
ICB8Kyt8dCAgICAgICAgICAgICAgICB8Kyt8dCAgICAgICAgICAgICAgICAgIHwgICAgICAgICAg
ICAgICAgICAgICB8K3xlDQo+Pj4gICAgICAgKy0tK2EtLS0tLS0tLS0tLS0tLS0tKy0tK2EtLS0t
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tKy0rbg0KPj4+ICAgICAgIHwgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfHQNCj4+PiAgICAgICB2PC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tcG1lbSByZWdpb24t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPnYNCj4+Pg0KPj4+IFsyXSBodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1tbS83MEY5NzFDRi0xQTk2LTREODctQjcwQy1COTcxQzJBMTc0
N0NAcm9jLmNzLnVtYXNzLmVkdS9ULw0KPj4+DQo+Pj4NCj4+PiBUaGFua3MNCj4+PiBaaGlqaWFu

