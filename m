Return-Path: <nvdimm+bounces-12904-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKFEFArbeGmwtgEAu9opvQ
	(envelope-from <nvdimm+bounces-12904-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:34:34 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C2996CE9
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD91D30538E6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 15:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EC735D606;
	Tue, 27 Jan 2026 15:16:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE335CBCB
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526975; cv=none; b=GjW4Vw/bzZeelH0J3ZS4BbLpwHg9UQ3xHpKGCKBbOsa9F87uOw5eCX6TsLrPDFll+QzKyhnlHwAPrV3vKwIQtlUUdF+ODfUxtqdB0StsizWauHSmvGUVuP2FHMY0gCH+x9ymVRcodcNa6Z2hYjuC871Iecmr7fJ/on4gcREwwgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526975; c=relaxed/simple;
	bh=pmEU1/GjeEWtU5JBXeKFHL6rzRm4Dv+qk3Ok9xl6wR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGBPzxlk+L2iHelif/LyBWxVGTVp0bpkgI+IlufhBeK8vxX840NTf05KVnUxe8oFGqGpLo3nwZsYpDXRoCsNmZftH3dq4HrZ/ltXihmZpkC1Nqrdo6lYoa0lX+OWsWmIMX+mILb6Oejsw7jKNFooz6El/MF5t5alkKBh2a+aZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EEDB227AAA; Tue, 27 Jan 2026 16:16:10 +0100 (CET)
Date: Tue, 27 Jan 2026 16:16:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: support file system generated / verified integrity information
Message-ID: <20260127151609.GA1883@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12904-lists,linux-nvdimm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,nvdimm@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: E1C2996CE9
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 08:24:28PM +0530, Anuj gupta wrote:
> Hi Christoph,
> 
> Here are the QD1 latency numbers (in usec)

Thanks a lot!

Adding in the baseline numbers, as I wanted to compare those:

> Intel Optane:
> 
> Sequential read
>   | size | baseline | xfs-bounce |  xfs-pi  |
>   +------+----------+-----------+-----------+
>   |   4k |    7.18  |    13.62   |     7.20 |
>   |  64K |   36.40  |    99.66   |    34.16 |
>   |   1M |  206.38  |   258.88   |   306.23 |
>   +------+----------+------------+----------+

So for 4k and 64k reads we basically get back to the baseline.
The 1M numbers are puzzling, though.  I wonder if we need to
add WQ_CPU_INTENSIVE or do some other tweaks to the XFS I/O
completion workqueue so that we don't overload the scheduler.

