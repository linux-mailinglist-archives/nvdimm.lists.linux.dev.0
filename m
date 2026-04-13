Return-Path: <nvdimm+bounces-13853-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ESDIdcK3WngZAkAu9opvQ
	(envelope-from <nvdimm+bounces-13853-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 17:25:11 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C29D3EDE8F
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 17:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26D003058E25
	for <lists+linux-nvdimm@lfdr.de>; Mon, 13 Apr 2026 15:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEC73C4575;
	Mon, 13 Apr 2026 15:19:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1AC3B8BD5
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093599; cv=none; b=IGnik8A4X8Lxe6U6g49KtcRFY3jqZVaY8ljBtTQweHZUN6r8xOU7urkOnzSCe76gIj+eMTipppDepw6ixVeNnQOAUJzSCM7PeU0NhH5kOunZxExQUkeUSVglhzP9x8WIHUU4R4p4gndi1cpz3W/m/YA1al9tibfckSm1W0llJLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093599; c=relaxed/simple;
	bh=JXRMc0wy+BbDeeQTxXicS4g9lB0JzeS51S6VXGCc5uQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+ZyTeyiFCIdUnjJEkbxYR61iPF5lRzgJiLkK1NXBxdecdRYxtmAPwblkbCwszl+TI46HD+P8cpTnqHbDgNc9MGr2pOqvN/m9byIX5Q7B+wWYnhuD0y2wVJ66XZFslaxydqqsxhE5uJvpfBjN6d3V9sgEUzK4k8kTyWqqwCksYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fvWKJ1hgwzJ46Zv;
	Mon, 13 Apr 2026 23:19:16 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 41C574058B;
	Mon, 13 Apr 2026 23:19:56 +0800 (CST)
Received: from localhost (10.203.86.132) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 13 Apr
 2026 16:19:55 +0100
Date: Mon, 13 Apr 2026 16:19:54 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Dan
 Carpenter" <dan.carpenter@linaro.org>, John Groves <John@Groves.net>
Subject: Re: [PATCH] dax/fsdev: fix uninitialized kaddr in
 fsdev_dax_zero_page_range()
Message-ID: <20260413161954.00006daf@huawei.com>
In-Reply-To: <0100019d8262cda2-9714d31c-8fc1-4ca5-b32d-4df678240d14-000000@email.amazonses.com>
References: <20260412154944.461748-1-john@jagalactic.com>
	<0100019d8262cda2-9714d31c-8fc1-4ca5-b32d-4df678240d14-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Spamd-Result: default: False [0.04 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13853-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,huawei.com:mid,groves.net:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,jagalactic.com:email]
X-Rspamd-Queue-Id: 2C29D3EDE8F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 12 Apr 2026 15:50:06 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <John@Groves.net>
> 
> __fsdev_dax_direct_access() returns -EFAULT without setting *kaddr when
> dax_pgoff_to_phys() returns -1 (pgoff out of range). The return value
> was ignored, leaving kaddr uninitialized before being passed to
> fsdev_write_dax().
> 
> Check the return value and propagate the error.
> 
> Thanks to Dan Carpenter and the smatch project for reporting this.
> 
> Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

