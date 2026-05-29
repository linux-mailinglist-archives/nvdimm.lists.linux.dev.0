Return-Path: <nvdimm+bounces-14228-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIeXOXIoGmrR1wgAu9opvQ
	(envelope-from <nvdimm+bounces-14228-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 01:59:46 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 416AD609FD8
	for <lists+linux-nvdimm@lfdr.de>; Sat, 30 May 2026 01:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1B5C303D4C6
	for <lists+linux-nvdimm@lfdr.de>; Fri, 29 May 2026 23:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB103815EF;
	Fri, 29 May 2026 23:59:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275BA33D6F7
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780099175; cv=none; b=ZAHRzbSa6QoUcN9hZ2IWOKJZxOr99XCbmkdKst3Es6XxUI7tMVPIf+Ws2LbDvmIjVvvyu4pmLUNA3Ae6cStww6R8jGAuHhjNJRDDhHVT22tP2knCZ70RNTTS9W0Chll6IvDvxkMX+OBVf4Rr9JafoOZx1IaNV70DniuOQlRDQXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780099175; c=relaxed/simple;
	bh=YScupLwqyz7QCOIQyPueQI+phNqaX7MeGyOhFAKpMdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAG8O5ITzlxTxJ+KQcWSFFKsr8mUNMGQ29zWQvonTSLTsrLmoDT7/DX+tCrQqJCnv5Bqms9NDXoWx//yUXrR7c1IrTmbZ+hJUY+YqcPWWl2XNq1wu02Ly0dWednKH7LAPwThr4WIKu8VGVuVaQWGrb7pv5KcwkCPrtrLZvrvf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 126DF1616CB;
	Fri, 29 May 2026 23:59:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id 4B1F72000F;
	Fri, 29 May 2026 23:59:28 +0000 (UTC)
Date: Fri, 29 May 2026 18:59:27 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 2/7] dax/fsdev: fix multi-range offset, vmemmap_shift
 leak, and probe error cleanup
Message-ID: <ahooRHGgIePlaC7-@groves.net>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191851.79150-1-john@jagalactic.com>
 <0100019e51205fc2-9b729b27-3485-44a0-98b2-ea56189c192e-000000@email.amazonses.com>
 <0e68254a-b57a-4210-a2c2-7dce2a3e5256@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e68254a-b57a-4210-a2c2-7dce2a3e5256@intel.com>
X-Stat-Signature: oztuwrjpsmobxxtfhkdsxxywqacw46em
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/Lpfpm5Qu6C/BLudmgUp4Pc0YdtEjl9RM=
X-HE-Tag: 1780099168-55546
X-HE-Meta: U2FsdGVkX187JhgciOxCqkeSIW29B9adh6G7nyXuUU/ueR3qo1iA28pREKSnB7Bsg2WJoCzSUAhEAUZEDcrkN3Y7KGpw+VJqcvtZC24aHZ62+hZt6LGWji/fBcHw+9fo4Wvo+FNe/OQLnqGQKyjKJYJ4pPS/sCBCncAwC2142jBd3tTthhCD07iaOcaD2MaSz2egRSKT/pXIWEXjfxlNqLTaqgb9AvY0PFQtS7A8+QAqUmcPDSxT83M5k3ReE3ZUVKZJ5fqGzE4oSr7rygrahzeCwHcGdRrf3HFWRfYg2KzqmFptVoc9adlXMfj3UptyiO8xeA6KLUNhPwWEP4Tqk3bAay4/B0Frvlm4+GcGD2rmHWt5f2tT8Nngjmkz/N9C
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_FROM(0.00)[bounces-14228-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[John@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,groves.net:mid,groves.net:email]
X-Rspamd-Queue-Id: 416AD609FD8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 26/05/26 04:22PM, Dave Jiang wrote:
> 
> 
> On 5/22/26 12:18 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Three fixes for fsdev.c:
> > 
> > 1. Fix memory_failure offset calculation for multi-range devices.
> >    The old code subtracted ranges[0].range.start from the faulting PFN's
> >    physical address, which produces an incorrect (inflated) logical offset
> >    when the PFN falls in ranges[1] or beyond due to physical gaps between
> >    ranges. Add fsdev_pfn_to_offset() to walk the range list and compute
> >    the correct device-linear byte offset.
> > 
> > 2. Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a
> >    static device from device_dax (which may set vmemmap_shift based on
> >    alignment) to fsdev_dax, the stale vmemmap_shift persists on the
> >    shared pgmap. Explicitly zero it before devm_memremap_pages() so the
> >    vmemmap is built for order-0 folios as fsdev requires.
> > 
> > 3. Clear dev_dax->pgmap on probe failure for dynamic devices. After the
> >    dynamic path sets dev_dax->pgmap, if a later probe step fails, devres
> >    frees the devm_kzalloc'd pgmap but leaves dev_dax->pgmap dangling.
> >    Subsequent probe attempts would hit the "dynamic-dax with pre-populated
> >    page map" check and fail permanently. Use a goto cleanup to NULL
> >    dev_dax->pgmap on error.
> 
> 3 fixes, 3 separate patches?
> 
> DJ

Yes, thanks. Done.

John

<snip>


