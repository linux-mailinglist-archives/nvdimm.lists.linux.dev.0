Return-Path: <nvdimm+bounces-5715-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCA568AF9B
	for <lists+linux-nvdimm@lfdr.de>; Sun,  5 Feb 2023 12:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0845A280A55
	for <lists+linux-nvdimm@lfdr.de>; Sun,  5 Feb 2023 11:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30E8290D;
	Sun,  5 Feb 2023 11:52:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F4728E8
	for <nvdimm@lists.linux.dev>; Sun,  5 Feb 2023 11:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oaSp1uDrEJSreK2BT15lm8D1/ywHnOELmkze9J1/9gs=; b=uHl/kG336RTMsqPHsblbXTQ2Z7
	N7KGy95S/8cHu6nmIqYAl1avvNVI8mS1yV0V4Vfhz+9MMF+GgwOa1N5sXrtr5VlqJnnQ8KtIeh6Gl
	C8dgU4wNjoG1CZkCLpvIakxfqaIKWavXC13nKWJqFeTENtN5r/490eaMim0kN3DCJA9If2qXKkgvd
	MZidgWXWOn1baMT8+mFy8pU4dqnFvWMX8c06sVQy26YM1P0TWiTyRwDGoidsqjvaIYnfHFoXeXJeS
	V6lTCQc1N8uhmT3bohmKWqGTo/NbpWaCnNA4ebDIwcZpbYRewkh9Z9RA7Wts1LRbGRZY2KRv/h/QU
	0SiYGRrg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pOdPa-00Fsbl-0T; Sun, 05 Feb 2023 11:42:22 +0000
Date: Sun, 5 Feb 2023 11:42:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v9 1/3] xfs: fix the calculation of length and end
Message-ID: <Y9+WHXyA2GufLWpw@casper.infradead.org>
References: <1675522718-88-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1675522718-88-2-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675522718-88-2-git-send-email-ruansy.fnst@fujitsu.com>

On Sat, Feb 04, 2023 at 02:58:36PM +0000, Shiyang Ruan wrote:
> @@ -222,8 +222,8 @@ xfs_dax_notify_failure(
>  		len -= ddev_start - offset;
>  		offset = 0;
>  	}
> -	if (offset + len > ddev_end)
> -		len -= ddev_end - offset;
> +	if (offset + len - 1 > ddev_end)
> +		len -= offset + len - 1 - ddev_end;

This _looks_ wrong.  Are you sure it shouldn't be:

		len = ddev_end - offset + 1;


