Return-Path: <nvdimm+bounces-6071-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 785DF70C24A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 May 2023 17:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3375428109B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 May 2023 15:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07ADF14AA4;
	Mon, 22 May 2023 15:22:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E114A9C
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684768968; x=1716304968;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B+VCFjsrJW/lh7B61VjWVRHmyHm6MpEB6o9V7PhypQQ=;
  b=jjEyX5oWuigriSSKx+p09Jlnm3ncVZb1U6SYicRkY1SW3zRSAQ+a7o+N
   iUgGg7GuOrzNyEqXZyvBLT9X/9qTRojlm9VxwG5UZefbYQGnFdj1fG28K
   bvhH2+9t+8ILXXqYmEnSM39dhY5yq5dMh1vqHMBLUyNyaslsnEM+ZAN8A
   jWGKGSA+lBDc8+8nAf4TIdQ2jCqr+ummft7l2ReeEWU/7Gd2yszmBSfgC
   B1Rk8aOBdqStLNSD9HpZhvsIVJDUv65my+JzXXojAWncwd29GtaE3pP6Q
   wz/OhKHnxol+WXs4YLyvqesIhHb+dWZsDlIvQu8V6uuz+EGYlGftGjoDU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381182209"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381182209"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703554971"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703554971"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.173.219]) ([10.213.173.219])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:45 -0700
Message-ID: <67717c6d-de28-795a-74f8-e1fed71e627a@intel.com>
Date: Mon, 22 May 2023 08:22:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] libnvdimm: mark 'security_show' static again
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Hans de Goede <hdegoede@redhat.com>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20230516201415.556858-1-arnd@kernel.org>
 <20230516201415.556858-3-arnd@kernel.org>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230516201415.556858-3-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/16/23 1:14 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The security_show() function was made global and __weak at some
> point to allow overriding it. The override was removed later, but
> it remains global, which causes a warning about the missing
> declaration:
> 
> drivers/nvdimm/dimm_devs.c:352:9: error: no previous prototype for 'security_show'
> 
> This is also not an appropriate name for a global symbol in the
> kernel, so just make it static again.
> 
> Fixes: 15a8348707ff ("libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST flag")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/nvdimm/dimm_devs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 957f7c3d17ba..10c3cb6a574a 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -349,7 +349,7 @@ static ssize_t available_slots_show(struct device *dev,
>   }
>   static DEVICE_ATTR_RO(available_slots);
>   
> -ssize_t security_show(struct device *dev,
> +static ssize_t security_show(struct device *dev,
>   		struct device_attribute *attr, char *buf)
>   {
>   	struct nvdimm *nvdimm = to_nvdimm(dev);

