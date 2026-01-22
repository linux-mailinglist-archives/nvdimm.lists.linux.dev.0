Return-Path: <nvdimm+bounces-12756-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GJQ0Ae+9cWkmLwAAu9opvQ
	(envelope-from <nvdimm+bounces-12756-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 07:04:31 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA37362288
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 07:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C64274F41AD
	for <lists+linux-nvdimm@lfdr.de>; Thu, 22 Jan 2026 06:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3609A3D300E;
	Thu, 22 Jan 2026 06:04:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306033ADBF
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061848; cv=none; b=fPaF4mPRtelCHjsncXMSeLK/0eJR3oL8K5DSiRmJTDMiUwbFwLY3nVF+ysGP9C8q2uoOsbfkQuAD7q9VCH9oeb/kVm7yQvj6Y1DP4eZo7K0x8JBGyFO5KSOPGPz9SQFu85/sqQD1rE21KG+zuWu286ojeLkhbZbpdHV6hRMWVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061848; c=relaxed/simple;
	bh=qL/6fhBAIeZg7aAiyzwJ0h1lBqVBWusJUvD+4Ey7hsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZz12ThCmiBoOFL0L7hdIlsb60R5P9YOUHV5Pq7+MCJZ4v79+QZpb55ZaiontkgIcFniuW1eDmEqFcfhVb5zkCNtLejkK61wajWbPyZg5H6ZTQOuiKJY2sC7CEcHClWmGuOQVoPyafLloarmQKtsTumnY/ufvV2xLIINh9jg+14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DA21227AA8; Thu, 22 Jan 2026 07:04:01 +0100 (CET)
Date: Thu, 22 Jan 2026 07:04:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to
 bio_iov_iter_bounce
Message-ID: <20260122060400.GD24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-8-hch@lst.de> <20260122010440.GT5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122010440.GT5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : No valid SPF, No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,nvdimm@lists.linux.dev];
	R_DKIM_NA(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_FROM(0.00)[bounces-12756-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: AA37362288
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 05:04:40PM -0800, Darrick J. Wong wrote:
> >  	if (dio->flags & IOMAP_DIO_BOUNCE)
> > -		ret = bio_iov_iter_bounce(bio, dio->submit.iter);
> > +		ret = bio_iov_iter_bounce(bio, dio->submit.iter, UINT_MAX);
> 
> Nitpicking here, but shouldn't this be SIZE_MAX?

bi_size can't store more than UINT_MAX, so I think this is correct.


