Return-Path: <nvdimm+bounces-6012-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 824EA6FDBD5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 May 2023 12:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991271C20D19
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 May 2023 10:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AD76FA1;
	Wed, 10 May 2023 10:42:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa18.fujitsucc.c3s2.iphmx.com (esa18.fujitsucc.c3s2.iphmx.com [216.71.158.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495A8A5D
	for <nvdimm@lists.linux.dev>; Wed, 10 May 2023 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1683715377; x=1715251377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ax8Od0amGnP5TPEdVUVnCaa/50f5VRqGXtjyp9G6OEw=;
  b=akB6Oqo5Rqb+8t83JtMy1C3V2kb+FWbZWupfdS19575lJojQHt/N6iRP
   nGmTWafh5l54w7taXHTeOgSVkhUMoIJG0ctN7ajCrrCwuqtpiUPy4EZPG
   63G4P4yVtYgctUyCDx0GxUUVqgiqnYWX6o1RBpxGTSomnYvcHG4zvYcom
   hHflf3nNh9ML8ngaYCRRwVoSBIrAruDfnSgJ71K/mHTkXfgQu1ODLSSZz
   ewUwqGPaVybct10FXn4dM5GI+8j+BjSCmLpMfRNXWmr2zThBfZ/NfD4Cu
   9sweuqjYZfbcGa5C7dMb65oVG7jAgN/XZQwH0mWxJ1TPfyJAoOeJ3BuVs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="86529473"
X-IronPort-AV: E=Sophos;i="5.99,264,1677510000"; 
   d="scan'208";a="86529473"
Received: from mail-os0jpn01lp2108.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.108])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 19:41:43 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAQj4+r7rxrRTOVL1xaHex9zsy5DvxGrOxZiBIi+m4v+mBnmMniCtZZYkSO02wDqqGj8x71qBZJiZtHbNhI0DEgNhTQhAeO48RJqTYJVcqdNy5/eBKtkQBCJYQGrR/8DBWTPLVINxIWtQ1mzcK07EDvzxbfw8GHV5EV1DjW1tZxHe2ZH2wNxxCfGApIE9AfqlfZUsJeViLwKdu4mdde62k8d94JMK/gahTyjtNnRzD2tHwXrZ2k+J14N1B0AQNqTuTc8Ht+cfAOWmOGyjK5Zt6n3id5mRCqGkKrxW0GEUx5TtAQAvE0VeRqdiaFqK4IpyYT1GGY1dS1W3iMdl9mUJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ax8Od0amGnP5TPEdVUVnCaa/50f5VRqGXtjyp9G6OEw=;
 b=DKLo6AVa3RTeXwQ25ZMkFdOXIpmkLuCMDX0nJIVAbmQeoeCw2MTntKkfiB5XGoNEzcFWwnq4yRZeyN5JB2Gy9zO2DqWzfu41mo0jj8+RnyOKG7auq6Jf8nV8u+YVtGNLfrSpGipRrR3lQ/4Q8cWBCTQ7WxXpxY4SpWGyF3XC6jX9euMgPa/besJ5HU4mzGI9FvpVb1fK5q9MxAz/fDGfiVzAkVepMZ/Clx8ZkOeybN9KBTQrBSKXx3hoJ5yNIRLFP59stEAaQrBlf2FuoiPPMaUI39HiAoGbaUC2zCynLWdNNvMAGXAGjOeGUs9BpjphD5CyZeYow69uyXBSEeidlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB11656.jpnprd01.prod.outlook.com (2603:1096:400:37a::6)
 by OS3PR01MB10388.jpnprd01.prod.outlook.com (2603:1096:604:1f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 10:41:39 +0000
Received: from TYCPR01MB11656.jpnprd01.prod.outlook.com
 ([fe80::d9a:a858:c1d:1aa2]) by TYCPR01MB11656.jpnprd01.prod.outlook.com
 ([fe80::d9a:a858:c1d:1aa2%8]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 10:41:39 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yasunori
 Gotou (Fujitsu)" <y-goto@fujitsu.com>, "Xiao Yang (Fujitsu)"
	<yangx.jy@fujitsu.com>, "Shiyang Ruan (Fujitsu)" <ruansy.fnst@fujitsu.com>
Subject: Re: [RFC PATCH v2 0/3] pmem memmap dump support
Thread-Topic: [RFC PATCH v2 0/3] pmem memmap dump support
Thread-Index: AQHZePGyDbRSw7SlpU2xnWSJHHhjFK9BFSkAgA8cuQCAAzQ4gA==
Date: Wed, 10 May 2023 10:41:39 +0000
Message-ID: <0fe0d69e-e33b-cf45-c957-68a8159d29ab@fujitsu.com>
References: <20230427101838.12267-1-lizhijian@fujitsu.com>
 <644c17823cf83_13303129460@dwillia2-xfh.jf.intel.com.notmuch>
 <774fd596-5481-aeff-aace-8785158728ea@fujitsu.com>
In-Reply-To: <774fd596-5481-aeff-aace-8785158728ea@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11656:EE_|OS3PR01MB10388:EE_
x-ms-office365-filtering-correlation-id: 852386d5-f562-4e6b-3305-08db514322e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 k8Exq2VzPCsid7/IJYCWpAhfeF74l7nVsfyg6A8KvtDZ7oTcih8IuZbMrE/BTWGw3JC74l/rHYkjIrazo/AHtCz+l33ucwoqLK0MChgOvNmSUjIB131a24HbIGFGBgfteKE5jIKvkhB47f+oIida0/H8TEQA15SzedcW9npnCzyI7kzFNT0bdnj/Q5KwDmpfEJAAMeqDXZ9yw8Xzi28eqb+J4wiLy7X9fxLpTwksHDcr14TygC/EjYjUDPDPv9r9NW1Ef4993TaUf55NPaCBUopZ6XlUxoW9giJF0OVzUunSLUREPdS7XNcBBgFjrqHSYS6uQ7AvawJ7uDSldm4FAKzfADXrHWpHLfyrokm54LVEIK+w3Bk7YzfWLDnkWDibDwB9W7hcf6oo4t0CsC2YN9S5j/LsRWf5mo3HFZTzoSyepTbW9qjTGcc+QI2pDf6VYfPwVWTMLYAcmgiQsLvh9E9/pxcTIGnjxrsygO0HSsJDpFgj3npkOXh9Rpuy5kwgkF9bot3OSnmaAgnZeBSVQ+Fj8UreWb63LzgcBKpnzP/VlpKWuaEdPhRPn9R/JqluVbuB3+wlpeREPLKFjeR+6mM7fk0W5AJtGPzE+wvu0m7r+Pk+80bckxvH5DURgrYNSZK6GNP2FH9So5OY1t4fcrKmEjTVLfCykXHko708oGsyUsN2o3UWAsVo0jpEVxGDiYFGZRZUKrzzxjeDwMTZGp9+HQX/b21LXdm9h3VxV6c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11656.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(1590799018)(451199021)(83380400001)(54906003)(85182001)(2906002)(5660300002)(110136005)(122000001)(82960400001)(31686004)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(91956017)(316002)(4326008)(41300700001)(1580799015)(6486002)(38100700002)(86362001)(966005)(2616005)(26005)(53546011)(6512007)(6506007)(8936002)(8676002)(71200400001)(107886003)(186003)(36756003)(38070700005)(31696002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RURXTEY0NFpsSFFFaUd6bGtwcFhnKzNoMHdiZHBSZ2hRMkN1U1NOV0dodHlX?=
 =?utf-8?B?UnlWM0hCUlFMcEhVODBpbjNBbDVZbzUxMUJucWdQR29kYkNkZDQwdnliK1No?=
 =?utf-8?B?UVJqYTM1R09aMVk1Zk1JUVkrRzFJVHVmY3ZaUUc5MjhPQTZ3b2IvMHRKOEFD?=
 =?utf-8?B?MldacmVjYUJPK25OaExNQjhwSHI2YlJhcjFJK25lenpjQnpnZVdJV0NCVTUz?=
 =?utf-8?B?UDBQaFVZUFdkcFNPNk9MdW8ycUx6dXlxbVdmYzc3c091d3M2VEwrSnNVeVF4?=
 =?utf-8?B?cFB1Y0x0aG91VFYxOFNndW9sTEw2UEtwUEFlUGdFV09tdmRHMmhZbWc1cEZW?=
 =?utf-8?B?bWhjNmlBNWVKREZ4cjBJUmFGVEJ4eEdYMEJBVVVOZUwrek1tR1lsSDd1VmxK?=
 =?utf-8?B?bGJYUTNRZ2ZmWWZXSHY2TWtrL1BxdGJ6OEVqTno0UCtMWE9tSzNrWk9XTkU1?=
 =?utf-8?B?NzY5c1VveFdTTXdhcGQvTWZjRERkRkVBSmZtbFUrVEgwUjYvR016YXpWcUNH?=
 =?utf-8?B?NkgxUVJDMUFNeWtDM0tPVi9XQnlvRVVTZjkwUjdpaW1mNVVwV0hreGhwK2tZ?=
 =?utf-8?B?YWFEWDlqZ0M0RkpxeVhvcFhxZVlCK0NjVHc0NjBSb2lieFFvTU1kNytIa1RH?=
 =?utf-8?B?TUp4MTN0bkZrN0lkWWV4WkNrdFRRb3poNDA3cjYvbjN1SlEwb2RPOHF1eXNy?=
 =?utf-8?B?WVVGQS8reUQ3VWtISzdCRHBvOE9FWkdXcFlid01mUzZad09saFZhbGFmTmY5?=
 =?utf-8?B?aFp6L0dqUGhIY0pnNnRlZTdhZXVyMHlVNjFjL0crdndZcXovZ0dMUFoycEJl?=
 =?utf-8?B?allDUk5adHV0cHZZNFlDc29ocXBFbThzZ21vRVYrZDJ6OXBFOXlzUEJVVk05?=
 =?utf-8?B?V2ZsMzVpTXNpbDVwekZBNXpaQlBBakx4SytpRGNkNTQ2V3doa0svem8vVTN0?=
 =?utf-8?B?QUJsUG5mSnQ1M2N3OUlFVTdTeFpYTG05ejBqYXkzUWpwRUtaSWJTTUR5bUJ4?=
 =?utf-8?B?QzVQT1FPUDQvd1diOEE5cTY0ZlY2ZFlEaVdROXBUZTg1MDE0N3ZOamZFYzUz?=
 =?utf-8?B?RUYrLzdvbTVsZ1RMZ3lWSmpmUUlaMkNBU2pNRWdwckx2cnVxVGpaMXVMVzNi?=
 =?utf-8?B?ZkpDTTdET0VPRUoxd0ljSE5hUWl6V2tMZzBxUG9GdEtRNm5KWnpUMVBEcWdI?=
 =?utf-8?B?UkVnaXF2am5DbzN3TDlkYjRqeE1lN0RYVGlmTlpjN2xwbjMrTTRBTmxFQ1lt?=
 =?utf-8?B?YkZBZ3NDQ2dwYnVaeXJFYURMLzN6a3htODVnZVhEeEZ5Rm5yNUc5aVNrTmVR?=
 =?utf-8?B?Ui9lQm8yNUFhVTVrNzZBY2RnVy9JdzZGQ3o4VUk1UDNUOCtPQUk3a3RMQ1py?=
 =?utf-8?B?V0tFOEhoL3Mwdy95V0hrVlErS2ZZaFk5VjJPMWFtQzBlSFY3ZW1EZTJ4dVBx?=
 =?utf-8?B?NjZmMis2VGEzZXhvVnJjeGxSNG9jK1Q0SVR1bHN2VWIvenAxNS9aQ05wNmtm?=
 =?utf-8?B?ZHRzbHNndkdGUnQ1ZlNrNzc5NFlhYk84Tlozb0prWjFCcXJ6aFRlVkpkL2Za?=
 =?utf-8?B?ZzdYbXlCZjd3djZsSmZ3SEJscGxrMStoSlhPZEJWY1dIbi9oaXJpbWV1RCsy?=
 =?utf-8?B?a0hNcW1WN2N2aEFseExNZUNuVVNBTWlFQmhPaEtIckVucExhWVk5Y0M2WUU1?=
 =?utf-8?B?dTBzZjVXOHdPNFhwMlhFVXc5MmE0ZzNRVEE2bURVYXVyWitTVTZKaUxaMmth?=
 =?utf-8?B?TzI3eC94d2kzTXZMdWhrNnlVVFN0YU02ZnNjMTlFclNVdFlON1lybDVjRzV1?=
 =?utf-8?B?WGpzZExCZkdmWW8rc2luZzFoMmRsWlZ4UVhHUG5iQnZnS0dKcklYdkV6QjNt?=
 =?utf-8?B?Mjg5dWRRbDhGQlFmYzhPNnIzWWNLRnNMWVoycFdaZWdkRUxJRDhEQzJHcUVW?=
 =?utf-8?B?RmxJZGFZaSs3eDF2VEZWWnY3NGNpR25uN2NHdXgyUER1VFdoMG9BRW0vOFpO?=
 =?utf-8?B?eW94Mllvb1BsZStRajU2T1BFNkIzd3BtVVA5bDl5NlFZU1g0ZlFiNEZGRllN?=
 =?utf-8?B?TmNmMVMwMnpubXVqeGlTNlpid3BpdHAwQnN4YVhteEVCeUdTQkk4Y0U0c1Vs?=
 =?utf-8?B?T3NISkZqTlk0YVB0dGY4NWluTE5GVjRydDZnNGRYSlBieWtQUlBJYTNJMGFG?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B2960B62FF1284F8832A77EA8AB73E7@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cpgqWZvl/1iq+5sgNoBhL+aFerSFhUcY9ulTfq03FBtI/7qZxCiHXVn2p8UpUY6Mv+qe431nT1p8kdaFu7FUb/oHjGVqMDNKJWNai9G4tjzeejE5rGJHLb4/BHPk5H+FJo4X5yMLJ5aOE+9mqJSO7NSMHhlBWQNDC9Iht0L0yj1dMe6SvMbwcL72VeHGImCBLJadgjjKomkLMZThfG34fdl7zy2LHsBdejNft/GjaMbJIsuow+fpj5EsGMCuStNgDLDcD08Kcepo18eQdM6x4aipIoliSKrCOVwQRf0MUEzn7dSGQvkmNp7iQlJjWoLaiP/nY+ZydJhjDyVqjfrhBdLAgsy6eYcPocpjBPxA5A3s3odSZNE7kBh0rUD3TmJE6hh13lIvYbOp6eZXNVjIXt2Ki5gWc6rJ+EMj4Ii6yCRvYnMCX1prujK1A+vZGDhio/8X7Oi9FdeLy0LzSmsAXMF6yt4sb2bo+w0R6nng+x1f2651bXeGbz8NCNRn/V8NBuUKCO5tZ5gK2xk5l95Zaofahv+g7dhqawhyt7ta3tIx4RS+Nq9ikgjNe0igfh6MPJmpMO8MldGCh9Xlsa+1fLHsA206clHf5OTTB673HbnsIhhX9NVXtcwYmKnswkoBVCpfCQiGG3Qjp1kwnqMCkOwRpC/NkwFbzNFca5rzRbnrfDKTOtJRt7w0/0bwqbkvpEOYOs7afH/OOhTqkV5Drki3HZ3yW5UgtYRrBn2GClQPiEu+EuoVuOFN+n+al0wvcA8XPT4xlq7wXRZWV7ANTaUKN9+h5qSSSiXy8qO4Ag6gg52aN3ZOqqZqrcJda4mRNHNmaLaZmANIYNi7RGPAmUm1gPre+P7xyFHRkRtdx48+o9dzZjvS0c9LWpgwLfZ/57Zdiwjb1ZvMXOp7hY6D1uGP/O18HGHsChzqjcHMDCo=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11656.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852386d5-f562-4e6b-3305-08db514322e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 10:41:39.2879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkQqax9oHlIS1atiY0zUmeGJioUgtR1/NOiWB0ZeoxnV69fAEXRQ8i/a/QfEttl70drYO63mALYFOUtdLz82aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10388

SGkgRGFuDQoNCg0Kb24gNS84LzIwMjMgNTo0NSBQTSwgWmhpamlhbiBMaSAoRnVqaXRzdSkgd3Jv
dGU6DQo+IERhbiwNCj4NCj4NCj4gT24gMjkvMDQvMjAyMyAwMjo1OSwgRGFuIFdpbGxpYW1zIHdy
b3RlOg0KPj4gTGkgWmhpamlhbiB3cm90ZToNCj4+PiBIZWxsbyBmb2xrcywNCj4+Pg0KPj4+IEFi
b3V0IDIgbW9udGhzIGFnbywgd2UgcG9zdGVkIG91ciBmaXJzdCBSRkNbM10gYW5kIHJlY2VpdmVk
IHlvdXIga2luZGx5IGZlZWRiYWNrLiBUaGFuayB5b3UgOikNCj4+PiBOb3csIEknbSBiYWNrIHdp
dGggdGhlIGNvZGUuDQo+Pj4NCj4+PiBDdXJyZW50bHksIHRoaXMgUkZDIGhhcyBhbHJlYWR5IGlt
cGxlbWVudGVkIHRvIHN1cHBvcnRlZCBjYXNlIEQqLiBBbmQgdGhlIGNhc2UgQSZCIGlzIGRpc2Fi
bGVkDQo+Pj4gZGVsaWJlcmF0ZWx5IGluIG1ha2VkdW1wZmlsZS4gSXQgaW5jbHVkZXMgY2hhbmdl
cyBpbiAzIHNvdXJjZSBjb2RlIGFzIGJlbG93Og0KPj4gSSB0aGluayB0aGUgcmVhc29uIHRoaXMg
cGF0Y2hraXQgaXMgZGlmZmljdWx0IHRvIGZvbGxvdyBpcyB0aGF0IGl0DQo+PiBzcGVuZHMgYSBs
b3Qgb2YgdGltZSBkZXNjcmliaW5nIGEgY2hvc2VuIHNvbHV0aW9uLCBidXQgbm90IGVub3VnaCB0
aW1lDQo+PiBkZXNjcmliaW5nIHRoZSBwcm9ibGVtIGFuZCB0aGUgdHJhZGVvZmZzLg0KPj4NCj4+
IEZvciBleGFtcGxlIHdoeSBpcyB1cGRhdGluZyAvcHJvYy92bWNvcmUgd2l0aCBwbWVtIG1ldGFk
YXRhIHRoZSBjaG9zZW4NCj4+IHNvbHV0aW9uPyBXaHkgbm90IGxlYXZlIHRoZSBrZXJuZWwgb3V0
IG9mIGl0IGFuZCBoYXZlIG1ha2VkdW1wZmlsZQ0KPj4gdG9vbGluZyBhd2FyZSBvZiBob3cgdG8g
cGFyc2UgcGVyc2lzdGVudCBtZW1vcnkgbmFtZXNwYWNlIGluZm8tYmxvY2tzDQo+PiBhbmQgcmV0
cmlldmUgdGhhdCBkdW1wIGl0c2VsZj8gVGhpcyBpcyB3aGF0IEkgcHJvcG9zZWQgaGVyZToNCj4+
DQo+PiBodHRwOi8vbG9yZS5rZXJuZWwub3JnL3IvNjQxNDg0ZjdlZjc4MF9hNTJlMjk0MEBkd2ls
bGlhMi1tb2JsMy5hbXIuY29ycC5pbnRlbC5jb20ubm90bXVjaA0KPiBTb3JyeSBmb3IgdGhlIGxh
dGUgcmVwbHkuIEknbSBqdXN0IGJhY2sgZnJvbSB0aGUgdmFjYXRpb24uDQo+IEFuZCBzb3JyeSBh
Z2FpbiBmb3IgbWlzc2luZyB5b3VyIHByZXZpb3VzICppbXBvcnRhbnQqIGluZm9ybWF0aW9uIGlu
IFYxLg0KPg0KPiBZb3VyIHByb3Bvc2FsIGFsc28gc291bmRzIHRvIG1lIHdpdGggbGVzcyBrZXJu
ZWwgY2hhbmdlcywgYnV0IG1vcmUgbmRjdGwgY291cGxpbmcgd2l0aCBtYWtlZHVtcGZpbGUgdG9v
bHMuDQo+IEluIG15IGN1cnJlbnQgdW5kZXJzdGFuZGluZywgaXQgd2lsbCBpbmNsdWRlcyBmb2xs
b3dpbmcgc291cmNlIGNoYW5nZXMuDQoNClRoZSBrZXJuZWwgYW5kIG1ha2VkdW1wZmlsZSBoYXMg
dXBkYXRlZC4gSXQncyBzdGlsbCBpbiBhIGVhcmx5IHN0YWdlLCBidXQgaW4gb3JkZXIgdG8gbWFr
ZSBzdXJlIEknbSBmb2xsb3dpbmcgeW91ciBwcm9wb3NhbC4NCmkgd2FudCB0byBzaGFyZSB0aGUg
Y2hhbmdlcyB3aXRoIHlvdSBlYXJseS4gQWx0ZXJuYXRpdmVseSwgeW91IGFyZSBhYmxlIHRvIHJl
ZmVyIHRvIG15IGdpdGh1YiBmb3IgdGhlIGZ1bGwgZGV0YWlscy4NCmh0dHBzOi8vZ2l0aHViLmNv
bS96aGlqaWFubGk4OC9tYWtlZHVtcGZpbGUvY29tbWl0LzhlYmZlMzhjMDE1Y2ZjYTA1NDVjYjNi
MWQ3YTZjYzlhNThmYzliYjMNCg0KSWYgSSdtIGdvaW5nIHRoZSB3cm9uZyB3YXksIGZlZSBmcmVl
IHRvIGxldCBtZSBrbm93IDopDQoNCg0KPg0KPiAtLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiBT
b3VyY2UgICAgIHwgICAgICAgICAgICAgICAgICAgICAgY2hhbmdlcyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfA0KPiAtLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiBJLiAg
ICAgICAgIHwgMS4gZW50ZXIgZm9yY2VfcmF3IGluIGtkdW1wIGtlcm5lbCBhdXRvbWF0aWNhbGx5
KGF2b2lkIG1ldGFkYXRhIGJlaW5nIHVwZGF0ZWQgYWdhaW4pfA0KDQprZXJuZWwgc2hvdWxkIGFk
YXB0IGl0IHNvIHRoYXQgdGhlIG1ldGFkYXRhIG9mIHBtZW0gd2lsbCBiZSB1cGRhdGVkIGFnYWlu
IGluIHRoZSBrZHVtcCBrZXJuZWw6DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9uYW1l
c3BhY2VfZGV2cy5jIGIvZHJpdmVycy9udmRpbW0vbmFtZXNwYWNlX2RldnMuYw0KaW5kZXggYzYw
ZWMwYjM3M2M1Li4yZTU5YmU4YjljNzggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL252ZGltbS9uYW1l
c3BhY2VfZGV2cy5jDQorKysgYi9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jDQpAQCAt
OCw2ICs4LDcgQEANCiAgI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCiAgI2luY2x1ZGUgPGxpbnV4
L2xpc3QuaD4NCiAgI2luY2x1ZGUgPGxpbnV4L25kLmg+DQorI2luY2x1ZGUgPGxpbnV4L2NyYXNo
X2R1bXAuaD4NCiAgI2luY2x1ZGUgIm5kLWNvcmUuaCINCiAgI2luY2x1ZGUgInBtZW0uaCINCiAg
I2luY2x1ZGUgInBmbi5oIg0KQEAgLTE1MDQsNiArMTUwNSw4IEBAIHN0cnVjdCBuZF9uYW1lc3Bh
Y2VfY29tbW9uICpudmRpbW1fbmFtZXNwYWNlX2NvbW1vbl9wcm9iZShzdHJ1Y3QgZGV2aWNlICpk
ZXYpDQogICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIEVSUl9QVFIoLUVOT0RFVik7DQog
ICAgICAgICB9DQogIA0KKyAgICAgICBpZiAoaXNfa2R1bXBfa2VybmVsKCkpDQorICAgICAgICAg
ICAgICAgbmRucy0+Zm9yY2VfcmF3ID0gdHJ1ZTsNCiAgICAgICAgIHJldHVybiBuZG5zOw0KICB9
DQogIEVYUE9SVF9TWU1CT0wobnZkaW1tX25hbWVzcGFjZV9jb21tb25fcHJvYmUpOw0KDQo+IGtl
cm5lbCAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8DQo+ICAgICAgICAgICAgICB8IDIuIG1hcmsgdGhlIHdob2xl
IHBtZW0ncyBQVF9MT0FEIGZvciBrZXhlY19maWxlX2xvYWQoMikgc3lzY2FsbCAgIHwNCj4gLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gSUkuIGtleGVjLSB8IDEuIG1hcmsgdGhlIHdob2xlIHBt
ZW0ncyBQVF9MT0FEIGZvciBrZXhlX2xvYWQoMikgc3lzY2FsbCAgICAgICAgIHwNCj4gdG9vbCAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwNCj4gLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gSUlJLiAgICAg
ICB8IDEuIHBhcnNlIHRoZSBpbmZvYmxvY2sgYW5kIGNhbGN1bGF0ZSB0aGUgYm91bmRhcmllcyBv
ZiB1c2VyZGF0YSBhbmQgbWV0YWRhdGEgICB8DQo+IG1ha2VkdW1wLSAgfCAyLiBza2lwIHBtZW0g
dXNlcmRhdGEgcmVnaW9uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+
IGZpbGUgICAgICAgfCAzLiBleGNsdWRlIHBtZW0gbWV0YWRhdGEgcmVnaW9uIGlmIG5lZWRlZCAg
ICAgICAgICAgICAgICAgICAgICAgICB8DQo+IC0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+DQo+
IEkgd2lsbCB0cnkgcmV3cml0ZSBpdCB3aXRoIHlvdXIgcHJvcG9zYWwgQVNBUA0KDQppbnNwZWN0
X3BtZW1fbmFtZXNwYWNlKCkgd2lsbCB3YWxrIHRoZSBuYW1lc3BhY2VzIGFuZCB0aGUgcmVhZCBp
dHMgcmVzb3VyY2Uuc3RhcnQgYW5kIGluZm9ibG9jay4gV2l0aCB0aGlzDQppbmZvcm1hdGlvbiwg
d2UgY2FuIGNhbGN1bGF0ZSB0aGUgYm91bmRhcmllcyBvZiB1c2VyZGF0YSBhbmQgbWV0YWRhdGEg
ZWFzaWx5LiBCdXQgY3VycmVudGx5IHRoaXMgY2hhbmdlcyBhcmUNCnN0cm9uZ2x5IGNvdXBsaW5n
IHdpdGggdGhlIG5kY3RsL3BtZW0gd2hpY2ggbG9va3MgYSBiaXQgbWVzc3kgYW5kIHVnbHkuDQoN
Cj09PT09PT09PT09PW1ha2VkdW1wZmlsZT09PT09PT0NCg0KZGlmZiAtLWdpdCBhL01ha2VmaWxl
IGIvTWFrZWZpbGUNCmluZGV4IGEyODllNDFlZjQ0ZC4uNGI0ZGVkNjM5Y2ZkIDEwMDY0NA0KLS0t
IGEvTWFrZWZpbGUNCisrKyBiL01ha2VmaWxlDQpAQCAtNTAsNyArNTAsNyBAQCBPQkpfUEFSVD0k
KHBhdHN1YnN0ICUuYywlLm8sJChTUkNfUEFSVCkpDQogIFNSQ19BUkNIID0gYXJjaC9hcm0uYyBh
cmNoL2FybTY0LmMgYXJjaC94ODYuYyBhcmNoL3g4Nl82NC5jIGFyY2gvaWE2NC5jIGFyY2gvcHBj
NjQuYyBhcmNoL3MzOTB4LmMgYXJjaC9wcGMuYyBhcmNoL3NwYXJjNjQuYyBhcmNoL21pcHM2NC5j
IGFyY2gvbG9vbmdhcmNoNjQuYw0KICBPQkpfQVJDSD0kKHBhdHN1YnN0ICUuYywlLm8sJChTUkNf
QVJDSCkpDQogIA0KLUxJQlMgPSAtbGR3IC1sYnoyIC1sZGwgLWxlbGYgLWx6DQorTElCUyA9IC1s
ZHcgLWxiejIgLWxkbCAtbGVsZiAtbHogLWxuZGN0bA0KICBpZm5lcSAoJChMSU5LVFlQRSksIGR5
bmFtaWMpDQogIExJQlMgOj0gLXN0YXRpYyAkKExJQlMpIC1sbHptYQ0KICBlbmRpZg0KZGlmZiAt
LWdpdCBhL21ha2VkdW1wZmlsZS5jIGIvbWFrZWR1bXBmaWxlLmMNCmluZGV4IDk4YzNiOGM3Y2Vk
OS4uZGI2OGQwNWEyOWY5IDEwMDY0NA0KLS0tIGEvbWFrZWR1bXBmaWxlLmMNCisrKyBiL21ha2Vk
dW1wZmlsZS5jDQpAQCAtMjcsNiArMjcsOCBAQA0KICAjaW5jbHVkZSA8bGltaXRzLmg+DQogICNp
bmNsdWRlIDxhc3NlcnQuaD4NCiAgI2luY2x1ZGUgPHpsaWIuaD4NCisjaW5jbHVkZSA8c3lzL3R5
cGVzLmg+DQorI2luY2x1ZGUgPG5kY3RsL2xpYm5kY3RsLmg+DQoNCisNCisjZGVmaW5lIElORk9C
TE9DS19TWiAoODE5MikNCisjZGVmaW5lIFNaXzRLICg0MDk2KQ0KKyNkZWZpbmUgUEZOX1NJR19M
RU4gMTYNCisNCit0eXBlZGVmIHVpbnQ2NF90IHU2NDsNCit0eXBlZGVmIGludDY0X3QgczY0Ow0K
K3R5cGVkZWYgdWludDMyX3QgdTMyOw0KK3R5cGVkZWYgaW50MzJfdCBzMzI7DQordHlwZWRlZiB1
aW50MTZfdCB1MTY7DQordHlwZWRlZiBpbnQxNl90IHMxNjsNCit0eXBlZGVmIHVpbnQ4X3QgdTg7
DQordHlwZWRlZiBpbnQ4X3Qgczg7DQorDQordHlwZWRlZiBpbnQ2NF90IGxlNjQ7DQordHlwZWRl
ZiBpbnQzMl90IGxlMzI7DQordHlwZWRlZiBpbnQxNl90IGxlMTY7DQorDQorc3RydWN0IHBmbl9z
YiB7DQorICAgICAgIHU4IHNpZ25hdHVyZVtQRk5fU0lHX0xFTl07DQorICAgICAgIHU4IHV1aWRb
MTZdOw0KKyAgICAgICB1OCBwYXJlbnRfdXVpZFsxNl07DQorICAgICAgIGxlMzIgZmxhZ3M7DQor
ICAgICAgIGxlMTYgdmVyc2lvbl9tYWpvcjsNCisgICAgICAgbGUxNiB2ZXJzaW9uX21pbm9yOw0K
KyAgICAgICBsZTY0IGRhdGFvZmY7IC8qIHJlbGF0aXZlIHRvIG5hbWVzcGFjZV9iYXNlICsgc3Rh
cnRfcGFkICovDQorICAgICAgIGxlNjQgbnBmbnM7DQorICAgICAgIGxlMzIgbW9kZTsNCisgICAg
ICAgLyogbWlub3ItdmVyc2lvbi0xIGFkZGl0aW9ucyBmb3Igc2VjdGlvbiBhbGlnbm1lbnQgKi8N
CisgICAgICAgbGUzMiBzdGFydF9wYWQ7DQorICAgICAgIGxlMzIgZW5kX3RydW5jOw0KKyAgICAg
ICAvKiBtaW5vci12ZXJzaW9uLTIgcmVjb3JkIHRoZSBiYXNlIGFsaWdubWVudCBvZiB0aGUgbWFw
cGluZyAqLw0KKyAgICAgICBsZTMyIGFsaWduOw0KKyAgICAgICAvKiBtaW5vci12ZXJzaW9uLTMg
Z3VhcmFudGVlIHRoZSBwYWRkaW5nIGFuZCBmbGFncyBhcmUgemVybyAqLw0KKyAgICAgICAvKiBt
aW5vci12ZXJzaW9uLTQgcmVjb3JkIHRoZSBwYWdlIHNpemUgYW5kIHN0cnVjdCBwYWdlIHNpemUg
Ki8NCisgICAgICAgbGUzMiBwYWdlX3NpemU7DQorICAgICAgIGxlMTYgcGFnZV9zdHJ1Y3Rfc2l6
ZTsNCisgICAgICAgdTggcGFkZGluZ1szOTk0XTsNCisgICAgICAgbGU2NCBjaGVja3N1bTsNCit9
Ow0KKw0KK3N0YXRpYyBpbnQgbmRfcmVhZF9pbmZvYmxvY2tfZGF0YW9mZihzdHJ1Y3QgbmRjdGxf
bmFtZXNwYWNlICpuZG5zKQ0KK3sNCisgICAgICAgaW50IGZkLCByYzsNCisgICAgICAgY2hhciBw
YXRoWzUwXTsNCisgICAgICAgY2hhciBidWZbSU5GT0JMT0NLX1NaICsgMV07DQorICAgICAgIHN0
cnVjdCBwZm5fc2IgKnBmbl9zYiA9IChzdHJ1Y3QgcGZuX3NiICopKGJ1ZiArIFNaXzRLKTsNCisN
CisgICAgICAgc3ByaW50ZihwYXRoLCAiL2Rldi8lcyIsIG5kY3RsX25hbWVzcGFjZV9nZXRfYmxv
Y2tfZGV2aWNlKG5kbnMpKTsNCisNCisgICAgICAgZmQgPSBvcGVuKHBhdGgsIE9fUkRPTkxZfE9f
RVhDTCk7DQorICAgICAgIGlmIChmZCA8IDApDQorICAgICAgICAgICAgICAgcmV0dXJuIC0xOw0K
Kw0KKw0KKyAgICAgICByYyA9IHJlYWQoZmQsIGJ1ZiwgSU5GT0JMT0NLX1NaKTsNCisgICAgICAg
aWYgKHJjIDwgSU5GT0JMT0NLX1NaKSB7DQorICAgICAgICAgICAgICAgcmV0dXJuIC0xOw0KKyAg
ICAgICB9DQorDQorICAgICAgIHJldHVybiBwZm5fc2ItPmRhdGFvZmY7DQorfQ0KKw0KK2ludCBp
bnNwZWN0X3BtZW1fbmFtZXNwYWNlKHZvaWQpDQorew0KKyAgICAgICBzdHJ1Y3QgbmRjdGxfY3R4
ICpjdHg7DQorICAgICAgIHN0cnVjdCBuZGN0bF9idXMgKmJ1czsNCisgICAgICAgaW50IHJjID0g
LTE7DQorDQorICAgICAgIGZwcmludGYoc3RkZXJyLCAiXG5cbmluc3BlY3RfcG1lbV9uYW1lc3Bh
Y2UhIVxuXG4iKTsNCisgICAgICAgcmMgPSBuZGN0bF9uZXcoJmN0eCk7DQorICAgICAgIGlmIChy
YykNCisgICAgICAgICAgICAgICByZXR1cm4gLTE7DQorDQorICAgICAgIG5kY3RsX2J1c19mb3Jl
YWNoKGN0eCwgYnVzKSB7DQorICAgICAgICAgICAgICAgc3RydWN0IG5kY3RsX3JlZ2lvbiAqcmVn
aW9uOw0KKw0KKyAgICAgICAgICAgICAgIG5kY3RsX3JlZ2lvbl9mb3JlYWNoKGJ1cywgcmVnaW9u
KSB7DQorICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgbmRjdGxfbmFtZXNwYWNlICpuZG5z
Ow0KKw0KKyAgICAgICAgICAgICAgICAgICAgICAgbmRjdGxfbmFtZXNwYWNlX2ZvcmVhY2gocmVn
aW9uLCBuZG5zKSB7DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0gbmRjdGxf
bmFtZXNwYWNlX21vZGUgbW9kZTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9u
ZyBsb25nIHN0YXJ0LCBlbmRfbWV0YWRhdGE7DQorDQorICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIG1vZGUgPSBuZGN0bF9uYW1lc3BhY2VfZ2V0X21vZGUobmRucyk7DQorICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIC8qIGtkdW1wIGtlcm5lbCBzaG91bGQgc2V0IGZvcmNlX3Jh
dywgbW9kZSBiZWNvbWUgKnNhZmUqICovDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGlmIChtb2RlID09IE5EQ1RMX05TX01PREVfU0FGRSkgew0KKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiT25seSByYXcgY2FuIGJlIGR1bXBh
YmxlXG4iKTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51
ZTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfQ0KKw0KKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBzdGFydCA9IG5kY3RsX25hbWVzcGFjZV9nZXRfcmVzb3VyY2UobmRu
cyk7DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVuZF9tZXRhZGF0YSA9IG5kX3Jl
YWRfaW5mb2Jsb2NrX2RhdGFvZmYobmRucyk7DQorDQorICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qIG1ldGFkYXRhIHJlYWxseSBzdGFydHMgZnJvbSAyTSBhbGlnbm1lbnQgKi8NCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHN0YXJ0ICE9IFVMTE9OR19NQVggJiYg
ZW5kX21ldGFkYXRhID4gMiAqIDEwMjQgKiAxMDI0KSAvLyAyTQ0KKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHBtZW1fYWRkX25leHQoc3RhcnQsIGVuZF9tZXRhZGF0YSk7
DQorICAgICAgICAgICAgICAgICAgICAgICB9DQorICAgICAgICAgICAgICAgfQ0KKyAgICAgICB9
DQorDQorICAgICAgIG5kY3RsX3VucmVmKGN0eCk7DQorICAgICAgIHJldHVybiAwOw0KK30NCisN
Cg0KVGhhbmtzDQpaaGlqaWFuDQoNCg0KDQo+DQo+IFRoYW5rcyBhZ2Fpbg0KPg0KPiBUaGFua3MN
Cj4gWmhpamlhbg0KPg0KPj4gLi4uYnV0IG5ldmVyIGdvdCBhbiBhbnN3ZXIsIG9yIEkgbWlzc2Vk
IHRoZSBhbnN3ZXIuDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fDQo+IGtleGVjIG1haWxpbmcgbGlzdA0KPiBrZXhlY0BsaXN0cy5pbmZyYWRlYWQub3Jn
DQo+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8va2V4ZWMNCg==

