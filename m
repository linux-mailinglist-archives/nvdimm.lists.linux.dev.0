Return-Path: <nvdimm+bounces-8165-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB548FFD38
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jun 2024 09:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 964EC1F23182
	for <lists+linux-nvdimm@lfdr.de>; Fri,  7 Jun 2024 07:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1D51552E6;
	Fri,  7 Jun 2024 07:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oSyCR9xk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="878lOhC7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oSyCR9xk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="878lOhC7"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD4154440;
	Fri,  7 Jun 2024 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745499; cv=none; b=F6MJox4w/8W1JAhSHhslijVzvoL8UqwH/Kjo9VBEajbecnp1HE9n/vSBAVWOFewayMEZM1RGVeuhIQBvHYVEqfttLIqc4mhUDPHHpsw28/lK3mqpfAayMUK/GZxWECNUPEz4AxiGTtTwRUD7yi3fq+3ttjzT+R5kOTsvE698Pkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745499; c=relaxed/simple;
	bh=B2gCRIPjZcLOX3TCD7Q0rQ/wCCbd/cF1wmZCrQQQoLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXh4duDrwGzXDOZlyVdrsULX11lt3Zo+Kiuygmlrj+nN1ttJ3OaTXnNm+cvG0UWqAgRBzDBuIqpY+pPDX8m4PIjjhyypFwtSaV/VNAcAfLud/zTA3xj7RlKONVa0yvpkO1OWEt9WhSiCarQEOPJzqzmF24VxrFBI+10uEF5cROw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oSyCR9xk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=878lOhC7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oSyCR9xk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=878lOhC7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B525821AF1;
	Fri,  7 Jun 2024 07:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717745495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMMolUiLSPWu3XSdPdZUfGl9BCThwSdPrXW66Az97D8=;
	b=oSyCR9xkELO8L5Aadz8fPB8CERhvgOs/ZGlDUdrCQIPI0M8wj6y1frU9IbztGDMN4wcB+2
	kldDqHZLfWYCcHtXJtXox1VdZIQhCL6Iqq5zIs9zww4GaaEFffv7X24gE40Ncbzf7W2hEv
	Dg5wQHP6bBMEUC+M39L7V/VY8VBPlAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717745495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMMolUiLSPWu3XSdPdZUfGl9BCThwSdPrXW66Az97D8=;
	b=878lOhC75QuTS6EKVQEBgm0Gq4FVZ4FGMnpgSaU+4z8sCPvaQWsB+sjtGA9GYvtMrGg1k/
	NH+abBGyLAxZtSDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oSyCR9xk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=878lOhC7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717745495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMMolUiLSPWu3XSdPdZUfGl9BCThwSdPrXW66Az97D8=;
	b=oSyCR9xkELO8L5Aadz8fPB8CERhvgOs/ZGlDUdrCQIPI0M8wj6y1frU9IbztGDMN4wcB+2
	kldDqHZLfWYCcHtXJtXox1VdZIQhCL6Iqq5zIs9zww4GaaEFffv7X24gE40Ncbzf7W2hEv
	Dg5wQHP6bBMEUC+M39L7V/VY8VBPlAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717745495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMMolUiLSPWu3XSdPdZUfGl9BCThwSdPrXW66Az97D8=;
	b=878lOhC75QuTS6EKVQEBgm0Gq4FVZ4FGMnpgSaU+4z8sCPvaQWsB+sjtGA9GYvtMrGg1k/
	NH+abBGyLAxZtSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 047AB13A42;
	Fri,  7 Jun 2024 07:31:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KbchO1a3YmYEeAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 07:31:34 +0000
Message-ID: <04e67b76-1b47-4d67-9e92-71fb37b97351@suse.de>
Date: Fri, 7 Jun 2024 09:31:34 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] block: move integrity information into queue_limits
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240607055912.3586772-1-hch@lst.de>
 <20240607055912.3586772-12-hch@lst.de>
 <8cd46b95-bfdf-42a4-809f-36ff88062322@suse.de> <20240607063221.GB5387@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607063221.GB5387@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B525821AF1
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 6/7/24 08:32, Christoph Hellwig wrote:
> I just found a fullquota.  If you have anthing to say please trim your
> reply so that it can be found.
> 
Sorry.

Trimming reply next time.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


