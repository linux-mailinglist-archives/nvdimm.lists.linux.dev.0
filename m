Return-Path: <nvdimm+bounces-9423-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 844BF9E0754
	for <lists+linux-nvdimm@lfdr.de>; Mon,  2 Dec 2024 16:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BE6517435B
	for <lists+linux-nvdimm@lfdr.de>; Mon,  2 Dec 2024 15:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A4D20966C;
	Mon,  2 Dec 2024 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="deUmPdPE"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01679208990
	for <nvdimm@lists.linux.dev>; Mon,  2 Dec 2024 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733153200; cv=none; b=Xat5rzCNY2TsEO87xKArs6SzcjiNW0cLePzUOyYVtjOglzhRWYB1wkW2Q6fGJRUWqdxsY0G0MLuENiigV4tizj4HskanmdXB5qInVDYkI0ESxpL8g1FOSwvD/1Ug56UXlvIMFguG0ea6wukAVIHdkGYKVqKMvy8Rd4uT3uIW8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733153200; c=relaxed/simple;
	bh=rtIOev6fnqSJdfmM9KINIa78sHwNSBxTRYjDvhrxH+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QByZeiawcGmSRzBJ1r5dJnLNCEc2S0+hi2BEZi6a2mjG5gkPLXEKjXK8w1isj168d0ZhRbKoh4efRYliKe6M73XE2hPVR8VE7ZoaaygGMijRsP4ppEHARYixGE6Q28Wto0yWW2h5OSn399O7oHIFJpGQ1EhQ3iEW8s8gobJVxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=deUmPdPE; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733153199; x=1764689199;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rtIOev6fnqSJdfmM9KINIa78sHwNSBxTRYjDvhrxH+U=;
  b=deUmPdPEnQJtjCj3PGJzDSiN6sRijeizJ8XO2qbfPhhk4ADwWYuaCkJG
   H5qof9MwvVQuzR/BFaaqLFRUfbVvxv20fWauV5A35AZiSSQyc/lC7sRi2
   S3fR5hn7zODY9yyixnHo5tZ5Mvh7EEyhRf3M1lH/JEIF2y5WAja9XC6Ur
   ygSQbcresYi0/922VL4JJT0Diw7EOCiRPyIkae9PvvoX4NhyOVAdMfjps
   /Mwg+lQYsnLI1x3OY8yDlaN52omF2w+ivEJ1NsNP6t+/uoA25zc2WdUhq
   w0to3hS/UlDTXlQ0lOtgRyjUF/Toa9DAKhBkSu+kU4br4AjVSvlLEDy5U
   g==;
X-CSE-ConnectionGUID: mGZr54xYSr+78i9tLaRlog==
X-CSE-MsgGUID: RfwD5ZhRTimNf5Fadsz1Rg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="43994378"
X-IronPort-AV: E=Sophos;i="6.12,202,1728975600"; 
   d="scan'208";a="43994378"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 07:26:34 -0800
X-CSE-ConnectionGUID: 5blnOipIQ/Gz1znfqoGBKA==
X-CSE-MsgGUID: sci3YQEQScCF9mfDXchEHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98173354"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.111.153]) ([10.125.111.153])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 07:26:33 -0800
Message-ID: <377b8a42-dc65-4b3f-9096-b57dea435d74@intel.com>
Date: Mon, 2 Dec 2024 08:26:32 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
To: Suraj Sonawane <surajsonawane0215@gmail.com>, dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, ira.weiny@intel.com, rafael@kernel.org,
 lenb@kernel.org, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
References: <20241118162609.29063-1-surajsonawane0215@gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241118162609.29063-1-surajsonawane0215@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/18/24 9:26 AM, Suraj Sonawane wrote:
> Fix an issue detected by syzbot with KASAN:
> 
> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
> core.c:416 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
> drivers/acpi/nfit/core.c:459
> 
> The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
> array is accessed without verifying that call_pkg points to a buffer
> that is appropriately sized as a struct nd_cmd_pkg. This can lead
> to out-of-bounds access and undefined behavior if the buffer does not
> have sufficient space.
> 
> To address this, a check was added in acpi_nfit_ctl() to ensure that
> buf is not NULL and that buf_len is less than sizeof(*call_pkg)
> before accessing it. This ensures safe access to the members of
> call_pkg, including the nd_reserved2 array.
> 
> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/
> V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
> potential uninitialized variable usage if condition is true.
> V3: Changed the condition to if (!buf || buf_len < sizeof(*call_pkg))
> and updated the Fixes tag to reference the correct commit.
> V4: Removed the explicit cast to maintain the original code style.
> V5: Re-Initialized `out_obj` to NULL. To prevent
> potential uninitialized variable usage if condition is true.
> V6: Remove the goto out condition from the error handling and directly
> returned -EINVAL in the check for buf and buf_len
> 
>  drivers/acpi/nfit/core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 5429ec9ef..a5d47819b 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  	if (cmd_rc)
>  		*cmd_rc = -EINVAL;
>  
> -	if (cmd == ND_CMD_CALL)
> +	if (cmd == ND_CMD_CALL) {
> +		if (!buf || buf_len < sizeof(*call_pkg))
> +			return -EINVAL;
> +
>  		call_pkg = buf;
> +	}
> +
>  	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
>  	if (func < 0)
>  		return func;


