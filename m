Return-Path: <nvdimm+bounces-9014-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F1799551B
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Oct 2024 18:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAD0B286EB7
	for <lists+linux-nvdimm@lfdr.de>; Tue,  8 Oct 2024 16:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E4C1E0DF4;
	Tue,  8 Oct 2024 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrScJnjy"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB381DFE2B
	for <nvdimm@lists.linux.dev>; Tue,  8 Oct 2024 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728406592; cv=none; b=XnXnCP1zI5V+noD7u1K5dCzWarLxfzdtNsZXZIQO9wCkur8+Vn9wcbMeXewAwIj/Ke7ybmIFKm3/Df8Tq6SC6iZ08nLf6KYMBDQ0ZC3lUqTvNnaJLAaKyBUdp9vyvf1oXVvHWoZFwTKqENdk2d7A0czAJAFouWRnLpumsRfe9hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728406592; c=relaxed/simple;
	bh=Q8M18ulxejwRnUYRV/Nf4isTNrgYrTO5E95nOsiqw+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bo13lTUNAnm6l18g8zdfcDb9dn8omuh1nSHZukihaBucnbF1fE3HY7lvlkKv1L16cgWh0Qy2zsY8x4XZLhqpkZR/+sWNec1zby0Ku20TD0n22pnh8hQ7eWJ4r6p4vxanzDwxQvp5HkZWAgUpbg/gLDQLbv69AQMX3QvR+5SZ9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrScJnjy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728406591; x=1759942591;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q8M18ulxejwRnUYRV/Nf4isTNrgYrTO5E95nOsiqw+g=;
  b=KrScJnjy411SQm46UjB0kURScaU3lUD3D0F/J/Eta0dvCXbG4qRQEzuU
   4p4gzRqx7XMx2QohbOy5VB0xCG3oDJL+Q1YRYGnQNCA76qibf3PgZLXHj
   FeKhBcVEod3yQ7g91hpb1Ix/HxmKtlIbA5RbCRW7s7qkZwDViTNoLgz8E
   EXNsa8kPACae6BlioUDMJbT0fU0sNdoyXCDSnTKgFSZoP+SzLg9F6l3Np
   +vjYjItnkxWqNaKN6jW+U4h7NmXTudEq/gpDWb/3VwOG/g5tBjLMuwsk+
   jauPPH9S15BinLIq99yXxuIeSQFNkS9GNo2sCgurWa/P7fnEsi0b3tMqt
   Q==;
X-CSE-ConnectionGUID: ZMee5sXWQX6SK0RYao6+SQ==
X-CSE-MsgGUID: bMINmeFSTdaV82J8LBQJXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="31517950"
X-IronPort-AV: E=Sophos;i="6.11,187,1725346800"; 
   d="scan'208";a="31517950"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 09:56:31 -0700
X-CSE-ConnectionGUID: UxRKETLhRgyfXxERER7HJQ==
X-CSE-MsgGUID: oR7USdbkTRuaYJ3OqbOfoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,187,1725346800"; 
   d="scan'208";a="80506620"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa004.fm.intel.com with ESMTP; 08 Oct 2024 09:56:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 1683D20F; Tue, 08 Oct 2024 19:56:20 +0300 (EEST)
Date: Tue, 8 Oct 2024 19:56:20 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 02/28] printk: Add print format (%pra) for struct range
Message-ID: <ZwVkNNpVrJ4lHQ8p@black.fi.intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-2-c261ee6eeded@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Oct 07, 2024 at 06:16:08PM -0500, Ira Weiny wrote:
> The use of struct range in the CXL subsystem is growing.  In particular,
> the addition of Dynamic Capacity devices uses struct range in a number
> of places which are reported in debug and error messages.
> 
> To wit requiring the printing of the start/end fields in each print
> became cumbersome.  Dan Williams mentions in [1] that it might be time
> to have a print specifier for struct range similar to struct resource
> 
> A few alternatives were considered including '%par', '%r', and '%pn'.
> %pra follows that struct range is similar to struct resource (%p[rR])
> but need to be different.  Based on discussions with Petr and Andy
> '%pra' was chosen.[2]
> 
> Andy also suggested to keep the range prints similar to struct resource
> though combined code.  Add hex_range() to handle printing for both
> pointer types.

...

> +static void __init
> +struct_range(void)
> +{
> +	struct range test_range = {
> +		.start = 0xc0ffee00ba5eba11,
> +		.end = 0xc0ffee00ba5eba11,
> +	};

A side note, can we add something like

#define DEFINE_RANGE(start, end)	\
	(struct range) {		\
		.start = (start),	\
		.end = (end),		\
	}

in range.h and use here and in the similar cases?

> +	test("[range 0xc0ffee00ba5eba11]", "%pra", &test_range);
> +
> +	test_range = (struct range) {
> +		.start = 0xc0ffee,
> +		.end = 0xba5eba11,
> +	};
> +	test("[range 0x0000000000c0ffee-0x00000000ba5eba11]",
> +	     "%pra", &test_range);
> +
> +	test_range = (struct range) {
> +		.start = 0xba5eba11,
> +		.end = 0xc0ffee,
> +	};
> +	test("[range 0x00000000ba5eba11-0x0000000000c0ffee]",
> +	     "%pra", &test_range);
> +}

...


> +char *hex_range(char *buf, char *end, u64 start_val, u64 end_val,
> +		struct printf_spec spec)
> +{
> +	buf = number(buf, end, start_val, spec);
> +	if (start_val != end_val) {
> +		if (buf < end)
> +			*buf++ = '-';
> +		buf = number(buf, end, end_val, spec);
> +	}
> +	return buf;
> +}

Perhaps

	buf = number(buf, end, start_val, spec);
	if (start_val == end_val)
		return buf;

	if (buf < end)
		*buf++ = '-';
	return number(buf, end, end_val, spec);

(yes, I have seen the original code)?


> +static noinline_for_stack
> +char *range_string(char *buf, char *end, const struct range *range,
> +		   struct printf_spec spec, const char *fmt)
> +{
> +#define RANGE_DECODED_BUF_SIZE		((2 * sizeof(struct range)) + 4)
> +#define RANGE_PRINT_BUF_SIZE		sizeof("[range -]")
> +	char sym[RANGE_DECODED_BUF_SIZE + RANGE_PRINT_BUF_SIZE];
> +	char *p = sym, *pend = sym + sizeof(sym);
> +
> +	struct printf_spec range_spec = {
> +		.field_width = 2 + 2 * sizeof(range->start), /* 0x + 2 * 8 */
> +		.flags = SPECIAL | SMALL | ZEROPAD,
> +		.base = 16,
> +		.precision = -1,
> +	};
> +
> +	if (check_pointer(&buf, end, range, spec))
> +		return buf;
> +
> +	*p++ = '[';
> +	p = string_nocheck(p, pend, "range ", default_str_spec);
> +	p = hex_range(p, pend, range->start, range->end, range_spec);
> +	*p++ = ']';
> +	*p = '\0';
> +
> +	return string_nocheck(buf, end, sym, spec);
> +}

...

> + * - 'ra' struct ranges [range 0x00 - 0xff]

Is it possible to get only bytes out of this? I thought we have always
64-bit values here, no?

...

>  	case 'B':
>  		return symbol_string(buf, end, ptr, spec, fmt);
> -	case 'R':
>  	case 'r':
> +		switch (fmt[1]) {
> +		case 'a':
> +			return range_string(buf, end, ptr, spec, fmt);
> +		}
> +		fallthrough;
> +	case 'R':
>  		return resource_string(buf, end, ptr, spec, fmt);

Do we have default-less switches in the code (in this file)?

Actually I would suggest to move this to a wrapper like time_and_date().

-- 
With Best Regards,
Andy Shevchenko



