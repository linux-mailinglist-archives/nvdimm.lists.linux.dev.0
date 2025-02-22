Return-Path: <nvdimm+bounces-9974-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC08A4049E
	for <lists+linux-nvdimm@lfdr.de>; Sat, 22 Feb 2025 02:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABDFE426FA2
	for <lists+linux-nvdimm@lfdr.de>; Sat, 22 Feb 2025 01:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D6A15853B;
	Sat, 22 Feb 2025 01:16:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333D01EB36
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186964; cv=none; b=D/C2nHdfEZk0/okLcQSTRHlRymjgcGw5xXOLgJlVXgC2zWZiKXPR9t5lDyYmVJ2z7W9HqCPsEXJp5cODD2sTAV7pZdSyPnNk1LVyHGLRPCovRCIxGsUrh+vnXgDSXu9Yel+ZMZPYyygbfctT2TgghtYY1+3ub5f+TLJnGmWFHmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186964; c=relaxed/simple;
	bh=A9T6wbNvp4IdjzLFjPDRA4BmggDTqzIhlVDhgIPM7KE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FfZDI5F7R62W62TXSUwemBR3jWGJxL+qcdVYuN5JJNcP/KOUAk3cVqjX45Kde97/AJgB52sSV9Xo2Hq72HuNE0LMX9uIdd/OF/SPuH4F0BhWsHztl6ViQz1weP47QYnjG6vOdDQJGBl7CzZySUykj0qsxP4sJD2XRQQoSNRWsps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z08FN0vyNz4f3lVL
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3DB881A0E1F
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:15:59 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2BNJblnZD0iEg--.15749S3;
	Sat, 22 Feb 2025 09:15:58 +0800 (CST)
Subject: Re: [PATCH 06/12] badblocks: fix the using of MAX_BADBLOCKS
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-7-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d7ac0004-1387-d185-1c11-658c47f68c57@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:15:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-7-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2BNJblnZD0iEg--.15749S3
X-Coremail-Antispam: 1UD129KBjvJXoW7GFWUAw18Wr43Ww1DKrWrGrg_yoW8Jryrpw
	4qvwn8KrW0kr1xWa1DZ3WUtryrW3WxAr48Wa1Fkw18WFyxAw17tFykXF1Yqry0qF4fWr92
	qF1DuFyruayIk37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8Jr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU07PEDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

�� 2025/02/21 16:11, Zheng Qixing д��:
> From: Li Nan <linan122@huawei.com>
> 
> The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
> allowed to equal MAX_BADBLOCKS.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/block/badblocks.c b/block/badblocks.c
> index a953d2e9417f..87267bae6836 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -700,7 +700,7 @@ static bool can_front_overwrite(struct badblocks *bb, int prev,
>   			*extra = 2;
>   	}
>   
> -	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
> +	if ((bb->count + (*extra)) > MAX_BADBLOCKS)
>   		return false;
>   
>   	return true;
> @@ -1135,7 +1135,7 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>   		if ((BB_OFFSET(p[prev]) < bad.start) &&
>   		    (BB_END(p[prev]) > (bad.start + bad.len))) {
>   			/* Splitting */
> -			if ((bb->count + 1) < MAX_BADBLOCKS) {
> +			if ((bb->count + 1) <= MAX_BADBLOCKS) {
>   				len = front_splitting_clear(bb, prev, &bad);
>   				bb->count += 1;
>   				cleared++;
> 


