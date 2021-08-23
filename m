Return-Path: <nvdimm+bounces-949-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E3E3F4B3B
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 14:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D8A101C0A79
	for <lists+linux-nvdimm@lfdr.de>; Mon, 23 Aug 2021 12:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9983FCB;
	Mon, 23 Aug 2021 12:58:28 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FB23FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:58:26 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A97B367357; Mon, 23 Aug 2021 14:58:24 +0200 (CEST)
Date: Mon, 23 Aug 2021 14:58:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v7 5/8] iomap: Introduce iomap_iter2 for two files
Message-ID: <20210823125824.GB15536@lst.de>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816060359.1442450-6-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 16, 2021 at 02:03:56PM +0800, Shiyang Ruan wrote:
> Some operations, such as comparing a range of data in two files under
> fsdax mode, requires nested iomap_begin()/iomap_end() on two files.
> Thus, we introduce iomap_iter2() to accept two iteraters to operate
> action on two files.

We really should not need both.  We should be able to be in two
nested loops, just operating on the part that both cover (for which
a helper might be useful).

