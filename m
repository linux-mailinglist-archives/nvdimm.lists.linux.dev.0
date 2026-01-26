Return-Path: <nvdimm+bounces-12872-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iI7IOamsd2kZkAEAu9opvQ
	(envelope-from <nvdimm+bounces-12872-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 19:04:25 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4263F8BE2A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 19:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7CCC304F376
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Jan 2026 18:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDB7330679;
	Mon, 26 Jan 2026 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UqD1z5c3"
X-Original-To: nvdimm@lists.linux.dev
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C762F6907
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450662; cv=none; b=EYWDlV51PeCXJX1wWlP8ilwnyKq5+R0ASn6EuTyvoOLS9HCwWloCw37gPS/8wHHDtrnNCTvafXGZYDejxkerkkqspkhTSjjLHRcnagAkAGhKmByHas10/gIHkBh6XxxrITMy6XcxsnF45kLqLEWTcYi0Nb5C8/x8Wl0ViRDlxvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450662; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Bn3dyw29+qOIyK5guU26oMlK10zMs/U76s0kcPrY6CSpsxbGoV/IZnWN89RgmgUznZNwAHazu39NoEyaHauPNKWVPtnsBZVAFgOAV2abNVGIp56t1dF1JgTf1GMlZCSxq5wV5sxfeDnp5wnhrFDw1Tt4IhRYmn9GwQ0maTmztvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UqD1z5c3; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260126180419epoutp01f6faded248780fb53d62922f114fc757~OWf-mL2fn0787907879epoutp01p
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:04:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260126180419epoutp01f6faded248780fb53d62922f114fc757~OWf-mL2fn0787907879epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769450659;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=UqD1z5c3rrBDCN/viz3QvoOVfXGxVFAKiDNR1EKO0RBBzqbdOuwVFfcPk0zqTpcaI
	 lVycUjtvG/1SBXT7NgnXjPjzNCBM0c5HUBEPIxfx+IOcYH5L0AlnBje/SmNKGuDnQ6
	 RmyexlulJ8q7KWfZWMVkf778tHKRQp4Xw3BBF1Dg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260126180418epcas5p4e467dd4fb8c3d415158073b014e1f56f~OWf-LSMrq1794617946epcas5p48;
	Mon, 26 Jan 2026 18:04:18 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f0GdG0fRkz2SSKY; Mon, 26 Jan
	2026 18:04:18 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260126180417epcas5p32557baf3db90c96f454f596d2029e444~OWf92Ive12356823568epcas5p3t;
	Mon, 26 Jan 2026 18:04:17 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260126180415epsmtip2c494953f658c1c795b6b2001a6d50d10~OWf8XVjSK3252332523epsmtip2g;
	Mon, 26 Jan 2026 18:04:15 +0000 (GMT)
Message-ID: <5fda7607-c7cb-492d-9258-2492ff26b455@samsung.com>
Date: Mon, 26 Jan 2026 23:34:14 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/15] block: prepare generation / verification helpers
 for fs usage
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260121064339.206019-5-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260126180417epcas5p32557baf3db90c96f454f596d2029e444
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121064407epcas5p264c827b685831323745c7cdb350d2e1f
References: <20260121064339.206019-1-hch@lst.de>
	<CGME20260121064407epcas5p264c827b685831323745c7cdb350d2e1f@epcas5p2.samsung.com>
	<20260121064339.206019-5-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DKIM_TRACE(0.00)[samsung.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12872-lists,linux-nvdimm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,samsung.com:dkim,samsung.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 4263F8BE2A
X-Rspamd-Action: no action

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

