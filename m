Return-Path: <nvdimm+bounces-4543-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6456B59612B
	for <lists+linux-nvdimm@lfdr.de>; Tue, 16 Aug 2022 19:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 921B8280AA2
	for <lists+linux-nvdimm@lfdr.de>; Tue, 16 Aug 2022 17:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F45F53BD;
	Tue, 16 Aug 2022 17:30:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DAD53B8
	for <nvdimm@lists.linux.dev>; Tue, 16 Aug 2022 17:29:58 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8F2006C1B90;
	Tue, 16 Aug 2022 17:10:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a225.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id AEDA46C1977;
	Tue, 16 Aug 2022 17:10:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1660669843; a=rsa-sha256;
	cv=none;
	b=IbHFQs+XHp4MZI3X6oCtUbIZS0/XG+6TYvsn8I5KVkcFEbRthAx3z/u/xMqP+fReeDCFai
	Z3Y7WnvekUrlkotbQKRIqZVWFgdrrXMgehf/6yQUmYjzOl8xBbMagixZ0erABnsQYjWcm+
	JXD/9n8ut9ePLNRvhrcKAUcp8ZC/vH4YAsV2VwJVJwBEbzuc1QPmsE1boSkHKGdr/J31fL
	Iq5QQEWGKvX97E1u4DZk4jgAyZapMVF1ISnAtI1AVZ4Gw4qHn1u7N6IBi5OCHODClQGWU/
	FA54Vv7PV/UOmG8URN5smUid4VNZu8h+qKGchGJwvx0W5Ji6TYigj2n5XmzrUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1660669843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHBgu+nCXZPgIF8SF+iAlqU9/Ri3M1yE/jeNQa9OyJ8=;
	b=sqUdMlhmauBvWpJJdPaZzAT9WJQcj7oPOrs5e1+DYWIQHYeXAUylZOB2solv/r9cDy4MJa
	/Vn3kxQN0o1V2pc6VaMxXb88kR/ZiDFiYLRmPuI11kR9aszKtpUjMKNYM/4F7cz3RecL1z
	8T9Q9/mY5GmHeVupSd9kbFjdaikGdRO8ein1Uu+MFsmSM+SeE74oJpIHJHrpk+prTKUswz
	VyQMe+ZZ7wU50z9sFwzbGEIVg9KikGf4n+Xr1q+eBcrLLZjZuDANeO3A8jXyC+OiuGlHjS
	5/gv+xlxCkjhhzr+h8GTRvWr2eB2GqDFrulFkRwsNTVFrd7xIl598YkiyGsD+g==
ARC-Authentication-Results: i=1;
	rspamd-7697cc766f-vpvlp;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bitter-Robust: 2ac89aff49f3d01c_1660669843343_3379587907
X-MC-Loop-Signature: 1660669843343:2764178874
X-MC-Ingress-Time: 1660669843343
Received: from pdx1-sub0-mail-a225.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.238.93 (trex/6.7.1);
	Tue, 16 Aug 2022 17:10:43 +0000
Received: from offworld (unknown [104.36.25.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a225.dreamhost.com (Postfix) with ESMTPSA id 4M6d2T1Wsvz2V;
	Tue, 16 Aug 2022 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1660669842;
	bh=OHBgu+nCXZPgIF8SF+iAlqU9/Ri3M1yE/jeNQa9OyJ8=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=NJfSoY0zDKVG3Yq23Z8ww/mW+b8bq82/EFoJqrDMz2sdpQW5WWBb0SZ0gcH+gSaMD
	 MJfmttLaOMlcKx8nIPtmIKcf7pp+9DH39izVmSbD8+KrK5N0jC7pfDMriq8eKC1rE4
	 x3T/C2ADWt7uoU0nXrG/msbyzT0Jh3J/A/i3/AU2I26hh4VIsQOVGsLDMpCSG/wSc7
	 EpSyHLLUskSnCFYWzK7LZL2SvbpwVswJ+si6XS2laX1HTGXQlkZCiDeOiYc7WPyDxU
	 Yh5DfgfPlkFc/Rm7xvoU5lukELPTcMwYHhOvBwT4bBQ4nEV/YicmNKprHd/Flrq+hk
	 W9i5FRKQDlcBg==
Date: Tue, 16 Aug 2022 09:53:01 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	bwidawsk@kernel.org, ira.weiny@intel.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, a.manzanares@samsung.com,
	linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org, bp@alien8.de, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <20220816165301.4m4w6zsse62z4hxz@offworld>
References: <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
 <20220718053039.5whjdcxynukildlo@offworld>
 <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
 <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
 <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
 <62f40fba338af_3ce6829466@dwillia2-xfh.jf.intel.com.notmuch>
 <20220815160706.tqd42dv24tgb7x7y@offworld>
 <Yvtc2u1J/qip8za9@worktop.programming.kicks-ass.net>
 <62fbcae511ec1_dfbc129453@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <62fbcae511ec1_dfbc129453@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: NeoMutt/20220429

On Tue, 16 Aug 2022, Dan Williams wrote:

>Peter Zijlstra wrote:
>> On Mon, Aug 15, 2022 at 09:07:06AM -0700, Davidlohr Bueso wrote:
>> > diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
>> > index b192d917a6d0..ce2ec9556093 100644
>> > --- a/arch/x86/include/asm/cacheflush.h
>> > +++ b/arch/x86/include/asm/cacheflush.h
>> > @@ -10,4 +10,7 @@
>> >
>> >  void clflush_cache_range(void *addr, unsigned int size);
>> >
>> > +#define flush_all_caches() \
>> > +	do { wbinvd_on_all_cpus(); } while(0)
>> > +
>>
>> This is horrific... we've done our utmost best to remove all WBINVD
>> usage and here you're adding it back in the most horrible form possible
>> ?!?
>>
>> Please don't do this, do *NOT* use WBINVD.
>
>Unfortunately there are a few good options here, and the changelog did
>not make clear that this is continuing legacy [1], not adding new wbinvd
>usage.

While I was hoping that it was obvious from the intel.c changes that this
was not a new wbinvd, I can certainly improve the changelog with the below.

Thanks,
Davidlohr

>
>The functionality this is enabling is to be able to instantaneously
>secure erase potentially terabytes of memory at once and the kernel
>needs to be sure that none of the data from before the secure is still
>present in the cache. It is also used when unlocking a memory device
>where speculative reads and firmware accesses could have cached poison
>from before the device was unlocked.
>
>This capability is typically only used once per-boot (for unlock), or
>once per bare metal provisioning event (secure erase), like when handing
>off the system to another tenant. That small scope plus the fact that
>none of this is available to a VM limits the potential damage. So,
>similar to the mitigation we did in [2] that did not kill off wbinvd
>completely, this is limited to specific scenarios and should be disabled
>in any scenario where wbinvd is painful / forbidden.
>
>[1]: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
>[2]: e2efb6359e62 ("ACPICA: Avoid cache flush inside virtual machines")

