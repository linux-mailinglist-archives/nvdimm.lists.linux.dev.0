Return-Path: <nvdimm+bounces-5902-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C3C6C8616
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Mar 2023 20:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65C70280BE2
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Mar 2023 19:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B33D107BE;
	Fri, 24 Mar 2023 19:42:45 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4AB107BB
	for <nvdimm@lists.linux.dev>; Fri, 24 Mar 2023 19:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E167C4339C;
	Fri, 24 Mar 2023 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679686963;
	bh=cYdRTxR8dBazRdwhag620V6/LFVedTccg5+7XaXE0kY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ib/FgiIS5aIqzpEeYu3XpS3DTvGgv+D6xhqtJZadm/yN17y/6mRo7JEWo7osftdEo
	 by/OZtPRrnfTEfw8rTVR0sA70oEyd12C8yHEZY84tQgmSMREklqyTerS4rHv+m6sia
	 GLQXwjJ9lEylE+9CNvyNJ/7c9Cel2PhVIvUjjJ50=
Date: Fri, 24 Mar 2023 12:42:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-xfs@vger.kernel.org>, <dan.j.williams@intel.com>,
 <willy@infradead.org>, <jack@suse.cz>, <djwong@kernel.org>
Subject: Re: [PATCH] fsdax: force clear dirty mark if CoW
Message-Id: <20230324124242.c881cf384ab8a37716850413@linux-foundation.org>
In-Reply-To: <1679653680-2-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <1679653680-2-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Mar 2023 10:28:00 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> XFS allows CoW on non-shared extents to combat fragmentation[1].  The
> old non-shared extent could be mwrited before, its dax entry is marked
> dirty.  To be able to delete this entry, clear its dirty mark before
> invalidate_inode_pages2_range().

What are the user-visible runtime effects of this flaw?

Are we able to identify a Fixes: target for this?  Perhaps
f80e1668888f3 ("fsdax: invalidate pages when CoW")?

