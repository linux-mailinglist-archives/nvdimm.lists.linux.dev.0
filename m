Return-Path: <nvdimm+bounces-6903-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 601AF7E6986
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Nov 2023 12:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 137B0280E89
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Nov 2023 11:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161351A72B;
	Thu,  9 Nov 2023 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="vrybnWYc"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa15.fujitsucc.c3s2.iphmx.com (esa15.fujitsucc.c3s2.iphmx.com [68.232.156.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3BC1A70F
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1699529259; x=1731065259;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=onLr0RedqTvkP0zBVuVXMM2wMacWkJLcADnQNARQHWA=;
  b=vrybnWYclNKmpZlxbwzkK2CJ4kOeMgd6ALa7VrZOBie6r8XSWzoow49n
   6VMTEylfM2pPdKj1IGBbwkI9KjOdQqSeiO9ureVsjzk4aY2Ru+goXwImg
   FLjT0+WFgU0TaQNk8QPe4fvvFOM+TLb0xyh7ruXgw+4PJxMBNfrQZJ6iJ
   icOlGu+8y6rrLtJRa5mxZ1IfitufAM/YoFc5SohmchpxTIhdjEC5tOVQK
   bDgUK4r7pFymbsBUtQncQFLz6yOoWhmEC+RBUfa7drle3f3/sdQseC8/r
   ooMycX6ei//Oura2YdmGzncQj8UCNfebzE3lEin7hhqgAWhe+Vg1oN8Ri
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="102100719"
X-IronPort-AV: E=Sophos;i="6.03,289,1694703600"; 
   d="scan'208";a="102100719"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 20:26:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knsvlhFrVDEgmHHg+tKf29hhQsdJn5Tl9gJzu8uHpk2A54LKY7w3cBwILUmaSk6Cy0B/expIxz5GKMXH5iDlq1c971j+a1ynbfcV0hH55fmWrioCUf/rOdkVQDx64OngfHPagSeUMFq0WNTyJQ61yzHh7xLew2xz8oJntADcyNjgR7sfRGhohIQyLimbnxh0aGCSej1H49MHYg8NK+jFhPhjxtfl/LkdTgakKnC2Eiwc92KKQ6OfDpqd5c6XpH6PQw/FJicqEU4EcI1NGQcD3sF/OXIc06koMfrMl6OeTAmNs5nXhzeCUIsJfHgdZssmDTY3I+PaPRina6f1EQWeBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onLr0RedqTvkP0zBVuVXMM2wMacWkJLcADnQNARQHWA=;
 b=a8XWRyUK1CF350ttnZpRPEtifKWmTq6QuQDz5AKLYlfx9uFUhwZszmZyFus7KSYs9D+vVGr3DP43qeSEHde+C/dSPgQmQrihwCiNJFVTw3aIkDeZf70Hhionbwv/bxCzZshdbVY2s208xN3WsqcsCN3YVxvHoTexcBE7Z4aiYXswqej/XDcfaYphsm5cXQ34XjgLGA0VCwM8zkGAxpXC8DVRRAQBp3C3So78PZLcstr5N0eo3DJ6djOoWfPyoJ9I99mLk5HkDupC+7Ysod2oUD6vMrnQx85/n0gn3JUYHlVT2wbWLyNSa6+KoSCysi7cRz1veMmnXZwBhlNr7sg48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYWPR01MB10743.jpnprd01.prod.outlook.com (2603:1096:400:2a7::9)
 by OS3PR01MB7801.jpnprd01.prod.outlook.com (2603:1096:604:17b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.19; Thu, 9 Nov
 2023 11:26:22 +0000
Received: from TYWPR01MB10743.jpnprd01.prod.outlook.com
 ([fe80::8ee1:4e5b:c45f:dd6b]) by TYWPR01MB10743.jpnprd01.prod.outlook.com
 ([fe80::8ee1:4e5b:c45f:dd6b%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 11:26:22 +0000
From: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>
To: Dave Jiang <dave.jiang@intel.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>
Subject:
 =?utf-8?B?5Zue5aSNOiBbTkRDVEwgUEFUQ0ggdjNdIGN4bC9yZWdpb246IEFkZCAtZiBv?=
 =?utf-8?Q?ption_for_disable-region?=
Thread-Topic: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
Thread-Index: AQHaDEAj9CkOpNIeKEi5Q7RzVuVUO7Bx5bNw
Date: Thu, 9 Nov 2023 11:26:22 +0000
Message-ID:
 <TYWPR01MB107438A013022BA02BCCB686183AFA@TYWPR01MB10743.jpnprd01.prod.outlook.com>
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
In-Reply-To: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9YmY5YmMyZTUtNWRjZS00YTFmLThhMTUtNmNlOTU4NmQ4?=
 =?utf-8?B?Y2QyO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFROKAiztNU0lQ?=
 =?utf-8?B?X0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9T?=
 =?utf-8?B?ZXREYXRlPTIwMjMtMTEtMDlUMTE6MjM6MDFaO01TSVBfTGFiZWxfYTcyOTVj?=
 =?utf-8?B?YzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?utf-8?Q?d-81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB10743:EE_|OS3PR01MB7801:EE_
x-ms-office365-filtering-correlation-id: fd606091-8fb8-4e1f-5ba0-08dbe116b3bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4l0cSPjrnZl7AUkNhH8VYOwIGtkyas0MU+74uJYq6jjVGPG4X9NPjIykl9iG4g1NxLYHeEyHBNEdIWyhx8tUVCxRfQ/BzWkVcRDdLI7Vkqh8yrdnapceLaZxXH9SM6TH14zk6cCIkDTKYeN/6mBROY3LPL5F+782/RwS79TKfCYuS7uePWRVTqmSkbS3Gavi2JuyPJtvtXDi7aAmBtf+xX7H63F8R/xs7zhjTLQXS0hFHdJZX+culi54GHEVKwa988S8OyWeHchj2vNzoL6Y44RdwhQlolhpe76+GqYN9mt9/PAJ2hmLZL81DSsyS6UECT0bcshCVQaoT/inOuYS1wuS+mAe9t6v0XDjEdBFIwN6KHVLKD211TJo6pJTzvqat7xgdeYlVbLw9ysAouCCV+kgGhtjefe/GntyzjwLG4ipq+eMGJMs3twAkzUUIkBfikiKqerwwFXDFmQ6R9qnvHMOx1Q8NBzd1hwaZUr34vFe5dkNq7gasbHymtB/dAM8lq9DCEufbKZaPsfFmYP5Ry10MUKvcjPVwZe1Oui1B4E9f3UwsHySi7AWN88wGonEuzYfPIlRPiS2gjFGvJg+uNALdbfwcSlLzclkX1a6GF8I/YPblZ8AhQNmw04VRXIZ1JkCMvZFa/FMNmHdM8ACC7XwRsmOT/66noK4hWF0zRhxBl6J4ynqoQBkN8YWVHse
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB10743.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(1800799009)(186009)(1590799021)(451199024)(64100799003)(55016003)(1580799018)(66946007)(76116006)(66556008)(66446008)(54906003)(316002)(110136005)(64756008)(66476007)(224303003)(85182001)(86362001)(33656002)(38070700009)(38100700002)(122000001)(82960400001)(9686003)(83380400001)(26005)(71200400001)(7696005)(6506007)(2906002)(478600001)(8936002)(41300700001)(52536014)(4326008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VjhPdUhKTExlbVAzb05XUnEvWHFLNEtIRFRxeG5qZUlnVmt3TXZqamtkWWpu?=
 =?utf-8?B?SEJlNStOY21EeUxwL3BsTUN1SDBJMjNRSnZLSXZ5NEk0cU52eEZlbE1MSVU2?=
 =?utf-8?B?bng4TjdFRGRJSlVHMG5hZWZLQkp1MEZnRUlPdkR5eWFRR0V1UlgvWEVuVmx2?=
 =?utf-8?B?RmUzMEhHdlRwWEFVbkdOOUh1RGdmekJPWnNDcnhtQk9mNnRsQ3hXem9tbVVQ?=
 =?utf-8?B?aGJIaXZ2ek5WR2duNDBQTkFvTlF5QzJ5ZmRJSWV3UEZDOVZTSisvdlAwd1hK?=
 =?utf-8?B?Y2xxTk1vbUt3VTBIV0FxemtnUWxBam43c0ZDNzFlYnN0Qlp1UlBnWjNyU0hl?=
 =?utf-8?B?U0h5L1VUZnQ4VFpKbzN6blBZellBeHFpc1FPb2xkQXc4WEhhS1dRTXdCMWNZ?=
 =?utf-8?B?Q3J1ZEF6MlJWYXRlemlWUEhNRHdpZndJQlFnMjJTRmFES05USXBxcytpRFl2?=
 =?utf-8?B?bHdKbXpLQVJvaGdHWk1SNEFMSW51TUhldHVscERQVGEwaXhTUU9FcUdnSW8r?=
 =?utf-8?B?TzFKanB6QmtXYXpTNC9HcTJ5RUxXdkN0SGhGRjYxQll4YzlzeDFDSkEvcGps?=
 =?utf-8?B?MHZBSnMrNnZrV1JiR2lNL2FoR2YwSDZaWmNWNCs3cTZjSjhXNkdkVFdCZ1Ey?=
 =?utf-8?B?YTkzdXdWcGpnRnBDZ2dsdnV1SXFQRnA2WTBKNDUyNDM3T0ZMbXoyT2NmZm96?=
 =?utf-8?B?aWZ4NXp0UVdjZ2o4c2xHR25xbnEyWHlqd1J2U3Boc3BBM3hKcEs0TVR0ckNI?=
 =?utf-8?B?SWV6WjFXcDh4YVpDY0tHSk1idnJCK0ZSemxoVXp4cmtXbmVGNUxQSmRDME1w?=
 =?utf-8?B?Z090WFRvbG91VnBxY2hNZ2lRN2t1QzNHSkVKVVpsd3pCU0g1R3FydkYyU1Rw?=
 =?utf-8?B?NFVjc2VYa1ArZzh2bzNQRS9HcDFMY2NET2MyWXVXU3RUd2Z1aHY1YWgxMDVT?=
 =?utf-8?B?cHFmVzFySTRMNzJEeGtuTmlCeXRwKzd0cTM5UlVCYWc5Q1JPY2JPeUFUTVp0?=
 =?utf-8?B?eGpwbDV4S2RkUFlUMUdhckdkZlVKc2xiMXdOZlJHL2RtUUhYTUk3MEdldHRv?=
 =?utf-8?B?QTF4QVR6RkpLSmQzalhaNHNtVkh1eUF5K1JyTEgxVHVrcENIakRqbG9RNllH?=
 =?utf-8?B?Q2lLT215cHVCVXNML3dMamd5R2NwZnlqS1A2RktoUU9IR2tFYTRmcXJhcjdh?=
 =?utf-8?B?dE1iZFFqc3ZJRDhlVWw2S2g0QlVNVzZ6bGcxTFNjcVdsdEwrUUdYKzExVWVj?=
 =?utf-8?B?SS9CSVFZSGVhL1NrZFBZem14VVZzTzBzK0pGNEQvazQwRHk4dkFIYkdIZEFi?=
 =?utf-8?B?SXBsQThZYXU0Z3JOZ1RmNy9DZE40WEFiSGxHUHRVMkphVDFsMlgyOHRkZldL?=
 =?utf-8?B?Um1GdnQ0cTJKdmsxbjZOL0tjMUNPN0JtdFlNcndmNGN3MG5vWUFLMGZqOXlS?=
 =?utf-8?B?OG4vdHNHOTBqdi9TMTBVRTBGbHVqQkIraUJXb2FXVDV1UXNGaThyeVJRU1lt?=
 =?utf-8?B?dXRpblFGQkZvMDNReGIxMEYvM0l4eWZDVkVSdGs2dFhSMnlIQ2dqS0gvdjdV?=
 =?utf-8?B?Zm9LWG4wSG5yelh4WmllZnQrUlJSYm0zNCs1eldJazBBSk9WaHF0R0xMQmli?=
 =?utf-8?B?NXR5MDNJUjhLQ0hNQ0w5OVptWVpVQXd4UmFGckhHQ3BhMDdUekJPSTMxZlMr?=
 =?utf-8?B?NFFneDM3cEhQaFhnNlZvVk45dXg1OHg4SXYwVStCUWFWYkFTZVBqOGhHY1R5?=
 =?utf-8?B?U0NKWE9VcDNpVElFM29FNDhsdUxUMHFkWUZkRzRYdGZQUU9jZWx5c3dnUHZB?=
 =?utf-8?B?SVQxdTVHYXM1cnJCRkEzYlNxOGo0L2xkS29GN1JpY1NxZFdDbG1SUEVzTXNt?=
 =?utf-8?B?V2ttdEZJQVdIaHhTVDlneVdQamlSekZ2QlhpeUlwRUVwQVRBZERTK2dHbjZa?=
 =?utf-8?B?VXhKTENTK3h2eXNXUXhEanZLVUFUWVNDY2ZuZjQvdWlkZy9WcWV4WkpIMFRC?=
 =?utf-8?B?bGVoYTFtMW5rYmt1TEdxWkZWUGNleTlmMDZtWm5PNkpkZGdoY3VLb3ZmdjlY?=
 =?utf-8?B?ZXdySUNWa1pSU1VrR2Jwc0szRnY5Nmh4cStDUG9xY3hCR0U0djBFa2NqVGRE?=
 =?utf-8?Q?tELvRLrMA5P15gYgMAKhdpUzX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2sOLXBohW8yI5iCgbdWNcV27GeggbU/SuHyz85qPKpGukrICDSakuKea3w8456UKH7yiGGbtaO4xib0fGOwn5zvXN05Tnw1v4jVRMV5q7XQt2T1N0NRiZlm1qTvfZQ4KhuvxPpUSTJNA2dTzWUCrriVtfCSqKw4WTtukE0ynvSJNfnmzo8YrRqzJL3eLvxmViLRga4qZhfNoVx7+IFqVR/8Mu7Lm30/WQcLLt2hdsop82gPUk3KCok0vTNIqiz2uhWEPkF2fnSMHcWQtlKs2vzmVWDvk2kwEcK+sat/Iayel9S+RWB/AIDGD1UhRkEBo/iQwRammSAnYNROMLVCrv0hDJeLdtJXdboHhiRvlt+O9LfvcZrXXhv80a0StALll0OO6DkXfpyqu6lIxZQckCRfIRQib6xK7SN3YJ+Ov6S9gMmvSUo6yc2AnejX9Zv/KSHROivX58pyRrBE0IA5xYcuoqTJg5qB6Jexi6undY9m7kynNsgr2rQKl/l1U5hlWXIDGrYlnwJobr48hEg7nkRFFTC6XjcztJ9rLlk6ySdGNIe2iy2FSoaG7IiM8E9+iD95ON7EVJH1gax0FQ9Lt6FEb0vEbI2DTTswjdUMlIV/gLK3gCkhN/UqXVe6C6ZJ9yvbqPoHjTJO9DEDB79hRuZxu81mtSexlDpOBnlwEFz0FPBl4n8oR+9NrUFJFxaSt3XAlV9el/9fkK+5C7dnOYpdeAAkIYZhHVWI6DbIKeVEZptRJZ5VlW7rFNDAnrcpHHjdleLBkh4QtVKJCehcpcL+Km1WLAyWnGd/xoOJ87ByNbUIN0JtCkZH3Wd23OkN5XmiFfTlLMLz6GMgNXxotxg==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB10743.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd606091-8fb8-4e1f-5ba0-08dbe116b3bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2023 11:26:22.3874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NKoMn0qeyL55bSPbZkOi5CGLmFLO3rhwgmXbAPWkBRszrFQn/8iNJ71ebYuqps4EUMdPndNQUWCz55RAw2txHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7801

SGkgRGF2ZSwNCg0KVGhhbmtzIGZvciB5b3VyIHYzIHBhdGNoLg0KV2UgaGF2ZSB0ZXN0ZWQgdGhl
IHBhdGNoIG9uIG91ciBlbnZpcm9ubWVudCwgaXQgd29ya3Mgd2VsbC4NCg0KUmV2aWV3ZWQtYnk6
IFhpYW8gWWFuZyA8eWFuZ3guanlAZnVqaXRzdS5jb20+DQpUZXN0ZWQtYnk6IFF1YW5xdWFuIENh
byA8Y2FvcXFAZnVqaXRzdS5jb20+DQoNCkJlc3QgUmVnYXJkcywNClhpYW8gWWFuZw0KDQotLS0t
LemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50
ZWwuY29tPiANCuWPkemAgeaXtumXtDogMjAyM+W5tDEx5pyIMeaXpSA1OjIxDQrmlLbku7bkuro6
IHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbQ0K5oqE6YCBOiBsaW51eC1jeGxAdmdlci5rZXJuZWwu
b3JnOyBudmRpbW1AbGlzdHMubGludXguZGV2OyBkYW4uai53aWxsaWFtc0BpbnRlbC5jb207IFlh
bmcsIFhpYW8v5p2oIOaZkyA8eWFuZ3guanlAZnVqaXRzdS5jb20+DQrkuLvpopg6IFtORENUTCBQ
QVRDSCB2M10gY3hsL3JlZ2lvbjogQWRkIC1mIG9wdGlvbiBmb3IgZGlzYWJsZS1yZWdpb24NCg0K
VGhlIGN1cnJlbnQgb3BlcmF0aW9uIGZvciBkaXNhYmxlLXJlZ2lvbiBkb2VzIG5vdCBjaGVjayBp
ZiB0aGUgbWVtb3J5IGNvdmVyZWQgYnkgYSByZWdpb24gaXMgb25saW5lIGJlZm9yZSBhdHRlbXB0
aW5nIHRvIGRpc2FibGUgdGhlIGN4bCByZWdpb24uDQpIYXZlIHRoZSB0b29sIGF0dGVtcHQgdG8g
b2ZmbGluZSB0aGUgcmVsZXZhbnQgbWVtb3J5IGJlZm9yZSBhdHRlbXB0aW5nIHRvIGRpc2FibGUg
dGhlIHJlZ2lvbihzKS4gSWYgb2ZmbGluZSBmYWlscywgc3RvcCBhbmQgcmV0dXJuIGVycm9yLg0K
DQpQcm92aWRlIGEgLWYgb3B0aW9uIGZvciB0aGUgcmVnaW9uIHRvIGNvbnRpbnVlIGRpc2FibGUg
dGhlIHJlZ2lvbiBldmVuIGlmIHRoZSBtZW1vcnkgaXMgbm90IG9mZmxpbmVkLiBBZGQgYSB3YXJu
aW5nIHRvIHN0YXRlIHRoYXQgdGhlIHBoeXNpY2FsIG1lbW9yeSBpcyBiZWluZyBsZWFrZWQgYW5k
IHVucmVjb3ZlcmFibGUgdW5sZXNzIHJlYm9vdCBkdWUgdG8gZGlzYWJsZSB3aXRob3V0IG9mZmxp
bmUuDQoNClNpZ25lZC1vZmYtYnk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0K
DQotLS0NCnYzOg0KLSBSZW1vdmUgbW92YWJsZSBjaGVjay4gKERhbikNCi0gQXR0ZW1wdCB0byBv
ZmZsaW5lIGlmIG5vdCBvZmZsaW5lLiAtZiB3aWxsIGRpc2FibGUgcmVnaW9uIGFueXdheXMgZXZl
bg0KICBpZiBtZW1vcnkgbm90IG9mZmxpbmUuIChEYW4pDQp2MjoNCi0gVXBkYXRlIGRvY3VtZW50
YXRpb24gYW5kIGhlbHAgb3V0cHV0LiAoVmlzaGFsKQ0KLS0tDQogRG9jdW1lbnRhdGlvbi9jeGwv
Y3hsLWRpc2FibGUtcmVnaW9uLnR4dCB8ICAgMTAgKysrKysrDQogY3hsL3JlZ2lvbi5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystDQogMiBmaWxlcyBjaGFuZ2VkLCA2MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoN
CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdpb24udHh0IGIv
RG9jdW1lbnRhdGlvbi9jeGwvY3hsLWRpc2FibGUtcmVnaW9uLnR4dA0KaW5kZXggNGIwNjI1ZTQw
YmY2Li45YWJmMTllOTYwOTQgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlz
YWJsZS1yZWdpb24udHh0DQorKysgYi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdp
b24udHh0DQpAQCAtMTQsNiArMTQsMTAgQEAgU1lOT1BTSVMNCiANCiBpbmNsdWRlOjpyZWdpb24t
ZGVzY3JpcHRpb24udHh0W10NCiANCitJZiB0aGVyZSBhcmUgbWVtb3J5IGJsb2NrcyB0aGF0IGFy
ZSBzdGlsbCBvbmxpbmUsIHRoZSBvcGVyYXRpb24gd2lsbCANCithdHRlbXB0IHRvIG9mZmxpbmUg
dGhlIHJlbGV2YW50IGJsb2Nrcy4gSWYgdGhlIG9mZmxpbmluZyBmYWlscywgdGhlIA0KK29wZXJh
dGlvbiBmYWlscyB3aGVuIG5vdCB1c2luZyB0aGUgLWYgKGZvcmNlKSBwYXJhbWV0ZXIuDQorDQog
RVhBTVBMRQ0KIC0tLS0tLS0NCiAtLS0tDQpAQCAtMjcsNiArMzEsMTIgQEAgT1BUSU9OUw0KIC0t
LS0tLS0NCiBpbmNsdWRlOjpidXMtb3B0aW9uLnR4dFtdDQogDQorLWY6Og0KKy0tZm9yY2U6Og0K
KwlBdHRlbXB0IHRvIGRpc2FibGUtcmVnaW9uIGV2ZW4gdGhvdWdoIG1lbW9yeSBjYW5ub3QgYmUg
b2ZmbGluZWQgc3VjY2Vzc2Z1bGx5Lg0KKwlXaWxsIGVtaXQgd2FybmluZyB0aGF0IG9wZXJhdGlv
biB3aWxsIHBlcm1hbmVudGx5IGxlYWsgcGhpc2NhbCBhZGRyZXNzIHNwYWNlDQorCWFuZCBjYW5u
b3QgYmUgcmVjb3ZlcmVkIHVudGlsIGEgcmVib290Lg0KKw0KIGluY2x1ZGU6OmRlY29kZXItb3B0
aW9uLnR4dFtdDQogDQogaW5jbHVkZTo6ZGVidWctb3B0aW9uLnR4dFtdDQpkaWZmIC0tZ2l0IGEv
Y3hsL3JlZ2lvbi5jIGIvY3hsL3JlZ2lvbi5jIGluZGV4IGJjZDcwMzk1NjIwNy4uNWNiYmYyNzQ5
ZTJkIDEwMDY0NA0KLS0tIGEvY3hsL3JlZ2lvbi5jDQorKysgYi9jeGwvcmVnaW9uLmMNCkBAIC0x
NCw2ICsxNCw3IEBADQogI2luY2x1ZGUgPHV0aWwvcGFyc2Utb3B0aW9ucy5oPg0KICNpbmNsdWRl
IDxjY2FuL21pbm1heC9taW5tYXguaD4NCiAjaW5jbHVkZSA8Y2Nhbi9zaG9ydF90eXBlcy9zaG9y
dF90eXBlcy5oPg0KKyNpbmNsdWRlIDxkYXhjdGwvbGliZGF4Y3RsLmg+DQogDQogI2luY2x1ZGUg
ImZpbHRlci5oIg0KICNpbmNsdWRlICJqc29uLmgiDQpAQCAtOTUsNiArOTYsOCBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IG9wdGlvbiBlbmFibGVfb3B0aW9uc1tdID0gew0KIA0KIHN0YXRpYyBjb25z
dCBzdHJ1Y3Qgb3B0aW9uIGRpc2FibGVfb3B0aW9uc1tdID0gew0KIAlCQVNFX09QVElPTlMoKSwN
CisJT1BUX0JPT0xFQU4oJ2YnLCAiZm9yY2UiLCAmcGFyYW0uZm9yY2UsDQorCQkgICAgImF0dGVt
cHQgdG8gb2ZmbGluZSBtZW1vcnkgYmVmb3JlIGRpc2FibGluZyB0aGUgcmVnaW9uIiksDQogCU9Q
VF9FTkQoKSwNCiB9Ow0KIA0KQEAgLTc4OSwxMyArNzkyLDYyIEBAIHN0YXRpYyBpbnQgZGVzdHJv
eV9yZWdpb24oc3RydWN0IGN4bF9yZWdpb24gKnJlZ2lvbikNCiAJcmV0dXJuIGN4bF9yZWdpb25f
ZGVsZXRlKHJlZ2lvbik7DQogfQ0KIA0KK3N0YXRpYyBpbnQgZGlzYWJsZV9yZWdpb24oc3RydWN0
IGN4bF9yZWdpb24gKnJlZ2lvbikgew0KKwljb25zdCBjaGFyICpkZXZuYW1lID0gY3hsX3JlZ2lv
bl9nZXRfZGV2bmFtZShyZWdpb24pOw0KKwlzdHJ1Y3QgZGF4Y3RsX3JlZ2lvbiAqZGF4X3JlZ2lv
bjsNCisJc3RydWN0IGRheGN0bF9tZW1vcnkgKm1lbTsNCisJc3RydWN0IGRheGN0bF9kZXYgKmRl
djsNCisJaW50IGZhaWxlZCA9IDAsIHJjOw0KKw0KKwlkYXhfcmVnaW9uID0gY3hsX3JlZ2lvbl9n
ZXRfZGF4Y3RsX3JlZ2lvbihyZWdpb24pOw0KKwlpZiAoIWRheF9yZWdpb24pDQorCQlnb3RvIG91
dDsNCisNCisJZGF4Y3RsX2Rldl9mb3JlYWNoKGRheF9yZWdpb24sIGRldikgew0KKwkJbWVtID0g
ZGF4Y3RsX2Rldl9nZXRfbWVtb3J5KGRldik7DQorCQlpZiAoIW1lbSkNCisJCQlyZXR1cm4gLUVO
WElPOw0KKw0KKwkJLyoNCisJCSAqIElmIG1lbW9yeSBpcyBzdGlsbCBvbmxpbmUgYW5kIHVzZXIg
d2FudHMgdG8gZm9yY2UgaXQsIGF0dGVtcHQNCisJCSAqIHRvIG9mZmxpbmUgaXQuDQorCQkgKi8N
CisJCWlmIChkYXhjdGxfbWVtb3J5X2lzX29ubGluZShtZW0pKSB7DQorCQkJcmMgPSBkYXhjdGxf
bWVtb3J5X29mZmxpbmUobWVtKTsNCisJCQlpZiAocmMgPCAwKSB7DQorCQkJCWxvZ19lcnIoJnJs
LCAiJXM6IHVuYWJsZSB0byBvZmZsaW5lICVzOiAlc1xuIiwNCisJCQkJCWRldm5hbWUsDQorCQkJ
CQlkYXhjdGxfZGV2X2dldF9kZXZuYW1lKGRldiksDQorCQkJCQlzdHJlcnJvcihhYnMocmMpKSk7
DQorCQkJCWlmICghcGFyYW0uZm9yY2UpDQorCQkJCQlyZXR1cm4gcmM7DQorDQorCQkJCWZhaWxl
ZCsrOw0KKwkJCX0NCisJCX0NCisJfQ0KKw0KKwlpZiAoZmFpbGVkKSB7DQorCQlsb2dfZXJyKCZy
bCwgIiVzOiBGb3JjaW5nIHJlZ2lvbiBkaXNhYmxlIHdpdGhvdXQgc3VjY2Vzc2Z1bCBvZmZsaW5l
LlxuIiwNCisJCQlkZXZuYW1lKTsNCisJCWxvZ19lcnIoJnJsLCAiJXM6IFBoeXNpY2FsIGFkZHJl
c3Mgc3BhY2UgaGFzIG5vdyBiZWVuIHBlcm1hbmVudGx5IGxlYWtlZC5cbiIsDQorCQkJZGV2bmFt
ZSk7DQorCQlsb2dfZXJyKCZybCwgIiVzOiBMZWFrZWQgYWRkcmVzcyBjYW5ub3QgYmUgcmVjb3Zl
cmVkIHVudGlsIGEgcmVib290LlxuIiwNCisJCQlkZXZuYW1lKTsNCisJfQ0KKw0KK291dDoNCisJ
cmV0dXJuIGN4bF9yZWdpb25fZGlzYWJsZShyZWdpb24pOw0KK30NCisNCiBzdGF0aWMgaW50IGRv
X3JlZ2lvbl94YWJsZShzdHJ1Y3QgY3hsX3JlZ2lvbiAqcmVnaW9uLCBlbnVtIHJlZ2lvbl9hY3Rp
b25zIGFjdGlvbikgIHsNCiAJc3dpdGNoIChhY3Rpb24pIHsNCiAJY2FzZSBBQ1RJT05fRU5BQkxF
Og0KIAkJcmV0dXJuIGN4bF9yZWdpb25fZW5hYmxlKHJlZ2lvbik7DQogCWNhc2UgQUNUSU9OX0RJ
U0FCTEU6DQotCQlyZXR1cm4gY3hsX3JlZ2lvbl9kaXNhYmxlKHJlZ2lvbik7DQorCQlyZXR1cm4g
ZGlzYWJsZV9yZWdpb24ocmVnaW9uKTsNCiAJY2FzZSBBQ1RJT05fREVTVFJPWToNCiAJCXJldHVy
biBkZXN0cm95X3JlZ2lvbihyZWdpb24pOw0KIAlkZWZhdWx0Og0KDQoNCg==

