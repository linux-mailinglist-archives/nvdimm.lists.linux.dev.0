Return-Path: <nvdimm+bounces-4559-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0F959C10C
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Aug 2022 15:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DC651C20948
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Aug 2022 13:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6489123DA;
	Mon, 22 Aug 2022 13:55:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from dormouse.elm.relay.mailchannels.net (dormouse.elm.relay.mailchannels.net [23.83.212.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D07B
	for <nvdimm@lists.linux.dev>; Mon, 22 Aug 2022 13:55:47 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1952823430;
	Mon, 22 Aug 2022 13:55:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a269.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id F205F2316A;
	Mon, 22 Aug 2022 13:55:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1661176536; a=rsa-sha256;
	cv=none;
	b=3omOJCF76GuHexFv/qn+hiLUUmfn7xeZC84hnGFQT+rvm4rXISSdNtlZVmrEE5sqtb7qu0
	3inDTAnHBJfo+S+wp7aAATE21YP3PjKgbJ9C7QhYGOEU0j6cJwtyp3oH0tE4gSiL+OBW+U
	1DL2QK/F6AN6MuJUhu2HEW5h8Wut2n5/oIxzrMIfjuUal1nbMnF4JAs3B4bYWCx+LM6eGO
	Yc4LDkdGW1I8qj7+85o++qzprKZgxrtfobh1HEl6ikZ13fQz2bxXn7QoN/LKckqa8tJEEt
	2nX+0knXTvg9iGDyNftTkxY8Wh8GjerVMbb27j2h6vN0JtGORFYafRY1AnZ6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1661176536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csF531VNDYAPl7BDCtxROg1S1vDGD1Xfu0RVZFflFgw=;
	b=ZvmlbUl9YVut82uc81/HTw+lLblqpFVw9EygzxtfrSza3T+55d90/r5bSwQbBJKLcBd1eP
	62BbakMYs4pwykdF6hhicoBALGVfufFwXKZ7OS9F673ZnUL+B8yAg9xMS7g3Ng2kLUtnDt
	kL3kY1/EcPW9HH3n1hfJCZwzvf1XJs6aMzkAWFB6BY5V/o7d7VZntOWqc3/ykYAzUf6Vl8
	ZrwnFzdRpIcnJpC53MoRaIe6ibeCmRuZ/jMGV0ulEwplL4/jqczigLa1oWzOK3L4c/VL20
	ehYj7B6W/FtjzN4/J+VW46cehQWQJpR8tn0b80TcyH+H36nxNrjeKJ35r/051A==
ARC-Authentication-Results: i=1;
	rspamd-79945fd77c-g497v;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Army: 5b5717fe75be5fd0_1661176536659_1620849424
X-MC-Loop-Signature: 1661176536659:101402978
X-MC-Ingress-Time: 1661176536659
Received: from pdx1-sub0-mail-a269.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.55.195 (trex/6.7.1);
	Mon, 22 Aug 2022 13:55:36 +0000
Received: from offworld (unknown [104.36.31.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a269.dreamhost.com (Postfix) with ESMTPSA id 4MBDQZ3sRWzKj;
	Mon, 22 Aug 2022 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1661176535;
	bh=csF531VNDYAPl7BDCtxROg1S1vDGD1Xfu0RVZFflFgw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=purhyt64fbjx70+gG83TpY2jPCSW5nNdRsKMo2E1vKOMKSh2939nWpCf6L62aVxS1
	 XVRYEpBkL6OL2slgGlLRDPiwXn7C5eVwHPjt3LAOmS7vmu6rmAK8cRiHEsrno15B3t
	 OSKoQ77IUpZPFTzbIS3SWyFgXoz9Bn1oGZEKbmmY/Z7LtZ7b30ZInMcBX6PuWvWQr+
	 mMzIHELO8whLUjrUhgmlLQid7sPScz9wXRqJWgdjpRW1gReUH0RfGt9FRs7jwsUyUP
	 vKMEdFbqtOs8wDR54Nucu3waN0rVXPtJOReqRukQEhP3Ie8RB2HCwJ8MKpS1MfqZVE
	 nMdUf361w69Bw==
Date: Mon, 22 Aug 2022 06:37:36 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-arch@vger.kernel.org, dan.j.williams@intel.com,
	peterz@infradead.org, mark.rutland@arm.com, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, a.manzanares@samsung.com,
	bwidawsk@kernel.org, alison.schofield@intel.com,
	ira.weiny@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <20220822133736.roxmpj6sfo6gsij2@offworld>
References: <20220819171024.1766857-1-dave@stgolabs.net>
 <YwMkUMiKf3ZyMDDF@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YwMkUMiKf3ZyMDDF@infradead.org>
User-Agent: NeoMutt/20220429

On Sun, 21 Aug 2022, Christoph Hellwig wrote:

>On Fri, Aug 19, 2022 at 10:10:24AM -0700, Davidlohr Bueso wrote:
>> index b192d917a6d0..ac4d4fd4e508 100644
>> --- a/arch/x86/include/asm/cacheflush.h
>> +++ b/arch/x86/include/asm/cacheflush.h
>> @@ -10,4 +10,8 @@
>>
>>  void clflush_cache_range(void *addr, unsigned int size);
>>
>> +/* see comments in the stub version */
>> +#define flush_all_caches() \
>> +	do { wbinvd_on_all_cpus(); } while(0)
>
>Yikes.  This is just a horrible, horrible name and placement for a bad
>hack that should have no generic relevance.

Why does this have no generic relevance? There's already been discussions
on how much wbinv is hated[0].

>Please fix up the naming to make it clear that this function is for a
>very specific nvdimm use case, and move it to a nvdimm-specific header
>file.

Do you have any suggestions for a name? And, as the changelog describes,
this is not nvdimm specific anymore, and the whole point of all this is
volatile memory components for cxl, hence nvdimm namespace is bogus.

[0] https://lore.kernel.org/all/Yvtc2u1J%2Fqip8za9@worktop.programming.kicks-ass.net/

Thanks,
Davidlohr

