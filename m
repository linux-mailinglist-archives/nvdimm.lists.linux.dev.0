Return-Path: <nvdimm+bounces-9380-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6735C9D03A0
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Nov 2024 13:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1410B25A22
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Nov 2024 12:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A88B194AEB;
	Sun, 17 Nov 2024 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="mTU1+u6c"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D6180A80;
	Sun, 17 Nov 2024 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731846327; cv=none; b=NIjNK0/lFIeBHmWB45zoBb20Ezce0+I5xCOG6auRfysrp/lkelPbC1yaqnazDOMgBgpSRRLQ09Kw8rJhoeBynGww/6C0/wKPnNKwg0ahIuQFpYltwdopkZaJIZYHrWIJBvVkkBuzSS9gf+PkvRUmLp/fYU/qdcrxGhj2tkZDVYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731846327; c=relaxed/simple;
	bh=2Vzu3RlYgWlUg+kP8l3nTLXS8GOcuKbfykkwWU/BOFg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KNLZoCRK3iAlyxQzAbLB4ykLlAVjKlXzuPqX++NdYnLGzVoLvJ6YUXPtZ1/9S842zXq4Ct4+AhiDUXdKFRYYA8FVIquwazj7dNM6JlxXSKYBbCph81iH7tqPRDtCFxSkPvADBrFo2cecrggUrgJJ4tPxpLJ1pb1+pm+9cK6d1LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=fail (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=mTU1+u6c reason="signature verification failed"; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731846322;
	bh=tp2Q+8b3zGUBih3afpuzhAn88G4uKrpXKwQ9ivMWqHM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mTU1+u6copmZDAjfqnXWv+2ujIPjQ3JtoGu9so550WGMXDTKHgPRUtKWL5WTQKacA
	 ukYIXyZnvXaIaM7phYyg2ffevuNcZwkVM+fGzA0yJe4hA6ivVJfsyMN2k5es56Dca2
	 xnyEpYxwi2vRkSTSXt4SDnE54vHeCtrhpgtS0p+MhXC1a/iPqUZ6noNUE4xD/tX6x3
	 9xyLmagErBzssEeKDZj2zkr4owFCFT2YctuTq6qJ9KGCJplX90TRwhVHol5EujIAFV
	 JLHuHIFQhKPYuj26daIFU9Gqj0sP+YYyQFfmqJ5wJevMLVh4tXn5ub20TQGEUboHP9
	 4WeeB6bi4EbDw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Xrqhp5Zp2z4xf5;
	Sun, 17 Nov 2024 23:25:14 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linux-gpio@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc: kernel-janitors@vger.kernel.org, audit@vger.kernel.org, linux-mtd@lists.infradead.org, Zhihao Cheng <chengzhihao1@huawei.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-mm@kvack.org, maple-tree@lists.infradead.org, alsa-devel@alsa-project.org, Sanyog Kale <sanyog.r.kale@intel.com>, Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, dccp@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, drbd-dev@lists.linbit.com, linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org, nvdimm@lists.linux.dev, linux-leds@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, tipc-discussion@lists.sourceforge.
 net, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-trace-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20240930112121.95324-1-Julia.Lawall@inria.fr>
References: <20240930112121.95324-1-Julia.Lawall@inria.fr>
Subject: Re: (subset) [PATCH 00/35] Reorganize kerneldoc parameter names
Message-Id: <173184539760.890800.14513086226459117952.b4-ty@ellerman.id.au>
Date: Sun, 17 Nov 2024 23:09:57 +1100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 30 Sep 2024 13:20:46 +0200, Julia Lawall wrote:
> Reorganize kerneldoc parameter names to match the parameter
> order in the function header.
> 
> The misordered cases were identified using the following
> Coccinelle semantic patch:
> 
> // <smpl>
> @initialize:ocaml@
> @@
> 
> [...]

Applied to powerpc/next.

[11/35] powerpc/ps3: Reorganize kerneldoc parameter names
        https://git.kernel.org/powerpc/c/276e036e5844116e563fa90f676c625bb742cc57

cheers

