Return-Path: <nvdimm+bounces-5224-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8815F636278
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Nov 2022 15:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7021D1C20939
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Nov 2022 14:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A0A2591;
	Wed, 23 Nov 2022 14:54:17 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904F57E
	for <nvdimm@lists.linux.dev>; Wed, 23 Nov 2022 14:54:15 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANEahAB029309;
	Wed, 23 Nov 2022 14:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=gjywfSLx66XudyOcfC0Q+7A2zHWwhQJG44Cp+hcysn8=;
 b=m47cAIH3nr+Rgd2r5NHCCV9sZ2yGZuH6HUmXogawtN1HQ4MfrLZS31K8bz31Es/5HVLo
 VC8iELP5qFW27DRMXcM/56IHU3+virsYCbZljE0nbKOcdJAVQJAV/ylU3CV/R74dC0gb
 lgwyZ/S9MFthYcD+BYBxWjHc3vAGpC2a3J3iyYnD4kNb0l5PzrW7YZuDM1A+BdXudnmG
 fIb5gvm5g1HMk0UbscXiCbqkr+aAxmkZ2dtsIWgnYhoViZnWbKJWYNttlku3fQZAocGH
 oIUco2rWU7BuiwOA3UnMFKM81WOgsdc5E2jXY/GjC1norKnEV3qLrtUXmfJcnNlHZi5L BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffrp7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Nov 2022 14:54:00 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANEbVSP033847;
	Wed, 23 Nov 2022 14:54:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffrp6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Nov 2022 14:54:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANEop97010439;
	Wed, 23 Nov 2022 14:53:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma03ams.nl.ibm.com with ESMTP id 3kxps8wvyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Nov 2022 14:53:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANErtJ63670636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Nov 2022 14:53:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AA274C044;
	Wed, 23 Nov 2022 14:53:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E05ED4C046;
	Wed, 23 Nov 2022 14:53:52 +0000 (GMT)
Received: from tarunpc.in.ibm.com (unknown [9.199.157.25])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Nov 2022 14:53:52 +0000 (GMT)
Date: Wed, 23 Nov 2022 20:23:49 +0530
From: Tarun Sahu <tsahu@linux.ibm.com>
To: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: oohall@gmail.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, aneesh.kumar@linux.ibm.com,
        nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libnvdimm/of_pmem: Fix memory leak in
 of_pmem_region_probe()
Message-ID: <20221123145349.yrjo53cz7ez5i36o@tarunpc.in.ibm.com>
References: <20221123134527.119441-1-xiujianfeng@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123134527.119441-1-xiujianfeng@huawei.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VwnmYOhzArG9qUxHupJYkXv_WUak0ZC6
X-Proofpoint-GUID: kXHQCqt2-hpkSZJmV9_bdXiANo2QQ4bJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_08,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 clxscore=1011 lowpriorityscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230108

Hi,
Thanks for resolving it.

All looks good. Except a thing, there is no check for return status of
ksrdup too. that can also be part of this patch.

On Nov 23 2022, Xiu Jianfeng wrote:
> After changes in commit 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique
> name for bus provider"), @priv->bus_desc.provider_name is no longer a
> const string, but a dynamic string allocated by kstrdup(), it should be
> freed on the error path, and when driver is removed.
> 
> Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  drivers/nvdimm/of_pmem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 10dbdcdfb9ce..1292ffca7b2e 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -36,6 +36,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>  
>  	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
>  	if (!bus) {
> +		kfree(priv->bus_desc.provider_name);
>  		kfree(priv);
>  		return -ENODEV;
>  	}
> @@ -83,6 +84,7 @@ static int of_pmem_region_remove(struct platform_device *pdev)
>  	struct of_pmem_private *priv = platform_get_drvdata(pdev);
>  
>  	nvdimm_bus_unregister(priv->bus);
> +	kfree(priv->bus_desc.provider_name);
>  	kfree(priv);
>  
>  	return 0;
> -- 
> 2.17.1
> 

