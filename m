Return-Path: <nvdimm+bounces-7146-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 605B182B388
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jan 2024 18:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB2B1B26C5A
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Jan 2024 17:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAED524A3;
	Thu, 11 Jan 2024 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhLz2v4f"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF3351C5E
	for <nvdimm@lists.linux.dev>; Thu, 11 Jan 2024 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704992368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wx+dOtvAsy73MShjXLqNM5VTysHMNDO8WgMjL3CrPKg=;
	b=fhLz2v4fS2kjUPi8GiGM88WV3C7KRzBLyzR7dLHx87dp7I3/7CYuGGuwxa0FnqQ78iplnT
	kGnRnxn3PfCEtTU4HuxWVfyCpxcl9hIqTossOpLYiSzS5wzR2ZrESy08DDY8MlaSgSyNOw
	rr/EUUFlhNaBA8bx2eR2dBsqdKbJVSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-cgLKHKK8MuueJDOmIUcLFg-1; Thu, 11 Jan 2024 11:59:23 -0500
X-MC-Unique: cgLKHKK8MuueJDOmIUcLFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65169108BF30;
	Thu, 11 Jan 2024 16:59:23 +0000 (UTC)
Received: from redhat.com (unknown [10.22.17.159])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDCE640C6EB9;
	Thu, 11 Jan 2024 16:59:22 +0000 (UTC)
Date: Thu, 11 Jan 2024 10:59:21 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, djwong@kernel.org,
	chandan.babu@oracle.com, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <ZaAeaRJnfERwwaP7@redhat.com>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
> FSDAX and reflink can work together now, let's drop this warning.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Are there any updates on this?
Thanks-
Bill


> ---
>  fs/xfs/xfs_super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1f77014c6e1a..faee773fa026 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>  		return -EINVAL;
>  	}
>  
> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  	return 0;
>  
>  disable_dax:
> -- 
> 2.42.0
> 


