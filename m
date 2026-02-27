Return-Path: <nvdimm+bounces-13316-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qE0fLFScoWl8ugQAu9opvQ
	(envelope-from <nvdimm+bounces-13316-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Feb 2026 14:29:56 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2233C1B7A78
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Feb 2026 14:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7DCB23006B0C
	for <lists+linux-nvdimm@lfdr.de>; Fri, 27 Feb 2026 13:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B6A242D6A;
	Fri, 27 Feb 2026 13:24:01 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45729241CB7
	for <nvdimm@lists.linux.dev>; Fri, 27 Feb 2026 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772198641; cv=none; b=JMaVjgh70kZWHxXaTby+oudK0jacGwza3aBlK18vBDL2IT8A4WaWNXtIJar6UrbTDml2MXfhtcPbzv2q8GbQ8PPkU1kgTiZz3Y254T7mniYjg2B3sx3PaQKFh4VRZIcCeLkFAU03UKhmNZ9RXUvLzwg4ur5yU6Cpyhf0euUoeis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772198641; c=relaxed/simple;
	bh=isgjJ4LDMWU37geIAUnqw4AK5tQqZR2Dy+soG2mGPBo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFE8/u7ldHsXca2LKjz1EMdRW1fUrheM+0IKk9nRlYCAfCNzl2/ZCrjkzizdNMHHKlncV04lhk16zX3YZuKFRKQT4h+rlwQr56T5WCRqr/Tb30TR+JockmpHGrgXM7OJV9n28Yqcc861Pg082hQ9B5+4YGebNxGOto9j7Usgdbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fMpt82xZBzHnGj1;
	Fri, 27 Feb 2026 21:23:12 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 52F8740572;
	Fri, 27 Feb 2026 21:23:58 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 27 Feb
 2026 13:23:57 +0000
Date: Fri, 27 Feb 2026 13:23:56 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Ben Cheatham
	<benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2] dax/kmem: account for partial dis-contiguous
 resource upon removal
Message-ID: <20260227132356.00005c94@huawei.com>
In-Reply-To: <aZ_TlK4r41P0xBDO@aschofie-mobl2.lan>
References: <20260223201516.1517657-1-dave@stgolabs.net>
	<aZ_TlK4r41P0xBDO@aschofie-mobl2.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13316-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:mid,huawei.com:email]
X-Rspamd-Queue-Id: 2233C1B7A78
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 21:01:08 -0800
Alison Schofield <alison.schofield@intel.com> wrote:

> On Mon, Feb 23, 2026 at 12:15:16PM -0800, Davidlohr Bueso wrote:
> > When dev_dax_kmem_probe() partially succeeds (at least one range
> > is mapped) but a subsequent range fails request_mem_region()
> > or add_memory_driver_managed(), the probe silently continues,
> > ultimately returning success, but with the corresponding range
> > resource NULL'ed out.
> > 
> > dev_dax_kmem_remove() iterates over all dax_device ranges regardless
> > of if the underlying resource exists. When remove_memory() is
> > called later, it returns 0 because the memory was never added which
> > causes dev_dax_kmem_remove() to incorrectly assume the (nonexistent)
> > resource can be removed and attempts cleanup on a NULL pointer.  
> 
> Do you have a failure signature w Call Trace to paste here?
> If not, maybe just insert the expected signature for grepping:
> "BUG: unable to handle kernel NULL pointer dereference"
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

