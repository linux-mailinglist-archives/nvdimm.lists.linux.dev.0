Return-Path: <nvdimm+bounces-4681-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6345B13B9
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Sep 2022 06:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07EAF1C209A4
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Sep 2022 04:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C05391;
	Thu,  8 Sep 2022 04:32:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980657C
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 04:31:57 +0000 (UTC)
Received: from nazgul.tnic (unknown [84.201.196.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D58771EC0662;
	Thu,  8 Sep 2022 06:31:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1662611506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=0nvDue4vLSHB9eljGkQK3Ucd2hQfwmu9py9vEraev3s=;
	b=kH7QR8UJR/Jv9S+ZatWpkDuGnAdOKHYhXeTVzGozo20k83qlg15fWg3pFKQTF1H6GtwI2s
	xYe0bIt84Dd4vIISvV352h9TTw0UCv0GVGAkv5JoH3h68zLptnyT5tUewIoIyjoKPuDIU+
	qtbtGkJi50Y5R1D6CoU4cv4+SD3ES4Y=
Date: Thu, 8 Sep 2022 06:31:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: dan.j.williams@intel.com, x86@kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, peterz@infradead.org,
	akpm@linux-foundation.org, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, a.manzanares@samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] memregion: Add arch_flush_memregion() interface
Message-ID: <YxlwPOp9pRrH1luo@nazgul.tnic>
References: <20220829212918.4039240-1-dave@stgolabs.net>
 <YxjBSxtoav7PQVei@nazgul.tnic>
 <20220907162245.5ddexpmibjbanrho@offworld>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220907162245.5ddexpmibjbanrho@offworld>

On Wed, Sep 07, 2022 at 09:22:45AM -0700, Davidlohr Bueso wrote:
> So the context here is:
> 
> e2efb6359e62 ("ACPICA: Avoid cache flush inside virtual machines")

Please add this to your commit message so that at least we know how this
HV dependency came about.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

