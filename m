Return-Path: <nvdimm+bounces-6404-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAFB760955
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Jul 2023 07:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 693D02817EF
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Jul 2023 05:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C114848C;
	Tue, 25 Jul 2023 05:34:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB1538F
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 05:34:33 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="113462191"
X-IronPort-AV: E=Sophos;i="6.01,229,1684767600"; 
   d="scan'208";a="113462191"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 14:33:22 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 708EBDAE10
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 14:33:20 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9EC92D5E93
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 14:33:19 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 1B0BB200501A4
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 14:33:19 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 829531A0006;
	Tue, 25 Jul 2023 13:33:18 +0800 (CST)
Message-ID: <32cb262a-8ae6-60ba-2032-f02973f44a1e@fujitsu.com>
Date: Tue, 25 Jul 2023 13:33:18 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] nfit: remove redundant list_for_each_entry
To: Alison Schofield <alison.schofield@intel.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, lenb@kernel.org
References: <20230719080526.2436951-1-ruansy.fnst@fujitsu.com>
 <ZL7/mctQSQ7rtK3X@aschofie-mobl2>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <ZL7/mctQSQ7rtK3X@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27772.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27772.005
X-TMASE-Result: 10--9.638400-10.000000
X-TMASE-MatchedRID: GnNqJBi8oAePvrMjLFD6eC0UvD/exuSe2q80vLACqaeqvcIF1TcLYLBk
	jjdoOP1bzIVGiRcEkmlv6X20arg6Ogc/ZGDhY009v0DcGXX8NxV+tO36GYDlsrcIt210bWgIvwU
	evDt+uW5/XjpbSJS7a1Tdr6jAw79q7EfODkWa3rKeAiCmPx4NwFkMvWAuahr8AsMBg/gBdVHudj
	nWXAurTyAHAopEd76vSCFvCmrHwbZsH8NdYqTbnwFbVR12U3tBSTxjLVwsneMh5dLKIVvSMQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/7/25 6:47, Alison Schofield 写道:
> On Wed, Jul 19, 2023 at 04:05:26PM +0800, Shiyang Ruan wrote:
>> The first for_each only do acpi_nfit_init_ars() for NFIT_SPA_VOLATILE
>> and NFIT_SPA_PM, which can be moved to next one.
> 
> Can the result of nfit_spa_type(nfit_spa->spa) change as a result of
> the first switch statement? That would be a reason why they are separate.

nfit_spa_type() just gets the type of *spa by querying a type-uuid 
table.  Also, according to the code shown below, we can find that it 
doesn't change anything.

int nfit_spa_type(struct acpi_nfit_system_address *spa)
{
	guid_t guid;
	int i;

	import_guid(&guid, spa->range_guid);
	for (i = 0; i < NFIT_UUID_MAX; i++)
		if (guid_equal(to_nfit_uuid(i), &guid))
			return i;
	return -1;
}

--
Thanks,
Ruan.

> 
> Alison
> 
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>> ---
>>   drivers/acpi/nfit/core.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 07204d482968..4090a0a0505c 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -2971,14 +2971,6 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
>>   		case NFIT_SPA_VOLATILE:
>>   		case NFIT_SPA_PM:
>>   			acpi_nfit_init_ars(acpi_desc, nfit_spa);
>> -			break;
>> -		}
>> -	}
>> -
>> -	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
>> -		switch (nfit_spa_type(nfit_spa->spa)) {
>> -		case NFIT_SPA_VOLATILE:
>> -		case NFIT_SPA_PM:
>>   			/* register regions and kick off initial ARS run */
>>   			rc = ars_register(acpi_desc, nfit_spa);
>>   			if (rc)
>> -- 
>> 2.41.0
>>

