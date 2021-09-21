Return-Path: <nvdimm+bounces-1370-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 505D3413081
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 10:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 416D31C09AB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Sep 2021 08:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2ED03FCD;
	Tue, 21 Sep 2021 08:54:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229063FC8
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 08:54:33 +0000 (UTC)
Date: Tue, 21 Sep 2021 17:47:26 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1632214055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEhHJWpJC24ILJLlDw0Or37rjxqKPmeVeQEfaqhpy6c=;
	b=QSCAqLFF96h3MVBqda8tq/9/dWdSkHGqE5wl6ic0NIdaZh98Ws9FmN4heWGHvrwKMWF60O
	zKDB5XeoJ8ZGox6e+JvzjILBdvl664XOdSxr1RFbR5qlEuQN2J8njVjyNO0uhqnABBBF4V
	//NmdgT7RKAHOF5GtRyDQSoMwABkzo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Naoya Horiguchi <naoya.horiguchi@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, naoya.horiguchi@nec.com, linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] mm: don't include <linux/dax.h> in <linux/mempolicy.h>
Message-ID: <20210921084726.GA812038@u2004>
References: <20210921082253.1859794-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210921082253.1859794-1-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: naoya.horiguchi@linux.dev

On Tue, Sep 21, 2021 at 10:22:53AM +0200, Christoph Hellwig wrote:
> Not required at all, and having this causes a huge kernel rebuild
> as soon as something in dax.h changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

