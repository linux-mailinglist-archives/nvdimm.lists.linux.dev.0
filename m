Return-Path: <nvdimm+bounces-886-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F9E3EE3EF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 03:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 23CDC3E0F48
	for <lists+linux-nvdimm@lfdr.de>; Tue, 17 Aug 2021 01:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023896D24;
	Tue, 17 Aug 2021 01:46:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com [216.71.158.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFA6D18
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 01:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1629164806; x=1660700806;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=addYAJ9NQAkupJsMHMjmlZaOp45ZP1YYDeIU7kFuUAI=;
  b=Ln64AW5LEQ39A452sBfLYozdN2HYAK7f3Jh3QDEi3zNnQlZ51cCjJ/Cb
   hyJYyx3Wagt/AdV4rgeFjV2bWBZvlqUev7aGw6JMifp0/9K6wGmb9ojvK
   j7qXYQWqVJDoNTEHOIyptmPMrLq7+SxHMC56ELzsJ7eGQquEmb1GgKj6F
   t7pKacgoIX5cD5CXO2fIECtxI3ClQjHP4jZyT7UXpdKEkDK015sZAUD5B
   IQMTBSf07F5NRhpXVlGejXYad6nieoi7XaW4GELbPByfZWGUIbrkIsUhT
   iOXaSyLQwGAgaqSH44DU+54Uznqk+psZVTod4awdj8sQdNRs0dvEMZxHj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="36657678"
X-IronPort-AV: E=Sophos;i="5.84,327,1620658800"; 
   d="scan'208";a="36657678"
Received: from mail-ty1jpn01lp2058.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.58])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 10:45:32 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyCGCq4HZF5LDtCF9sCTw5vUe/KWuxBSI6xN72jIve64nBoR/9HunzSw2wXw7XHK0qg2fZqiZOLn7Nk9nraE+gRVolP2PeiOh2hlCaVeu50R9v1ckkQ7Fcc6dF2Cxbafi9klgrj5lnOZz9Ot5bPxRt5ZW1jO0sfR7wX4w1x8LZgtPrUluK+hqPZ0T5MDGp1btmBWvY13a9xZ8w/ffErgj9WniVA5tIIT0X61Ap6UsxuYPzjjVlRfruihDNUtn/S4bie0dIfFIgy63Ot/PVpDMZLuFsrWQuoOZdNOZs0AQ7n+yX3ZJomwcXEkcHnXKvU84xVG6DGZTt2sf++ZxaAMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=addYAJ9NQAkupJsMHMjmlZaOp45ZP1YYDeIU7kFuUAI=;
 b=YLvf7O70o8K+MKtYJ02UEEE7xg9shyrVbAuAR5R81FsHbakbbK7bcRAw6/ghR9gUVTo4KtSMJUmm/dcFulPBqYc8kTCwQMOPx5QOo3oolLI7gxHVwKYGrv/R+sz2hCWptjS899AywaRI+/FclLB2kH4JTBm4ZULi/XYTO74gLCrTJif6xSk9B9neJZc170mgkRf82Wn5vxecQCDPvUKVSCjAJuYRUYqFdiy6aJhKXdDyM3vkqbIfraPSmQTonIfx9jWCp/jnFyMkV+HB2He+POqwE++W514WedfrqASytHIdF6M7ja3njOVzi+rImiXcKH0qBv8my5MNxufIwKWHsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=addYAJ9NQAkupJsMHMjmlZaOp45ZP1YYDeIU7kFuUAI=;
 b=jJGd8/ZWvwg4tO1rYY9bXadYiL4sywMEb2LoHIFFWtI4feKBgj3DnFJ/1uBCJguNUW2+ZDvDLs9ywRPV26eeqjS1YNHcR/jbOivveyhy3w0t47yjsKG/wQicos4pzENuhRTBaUmuYA8wimrBP73T/Eiub1CUW9TfKJC9VUh5nvI=
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
 by OSBPR01MB3000.jpnprd01.prod.outlook.com (2603:1096:604:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 01:45:28 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
 ([fe80::6db8:ebd7:8ee4:62bb]) by OSBPR01MB2920.jpnprd01.prod.outlook.com
 ([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 01:45:28 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
CC: "djwong@kernel.org" <djwong@kernel.org>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>
Subject: RE: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
Thread-Topic: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
Thread-Index: AQHXhSoJ2MKEQAyDOkuQStUpIsX3SqtlsyYAgBFVaHA=
Date: Tue, 17 Aug 2021 01:45:28 +0000
Message-ID:
 <OSBPR01MB292042C10A7AA95CB6862F08F4FE9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
 <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
 <e844fc54-113f-239d-da23-fa140aeea9d7@oracle.com>
In-Reply-To: <e844fc54-113f-239d-da23-fa140aeea9d7@oracle.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ccf31b3-b7eb-4bfe-8767-08d96120b0c6
x-ms-traffictypediagnostic: OSBPR01MB3000:
x-microsoft-antispam-prvs:
 <OSBPR01MB30009BBC35070111A6F5EFAFF4FE9@OSBPR01MB3000.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bVI+29haPUqxDBc7Ukq/XeEfo4Gf40TbeArXck6AnboSZR6ehfDA8Hct3dU9TQeJT+sELzLFNyaEirRplqNzgN5FyVOofVZCzm4uq6xk/gbvC5fcL9ggK+9WLw5US9/Z9KV/OXMVN5uUdH9LCtwxqlzVZCe5nI96jgqbGsJdZzKquMmZY5wONN8h6lrpYH0sDhEZACLj2F4vOeqEsv2j2fgWBZ1uRgjEdSf5ur9nhaVuJdaUX+DfUx9OZalw2h1Hbn0WN3PtTPeljzX1eZnO35l3I5ySzHn7FbSXu6xU4s6bIOVqzE3CfTwNiGZJXkZGjp5qF80Td2rAiUFm7iOlI50ofwSCXN5HxFk5XNNf1sI02FC1qKWjhx9vHOPe2VW2436s8vBqro9aWKSTHtWY/qJxy3eZ8SB8qBWrChsZlvCd8aDezQI8uoHjf8PrIHIbVQ6amO2UWm1hC2iY4C3Itbbgs5KmiDDVbEScCGc9bA0VOZVeESySDh6Dw2sK9dC6O4WyauKz34hC0WmntUuv5z+TpoZvfpZNMxn6GZ2/s0J5ja1z+/2azqRmwtH5ffmkh5wegLI/xTO6NRJXnyyKOnj49DltkycC4YTsFEXuZ45tswVNmS+/yEWtUHlxVWEhg8vFq/hW/ZypJ/HkvtNMfWg0AWXpxQ0jY4/1fC8xMkMeuxJnCShIPz/AISFLEEgZ4K1s0vw2t84VsKOHMcFZSw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2920.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(8936002)(122000001)(5660300002)(7416002)(85182001)(478600001)(38100700002)(316002)(54906003)(2906002)(33656002)(66946007)(86362001)(110136005)(83380400001)(8676002)(66476007)(55016002)(64756008)(26005)(66556008)(66446008)(9686003)(6506007)(53546011)(4326008)(7696005)(186003)(52536014)(76116006)(71200400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MU9ETnZkR0VWcGk1cU1YV1p4ZUJjSy9wUDE2bE1sWFlpdHhtSHpKbitDNi9j?=
 =?utf-8?B?Uzlxc09xcjZqOHhSOEdSZmxEM09oa29DaHJoOVBUN2VjNGVNeUFLMHBRNEsr?=
 =?utf-8?B?aldabzUzSjR5YnhpZW5zWnhBNVptSVovNGxFQzFaTnlTeWlQRW9zWHVXU1Vh?=
 =?utf-8?B?ZlA3Mnk3MjZrSEhNWUVFMExXRW45dS94VXdXbis4ZE01UGpTT2MvRjUxVFFx?=
 =?utf-8?B?RnByTTYxTWVZc1lUVUpEVHlYWmxWVVBZeHdVQ3hKaVdIVWZmLzhDRzN1VGg1?=
 =?utf-8?B?RmhsbGUxNWV2THUwNkVjRi9NSWFIdDZQbC82Y0I0Y1hTYUNzcjBFc3dkYnJM?=
 =?utf-8?B?c0dvUHhPdTZSM1Rxa01RTlBwbEhxeExaNFFvZWhOU2JyRjR2SUtVZkQyR0Vv?=
 =?utf-8?B?djVlRnhJcHg1R0hBNUw5N0VjNEtDR1lzODdKbVQ3cDhrRUk4WGxVSlhsVW1B?=
 =?utf-8?B?Mlk2SENiWjNIWVRDM0RWNjhjQkxQaHJ2SWdqcmdWQTJDa1l4dDR5SGtsblhu?=
 =?utf-8?B?dEpNU09tSDN2bFdseTFuQ1FibktHbWdRN3hqb2pIamxNam0rcWw1c1lVZndW?=
 =?utf-8?B?aWNmQW51cEVsc1JpY3h6T2JuQjRNTlc3eFp2SWxhMkRQRVJVcUhJSEJ2cFl6?=
 =?utf-8?B?Sy9kSnJ0MFcyZnBncVREY0E4RjN5WE1mQ3hRQXo0TEJqMldMZXRVU3FVRlpM?=
 =?utf-8?B?WEhob1N3ek1WUlpFNXpxbUZMMC9lVHEvUTl3eFhPZ1EydCtDWlA0enFKbjZE?=
 =?utf-8?B?cWswNmM3Wkx6Z0QxQVV6VzdYMVpDV0JLTXJ5RXVYMm5UUjdTc0twc1g1MGJ6?=
 =?utf-8?B?a05OdHBkL0d6bER0YUx4QjBvWUJoMFEvUjRFZXJQdmt1eW1wUkt6aXE1WDU2?=
 =?utf-8?B?K2xTbDQ4a0NDY1NaZ0F2U1ZYN1FPa3ZDYzRac3FQTkFTNXRlVXhlZlk3YVM1?=
 =?utf-8?B?bWF6aVlueDQvR0djTHZ1VnBaTlVkTHpDUFJmVlZjdjZHUkhoNXVOd3dUeGVv?=
 =?utf-8?B?TjJkdFc5UGQyQ0ZZcGd5ZmZpZnRNOFUxNS8rN3gwZWU4ZmdVbDZMdXlKSHFa?=
 =?utf-8?B?MTMvdmJwdTZSaTIxUGRWQm1qWUtrRTVHaXBDRks1Y3pzZUR1S21md2R4S0kw?=
 =?utf-8?B?eExpdVY5ZmVGNmtqelZGdmdXejRWajN3eDB0VDJrRSs4eS9lMjk0MGhGR3NW?=
 =?utf-8?B?dGtlN3ZFckJ2eUpvWDdPQ1Jva1lnUUlvemJCR2VxcVlhRHZEMlZDVTM0Qk93?=
 =?utf-8?B?bkxobmN3dmJzazlpS2JXK3ovNmlQNXNTYnFlUFNCYkdQUkYvdWIrZzZrSVY1?=
 =?utf-8?B?TGx6TEczamQ0aDVQcE1naVBQMkc0aVg5R0VBYXhQS3NMWUpNT3luK1hkcHpZ?=
 =?utf-8?B?K3lQUWNOcThHeHZZRkZQcUJxZ0FoazVtOTlocXlDOUN0bG1DTkwzUjNBN0lx?=
 =?utf-8?B?MUR4TG1vK1JTRWx6Smk2MHNocTgxeUEzVDlZbEtHTU1aWGE4aEVTYzNyM0hH?=
 =?utf-8?B?NjltY1gydFRyVUhXUG1QR0lQdTIveG0rQkZqQWtyZ2ZaS080REs0dkdDb1NJ?=
 =?utf-8?B?bzFjUlIwZ3VqS3RoWWVtUE1aQ2RqWlJZMWRDeXhWK1VjSzVZNk1NeUdCS1Jq?=
 =?utf-8?B?cW1yZVBrQ1NsRHZzZCtvdlYyTWNVMzJxcUZNaG9DUXF4akZEUjFOOWFYQ2g2?=
 =?utf-8?B?V01tbFpkUDBlNEZjODBrSnE2SE8zRER6SklpRitlMzdua0lzYWxpait0VStH?=
 =?utf-8?Q?qCDu2qcdK6IzUWSh65RoOslfauwNdJPOydn6roO?=
x-ms-exchange-transport-forked: True
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
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccf31b3-b7eb-4bfe-8767-08d96120b0c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 01:45:28.1734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQJF1TotPN+oWvieAzz06YKTmRNHnZq3iylTD4fT8ah7/a3jhH6OT7Dbft7Zpe1rD793XlZl2aBulMkaMIR/YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3000

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEphbmUgQ2h1IDxqYW5lLmNo
dUBvcmFjbGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJFU0VORCB2NiAyLzldIGRheDog
SW50cm9kdWNlIGhvbGRlciBmb3IgZGF4X2RldmljZQ0KPiANCj4gDQo+IE9uIDcvMzAvMjAyMSAz
OjAxIEFNLCBTaGl5YW5nIFJ1YW4gd3JvdGU6DQo+ID4gLS0tIGEvZHJpdmVycy9kYXgvc3VwZXIu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvZGF4L3N1cGVyLmMNCj4gPiBAQCAtMjE0LDYgKzIxNCw4IEBA
IGVudW0gZGF4X2RldmljZV9mbGFncyB7DQo+ID4gICAgKiBAY2Rldjogb3B0aW9uYWwgY2hhcmFj
dGVyIGludGVyZmFjZSBmb3IgImRldmljZSBkYXgiDQo+ID4gICAgKiBAaG9zdDogb3B0aW9uYWwg
bmFtZSBmb3IgbG9va3VwcyB3aGVyZSB0aGUgZGV2aWNlIHBhdGggaXMgbm90IGF2YWlsYWJsZQ0K
PiA+ICAgICogQHByaXZhdGU6IGRheCBkcml2ZXIgcHJpdmF0ZSBkYXRhDQo+ID4gKyAqIEBob2xk
ZXJfcndzZW06IHByZXZlbnQgdW5yZWdpc3RyYXRpb24gd2hpbGUgaG9sZGVyX29wcyBpcyBpbiBw
cm9ncmVzcw0KPiA+ICsgKiBAaG9sZGVyX2RhdGE6IGhvbGRlciBvZiBhIGRheF9kZXZpY2U6IGNv
dWxkIGJlIGZpbGVzeXN0ZW0gb3IgbWFwcGVkDQo+IGRldmljZQ0KPiA+ICAgICogQGZsYWdzOiBz
dGF0ZSBhbmQgYm9vbGVhbiBwcm9wZXJ0aWVzDQo+IA0KPiBQZXJoYXBzIGFkZCB0d28gZG9jdW1l
bnRhcnkgbGluZXMgZm9yIEBvcHMgYW5kIEBob2xkZXJfb3BzPw0KDQpPSy4gSSdsbCBhZGQgdGhl
bSBpbiBuZXh0IHZlcnNpb24uDQoNCi0tDQpUaGFua3MsDQpSdWFuLg0KDQo+ID4gICAgKi8NCj4g
PiAgIHN0cnVjdCBkYXhfZGV2aWNlIHsNCj4gPiBAQCAtMjIyLDggKzIyNCwxMSBAQCBzdHJ1Y3Qg
ZGF4X2RldmljZSB7DQo+ID4gICAJc3RydWN0IGNkZXYgY2RldjsNCj4gPiAgIAljb25zdCBjaGFy
ICpob3N0Ow0KPiA+ICAgCXZvaWQgKnByaXZhdGU7DQo+ID4gKwlzdHJ1Y3Qgcndfc2VtYXBob3Jl
IGhvbGRlcl9yd3NlbTsNCj4gPiArCXZvaWQgKmhvbGRlcl9kYXRhOw0KPiA+ICAgCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7DQo+ID4gICAJY29uc3Qgc3RydWN0IGRheF9vcGVyYXRpb25zICpvcHM7DQo+
ID4gKwljb25zdCBzdHJ1Y3QgZGF4X2hvbGRlcl9vcGVyYXRpb25zICpob2xkZXJfb3BzOw0KPiA+
ICAgfTsNCj4gDQo+IHRoYW5rcywNCj4gLWphbmUNCg==

