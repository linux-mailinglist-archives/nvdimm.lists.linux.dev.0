Return-Path: <nvdimm+bounces-3303-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA4D4D5154
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 19:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id EE9193E0FA2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 10 Mar 2022 18:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8B95A21;
	Thu, 10 Mar 2022 18:47:16 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF61182
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646938034; x=1678474034;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=/igxCm1feoVRThNvvwlIN3/Q7e1fJlQvxBZXgOIZ2KY=;
  b=cNrMXqAf8TBT53I9S1wWFAw7783M0Z7ZxwvZ7esGJ7xfF1732E2Rm+Fb
   vXAH6Ts2zjRPcs8pTi+h5nwZc68xWD4zTyVg+MjTdLBrv4Iw9O446hTin
   2tVYK8+i3Okwi26VUk2XEl0ZcXF2TFLQjunk/Le6PCaCMHoINXFcCretg
   IH/z6V7+P+gLjzRKER1qf/pWhxRK5mg2i+kUuJJDU7x8YWcNEJUEIPP8r
   H13qml5qaBNjYRjRxn7e5BTZgkdB3djsN1EivWi6vt6I4IzKOgIQt2MVX
   YhgU5WxEOBz9QLl1AfbKE9i3u//5M+EvMD5Cc84XP4Hhhj6nZgJksK5UF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255287588"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="255287588"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 10:47:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="538579534"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2022 10:47:13 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 10:47:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 10:47:13 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 10:47:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqHV/vatXK8T6kyOqQC9P9+13XJZKPZUSwa+kSYhfBgO1npOiFFSDET+KJOsBU3ZBlyk9tVXhQFsMbCWnOn00EJp3mU9rt0f+f9H8amOxahRFd5z2hLXAjimQxrxV+9Vc6sqWfg1B9jACzboPdAtyKMQhwEaQMW5vi7JM/SdG38voHkfaVxg732VnvDVsdM9ylw09VCB2Rv+HlrFbPYaSEe5QDS/w8TrmDrOqja/bsWhhNzdkA5+rxFWo8wGaExOd4u0ei+peq2QPY6gJuYa/B7jCV1F881srVVpzEu3Fr0sLskPxSiWF7YNPvkg9JRgKscqI+9AYJJ6OJByTl+pwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/igxCm1feoVRThNvvwlIN3/Q7e1fJlQvxBZXgOIZ2KY=;
 b=U6Sek8TWiFIjJ/O7zSDa/F+VA+WlSqK4FEgg+WG0Ni1bgW8cxwXKW0+0d4bHT1YGv7pqmFi3TCQrbzwJhVkGQAlg/+OsLmXMKY1aZLmGmW5b01lIdTinqtOe3QlruSMVITiV75XJSF0LrtPG6etb0jooNeq556EpBWXrENQzUOnDPbcvySDsdlP9OQYbEbIhDbMm+w/beXAhsqj2E4/SxLDwwYiBm20RxT3tgMZHGuINt3xvN9RBGvufENyI7fQUt5ZH8dmdS0kkE7U9Yw3W7u5mrePna5KE4SeS1fi8J7gpoKoCnbbWJP4P59dY/0xcbcqpKc4aC2SlJmYERQQmOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL3PR11MB5715.namprd11.prod.outlook.com (2603:10b6:208:352::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Thu, 10 Mar
 2022 18:47:11 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 18:47:11 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "msuchanek@suse.de"
	<msuchanek@suse.de>
Subject: Re: Delivery by git send-email to mailing list fails
Thread-Topic: Delivery by git send-email to mailing list fails
Thread-Index: AQHYNH4JPfsDWxvXCUWdb3XSdPhzpay4nMeAgABYvAA=
Date: Thu, 10 Mar 2022 18:47:11 +0000
Message-ID: <ad280ea7658a1875d0dc9d7ef5abf573395b167b.camel@intel.com>
References: <20220310120531.4942-1-msuchanek@suse.de>
	 <20220310121735.GD3113@kunlun.suse.cz>
	 <20220310125436.GE3113@kunlun.suse.cz>
	 <20220310132935.GF3113@kunlun.suse.cz>
In-Reply-To: <20220310132935.GF3113@kunlun.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84975262-a26b-4c2c-88b2-08da02c662f8
x-ms-traffictypediagnostic: BL3PR11MB5715:EE_
x-microsoft-antispam-prvs: <BL3PR11MB57157F4182B51594E78A0D00C70B9@BL3PR11MB5715.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZV3D08IkwmgGwo4mLEo9oEdbblNwDlim4gYzWKtolAsc8eESaiDYlhkg1fA4G9xk7iB+X+uMT0sn06tOspufu4HrxyAwtnpRtBjXc9HUQXqO3xDI9FY6q2mYpfVUs3kW3vPjJrmlQZmqZuLs7zAAmTDkI1Afn4RHV6nukgEYQI7jzYm6kLoLAbTwsV4xhhuzYl6/rPbGgfYbr5kpAGHv0hxsRapX+LHGjY7e9ZnMGS+4duwIm7e5MaVf0hrz6MI9zJvq2iiK8GkMKIFHHzmkujvrcTRBncLKeTwa1acdkkx1ND9hVie2G/LufDWk+HAP0f9Uc9vo0bPjOQezD8tz+O4U1vsQv7SecnEOLBkC2p0HtMWrmm8ce4Qbnv35o6RVcH7sOlxqlNQxS5pwdQwe7GLf2w8zxZPmQ+rPs5I+9PsrrPBmTqjP/qtxMFMcqwyqfMcYmSGyHvPO+40kqu4VymdnPYx4hnmWrQ6sgY+vu7LaTJfRh2xFgpdJp1ucSp/DPCz5Gf9yhpvS0sHrIW/usf4HVG7V14f7/efqhbn/XETQJdtNjp5Mx9z+sGg04aBN/H8lWsAh4JoUpW8v4RhN6JbWm9TXfzHqD7HYz8jT5QhMG7/1CMT3MNJCkQ3g1pgjtW0AqfKrijUrd0yk/hAU7lYin1+3x/GRD71Ud+3U0qNYrPqfl27N2QInjD/1L++198XHg5AF4Tu03Y4CTlJcRho5GGyKI4UY6K2UyhmMU9yq1+4nfhf55hb88DgG9xr4muoGgbwd+SPY116tdrLuy+xUxYyxQvA3uIXes6EsOYf/WjuG5CsQbcJ55uphKaSZqYFIXda2V/FyjaYMbOj4/2ZxUpBU7Wvb79HJGjCENsU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6506007)(6512007)(8676002)(966005)(6486002)(2906002)(110136005)(64756008)(66946007)(508600001)(66446008)(66476007)(66556008)(82960400001)(38100700002)(36756003)(122000001)(316002)(38070700005)(26005)(2616005)(66574015)(5660300002)(8936002)(83380400001)(91956017)(76116006)(71200400001)(186003)(130980200001)(223123001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z05qU21vSFY0aFlXUWVGT0FUVWxobVNkdkxxUlpWWmpUMjdWV0ZrUTRnZGNn?=
 =?utf-8?B?Q1kxaEMzVmUzODNSS2FFRm5qb2NYTnNGdjU3cGhSVDhrV0l0WloxNSt6dU5G?=
 =?utf-8?B?L2lWb3B0VUFmckxtMVl6Yi9yT2RxVHhxNnlvNUpSbjZXZnlaSWllV3ovQUl6?=
 =?utf-8?B?dXJROWp2a1dDVmdhSm1rOTdZWXFjenJiaHlaaFFzQjg1ck5vbzhRdXU0emxw?=
 =?utf-8?B?V2R4VG1TVTVmUkFMUnVZS2VaWlhjNVVkc1Z2VCtWdXFWOVU2UXpHeDJlaGwx?=
 =?utf-8?B?OGRQYjNuRGZkV0pOaVliV1BSdHFwSjdVcVhiY3NQYXNocld1WDN3bGxxai85?=
 =?utf-8?B?bUJNZDhheUFxRWxmbGJHSTgyMytrZFI0a0MvdTVHamdrajZndmc0UUdGWWw3?=
 =?utf-8?B?czlQTFhJVDQ0c0JOUXhkaUVzdlVFYTVRc3VLUlo0YkhNajNlYU80K0NKRHF5?=
 =?utf-8?B?dDNRb3FYUkNpVkNJQm9JYmoyMGY0aVU1SzNSZ0dFZkNVS1N2SjFrWnh4VEdZ?=
 =?utf-8?B?cVBxZXR5d1g4U2V6N1I3YzVwdU9SdFBhUkZoK29TTGhPaDB3SUJDOEdCd3Bp?=
 =?utf-8?B?SEw4ODRCUkpaY2lVQm9Ydkg4eEM2ZCs3WjJTdVNJOHFrQnhmWUIrUXdEZS8w?=
 =?utf-8?B?ZmptV3RqbTBaMDJrbmNpams1ZjR1ajRBSDIvNk1uemJjaW5NUkVtZ2QzTWF1?=
 =?utf-8?B?NHI2T1NZazZyc0ZScWlqenAxaDgzUEw3RmxydUFXVU1rSWJKbzdDTjFudDl2?=
 =?utf-8?B?Sjg5eldDb1BZeGdhYWgrV1BjdDdwNCtoKzBQUmZoRHFCVXJIazY2azZtdzNu?=
 =?utf-8?B?dDU0MnpDbTNwTTJTeGlRK1AzUllaRitzL2ovRWY2bTFjWUhMMmFaTmhwUXpO?=
 =?utf-8?B?TVRXUG8yL2RtaExiQ1djUGg3dy9McXFJUFZ6Ung5OG5JSWtLQURoYndyT24y?=
 =?utf-8?B?NnFYakR4bk82aU5LQnJYZWRYczBkQ3hQaVl6ZUExRGs5YUl5cmFEdkNFMUhu?=
 =?utf-8?B?MkNlQVY2eWFmckYyWExkYm12bENEMG9rK0ZsWVA1YzU4azIwNENtSnJpZTdz?=
 =?utf-8?B?T1FpQkhYQml1NDZmSmoxTWsxVkhnRDY2V2REbW80UFpsUU5kL3pOSDlnQjc0?=
 =?utf-8?B?N0lkUnNkZEpVMnZVbXVNL3hvYnc4dyswUDhET2d5eGIrcU5FZFduSnltUGFt?=
 =?utf-8?B?SkloYUR1SFduYlVldkdFZ3VBTkpGY0Z6UDNqRytSbng0Y0QzdXBxUThqekpD?=
 =?utf-8?B?QzNLZjRKU0ZYZWM5dUtOV2w3eGFNMjVBTXUxMkt4RVRNdDloMGl2QzFLRnl6?=
 =?utf-8?B?eWV1TEJKeVV3cXNMNGFxSzhqMVRwRXF2dVpoSGlGTHVybDJHRkFNS3ZzQzN5?=
 =?utf-8?B?MU5KVHJuc0F6SS9WLzN3aTUzb2lKbjdJR29kaFRXQ200SkVuREYrd05VM0Vl?=
 =?utf-8?B?Sjd3QS85U21qS0tXVXVyay9XZ1YrSTZvZFpRbUdENGM2ZDBiQm1VandodjVm?=
 =?utf-8?B?ZGVEaFJMaVk5LzBLeThmQW0rTnV1bFBWUFliOERXUWZKV0hTd0xtckRGM0Uv?=
 =?utf-8?B?cW1Zem1PNHRCWE15eUVOdW9HMlRNMXdyS3h5dS9tSTBaNnlPaTNtRStQekNx?=
 =?utf-8?B?R0h6UkJ1UUhYRHpWdFpqM0tJN2pOVjFkOS8xaDZDKzBjT1VDVUZoaEsyR0tn?=
 =?utf-8?B?QjFJMEJrR0Mwamx3akJ1VUpwc1NFRGVqU2RJQ0Y4R3FxbHZ0NTVWSzNnZXl4?=
 =?utf-8?B?Y1VRUmMyZnhjamlmaGRxazJzenAzZ1ZBWXZ3V0ptZHFsK1BYMjdIK0l6OEg5?=
 =?utf-8?B?OWpVa1c0YjJDRjNiMm9YdWFEalArRG5Ecm8wNTE5SGN3YnE2NjgySk1FZU10?=
 =?utf-8?B?aXJKSDZzV3FkT0t4YnJ5cld1QlluRXNic3g5dzVMTlRUMGxxMVBKQ1c4dnhw?=
 =?utf-8?B?b3J6NFBDa3lpdG5nSDVFMExTVG1vRWlLTEIrb3pBSUFxUGZkOFFrQUsxMVBX?=
 =?utf-8?B?c3VkY2ZmdGdBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9178EA644B3FF48929E76E3FC21D488@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84975262-a26b-4c2c-88b2-08da02c662f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 18:47:11.2956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lp27xpT8ZJe7CVeTxWkcAbSqK9GrQezN3c4bT2ZXXsCZVcl2kGhrhHR+n7oN7gooO5CvyxWUPfuRN2fLjOoyNizUkhxmQh6te6irdCfv22Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5715
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTAzLTEwIGF0IDE0OjI5ICswMTAwLCBNaWNoYWwgU3VjaMOhbmVrIHdyb3Rl
Ogo+IE9uIFRodSwgTWFyIDEwLCAyMDIyIGF0IDAxOjU0OjM2UE0gKzAxMDAsIE1pY2hhbCBTdWNo
w6FuZWsgd3JvdGU6Cj4gPiBPbiBUaHUsIE1hciAxMCwgMjAyMiBhdCAwMToxNzozNVBNICswMTAw
LCBNaWNoYWwgU3VjaMOhbmVrIHdyb3RlOgo+ID4gPiBIZWxsbywKPiA+ID4gCj4gPiA+IEkgY2Fu
bm90IHNlbmQgbWFpbCB0byB0aGUgbWFpbGluZyBsaXN0IHdpdGggZ2V0IHNlbmQtZW1haWwuCj4g
PiA+IAo+ID4gPiBUaGUgY29weSBzZW50IHRvIG1lIGlzIGRlbGl2ZXJlZCBidXQgdGhlIGUtbWFp
bCBkb2VzIG5vdCBhcHBlYXIKPiA+ID4gaW4gdGhlCj4gPiA+IG1haWxpbmcgbGlzdCBhcmNoaXZl
cy4KPiA+ID4gCj4gPiA+IElzIHRoZXJlIGFueSB3YXkgdG8gZml4IHRoaXM/Cj4gPiAKPiA+IEFw
cGFyZW50bHkgdGhlIGxpc3QgaXMgc3Vic2NyaWJlci1vbmx5LiBUaGlzIGlzIHVudXN1YWwgZm9y
IG1haWxpbmcKPiA+IGxpc3RzIHJlbGF0ZWQgdG8ga2VybmVsIGRldmVsb3BtZW50LCBhbmQgaXMg
bm90IGRvY3VtZW50ZWQuCj4gCj4gQWN0dWFsbHksIHRoaXMgaGFzIG5vdGhpbmcgdG8gZG8gd2l0
aCBzdWJzY3JpcHRpb24uIFNvIGluIHRoZSBlbmQgSQo+IGhhdmUKPiBubyBpZGVhIHdoeSBlLW1h
aWwgc2VudCBieSBnaXQgc2VuZC1lbWFpbCBpcyBub3QgZGVsaXZlcmVkIHRvIHRoZQo+IGxpc3QK
PiB3aGlsZSBlLW1haWwgYXV0aG9yZWQgaW4gYSBNVUEgd29ya3MgZmluZS4KCk1pY2hhbCwKCkl0
IGxvb2tzIGxpa2UgeW91ciBwYXRjaGVzIGZyb20gdG9kYXkgKEkgc2VlIHRocmVlKSBkaWQgbWFr
ZSBpdCB0byB0aGUKbGlzdC4gZS5nLjoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbnZkaW1tLzIw
MjIwMzEwMTMzMTA2LkdBMTA2NzM0QGt1bmx1bi5zdXNlLmN6L1QvI3UKCkRpZCB5b3UgY2hhbmdl
IHNvbWV0aGluZyBvbiB5b3VyIGVuZD8KCj4gCj4gPiAKPiA+IFBsZWFzZSB1cGRhdGUgdGhlIGRv
Y3VtZW50YXRpb24gb3IgdGhlIG1haWxpbmcgbGlzdCBzZXR0aW5ncy4KPiA+IAo+ID4gPiAKPiA+
ID4gVGhhbmtzCj4gPiA+IAo+ID4gPiBNaWNoYWwKPiA+ID4gCj4gPiA+IE9uIFRodSwgTWFyIDEw
LCAyMDIyIGF0IDAxOjA1OjMzUE0gKzAxMDAsIE1pY2hhbCBTdWNoYW5layB3cm90ZToKPiA+ID4g
PiBXaXRoIHNlZWQgbmFtZXNwYWNlcyBjYXVnaHQgZWFybHkgb24gd2l0aAo+ID4gPiA+IGNvbW1p
dCA5YmQyOTk0ICgibmRjdGwvbmFtZXNwYWNlOiBTa2lwIHNlZWQgbmFtZXNwYWNlcyB3aGVuCj4g
PiA+ID4gcHJvY2Vzc2luZyBhbGwgbmFtZXNwYWNlcy4iKQo+ID4gPiA+IGNvbW1pdCAwNzAxMWEz
ICgibmRjdGwvbmFtZXNwYWNlOiBTdXBwcmVzcyAtRU5YSU8gd2hlbgo+ID4gPiA+IHByb2Nlc3Np
bmcgYWxsIG5hbWVzcGFjZXMuIikKPiA+ID4gPiB0aGUgZnVuY3Rpb24tc3BlY2lmaWMgY2hlY2tz
IGFyZSBubyBsb25nZXIgbmVlZGVkIGFuZCBjYW4gYmUKPiA+ID4gPiBkcm9wcGVkLgo+ID4gPiA+
IAo+ID4gPiA+IFJldmVydHMgY29tbWl0IGZiMTNkZmIgKCJ6ZXJvX2luZm9fYmxvY2s6IHNraXAg
c2VlZCBkZXZpY2VzIikKPiA+ID4gPiBSZXZlcnRzIGNvbW1pdCBmZTYyNmE4ICgibmRjdGwvbmFt
ZXNwYWNlOiBGaXggZGlzYWJsZS1uYW1lc3BhY2UKPiA+ID4gPiBhY2NvdW50aW5nIHJlbGF0aXZl
IHRvIHNlZWQgZGV2aWNlcyIpCj4gPiA+ID4gCj4gPiA+ID4gRml4ZXM6IDgwZTBkODggKCJuYW1l
c3BhY2UtYWN0aW9uOiBEcm9wIHplcm8gbmFtZXNwYWNlCj4gPiA+ID4gY2hlY2tzLiIpCj4gPiA+
ID4gRml4ZXM6IGZiMTNkZmIgKCJ6ZXJvX2luZm9fYmxvY2s6IHNraXAgc2VlZCBkZXZpY2VzIikK
PiA+ID4gPiBGaXhlczogZmU2MjZhOCAoIm5kY3RsL25hbWVzcGFjZTogRml4IGRpc2FibGUtbmFt
ZXNwYWNlCj4gPiA+ID4gYWNjb3VudGluZyByZWxhdGl2ZSB0byBzZWVkIGRldmljZXMiKQo+ID4g
PiA+IFNpZ25lZC1vZmYtYnk6IE1pY2hhbCBTdWNoYW5layA8bXN1Y2hhbmVrQHN1c2UuZGU+Cj4g
PiA+ID4gLS0tCj4gPiA+ID4gwqBuZGN0bC9saWIvbGlibmRjdGwuYyB8wqAgNyArLS0tLS0tCj4g
PiA+ID4gwqBuZGN0bC9uYW1lc3BhY2UuY8KgwqDCoCB8IDExICsrKystLS0tLS0tCj4gPiA+ID4g
wqBuZGN0bC9yZWdpb24uY8KgwqDCoMKgwqDCoCB8wqAgMiArLQo+ID4gPiA+IMKgMyBmaWxlcyBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQo+ID4gPiA+IAo+ID4gPiA+
IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvbGlibmRjdGwuYyBiL25kY3RsL2xpYi9saWJuZGN0bC5j
Cj4gPiA+ID4gaW5kZXggY2NjYThiNS4uMTEwZDhhNSAxMDA2NDQKPiA+ID4gPiAtLS0gYS9uZGN0
bC9saWIvbGlibmRjdGwuYwo+ID4gPiA+ICsrKyBiL25kY3RsL2xpYi9saWJuZGN0bC5jCj4gPiA+
ID4gQEAgLTQ1OTMsNyArNDU5Myw2IEBAIE5EQ1RMX0VYUE9SVCBpbnQKPiA+ID4gPiBuZGN0bF9u
YW1lc3BhY2VfZGlzYWJsZV9zYWZlKHN0cnVjdCBuZGN0bF9uYW1lc3BhY2UgKm5kbnMpCj4gPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0IGNoYXIgKmJkZXYgPSBOVUxMOwo+ID4gPiA+IMKgwqDC
oMKgwqDCoMKgwqBpbnQgZmQsIGFjdGl2ZSA9IDA7Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGNo
YXIgcGF0aFs1MF07Cj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBsb25nIHNp
emUgPQo+ID4gPiA+IG5kY3RsX25hbWVzcGFjZV9nZXRfc2l6ZShuZG5zKTsKPiA+ID4gPiDCoAo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAocGZuICYmIG5kY3RsX3Bmbl9pc19lbmFibGVkKHBm
bikpCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBiZGV2ID0gbmRjdGxf
cGZuX2dldF9ibG9ja19kZXZpY2UocGZuKTsKPiA+ID4gPiBAQCAtNDYzMCwxMSArNDYyOSw3IEBA
IE5EQ1RMX0VYUE9SVCBpbnQKPiA+ID4gPiBuZGN0bF9uYW1lc3BhY2VfZGlzYWJsZV9zYWZlKHN0
cnVjdCBuZGN0bF9uYW1lc3BhY2UgKm5kbnMpCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldm5hbWUpOwo+ID4g
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQlVTWTsKPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsKPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKHNpemUgPT0gMCkKPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIE5vIGRpc2FibGUgbmVjZXNzYXJ5IGR1ZSB0byBubwo+
ID4gPiA+IGNhcGFjaXR5IGFsbG9jYXRlZCAqLwo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDE7Cj4gPiA+ID4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiA+ID4gPiAtCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5kY3RsX25hbWVzcGFjZV9kaXNhYmxlX2lu
dmFsaWRhdGUobmRucyk7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5k
Y3RsX25hbWVzcGFjZV9kaXNhYmxlX2ludmFsaWRhdGUobmRucyk7Cj4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoH0KPiA+ID4gPiDCoAo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiA+
ID4gPiBkaWZmIC0tZ2l0IGEvbmRjdGwvbmFtZXNwYWNlLmMgYi9uZGN0bC9uYW1lc3BhY2UuYwo+
ID4gPiA+IGluZGV4IDI1N2I1OGMuLjcyMmYxM2EgMTAwNjQ0Cj4gPiA+ID4gLS0tIGEvbmRjdGwv
bmFtZXNwYWNlLmMKPiA+ID4gPiArKysgYi9uZGN0bC9uYW1lc3BhY2UuYwo+ID4gPiA+IEBAIC0x
MDU0LDkgKzEwNTQsNiBAQCBzdGF0aWMgaW50IHplcm9faW5mb19ibG9jayhzdHJ1Y3QKPiA+ID4g
PiBuZGN0bF9uYW1lc3BhY2UgKm5kbnMpCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHZvaWQgKmJ1
ZiA9IE5VTEwsICpyZWFkX2J1ZiA9IE5VTEw7Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGNoYXIg
cGF0aFs1MF07Cj4gPiA+ID4gwqAKPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqBpZiAobmRjdGxfbmFt
ZXNwYWNlX2dldF9zaXplKG5kbnMpID09IDApCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiAxOwo+ID4gPiA+IC0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgbmRj
dGxfbmFtZXNwYWNlX3NldF9yYXdfbW9kZShuZG5zLCAxKTsKPiA+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgcmMgPSBuZGN0bF9uYW1lc3BhY2VfZW5hYmxlKG5kbnMpOwo+ID4gPiA+IMKgwqDCoMKgwqDC
oMKgwqBpZiAocmMgPCAwKSB7Cj4gPiA+ID4gQEAgLTExMzAsNyArMTEyNyw3IEBAIHN0YXRpYyBp
bnQgbmFtZXNwYWNlX3ByZXBfcmVjb25maWcoc3RydWN0Cj4gPiA+ID4gbmRjdGxfcmVnaW9uICpy
ZWdpb24sCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoH0KPiA+ID4gPiDCoAo+ID4gPiA+IMKgwqDC
oMKgwqDCoMKgwqByYyA9IG5kY3RsX25hbWVzcGFjZV9kaXNhYmxlX3NhZmUobmRucyk7Cj4gPiA+
ID4gLcKgwqDCoMKgwqDCoMKgaWYgKHJjIDwgMCkKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBpZiAo
cmMpCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmM7Cj4g
PiA+ID4gwqAKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgbmRjdGxfbmFtZXNwYWNlX3NldF9lbmZv
cmNlX21vZGUobmRucywKPiA+ID4gPiBORENUTF9OU19NT0RFX1JBVyk7Cj4gPiA+ID4gQEAgLTE0
MjYsNyArMTQyMyw3IEBAIHN0YXRpYyBpbnQgZGF4X2NsZWFyX2JhZGJsb2NrcyhzdHJ1Y3QKPiA+
ID4gPiBuZGN0bF9kYXggKmRheCkKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiAtRU5YSU87Cj4gPiA+ID4gwqAKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcmMg
PSBuZGN0bF9uYW1lc3BhY2VfZGlzYWJsZV9zYWZlKG5kbnMpOwo+ID4gPiA+IC3CoMKgwqDCoMKg
wqDCoGlmIChyYyA8IDApIHsKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmMpIHsKPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yKCIlczogdW5hYmxlIHRvIGRp
c2FibGUgbmFtZXNwYWNlOiAlc1xuIiwKPiA+ID4gPiBkZXZuYW1lLAo+ID4gPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cmVycm9yKC1yYykpOwo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ID4gPiA+
IEBAIC0xNDUwLDcgKzE0NDcsNyBAQCBzdGF0aWMgaW50IHBmbl9jbGVhcl9iYWRibG9ja3Moc3Ry
dWN0Cj4gPiA+ID4gbmRjdGxfcGZuICpwZm4pCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gLUVOWElPOwo+ID4gPiA+IMKgCj4gPiA+ID4gwqDCoMKgwqDCoMKg
wqDCoHJjID0gbmRjdGxfbmFtZXNwYWNlX2Rpc2FibGVfc2FmZShuZG5zKTsKPiA+ID4gPiAtwqDC
oMKgwqDCoMKgwqBpZiAocmMgPCAwKSB7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHJjKSB7
Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvcigiJXM6IHVuYWJs
ZSB0byBkaXNhYmxlIG5hbWVzcGFjZTogJXNcbiIsCj4gPiA+ID4gZGV2bmFtZSwKPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJlcnJvcigt
cmMpKTsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByYzsK
PiA+ID4gPiBAQCAtMTQ3Myw3ICsxNDcwLDcgQEAgc3RhdGljIGludCByYXdfY2xlYXJfYmFkYmxv
Y2tzKHN0cnVjdAo+ID4gPiA+IG5kY3RsX25hbWVzcGFjZSAqbmRucykKPiA+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5YSU87Cj4gPiA+ID4gwqAKPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgcmMgPSBuZGN0bF9uYW1lc3BhY2VfZGlzYWJsZV9zYWZlKG5kbnMp
Owo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoGlmIChyYyA8IDApIHsKPiA+ID4gPiArwqDCoMKgwqDC
oMKgwqBpZiAocmMpIHsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVy
cm9yKCIlczogdW5hYmxlIHRvIGRpc2FibGUgbmFtZXNwYWNlOiAlc1xuIiwKPiA+ID4gPiBkZXZu
YW1lLAo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHN0cmVycm9yKC1yYykpOwo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIHJjOwo+ID4gPiA+IGRpZmYgLS1naXQgYS9uZGN0bC9yZWdpb24uYyBiL25kY3Rs
L3JlZ2lvbi5jCj4gPiA+ID4gaW5kZXggZTQ5OTU0Ni4uMzM4MjhiMCAxMDA2NDQKPiA+ID4gPiAt
LS0gYS9uZGN0bC9yZWdpb24uYwo+ID4gPiA+ICsrKyBiL25kY3RsL3JlZ2lvbi5jCj4gPiA+ID4g
QEAgLTcxLDcgKzcxLDcgQEAgc3RhdGljIGludCByZWdpb25fYWN0aW9uKHN0cnVjdCBuZGN0bF9y
ZWdpb24KPiA+ID4gPiAqcmVnaW9uLCBlbnVtIGRldmljZV9hY3Rpb24gbW9kZSkKPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgY2FzZSBBQ1RJT05fRElTQUJMRToKPiA+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoG5kY3RsX25hbWVzcGFjZV9mb3JlYWNoKHJlZ2lvbiwgbmRucykg
ewo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJjID0KPiA+ID4gPiBuZGN0bF9uYW1lc3BhY2VfZGlzYWJsZV9zYWZlKG5kbnMpOwo+ID4gPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJjIDwg
MCkKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGlmIChyYykKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ID4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmMgPSBuZGN0bF9yZWdpb25fZGlzYWJsZV9pbnZhbGlkYXRlKHJlZ2lvbik7Cj4gPiA+ID4g
LS0gCj4gPiA+ID4gMi4zNS4xCj4gPiA+ID4gCj4gPiA+IAo+ID4gCj4gCgo=

