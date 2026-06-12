Return-Path: <nvdimm+bounces-14415-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pMkBFoihK2orAwQAu9opvQ
	(envelope-from <nvdimm+bounces-14415-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Jun 2026 08:04:56 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D97676DAE
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Jun 2026 08:04:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=hygon.cn (policy=none);
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14415-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14415-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 591F03140CDE
	for <lists+linux-nvdimm@lfdr.de>; Fri, 12 Jun 2026 06:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B0E3806B5;
	Fri, 12 Jun 2026 06:04:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D208E36309C
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 06:04:13 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244271; cv=none; b=i4R6VDFg7+CIXVnkWFcGiTyqilvT6+ZAQbcOhNFtkEwyB6fnzH1TGJFLErkV/ADcLWhqm1ZjwGsv85KGoIpWarnoEN5iZpgYcIA06BFx/cxFDGKJHbBrpbSw2hbHYROirXQAUDoUpzXAzpTZc31oSBkSBQ/0hdZhB7CFfkQkNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244271; c=relaxed/simple;
	bh=JR4/NPp6xduf8TZbLaNbp0R8f75Pk6UDMh5YcyCee6Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGQDQhbMXsOBA6lr3wn/40m1l2oy5FFA8IZYIl9g0leBBVwfzunA0SeAs/vBK5WGEgCrPGabfU44nTTs+ag9DZU6nPEaNLydrLcj6cR4T/PyVHWPJkuy0C7fc2BW0ICSJotrEXpe1g+dd4tKM6tErmDwesQ1Bcn8pZqadYZIhCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc89067rlz1dd8B;
	Fri, 12 Jun 2026 14:04:04 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc88x6nQCz1dd8B;
	Fri, 12 Jun 2026 14:04:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 777DC7896;
	Fri, 12 Jun 2026 14:03:43 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Jun
 2026 14:03:57 +0800
Date: Fri, 12 Jun 2026 14:03:55 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <surenb@google.com>,
	<mjguzik@gmail.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<shakeel.butt@linux.dev>, <rppt@kernel.org>, <mhocko@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<dinguyen@kernel.org>, <schuster.simon@siemens-energy.com>,
	<James.Bottomley@hansenpartnership.com>, <deller@gmx.de>, <djbw@kernel.org>,
	<willy@infradead.org>, <peterz@infradead.org>, <mingo@redhat.com>,
	<acme@kernel.org>, <namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <aiuhS4iyBxx6Kcag@hsj-2U-Workstation>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
 <airZn524Ip8VsWra@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <airZn524Ip8VsWra@lucifer>
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[hygon.cn : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14415-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7];
	FORGED_RECIPIENTS(0.00)[m:ljs@kernel.org,m:akpm@linux-foundation.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:jack@suse.cz,m:muchun.song@linux.dev,m:osalvador@suse.de,m:david@kernel.org,m:surenb@google.com,m:mjguzik@gmail.com,m:liam@infradead.org,m:vbabka@kernel.org,m:shakeel.butt@linux.dev,m:rppt@kernel.org,m:mhocko@suse.com,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:linux@armlinux.org.uk,m:dinguyen@kernel.org,m:schuster.simon@siemens-energy.com,m:James.Bottomley@hansenpartnership.com,m:deller@gmx.de,m:djbw@kernel.org,m:willy@infradead.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:mark.rutland@arm.com,m:alexander.shishkin@linux.intel.com,m:jolsa@kernel.org,m:irogers@google.com,m:adrian.hunter@intel.com,m:james.clark@linaro.org,m:mhiramat@kernel.org,m:oleg@redhat.com,m:ziy@nvidia.com,m:baolin.wang@linux.alibaba.com,m:npache@redhat.com,m:ryan.roberts@arm.com,m:dev.jain@arm.com,m:baohua@kernel.org,m:lance.yang@linux.dev,m:linmiaohe
 @huawei.com,m:nao.horiguchi@gmail.com,m:jannh@google.com,m:pfalcato@suse.de,m:riel@surriel.com,m:harry@kernel.org,m:will@kernel.org,m:brian.ruley@gehealthcare.com,m:rmk+kernel@armlinux.org.uk,m:dave.anglin@bell.net,m:linux-mm@kvack.org,m:linux-doc@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-arm-kernel@lists.infradead.org,m:linux-parisc@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:nvdimm@lists.linux.dev,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:zhongyuan@hygon.cn,m:fangbaoshun@hygon.cn,m:yingzhiwei@hygon.cn,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,zeniv.linux.org.uk,kernel.org,suse.cz,linux.dev,suse.de,google.com,gmail.com,infradead.org,suse.com,lwn.net,linuxfoundation.org,armlinux.org.uk,siemens-energy.com,hansenpartnership.com,gmx.de,redhat.com,arm.com,linux.intel.com,intel.com,linaro.org,nvidia.com,linux.alibaba.com,huawei.com,surriel.com,gehealthcare.com,bell.net,kvack.org,vger.kernel.org,lists.infradead.org,lists.linux.dev,hygon.cn];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[huangsj@hygon.cn,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[huangsj@hygon.cn,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[65];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[linux-nvdimm,kernel];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,hygon.cn:from_mime,hygon.cn:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,hsj-2U-Workstation:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B5D97676DAE

Hi Lorenzo & Pedro,
On Thu, Jun 11, 2026 at 04:52:54PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> > Use mapping_mapped() to simplify the code, make
> > the code tidy and clean.
> >
> > Signed-off-by: Huang Shijie <huangsj@hygon.cn>
> 
> Yeah as Pedro said this one could just be sent separately, and I in fact
> suggest you do that :) So:
> 
Thank you Pedro and Lorenzo.
I can send a separate patch later.

Thanks
Huang Shijie


