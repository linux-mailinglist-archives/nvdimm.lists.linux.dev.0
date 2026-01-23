Return-Path: <nvdimm+bounces-12804-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8I+nKJ4Qc2klsAAAu9opvQ
	(envelope-from <nvdimm+bounces-12804-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Jan 2026 07:09:34 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C7F870C5A
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Jan 2026 07:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C12BB3028648
	for <lists+linux-nvdimm@lfdr.de>; Fri, 23 Jan 2026 06:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E3639F8A8;
	Fri, 23 Jan 2026 06:08:46 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C236072A
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 06:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148520; cv=none; b=iZlUoRKML6s5dWaNF0EGgSyDwyYhOY57V42hXPwNqTf3RaL/sz+SfhSARcKamNnKOu6ZFkwrvBMMEUSQyeyuCapnp6ZdA1Y/3qoeSOQDfKa7i9rWWppEX/tk2GqKqOuM6k3vKMeI5dOG6zEy90PyRVLgYlTKV4942fNzDBeBPcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148520; c=relaxed/simple;
	bh=bXVV0ghNB3ZHWq8MaKQRXrwL+cr6NkZ++8gUPnQydeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9hvV479YZrC2oXMo56Fp9rPR6YXLGozdF82pt9+J4lBL10XT1NVG3LJIroL8CSyvQxNVR5+dwUK0044MghxrPV1x8s5Er49zK0PWhEUhCVC7nT7m/3fuwFq5fFU0soWcdoia88SltTwKu6lTwl+Ukud5paAjDSXbpT4v7lKNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E75EC227AAE; Fri, 23 Jan 2026 07:08:33 +0100 (CET)
Date: Fri, 23 Jan 2026 07:08:33 +0100
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
Subject: Re: [PATCH 02/15] block: factor out a bio_integrity_setup_default
 helper
Message-ID: <20260123060833.GA25528@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-3-hch@lst.de> <20260123000537.GG5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123000537.GG5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	NEURAL_HAM(-0.00)[-0.999];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-12804-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Queue-Id: 1C7F870C5A
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 04:05:37PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 21, 2026 at 07:43:10AM +0100, Christoph Hellwig wrote:
> > Add a helper to set the seed and check flag based on useful defaults
> > from the profile.
> > 
> > Note that this includes a small behavior change, as we ow only sets the
> 
> "...as we only set the seed if..." ?

Yes.

> > +void bio_integrity_setup_default(struct bio *bio)
> > +{
> > +	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
> > +	struct bio_integrity_payload *bip = bio_integrity(bio);
> > +
> > +	bip_set_seed(bip, bio->bi_iter.bi_sector);
> > +
> > +	if (bi->csum_type) {
> > +		bip->bip_flags |= BIP_CHECK_GUARD;
> > +		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
> 
> /me wonders if this should be a switch, but it'd be a pretty lame one.
> 
> 	switch (bi->csum_type) {
> 	case BLK_INTEGRITY_CSUM_NONE:
> 		break;
> 	case BLK_INTEGRITY_CSUM_IP:
> 		bip->bip_flags |= BIP_IP_CHECKSUM;
> 		fallthrough;
> 	case BLK_INTEGRITY_CSUM_CRC:
> 	case BLK_INTEGRITY_CSUM_CRC64:
> 		bip->bip_flags |= BIP_CHECK_GUARD;
> 		break;
> 	}

I don't really think that's a good idea here.  BIP_IP_CHECKSUM is a
really a special snowflake for SCSI HBA (and not even actual device)
usage, so it should be treated like a special snowflake with the if.
I sincerely hope no new special snowflakes will show up for the checksums
in the future.


