Return-Path: <nvdimm+bounces-13819-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gBltHLrr1Wkd/QcAu9opvQ
	(envelope-from <nvdimm+bounces-13819-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 08 Apr 2026 07:46:34 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C090D3B7588
	for <lists+linux-nvdimm@lfdr.de>; Wed, 08 Apr 2026 07:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BE573018740
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Apr 2026 05:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E16352C54;
	Wed,  8 Apr 2026 05:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ov/SnaXx"
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE60F1EB5C2;
	Wed,  8 Apr 2026 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627187; cv=none; b=FB2Z34kF7MaKymezLjjrOaXhe5XoEOMzzLcIDoYf0iu463QpvKU0yGhkxRGwZlhGe00nPqYCV7eUjCR+X84e/+dDIt5MS+GdLHgZ38RlnLD/gys3pqOuH7Wl6JHyPM/bCjdaIeWxi63BndJJr7n0waLLi1FotbnvOquOg4/m8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627187; c=relaxed/simple;
	bh=c3uM1Hh9/Z5cghwcYPpZ0G1u1yDL6hE+sM8tckvWT1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGC665zyUrgNzmxhtFcqG7MgDt/Azh+YRVm8ijYLqh22+CUzigVURSeTxL5dsD5HJy2M6Q0eqgIpaC3aa1J/w/Wyf0HWliMEXTSZuUKaeazFizAnrXuT8eZGoWtXMwT1T7hoW5ZaJzHIijteCLfsYzHz34O7U/xS/odhpQw77nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ov/SnaXx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nm4J6cVc9fv225rRNI935mcVaIP0KdgRI26cZBTikF8=; b=Ov/SnaXx0Q/Z3SkamNyHpx+8C2
	4DAfg6g37LD/hoZIyT0kwZLa+zeFZINYdTT4lP5m9A3lydgLDzTDG96mJxUpBwi9oCLPUCXXtffua
	Fk91CKv8eSaPUa8ZUIUhvfhSYA+VJvfIA2X2W7AQ2Ob5UoKCCgoqYn+WZoTA8PK6CYeeiZ4sh9Xus
	iZ6mZ4Sg2QAOkhVCQ+8Obt5oq9klPhSD2OVtmNJ2jXwargl3U7vJ99bpdqjOfXZDioRPKeHvpw7Jo
	6U0tucfgyIgJVIMa/jx+X0lzn4ctkaDG5x6/mXgvfxZC7p8iyZ8pWBy44hiN6xQrXT1aeZaixXNjD
	vDoAJZHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wALkA-00000008IWy-0vEj;
	Wed, 08 Apr 2026 05:46:26 +0000
Date: Tue, 7 Apr 2026 22:46:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org,
	Joel Colledge <joel.colledge@linbit.com>,
	an Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH 08/20] drbd: add DAX/PMEM support for metadata access
Message-ID: <adXrslkhromDtu37@infradead.org>
References: <20260327223820.2244227-1-christoph.boehmwalder@linbit.com>
 <20260327223820.2244227-9-christoph.boehmwalder@linbit.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327223820.2244227-9-christoph.boehmwalder@linbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13819-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Queue-Id: C090D3B7588
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Adding the dax maintainers and they really need to review this.

> +	long want = (drbd_md_last_sector(bdev) + 1 - first_sector) >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	pgoff_t pgoff = first_sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	long md_offset_byte = (bdev->md.md_offset - first_sector) << SECTOR_SHIFT;
> +	long al_offset_byte = (al_sector - first_sector) << SECTOR_SHIFT;

You really want helpers to make all these unit conversions maintainable.


