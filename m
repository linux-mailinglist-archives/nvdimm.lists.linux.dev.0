Return-Path: <nvdimm+bounces-6279-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9231D7442A7
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 21:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 492C2281188
	for <lists+linux-nvdimm@lfdr.de>; Fri, 30 Jun 2023 19:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72B4174DC;
	Fri, 30 Jun 2023 19:17:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E7171BB
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688152675; x=1719688675;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=cI7QH6PXnJ2+yV60boV0wKoiVgCsj1GszN6VLufcFmc=;
  b=ZIOzCVu64EFbvVJoxh/OnmmfhFxaGA0QDcTYtZy3+yVEKi+Lgh49qAKs
   4Jj45aW33pdrAHmAIMCcIz65e66/5N0DUzWg4qBfS79WCU1rhyQFDjqaM
   qg9KktH6O3zTikSr0SntJYUVy+nV3i7gT5HcVmNdb93wozTUmmzI7JqAj
   tRjzjtKTnpyrYFDRTUcSQik0w0mNt0D94/uANifCptrM5GPRUCCtiend4
   77aB/P8O/DZQVHYEpgbYuzGDGpwjee7nJHdtI5Yux/R4611O1VjIGPap2
   jPZkZKySRv5jiux/ZW7GD9lVhjPvVoF5d05wss7FOLULbuuEYX5X3n22d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="342806522"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="342806522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 12:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="747515134"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="747515134"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 30 Jun 2023 12:17:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 12:17:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 12:17:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 12:17:53 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 12:17:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdgKQq0Fm/oe2UOzBcnFInGEc54j1jHjBWG8lrzxW4cqR4LfyCzMOI9XxBWzPfbfq2XN7Q+0qt4yByHHWeCDO2GYMzsY5TgStWjEGXwupgn22f565ByjiOm+6W6IWgQcjT55+xK/4mcTFFQLaG/Onvg8Pc5hctKhvNSRusTj6AmBv8ztO1JhA3MiG3MUJN4bsR3xxTWrDw8zAMsyuUJauvN2MCZNMYzzc8FnDpkJ17EawVyEXv3rrXVoL3Y5ZH4wLnOrj1prSkkN1GCAclAcfuV7Utsg64rAOTHg8jk334pFfDzbXy1oFF8jFBXupFi80vbRI6Im166P/T/dFZNQew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cI7QH6PXnJ2+yV60boV0wKoiVgCsj1GszN6VLufcFmc=;
 b=VpHIqgE/w8B6IQX2ZhTwhs3qVcYSPuZ4es+hxpmwP1gTEXpKMXNShzvpXMjTfTMKVdVRRlot1T/+rwqpWG2ryukBdvK865prZgXmwDs/vpIHU/Cn85jpk1XaIsHFI4l8odTJsZe5wK6VQ7yfwsZLHs3zOZ/hXbKm0XQJhHm4/60N1ykk3TMYrt7be5jFptsfOS8qz1U/JHwVL2nCyia6OLyl1ll88RdARlcQJEMac1yKZrxUgLgyCrrKlxBZGTqAa6R/tWHH00G3INdssP0ZIpajTLlA52HeXMs6Hx6azsEZr1S9t9I4DavsKIdAglr5ZgH23XLSL2npD+j/gbG7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW3PR11MB4666.namprd11.prod.outlook.com (2603:10b6:303:56::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 19:17:47 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::c1d2:a32a:f7ef:1803]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::c1d2:a32a:f7ef:1803%7]) with mapi id 15.20.6521.024; Fri, 30 Jun 2023
 19:17:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Torvalds, Linus" <torvalds@linux-foundation.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [GIT PULL] NVDIMM and DAX for 6.5
Thread-Topic: [GIT PULL] NVDIMM and DAX for 6.5
Thread-Index: AQHZq4eN8+cRTdpSmk2H0698Ut9SpA==
Date: Fri, 30 Jun 2023 19:17:47 +0000
Message-ID: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW3PR11MB4666:EE_
x-ms-office365-filtering-correlation-id: 569f0c15-d459-4f97-0276-08db799eb065
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: My7r+IUJufdsqmPKRdaWMMNT3pcg4o1Fztz9Oz2pLCPKDg45xYA4D5td8qnvki3Y3QfJu/w9Kkj95usSRALJmWX5tDwoEYRa4pOaa3QFS8n9K41vGaplhRZAZgVvz4OMVAo2vBpGFuOsxK3e2oO6nxP4vvyb32pT0dej/+AtuVMYbsMPEoLhpaq+iaPhtBttbxofdEH3nKl6GpvjappbyWOpRoGi/TdOWO6oCRj1AqEyeWbJOyE1Dw9BtCQvtI07RvUqT0SkFklXFgPAsfDJ1wsaZPAZIVK6kjlRkZkhguCsZ/o5cAJzML+Q8lc6uYJEgHaJbwh4KX6qIp96iYQcEWOLZLKipU+fLDD4/lPONRR8gAreOxFMlzti+Qltt94S2SPUaDb3iS2h980bX3Bj/KI77OZztFpACc/E2MLiyop8tdxGqUEZw0mmhY6ek6xxrSYvfmUIwhOxrZbya8kfDFWO0OgaPnDhjGxYF8TEdKEPnAaZ65fNaQXlZlLEpml0JVuEtlitfe50X2FkQ88UaAILW5Q9J4NFchdFKDdYkQiR3NYDtpfcXrmvoXmLfNr1ZepmktyJG2chChjZM3+LjI/y10gCrKbYfBzIYwrr6GiLIyAOoc5io+7rS5c+F/5v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(66574015)(83380400001)(38070700005)(2616005)(2906002)(122000001)(38100700002)(82960400001)(36756003)(8936002)(8676002)(5660300002)(86362001)(71200400001)(54906003)(6512007)(41300700001)(76116006)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(66946007)(316002)(6486002)(478600001)(186003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWNtL3dRUC9rZkxPTUNjeFhWMXh5bCt5elRHYWJ6eXoyQ2dxdkxFSUxNK3Na?=
 =?utf-8?B?c29ta2xHY3NqSjRiS1FUOVJxbEY1Tkp1SUIzYzBtc2tyZHdub2RnMk5pVGZD?=
 =?utf-8?B?blVYYWRDSC9mZ0hlcXRGQUhVQ0oyWldNelhsMXBEcTJVNCtPME5nUFlTMWN4?=
 =?utf-8?B?K1ZacmppQ29mcXVRb2F0U2h3U0h6RUl6RDQrOEdyT3JFVUMxeFNjNFlwQ0E0?=
 =?utf-8?B?QWtPeFBQUWc3YmxkZFBHN0RENW9KL3pFUGphUTl4ZGlVZUladUJiMWF2czlO?=
 =?utf-8?B?UGx4L09Fc2JqNURETE0xb0ZLVldPTHRoQk9iUDZJWGVncVIwMTJpbmh1UWt6?=
 =?utf-8?B?eDdXc0dmVXYyY2d1N3R0bC9LenZUWmFoaTNNRjIwOFkzNE5veWJtVlg1aTND?=
 =?utf-8?B?a2dJSVlMUW15T1R1aElOSld5NTdSaE9iWHBuSzhuQVBkdmJTV1dNZTU5b1dy?=
 =?utf-8?B?RGtLMUpCR1VOTjc2YzhETTVmZlYwMmhGcGhYTmhlVnZrZ3BGbFp6cStXaXpy?=
 =?utf-8?B?SlJ6cGV1WjdsT0Uxc2h5L3pyNmdDem9RcFdleFBvMW9ZUlBORWg3amVzVHl5?=
 =?utf-8?B?eFBCUXdVKzVMRXpCRXZUOGNMMVhmNkVyam1BMUVqRjdVUWtUZ05ocnRmcnlH?=
 =?utf-8?B?ZkJEdm1rTEdXSkV2VHJoSU11by9SNlU1OTUxc3pyOUkyVlNrRDR1ZytNbU93?=
 =?utf-8?B?NWZwaDh4OTJTdDRlZk1pMGhzQlRUc1pPMTYwR2ZZQll4TWdLRUFmREFOa08z?=
 =?utf-8?B?V3ViZmh2akVOYWxvbXNxY0RreWNCRFc0QnM3Q3BnbnJudTlFSWY5VEhzY2VJ?=
 =?utf-8?B?OXBVSGNqUzFQN3dPZlZIQ2xSRXJMZExtYkhFQ3BUc2NVMVFMTHlrUE5aNkM2?=
 =?utf-8?B?elhPWEdaY1Y0MUMwc2k3bVA2dFd0SkNpRnJoc3pab0tRNzlmb2d3MjJqbkcv?=
 =?utf-8?B?WGxpMEoyaERJYzRkemRMOCtQU3oxb0RaVXd0RTkxaTN3cXRzZVk0QzNVd3Zt?=
 =?utf-8?B?ZVZXdDA3c0hXcWxJeDB3aVlXT09uRTZ4MmdYRXBRYjdldDNFZEZiejEwRzlP?=
 =?utf-8?B?ZnhuSWgvckFSZHhwUEs3K3ZXdHpSeWJPUlpDcitlQ09zSHdISTBKODl3b25O?=
 =?utf-8?B?RHNyT09hMy9KOUJOQ1k5QnJqbjJjS0ZMV3UzYU4yV2l5VWFqUEw5dzBpaWQ0?=
 =?utf-8?B?bkRZREdIdFJwVFk4RmNqTFBvdk1oN1JOOGlGNWNReG5VcWVQVVBDR29Qejl2?=
 =?utf-8?B?eG1XYlpkaGxwZzdma051eklRNWtrcUplTFM2N3Z1SlpDZFJlLzhwMW4vaGRE?=
 =?utf-8?B?YTRPdUlvN1hxeFc1RjU0ZndpK2R5dlkrQ2I2R2Y1b3lsY0U2bDV3aFlmL3lD?=
 =?utf-8?B?dW9sSmd6a0FDRG9jYkwrai9EQlltajZFNmNILzdnWFBVRFRqd2VGYWU3NjEv?=
 =?utf-8?B?TjV3QTZad2p0bmMySTRPWTRmeUEvbWFWSTRIeE45anQ3Ni9zeVgvMi9yeFJ1?=
 =?utf-8?B?V3VyNXllc2UyZ203ZTAyYitBRktNTm1TSUM2bS9ld01lVjZvMmdYc0lYUTZt?=
 =?utf-8?B?Y1l4TjlnemJvNWxwZGZJanJNbGswL3U3aHQ3dXV3cDFQVmFFL05rYVE3TnRB?=
 =?utf-8?B?bWh0NDlsOXRZeW9udm8reFJkd2hmYmwzcmhjTmxwZEhkYW51WWNJc0pFSEVD?=
 =?utf-8?B?SktEbWFWRUxEejBoZ09WUEs4VFkvQkZoMVZUYm1peVBuMFBHNktsMHFDeHFF?=
 =?utf-8?B?YWpTNDc4ekxPUHRoN1FVUUdYaXZmbEF1UkdPSEtBWFg3YnR2ZVdvTlAxbDBQ?=
 =?utf-8?B?R2VFUng5OWV1d0JJNGlvWWNGZVJ5SDFTU1hqNVZpRC9mTUtOeHNpUy9FelhB?=
 =?utf-8?B?bGJUQWJjQTlXU0pXZE90VStNWDFRM05xNzl6QVdqbUY1Smc4bzNxSWFCd1NU?=
 =?utf-8?B?UVlLeENIZVFOWllrMlI1OFdSYU85NDB2dDhwUzl0UVJjWlZidTh2Zy8wUXpB?=
 =?utf-8?B?QmlIZWJPS3FVcFVTdUtsTEFGYldjWXNEa0E5d3kreVdwbzB2YVdIdUthZG8w?=
 =?utf-8?B?dXpVUWZiRmowcmxVaDN2ME1JQ0hvWm1JRklXRlJadG5QVmlINFhGbk9UQVVh?=
 =?utf-8?B?SUxYdGRUdkRKS1Z0QUx2M2x2YnEza1VnbC9RNXNsZjAyeXRXVElOZm80S2Fl?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71517BF39B7A7E459127E93FF3760EA6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569f0c15-d459-4f97-0276-08db799eb065
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 19:17:47.4009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7zVi4o5KtMbK2qTljimUiQbTkN2MhTlyLHhEW1sCBbRA7Apnz1QCMp8+SEq2QFDOXBlDx3A2H70h3IRgUpLOmesMIuNJ/M7xZVxQgzH3J0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4666
X-OriginatorOrg: intel.com

SGkgTGludXMsIHBsZWFzZSBwdWxsIGZyb20NCg0KICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvbnZkaW1tL252ZGltbS5naXQgdGFncy9saWJudmRpbW0tZm9y
LTYuNQ0KDQouLi4gdG8gcmVjZWl2ZSAgdGhlIGxpYm52ZGltbSBhbmQgREFYIHVwZGF0ZSBmb3Ig
djYuNS4NCg0KVGhpcyBpcyBtb3N0bHkgc21hbGwgY2xlYW51cHMgYW5kIGZpeGVzLCB3aXRoIHRo
ZSBiaWdnZXN0IGNoYW5nZSBiZWluZyB0aGUNCmNoYW5nZSB0byB0aGUgREFYIGZhdWx0IGhhbmRs
ZXIgYWxsb3dpbmcgaXQgdG8gcmV0dXJuIFZNX0ZBVUxUX0hXUE9JU09OLg0KDQpJdCBoYXMgYXBw
ZWFyZWQgaW4gbGludXgtbmV4dCB3aXRoIG5vIHJlcG9ydGVkIGlzc3Vlcy4NCg0KT24gYW4gb3Bl
cmF0aW9uYWwgbm90ZSwgYXMgRGFuIGhhbmRlZCBvZmYgdGhlIGJyYW5jaCB0byBtZSBmb3IgdGhp
cyBjeWNsZSwgd2UNCm1pc3NlZCB0aGF0IHRoZSBvcmlnaW5hbCBmZXcgY29tbWl0cyB3ZXJlIGlu
YWR2ZXJ0ZW50bHkgbWFkZSBvbiB0b3Agb2YgYSBmZXcNCkNYTCBjb21taXRzIHRoYXQgd2VudCBp
biBpbiB0aGUgNi40LXJjIGN5Y2xlIHZpYSB0aGUgQ1hMIHRyZWUuDQoNCmdpdC1yZXF1ZXN0LXB1
bGwgaW5jbHVkZWQgdGhlc2UsIGFuZCBoZW5jZSB0aGV5IGFwcGVhciBpbiB0aGUgc2hvcnRsb2cg
YW5kDQpkaWZmc3RhdCBiZWxvdywgYnV0IHRoZSBhY3R1YWwgbWVyZ2UgY29ycmVjdGx5IGlkZW50
aWZpZXMgYW5kIHNraXBzIG92ZXIgdGhlbS4NCkkga2VwdCBpdCBhcyBpdCBpcyB0byBwcmVzZXJ2
ZSB0aGUgbGludXgtbmV4dCBzb2FrIHRpbWUsIGJ1dCBpZiBJIHNob3VsZCBoYXZlDQpkb25lIGl0
IGRpZmZlcmVudGx5LCBwbGVhc2UgbGV0IG1lIGtub3cuDQoNCi0tLQ0KDQpUaGUgZm9sbG93aW5n
IGNoYW5nZXMgc2luY2UgY29tbWl0IGYxZmNiYWExOGIyOGRlYzEwMjgxNTUxZGZlNmVkM2EzZWQ4
MGUzZDY6DQoNCiAgTGludXggNi40LXJjMiAoMjAyMy0wNS0xNCAxMjo1MTo0MCAtMDcwMCkNCg0K
YXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoNCiAgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L252ZGltbS9udmRpbW0uZ2l0IHRhZ3Mv
bGlibnZkaW1tLWZvci02LjUNCg0KZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIDFlYTdj
YTFiMDkwMTQ1NTE5YWFkOTk4Njc5MjIyZjBhMTRhYjhmY2U6DQoNCiAgZGF4OiBlbmFibGUgZGF4
IGZhdWx0IGhhbmRsZXIgdG8gcmVwb3J0IFZNX0ZBVUxUX0hXUE9JU09OICgyMDIzLTA2LTI2IDA3
OjU0OjIzIC0wNjAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpsaWJudmRpbW0gZm9yIDYuNQ0KDQotIERBWCBmaXhl
cyBhbmQgY2xlYW51cHMgaW5jbHVkaW5nIGEgdXNlIGFmdGVyIGZyZWUsIGV4dHJhIHJlZmVyZW5j
ZXMsDQogIGFuZCBkZXZpY2UgdW5yZWdpc3RyYXRpb24sIGFuZCBhIHJlZHVuZGFudCB2YXJpYWJs
ZS4NCg0KLSBBbGxvdyB0aGUgREFYIGZhdWx0IGhhbmRsZXIgdG8gcmV0dXJuIFZNX0ZBVUxUX0hX
UE9JU09ODQoNCi0gQSBmZXcgbGlibnZkaW1tIGNsZWFudXBzIHN1Y2ggYXMgbWFraW5nIHNvbWUg
ZnVuY3Rpb25zIGFuZCB2YXJpYWJsZXMNCnN0YXRpYyB3aGVyZSBzdWZmaWNpZW50Lg0KDQotIEFk
ZCBhIGZldyBtaXNzaW5nIHByb3RvdHlwZXMgZm9yIHdyYXBwZWQgZnVuY3Rpb25zIGluDQp0b29s
cy90ZXN0aW5nL252ZGltbQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpBcm5kIEJlcmdtYW5uICgzKToNCiAgICAgIGRh
eDogZml4IG1pc3NpbmctcHJvdG90eXBlIHdhcm5pbmdzDQogICAgICB0ZXN0aW5nOiBudmRpbW06
IGFkZCBtaXNzaW5nIHByb3RvdHlwZXMgZm9yIHdyYXBwZWQgZnVuY3Rpb25zDQogICAgICBsaWJu
dmRpbW06IG1hcmsgJ3NlY3VyaXR5X3Nob3cnIHN0YXRpYyBhZ2Fpbg0KDQpCZW4gRG9va3MgKDIp
Og0KICAgICAgbnZkaW1tOiBtYWtlIG5kX2NsYXNzIHZhcmlhYmxlIHN0YXRpYw0KICAgICAgbnZk
aW1tOiBtYWtlIHNlY3VyaXR5X3Nob3cgc3RhdGljDQoNCkNvbGluIElhbiBLaW5nICgxKToNCiAg
ICAgIGZzZGF4OiByZW1vdmUgcmVkdW5kYW50IHZhcmlhYmxlICdlcnJvcicNCg0KRGFuIFdpbGxp
YW1zICg1KToNCiAgICAgIGN4bC9wb3J0OiBFbmFibGUgdGhlIEhETSBkZWNvZGVyIGNhcGFiaWxp
dHkgZm9yIHN3aXRjaCBwb3J0cw0KICAgICAgZGF4OiBGaXggZGF4X21hcHBpbmdfcmVsZWFzZSgp
IHVzZSBhZnRlciBmcmVlDQogICAgICBkYXg6IFVzZSBkZXZpY2VfdW5yZWdpc3RlcigpIGluIHVu
cmVnaXN0ZXJfZGF4X21hcHBpbmcoKQ0KICAgICAgZGF4OiBJbnRyb2R1Y2UgYWxsb2NfZGV2X2Rh
eF9pZCgpDQogICAgICBkYXg6IENsZWFudXAgZXh0cmEgZGF4X3JlZ2lvbiByZWZlcmVuY2VzDQoN
CkRhdmUgSmlhbmcgKDIpOg0KICAgICAgY3hsOiBXYWl0IE1lbW9yeV9JbmZvX1ZhbGlkIGJlZm9y
ZSBhY2Nlc3MgbWVtb3J5IHJlbGF0ZWQgaW5mbw0KICAgICAgY3hsOiBNb3ZlIGN4bF9hd2FpdF9t
ZWRpYV9yZWFkeSgpIHRvIGJlZm9yZSBjYXBhY2l0eSBpbmZvIHJldHJpZXZhbA0KDQpKYW5lIENo
dSAoMSk6DQogICAgICBkYXg6IGVuYWJsZSBkYXggZmF1bHQgaGFuZGxlciB0byByZXBvcnQgVk1f
RkFVTFRfSFdQT0lTT04NCg0KVGFydW4gU2FodSAoMSk6DQogICAgICBkYXgva21lbTogUGFzcyB2
YWxpZCBhcmd1bWVudCB0byBtZW1vcnlfZ3JvdXBfcmVnaXN0ZXJfc3RhdGljDQoNClV3ZSBLbGVp
bmUtS8O2bmlnICgxKToNCiAgICAgIHRvb2xzL3Rlc3RpbmcvbnZkaW1tOiBEcm9wIGVtcHR5IHBs
YXRmb3JtIHJlbW92ZSBmdW5jdGlvbg0KDQpWaXNoYWwgVmVybWEgKDEpOg0KICAgICAgTWVyZ2Ug
YnJhbmNoICdmb3ItNi41L2RheC1jbGVhbnVwcycgaW50byBudmRpbW0tZm9yLW5leHQNCg0KIGlu
Y2x1ZGUvbGludXgvZGF4LmggICAgICAgICAgICAgICAgICAgfCAgMTMgKysrKw0KIGluY2x1ZGUv
bGludXgvbW0uaCAgICAgICAgICAgICAgICAgICAgfCAgIDIgKw0KIGRyaXZlcnMvY3hsL2N4bC5o
ICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KIGRyaXZlcnMvY3hsL2N4bG1lbS5oICAgICAg
ICAgICAgICAgICAgfCAgIDIgKw0KIGRyaXZlcnMvY3hsL2N4bHBjaS5oICAgICAgICAgICAgICAg
ICAgfCAgIDIgKw0KIGRyaXZlcnMvZGF4L2J1cy5oICAgICAgICAgICAgICAgICAgICAgfCAgIDgg
LS0tDQogZHJpdmVycy9kYXgvZGF4LXByaXZhdGUuaCAgICAgICAgICAgICB8ICAxMSArKystDQog
dG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9uZml0X3Rlc3QuaCB8ICAyOSArKysrKysrKysNCiBk
cml2ZXJzL2N4bC9jb3JlL21ib3guYyAgICAgICAgICAgICAgIHwgIDE1ICsrKy0tDQogZHJpdmVy
cy9jeGwvY29yZS9wY2kuYyAgICAgICAgICAgICAgICB8IDExMiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tDQogZHJpdmVycy9jeGwvbWVtLmMgICAgICAgICAgICAgICAgICAgICB8
ICAgMyArDQogZHJpdmVycy9jeGwvcGNpLmMgICAgICAgICAgICAgICAgICAgICB8ICAgNiArKw0K
IGRyaXZlcnMvY3hsL3BvcnQuYyAgICAgICAgICAgICAgICAgICAgfCAgMjAgKysrLS0tDQogZHJp
dmVycy9kYXgvYnVzLmMgICAgICAgICAgICAgICAgICAgICB8ICA2NCArKysrKysrKysrKy0tLS0t
LS0tDQogZHJpdmVycy9kYXgvY3hsLmMgICAgICAgICAgICAgICAgICAgICB8ICAgOCArLS0NCiBk
cml2ZXJzL2RheC9kZXZpY2UuYyAgICAgICAgICAgICAgICAgIHwgICAzICstDQogZHJpdmVycy9k
YXgvaG1lbS9obWVtLmMgICAgICAgICAgICAgICB8ICAgOCArLS0NCiBkcml2ZXJzL2RheC9rbWVt
LmMgICAgICAgICAgICAgICAgICAgIHwgICAyICstDQogZHJpdmVycy9kYXgvcG1lbS5jICAgICAg
ICAgICAgICAgICAgICB8ICAgNyArLS0NCiBkcml2ZXJzL2RheC9zdXBlci5jICAgICAgICAgICAg
ICAgICAgIHwgICA1ICstDQogZHJpdmVycy9udmRpbW0vYnVzLmMgICAgICAgICAgICAgICAgICB8
ICAgMiArLQ0KIGRyaXZlcnMvbnZkaW1tL2RpbW1fZGV2cy5jICAgICAgICAgICAgfCAgIDQgKy0N
CiBkcml2ZXJzL252ZGltbS9wbWVtLmMgICAgICAgICAgICAgICAgIHwgICAyICstDQogZHJpdmVy
cy9zMzkwL2Jsb2NrL2Rjc3NibGsuYyAgICAgICAgICB8ICAgMyArLQ0KIGZzL2RheC5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTQgKystLS0NCiBmcy9mdXNlL3ZpcnRpb19mcy5j
ICAgICAgICAgICAgICAgICAgIHwgICAzICstDQogdG9vbHMvdGVzdGluZy9jeGwvdGVzdC9tZW0u
YyAgICAgICAgICB8ICAgMSArDQogdG9vbHMvdGVzdGluZy9jeGwvdGVzdC9tb2NrLmMgICAgICAg
ICB8ICAxNSArKysrKw0KIHRvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jICAgICAgfCAg
IDYgLS0NCiB0b29scy90ZXN0aW5nL2N4bC9LYnVpbGQgICAgICAgICAgICAgIHwgICAxICsNCiAz
MCBmaWxlcyBjaGFuZ2VkLCAyNjUgaW5zZXJ0aW9ucygrKSwgMTA3IGRlbGV0aW9ucygtKQ0K

