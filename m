Return-Path: <nvdimm+bounces-8381-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5430190AB97
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Jun 2024 12:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5801C20C96
	for <lists+linux-nvdimm@lfdr.de>; Mon, 17 Jun 2024 10:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2C4194A65;
	Mon, 17 Jun 2024 10:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0aaHE0nD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u/mMPT+2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xTEWwfzF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qkTWtDj2"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE85025E;
	Mon, 17 Jun 2024 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620924; cv=none; b=ZBoMx3JtQaGhQJzogNNfqQSrFluIl+3ZI0aMidSiAL67xBDBilOtYFmQ3ZW9RIVJX59diVs6FHq3dFLJukPxfbM4pYHLGok+uJHpd81xcNp+cAsj4t1Tnxd22L3FnGsMKwS8SANSICTP2uG2uh04BmfB43ssYJjN2Fp3HUze1Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620924; c=relaxed/simple;
	bh=uLD0MnBZUkmBcdQuYDt2WcOIDQqWv+V2wjGWGGRGgpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NhSO3+iyi3TKYM/o94GXJxmBMWMdVWHR0JZgIew2YxVfXPepgq/ofRUL1YXBj6FaGhVbhUALiEzgSzVGp+Mu7x+QVJveXM4EIYde6R/WVPwKp1W70LA3yY0mcT8OeGZ4IL81t8GxuSbdLuGI4n9YPSXJW6HEToCwNz95EJHXtU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0aaHE0nD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u/mMPT+2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xTEWwfzF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qkTWtDj2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E7E405FEE9;
	Mon, 17 Jun 2024 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ei0H6kpwHCrAVar/RhH6iZ8w6j4VD0fXtJ6uoOiivc4=;
	b=0aaHE0nDv3sFsKVo4RUNdgi1Gj4Z+MuxUZnX8NnbX4LzirK+9YxDEKeKTIvvb3Wd8UZxyQ
	pL02vk2jca8kXflRM+INPCSpkiMwMWo7zucPCyoXwRKjtHW7Td94vfcVrUznX/Wrnql6uU
	nbRjt2sHYPvoTYF1vldXy3sMrqyJ5ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ei0H6kpwHCrAVar/RhH6iZ8w6j4VD0fXtJ6uoOiivc4=;
	b=u/mMPT+20sxE/ovrpfH8HyTUV2cuE+R8tuWdBd19R5MUKmu37GlwIbXmeKfQurMrJvkHuR
	ct5GSA7YBBDQI5Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ei0H6kpwHCrAVar/RhH6iZ8w6j4VD0fXtJ6uoOiivc4=;
	b=xTEWwfzFhRWHcOXnCi0toiBdIbekgACZlSGjefUOBapq+sr5vsf4vQJQ1gCTgtm0E9xveU
	accWTuwIKPqiaNL6bALixViV7AYgXFVqL7fo2rJJx59ox9JSCXpgx4591/71uuV/xfscUt
	sB86pC4PSbMmA80wDdJRXCgbv9+51b4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ei0H6kpwHCrAVar/RhH6iZ8w6j4VD0fXtJ6uoOiivc4=;
	b=qkTWtDj2KUeKlE0sNEFFUQfU+KX8KlrCG6SQVbv5pLDtOUA6x3/nFzgU57ULpz5g8bO5y2
	Ph8SFQJlrPTNjiAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84C9013AAA;
	Mon, 17 Jun 2024 10:42:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bAPLHPgScGbeDQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:42:00 +0000
Message-ID: <c33258a8-6ad2-4b8b-bd38-90c08d366c2c@suse.de>
Date: Mon, 17 Jun 2024 12:42:00 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/26] block: move the dax flag to queue_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-21-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-21-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the dax flag into the queue_limits feature field so that it can be
> set atomically with the queue frozen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c       | 1 -
>   drivers/md/dm-table.c        | 4 ++--
>   drivers/nvdimm/pmem.c        | 7 ++-----
>   drivers/s390/block/dcssblk.c | 2 +-
>   include/linux/blkdev.h       | 6 ++++--
>   5 files changed, 9 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


