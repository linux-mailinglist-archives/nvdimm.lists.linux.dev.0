Return-Path: <nvdimm+bounces-5857-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8196AD507
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Mar 2023 03:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 011E1280A7C
	for <lists+linux-nvdimm@lfdr.de>; Tue,  7 Mar 2023 02:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89BC938C;
	Tue,  7 Mar 2023 02:50:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179B836E
	for <nvdimm@lists.linux.dev>; Tue,  7 Mar 2023 02:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1678157435; x=1709693435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tNFqKY+eMx1n3Yh1RWDvVv7QIpG9Gdb+acQHEfPE+EM=;
  b=QMQeeLhJy3XKeCv2YqjU5XufPjclOc/kL+DUni5rHvjcwdPp3MhfD1rn
   PdXNuhtJpokNKza0Xt2QsORLVLbSzsGxlT9+CG894XYWeiLXfmKPZke4Z
   EubJtdzDYmPisZmPw9/Wq09nei1UlDpVC0aJe48l8cTSeynvmq2jMMS6r
   zGO5KlyBT7Z9LMNZmE9mSAM+j3qnkJXR3qVQOieGJ5FZZM2NVdELb/KJ2
   RMUAPoPBTiIiXNJEYb+M9lMlNv6oJIZg5a+QfLXBreIbBD4MAPI8xNLqx
   6V3kUyNMaxxqrW8mKpIdyTWo+7WCpGRp+zEpIkTPXxolGjiPRusSwXONn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="78529966"
X-IronPort-AV: E=Sophos;i="5.98,238,1673881200"; 
   d="scan'208";a="78529966"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 11:49:19 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpDHOXgngBAQNt+ArjgdggIv+zl5v4NCVQCDDY+SZKBEPzo9DpsoNwDhY8hsk/nR2T24RD8VYPzrmBvufSj7A4Pfvem0id+SNWgpYBhMZMVggEhc21idFEuth189Cem3QDpGmB3aBYr+kpvAlSHKe3YGUMr+h+GqFrjkPOpW/Itx0qB4V3d06gFv0M+N7S6BrqQ58khzAqgfRD6aIpGdvSOhuJWW/k2fYzxt4hINFL+5DRZOpxYK5H6fiZSK5tycx8GSaN7PbC2g2XqMWzzLl6ldf4MD1UAzihksmukdoU7H/XCfLqgGcRVryS7a3Bk3BHabBhSprepuc8STiUOEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNFqKY+eMx1n3Yh1RWDvVv7QIpG9Gdb+acQHEfPE+EM=;
 b=mmO0OJCuBXbyC4XuINAc/+ruDMlfAz6T6gsEFSMa9Eszcw/ztqy+znzVvmiB+0D0UeT4BursKvjAeml9gepw/qrkuGYiLM76vkHSnKbLC7ewgLqiCX6spzoacjudAfPdjr2YwrmOwheks+dED8b6H8uKWFFJlHjrTcrNRfOclQR2FcbJKDhtV8IA1cnxPuWQEqY96+8TNJxxrOCneZ31Ie66aGx8hpVmyOez6HiIHKn0B5DxeznymO7/yYcd3KT/dX7pPpSiDLV8U0JtKeCdUDzGeKkLePZWO/a6D2wDw2TJHf9qOwvPv/UBBhNQXf6ctj7hohGKj6iZz7EQmolm5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by OS0PR01MB5828.jpnprd01.prod.outlook.com
 (2603:1096:604:b9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 02:49:16 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58%9]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 02:49:16 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: =?utf-8?B?SEFHSU8gS0FaVUhJVE8o6JCp5bC+IOS4gOS7gSk=?= <k-hagio-ab@nec.com>,
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
Thread-Index: AQHZR0+Bi1lA/ErA5EK0zxLjybbH0K7uo9aAgAAMWAA=
Date: Tue, 7 Mar 2023 02:49:15 +0000
Message-ID: <19f1578d-476d-53cd-a9ff-166ff3d2bc80@fujitsu.com>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <1fecbb60-d9f1-908c-31c9-16a3c890cf3f@nec.com>
In-Reply-To: <1fecbb60-d9f1-908c-31c9-16a3c890cf3f@nec.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|OS0PR01MB5828:EE_
x-ms-office365-filtering-correlation-id: 298feb2d-ddb7-4deb-970a-08db1eb68a85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 AjiGUOWi3D6c7+m8r2U+/l4RLEIlhL/UHTiDDWw+6K4pojJHbOqDOZNyeji5StUKW639MkZwW6X2YsqWkvWQcH35PUnXcC4TiZXruvj2uC1iWfV4ihKq1MgTPvg3TUk7uLIh/LCS2OsP3FmIrUtVf3mGFg/tpupk76bxY/jCDnFnoR5a1mDCzz4dggY5EC8vc8C793oAQL2wS6eldG0xgmZ/ClCSB5vff7LtK8jULjvnyvKwJ93QhMUukSGh9NwCFWbCJ3mhRy7z/yXRJyx8vBFAUlLFedErX9Ta+UBEGlpPUxiWdgPoO6TXyUaAgTEFsdKO+jrKqfIpKQtjwSJitgAPwTWNY3DPX6/azbJ6N5i2NsXTt57vYkW1RcOzwzeHYPKYW8x0a5IKP1E/QHn2Uzcm3E8vdml1Rm2HZahzmD8LYPuk/JsPJbSHuyZp3x5NyZUoyv0qwpm0kuxZnMVkcP5r1kkE6Y10Ki9Zqm3zOlE8Zca+vw5ZQYQ7qvR5aAH7291P7G6Os6Ne8m5Aw0tK6rEZ1BDbs3ngiC5iNUHYf1qPkOn4FJom4+CC4XuGErPp2HHP/8Re6v3dshGPt3lO/xAMWjD3Zg/ChNHVqtOQmw/X8fMGTy7sVWWICkmCGv3h97R6DCQF3R8bF53+o365CUo1pinMoVi7OHxxrPQ1zeOquZvG3thGB+UE3EHqc45SJltFz1s0XZxwv408i7Mj7t2c4s6WdmyYb0g9aclKZkUfrpFaGFMK3L6CHw2FjjV3K4wPYetQ3tamFL+eALgOqz5+ys4Iol+toDtT8C2yVwY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(1590799015)(2906002)(38100700002)(122000001)(82960400001)(186003)(26005)(53546011)(6506007)(6512007)(66899018)(2616005)(31686004)(107886003)(38070700005)(1580799012)(66946007)(64756008)(66446008)(66476007)(91956017)(478600001)(76116006)(966005)(66556008)(8936002)(5660300002)(6486002)(7416002)(41300700001)(31696002)(71200400001)(85182001)(110136005)(54906003)(316002)(36756003)(8676002)(4326008)(86362001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFZKYU9nUko2dlNpZkZuK0R1MmdudEFWdWFMaWNaUmdxMGNTV0J4d3QwaGZz?=
 =?utf-8?B?dzB2Mk1xOWJFeUhZeW13NlE5U2xoMDBDVHA1V1RpNUhnY0ZqOUtvV1BZSGlH?=
 =?utf-8?B?V0g0dFdLLzN6ZkdYcFM1NzBDS2pDN2ZCcTVwWTdrNGtKUCtsN1FOZXV2b0pD?=
 =?utf-8?B?c1FHRitwRmwzSm5YcnFPMWFIK0JwYk5YS2dOZGw5dHhMQU56bkRFQ1JWQ09M?=
 =?utf-8?B?QXVMakZlaDRpZXpSdHViZ3AvNG9PSTlJOVNtRVdkSnZZcGk0UEJMbjhyT0s4?=
 =?utf-8?B?cUtkZWNxbXg3aWpyMFJSeThYRit2Z2ZsTkxLNTZPbnhJZEtvWFBtbGN5SmFw?=
 =?utf-8?B?Z09SYVRUZmFRbXFHL3R2eGFmM1FXZ1Uvc2VyRjBCb1ZOL0J4eGwxZ1BUcFh6?=
 =?utf-8?B?MjN5RzVUVllKMGJEeUlqSEdPWkFESlQ1WlBoL090WGx5NENWRUplRnUzZ1lw?=
 =?utf-8?B?bkhVYnM3cHMvQVp1V01sVkRVYlExcnI5SHMxSXFpakZaMzN0UVdVS0F6VVht?=
 =?utf-8?B?VUk0Qm9oQWYyUnR0clhETUM2UTVYSkJFMzZqRUpPYVdCVmJDTjZTd0hjVXlV?=
 =?utf-8?B?YWFOYVExSFhNRlNXTVY2bE9Wd0NlRWIyeWh6REJRL00vQ3IrM2lzUGdIa1R2?=
 =?utf-8?B?bzNLODMxTkVjL2Y5WE9yMGt5QXhYYlM3ajcweTNWZHI2MzZUby91S2pCQWY1?=
 =?utf-8?B?SVJ6ck5tRFJvaWlPV294TGhTMmRaNC9LTTlsdUU1WWpIRDFFZ1R1dWxsOUhN?=
 =?utf-8?B?MWwxaE9RZ3lRQmJpdzRxRWpTN1d0OWxGTXJmVlpDM0tVcHBQZzlOaGV2L3Y4?=
 =?utf-8?B?Q3lZbkZ5RlVtQ0pteFBTU2tnY2tMUCt5Y2QrYTFDV0wzWDJtTS9jNHNOUWZM?=
 =?utf-8?B?UmZUWDFaYmgvakdMN2FzL3BVaTh0Vjlmd3packZlbHBYekcrV3FZQkk2ZWlN?=
 =?utf-8?B?b2R4YlYxUVRnWDd5dGFXSzE3MHI1aEs5NnloZi9sVXU0N3l6Vzg3bjFCMnRn?=
 =?utf-8?B?Wk1PdUdBcmlSdEVvV1M4ZkNmc2dXdUhxWlJxZDE1YmxRYlR1RWZGdmZFQkQ5?=
 =?utf-8?B?bjNoM2tGNXg5SHp0bmpBUi9ONUE2czV5QytBU055Tm9TNUoyZlBMS25rb0VW?=
 =?utf-8?B?T2FXSG5zc3FtREpQMDNidUFLMlZvV2FCeTRYbUJoZjRpLzBwdmdQQ2pycXhy?=
 =?utf-8?B?WmlwLzBvazZueEFLOHVHMHNsZlNOWCtPcllJb2gvR0Qrd000LzNrSTA1Q1Nw?=
 =?utf-8?B?STc3OHBucEJqU01IVkkyckZ4eWgwVWcva0djVTUrd2g5TnRLeTdJRGwzcjZX?=
 =?utf-8?B?UU11bk1OakRCd1pxRnlOVDhYKys0NTZpWVNsNXJTUGs2SUFyUmVxb1JDcXpW?=
 =?utf-8?B?RE80RHFYWHNuSEZCVitycEY0U3BncFFuRDY3QzN6ejEyb1F1N21VZUplQmNZ?=
 =?utf-8?B?Y3hJSlp3NW9CWlUxWmJaa0RuWW0yNzExRTBOeE9JU21jSlJHUTJKMkxaczRV?=
 =?utf-8?B?d25IKy9XaC9DU1BnMWNyY1NWcFBFNFFYK1FTSWk0Smp0V3RMcndrcnFkV0tt?=
 =?utf-8?B?V2RoK1JvWC8xelV4d1k0Sml6QUUzc2g1M3ZOa1RoMnhrRC9QbkdIOXZxalRI?=
 =?utf-8?B?TG1CMGdiZ3hxaVA3TWd4dTYwSVpCOWRQNVJ6NDdJOVVqVk8yd09FWEdwRzRH?=
 =?utf-8?B?dDVyK0s4S2QwdU1mYWJ4T1dBd1dVKzNtcUs2dHA0WEY4L2xsaWRWQWdBWkVq?=
 =?utf-8?B?WHNsbXJzcjFwYi9NRjF4NzRGeHV0VXNkanlISEFPTUZVZEV0UTBkeTdJaUsw?=
 =?utf-8?B?S21pdFlUTmp4dUpueTJjT3VpUm56UE1tY0YzQXl1azdIVXJnalpBWWFENUdL?=
 =?utf-8?B?Y1h3cEdGWm1WZ0JpbE5aTDBtSW5wQk5yNnVUQS96WnhvWlJXRWNGRXBRSmg4?=
 =?utf-8?B?STNhaC8zYVBsU1ZrWnRkbDdHRFl3bG5pMVRtVktQNFAwRndQN0R1K0ptTzhK?=
 =?utf-8?B?RlZqN3Z0OThTV204eTVFQURhRkZBcWNyYXpkVzJRSFVYZUUzYnNLOEM0UFVv?=
 =?utf-8?B?OEpFN1pQOTlaM2hXbkFWdGZoek9Wb2JFQWJIU2JjcktCOE1WM1ZMTEVjc2h4?=
 =?utf-8?B?VDJCdGNZY1J1cFd4L3dsQU5mMnYxN24vR3cwNjNodk1nTUlvcjBGYjd4bkdk?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA6442A895267D4AAA3E42A28CCA1140@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?utf-8?B?eTJNb2NZVmdoUkkvRjlqWkhNUTh6M2oreXZPWWhNend0clp4MFRjRmNaYW5V?=
 =?utf-8?B?WEY5R29DSWxJc2pyZWE4a0lDaFMxSEh3RGdxcGtLeUNIWEI2OTNxaGVWUkdk?=
 =?utf-8?B?Q0xxSktSSVd5YXRHYlAyWm5KTjRObFJSZTNJdDhKblkzZGlBNTcyeDVKa3hl?=
 =?utf-8?B?TDNZMjljNnR4dWhSSGRsalBkWjVyYXRZRTFmdFl1bk9CcXM1bzFYL3BLNmlQ?=
 =?utf-8?B?c0Iya2NmMDRGbWJMWnBuZUk0Vlc5NkpsOUFVOWRaR2w3VEFSQ1g5V3hYNDZK?=
 =?utf-8?B?U0FpSW94SDQwMzNLdG03eElsVUl6WXpld2dDU0w4QWk1eHhxNzVua3Fjd2ty?=
 =?utf-8?B?eUlrWHJMN2xXWWpFN0N2aGt6ejlQcFhoMUFtYlFLV1ptZjV5YndVY3VDbkpV?=
 =?utf-8?B?eVRtL0E3R1NxaXBERGlLZnJHM0FoNUNGL2hYUGZrdTYxem4vQVp6QWpuenlI?=
 =?utf-8?B?cU04T085Nm96eHZLbTk1V21DdHpBcWo0VzNvcWZOZlZWU2RLZDQyRGJHeUdR?=
 =?utf-8?B?VUYwVTVORjdvbi9CbTdBdEZ2WDJ4U1RscU1oYWdLYkozaXVaREZHSUo1U2lP?=
 =?utf-8?B?anpxQXZaMnlJT3N3UjE1djRJZHlWWmVzbS9rOUYrZWlIUk9zNHV6VXNmVjZM?=
 =?utf-8?B?eDIyYTNNLzlLUGFvRHlQeDAwTTl4K2sxdDJMN2w1cEwvTjRkWTg4MkZFZmgr?=
 =?utf-8?B?T0dWcFRONENCVjc5MHZjL01NUTlzNDJ0NVBWTHF1SlkrMVFITHprZjk1YTMr?=
 =?utf-8?B?Tnp5emRUeDBvUVhyTHRzcmVTTFcrOGxUU0QvTStTaktpSEs2S1hCZm5uUE9G?=
 =?utf-8?B?UVZScWtNbkk4VDY2VHJiT05Sc3dTR3hVNm5xQVFkRUhzdWtNWWd5a1RGdVpE?=
 =?utf-8?B?bHlJRzUra0FUaGZId005TUkxN1QwVnR2aU5YY255R1k1Zk1HWTNsU1g3UURo?=
 =?utf-8?B?a3JDbXZsbnpua1JubWxHUC9vT1ppVU93OUZscVljRUhxNHk3RnhzY1MrTVpB?=
 =?utf-8?B?aG9oWDlmUkhockR2QVh2dERzQU13ZkpyVm9TT2J5SnIyc3luTEFhZjlHOWhl?=
 =?utf-8?B?dEtTWkFlejRFWElzVlUyckR0UFoxTTMyaXJTNTJQNDNsM2EvVmp4KzdCWUhJ?=
 =?utf-8?B?eThJK0FoT0ZyTWNzdXJYVDBBdFdETWF2REdwNDVzV2ZWTHJVRUtRQmJPQ0hZ?=
 =?utf-8?B?TWYxT2dmN0pvWG5mTlZSOTNIU2Zuai9xM2xrRVZHMjZyVnd3MUFqSTlwYlJa?=
 =?utf-8?B?UnZadjhqRWhHSkkwY0F2Ry9CaUZWSlNQVGdDcmp1Y0szQXdXM21YK0lsd3lD?=
 =?utf-8?B?eVdKQmxvcUFpTU45M1lyWVVwbE94d0xOZWNQNkNweDhDdmo0ZHZFWnBMRHRu?=
 =?utf-8?B?RTVFTm5VRjlLYmc9PQ==?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298feb2d-ddb7-4deb-970a-08db1eb68a85
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 02:49:15.9636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgsk0FTef0OAtaRmSvZblLNkjtvwF6Wx21xK4XEUNpv/vY3rzv99+zd6yhT2dR0P6gJrowirP9Myn27dA5YIHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5828

DQoNCk9uIDA3LzAzLzIwMjMgMTA6MDUsIEhBR0lPIEtBWlVISVRPKOiQqeWwviDkuIDku4EpIHdy
b3RlOg0KPiBPbiAyMDIzLzAyLzIzIDE1OjI0LCBsaXpoaWppYW5AZnVqaXRzdS5jb20gd3JvdGU6
DQo+PiBIZWxsbyBmb2xrcywNCj4+DQo+PiBUaGlzIG1haWwgcmFpc2VzIGEgcG1lbSBtZW1tYXAg
ZHVtcCByZXF1aXJlbWVudCBhbmQgcG9zc2libGUgc29sdXRpb25zLCBidXQgdGhleSBhcmUgYWxs
IHN0aWxsIHByZW1hdHVyZS4NCj4+IEkgcmVhbGx5IGhvcGUgeW91IGNhbiBwcm92aWRlIHNvbWUg
ZmVlZGJhY2suDQo+Pg0KPj4gcG1lbSBtZW1tYXAgY2FuIGFsc28gYmUgY2FsbGVkIHBtZW0gbWV0
YWRhdGEgaGVyZS4NCj4+DQo+PiAjIyMgQmFja2dyb3VuZCBhbmQgbW90aXZhdGUgb3ZlcnZpZXcg
IyMjDQo+PiAtLS0NCj4+IENyYXNoIGR1bXAgaXMgYW4gaW1wb3J0YW50IGZlYXR1cmUgZm9yIHRy
b3VibGUgc2hvb3Rpbmcgb2Yga2VybmVsLiBJdCBpcyB0aGUgZmluYWwgd2F5IHRvIGNoYXNlIHdo
YXQNCj4+IGhhcHBlbmVkIGF0IHRoZSBrZXJuZWwgcGFuaWMsIHNsb3dkb3duLCBhbmQgc28gb24u
IEl0IGlzIHRoZSBtb3N0IGltcG9ydGFudCB0b29sIGZvciBjdXN0b21lciBzdXBwb3J0Lg0KPj4g
SG93ZXZlciwgYSBwYXJ0IG9mIGRhdGEgb24gcG1lbSBpcyBub3QgaW5jbHVkZWQgaW4gY3Jhc2gg
ZHVtcCwgaXQgbWF5IGNhdXNlIGRpZmZpY3VsdHkgdG8gYW5hbHl6ZQ0KPj4gdHJvdWJsZSBhcm91
bmQgcG1lbSAoZXNwZWNpYWxseSBGaWxlc3lzdGVtLURBWCkuDQo+Pg0KPj4NCj4+IEEgcG1lbSBu
YW1lc3BhY2UgaW4gImZzZGF4IiBvciAiZGV2ZGF4IiBtb2RlIHJlcXVpcmVzIGFsbG9jYXRpb24g
b2YgcGVyLXBhZ2UgbWV0YWRhdGFbMV0uIFRoZSBhbGxvY2F0aW9uDQo+PiBjYW4gYmUgZHJhd24g
ZnJvbSBlaXRoZXIgbWVtKHN5c3RlbSBtZW1vcnkpIG9yIGRldihwbWVtIGRldmljZSksIHNlZSBg
bmRjdGwgaGVscCBjcmVhdGUtbmFtZXNwYWNlYCBmb3INCj4+IG1vcmUgZGV0YWlscy4gSW4gZnNk
YXgsIHN0cnVjdCBwYWdlIGFycmF5IGJlY29tZXMgdmVyeSBpbXBvcnRhbnQsIGl0IGlzIG9uZSBv
ZiB0aGUga2V5IGRhdGEgdG8gZmluZA0KPj4gc3RhdHVzIG9mIHJldmVyc2UgbWFwLg0KPj4NCj4+
IFNvLCB3aGVuIG1ldGFkYXRhIHdhcyBzdG9yZWQgaW4gcG1lbSwgZXZlbiBwbWVtJ3MgcGVyLXBh
Z2UgbWV0YWRhdGEgd2lsbCBub3QgYmUgZHVtcGVkLiBUaGF0IG1lYW5zDQo+PiB0cm91Ymxlc2hv
b3RlcnMgYXJlIHVuYWJsZSB0byBjaGVjayBtb3JlIGRldGFpbHMgYWJvdXQgcG1lbSBmcm9tIHRo
ZSBkdW1wZmlsZS4NCj4+DQo+PiAjIyMgTWFrZSBwbWVtIG1lbW1hcCBkdW1wIHN1cHBvcnQgIyMj
DQo+PiAtLS0NCj4+IE91ciBnb2FsIGlzIHRoYXQgd2hldGhlciBtZXRhZGF0YSBpcyBzdG9yZWQg
b24gbWVtIG9yIHBtZW0sIGl0cyBtZXRhZGF0YSBjYW4gYmUgZHVtcGVkIGFuZCB0aGVuIHRoZQ0K
Pj4gY3Jhc2gtdXRpbGl0aWVzIGNhbiByZWFkIG1vcmUgZGV0YWlscyBhYm91dCB0aGUgcG1lbS4g
T2YgY291cnNlLCB0aGlzIGZlYXR1cmUgY2FuIGJlIGVuYWJsZWQvZGlzYWJsZWQuDQo+Pg0KPj4g
Rmlyc3QsIGJhc2VkIG9uIG91ciBwcmV2aW91cyBpbnZlc3RpZ2F0aW9uLCBhY2NvcmRpbmcgdG8g
dGhlIGxvY2F0aW9uIG9mIG1ldGFkYXRhIGFuZCB0aGUgc2NvcGUgb2YNCj4+IGR1bXAsIHdlIGNh
biBkaXZpZGUgaXQgaW50byB0aGUgZm9sbG93aW5nIGZvdXIgY2FzZXM6IEEsIEIsIEMsIEQuDQo+
PiBJdCBzaG91bGQgYmUgbm90ZWQgdGhhdCBhbHRob3VnaCB3ZSBtZW50aW9uZWQgY2FzZSBBJkIg
YmVsb3csIHdlIGRvIG5vdCB3YW50IHRoZXNlIHR3byBjYXNlcyB0byBiZQ0KPj4gcGFydCBvZiB0
aGlzIGZlYXR1cmUsIGJlY2F1c2UgZHVtcGluZyB0aGUgZW50aXJlIHBtZW0gd2lsbCBjb25zdW1l
IGEgbG90IG9mIHNwYWNlLCBhbmQgbW9yZSBpbXBvcnRhbnRseSwNCj4+IGl0IG1heSBjb250YWlu
IHVzZXIgc2Vuc2l0aXZlIGRhdGEuDQo+Pg0KPj4gKy0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLSst
LS0tLS0tLS0tLS0rDQo+PiB8XCstLS0tLS0tLStcICAgICBtZXRhZGF0YSBsb2NhdGlvbiAgIHwN
Cj4+IHwgICAgICAgICAgICArKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPj4gfCBkdW1wIHNj
b3BlICB8ICBtZW0gICAgIHwgICBQTUVNICAgICB8DQo+PiArLS0tLS0tLS0tLS0tLSstLS0tLS0t
LS0tKy0tLS0tLS0tLS0tLSsNCj4+IHwgZW50aXJlIHBtZW0gfCAgICAgQSAgICB8ICAgICBCICAg
ICAgfA0KPj4gKy0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0rDQo+PiB8IG1l
dGFkYXRhICAgIHwgICAgIEMgICAgfCAgICAgRCAgICAgIHwNCj4+ICstLS0tLS0tLS0tLS0tKy0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KPj4NCj4+IENhc2UgQSZCOiB1bnN1cHBvcnRlZA0KPj4g
LSBPbmx5IHRoZSByZWdpb25zIGxpc3RlZCBpbiBQVF9MT0FEIGluIHZtY29yZSBhcmUgZHVtcGFi
bGUuIFRoaXMgY2FuIGJlIHJlc29sdmVkIGJ5IGFkZGluZyB0aGUgcG1lbQ0KPj4gcmVnaW9uIGlu
dG8gdm1jb3JlJ3MgUFRfTE9BRHMgaW4ga2V4ZWMtdG9vbHMuDQo+PiAtIEZvciBtYWtlZHVtcGZp
bGUgd2hpY2ggd2lsbCBhc3N1bWUgdGhhdCBhbGwgcGFnZSBvYmplY3RzIG9mIHRoZSBlbnRpcmUg
cmVnaW9uIGRlc2NyaWJlZCBpbiBQVF9MT0FEcw0KPj4gYXJlIHJlYWRhYmxlLCBhbmQgdGhlbiBz
a2lwcy9leGNsdWRlcyB0aGUgc3BlY2lmaWMgcGFnZSBhY2NvcmRpbmcgdG8gaXRzIGF0dHJpYnV0
ZXMuIEJ1dCBpbiB0aGUgY2FzZQ0KPj4gb2YgcG1lbSwgMXN0IGtlcm5lbCBvbmx5IGFsbG9jYXRl
cyBwYWdlIG9iamVjdHMgZm9yIHRoZSBuYW1lc3BhY2VzIG9mIHBtZW0sIHNvIG1ha2VkdW1wZmls
ZSB3aWxsIHRocm93DQo+PiBlcnJvcnNbMl0gd2hlbiBzcGVjaWZpYyAtZCBvcHRpb25zIGFyZSBz
cGVjaWZpZWQuDQo+PiBBY2NvcmRpbmdseSwgd2Ugc2hvdWxkIG1ha2UgbWFrZWR1bXBmaWxlIHRv
IGlnbm9yZSB0aGVzZSBlcnJvcnMgaWYgaXQncyBwbWVtIHJlZ2lvbi4NCj4+DQo+PiBCZWNhdXNl
IHRoZXNlIGFib3ZlIGNhc2VzIGFyZSBub3QgaW4gb3VyIGdvYWwsIHdlIG11c3QgY29uc2lkZXIg
aG93IHRvIHByZXZlbnQgdGhlIGRhdGEgcGFydCBvZiBwbWVtDQo+PiBmcm9tIHJlYWRpbmcgYnkg
dGhlIGR1bXAgYXBwbGljYXRpb24obWFrZWR1bXBmaWxlKS4NCj4+DQo+PiBDYXNlIEM6IG5hdGl2
ZSBzdXBwb3J0ZWQNCj4+IG1ldGFkYXRhIGlzIHN0b3JlZCBpbiBtZW0sIGFuZCB0aGUgZW50aXJl
IG1lbS9yYW0gaXMgZHVtcGFibGUuDQo+Pg0KPj4gQ2FzZSBEOiB1bnN1cHBvcnRlZCAmJiBuZWVk
IHlvdXIgaW5wdXQNCj4+IFRvIHN1cHBvcnQgdGhpcyBzaXR1YXRpb24sIHRoZSBtYWtlZHVtcGZp
bGUgbmVlZHMgdG8ga25vdyB0aGUgbG9jYXRpb24gb2YgbWV0YWRhdGEgZm9yIGVhY2ggcG1lbQ0K
Pj4gbmFtZXNwYWNlIGFuZCB0aGUgYWRkcmVzcyBhbmQgc2l6ZSBvZiBtZXRhZGF0YSBpbiB0aGUg
cG1lbSBbc3RhcnQsIGVuZCkNCj4+DQo+PiBXZSBoYXZlIHRob3VnaHQgb2YgYSBmZXcgcG9zc2li
bGUgb3B0aW9uczoNCj4+DQo+PiAxKSBJbiB0aGUgMm5kIGtlcm5lbCwgd2l0aCB0aGUgaGVscCBv
ZiB0aGUgaW5mb3JtYXRpb24gZnJvbSAvc3lzL2J1cy9uZC9kZXZpY2VzL3tuYW1lc3BhY2VYLlks
IGRheFguWSwgcGZuWC5ZfQ0KPj4gZXhwb3J0ZWQgYnkgcG1lbSBkcml2ZXJzLCBtYWtlZHVtcGZp
bGUgaXMgYWJsZSB0byBjYWxjdWxhdGUgdGhlIGFkZHJlc3MgYW5kIHNpemUgb2YgbWV0YWRhdGEN
Cj4+IDIpIEluIHRoZSAxc3Qga2VybmVsLCBhZGQgYSBuZXcgc3ltYm9sIHRvIHRoZSB2bWNvcmUu
IFRoZSBzeW1ib2wgaXMgYXNzb2NpYXRlZCB3aXRoIHRoZSBsYXlvdXQgb2YNCj4+IGVhY2ggbmFt
ZXNwYWNlLiBUaGUgbWFrZWR1bXBmaWxlIHJlYWRzIHRoZSBzeW1ib2wgYW5kIGZpZ3VyZXMgb3V0
IHRoZSBhZGRyZXNzIGFuZCBzaXplIG9mIHRoZSBtZXRhZGF0YS4NCj4gDQo+IEhpIFpoaWppYW4s
DQo+IA0KPiBzb3JyeSwgcHJvYmFibHkgSSBkb24ndCB1bmRlcnN0YW5kIGVub3VnaCwgYnV0IGRv
IHRoZXNlIG1lYW4gdGhhdA0KPiAgICAxLiAvcHJvYy92bWNvcmUgZXhwb3J0cyBwbWVtIHJlZ2lv
bnMgd2l0aCBQVF9MT0FEcywgd2hpY2ggY29udGFpbg0KPiAgICAgICB1bnJlYWRhYmxlIG9uZXMs
IGFuZA0KPiAgICAyLiBtYWtlZHVtcGZpbGUgZ2V0cyB0byBrbm93IHRoZSByZWFkYWJsZSByZWdp
b25zIHNvbWVob3c/DQoNCkthenUsDQoNCkdlbmVyYWxseSwgb25seSBtZXRhZGF0YSBvZiBwbWVt
IGlzIHJlYWRhYmxlIGJ5IGNyYXNoLXV0aWxpdGllcywgYmVjYXVzZSBtZXRhZGF0YSBjb250YWlu
cyBpdHMgb3duIG1lbW1hcChwYWdlIGFycmF5KS4NClRoZSByZXN0IHBhcnQgb2YgcG1lbSB3aGlj
aCBjb3VsZCBiZSB1c2VkIGFzIGEgYmxvY2sgZGV2aWNlKERBWCBmaWxlc3lzdGVtKSBvciBvdGhl
ciBwdXJwb3NlLCBzbyBpdCdzIG5vdCBtdWNoIGhlbHBmdWwNCmZvciB0aGUgdHJvdWJsZXNob290
aW5nLg0KDQpJbiBteSB1bmRlcnN0YW5kaW5nLCBQVF9MT0FEcyBpcyBwYXJ0IG9mIEVMRiBmb3Jt
YXQsIGl0IGNvbXBsaWVzIHdpdGggd2hhdCBpdCdzLg0KSW4gbXkgY3VycmVudCB0aG91Z2h0cywN
CjEuIGNyYXNoLXRvb2wgd2lsbCBleHBvcnQgdGhlIGVudGlyZSBwbWVtIHJlZ2lvbiB0byAvcHJv
Yy92bWNvcmUuIG1ha2VkdW1wZmlsZS9jcCBldGMgY29tbWFuZHMgY2FuIHJlYWQgdGhlIGVudGly
ZQ0KcG1lbSByZWdpb24gZGlyZWN0bHkuDQoyLiBleHBvcnQgdGhlIG5hbWVzcGFjZSBsYXlvdXQg
dG8gdm1jb3JlIGFzIGEgc3ltYm9sLCB0aGVuIGR1bXBpbmcgYXBwbGljYXRpb25zKG1ha2VkdW1w
ZmlsZSkgY2FuIGZpZ3VyZSBvdXQgd2hlcmUNCnRoZSBtZXRhZGF0YSBpcywgYW5kIHJlYWQgbWV0
YWRhdGEgb25seS4NCg0KTm90IHN1cmUgd2hldGhlciB0aGUgcmVwbHkgaXMgaGVscGZ1bCwgaWYg
eW91IGhhdmUgYW55IG90aGVyIHF1ZXN0aW9ucywgZmVlbCBmcmVlIHRvIGxldCBtZSBrbm93LiA6
KQ0KDQoNClRoYW5rcw0KWmhpamlhbg0KDQo+IA0KPiBUaGVuIC9wcm9jL3ZtY29yZSB3aXRoIHBt
ZW0gY2Fubm90IGJlIGNhcHR1cmVkIGJ5IG90aGVyIGNvbW1hbmRzLA0KPiBlLmcuIGNwIGNvbW1h
bmQ/DQo+IA0KPiBUaGFua3MsDQo+IEthenUNCj4gDQo+PiAzKSBvdGhlcnMgPw0KPj4NCj4+IEJ1
dCB0aGVuIHdlIGZvdW5kIHRoYXQgd2UgaGF2ZSBhbHdheXMgaWdub3JlZCBhIHVzZXIgY2FzZSwg
dGhhdCBpcywgdGhlIHVzZXIgY291bGQgc2F2ZSB0aGUgZHVtcGZpbGUNCj4+IHRvIHRoZSBwbWVt
LiBOZWl0aGVyIG9mIHRoZXNlIHR3byBvcHRpb25zIGNhbiBzb2x2ZSB0aGlzIHByb2JsZW0sIGJl
Y2F1c2UgdGhlIHBtZW0gZHJpdmVycyB3aWxsDQo+PiByZS1pbml0aWFsaXplIHRoZSBtZXRhZGF0
YSBkdXJpbmcgdGhlIHBtZW0gZHJpdmVycyBsb2FkaW5nIHByb2Nlc3MsIHdoaWNoIGxlYWRzIHRv
IHRoZSBtZXRhZGF0YQ0KPj4gd2UgZHVtcGVkIGlzIGluY29uc2lzdGVudCB3aXRoIHRoZSBtZXRh
ZGF0YSBhdCB0aGUgbW9tZW50IG9mIHRoZSBjcmFzaCBoYXBwZW5pbmcuDQo+PiBTaW1wbHksIGNh
biB3ZSBqdXN0IGRpc2FibGUgdGhlIHBtZW0gZGlyZWN0bHkgaW4gMm5kIGtlcm5lbCBzbyB0aGF0
IHByZXZpb3VzIG1ldGFkYXRhIHdpbGwgbm90IGJlDQo+PiBkZXN0cm95ZWQ/IEJ1dCB0aGlzIG9w
ZXJhdGlvbiB3aWxsIGJyaW5nIHVzIGluY29udmVuaWVuY2UgdGhhdCAybmQga2VybmVsIGRvZXNu
4oCZdCBhbGxvdyB1c2VyIHN0b3JpbmcNCj4+IGR1bXBmaWxlIG9uIHRoZSBmaWxlc3lzdGVtL3Bh
cnRpdGlvbiBiYXNlZCBvbiBwbWVtLg0KPj4NCj4+IFNvIGhlcmUgSSBob3BlIHlvdSBjYW4gcHJv
dmlkZSBzb21lIGlkZWFzIGFib3V0IHRoaXMgZmVhdHVyZS9yZXF1aXJlbWVudCBhbmQgb24gdGhl
IHBvc3NpYmxlIHNvbHV0aW9uDQo+PiBmb3IgdGhlIGNhc2VzIEEmQiZEIG1lbnRpb25lZCBhYm92
ZSwgaXQgd291bGQgYmUgZ3JlYXRseSBhcHByZWNpYXRlZC4NCj4+DQo+PiBJZiBJ4oCZbSBtaXNz
aW5nIHNvbWV0aGluZywgZmVlbCBmcmVlIHRvIGxldCBtZSBrbm93LiBBbnkgZmVlZGJhY2sgJiBj
b21tZW50IGFyZSB2ZXJ5IHdlbGNvbWUuDQo+Pg0KPj4NCj4+IFsxXSBQbWVtIHJlZ2lvbiBsYXlv
dXQ6DQo+PiAgICAgIF48LS1uYW1lc3BhY2UwLjAtLS0tPl48LS1uYW1lc3BhY2UwLjEtLS0tLS0+
Xg0KPj4gICAgICB8ICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgIHwN
Cj4+ICAgICAgKy0tK20tLS0tLS0tLS0tLS0tLS0tKy0tK20tLS0tLS0tLS0tLS0tLS0tLS0rLS0t
LS0tLS0tLS0tLS0tLS0tLS0tKy0rYQ0KPj4gICAgICB8Kyt8ZSAgICAgICAgICAgICAgICB8Kyt8
ZSAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICB8K3xsDQo+PiAgICAgIHwr
K3x0ICAgICAgICAgICAgICAgIHwrK3x0ICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgIHwrfGkNCj4+ICAgICAgfCsrfGEgICAgICAgICAgICAgICAgfCsrfGEgICAgICAgICAg
ICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgfCt8Zw0KPj4gICAgICB8Kyt8ZCAgbmFtZXNw
YWNlMC4wICB8Kyt8ZCAgbmFtZXNwYWNlMC4xICAgIHwgICAgIHVuLWFsbG9jYXRlZCAgICB8K3xu
DQo+PiAgICAgIHwrK3xhICAgIGZzZGF4ICAgICAgIHwrK3xhICAgICBkZXZkYXggICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgIHwrfG0NCj4+ICAgICAgfCsrfHQgICAgICAgICAgICAgICAgfCsr
fHQgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgfCt8ZQ0KPj4gICAgICAr
LS0rYS0tLS0tLS0tLS0tLS0tLS0rLS0rYS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0t
LS0tLS0tLS0rLStuDQo+PiAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfHQNCj4+ICAgICAgdjwtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLXBtZW0gcmVnaW9uLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLT52
DQo+Pg0KPj4gWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzcwRjk3MUNGLTFB
OTYtNEQ4Ny1CNzBDLUI5NzFDMkExNzQ3Q0Byb2MuY3MudW1hc3MuZWR1L1QvDQo+Pg0KPj4NCj4+
IFRoYW5rcw0KPj4gWmhpamlhbg==

