Return-Path: <nvdimm+bounces-13742-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIsiGNfTw2lLuQQAu9opvQ
	(envelope-from <nvdimm+bounces-13742-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 13:23:51 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9F5324D02
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 13:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0AE16319E236
	for <lists+linux-nvdimm@lfdr.de>; Wed, 25 Mar 2026 11:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5D23D1CA1;
	Wed, 25 Mar 2026 11:55:48 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6843CFF42
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 11:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774439748; cv=none; b=rzV7uPTgyEsjB0yiADeYikzXd532TiIm/vCjvN9bvXU5cRsH9kC1CepNmBH3MY+QYi1b47dVQNA+spH6i/aiJycBbtuwxdjbC9RvxBRYtsx6W2VYIsrj3LPc9StGNVrY36ED+VlYesG1ZLbtHUCCtrOnJWcv5H68TYQrQJHT1cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774439748; c=relaxed/simple;
	bh=ys6PuOWdFe0qxokKIbVNj5WZJc8jhMK2HslSsFknON8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9692VUkxGTeVjXG8nM7bkueqh3rzuPReDzeBIN7FnDs62aRfXkYslJcKQ7/u6t88b/humJFNtiRdVSMrimmixxHFeb55VI829ftFX0zBLH7OQrVNs7ojYCoqxsa6GMX54Xk8bPknn48Vdcbh3pOcJYDYPRI8gYI556sOLazvyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fglhW5P1vzHnGfQ;
	Wed, 25 Mar 2026 19:55:07 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 07E6F40587;
	Wed, 25 Mar 2026 19:55:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Mar
 2026 11:55:41 +0000
Date: Wed, 25 Mar 2026 11:55:40 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, "Miklos
 Szeredi" <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, "Bernd
 Schubert" <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, "Jonathan Corbet" <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, "Vishal Verma" <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan
 Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen
 Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad
 Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank
 Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
Message-ID: <20260325115540.000047f2@huawei.com>
In-Reply-To: <69c321d5e7195_e9d8d10040@iweiny-mobl.notmuch>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003743.4973-1-john@jagalactic.com>
	<0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000@email.amazonses.com>
	<20260324141806.000003f7@huawei.com>
	<69c321d5e7195_e9d8d10040@iweiny-mobl.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Spamd-Result: default: False [0.04 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[huawei.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[40];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[jagalactic.com,groves.net,szeredi.hu,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-13742-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[jagalactic.com:email,intel.com:email,groves.net:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA9F5324D02
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 24 Mar 2026 18:44:21 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Tue, 24 Mar 2026 00:37:53 +0000
> > John Groves <john@jagalactic.com> wrote:
> >   
> > > From: John Groves <john@groves.net>
> > > 
> > > This function will be used by both device.c and fsdev.c, but both are
> > > loadable modules. Moving to bus.c puts it in core and makes it available
> > > to both.
> > > 
> > > No code changes - just relocated.
> > > 
> > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > > Signed-off-by: John Groves <john@groves.net>  
> > Obviously this is a straight forward code move... But I can't resist
> > commenting on what is moving  (feel free to ignore! or maybe a follow
> > up patch if you agree.
> > 
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>  
> 
> Added this to the series.  LMK if I missed something.
LGTM.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
(don't bother adding it unless you are touching the tree for some other reason!)

> 
> Ira
> 
> ---
> commit ccc1878ab00178e82108bdd1ece497388a24290b (HEAD -> nvdimm-famfs-dax)
> Author: Ira Weiny <ira.weiny@intel.com>
> Date:   Tue Mar 24 12:36:19 2026 -0500
> 
>     dax: Modernize dax_pgoff_to_phys()
> 
>     The patch to move dax_pgoff_to_phys() to bus.c revealed that the
>     function could be improved with more modern style and the newer
>     in_range() utility function.
> 
>     Update it while we are moving it around.
> 
>     Link: https://lore.kernel.org/all/20260324141806.000003f7@huawei.com/
>     Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>     Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index e4bd5c9f006c..1b412264bb36 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1421,16 +1421,12 @@ static const struct device_type dev_dax_type = {
>  __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>                               unsigned long size)
>  {
> -       int i;
> -
> -       for (i = 0; i < dev_dax->nr_range; i++) {
> +       for (int i = 0; i < dev_dax->nr_range; i++) {
>                 struct dev_dax_range *dax_range = &dev_dax->ranges[i];
>                 struct range *range = &dax_range->range;
> -               unsigned long long pgoff_end;
>                 phys_addr_t phys;
> 
> -               pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
> -               if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
> +               if (!in_range(pgoff, dax_range->pgoff, PHYS_PFN(range_len(range))))
>                         continue;
>                 phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
>                 if (phys + size - 1 <= range->end)
> 


