Return-Path: <nvdimm+bounces-4496-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE80058F404
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Aug 2022 23:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9AE31C20970
	for <lists+linux-nvdimm@lfdr.de>; Wed, 10 Aug 2022 21:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A71468D;
	Wed, 10 Aug 2022 21:57:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from donkey.elm.relay.mailchannels.net (donkey.elm.relay.mailchannels.net [23.83.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB90B443A
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 21:56:59 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C1C606C176F;
	Wed, 10 Aug 2022 21:48:33 +0000 (UTC)
Received: from pdx1-sub0-mail-a301.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id A8F856C1F1A;
	Wed, 10 Aug 2022 21:48:32 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1660168113; a=rsa-sha256;
	cv=none;
	b=WYJMxqrkeP4XCTOieBVD2PSb5p6fs8JP3LLyF0OZ80zLtfrBHUZZvzwCyUFnGl2pyeYpFg
	OSAky+QGuVZ4Bs2fbjFz1Uzh2vbJUcQZqSRIX8RTP8ZdigDjHfYM2ycaGOuZL7vKROGHC5
	EIfXZDiz3XZ9E9PppwWKOHRM5C3mXO+53L1MFO2mw94J6NhUBuAtKnZo8dl1x6cQCopWJN
	hCNV3v99/GrjoCFy6WMiLE62qvBo/oEBwdI5SfNQ1Z41usxp/WBUy0Y4qYgD0SM5HRnI9T
	iybn/hUccU8mziu16/2OOfMxI+nchMsj4TCOlXSv/FHNyP2UzY4zT30NwBMscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1660168113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWp01Hcl4j0YiL9/n7IqCl4dh/n8uPqHFzk1dZ4hNj8=;
	b=INNStFOlxSuXXOwUF/tkf8NmHL8KePZuDc2lWL2jv7EBB633F3vaq2ymNKkD80dnh5yNSo
	bWl5PbePBYG/esel1y+16Svr16VzqJ6Q67KJw5B7kYk/UoXlMUPlc02xg4oFBhZIEZTd8W
	u4VHk5T5P9E3piV41193RGytTWwCZUEl/g9ZtJ3R55Zmdz3QD3B13YHzmxHvj7lrORM6Xa
	mPzwW8ebFpPbKEJLrF64kPLtD0bUx6uZy4pM9ndtbQ4BIamUmD2wRqraYIrDG8thApP2Mu
	tee669SrSzwmLl2+9xpQD/11viUm79fr7zMSSOdoiDyfkicvGi9GGXvx3xSVmg==
ARC-Authentication-Results: i=1;
	rspamd-7c478d8c66-wmbcj;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Lonely-Unite: 2587f2a53c744ae3_1660168113268_3568757427
X-MC-Loop-Signature: 1660168113268:3572167391
X-MC-Ingress-Time: 1660168113267
Received: from pdx1-sub0-mail-a301.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.55.239 (trex/6.7.1);
	Wed, 10 Aug 2022 21:48:33 +0000
Received: from offworld (unknown [104.36.25.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a301.dreamhost.com (Postfix) with ESMTPSA id 4M33Tq2F6MzMD;
	Wed, 10 Aug 2022 14:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1660168112;
	bh=jWp01Hcl4j0YiL9/n7IqCl4dh/n8uPqHFzk1dZ4hNj8=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=A6GKJe13/0xcGDk13MOtD/Lf29AjbXwG7DsGw8gAvvZtFwA3xgbgYPqjHxiN7iPDv
	 D5k7AqupovSKVi//+eIPG84PE3FCZMln9AyHay2+GllzOCv2EnHZOKou364UCxz+ib
	 j4O4AFEjnlRErLj1vowWcX+OiRmqciu1sZwW8N8XaFyB3sFZ1bgVkvEUzW2IUQint/
	 YCYxGvHeunNiEGk9FJ9ratMlpHkt03pT9eejxjNvh+nuAUgk0SWzgpQegOKqBnq1Gv
	 WvIb054m7ixCjZT6ReFxkDztcdkkfH6ZghMFTjtQ563pV9fRkX2U1CrCqwp5du+oFw
	 dg9dzgrWnGqqw==
Date: Wed, 10 Aug 2022 14:31:12 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	bwidawsk@kernel.org, ira.weiny@intel.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, a.manzanares@samsung.com,
	linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 10/15] x86: add an arch helper function to invalidate
 all cache for nvdimm
Message-ID: <20220810213112.p4fdclh4zbd3vta6@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
 <20220718053039.5whjdcxynukildlo@offworld>
 <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
 <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
 <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
 <62f40fba338af_3ce6829466@dwillia2-xfh.jf.intel.com.notmuch>
 <20220810211337.ha27cl24splm4wjh@offworld>
 <62f4238b5ce8a_3ce6829447@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <62f4238b5ce8a_3ce6829447@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: NeoMutt/20220429

On Wed, 10 Aug 2022, Dan Williams wrote:

>Davidlohr Bueso wrote:
>> On Wed, 10 Aug 2022, Dan Williams wrote:
>>
>> >I expect the interface would not be in the "flush_cache_" namespace
>> >since those functions are explicitly for virtually tagged caches that
>> >need maintenance on TLB operations that change the VA to PA association.
>> >In this case the cache needs maintenance because the data at the PA
>> >changes. That also means that putting it in the "nvdimm_" namespace is
>> >also wrong because there are provisions in the CXL spec where volatile
>> >memory ranges can also change contents at a given PA, for example caches
>> >might need to be invalidated if software resets the device, but not the
>> >platform.
>> >
>> >Something like:
>> >
>> >    region_cache_flush(resource_size_t base, resource_size_t n, bool nowait)
>> >
>> >...where internally that function can decide if it can rely on an
>> >instruction like wbinvd, use set / way based flushing (if set / way
>> >maintenance can be made to work which sounds like no for arm64), or map
>> >into VA space and loop. If it needs to fall back to that VA-based loop
>> >it might be the case that the caller would want to just fail the
>> >security op rather than suffer the loop latency.
>>
>> Yep, I was actually prototyping something similar, but want to still
>> reuse cacheflush.h machinery and just introduce cache_flush_region()
>> or whatever name, which returns any error. So all the logic would
>> just be per-arch, where x86 will do the wbinv and return 0, and arm64
>> can just do -EINVAL until VA-based is no longer the only way.
>
>cache_flush_region() works for me, but I wonder if there should be a
>cache_flush_region_capable() call to shut off dependent code early
>rather than discovering it at runtime? For example, even archs like x86,
>that have wbinvd, have scenarios where wbinvd is prohibited, or painful.
>TDX, and virtualization in general, comes to mind.

Yeah I'm no fan of wbinv, but in these cases (cxl/nvdimm), at least from
the performance angle, I am not worried: the user is explicity doing a
security/cleaning specific op, probably decomisioning, so it's rare and
should not expect better.

Thanks,
Davidlohr

