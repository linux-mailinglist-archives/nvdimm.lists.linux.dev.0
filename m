Return-Path: <nvdimm+bounces-4556-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3024059AED5
	for <lists+linux-nvdimm@lfdr.de>; Sat, 20 Aug 2022 17:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 700821C20864
	for <lists+linux-nvdimm@lfdr.de>; Sat, 20 Aug 2022 15:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19792F29;
	Sat, 20 Aug 2022 15:28:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from aye.elm.relay.mailchannels.net (aye.elm.relay.mailchannels.net [23.83.212.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AEA2C80
	for <nvdimm@lists.linux.dev>; Sat, 20 Aug 2022 15:28:44 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id F3E4781A20;
	Sat, 20 Aug 2022 15:28:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3ADB681ACC;
	Sat, 20 Aug 2022 15:28:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1661009323; a=rsa-sha256;
	cv=none;
	b=7rvQN60sBIVjy7AkpTrUqnCxfXeG0cUm9Q/9sd1Zj2R90grliw+OmbQ7KTHcgllwcURX9O
	kkyKxMktGnoni+i+yvHmP+47NfpTpzptRWjRdMgeNbJdgQFHt/pDMYyRDay24ZLsEjI/Gq
	pH/CoCpevchzKufW/GWj+uNllY6UdMHyTXSGMoBXoWqO0ZP5CK7vmeHQS44feDXja2Ase/
	PiYNDam0P+ubTGkvBgtAK8K6Lj7LlkUjGc3Nc1HlLf+XbzXO8rsUuykBvwOQWni727tvxH
	VSs1MQwu14xqK95+wRNtdaxfG5N2+3vdJhHIoBz5thrzgRkIQC9FL0cxMhsFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1661009323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLgPsu0bpwJo2yzzcZFJyYYI3Z1xx8Vz41AtkGRgplE=;
	b=rb7EuImPAXq73OTykiCXNYMC+LO4wwZjGaqci3/b6DHeCUzSBslV3IfGNSUs2idBMtNKWZ
	6euvGi1VWNtu6we7M69JJYC+uBdsTQS4kCu4DG/eyBdvywS5O7dDkcUUs59UeIhkGEIqfb
	IMSm/Mg3hXftm3R9HApHG/M7jUrpxdem7G1tbkBEak4uAc3jgJfrH186UuUnJvAmtC2JSU
	uPkQwQZYLk2t+jBZVPau5Ls9KqnxuJSahcNmWc/mknYs321wcSwR7+C1EfYcpWtia0EnDt
	oxRUo7ZoCSdXnltXTY0j6vcbjg7oLL6b/vJR0dxAiOKTcsALIFvXPLgc3XC4zw==
ARC-Authentication-Results: i=1;
	rspamd-769cfffc99-pl9xh;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Keen-Bitter: 287036c97cafc95e_1661009323837_324093453
X-MC-Loop-Signature: 1661009323837:942968739
X-MC-Ingress-Time: 1661009323837
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.115.45.14 (trex/6.7.1);
	Sat, 20 Aug 2022 15:28:43 +0000
Received: from offworld (unknown [104.36.31.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4M92Zy1C3XzH9;
	Sat, 20 Aug 2022 08:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1661009323;
	bh=SLgPsu0bpwJo2yzzcZFJyYYI3Z1xx8Vz41AtkGRgplE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=fHxoD6rXRIqgJrjKNKsIW6+ui5Ph6YXviotJnFjL1rU6l5SMz+1mhqUe3TZ09rHeb
	 ONUC9V5T9h/dtCH0EdaNZ965uxF5+8bz76NV0MmxOURYn08zbfFNvOXfvacIb/iOY4
	 uPt5Zf1x/WK9RLPUbfC+Zbbc5K+9iqm6ueDFpbamNd0GdEnP209G1qumZEqdLjoNLV
	 F5Kj0bd94jYtdilG1Ay7kHm1F3ecmLmhKx+W5pnIS5Xn7c8jyLMiI2FwiWWeq0weUZ
	 R9dbOlabfh3KmSIwm7tUK3RXJxZhFAGthbN8QeInfkyJ43wc10+EBe7jGK3UMpzCaf
	 P0e+AkEa/m1vA==
Date: Sat, 20 Aug 2022 08:10:48 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-arch@vger.kernel.org, dan.j.williams@intel.com,
	peterz@infradead.org, mark.rutland@arm.com, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, a.manzanares@samsung.com,
	bwidawsk@kernel.org, alison.schofield@intel.com,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <20220820151048.cfpkqhut5z6wa6yk@offworld>
References: <20220819171024.1766857-1-dave@stgolabs.net>
 <YwAo1Ec13hjiBOat@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YwAo1Ec13hjiBOat@iweiny-desk3>
User-Agent: NeoMutt/20220429

On Fri, 19 Aug 2022, Ira Weiny wrote:

>Did you mean "must"?

Yep.

>> + * such as those which caches are in a consistent state. The
>> + * caller can verify the situation early on.
>> + */
>> +#ifndef flush_all_caches
>> +# define flush_all_caches_capable() false
>> +static inline void flush_all_caches(void)
>> +{
>> +	WARN_ON_ONCE("cache invalidation required\n");
>> +}
>
>With the addition of flush_all_caches_capable() will flush_all_caches() ever be
>called?

No, it should not. Hence you get a splat if you call it bogusly.

