Return-Path: <nvdimm+bounces-8074-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7078CFB94
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 May 2024 10:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068721F219F9
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 May 2024 08:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDA956477;
	Mon, 27 May 2024 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="F/7ALzDU"
X-Original-To: nvdimm@lists.linux.dev
Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A981654907
	for <nvdimm@lists.linux.dev>; Mon, 27 May 2024 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716798933; cv=fail; b=Mj+18lWQeecu1vg6JN4b18ZJ1Eq5iN2vpyuXPFi9ofnBsrOPKJtz/30be10InjlENZ6Hs8VdhfnciB2DcqRWtyDDgww3YYKN9nT3cFHsgUtdKo18Qb+vNIw/vXPxVrzXL91xLbIXv4QMFmmD3sBgTsvL7gfVa4T9dwugO4YMlqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716798933; c=relaxed/simple;
	bh=a9R5iYKHjz18sd8ojSvwauIMgpxWimn/jWGQ5nFXRe4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=heU9zHZKIV/FoXKTy6ir25fk67lnMVF0QCGn1eqDslHlAAMWwvZwjEtG90+d58WBT4NLCuf7ZYDA9aSgGOAev9Br3YZiWGlFDsjP6KTehpHDuDXzYSzLwTtch0E/QMRBs+UnYBYCLtod1eRCAtgmjsuwh9xDZe9wi1XSP6oTsis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=F/7ALzDU; arc=fail smtp.client-ip=216.71.156.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1716798929; x=1748334929;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=a9R5iYKHjz18sd8ojSvwauIMgpxWimn/jWGQ5nFXRe4=;
  b=F/7ALzDUge8HRFj9ClNQGYIuTnj5WDZI51tkaACCGd9UT9/sGgNm9Ljl
   bE84c4rY8ZQDJ8j2Potzs6TRZq4wYKEtXcsHFCI/5KW4FnR371lBKBNy3
   /U+Xmtft3eMlVAbSR8PbwefI9+kp+XIYLpW2kk7Z/hQBWQ2T638FSG93l
   PveTnwnlrerxQQkyIfLC64ps5N2Gc8tEBQL2eFRj/9EX0vIVoH0YyofwA
   dDTZPyNTB7JKc/Gv76c1UtPT1OA27LaTmlHkrUnbIpGXsrqY8KDD260EW
   vRqWAn0id0WcRrE6WVvEeS5GKW2eQD5T6PklUy0f8h2CUH7dKMuISBcXN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="120700339"
X-IronPort-AV: E=Sophos;i="6.08,192,1712588400"; 
   d="scan'208";a="120700339"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 17:34:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ita42CVbWf2t15sAESkc0K8WzghjP/BLNBfMGbUvUBrZ36pc+tE4h0Lgw3nvf+OIQ+bUKiU0ItdF5IzgNS9r/OMRgpB4B8wMKGBI0mF/9gft5vvqsA3YUsDG0203ZU/e++bUfFZyn5e1cUY8jj8mOf8gx6rio9pBIQ7cGiSERgOLCv00gPW+lQOo0UwBdWghX9ZkDBUF8J/G8PQijYoMoBN9ooxGywwKVpkImFe0UmkKk65YhmpQh//wJJxEAgAWKtuXhyTJQ0vhgtJ5X+6NOODsPUZxnRM/35EDBAOLBgsx6dFdhxatIGCfAq+mcN4sCFGd9wPXycBP/mxER1BfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9R5iYKHjz18sd8ojSvwauIMgpxWimn/jWGQ5nFXRe4=;
 b=Xd7iKkHncwNJh2r9Iz2hxex4EMFrJaGhp2dJX+sKDBCUrcZ7gLYQclEKYs8KisnxKLP3csizQz1JAJeuzgxbznp5l7GTMzgL2uYeuWUJZGh5uGPIJaRjDR3tDDYBp7aEeqwhhVQB7s9L2jYqcufk7+YHBmkVzxNKNgwy15ZrdVZXcU8n2k4sIxYOW/B5e72iGN7WQaJ+uy24xcjWw0bsUNkkTOj6N78o+kgd5ma9MXPOxcYLrn60Bmq+j5Dp9/aPE3sGPn/svdx2E5PWHwclai0dfBKh2QQB9ePCDBIoi2o3Q+xFF2IcFM2U6lnBvfJ2eLJ9RS0+Hc+FeB0tEIZoDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OSZPR01MB6956.jpnprd01.prod.outlook.com (2603:1096:604:138::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 08:34:13 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%6]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 08:34:13 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 2/2] daxctl: Fix create-device manual
Thread-Topic: [ndctl PATCH 2/2] daxctl: Fix create-device manual
Thread-Index: AQHasAGEN7l9fXyWX0+f8W3US0cKa7GqwUiA
Date: Mon, 27 May 2024 08:34:13 +0000
Message-ID: <6d0e20c3-85c1-4406-9ff1-541dbab32df8@fujitsu.com>
References: <20240527064539.819487-1-lizhijian@fujitsu.com>
 <20240527064539.819487-2-lizhijian@fujitsu.com>
In-Reply-To: <20240527064539.819487-2-lizhijian@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OSZPR01MB6956:EE_
x-ms-office365-filtering-correlation-id: 25b14285-a537-4af3-5197-08dc7e27c9f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|366007|376005|1580799018|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?a1A3OXFhQUNkbDNEdWprc3UwTXJkcHl4SWFwekZyeExpSHRHWnkwNGxtWVdU?=
 =?utf-8?B?cldhWThxdi93enNDSkNnWnp1MysrSy9sL1lFaVVGSlBhQUR3TnB3VTk0TVlC?=
 =?utf-8?B?WjR5TDZwVUxkSGpBNVdibGpWR1JDSFUvU0REZDZpNUwyVmdwcXRtZFcxMzF2?=
 =?utf-8?B?dnkwSWJWdm1MaGY3WlJFLzM4RFIzempiNllyaUhia0MreWhnVU9tazV0Z1R3?=
 =?utf-8?B?Q3hQOTZOeHczN2J1cFVoM2g4M2JPYitpZ1pWNlpwaUR5QXFheUtpQ0hmYU93?=
 =?utf-8?B?RzFFMlBsQU1ER0ZWbURVTk1oU1Qvd1dxZ3ZHcDdlQmhoc0wyVzRkdXlkR2da?=
 =?utf-8?B?N2hZS3lNK01xYlhsR1ZoL0ovYmdWZmszZ1IxdzFiUWFkcXhPendNL20yU3N2?=
 =?utf-8?B?V200S0ZwR2tUZzg3eWdEYllpYmtHbytocXoyN2xRZUQ3TDB0ckZUbk1TdDYr?=
 =?utf-8?B?OE4zZDdJWiszUHFTUUpFSjNDWkRkUEZnRVE1dGRPSmc0Nkl0ODNmQjdNVVVu?=
 =?utf-8?B?WlExVy9MVS9TL2FHT01pR3dCa1o5U3AyU1laRGpKbmRVYXA4bHdva1A3bERt?=
 =?utf-8?B?SDgxTXFxd1VzZ0Y5ekcyRFFGNS9ScW5WNWErb0JYZEZFOFNDcVhRZEZ1R1hN?=
 =?utf-8?B?Y21mU3hsV1RiZUtNYXFGWFpOZkcwSHN4OVNKTCtrL2ZpZHIwTG5hVTNUcjEx?=
 =?utf-8?B?VFZqb0h5aFUyVW5TbTc5ZVJzOVFCbVpoandrRWZtQ1MxVlY5WGNkNFUwTWkz?=
 =?utf-8?B?RjBaRDBYS0VHQWtxNDFTd3dyU2pIbk5wdHA1YW9xanRZZ2J2MmVPMXQvbGJU?=
 =?utf-8?B?eCttbFpKZlp4QlNibTBOTm5BUDBtL0FwY0VnOUltcU16UGx6blZIRkpjK0dL?=
 =?utf-8?B?aCtIMG9MQ0FGaGQ2dXhteC9YdDlRSno4eG03VnBlK09ucko5YUl3ckgwRE40?=
 =?utf-8?B?V1BwSVVGbkVvVmR5ZDZlTk1FcElyWFNsMGp3Qm56TEx2V05iR3VOLzN4MU1o?=
 =?utf-8?B?OHpFM3R4Q20xMHY4c1loU213SzlCb3JPL09WUDRNRVZBZ1EvSU1nWC84QlNC?=
 =?utf-8?B?VzRHMkdQcnFEK0ViN01LQlpxTVIwa013bXN2WTl6ZnpCVGVXbGlRdmFaOGsx?=
 =?utf-8?B?NmdwaWxoby9UL01qNzEybVE3MEJWajhraFNYVkJid3NRMFV6QkpqcG5IUzBX?=
 =?utf-8?B?MjF3SmwwRkRlbzVJUHE3aktGbXdjdjJkaHJoY0EybE5TbUEyYkl4UlhLS1lV?=
 =?utf-8?B?M25RT2cydlZvR2hVVEErNTA2TGNIR014UFU5b0xxZGhMRVBWdG5zbHhLc3Rl?=
 =?utf-8?B?R0NzODh2ZjBLMnk1VHlpMHh5dmRMaDBsR3NlRjdHdHhORTdYY0JaVkhobXA5?=
 =?utf-8?B?dWF2b0hITG5mLzJnT1dWK01DRm1SWmpudy81SEJhbUIvOUNGa1FNK3FUN0xw?=
 =?utf-8?B?UTVxWlF4OG1nMUxydkJiSmRlVVNmbnRQejQxK3NqQ1VCNy9XS3U2bG9wWlVq?=
 =?utf-8?B?a014aU81eEJ2eklSbk9GMEdjUi9XRTBTU05zUnRWZ29MSnhwUkloUW5KbzdG?=
 =?utf-8?B?WHhsTVZXK1M3aDlmdFA3Z1pGT1pMMytmUnFwK0FVMGJZdDkzdkt4VmJObkpE?=
 =?utf-8?B?Vm5jRGc3NUhLU1VRUDlmRVdTWmlDaCtXK2NaZlduZ0ZFM3Q5OU9ja1ZrNG9H?=
 =?utf-8?B?RXlvUjl6ZkxUSStxSEJ4YUhBNUpQQVcvL0pnZXVuMW5qL21hc2dQa2lNT1Nh?=
 =?utf-8?B?OUE4WkU2cllEckVYa2p1K3NIaU81UWhNY3IvZG1wRUdVOHpOM1c5akNscHM2?=
 =?utf-8?Q?iNWnEasqbFMjVg9g1xpUd0Y8anR0y6FUq3l1A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ams1WGF4OXlYWk43RklCckxaRmpFS0NoUW13ZWN2STQxa3JPOFhNU1N6TnR4?=
 =?utf-8?B?bVBZNnVZRkxHbTAwamNFeEJ3SFVUeE5wY2EySStaRVMzbms1aGxwNG91YnBL?=
 =?utf-8?B?VUlOZmhOSlZ2L0VmcGFta05KTThVUnRXRWJPRCs1SnlMTmZRMDBwR2V5WGlN?=
 =?utf-8?B?K3I3OURrTUEzZ1RIMDU5RjQzYm1uVFZORG5LM05YRytOMG11OXBpVTZ2OW9j?=
 =?utf-8?B?Q3lFN3lrMEJOL2FvbWF4QmVXRmplbVNheXJvUDFzZ1BFejNBODVQd3hYWjJY?=
 =?utf-8?B?RlFRS2JoVThSQWtpVDMvcmtkOER4S0RHbjVZbDJUTmZQNDN3WnBnem1QRFBD?=
 =?utf-8?B?dWtVbXp3bXVDa3BnMHIwaHZaRUVLYXJiT2tnRGlTSUQ5UWR3RjhHWndXNWFl?=
 =?utf-8?B?RmFaVndscUdMaEFhQUZSU3duWWJDa0lzdHJNeFk4U05GYis4UFA2TTM3Tml3?=
 =?utf-8?B?NWJLdDZ4ck5GYS9uOGp6aEhoREx5VzM5MVQ5aFQ2Q0QvNDN3WFdhZTFkdTFJ?=
 =?utf-8?B?dVBNSGNVSzlBYWlDSGN2Q1U1cjBMdWp5a3lWWmZKdlByNlF6Y1llYnRpUVFF?=
 =?utf-8?B?aVV6eEtsc3dnMW9TUndwZWlMVXZYc2dkNXkrNTk1N0RLVHZ5R3hJVmNxa1Rq?=
 =?utf-8?B?TXNvWDJLRzJYTmZJRkRzQit0ZFdFNkR5eXhrcXh4ZE1tYlNYZC9XTGczZ2cv?=
 =?utf-8?B?RzNHVFNoZ3FjYjdQdjRKTk5UMzJrYm9WU3VqNGF1TmRyQlJIR1preG1IUDlH?=
 =?utf-8?B?VklxVEN2M1RqTFFMaU1rZ2c2ZXZIZEhBaGVBR2o4QmZyVnZmOWRNZnJVZTd3?=
 =?utf-8?B?OUdMSVNJaDgzc05Wd3A4VVJlcXFvTlNVZ2ZiUG9XRUxjZ29NY2V2R3AyWnNr?=
 =?utf-8?B?MFh1enk0Y0FXdjk0cWJLV00zc2p0TkxLeWZlbjNmL3dlOG9JN3RIUTlrODV2?=
 =?utf-8?B?Tjl6UzNXSEZXV1Rud2lUanp0UHhoNVRHK1h6SmtkZWNMazJiVlFzRzRoTHc1?=
 =?utf-8?B?MGFaR25RSTVveHRnRVB0ckdmTm5TZHVkYXdXOTE4Tk9TbWNMTWR3Kzg3akZT?=
 =?utf-8?B?cTQ4MGZ5V1h2bVBGZU4ybHpvSTNHT216VEFtdnl6bTFDcmQwV0VHV1JTZ1px?=
 =?utf-8?B?T3VZTUl6TlBNelo4VmFSVXBsdll1SlJpdTBCNlpURlBmTlBPRmxPOE9DODRo?=
 =?utf-8?B?QTJ4S0JjMGpOV1RtUWNBb010bm11bnp2Q3c1VVhYUnF4bVFqUE9JVW5CYzFQ?=
 =?utf-8?B?RHBQT09qTzQ2Nk13dC95NlFDY3FsYkZxWGk4VFFiQTRGdktmZXBiZFRyby9O?=
 =?utf-8?B?WFpEZTY4RmVGOUEyYXlpRm53Y0NCSTdWL0tPazVqTW5JOWVqWEw0MVU3OExm?=
 =?utf-8?B?Ti9KRDNqOGdKUzNJdEJIdVdhZ21ITi9IaFlpTHlKYjdWdzF1ejgvVG14UmFT?=
 =?utf-8?B?ZkIybzFCZEhnQ1FMK2Q1SE1lTjJnRFBzMElNWVJNZEl6SkZvNGJDajhtT3Az?=
 =?utf-8?B?VTgrUytURTFkL0pydUZoa0NzeitmU1p3bWozL2t3ZXorWEVISnlsUjhiZi9G?=
 =?utf-8?B?RXppNzNqT0MvTlVUaW4yNi8xa0M2cENhZmJzL1UrMFpBbWpnQmFScE02OUx1?=
 =?utf-8?B?cHJiRXdoOElZeGJRckFJeW5OcUZxc0N6dldPbHpmUUNQTklzV09RWHFiUVVZ?=
 =?utf-8?B?ajJXOFJiWS9jaG5ORVV5eWNpbkI3NTF5VktnNXliNTVaWTdKNERFb0daRkx6?=
 =?utf-8?B?ZnVkM0ptc0hlalFsSmVSazhsTGNtUEkwOW8zT2dKc0dWU25hUkRHQ0dzaGxF?=
 =?utf-8?B?V0t5MklVRGROMy9NK21HV1dZWm9MZ2ZpYlB3bXhHcmZiVWY1YTBGZ3NkVnJr?=
 =?utf-8?B?WjlacWtnRWRJTWt0cHgxRnlna0pPWDUvUXV0bml3YVVEdFdxU201R3UyaklG?=
 =?utf-8?B?eDZPSTFYdUp3a1loVVlvZjJhVXBuMkNuRmV3Y01mRnRJUitsdExnanBrMFhl?=
 =?utf-8?B?Yit3elR0QlkvMStvMHNjbnc5dGEvbVlzajBHaWFFeUY3cnB1cU81SkJtOWNn?=
 =?utf-8?B?cHV1amZ0S0djSHRDUFlQclFFdEhRV0FyRC96R1pRdmZVRWd5OXNSTlhSdzRo?=
 =?utf-8?B?T0ozemdMQ0M1M3YzSGtXb0lNTVFuakl1cHVrSU9NQ1l0YzZ4N3V0b2NGT3pL?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE41B7E2C4990E47BB34A26FC5D39F01@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d60QGkd/0bF8ZHhhG+RPoM32XBzfO9ozTgU3pFboIn22rN0gEWKRfrpR0vikL2RSrCUiECZy6jHgNj9egKQ9cf+H1sOSFQhos0Yp35Msrtevj6evwqDWljYNIkoRfQaRHhb11RAC3nAlTLSCzH27xZfF+ukZZ+9Ur8daXr19GWiv0t3DcqEKZShugPtZ84igVRhKClOwXUZgpknNjXjbioz6LLS8T20Pma7U726XSQEvOT6Jyai6oDwrK3ocSYRVytrSKAakmNQwnHI8xFR0n+OiQ87FU72EdAwFTwhKWSm8nZLnD3ImXh2y2cLS4XhZN7E7XlvxWce10MQgZtfB+rCIxj3iM2oYPZgr626k09Gqzr6NcobqMd/GpONuJLpk2AlDL/p7AAEaoY0Mu3QungROs742BnDza6liPpK7GjDUsue3SRNYUw23p1OnUcBdazF1UxS4jO187t0E7RjrvHJ5qBEN9mxLPtIDETSj2d+XX48EB7zuZlhX4Mex5OkGaIuNoll6tVJrpdVo4FChsvJj4utq65SCpWR0poqg9kDBPoZUqFBhvtItpzCnky6bLwg2Vp85pN4Ik+F0b68PHT/BEk9I8g0/bD+HXwkgMEcq9I0gAzhAgyQIgwaCnFBn
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b14285-a537-4af3-5197-08dc7e27c9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2024 08:34:13.6384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x60wDbLbUhF5rfUx7M4jZNrke2r8aJOaiVYf7Duiu30DwiLGpJ4xrbtHSxGwuT/3UAqG6MkwwRANPy7tVzAjKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6956

DQpIb2xkIG9uLCBIb2xkIG9uDQoNCkl0IHNlZW1zIHRoZSBtYW51YWwgaXMgY29ycmVjdCwgdGhl
IHVzYWdlIGlzIHdyb25nLg0KQ3VycmVudCBjb2RlIG9ubHkgaW1wbGVtZW50cyBCQVNFX09QVElP
TlMoKSBhbmQgQ1JFQVRFX09QVElPTlMoKSBmb3IgY3JlYXRlLWRldmljZSBjb21tYW5kLg0KUkVD
T05GSUdfT1BUSU9OUygpIGFuZCBaT05FX09QVElPTlMoKSBoYXZlIG5vdCBzdXBwb3J0ZWQgeWV0
Lg0KDQogICA3MSAjZGVmaW5lIEJBU0VfT1BUSU9OUygpIFwNCiAgIDcyIE9QVF9TVFJJTkcoJ3In
LCAicmVnaW9uIiwgJnBhcmFtLnJlZ2lvbiwgInJlZ2lvbi1pZCIsICJmaWx0ZXIgYnkgcmVnaW9u
IiksIFwNCiAgIDczIE9QVF9CT09MRUFOKCd1JywgImh1bWFuIiwgJnBhcmFtLmh1bWFuLCAidXNl
IGh1bWFuIGZyaWVuZGx5IG51bWJlciBmb3JtYXRzIiksIFwNCiAgIDc0IE9QVF9CT09MRUFOKCd2
JywgInZlcmJvc2UiLCAmcGFyYW0udmVyYm9zZSwgImVtaXQgbW9yZSBkZWJ1ZyBtZXNzYWdlcyIp
DQogICA3NQ0KICAgNzYgI2RlZmluZSBSRUNPTkZJR19PUFRJT05TKCkgXA0KICAgNzcgT1BUX1NU
UklORygnbScsICJtb2RlIiwgJnBhcmFtLm1vZGUsICJtb2RlIiwgIm1vZGUgdG8gc3dpdGNoIHRo
ZSBkZXZpY2UgdG8iKSwgXA0KICAgNzggT1BUX0JPT0xFQU4oJ04nLCAibm8tb25saW5lIiwgJnBh
cmFtLm5vX29ubGluZSwgXA0KICAgNzkgICAgICAgICAiZG9uJ3QgYXV0by1vbmxpbmUgbWVtb3J5
IHNlY3Rpb25zIiksIFwNCiAgIDgwIE9QVF9CT09MRUFOKCdmJywgImZvcmNlIiwgJnBhcmFtLmZv
cmNlLCBcDQogICA4MSAgICAgICAgICAgICAgICAgImF0dGVtcHQgdG8gb2ZmbGluZSBtZW1vcnkg
c2VjdGlvbnMgYmVmb3JlIHJlY29uZmlndXJhdGlvbiIpLCBcDQogICA4MiBPUFRfQk9PTEVBTign
QycsICJjaGVjay1jb25maWciLCAmcGFyYW0uY2hlY2tfY29uZmlnLCBcDQogICA4MyAgICAgICAg
ICAgICAgICAgInVzZSBjb25maWcgZmlsZXMgdG8gZGV0ZXJtaW5lIHBhcmFtZXRlcnMgZm9yIHRo
ZSBvcGVyYXRpb24iKQ0KICAgODQNCiAgIDg1ICNkZWZpbmUgQ1JFQVRFX09QVElPTlMoKSBcDQog
ICA4NiBPUFRfU1RSSU5HKCdzJywgInNpemUiLCAmcGFyYW0uc2l6ZSwgInNpemUiLCAic2l6ZSB0
byBzd2l0Y2ggdGhlIGRldmljZSB0byIpLCBcDQogICA4NyBPUFRfU1RSSU5HKCdhJywgImFsaWdu
IiwgJnBhcmFtLmFsaWduLCAiYWxpZ24iLCAiYWxpZ25tZW50IHRvIHN3aXRjaCB0aGUgZGV2aWNl
IHRvIiksIFwNCiAgIDg4IE9QVF9TVFJJTkcoJ1wwJywgImlucHV0IiwgJnBhcmFtLmlucHV0LCAi
aW5wdXQiLCAiaW5wdXQgZGV2aWNlIEpTT04gZmlsZSIpDQogICA4OQ0KICAgOTAgI2RlZmluZSBE
RVNUUk9ZX09QVElPTlMoKSBcDQogICA5MSBPUFRfQk9PTEVBTignZicsICJmb3JjZSIsICZwYXJh
bS5mb3JjZSwgXA0KICAgOTIgICAgICAgICAgICAgICAgICJhdHRlbXB0IHRvIGRpc2FibGUgYmVm
b3JlIGRlc3Ryb3lpbmcgZGV2aWNlIikNCiAgIDkzDQogICA5NCAjZGVmaW5lIFpPTkVfT1BUSU9O
UygpIFwNCiAgIDk1IE9QVF9CT09MRUFOKCdcMCcsICJuby1tb3ZhYmxlIiwgJnBhcmFtLm5vX21v
dmFibGUsIFwNCiAgIDk2ICAgICAgICAgICAgICAgICAib25saW5lIG1lbW9yeSBpbiBaT05FX05P
Uk1BTCIpDQoNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KICB1
c2FnZTogZGF4Y3RsIGNyZWF0ZS1kZXZpY2UgWzxvcHRpb25zPl0NCg0KICAgICAtciwgLS1yZWdp
b24gPHJlZ2lvbi1pZD4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpbHRlciBieSByZWdp
b24NCiAgICAgLXUsIC0taHVtYW4gICAgICAgICAgIHVzZSBodW1hbiBmcmllbmRseSBudW1iZXIg
Zm9ybWF0cw0KICAgICAtdiwgLS12ZXJib3NlICAgICAgICAgZW1pdCBtb3JlIGRlYnVnIG1lc3Nh
Z2VzDQogICAgIC1zLCAtLXNpemUgPHNpemU+ICAgICBzaXplIHRvIHN3aXRjaCB0aGUgZGV2aWNl
IHRvDQogICAgIC1hLCAtLWFsaWduIDxhbGlnbj4gICBhbGlnbm1lbnQgdG8gc3dpdGNoIHRoZSBk
ZXZpY2UgdG8NCiAgICAgICAgIC0taW5wdXQgPGlucHV0PiAgIGlucHV0IGRldmljZSBKU09OIGZp
bGUNCiAgICAgLW0sIC0tbW9kZSA8bW9kZT4gICAgIG1vZGUgdG8gc3dpdGNoIHRoZSBkZXZpY2Ug
dG8NCiAgICAgLU4sIC0tbm8tb25saW5lICAgICAgIGRvbid0IGF1dG8tb25saW5lIG1lbW9yeSBz
ZWN0aW9ucw0KICAgICAtZiwgLS1mb3JjZSAgICAgICAgICAgYXR0ZW1wdCB0byBvZmZsaW5lIG1l
bW9yeSBzZWN0aW9ucyBiZWZvcmUgcmVjb25maWd1cmF0aW9uDQogICAgIC1DLCAtLWNoZWNrLWNv
bmZpZyAgICB1c2UgY29uZmlnIGZpbGVzIHRvIGRldGVybWluZSBwYXJhbWV0ZXJzIGZvciB0aGUg
b3BlcmF0aW9uDQogICAgICAgICAtLW5vLW1vdmFibGUgICAgICBvbmxpbmUgbWVtb3J5IGluIFpP
TkVfTk9STUFMDQoNCg0KDQpPbiAyNy8wNS8yMDI0IDE0OjQ1LCBMaSBaaGlqaWFuIHdyb3RlOg0K
PiBjcmVhdGUtZGV2aWNlIGNhbiBhY2NlcHQgbW9yZSBvcHRpb25zLCBzZWUgYGRheGN0bCBoZWxw
IGNyZWF0ZS1kZXZpY2VgDQo+IG9yIHRoZSBjb2RlIGZvciBtb3JlIGRldGFpbHMuDQo+IA0KPiBS
ZXVzZSByZWNvbmZpZ3VyZSBvcHRpb25zIGZyb20gcmVjb25maWd1cmUtZGV2aWNlIGFuZCBpbmNs
dWRlIG1vdmFibGUNCj4gb3B0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4g
PGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4gLS0tDQo+ICAgRG9jdW1lbnRhdGlvbi9kYXhjdGwv
ZGF4Y3RsLWNyZWF0ZS1kZXZpY2UudHh0IHwgIDIgKw0KPiAgIC4uLi9kYXhjdGwvZGF4Y3RsLXJl
Y29uZmlndXJlLWRldmljZS50eHQgICAgICB8IDM5ICstLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIERv
Y3VtZW50YXRpb24vZGF4Y3RsL3JlY29uZmlndXJlLW9wdGlvbnMudHh0ICB8IDQwICsrKysrKysr
KysrKysrKysrKysNCj4gICAzIGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyksIDM4IGRl
bGV0aW9ucygtKQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RheGN0bC9y
ZWNvbmZpZ3VyZS1vcHRpb25zLnR4dA0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
ZGF4Y3RsL2RheGN0bC1jcmVhdGUtZGV2aWNlLnR4dCBiL0RvY3VtZW50YXRpb24vZGF4Y3RsL2Rh
eGN0bC1jcmVhdGUtZGV2aWNlLnR4dA0KPiBpbmRleCAwNWY0ZGJkOWQ2MWMuLmFkNmYxNzdmYTNi
OSAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kYXhjdGwvZGF4Y3RsLWNyZWF0ZS1kZXZp
Y2UudHh0DQo+ICsrKyBiL0RvY3VtZW50YXRpb24vZGF4Y3RsL2RheGN0bC1jcmVhdGUtZGV2aWNl
LnR4dA0KPiBAQCAtNzIsNiArNzIsOCBAQCBFRkkgbWVtb3J5IG1hcCB3aXRoIEVGSV9NRU1PUllf
U1AuIFRoZSByZXN1bHRhbnQgcmFuZ2VzIG1lYW4gdGhhdCBpdCdzDQo+ICAgT1BUSU9OUw0KPiAg
IC0tLS0tLS0NCj4gICBpbmNsdWRlOjpyZWdpb24tb3B0aW9uLnR4dFtdDQo+ICtpbmNsdWRlOjpt
b3ZhYmxlLW9wdGlvbnMudHh0W10NCj4gK2luY2x1ZGU6OnJlY29uZmlndXJlLW9wdGlvbnMudHh0
W10NCj4gICANCj4gICAtczo6DQo+ICAgLS1zaXplPTo6DQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL2RheGN0bC9kYXhjdGwtcmVjb25maWd1cmUtZGV2aWNlLnR4dCBiL0RvY3VtZW50YXRp
b24vZGF4Y3RsL2RheGN0bC1yZWNvbmZpZ3VyZS1kZXZpY2UudHh0DQo+IGluZGV4IDA5NjkxZDIw
MjUxNC4uMzJmMjhhNWI4ZTgyIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RheGN0bC9k
YXhjdGwtcmVjb25maWd1cmUtZGV2aWNlLnR4dA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RheGN0
bC9kYXhjdGwtcmVjb25maWd1cmUtZGV2aWNlLnR4dA0KPiBAQCAtMTk2LDQ3ICsxOTYsMTAgQEAg
aW5jbHVkZTo6cmVnaW9uLW9wdGlvbi50eHRbXQ0KPiAgIA0KPiAgIAlUaGlzIG9wdGlvbiBpcyBt
dXR1YWxseSBleGNsdXNpdmUgd2l0aCAtbSBvciAtLW1vZGUuDQo+ICAgDQo+IC0tbTo6DQo+IC0t
LW1vZGU9OjoNCj4gLQlTcGVjaWZ5IHRoZSBtb2RlIHRvIHdoaWNoIHRoZSBkYXggZGV2aWNlKHMp
IHNob3VsZCBiZSByZWNvbmZpZ3VyZWQuDQo+IC0JLSAic3lzdGVtLXJhbSI6IGhvdHBsdWcgdGhl
IGRldmljZSBpbnRvIHN5c3RlbSBtZW1vcnkuDQo+IC0NCj4gLQktICJkZXZkYXgiOiBzd2l0Y2gg
dG8gdGhlIG5vcm1hbCAiZGV2aWNlIGRheCIgbW9kZS4gVGhpcyByZXF1aXJlcyB0aGUNCj4gLQkg
IGtlcm5lbCB0byBzdXBwb3J0IGhvdC11bnBsdWdnaW5nICdrbWVtJyBiYXNlZCBtZW1vcnkuIElm
IHRoaXMgaXMgbm90DQo+IC0JICBhdmFpbGFibGUsIGEgcmVib290IGlzIHRoZSBvbmx5IHdheSB0
byBzd2l0Y2ggYmFjayB0byAnZGV2ZGF4JyBtb2RlLg0KPiAtDQo+IC0tTjo6DQo+IC0tLW5vLW9u
bGluZTo6DQo+IC0JQnkgZGVmYXVsdCwgbWVtb3J5IHNlY3Rpb25zIHByb3ZpZGVkIGJ5IHN5c3Rl
bS1yYW0gZGV2aWNlcyB3aWxsIGJlDQo+IC0JYnJvdWdodCBvbmxpbmUgYXV0b21hdGljYWxseSBh
bmQgaW1tZWRpYXRlbHkgd2l0aCB0aGUgJ29ubGluZV9tb3ZhYmxlJw0KPiAtCXBvbGljeS4gVXNl
IHRoaXMgb3B0aW9uIHRvIGRpc2FibGUgdGhlIGF1dG9tYXRpYyBvbmxpbmluZyBiZWhhdmlvci4N
Cj4gLQ0KPiAtLUM6Og0KPiAtLS1jaGVjay1jb25maWc6Og0KPiAtCUdldCByZWNvbmZpZ3VyYXRp
b24gcGFyYW1ldGVycyBmcm9tIHRoZSBnbG9iYWwgZGF4Y3RsIGNvbmZpZyBmaWxlLg0KPiAtCVRo
aXMgaXMgdHlwaWNhbGx5IHVzZWQgd2hlbiBkYXhjdGwtcmVjb25maWd1cmUtZGV2aWNlIGlzIGNh
bGxlZCBmcm9tDQo+IC0JYSBzeXN0ZW1kLXVkZXZkIGRldmljZSB1bml0IGZpbGUuIFRoZSByZWNv
bmZpZ3VyYXRpb24gcHJvY2VlZHMgb25seQ0KPiAtCWlmIHRoZSBtYXRjaCBwYXJhbWV0ZXJzIGlu
IGEgJ3JlY29uZmlndXJlLWRldmljZScgc2VjdGlvbiBvZiB0aGUNCj4gLQljb25maWcgbWF0Y2gg
dGhlIGRheCBkZXZpY2Ugc3BlY2lmaWVkIG9uIHRoZSBjb21tYW5kIGxpbmUuIFNlZSB0aGUNCj4g
LQknUEVSU0lTVEVOVCBSRUNPTkZJR1VSQVRJT04nIHNlY3Rpb24gZm9yIG1vcmUgZGV0YWlscy4N
Cj4gK2luY2x1ZGU6OnJlY29uZmlndXJlLW9wdGlvbnMudHh0W10NCj4gICANCj4gICBpbmNsdWRl
Ojptb3ZhYmxlLW9wdGlvbnMudHh0W10NCj4gICANCj4gLS1mOjoNCj4gLS0tZm9yY2U6Og0KPiAt
CS0gV2hlbiBjb252ZXJ0aW5nIGZyb20gInN5c3RlbS1yYW0iIG1vZGUgdG8gImRldmRheCIsIGl0
IGlzIGV4cGVjdGVkDQo+IC0JdGhhdCBhbGwgdGhlIG1lbW9yeSBzZWN0aW9ucyBhcmUgZmlyc3Qg
bWFkZSBvZmZsaW5lLiBCeSBkZWZhdWx0LA0KPiAtCWRheGN0bCB3b24ndCB0b3VjaCBvbmxpbmUg
bWVtb3J5LiBIb3dldmVyIHdpdGggdGhpcyBvcHRpb24sIGF0dGVtcHQNCj4gLQl0byBvZmZsaW5l
IHRoZSBtZW1vcnkgb24gdGhlIE5VTUEgbm9kZSBhc3NvY2lhdGVkIHdpdGggdGhlIGRheCBkZXZp
Y2UNCj4gLQliZWZvcmUgY29udmVydGluZyBpdCBiYWNrIHRvICJkZXZkYXgiIG1vZGUuDQo+IC0N
Cj4gLQktIEFkZGl0aW9uYWxseSwgaWYgYSBrZXJuZWwgcG9saWN5IHRvIGF1dG8tb25saW5lIGJs
b2NrcyBpcyBkZXRlY3RlZCwNCj4gLQlyZWNvbmZpZ3VyYXRpb24gdG8gc3lzdGVtLXJhbSBmYWls
cy4gV2l0aCB0aGlzIG9wdGlvbiwgdGhlIGZhaWx1cmUgY2FuDQo+IC0JYmUgb3ZlcnJpZGRlbiB0
byBhbGxvdyByZWNvbmZpZ3VyYXRpb24gcmVnYXJkbGVzcyBvZiBrZXJuZWwgcG9saWN5Lg0KPiAt
CURvaW5nIHRoaXMgbWF5IHJlc3VsdCBpbiBhIHN1Y2Nlc3NmdWwgcmVjb25maWd1cmF0aW9uLCBi
dXQgaXQgbWF5DQo+IC0Jbm90IGJlIHBvc3NpYmxlIHRvIHN1YnNlcXVlbnRseSBvZmZsaW5lIHRo
ZSBtZW1vcnkgd2l0aG91dCBhIHJlYm9vdC4NCj4gLQ0KPiAtDQo+ICAgaW5jbHVkZTo6aHVtYW4t
b3B0aW9uLnR4dFtdDQo+ICAgDQo+ICAgaW5jbHVkZTo6dmVyYm9zZS1vcHRpb24udHh0W10NCj4g
ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGF4Y3RsL3JlY29uZmlndXJlLW9wdGlvbnMudHh0
IGIvRG9jdW1lbnRhdGlvbi9kYXhjdGwvcmVjb25maWd1cmUtb3B0aW9ucy50eHQNCj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi5mMTc0NzI5ZWIwMjMNCj4gLS0t
IC9kZXYvbnVsbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RheGN0bC9yZWNvbmZpZ3VyZS1vcHRp
b25zLnR4dA0KPiBAQCAtMCwwICsxLDQwIEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMA0KPiArDQo+ICsNCj4gKy1tOjoNCj4gKy0tbW9kZT06Og0KPiArCVNwZWNpZnkg
dGhlIG1vZGUgdG8gd2hpY2ggdGhlIGRheCBkZXZpY2Uocykgc2hvdWxkIGJlIHJlY29uZmlndXJl
ZC4NCj4gKwktICJzeXN0ZW0tcmFtIjogaG90cGx1ZyB0aGUgZGV2aWNlIGludG8gc3lzdGVtIG1l
bW9yeS4NCj4gKw0KPiArCS0gImRldmRheCI6IHN3aXRjaCB0byB0aGUgbm9ybWFsICJkZXZpY2Ug
ZGF4IiBtb2RlLiBUaGlzIHJlcXVpcmVzIHRoZQ0KPiArCSAga2VybmVsIHRvIHN1cHBvcnQgaG90
LXVucGx1Z2dpbmcgJ2ttZW0nIGJhc2VkIG1lbW9yeS4gSWYgdGhpcyBpcyBub3QNCj4gKwkgIGF2
YWlsYWJsZSwgYSByZWJvb3QgaXMgdGhlIG9ubHkgd2F5IHRvIHN3aXRjaCBiYWNrIHRvICdkZXZk
YXgnIG1vZGUuDQo+ICsNCj4gKy1OOjoNCj4gKy0tbm8tb25saW5lOjoNCj4gKwlCeSBkZWZhdWx0
LCBtZW1vcnkgc2VjdGlvbnMgcHJvdmlkZWQgYnkgc3lzdGVtLXJhbSBkZXZpY2VzIHdpbGwgYmUN
Cj4gKwlicm91Z2h0IG9ubGluZSBhdXRvbWF0aWNhbGx5IGFuZCBpbW1lZGlhdGVseSB3aXRoIHRo
ZSAnb25saW5lX21vdmFibGUnDQo+ICsJcG9saWN5LiBVc2UgdGhpcyBvcHRpb24gdG8gZGlzYWJs
ZSB0aGUgYXV0b21hdGljIG9ubGluaW5nIGJlaGF2aW9yLg0KPiArDQo+ICstQzo6DQo+ICstLWNo
ZWNrLWNvbmZpZzo6DQo+ICsJR2V0IHJlY29uZmlndXJhdGlvbiBwYXJhbWV0ZXJzIGZyb20gdGhl
IGdsb2JhbCBkYXhjdGwgY29uZmlnIGZpbGUuDQo+ICsJVGhpcyBpcyB0eXBpY2FsbHkgdXNlZCB3
aGVuIGRheGN0bC1yZWNvbmZpZ3VyZS1kZXZpY2UgaXMgY2FsbGVkIGZyb20NCj4gKwlhIHN5c3Rl
bWQtdWRldmQgZGV2aWNlIHVuaXQgZmlsZS4gVGhlIHJlY29uZmlndXJhdGlvbiBwcm9jZWVkcyBv
bmx5DQo+ICsJaWYgdGhlIG1hdGNoIHBhcmFtZXRlcnMgaW4gYSAncmVjb25maWd1cmUtZGV2aWNl
JyBzZWN0aW9uIG9mIHRoZQ0KPiArCWNvbmZpZyBtYXRjaCB0aGUgZGF4IGRldmljZSBzcGVjaWZp
ZWQgb24gdGhlIGNvbW1hbmQgbGluZS4gU2VlIHRoZQ0KPiArCSdQRVJTSVNURU5UIFJFQ09ORklH
VVJBVElPTicgc2VjdGlvbiBmb3IgbW9yZSBkZXRhaWxzLg0KPiArDQo+ICstZjo6DQo+ICstLWZv
cmNlOjoNCj4gKwktIFdoZW4gY29udmVydGluZyBmcm9tICJzeXN0ZW0tcmFtIiBtb2RlIHRvICJk
ZXZkYXgiLCBpdCBpcyBleHBlY3RlZA0KPiArCXRoYXQgYWxsIHRoZSBtZW1vcnkgc2VjdGlvbnMg
YXJlIGZpcnN0IG1hZGUgb2ZmbGluZS4gQnkgZGVmYXVsdCwNCj4gKwlkYXhjdGwgd29uJ3QgdG91
Y2ggb25saW5lIG1lbW9yeS4gSG93ZXZlciB3aXRoIHRoaXMgb3B0aW9uLCBhdHRlbXB0DQo+ICsJ
dG8gb2ZmbGluZSB0aGUgbWVtb3J5IG9uIHRoZSBOVU1BIG5vZGUgYXNzb2NpYXRlZCB3aXRoIHRo
ZSBkYXggZGV2aWNlDQo+ICsJYmVmb3JlIGNvbnZlcnRpbmcgaXQgYmFjayB0byAiZGV2ZGF4IiBt
b2RlLg0KPiArDQo+ICsJLSBBZGRpdGlvbmFsbHksIGlmIGEga2VybmVsIHBvbGljeSB0byBhdXRv
LW9ubGluZSBibG9ja3MgaXMgZGV0ZWN0ZWQsDQo+ICsJcmVjb25maWd1cmF0aW9uIHRvIHN5c3Rl
bS1yYW0gZmFpbHMuIFdpdGggdGhpcyBvcHRpb24sIHRoZSBmYWlsdXJlIGNhbg0KPiArCWJlIG92
ZXJyaWRkZW4gdG8gYWxsb3cgcmVjb25maWd1cmF0aW9uIHJlZ2FyZGxlc3Mgb2Yga2VybmVsIHBv
bGljeS4NCj4gKwlEb2luZyB0aGlzIG1heSByZXN1bHQgaW4gYSBzdWNjZXNzZnVsIHJlY29uZmln
dXJhdGlvbiwgYnV0IGl0IG1heQ0KPiArCW5vdCBiZSBwb3NzaWJsZSB0byBzdWJzZXF1ZW50bHkg
b2ZmbGluZSB0aGUgbWVtb3J5IHdpdGhvdXQgYSByZWJvb3Qu

