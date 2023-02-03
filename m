Return-Path: <nvdimm+bounces-5705-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B1D688BAF
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Feb 2023 01:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77E0728099F
	for <lists+linux-nvdimm@lfdr.de>; Fri,  3 Feb 2023 00:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F481A47;
	Fri,  3 Feb 2023 00:23:51 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A05A20
	for <nvdimm@lists.linux.dev>; Fri,  3 Feb 2023 00:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F2C433EF;
	Fri,  3 Feb 2023 00:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1675383829;
	bh=4LiI6LUcTbhezBBW+0OJ2nl0Sdx+u3H0eDkNbo0sxTA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dLkoEyZrHII+fisTY2H6Z4CnFrpYEZ4yIl8HhX2Gu9WBocrMso/ZngW0zJ4c5tjvx
	 g9wlrdSTDswuv348WlPjO2f7xlWc+RAJeXg+dSkqUrTeSO91tbcfeXClmjBqVbQQIS
	 1FhB/2pAgrGdZynTPbLxwC3i7ubh438rLf1vyoJA=
Date: Thu, 2 Feb 2023 16:23:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, djwong@kernel.org,
 david@fromorbit.com, dan.j.williams@intel.com
Subject: Re: [PATCH] fsdax: dax_unshare_iter() should return a valid length
Message-Id: <20230202162348.f90fea5cbff377b977f7b6b1@linux-foundation.org>
In-Reply-To: <Y9xAw+poZxOyMk1J@casper.infradead.org>
References: <1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com>
	<Y9xAw+poZxOyMk1J@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Feb 2023 23:01:23 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Thu, Feb 02, 2023 at 12:33:47PM +0000, Shiyang Ruan wrote:
> > The copy_mc_to_kernel() will return 0 if it executed successfully.
> > Then the return value should be set to the length it copied.
> > 
> > Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  fs/dax.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index c48a3a93ab29..a5b4deb5def3 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1274,6 +1274,7 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
> >  	ret = copy_mc_to_kernel(daddr, saddr, length);
> >  	if (ret)
> >  		ret = -EIO;
> > +	ret = length;
> 
> Umm.  Surely should be:
> 
> 	else
> 		ret = length;
> 
> otherwise you've just overwritten the -EIO.

yup

> And maybe this should be:
> 
> 	ret = length - copy_mc_to_kernel(daddr, saddr, length);
> 	if (ret < length)
> 		ret = -EIO;
> 

not a fan of giving `ret' a temporary new meaning like that.  If it was

	copied = length - copy_mc_to_kernel(daddr, saddr, length);
	if (copied < length)
		ret = -EIO;

then it would be clear.

Clearer, methinks:

	if (copy_mc_to_kernel(daddr, saddr, length) == 0)
		ret = length;
	else
		ret = -EIO;


