Return-Path: <nvdimm+bounces-5970-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF926F0F3B
	for <lists+linux-nvdimm@lfdr.de>; Fri, 28 Apr 2023 01:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4204280C0B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 27 Apr 2023 23:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B2CAD22;
	Thu, 27 Apr 2023 23:48:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA164A95E
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Id5MRY6csHEAIIsWpDo8U+QRcsMChe0pvKJYUVbkiTw=; b=E4tcX0SO90gvZiDhw+vy7p9mK7
	IVDKsvFI1+xO294jdGE6g3uuZRS9vT9ODrLCSgePm+CAgSNhjxAHQX1Lok2YzWv8yN0WmDDP3FAY3
	TdHn3hQowDzhd2MQaLNe0MNI40WePW2xUr+bGNMkhcYgHlOGM1lT4pVDbwVzgl66yK6lelvYoxq08
	eQln+0WMuJL13DnbinnqclALtKIjb/MkbNu6tO8wjC7Xv3eyic1RHGpnSaiLYJ3MFDwtgnayz1fqH
	aoxQySM3VUVMgmp37tiTy59a/abVnCrvZEJWMqmkFeGRghmnoagtpQjJI9rdRARKyKuLaFVCd1O43
	5WP9Eyrw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1psBLb-0043WT-N4; Thu, 27 Apr 2023 23:48:23 +0000
Date: Fri, 28 Apr 2023 00:48:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
Message-ID: <ZEsJxwbIeq3jHDBT@casper.infradead.org>
References: <20230406230127.716716-1-jane.chu@oracle.com>
 <644aeadcba13b_2028294c9@dwillia2-xfh.jf.intel.com.notmuch>
 <a3c1bef3-4226-7c24-905a-d58bd67b89f1@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c1bef3-4226-7c24-905a-d58bd67b89f1@oracle.com>

On Thu, Apr 27, 2023 at 04:36:58PM -0700, Jane Chu wrote:
> > This change results in EHWPOISON leaking to usersapce in the case of
> > read(2), that's not a return code that block I/O applications have ever
> > had to contend with before. Just as badblocks cause EIO to be returned,
> > so should poisoned cachelines for pmem.
> 
> The read(2) man page (https://man.archlinux.org/man/read.2) says
> "On error, -1 is returned, and errno is set to indicate the error. In this
> case, it is left unspecified whether the file position (if any) changes."
> 
> If read(2) users haven't dealt with EHWPOISON before, they may discover that
> with pmem backed dax file, it's possible.

I don't think they should.  While syscalls are allowed to return errnos
other than the ones listed in POSIX, I don't think this is a worthwhile
difference.  We should be abstracting from the user that this is pmem
rather than spinning rust or nand.  So we should convert the EHWPOISON
to EIO as Dan suggests.

