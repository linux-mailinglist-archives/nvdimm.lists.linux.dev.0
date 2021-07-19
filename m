Return-Path: <nvdimm+bounces-563-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7540A3CE076
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 18:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id BFFB53E1062
	for <lists+linux-nvdimm@lfdr.de>; Mon, 19 Jul 2021 16:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24932FB3;
	Mon, 19 Jul 2021 16:00:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6170
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 16:00:50 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 268EC613ED;
	Mon, 19 Jul 2021 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626710450;
	bh=AyDppAbQr+ozfywAjYIPhhIzoe8rAsZVoJN4/3CPOIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wnl3yXmLuWrHkJUM12djk5eyKICfd2Mb5AFrsLl01gUKn8MPzQFQUWfZcq98UIBC7
	 Jb23Oov3tZv20IdGYkxV67dHUrU2IX4KiGv8h09kZ3VRF9NxSRTF1JRIAEHhHp/rPm
	 ZggjeP6kD5oT45pykGXdv5VG95PnJZm9ZofAdfbKh/xJK+bfMc40JwAcZIrcj1a401
	 hElKVPQ2J/Xk0dpYS18OES3ZXQIvl+C4tZC9NIH+v0kQtSB8p7jGam4W88F8J75Mmz
	 VtNFcRUHRSrNuVLvucYfQzCXOf0no6enfG96vlwZmGyIr3bMdkif0Ub7ZIAnZwKmPl
	 HjRU2/Fi04RMw==
Date: Mon, 19 Jul 2021 09:00:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 01/27] iomap: fix a trivial comment typo in trace.h
Message-ID: <20210719160049.GC22402@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-2-hch@lst.de>

On Mon, Jul 19, 2021 at 12:34:54PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
> index fdc7ae388476f5..e9cd5cc0d6ba40 100644
> --- a/fs/iomap/trace.h
> +++ b/fs/iomap/trace.h
> @@ -2,7 +2,7 @@
>  /*
>   * Copyright (c) 2009-2019 Christoph Hellwig
>   *
> - * NOTE: none of these tracepoints shall be consider a stable kernel ABI
> + * NOTE: none of these tracepoints shall be considered a stable kernel ABI
>   * as they can change at any time.
>   */
>  #undef TRACE_SYSTEM
> -- 
> 2.30.2
> 

