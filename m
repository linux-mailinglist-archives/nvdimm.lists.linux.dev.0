Return-Path: <nvdimm+bounces-12910-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zbI0F3MveWlovwEAu9opvQ
	(envelope-from <nvdimm+bounces-12910-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 22:34:43 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A68CB9AB7A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 22:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ADC6302D132
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 21:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DD8285050;
	Tue, 27 Jan 2026 21:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DjTBNLHT"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125641DE887;
	Tue, 27 Jan 2026 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769549673; cv=none; b=BejiWvRdA3EGolrRt0qD1ijIP6u1O0mtb9XIwTB+Nyism7YKKE38B2OWhbgX3WMfJloZuqF6yYhV6/jlp8GpA1bt1fxBgRxqTWBj79DKBMVuf6ofyThvT0s0aU/xLZR9eOvoenFyT2Eo01RyMyQTXT4v3bb5Wkxe+SJlzcryBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769549673; c=relaxed/simple;
	bh=bR9qRQiDPotvAWn2QIuk3A3vxmknksey0H/5pA0EgaU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bXpJh1ZTUVcelMli4IpSPVPCaPZ9uOofxPooLUbSb6nUhdQ1SVjiWnQpyPZYTBPkbMozLiUa7I6aosOTshdZGq9XCu5BkOFawqiSrJ5L4czbXVyBH6b/pE1VMDMLigxsRhg7R3vWlR76dU4RpH6La/FPjM+Juhrv8jOI11WyVAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DjTBNLHT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A5FC116C6;
	Tue, 27 Jan 2026 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769549672;
	bh=bR9qRQiDPotvAWn2QIuk3A3vxmknksey0H/5pA0EgaU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DjTBNLHTNOC+jXRWsQ6HIWju6jaCg17tDZSayr8cblHACDU+z7Syip8Gie1ClWfDk
	 YXi9aqZvE3iKKO+oV1rWm4swd+zSyWuVq6ApEnjlVtei99TwkJr9wfiAoy1CLgEKvE
	 lAlqYtdgL6tUK0UDATd8mL/cp6frej8XW69FO5PU=
Date: Tue, 27 Jan 2026 13:34:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, david@kernel.org, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 osalvador@suse.de
Subject: Re: [PATCH] dax/kmem: add build config for protected dax memory
 blocks
Message-Id: <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>
In-Reply-To: <20260115024222.3486455-1-gourry@gourry.net>
References: <20260114235022.3437787-6-gourry@gourry.net>
	<20260115024222.3486455-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux-foundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12910-lists,linux-nvdimm=lfdr.de];
	DMARC_NA(0.00)[linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux-foundation.org:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[akpm@linux-foundation.org,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux-foundation.org:mid,linux-foundation.org:dkim]
X-Rspamd-Queue-Id: A68CB9AB7A
X-Rspamd-Action: no action

On Wed, 14 Jan 2026 21:42:22 -0500 Gregory Price <gourry@gourry.net> wrote:

> Since this protection may break userspace tools, it should
> be an opt-in until those tools have time to update to the
> new daxN.M/hotplug interface instead of memory blocks.
> 
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -78,4 +78,22 @@ config DEV_DAX_KMEM
>  
>  	  Say N if unsure.
>  
> +config DEV_DAX_KMEM_PROTECTED

Users must rebuild and redeploy kernels after having updated a
userspace tool.  They won't thank us for this ;)

Isn't there something we can do to make this feature
backward-compatible?


