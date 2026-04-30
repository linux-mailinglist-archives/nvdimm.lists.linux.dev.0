Return-Path: <nvdimm+bounces-13983-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FXfLFSF82kY4wEAu9opvQ
	(envelope-from <nvdimm+bounces-13983-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 18:37:40 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D674A5D4B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 18:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 655F83058161
	for <lists+linux-nvdimm@lfdr.de>; Thu, 30 Apr 2026 16:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AEE472784;
	Thu, 30 Apr 2026 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkOJsiyI"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70929472782
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566704; cv=none; b=TQD9n9aPmYz+gi3R4Gh+iDjU5QVQKHHfI8awXxHgCT2aS7vs/yD6i3PFdDGof9GL49E47mYthxvvEQm0vc4N2P+NA4y148lE8StVJ+JC+M00ALecRaPVdxbBp0NIXb7koPoERwZ+sku56nsuis0NjXImtkHddBVuh/Vl26Pq6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566704; c=relaxed/simple;
	bh=OT/k20UIojL6S9naSu8TuqOF0V/Hqlf+FUgBZqtdSz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dq1Og2rqWuLP/zRd4zGXrBlgcqywAv8YJhQZ6wq4VnG7xhX0kvDoDpwb2PpwxtsFYvaJ1sPrYKwA0hAm9EH2/C91FgDRh75fgb74Jclw6JZmOMOXTsgF9NAIISHkTMxCLLdmrvo1HMW/f7YGX84RqW9FF5yhbi1xcQ0TaP81kR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkOJsiyI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777566703; x=1809102703;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=OT/k20UIojL6S9naSu8TuqOF0V/Hqlf+FUgBZqtdSz0=;
  b=QkOJsiyIYLo8mpqHZZogXOePl0i2LZN0wWt5MOlSWiqUb20QpYBSXBzx
   H+8UsyeLs5AV3zvzpO6zNRZpPibwyPhtOUVA1H3ODBQ/Rhts7NoSsZxA2
   0cniFmEiB5Y5pG1xEek8XZ7pijapiulI2i20z6Lrvo496iB1j6fVE64zf
   gKT78OAVjIoQ9xwvRjF/r4sGu2d3ElshIbbVx1R+3AHTn7Apvgmh3ZrKn
   F2E231v/CLJEj1yETRWD0fsjFEy1rYamYrzwr94Sy44MrJmkQJ23XT9Hu
   L/BaH++Dl/P44QKLbqdgB3yl8bBozG32S72zPbA3mIQnI+Z+zCm6ZD7YK
   Q==;
X-CSE-ConnectionGUID: G6fAtQvxRzCBe5G+1fUXtw==
X-CSE-MsgGUID: TNWOD9ddR9GkCOwbAJWTTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="78553227"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="78553227"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:31:43 -0700
X-CSE-ConnectionGUID: wguelkorT92q7P/AWL1K3w==
X-CSE-MsgGUID: F4XRxBlSQD2WDDlzVbW4QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="234517872"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:31:42 -0700
Message-ID: <7de20386-21d9-4e37-96bf-1e6397d4408e@intel.com>
Date: Thu, 30 Apr 2026 09:31:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/cxl-sanitize: avoid sanitize submit/wait race
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20260430021843.3919334-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260430021843.3919334-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 36D674A5D4B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13983-lists,linux-nvdimm=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.jiang@intel.com,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]



On 4/29/26 7:18 PM, Alison Schofield wrote:
> This test verifies that wait-sanitize blocks for the programmed
> timeout after issuing sanitize on an inactive memdev.
> 
> The sanitize request is issued in the background and wait-sanitize
> is called immediately after. In cxl_test, sanitize completes
> asynchronously via delayed work, and the sysfs write does not block.
> This creates a race where wait-sanitize may run before sanitize is
> observed and return immediately.
> 
> This test has been reliable since its introduction, but recently
> started failing consistently in one environment, suggesting a
> timing sensitivity. It fails here:
> 
>   ((SECONDS > start + 2)) || err $LINENO
> 
> Add a short delay after backgrounding the sanitize write to make
> sure that wait-sanitize can observe the in-progress operation.
> 
> A sysfs-based synchronization was considered, but no in-progress
> state is exposed to user space.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks reasonable

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/cxl-sanitize.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/test/cxl-sanitize.sh b/test/cxl-sanitize.sh
> index 9c161014ccb7..d1ed598f3663 100644
> --- a/test/cxl-sanitize.sh
> +++ b/test/cxl-sanitize.sh
> @@ -68,6 +68,9 @@ done
>  set_timeout $inactive 3000
>  start=$SECONDS
>  echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize &
> +
> +# Allow background sanitize to start before wait-sanitize can observe it
> +sleep 1
>  "$CXL" wait-sanitize $inactive || err $LINENO
>  ((SECONDS > start + 2)) || err $LINENO
>  


