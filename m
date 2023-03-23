Return-Path: <nvdimm+bounces-5893-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0539A6C72C9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 23:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98906280A9F
	for <lists+linux-nvdimm@lfdr.de>; Thu, 23 Mar 2023 22:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9922D2FB;
	Thu, 23 Mar 2023 22:12:04 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96A6D2F1
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 22:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A44DC433AA;
	Thu, 23 Mar 2023 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679609522;
	bh=NPJ7rJHAWoXvOzSWrNmY2FKPUyh54zh3/+WwtjUeeZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h5KzCfwPb0Phb7owz/hHVi892GYAfI2mUZ43fBiSOl3tFnJfHYr4Oz4hZCnsxtIrp
	 /IlUGuq3VA3IaNbqAGwzyydoRiL+oLjNmo1c5jlrnYh8G5PdrIhX/4ub3HRcYDZDVv
	 lcYGdsoCJFioAzmJWS03J2Uv9Mag6FFZxYwg+Ipc=
Date: Thu, 23 Mar 2023 15:12:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>
Subject: Re: [PATCH] fsdax: dedupe should compare the min of two iters'
 length
Message-Id: <20230323151201.98d54f8d85f83c636568eacc@linux-foundation.org>
In-Reply-To: <0d219eb0-0f58-e667-0d86-be158ea2030f@fujitsu.com>
References: <1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com>
	<20230322161236.f90c21c8f668f551ee19d80b@linux-foundation.org>
	<0d219eb0-0f58-e667-0d86-be158ea2030f@fujitsu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 23 Mar 2023 14:48:25 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> 
> 
> 在 2023/3/23 7:12, Andrew Morton 写道:
> > On Wed, 22 Mar 2023 07:25:58 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > 
> >> In an dedupe corporation iter loop, the length of iomap_iter decreases
> >> because it implies the remaining length after each iteration.  The
> >> compare function should use the min length of the current iters, not the
> >> total length.
> > 
> > Please describe the user-visible runtime effects of this flaw, thanks.
> 
> This patch fixes fail of generic/561, with test config:
> 
> export TEST_DEV=/dev/pmem0
> export TEST_DIR=/mnt/test
> export SCRATCH_DEV=/dev/pmem1
> export SCRATCH_MNT=/mnt/scratch
> export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
> export MOUNT_OPTIONS="-o dax"
> export XFS_MOUNT_OPTIONS="-o dax"

Again, how does the bug impact real-world kernel users?

Thanks.

