Return-Path: <nvdimm+bounces-5892-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BAF6C72C6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 23:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2DE61C208F6
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 22:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E2DD2FA;
	Thu, 23 Mar 2023 22:11:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE6BD2F1
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 22:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA892C433D2;
	Thu, 23 Mar 2023 22:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679609473;
	bh=yNzdXs0jlKa5oEb92maO/avegSZEB8iOyQikXYKNFeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MKMZJsBo3JVwF/EwV+ZZiu/BL2/G6BUDxJNzwFdFV1c9bnvrQ9sglF83b3IwZE85c
	 +HeLbn4sGozma+ZCDAmOlNJINZGiAbjdpCwO2heqzE98p5JsbnGz4igtWlVfKSD5Z7
	 sCRd2OCA7JYR8BrZG9jeXysK1e59jUtVYVhpcaqQ=
Date: Thu, 23 Mar 2023 15:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
 <djwong@kernel.org>
Subject: Re: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or
 UNWRITTEN
Message-Id: <20230323151112.1cc3cf57b35f2dc704ff1af8@linux-foundation.org>
In-Reply-To: <a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>
References: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
	<20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
	<a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 23 Mar 2023 14:50:38 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> 
> 
> 在 2023/3/23 7:03, Andrew Morton 写道:
> > On Wed, 22 Mar 2023 11:11:09 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > 
> >> unshare copies data from source to destination. But if the source is
> >> HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
> >> result will be unexpectable.
> > 
> > Please provide much more detail on the user-visible effects of the bug.
> > For example, are we leaking kernel memory contents to userspace?
> 
> This fixes fail of generic/649.

OK, but this doesn't really help.  I'm trying to determine whether this
fix should be backported into -stable kernels and whether it should be
fast-tracked into Linus's current -rc tree.

But to determine this I (and others) need to know what effect the bug
has upon our users.

