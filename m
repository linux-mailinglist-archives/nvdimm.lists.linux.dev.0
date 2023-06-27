Return-Path: <nvdimm+bounces-6231-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C15C973FFF7
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jun 2023 17:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E30281088
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jun 2023 15:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438F419939;
	Tue, 27 Jun 2023 15:44:40 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7530B182AB
	for <nvdimm@lists.linux.dev>; Tue, 27 Jun 2023 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5OQ81fP5MT/p2WsB3Y4qNkUUEhdkT8Ufx9BbHjrAEbA=; b=FWVHHoNlfAUSWj7ka/pCDSK0++
	SWDM/XEPrDvTwyoUL2l8ZbKiwIjlzLtT+XeR/zCp/mxEJsSuW1gbUXCKdSGk1bAnDmX8YEW63MPLe
	51ySaTyvfy7uQf72BWCkBY70FwJzRfi8Vikc8OcuMD27S3jUWxIDKYvZga77pTyT/qx8wzm3nn2p1
	v2X5IQDuY4fE5mqCWq2yQ/3n2lZacpfxypxdliaJdlFl3+N4a3kv8EYqAd2zvEbH6lq3VV3RuaWnn
	sJYMegxILw3EWuWCOH/UA8z5UEAEAQr6u1Ob6LzjW/ajVTxpxRQtlVtsmiHpXfPGJhXyhUqSGpq3u
	HtEegAJA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qEAW6-002q7Q-Q9; Tue, 27 Jun 2023 15:22:07 +0000
Date: Tue, 27 Jun 2023 16:22:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Jane Chu <jane.chu@oracle.com>, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [v5 0/1] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
Message-ID: <ZJr+ngIH877t9seI@casper.infradead.org>
References: <20230615181325.1327259-1-jane.chu@oracle.com>
 <b57afc45-6bf8-3849-856f-2873e60fcf97@web.de>
 <18ca0017-821b-595c-0d5a-25adb04196c1@oracle.com>
 <be3db57c-29d0-cfc9-f0cc-1765b672c57e@web.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be3db57c-29d0-cfc9-f0cc-1765b672c57e@web.de>

On Tue, Jun 27, 2023 at 08:08:19AM +0200, Markus Elfring wrote:
> > The thought was to put descriptions unsuitable for commit header in the cover letter.
> 
> How do you think about to put additional information below triple dashes
> (or even into improved change descriptions)?
> 
> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.4#n686

Markus,

Please go away.  Your feedback is not helpful.  Thank you.

