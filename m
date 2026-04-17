Return-Path: <nvdimm+bounces-13908-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIKMI1rX4WkuywAAu9opvQ
	(envelope-from <nvdimm+bounces-13908-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 08:46:50 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 118AA417852
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 08:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A534E3029765
	for <lists+linux-nvdimm@lfdr.de>; Fri, 17 Apr 2026 06:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9085C34D922;
	Fri, 17 Apr 2026 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RFsn5e9x"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4302F7462
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776408394; cv=none; b=Bbe218/rEANfiXSscZVQifpuOmiA3NhjkztnY9REtpzU0PXpu5vV2pNs0/9qntytHiexoUSMZW75FT+9Gvy1I/63Sqa9JE32LJZeHWqoF7ubWl0ZFovf/Bo3B23cC5a59b17p2F3+rEgJU/H85222YdBsImSAbeEWL9Uv+PfSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776408394; c=relaxed/simple;
	bh=d4PpKCk3+cY+Ia63Uy2Vt+eoNLKg4rm4l23ANxaSUh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laTxqn5T4OEAKyZFc3524fQc1qktFdvjQiPEfXJvpBMa1/zZg4mUF0UyaOGxVEZrZIkiM/lAMP9tq+TSC1cRIjafvSFzTn+28iD3zHzKKZA54kMtl+6V54WH5t9dQhSxQu9OzPbwsVIy8ecgLeMlTZHQcs4JHHNTMvrH1GBQew0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RFsn5e9x; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d6d5e45c43so39812285a.3
        for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 23:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776408392; x=1777013192; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hhIjuJ3A3M20AFrPa5BfGVCAhbvvigIUz2GsEPa7gR8=;
        b=RFsn5e9x6USLb4iZ86KS5oSNHgV5c5un6UpwgaYE0MSOjugGYNIy4HtRe3yfDNXb4A
         7QMdAxtPAIsweWXQ/jXu0g+YR4iIvyuZM+80NnI73kB3bn4sqZZRTzMdKkAlGCtNJHn+
         7Q9P2gnGQXrNiGZdJoiBWoM4L1WtPENre9h6XEbuERWMlgKFSbvBjOKzATd9xW94FMbI
         BRYESo9p/imGFm5TZLm603pV1Op6X1VV3T0WQXfEsRQJ5oDNpEC2V2M3hRxIC4XEOZhQ
         28ms4YdrFmXgysaF4BPdKJ/8dtd2Zed5bU46Eco9Aubwb14yAIbEv2SZv/6jP0CuNZ1i
         0EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776408392; x=1777013192;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hhIjuJ3A3M20AFrPa5BfGVCAhbvvigIUz2GsEPa7gR8=;
        b=oyB15xCMrWqNsWDgdW0XkMkC+x+alq2VWoSSqIkWHsnXOhcw9ED5FASMkOP58bDY2B
         wKWajJcnkq4iSP9kihv7HYomsxfOSI4SZR048F7C7d7nfhBknwQrBSB8ixZ81NhQUG2Q
         VCvEuqWLC0XAqZpdAy8axkdS2OT4sjwlsPdgb8vkmeIhencXQ+oaSErEWLGecAywZQkT
         P0vAGQ9S/olzmvL5Wz7g/K6/f6eOgPb7fONt5KdbhNcY1dzHHw+OnRXD2mjjuCxUPDiq
         OkK6mouJ6zpfYyDe8HUH9Y9A5H0XjD6tffImrBq2ihpR+nvRP1w6wkZ92bdR1i9cVaG3
         Us3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/jAz0qj5bVBh1tWUI8EcZ6tGB/XIg324bMnLC2DlCk6KlaZ44+usit6CNdeKVesbpgbYukMZk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRCMocgXEcbsujX55re9195Vnt8dUSUqlZnb3h6w2vmWGily0V
	n272ErOPubNH2m0p2Y9q7E61oT943MjnxzmhpEiOyT0zebKyxeskM5FuGKCX1Trwo+A=
X-Gm-Gg: AeBDiesg0K76Vdygxf8V6K+R8Ykaq8LNJy3mkpXs8enQ2GW97AgAv+sm3AjlnY5biT1
	OM3CofJkvPSidgYmfTZCruay0vj2zCvAsDKhTxJT7xlJd35lv1Ncjs3c9HBYvcTEjjGzhp2hiYZ
	CoCwYK9f/rDlzMx7nVpj/Qm6F6Zw1Kd6Y3cADrlLG2w1IssBnaYWuJcZXUiux9T6YOP789m8uim
	IFjX1yURNCOKiDiXwUOEEb9tNsV0KYJYKv3T1kYxKnCIgYRXwNvd+XUlHDZnyJbUOWjjvHy+Idq
	jJ2UEcuuMjID0ogjPj6yuxztbpN3tjNzmddRUoszXSSiQwDM7+sU2J0b8So9FiIlO2lhNBhCXR4
	FMT6XHR9vAn0f+dATtpgj7O1zT710fs75dPVVBL/OEoOABZxJnPUaAWOzzYcxktnPvPcWIeLQw7
	X2bHmfDlB/ixOqx3kgeDOqffFZEyiBNBXSLNoKUf/ikGSF9AmVSqUgT1+geoXRAPXKHSlc72PtK
	KGbyrJV8rrYcuZDjIpV8ATM5R8Luj8=
X-Received: by 2002:a05:620a:4690:b0:8cd:92c5:b3e7 with SMTP id af79cd13be357-8e790407b72mr203408385a.18.1776408391906;
        Thu, 16 Apr 2026 23:46:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-18-109-80.washdc.ftas.verizon.net. [108.18.109.80])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d93c2fffsm42616985a.36.2026.04.16.23.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 23:46:30 -0700 (PDT)
Date: Fri, 17 Apr 2026 02:46:27 -0400
From: Gregory Price <gourry@gourry.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>, "Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeHXQ2EW2ivlLb_N@gourry-fedora-PF4VCD3F>
References: <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <CAJnrk1ad6t6CJV+xnXwhoNHrHYA3htuaVdDq47FeT60cPBzj7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ad6t6CJV+xnXwhoNHrHYA3htuaVdDq47FeT60cPBzj7g@mail.gmail.com>
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13908-lists,linux-nvdimm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[gourry.net];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[groves.net,kernel.org,szeredi.hu,bsbernd.com,jagalactic.com,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,infradead.org,suse.cz,zeniv.linux.org.uk,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,vger.kernel.org,lists.linux.dev];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gourry.net:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[41];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 118AA417852
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 06:24:02PM -0700, Joanne Koong wrote:
> On Thu, Apr 16, 2026 at 1:14 PM Gregory Price <gourry@gourry.net> wrote:
> >
> > I worry that this discussion is going to turn towards implementing a
> > solution grounded in parsing arbitrary formats and how to store them,
> > and that is completely detached from why FAMFS went this route in the
> > first place.
> >
> > I question whether the actual issue here lies in the interface APPEARING
> > more general purpose than it actually is - and therefore inviting
> > attempts to over-genericize it.
> 
> Would you mind clarifying this part? Are you saying that the interface
> and logic is *already* generic and usable for other dax-backed
> servers, just that everything is *named* famfs but it's not really
> famfs specific? 

Yes.

If you just find/replace "famfs" with "dax_iomap", the structures
here don't really seem all *that* crazy specific - they're just
optimized for memory speeds instead of I/O.

There is a circular nature to this - FAMFS figured it out first, in
what we think is a reasonably generic way, but we can't know for sure.

John, Dan, and Darrick have all proposed reasonable ways to hedge
against the obvious fact the interface will not be perfect - which
incorporates your BPF proposal along with a reasonably straight forward
deprecation path that's not always possible in other arenas.

All that while solving a real (and novel) problem.

That's actually pretty damn cool.

I would urge you to consider these proposals earnestly.

~Gregory

