Return-Path: <nvdimm+bounces-1420-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id D169E4193A2
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Sep 2021 13:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 871D03E1045
	for <lists+linux-nvdimm@lfdr.de>; Mon, 27 Sep 2021 11:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21DD3FD4;
	Mon, 27 Sep 2021 11:51:26 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948C3FC8
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 11:51:24 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 566C667373; Mon, 27 Sep 2021 13:51:16 +0200 (CEST)
Date: Mon, 27 Sep 2021 13:51:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: nvdimm@lists.linux.dev, hch@lst.de, linux-fsdevel@vger.kernel.org
Subject: Re: [regression] fs dax xfstests panic
Message-ID: <20210927115116.GB23909@lst.de>
References: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 27, 2021 at 02:17:47PM +0800, Murphy Zhou wrote:
> Hi folks,
> 
> Since this commit:
> 
> commit edb0872f44ec9976ea6d052cb4b93cd2d23ac2ba
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Aug 9 16:17:43 2021 +0200
> 
>     block: move the bdi from the request_queue to the gendisk
> 
> 
> Looping xfstests generic/108 or xfs/279 on mountpoints with fsdax
> enabled can lead to panic like this:

Does this still happen with this series:

https://lore.kernel.org/linux-block/20210922172222.2453343-1-hch@lst.de/T/#m8dc646a4dfc40f443227da6bb1c77d9daec524db

?

