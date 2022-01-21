Return-Path: <nvdimm+bounces-2528-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8AC495A81
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 Jan 2022 08:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 924831C0964
	for <lists+linux-nvdimm@lfdr.de>; Fri, 21 Jan 2022 07:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9672CA9;
	Fri, 21 Jan 2022 07:17:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1049029CA
	for <nvdimm@lists.linux.dev>; Fri, 21 Jan 2022 07:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yFPxDUUe1fppNO0I1fDa7AQSMUJ89zWSqQ4St/CxUW8=; b=re5gJo5P3fM6JbXabIyQgDSFuL
	2/c/R1kbmGwM9wnFvcVIbtFV6CPKFG9KTLSuDQkKjGa7WNFhDfqwXK8gLbDqtDaEMLLkSvfF1Rw68
	m15Kn9nvJWBn4B4wYwj1beL1ETujNA/HHaYmLvJM1tinQimQSEbY3tHoWaFsZhrCy0q7ReWHsApIq
	7FNG6Ycsi2kWOXn0+33z2cwtPVagIqc4tKLK2Q0YpAKyEXB6MkHql2Px/ou3XS9ptRM0ecbOxqpQB
	qLixJ458q3LMWO/T57T734HDJV6QUdtx8nSwdkI9MtVzW4rRmkebbT/b2TvZFx5kS+5khxoY0iyXY
	j6+9XE0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nAoAu-00E2IP-QD; Fri, 21 Jan 2022 07:17:32 +0000
Date: Thu, 20 Jan 2022 23:17:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	david <david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
Message-ID: <YepeDLO5VNWsmV0J@infradead.org>
References: <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com>
 <20220105185626.GE398655@magnolia>
 <CAPcyv4h3M9f1-C5e9kHTfPaRYR_zN4gzQWgR+ZyhNmG_SL-u+A@mail.gmail.com>
 <20220105224727.GG398655@magnolia>
 <CAPcyv4iZ88FPeZC1rt_bNdWHDZ5oh7ua31NuET2-oZ1UcMrH2Q@mail.gmail.com>
 <20220105235407.GN656707@magnolia>
 <CAPcyv4gUmpDnGkhd+WdhcJVMP07u+CT8NXRjzcOTp5KF-5Yo5g@mail.gmail.com>
 <YekhXENAEYJJNy7e@infradead.org>
 <76f5ed28-2df9-890e-0674-3ef2f18e2c2f@fujitsu.com>
 <20220121022200.GG13563@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121022200.GG13563@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 20, 2022 at 06:22:00PM -0800, Darrick J. Wong wrote:
> Hm, so that means XFS can only support dax+pmem when there aren't
> partitions in use?  Ew.

Yes.  Or any sensible DAX usage going forward for that matter.

> 
> > >   (2) extent the holder mechanism to cover a rangeo
> 
> I don't think I was around for the part where "hch balked at a notifier
> call chain" -- what were the objections there, specifically?  I would
> hope that pmem problems would be infrequent enough that the locking
> contention (or rcu expiration) wouldn't be an issue...?

notifiers are a nightmare untype API leading to tons of boilerplate
code.  Open coding the notification is almost always a better idea.

