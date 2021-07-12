Return-Path: <nvdimm+bounces-455-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF8D3C6446
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Jul 2021 21:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 654F41C0DBD
	for <lists+linux-nvdimm@lfdr.de>; Mon, 12 Jul 2021 19:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584CD2F80;
	Mon, 12 Jul 2021 19:53:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtprelay.hostedemail.com (smtprelay0061.hostedemail.com [216.40.44.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FC470
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 19:53:37 +0000 (UTC)
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 08D44184F0471
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 16:15:03 +0000 (UTC)
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
	by smtprelay06.hostedemail.com (Postfix) with ESMTP id 20EEA181BDB94;
	Mon, 12 Jul 2021 16:14:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id CF5B920A297;
	Mon, 12 Jul 2021 16:14:54 +0000 (UTC)
Message-ID: <6fe3c15d985017ad4e7a266bcf214a711326f151.camel@perches.com>
Subject: Re: [PATCH] dax: replace sprintf() by scnprintf()
From: Joe Perches <joe@perches.com>
To: Salah Triki <salah.triki@gmail.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com,  nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Mon, 12 Jul 2021 09:14:53 -0700
In-Reply-To: <20210712122624.GB777994@pc>
References: <20210710164615.GA690067@pc>
	 <10621e048f62018432c42a3fccc1a5fd9a6d71d7.camel@perches.com>
	 <20210712122624.GB777994@pc>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: CF5B920A297
X-Spam-Status: No, score=1.53
X-Stat-Signature: dg9frhquxfqc8dkxcqj5z1gnfmbqt4nz
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+nBNFM9f63F3PVtFOORRYpE+8rW4mr8PA=
X-HE-Tag: 1626106494-476059

On Mon, 2021-07-12 at 13:26 +0100, Salah Triki wrote:
> On Sat, Jul 10, 2021 at 10:04:48AM -0700, Joe Perches wrote:
> > On Sat, 2021-07-10 at 17:46 +0100, Salah Triki wrote:
> > > Replace sprintf() by scnprintf() in order to avoid buffer overflows.
> > 
> > OK but also not strictly necessary.  DAX_NAME_LEN is 30.
> > 
> > Are you finding and changing these manually or with a script?
> > 
> > > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > []
> > > @@ -76,7 +76,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
> > >  	fields = sscanf(buf, "dax%d.%d", &region_id, &id);
> > >  	if (fields != 2)
> > >  		return -EINVAL;
> > > -	sprintf(devname, "dax%d.%d", region_id, id);
> > > +	scnprintf(devname, DAX_NAME_LEN, "dax%d.%d", region_id, id);
> > >  	if (!sysfs_streq(buf, devname))
> > >  		return -EINVAL;
> > >  
> > > 
> > 
> > 
> 
> since region_id and id are unsigned long may be devname should be
> char[21].

I think you need to look at the code a bit more carefully.

	unsigned int region_id, id;

Also the output is %d, so the maximum length of each output
int is 10 with a possible leading minus sign.

3 + 10 + 1 + 10 + 1.  So 25 not 21 which is too small.

The %d uses could be changed to %u to make it 23.
But really it hardly matters as 30 is sufficent and the
function call depth here isn't particularly high.

> I'm finding and changing these manually.

coccinelle could help.
https://coccinelle.gitlabpages.inria.fr/website/



