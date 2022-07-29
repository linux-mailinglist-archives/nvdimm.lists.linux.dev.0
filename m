Return-Path: <nvdimm+bounces-4439-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C309584AD8
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 Jul 2022 06:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50BE31C20A01
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 Jul 2022 04:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609CC1FBC;
	Fri, 29 Jul 2022 04:54:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A97A
	for <nvdimm@lists.linux.dev>; Fri, 29 Jul 2022 04:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9200BC433C1;
	Fri, 29 Jul 2022 04:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1659070452;
	bh=r+29KtQL8GX5O6yNf3ncNF/wVf3L2fZKUgMfQpxeBzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJr/UZKTrPIqn2V8TgJJDX5phjAuqJHF0TUTfF/H7HBl7xdbIXJ9cofvVRCetJvEa
	 LPideJ5gfrQ7IvJoM1uEbQ9hMoWGei19TR2LoJ1vbtxcF1wcsei/GOb8wPgK6pGKd1
	 widV38RrDNozmGqv5p/LbAEor4Xee4380dLaw93MKmgccrhdY4QpKWkfTuKAOeroGI
	 REanbewENM3vGfvR6qGvEvlAyQwE2vRimpWCCVh8e39IKGMKcQugDGb+pe2dpJ20ap
	 E9sweR3OWdLbfq8ay+5mUBstMxDMN+goCC9rClnutf3MMkOb6CYrKFkXCFEGoNX5AG
	 x24BAPXW+TBPw==
Date: Thu, 28 Jul 2022 21:54:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <YuNn9NkUFofmrXRG@magnolia>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
 <Yr5AV5HaleJXMmUm@magnolia>
 <74b0a034-8c77-5136-3fbd-4affb841edcb@fujitsu.com>
 <Ytl7yJJL1fdC006S@magnolia>
 <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>

On Fri, Jul 29, 2022 at 03:55:24AM +0000, ruansy.fnst@fujitsu.com wrote:
> 
> 
> 在 2022/7/22 0:16, Darrick J. Wong 写道:
> > On Thu, Jul 21, 2022 at 02:06:10PM +0000, ruansy.fnst@fujitsu.com wrote:
> >> 在 2022/7/1 8:31, Darrick J. Wong 写道:
> >>> On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
> >>>> Failure notification is not supported on partitions.  So, when we mount
> >>>> a reflink enabled xfs on a partition with dax option, let it fail with
> >>>> -EINVAL code.
> >>>>
> >>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> >>>
> >>> Looks good to me, though I think this patch applies to ... wherever all
> >>> those rmap+reflink+dax patches went.  I think that's akpm's tree, right?
> >>>
> >>> Ideally this would go in through there to keep the pieces together, but
> >>> I don't mind tossing this in at the end of the 5.20 merge window if akpm
> >>> is unwilling.
> >>
> >> BTW, since these patches (dax&reflink&rmap + THIS + pmem-unbind) are
> >> waiting to be merged, is it time to think about "removing the
> >> experimental tag" again?  :)
> > 
> > It's probably time to take up that question again.
> > 
> > Yesterday I tried running generic/470 (aka the MAP_SYNC test) and it
> > didn't succeed because it sets up dmlogwrites atop dmthinp atop pmem,
> > and at least one of those dm layers no longer allows fsdax pass-through,
> > so XFS silently turned mount -o dax into -o dax=never. :(
> 
> Hi Darrick,
> 
> I tried generic/470 but it didn't run:
>    [not run] Cannot use thin-pool devices on DAX capable block devices.
> 
> Did you modify the _require_dm_target() in common/rc?  I added thin-pool 
> to not to check dax capability:
> 
>          case $target in
>          stripe|linear|log-writes|thin-pool)  # add thin-pool here
>                  ;;
> 
> then the case finally ran and it silently turned off dax as you said.
> 
> Are the steps for reproduction correct? If so, I will continue to 
> investigate this problem.

Ah, yes, I did add thin-pool to that case statement.  Sorry I forgot to
mention that.  I suspect that the removal of dm support for pmem is
going to force us to completely redesign this test.  I can't really
think of how, though, since there's no good way that I know of to gain a
point-in-time snapshot of a pmem device.

--D

> 
> --
> Thanks,
> Ruan.
> 
> 
> 
> > 
> > I'm not sure how to fix that...
> > 
> > --D
> > 
> >>
> >> --
> >> Thanks,
> >> Ruan.
> >>
> >>>
> >>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >>>
> >>> --D
> >>>
> >>>> ---
> >>>>    fs/xfs/xfs_super.c | 6 ++++--
> >>>>    1 file changed, 4 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >>>> index 8495ef076ffc..a3c221841fa6 100644
> >>>> --- a/fs/xfs/xfs_super.c
> >>>> +++ b/fs/xfs/xfs_super.c
> >>>> @@ -348,8 +348,10 @@ xfs_setup_dax_always(
> >>>>    		goto disable_dax;
> >>>>    	}
> >>>>    
> >>>> -	if (xfs_has_reflink(mp)) {
> >>>> -		xfs_alert(mp, "DAX and reflink cannot be used together!");
> >>>> +	if (xfs_has_reflink(mp) &&
> >>>> +	    bdev_is_partition(mp->m_ddev_targp->bt_bdev)) {
> >>>> +		xfs_alert(mp,
> >>>> +			"DAX and reflink cannot work with multi-partitions!");
> >>>>    		return -EINVAL;
> >>>>    	}
> >>>>    
> >>>> -- 
> >>>> 2.36.1
> >>>>
> >>>>
> >>>>

