Return-Path: <nvdimm+bounces-9685-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2A3A052E5
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Jan 2025 06:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8C60166CB7
	for <lists+linux-nvdimm@lfdr.de>; Wed,  8 Jan 2025 05:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A07E1A257D;
	Wed,  8 Jan 2025 05:53:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E38199939
	for <nvdimm@lists.linux.dev>; Wed,  8 Jan 2025 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736315628; cv=none; b=h5NHKbn0OfXlD4A61FWVFc9GAqo8ELZCT82fpjSeXgmmG/Mb0Dc2piRLA0t+wafT+mgKLGcSiMBFfgxfX/RjP+XKWZ7NPHhluePuBIk83ZA3MjKSeUNafprntpnd5rzp490j00lUi65xXJ6G/06jVgvTv5RWkCU+9o4STRvXXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736315628; c=relaxed/simple;
	bh=0yp55jEfCimJ/twURXZICKIRcsnGSxEzmU/wFBj1rn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWrOetnVh9glY00u8e8uazRkwrmpw2AMPhbrLv9yVJmC5p+9Oq+FQ9M8ppaqUB7HK/Z+mlXWbVBpCFAxS2aSLv0RgwrbAHZkDfuR3jJLlj3298Gptg5dZDIKaLVDjMnHm0rU6t6Af3Yrx/T1ayIGrH6WtY4ZjobQaqhmti4M3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 622FB68BEB; Wed,  8 Jan 2025 06:53:43 +0100 (CET)
Date: Wed, 8 Jan 2025 06:53:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com,
	jgg@ziepe.ca, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de
Subject: Re: [RFC 4/4] mm: Remove include/linux/pfn_t.h
Message-ID: <20250108055343.GE20341@lst.de>
References: <cover.a7cdeffaaa366a10c65e2e7544285059cc5d55a4.1736299058.git-series.apopple@nvidia.com> <34dfcab0f529cb32b59e70c8bce132a9d82dc3f0.1736299058.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dfcab0f529cb32b59e70c8bce132a9d82dc3f0.1736299058.git-series.apopple@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I'd just merge this into the previous patch, but otherwise this looks
good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


