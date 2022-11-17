Return-Path: <nvdimm+bounces-5208-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA6262E7C4
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Nov 2022 23:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDF78280C43
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Nov 2022 22:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1D78F75;
	Thu, 17 Nov 2022 22:07:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF18F69
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 22:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722876; x=1700258876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2vk5hqafUlt/qnDpLdYQDe9Fb1Ls4KvewSFZqXZedP4=;
  b=OrIMezAUuub9Nbo9p2uJcUHjw6CDgz+kGfHEz616yWZs5Z1cqTipm9UR
   tWSr1r2G16TZllr138eN7qtELoLBZkNShMH6YW+9AaLamMHwgWGlw8H9d
   A+BdENKfhGiue0OPOu7wr7PAl91wUBHKnIq0jDM1kC5OdHa8CzwsrrpSO
   Vu0briI4ez5GlmWRRCjV/3R5e1BMsHH+hIjiZ4MbnTub8YODhU0+9P2iO
   0NnJS/dPIVdCmda2DUPuKQf1R/bRWXSMBTr4pHCk5YdLb4PvectJW2ybe
   l/W/j6rN+bAwGkDgfg/sVj/Z2CYgytPdK77F3Eue9RuU3Aa4Kiz40GwQE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339823524"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339823524"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:07:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="728996552"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="728996552"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.84.12])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:07:56 -0800
Date: Thu, 17 Nov 2022 14:07:54 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Alexander Motin <mav@ixsystems.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH] libndctl/msft: Improve "smart" state reporting
Message-ID: <Y3awuiWbbJFcqJdt@aschofie-mobl2>
References: <20221117210935.5717-1-mav@ixsystems.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117210935.5717-1-mav@ixsystems.com>

On Thu, Nov 17, 2022 at 04:09:36PM -0500, Alexander Motin wrote:
> Previous code reported "smart" state based on number of bits
> set in the module health field.  But actually any single bit
> set there already means critical failure.  Rework the logic
> according to specification, properly reporting non-critical
> state in case of warning threshold reached, critical in case
> of any module health bit set or error threshold reached and
> fatal if NVDIMM exhausted its life time.  In attempt to
> report the cause of failure in absence of better methods,
> report reached thresholds as more or less matching alarms.
> 
> While there clean up the code, making it more uniform with
> others and allowing more methods to be implemented later.

Hi Alexander,

Perhaps this would be better presented in 2 patches:
1)the cleanup and then 2) improvement of smart state reporting.

Alison

> 
> Signed-off-by: Alexander Motin <mav@ixsystems.com>
> ---
>  ndctl/lib/msft.c | 111 ++++++++++++++++++++++++++++++++---------------
>  ndctl/lib/msft.h |  13 ++----
>  2 files changed, 79 insertions(+), 45 deletions(-)
> 
> diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
> index 3112799..8f66c97 100644
> --- a/ndctl/lib/msft.c
> +++ b/ndctl/lib/msft.c
> @@ -2,6 +2,7 @@
>  // Copyright (C) 2016-2017 Dell, Inc.
>  // Copyright (C) 2016 Hewlett Packard Enterprise Development LP
>  // Copyright (C) 2016-2020, Intel Corporation.
> +/* Copyright (C) 2022 iXsystems, Inc. */
>  #include <stdlib.h>
>  #include <limits.h>
>  #include <util/log.h>
> @@ -12,12 +13,39 @@
>  #define CMD_MSFT(_c) ((_c)->msft)
>  #define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
>  
> +static const char *msft_cmd_desc(int fn)
> +{
> +	static const char * const descs[] = {
> +		[NDN_MSFT_CMD_CHEALTH] = "critical_health",
> +		[NDN_MSFT_CMD_NHEALTH] = "nvdimm_health",
> +		[NDN_MSFT_CMD_EHEALTH] = "es_health",
> +	};
> +	const char *desc;
> +
> +	if (fn >= (int) ARRAY_SIZE(descs))
> +		return "unknown";
> +	desc = descs[fn];
> +	if (!desc)
> +		return "unknown";
> +	return desc;
> +}
> +
> +static bool msft_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
> +{
> +	/* Handle this separately to support monitor mode */
> +	if (cmd == ND_CMD_SMART)
> +		return true;
> +
> +	return !!(dimm->cmd_mask & (1ULL << cmd));
> +}
> +
>  static u32 msft_get_firmware_status(struct ndctl_cmd *cmd)
>  {
>  	return cmd->msft->u.smart.status;
>  }
>  
> -static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +static struct ndctl_cmd *alloc_msft_cmd(struct ndctl_dimm *dimm,
> +		unsigned int func, size_t in_size, size_t out_size)
>  {
>  	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
>  	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> @@ -30,12 +58,12 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  		return NULL;
>  	}
>  
> -	if (test_dimm_dsm(dimm, NDN_MSFT_CMD_SMART) == DIMM_DSM_UNSUPPORTED) {
> +	if (test_dimm_dsm(dimm, func) == DIMM_DSM_UNSUPPORTED) {
>  		dbg(ctx, "unsupported function\n");
>  		return NULL;
>  	}
>  
> -	size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
> +	size = sizeof(*cmd) + sizeof(struct nd_cmd_pkg) + in_size + out_size;
>  	cmd = calloc(1, size);
>  	if (!cmd)
>  		return NULL;
> @@ -45,25 +73,30 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  	cmd->type = ND_CMD_CALL;
>  	cmd->size = size;
>  	cmd->status = 1;
> +	cmd->get_firmware_status = msft_get_firmware_status;
>  
>  	msft = CMD_MSFT(cmd);
>  	msft->gen.nd_family = NVDIMM_FAMILY_MSFT;
> -	msft->gen.nd_command = NDN_MSFT_CMD_SMART;
> +	msft->gen.nd_command = func;
>  	msft->gen.nd_fw_size = 0;
> -	msft->gen.nd_size_in = offsetof(struct ndn_msft_smart, status);
> -	msft->gen.nd_size_out = sizeof(msft->u.smart);
> +	msft->gen.nd_size_in = in_size;
> +	msft->gen.nd_size_out = out_size;
>  	msft->u.smart.status = 0;
> -	cmd->get_firmware_status = msft_get_firmware_status;
>  
>  	return cmd;
>  }
>  
> +static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +{
> +	return (alloc_msft_cmd(dimm, NDN_MSFT_CMD_NHEALTH,
> +			0, sizeof(struct ndn_msft_smart)));
> +}
> +
>  static int msft_smart_valid(struct ndctl_cmd *cmd)
>  {
>  	if (cmd->type != ND_CMD_CALL ||
> -	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
>  	    CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
> -	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
> +	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_NHEALTH ||
>  	    cmd->status != 0)
>  		return cmd->status < 0 ? cmd->status : -EINVAL;
>  	return 0;
> @@ -80,28 +113,33 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
>  	}
>  
>  	/* below health data can be retrieved via MSFT _DSM function 11 */
> -	return NDN_MSFT_SMART_HEALTH_VALID |
> -		NDN_MSFT_SMART_TEMP_VALID |
> -		NDN_MSFT_SMART_USED_VALID;
> +	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
> +	    ND_SMART_USED_VALID | ND_SMART_ALARM_VALID;
>  }
>  
> -static unsigned int num_set_bit_health(__u16 num)
> +static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
>  {
> -	int i;
> -	__u16 n = num & 0x7FFF;
> -	unsigned int count = 0;
> +	unsigned int health = 0;
> +	int rc;
>  
> -	for (i = 0; i < 15; i++)
> -		if (!!(n & (1 << i)))
> -			count++;
> +	rc = msft_smart_valid(cmd);
> +	if (rc < 0) {
> +		errno = -rc;
> +		return UINT_MAX;
> +	}
>  
> -	return count;
> +	if (CMD_MSFT_SMART(cmd)->nvm_lifetime == 0)
> +		health |= ND_SMART_FATAL_HEALTH;
> +	if (CMD_MSFT_SMART(cmd)->health != 0 ||
> +	    CMD_MSFT_SMART(cmd)->err_thresh_stat != 0)
> +		health |= ND_SMART_CRITICAL_HEALTH;
> +	if (CMD_MSFT_SMART(cmd)->warn_thresh_stat != 0)
> +		health |= ND_SMART_NON_CRITICAL_HEALTH;
> +	return health;
>  }
>  
> -static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
> +static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
>  {
> -	unsigned int health;
> -	unsigned int num;
>  	int rc;
>  
>  	rc = msft_smart_valid(cmd);
> @@ -110,21 +148,13 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
>  		return UINT_MAX;
>  	}
>  
> -	num = num_set_bit_health(CMD_MSFT_SMART(cmd)->health);
> -	if (num == 0)
> -		health = 0;
> -	else if (num < 2)
> -		health = ND_SMART_NON_CRITICAL_HEALTH;
> -	else if (num < 3)
> -		health = ND_SMART_CRITICAL_HEALTH;
> -	else
> -		health = ND_SMART_FATAL_HEALTH;
> -
> -	return health;
> +	return CMD_MSFT_SMART(cmd)->temp * 16;
>  }
>  
> -static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
> +static unsigned int msft_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
>  {
> +	__u8 stat;
> +	unsigned int flags = 0;
>  	int rc;
>  
>  	rc = msft_smart_valid(cmd);
> @@ -133,7 +163,13 @@ static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
>  		return UINT_MAX;
>  	}
>  
> -	return CMD_MSFT_SMART(cmd)->temp * 16;
> +	stat = CMD_MSFT_SMART(cmd)->err_thresh_stat |
> +	    CMD_MSFT_SMART(cmd)->warn_thresh_stat;
> +	if (stat & 3) /* NVM_LIFETIME/ES_LIFETIME */
> +		flags |= ND_SMART_SPARE_TRIP;
> +	if (stat & 4) /* ES_TEMP */
> +		flags |= ND_SMART_CTEMP_TRIP;
> +	return flags;
>  }
>  
>  static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
> @@ -171,10 +207,13 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>  }
>  
>  struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
> +	.cmd_desc = msft_cmd_desc,
> +	.cmd_is_supported = msft_cmd_is_supported,
>  	.new_smart = msft_dimm_cmd_new_smart,
>  	.smart_get_flags = msft_cmd_smart_get_flags,
>  	.smart_get_health = msft_cmd_smart_get_health,
>  	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
> +	.smart_get_alarm_flags = msft_cmd_smart_get_alarm_flags,
>  	.smart_get_life_used = msft_cmd_smart_get_life_used,
>  	.xlat_firmware_status = msft_cmd_xlat_firmware_status,
>  };
> diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
> index 978cc11..8d246a5 100644
> --- a/ndctl/lib/msft.h
> +++ b/ndctl/lib/msft.h
> @@ -2,21 +2,16 @@
>  /* Copyright (C) 2016-2017 Dell, Inc. */
>  /* Copyright (C) 2016 Hewlett Packard Enterprise Development LP */
>  /* Copyright (C) 2014-2020, Intel Corporation. */
> +/* Copyright (C) 2022 iXsystems, Inc. */
>  #ifndef __NDCTL_MSFT_H__
>  #define __NDCTL_MSFT_H__
>  
>  enum {
> -	NDN_MSFT_CMD_QUERY = 0,
> -
> -	/* non-root commands */
> -	NDN_MSFT_CMD_SMART = 11,
> +	NDN_MSFT_CMD_CHEALTH = 10,
> +	NDN_MSFT_CMD_NHEALTH = 11,
> +	NDN_MSFT_CMD_EHEALTH = 12,
>  };
>  
> -/* NDN_MSFT_CMD_SMART */
> -#define NDN_MSFT_SMART_HEALTH_VALID	ND_SMART_HEALTH_VALID
> -#define NDN_MSFT_SMART_TEMP_VALID	ND_SMART_TEMP_VALID
> -#define NDN_MSFT_SMART_USED_VALID	ND_SMART_USED_VALID
> -
>  /*
>   * This is actually function 11 data,
>   * This is the closest I can find to match smart
> -- 
> 2.30.2
> 
> 

