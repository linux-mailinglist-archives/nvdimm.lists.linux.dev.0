Return-Path: <nvdimm+bounces-1368-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2101413004
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 10:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D4E6D1C0A22
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 08:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860243FCB;
	Tue, 21 Sep 2021 08:14:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878E72
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 08:14:18 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 241FF67373; Tue, 21 Sep 2021 10:14:15 +0200 (CEST)
Date: Tue, 21 Sep 2021 10:14:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	rgoldwyn@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH v9 7/8] xfs: support CoW in fsdax mode
Message-ID: <20210921081414.GA28927@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-8-ruansy.fnst@fujitsu.com> <20210916002227.GD34830@magnolia> <20210916063251.GE13306@lst.de> <20210917153304.GB10250@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917153304.GB10250@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 17, 2021 at 08:33:04AM -0700, Darrick J. Wong wrote:
> > More importantly before we can merge this series we also need the VM
> > level support for reflink-aware reverse mapping.  So while this series
> > here is no in a good enough shape I don't see how we could merge it
> > without that other series as we'd have to disallow mmap for reflink+dax
> > files otherwise.
> 
> I've forgotten why we need mm level reverse mapping again?  The pmem
> poison stuff can use ->media_failure (or whatever it was called,
> memory_failure?) to find all the owners and notify them.  Was there
> some other accounting reason that fell out of my brain?
> 
> I'm more afraid of 'sharing pages between files needs mm support'
> sparking another multi-year folioesque fight with the mm people.

Because of the way page->mapping is used by DAX.  But I think this is
mostly under control in the other series.

