Return-Path: <nvdimm+bounces-5093-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6CC621D12
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Nov 2022 20:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48BA7280C6F
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Nov 2022 19:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F98A3E1;
	Tue,  8 Nov 2022 19:36:52 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5733E2
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667936210; x=1699472210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Nml5Fbn8JIRmgG88t7Lp7fbfBLPpxuWBdJIEvhmy3Go=;
  b=mQNzwHXa70tI8V41hOng0q+La6Q5U53cPj8TRnrxoCNLU4vopIZV/lLR
   meQQAooF1+rkxeCPLJlAQR58DDuzbAZ5WMZ3TwggoKbcUqMJD/rU72R/N
   SaEhQ3/fMK7h7OWgKHiXZP5r4isxPXSx6B0TBiY7WRjsK3lAx4QY42Xv+
   /DS5M/cT0lEUregrbYW/1VQlvQO6ZgpDAGQJHMCMEu4zw51V/Vz4CJFMh
   ccJjA+bgi8fISuUIbQLs4CqGAJpt+UiwADlf+aw3Wj4NppXYzSDAsrEH+
   BkKqKuNT3ncrqmj/ZETdDYKS0j3ANP5xS74udfVeb8B5VTvRqdtcKLZIv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="310788109"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="310788109"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 11:36:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="742089368"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="742089368"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 08 Nov 2022 11:36:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 11:36:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 11:36:47 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 11:36:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFA2LooJ2ySgZnx8qCuy2KsQmJ2dw5fYIViC+5HeMAR4TtBPz02L5hD0zYTtCrwuHF1SChjO040mVkFOZZtWKf+Q4eVvzmJ1BgBDJr22oH0nWoz9kfxildd2hZbv2Ewt4QqGuZHU1cstEYtflhQ2ghJ3T1TE3o2EJrIVHTIr7Lxb4EdPyVHj90qIgKlz5ma4gfwS5MRstoZ3V7ahIbKHjm/ncYS4dQTMPkMlw1Zrk8BvKKy/Uz4Wf/y253SbbdFCf8s/O4DQtIoFkkoPFFqvFxt/WPWmReRIU/70y2zTgjm+XWOuSp51LlhOdELgD+amEvXViyk5/l7FYGAHvDM7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nml5Fbn8JIRmgG88t7Lp7fbfBLPpxuWBdJIEvhmy3Go=;
 b=DLyGwHC/Vm9RCeYx5sLObPht062ZQlTPBT9+PNkWXtkjEFwiZkwvB5LLBzYlUgST5BPot/kAN7ArvDI+8qW85Aju/9s+QfXcxxC1Wsv1ZBxk6oO+8xwt5OiQTwmsAz6+g399qDsrOFk/jF87nDc133dU/aLD1/OQjtUllVyzUuXysuQQVKW+UPMO5QfJe3eBLIeuyjjeJwtv3Rx8d98vgyTHwOPEXhFjnFl13G5zyi122iHs/E7GjskhT7Nwoqjf6/TV+aZIq03doHRhm6WYXJ/43RtEM6dPUhqelSqpGaSjM2YmWwKevRf8HDBjfe7G/Siua2WPkoFSpGr9d6L0KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 19:36:32 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 19:36:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/15] cxl/region: Make ways an integer argument
Thread-Topic: [ndctl PATCH 09/15] cxl/region: Make ways an integer argument
Thread-Index: AQHY8joqEQ/vv10Xm0i4bDAEWYfGbK41blmA
Date: Tue, 8 Nov 2022 19:36:32 +0000
Message-ID: <2143317d50d570ca02d2975905612a196268d1f5.camel@intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
	 <166777845733.1238089.4849744927692588680.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777845733.1238089.4849744927692588680.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH0PR11MB5078:EE_
x-ms-office365-filtering-correlation-id: e55a0f26-beaf-4fc7-e6cf-08dac1c08a32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUID+Iyznx9Zyn49kEQVnlYZabes3n4zk3pNY+cp4w6o9BeafArW+q1kPhYjKaGCjC09XlZ+WJq27H4eDZqztQs+55MfgGF6bTFYfZwZWPVCAaTEQWYimo0Lp9CUccRePFZSPWGT1w/Ow1hA655DY8V5jDX/iqjGzAAHsPXfQmPeYKME+cefPLhCDa/JaC2nRGEb0hPpUgLddRRxd4bV+GTmhq+DF88+P9EoBYuA9GB6Q37kjOj1XmoJt9McdTcXFcdmXGfjUhPOHan+KPzfbWaGexIBQ/xMyi96J7OduC/2zf+UvCKbDslI0yROw0HGloGkBXgQhWp8siX0ITJHKW2C4VeS+qSp8nsAawKGYw0TSh5AkW+RryHRYfp/5Z8GK7Xtg0OMhaWb1bDVNLMDO+ElpFytegxFrO3ZSZaGwubhod+6bX7scuhJsTOUZrDDgdhZBJ46feTYFJRjB19ItcMsMnoJkX9Dl9BCTn6SGYmpmA+XyXP7LSTStkAvi15rQIHsKOVxhGwynWbCsIAA7IDol84eXHoLFdwGpt13wkQpjyOZu+ZnnAX0nINvyx4EzaQ1DpHPqqyYdfNRrjKnmQN5knT7FgeTpul3taQE1WBAtTTrEptB7IIBw7bCKBexfH9ypFtArGa0e6msHTvMthSrshueRilaB66bclVtQxfO6MtYUht364bSTv8PxZ9Yr/vLZ5lucwkUEft/LcCXipBJ7fK/la6tjsPpA3QK0DyOAoNrUuqQ65Hnr0KJcVmRUi5onqg5GlHhdFQ4rzndCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199015)(26005)(186003)(6512007)(38100700002)(82960400001)(83380400001)(6862004)(6636002)(122000001)(2616005)(2906002)(38070700005)(8936002)(5660300002)(66946007)(41300700001)(6486002)(71200400001)(478600001)(76116006)(66446008)(4326008)(66556008)(8676002)(64756008)(37006003)(91956017)(316002)(54906003)(66476007)(6506007)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDVrNVZTbCtuazRuUmw5RUl3dDRUWWp6amFWcWFSSlJOYnkwd0F3RVVIMlZn?=
 =?utf-8?B?Y2ttWUJkcHI5eGgxeVFyNVJsWGFOOEN1d1V4dExuTW9heE1pMWFpWnUxTVUw?=
 =?utf-8?B?V0xad3JFR3krS1NlWWZ0RGR3ZGRORFNJZFBYZFlyaWxIWjJxYXlQUG5LSDk2?=
 =?utf-8?B?Y085a2xSSUM0YUVtYjZubEtJdmcwS0NiWit4cGgwRjIvaVhPODM1QU1IZzBl?=
 =?utf-8?B?cEIwSDhlaWlubVdtK0lBYWZTc0RmNG1YRmFpcFlmRUhFU3JXQmFqSWtNR0lR?=
 =?utf-8?B?M0xjWThSVFhXZG84Vlh0MHBueEVHSUkxZFliTS9zdmtWUGF4YWxieE9RVU42?=
 =?utf-8?B?QlJBV1FUZ1o1RzRDazBUVnVSeUt5QjlPc1YwdG1CMDJPUElCb3EzZnFmVXAr?=
 =?utf-8?B?N2R2OEtnZjJEcHdpdVJBZExEaUtzMm56bE1ZVXFNNWpnVW1tdnI5Q2J0QkVa?=
 =?utf-8?B?NEZYTzNuamJZekkzK3RYbUFCVlFDZ2JNOFl2c21scmtDU2hWVDlyWFNIdFho?=
 =?utf-8?B?SHB1ZmQ5c0RmSVJ2UFBBQU95SnI0bE9PTjJHbXB5cTU4RDNtK1Jpd1c4SmVT?=
 =?utf-8?B?M1BFdDRXZGNBVzk0OVl3VGNBN1M2bytpL0hwWE1sb0hYUE1jbXlpdG1BbHAv?=
 =?utf-8?B?ZTlPTGNyOGJLc3ljaTVITGFCZEp6UElUMVJHZDBsYXVuRkJBRFNLeDYwNnh0?=
 =?utf-8?B?RDhrTEw2eno0ZkhQcmNzTGtzUVVSVktEQmVXbXhZWGM2NkpCNjFLUzNQTGIy?=
 =?utf-8?B?WlF0dFR5Tzk5Si9JVElHQjRiUTUxcFdsVmdYRjFBN1pEN3FPM2E1VTNiSzJo?=
 =?utf-8?B?TlY0c0VoQklEOEJRN3VOZ1N4bjlMcmJUbWJ5SGNLUUdEbmxTSEhVUEh6VlNt?=
 =?utf-8?B?eDQwY0dHRzlaTmV5WE83cktBUlV3S25VKyt1amdFKzlyek5FeXZDckhwdE1R?=
 =?utf-8?B?RTMrZDdxMWpxWUZYdW40WmtJQ3VQM095N2NDQ0NZQVhabjRvTXR5eE1CcXJs?=
 =?utf-8?B?MnBzalg1NUFSVFh1VnJCQWNPMXZkcWQ2ZVM2Z2ZvZzVFVnRBN3pNSVd2bm9J?=
 =?utf-8?B?Q0plaTJsMGlxb29Od2JjRGZabkRFMWQrSnQ1Ui9jeGs1QUwzMFFTUGg4T1Yr?=
 =?utf-8?B?elJmWXlxQllpYWFHUm90T0haWm5mVjArcFV5Yld6cHRQaFM1L0JHaVFUaXhi?=
 =?utf-8?B?VmxBSkVzc0p6RlVOakRtMnlTSmdzZTlFM011ZS9IRGdJci95WVZjanN3dXJi?=
 =?utf-8?B?N3ZkMEd5NkFObndQam5qRWlsMFJXRE4wNFozcDJ1Nk1ubk8ySUk5RlBJNFph?=
 =?utf-8?B?NVZIMWwyd2d0RElWRGdhN3gwT2YrQWlOV3kvdENoZktzcFVRSTVKRjhEOXBn?=
 =?utf-8?B?dE9aVUhIa2xVdlUzRlhGc09LS0ZQaXZMVmd0dUNZVnNRQWRuSFFUWDZibkRn?=
 =?utf-8?B?d3lkSnRpMVU3aWZKcFNETks5Yi9HMURXamhtdnpKSmx1OTBVR3ZMWkU3Rk9Y?=
 =?utf-8?B?Y1pCUW5yRUcyRUVLU25EaWtiRE1HRmdPTkhFMEZpTWVUcWI0aWJDVmdOaUZI?=
 =?utf-8?B?bzdiSjFRVXFBYmMvMnpQaUhXSjg1TDBERDdKNkgybUpzaVFVYnhhOFMvZFB2?=
 =?utf-8?B?dXN3Skp0aEZxbFpQZDJKaVNJVnREY1F0Mm5lekV6VUVRQmpPNWwzNzN3VjdD?=
 =?utf-8?B?YWFlTmRwM3A5aUUyN3pNWDVEVGkxWFZ1WmJCclpWdmMxVEVBOGRrSTFlY1FY?=
 =?utf-8?B?OEM4MTZML0QxQzk3Z2dyN2l6bEk4UEowbjRZZldDY0pCZVRBc3BCOVBMcTlt?=
 =?utf-8?B?aVpVUmhwMEpPTHZxeW94VzRFZ0ZsK0puZitISFFWeEtoMUY3dFM0emIyZUJZ?=
 =?utf-8?B?OFVHZXN5RnRGUkZ1Njc5WmxPRSs5SytnVEdqa1grOUhvNFlhT2UzN0hZZmF1?=
 =?utf-8?B?RWRDc2tKWFI1Zk1XZHh2Qy9wN1pmVk5hQWxWNXlGU205RzhJVGxzbDlNVERL?=
 =?utf-8?B?bkRJWUlrbWtHNC9ENzRqZ285bW9CVHlQRHA5RURia2hlei9jYlF3QkRTajBF?=
 =?utf-8?B?Q1gyUXlSYkpjenl0anhERkVCYUVWZU5KenRmdmV2Tk1VNnM2dTlUaThTMHVy?=
 =?utf-8?B?N05hQnhSYloxeE0vbVYxK3lOdUtNNlVDVWs1RzdRWXgyNkZWYjA1YUxBZG9P?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41F74ED897F98146B5E098852AFDC889@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55a0f26-beaf-4fc7-e6cf-08dac1c08a32
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 19:36:32.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NKdDp4VxP5cpZ85RdalkQOY1i8U9fXEP6zRfvtreHao20Z+btRkZzDwx5wWks4sp/8gXevPHlPUY/LTdvOr73gbeSL0y7qkPj0mGNP8pi6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDIyLTExLTA2IGF0IDE1OjQ3IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
U2luY2UgLS13YXlzIGRvZXMgbm90IHRha2UgYSB1bml0IHZhbHVlIGxpa2UgLS1zaXplLCBqdXN0
IG1ha2UgaXQgYW4KPiBpbnRlZ2VyIGFyZ3VtZW50IGRpcmVjdGx5IGFuZCBza2lwIHRoZSBoYW5k
IGNvZGVkIGNvbnZlcnNpb24uCgpBaCBJIGhhZCBnb25lIGJhY2sgYW5kIGZvcnRoIGJldHdlZW4g
dXNpbmcgYW4gaW50IHZzLiB1bnNpZ25lZC4gSSBoYWQKZ29uZSB3aXRoIHVuc2lnbmVkIGJlY2F1
c2UgdGhlIGtlcm5lbCB0cmVhdHMgaXQgYXMgYW4gdW5zaWduZWQgdG9vCmJlaGluZCB0aGUgc3lz
ZnMgQUJJLiBCdXQgSSBndWVzcyBpbiBwcmFjdGljZSBpdCBkb2Vzbid0IG1hdHRlciwgc2luY2UK
dGhlIHZhbHVlcyBhcmUgY2xhbXBlZCB0byBbMjU2LCAxNktdLiBDZXJ0YWlubHkgdXNpbmcgYW4g
aW50IGhlcmUgbWFrZXMKdGhpbmdzIGNsZWFuZXIhCgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbiBX
aWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgo+IC0tLQo+IMKgY3hsL3JlZ2lvbi5j
IHzCoMKgIDQxICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gwqAx
IGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pCj4gCj4gZGlm
ZiAtLWdpdCBhL2N4bC9yZWdpb24uYyBiL2N4bC9yZWdpb24uYwo+IGluZGV4IDMzNGZjYzI5MWRl
Ny4uNDk0ZGE1MTM5YzA1IDEwMDY0NAo+IC0tLSBhL2N4bC9yZWdpb24uYwo+ICsrKyBiL2N4bC9y
ZWdpb24uYwo+IEBAIC0yMSwyMSArMjEsMjMgQEAKPiDCoHN0YXRpYyBzdHJ1Y3QgcmVnaW9uX3Bh
cmFtcyB7Cj4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0IGNoYXIgKmJ1czsKPiDCoMKgwqDCoMKgwqDC
oMKgY29uc3QgY2hhciAqc2l6ZTsKPiAtwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICp3YXlzOwo+
IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpncmFudWxhcml0eTsKPiDCoMKgwqDCoMKgwqDC
oMKgY29uc3QgY2hhciAqdHlwZTsKPiDCoMKgwqDCoMKgwqDCoMKgY29uc3QgY2hhciAqcm9vdF9k
ZWNvZGVyOwo+IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpyZWdpb247Cj4gK8KgwqDCoMKg
wqDCoMKgaW50IHdheXM7Cj4gwqDCoMKgwqDCoMKgwqDCoGJvb2wgbWVtZGV2czsKPiDCoMKgwqDC
oMKgwqDCoMKgYm9vbCBmb3JjZTsKPiDCoMKgwqDCoMKgwqDCoMKgYm9vbCBodW1hbjsKPiDCoMKg
wqDCoMKgwqDCoMKgYm9vbCBkZWJ1ZzsKPiAtfSBwYXJhbTsKPiArfSBwYXJhbSA9IHsKPiArwqDC
oMKgwqDCoMKgwqAud2F5cyA9IElOVF9NQVgsCj4gK307Cj4gwqAKPiDCoHN0cnVjdCBwYXJzZWRf
cGFyYW1zIHsKPiDCoMKgwqDCoMKgwqDCoMKgdTY0IHNpemU7Cj4gwqDCoMKgwqDCoMKgwqDCoHU2
NCBlcF9taW5fc2l6ZTsKPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgd2F5czsKPiArwqDC
oMKgwqDCoMKgwqBpbnQgd2F5czsKPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50IGdyYW51
bGFyaXR5Owo+IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICoqdGFyZ2V0czsKPiDCoMKgwqDC
oMKgwqDCoMKgaW50IG51bV90YXJnZXRzOwo+IEBAIC02Myw5ICs2NSw4IEBAIE9QVF9CT09MRUFO
KDAsICJkZWJ1ZyIsICZwYXJhbS5kZWJ1ZywgInR1cm4gb24KPiBkZWJ1ZyIpCj4gwqBPUFRfU1RS
SU5HKCdzJywgInNpemUiLCAmcGFyYW0uc2l6ZSwgXAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgICJz
aXplIGluIGJ5dGVzIG9yIHdpdGggYSBLL00vRyBldGMuIHN1ZmZpeCIsIFwKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAidG90YWwgc2l6ZSBkZXNpcmVkIGZvciB0aGUgcmVzdWx0aW5nIHJlZ2lvbi4i
KSwgXAo+IC1PUFRfU1RSSU5HKCd3JywgIndheXMiLCAmcGFyYW0ud2F5cywgXAo+IC3CoMKgwqDC
oMKgwqDCoMKgwqAgIm51bWJlciBvZiBpbnRlcmxlYXZlIHdheXMiLCBcCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoCAibnVtYmVyIG9mIG1lbWRldnMgcGFydGljaXBhdGluZyBpbiB0aGUgcmVnaW9ucyBp
bnRlcmxlYXZlCj4gc2V0IiksIFwKPiArT1BUX0lOVEVHRVIoJ3cnLCAid2F5cyIsICZwYXJhbS53
YXlzLCBcCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICJudW1iZXIgb2YgbWVtZGV2cyBwYXJ0aWNp
cGF0aW5nIGluIHRoZSByZWdpb25zCj4gaW50ZXJsZWF2ZSBzZXQiKSwgXAo+IMKgT1BUX1NUUklO
RygnZycsICJncmFudWxhcml0eSIsIFwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmcGFyYW0uZ3Jh
bnVsYXJpdHksICJpbnRlcmxlYXZlIGdyYW51bGFyaXR5IiwgXAo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgICJncmFudWxhcml0eSBvZiB0aGUgaW50ZXJsZWF2ZSBzZXQiKSwgXAo+IEBAIC0xMjYsMTUg
KzEyNywxMSBAQCBzdGF0aWMgaW50IHBhcnNlX2NyZWF0ZV9vcHRpb25zKGludCBhcmdjLCBjb25z
dAo+IGNoYXIgKiphcmd2LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+IMKg
wqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBpZiAocGFyYW0ud2F5cykgewo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIHdheXMgPSBzdHJ0
b3VsKHBhcmFtLndheXMsIE5VTEwsIDApOwo+IC0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKHdheXMgPT0gVUxPTkdfTUFYIHx8IChpbnQpd2F5cyA8PSAwKSB7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb2dfZXJyKCZybCwgIklu
dmFsaWQgaW50ZXJsZWF2ZSB3YXlzOiAlc1xuIiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJhbS53YXlzKTsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFM
Owo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHAtPndheXMgPSB3YXlzOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChwYXJhbS53
YXlzIDw9IDApIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2Vycigmcmws
ICJJbnZhbGlkIGludGVybGVhdmUgd2F5czogJWRcbiIsCj4gcGFyYW0ud2F5cyk7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOwo+ICvCoMKgwqDCoMKgwqDC
oH0gZWxzZSBpZiAocGFyYW0ud2F5cyA8IElOVF9NQVgpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcC0+d2F5cyA9IHBhcmFtLndheXM7Cj4gwqDCoMKgwqDCoMKgwqDCoH0gZWxz
ZSBpZiAoYXJnYykgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcC0+d2F5cyA9
IGFyZ2M7Cj4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gQEAgLTE1NSwxMyArMTUyLDEzIEBA
IHN0YXRpYyBpbnQgcGFyc2VfY3JlYXRlX29wdGlvbnMoaW50IGFyZ2MsIGNvbnN0Cj4gY2hhciAq
KmFyZ3YsCj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgaWYg
KGFyZ2MgPiAoaW50KXAtPndheXMpIHsKPiArwqDCoMKgwqDCoMKgwqBpZiAoYXJnYyA+IHAtPndh
eXMpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZvciAoaSA9IHAtPndheXM7
IGkgPCBhcmdjOyBpKyspCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgbG9nX2VycigmcmwsICJleHRyYSBhcmd1bWVudDogJXNcbiIsIHAtCj4gPnRhcmdl
dHNbaV0pOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7
Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoGlmIChhcmdjIDwgKGlu
dClwLT53YXlzKSB7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKGFyZ2MgPCBwLT53YXlzKSB7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb2dfZXJyKCZybCwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAidG9vIGZldyB0YXJnZXQgYXJndW1l
bnRzICglZCkgZm9yIGludGVybGVhdmUKPiB3YXlzICgldSlcbiIsCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXJnYywgcC0+d2F5cyk7Cj4gQEAgLTI1
Myw3ICsyNTAsNyBAQCBzdGF0aWMgYm9vbCB2YWxpZGF0ZV9tZW1kZXYoc3RydWN0IGN4bF9tZW1k
ZXYKPiAqbWVtZGV2LCBjb25zdCBjaGFyICp0YXJnZXQsCj4gwqAKPiDCoHN0YXRpYyBpbnQgdmFs
aWRhdGVfY29uZmlnX21lbWRldnMoc3RydWN0IGN4bF9jdHggKmN0eCwgc3RydWN0Cj4gcGFyc2Vk
X3BhcmFtcyAqcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgaSwgbWF0Y2hl
ZCA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IGksIG1hdGNoZWQgPSAwOwo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCBwLT53YXlzOyBpKyspIHsKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXY7Cj4gQEAgLTM5Myw3
ICszOTAsOCBAQCBzdGF0aWMgaW50Cj4gY3hsX3JlZ2lvbl9kZXRlcm1pbmVfZ3JhbnVsYXJpdHko
c3RydWN0IGN4bF9yZWdpb24gKnJlZ2lvbiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3QgcGFyc2VkX3BhcmFtcyAqcCkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgY29uc3Qg
Y2hhciAqZGV2bmFtZSA9IGN4bF9yZWdpb25fZ2V0X2Rldm5hbWUocmVnaW9uKTsKPiAtwqDCoMKg
wqDCoMKgwqB1bnNpZ25lZCBpbnQgZ3JhbnVsYXJpdHksIHdheXM7Cj4gK8KgwqDCoMKgwqDCoMKg
dW5zaWduZWQgaW50IGdyYW51bGFyaXR5Owo+ICvCoMKgwqDCoMKgwqDCoGludCB3YXlzOwo+IMKg
Cj4gwqDCoMKgwqDCoMKgwqDCoC8qIERlZmF1bHQgZ3JhbnVsYXJpdHkgd2lsbCBiZSB0aGUgcm9v
dCBkZWNvZGVyJ3MgZ3JhbnVsYXJpdHkKPiAqLwo+IMKgwqDCoMKgwqDCoMKgwqBncmFudWxhcml0
eSA9IGN4bF9kZWNvZGVyX2dldF9pbnRlcmxlYXZlX2dyYW51bGFyaXR5KHAtCj4gPnJvb3RfZGVj
b2Rlcik7Cj4gQEAgLTQwOCw3ICs0MDYsNyBAQCBzdGF0aWMgaW50Cj4gY3hsX3JlZ2lvbl9kZXRl
cm1pbmVfZ3JhbnVsYXJpdHkoc3RydWN0IGN4bF9yZWdpb24gKnJlZ2lvbiwKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBncmFudWxhcml0eTsKPiDCoAo+IMKgwqDCoMKg
wqDCoMKgwqB3YXlzID0gY3hsX2RlY29kZXJfZ2V0X2ludGVybGVhdmVfd2F5cyhwLT5yb290X2Rl
Y29kZXIpOwo+IC3CoMKgwqDCoMKgwqDCoGlmICh3YXlzID09IDAgfHwgd2F5cyA9PSBVSU5UX01B
WCkgewo+ICvCoMKgwqDCoMKgwqDCoGlmICh3YXlzID09IDAgfHwgd2F5cyA9PSAtMSkgewo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2VycigmcmwsICIlczogdW5hYmxlIHRv
IGRldGVybWluZSByb290IGRlY29kZXIKPiB3YXlzXG4iLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldm5hbWUpOwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTlhJTzsKPiBAQCAtNDM2LDEyICs0MzQsMTEgQEAgc3Rh
dGljIGludCBjcmVhdGVfcmVnaW9uKHN0cnVjdCBjeGxfY3R4ICpjdHgsCj4gaW50ICpjb3VudCwK
PiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBmbGFncyA9IFVUSUxfSlNPTl9U
QVJHRVRTOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QganNvbl9vYmplY3QgKmpyZWdpb247Cj4g
LcKgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50IGksIGdyYW51bGFyaXR5Owo+IMKgwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgY3hsX3JlZ2lvbiAqcmVnaW9uOwo+ICvCoMKgwqDCoMKgwqDCoGludCBpLCBy
YywgZ3JhbnVsYXJpdHk7Cj4gwqDCoMKgwqDCoMKgwqDCoHU2NCBzaXplLCBtYXhfZXh0ZW50Owo+
IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpkZXZuYW1lOwo+IMKgwqDCoMKgwqDCoMKgwqB1
dWlkX3QgdXVpZDsKPiAtwqDCoMKgwqDCoMKgwqBpbnQgcmM7Cj4gwqAKPiDCoMKgwqDCoMKgwqDC
oMKgcmMgPSBjcmVhdGVfcmVnaW9uX3ZhbGlkYXRlX2NvbmZpZyhjdHgsIHApOwo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAocmMpCj4gCgo=

