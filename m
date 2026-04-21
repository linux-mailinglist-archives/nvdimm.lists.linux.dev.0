Return-Path: <nvdimm+bounces-13929-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4ECiI9gg52ki4QEAu9opvQ
	(envelope-from <nvdimm+bounces-13929-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Apr 2026 09:01:44 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3257C4373FA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Apr 2026 09:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27A4F3012EA0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 21 Apr 2026 06:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185193803D4;
	Tue, 21 Apr 2026 06:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UATZPd0W"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC42EC09F;
	Tue, 21 Apr 2026 06:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776754784; cv=none; b=oTdxrizLmeDWvv7v6EC4aQ92lT7VTBs0KJIDh7+mZbnhZ9/rqRAakfXvSYAQHDAWnZfy9kY4xD4Zj6ZY5zBkJyH5XrrK+OtRNXlF1pfRrwH8iIixNQF94xw2rlVXGu42nuKJ0oJLSIi4lrDanHEXX7wPX1hF76C4SmE5ct8mRSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776754784; c=relaxed/simple;
	bh=ZtnupvFJs1Tf+kL7zMpn6BLAX5iZ4SmevAhN3WVdgTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFJ+m/qomuaI+5GCV07Z9vH44dVHqCgRM5DXh2Zhdxr4js9mJMsES+aOtERFzJv7HBzMc5QXbLVwMpX40uOspJTFjqs/o4p0VK9X4RRFd+UdlKDk/AXECXdErmh9PinCEJNiQfv7BcEpms6Y2JX1wWb6fW++X+1j5GAGtA6bHOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UATZPd0W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8517AC2BCB6;
	Tue, 21 Apr 2026 06:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776754784;
	bh=ZtnupvFJs1Tf+kL7zMpn6BLAX5iZ4SmevAhN3WVdgTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UATZPd0W/pIgAM5wbl1JBTyAHTan/Gbz55/mbTEAuJ1pOi9tSrDU92jTjwl/Zpnwn
	 b25DPSZOTK9bw0W7W1wUj78+b73KLbRV80FadetzTGTbycHDayEiW9UG7m0pKYTgdV
	 hUZ9JWCIPz96Uwi7M3hzKLwXo2/20jf9/+4BT5KUP7eKZYJiEE9gJArX2KzPgXw379
	 /waGRSwdieXd4JHQZPRw4Eu3ZYUxbjX7R8jtwowb3EhpkpBiVpNd+AbobtL4kfouyQ
	 FvYqLMdvGHmuCp8QkU2BpNprsmFxaVkIQ5njUY0oQasqHyaccXkrjL0CwAlYP1qfW3
	 qa3RPnWfDMibw==
Date: Tue, 21 Apr 2026 08:59:32 +0200
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, John Groves <John@groves.net>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <20260421-arsch-gelernt-e0b5bcd8a7ff@brauner>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <aeHpjpNN4TliZOyp@infradead.org>
 <CAJnrk1a7idWN4UNpW0P-X4xeBKOkhnR+Mvfo3QW38OfShiwpKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1a7idWN4UNpW0P-X4xeBKOkhnR+Mvfo3QW38OfShiwpKw@mail.gmail.com>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13929-lists,linux-nvdimm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[infradead.org,szeredi.hu,groves.net,bsbernd.com,jagalactic.com,intel.com,ddn.com,micron.com,lwn.net,linuxfoundation.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[42];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3257C4373FA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 12:35:13PM -0700, Joanne Koong wrote:
> On Fri, Apr 17, 2026 at 1:04 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > This is the first mail without annoying and pointless full quotes,
> > so chiming in here.  Sorry if I missed something important in all the
> > noise.
> >
> > On Tue, Apr 14, 2026 at 03:19:36PM +0200, Miklos Szeredi wrote:
> > > On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > > Overall, my intention with bringing this up is just to make sure we're
> > > > at least aware of this alternative before anything is merged and
> > > > permanent. If Miklos and you think we should land this series, then
> > > > I'm on board with that.
> > >
> > > TBH, I'd prefer not to add the famfs specific mapping interface if not
> > > absolutely necessary.
> >
> > Yes,  fuse needing support for a specific file systems sounds like a
> > design mistake.
> >
> > >This was the main sticking point originally,
> > > but there seemed to be no better alternative.
> > >
> > > However with the bpf approach this would be gone, which is great.
> >
> > So what is this bpf magic actually trying to solve?
> 
> It is trying to avoid having famfs-specific implementation details
> hardcoded permanently into fuse's uapi and kernel code. I really like
> your suggestion of adding generic stride/offset multi-device support
> to fs/iomap. That is a much better solution than bpf.

If you go down the bpf route you will just have to use bpf hashmaps to
associate the blobs that you need with the relevant data structure and
then activate it from whatever hook you need. There's now very flexible
hashmap storage that you can autoresize - or you can use bpf arenas.
There's a ton of options that don't require modifying core structures.

IOW, I don't want dedicated bpf storage in struct inode. Not just
because bpf people consider dedicated blob storage in kernel structures
obsolete and recommend to use hashmaps - which is e.g., what I use for
another project of mine where I associate metadata with block devices -
but also because I very much disagree with bloating generic infra.

