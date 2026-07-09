Return-Path: <nvdimm+bounces-14823-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id hKJWCHo1UGpQvAIAu9opvQ
	(envelope-from <nvdimm+bounces-14823-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Jul 2026 01:57:46 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 81AD4736494
	for <lists+linux-nvdimm@lfdr.de>; Fri, 10 Jul 2026 01:57:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGvMFIuG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14823-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.105.105.114 as permitted sender) smtp.mailfrom="nvdimm+bounces-14823-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F46B3023050
	for <lists+linux-nvdimm@lfdr.de>; Thu,  9 Jul 2026 23:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADEB3BFAF7;
	Thu,  9 Jul 2026 23:57:35 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F63BB12B;
	Thu,  9 Jul 2026 23:57:34 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783641455; cv=none; b=AL7ANBPjN3J/L3sdUTTqlGgh+w9YwgYtzfhGjGypFb1Ah9hiaJm08sSPbnyin1VZYDpiXHr8sepHIZBVYfDCRGm/5XOF7uL8lHGKvN/1KKnWRtUvY7dcY365GJhIsdlR/dl51/Bd5Dp47Bp4Q5/t2dteFPsuaLwN0JQKO9d8ED0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783641455; c=relaxed/simple;
	bh=ijeMi1ynINCbfpsysZOXJoU1MZ/yQ6o1QBJh/Ou0gAQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=sNhPR/87LSf050OAfQ53FuqQRj7IV/6wsOjLbWlyaot6XMUDNFfAWJw3Y8cC2SKuTozo3XCsPGNB72S4kdL+MFMwkuJtL6/s7EfxdAK3GZhuzXC/zpGRwJqUbC/GbNEsQm+rB76CPBglAMqD6+pCpfytxlcPbk4VOZzT31bYXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGvMFIuG; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418A01F00A3D;
	Thu,  9 Jul 2026 23:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783641454;
	bh=NL6KkE+XGM13rjECEPlDsP8sDmlO2+4iY80eSoJW34k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VGvMFIuGD04PIRzU/JMeGvWpJXoTWA+IBrWJ4DETddqsvMfFiGavTTa9l63r0ClWv
	 X2UUQqNqpZqczRFyLqhZ+Zy8m15reHdQPTxmbUIl38NqaY/9+pMPbWiYC4uxdsvauQ
	 wiyhThJeiv2vh4H7xyufBRg8Jf3VvutnySvhp/UkfByFzJVEb/o6mL59688vpOGA8E
	 /KtI4FyfFU6/yE1N8/6ajHygAZKQzXhv4MUIjJQ7ZlAJqRmRYhZpdgugODmzwu+OMS
	 LmeVZGAdUBW7l7GzygghdDpLsz0oELPEdGv7JVw3JmP3iGheo/4T7jidFlKAypbciy
	 7bI+bsP27Yw9A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5ED64F40068;
	Thu,  9 Jul 2026 19:57:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 09 Jul 2026 19:57:32 -0400
X-ME-Sender: <xms:bDVQalWT3kkP1O_nPlEUgaGq8m8QWlO5PPNjznrDe7d1CpTWIfMANg>
    <xme:bDVQalv5hmJ1CwhK2dgiJKfqcKH5_0MDF8nquspQ3CIiab0qCEzQOUNU3wTkB6jqA
    qux6Ekbzjl6ev_KByOlE4DpQciHdJVr0JS7N5fHu8-OEkyJk7RLkY4>
X-ME-Received: <xmr:bDVQavNLOvwweJeepDKvjUahneSQU-R9SYF3Ap5jl8v4MTmiRC2Md5MF496hZvJ_k9lFsj2yuAX9-jTBk3671HtMbzuA8Bg0NRc>
X-ME-Proxy-Cause: dmFkZTFRjNBlnTz3PRsAmwjqRoF0mrjGm979SwqAKHEfthIBDq5uh/i9WRUkVW7VZSf//w
    YDoaw7hRG798DaAYdC6UbfhFGRdHF+jU+/jGu6HBle2Ytf+9RWyMwBDwRmckEaZLf/nUyQ
    SKi5sJRgbDjlp94ASRYw/4muCvkc2xHnl/vxqUx1y1DhspUjPMoJnbB/bl00rpb5PWiQyg
    GTtZWI4G6plLyhOdjNWH8CBGphBXLtH3D2Pvho0pAK+KnWiAORXsSOpMdV4xD7ID8QXYje
    a9mh9aiUSp78AdFrJ9O2B3vkzu06KG1gqyHdViPBwiRVrcIhbVPJi05ziCPPBR/N6vYfer
    6lrpXziKcnjva9wT7p5QUwgxDdC5jjdwT7fXiZidMKAEs3vLpiGVt16GoilNTbBE1Swe66
    lq1nYogPtBgSjvZCHT/YZLpCIqUO4TamHC1Gj5FtyOihURCc/3jiGGJS5HrnflvJVUhjxl
    uPu1tEET6rrY+yW5GgTNYjuDoKs+MzBD57qey3Z58xdp6wOjNRKNBRIG8N4BLdwR9dsmCv
    A4RIo/MDKkVvsbyt2hA+z7nruReU0o4mcD3lQXH5OqBkbo9AE/nGnLS1/bS/nnG97VTtRr
    clacuChAjPCOEchopHVZNuyYh3E0NUuVP+WPVNPQEQOSK3N74GMuftNUjPxA
X-ME-Proxy: <xmx:bDVQasnnBxeuM7jroXxksAQB9zn6duvpKmyvN9LZYwI-PdaHUkJUKA>
    <xmx:bDVQatz0AT56AL-iX_O4imnfAPCevJDLonBYOOcGBR4lexJTusoU-A>
    <xmx:bDVQalDdKFvxjIjyCfZD792xaNLb2nqmtQGGLIeFu5A_OdS7ISVbsQ>
    <xmx:bDVQal5BbtDERhJ51QOg_cveb9aqQk1z5niWGshAPguYIvTxzRtlwA>
    <xmx:bDVQap1K540U56JdRBFV8JSNUnGOGG8a2VUV2cYjZ6gcar-XwgSzqP4U>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 19:57:31 -0400 (EDT)
Date: Thu, 09 Jul 2026 16:57:30 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, 
 nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com, 
 Hannes Reinecke <hare@suse.de>
Message-ID: <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
In-Reply-To: <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
 <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14823-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gourry@gourry.net,m:djbw@kernel.org,m:linux-mm@kvack.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,m:iweiny@kernel.org,m:Smita.KoralahalliChannabasappa@amd.com,m:apopple@nvidia.com,m:hare@suse.de,s:lists@lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[djbw-dev.notmuch:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FORGED_SENDER(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djbw@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 81AD4736494

Gregory Price wrote:
> > So the "unknown" case does not need to be here.
> >
> 
> mhp_online_type_to_str can technically return NULL, seems better to not
> just let a NULL dereference sit latent even if we can visually tell it
> can't happen today?

Oh, makes sense I was thinking "unknown" was only a result of the
drvdata missing case.

> > > +	if (dax_kmem_state_is_online(data->state)) {
> > > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > 
> > I like that the BUG() is avoided, but I think these should stay
> > dev_err() given the severity.
> > 
> 
> I had to go back to calling remove_memory() by default given different
> feedback, but I think if anything I will just modify the BUG() to a
> WARN() and call it a day.

ack.

