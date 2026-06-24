Return-Path: <nvdimm+bounces-14528-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4rF0KEH3O2opgwgAu9opvQ
	(envelope-from <nvdimm+bounces-14528-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:26:57 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E10636BFA19
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:26:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXInSR0Q;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14528-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14528-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C9F13160EA9
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 15:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE65B3DA5C3;
	Wed, 24 Jun 2026 15:14:09 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63A33D9DDC
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 15:14:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782314049; cv=none; b=J93lhuYfPCkacVb0HJ47GVxiinBBg7DWbVbtOE3GDT5WxS+AzOZE1mctK1VhHZbEASdxJmdbOVeb93wxxhLuAfMREl8ZKZUf+bXfLFIHrUNNzFdLeVSEazY3P2mjOjeN7gtSW49r0WFSLjwZTvcTCZps0fpw57oeCJTOL/xsX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782314049; c=relaxed/simple;
	bh=97/qbvVTs/jF8SZ4AfcqRjJ7YmwC+4lUHCDgaKzf6Do=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ltDHV+NCDO6P/f0WvUl9YunmtJhsgORL0adFAPhNzoRMwQdzR82ViL7QmorQUnZ0LhoOxmelSzfMBbV27OL+CKDocC10Jc1A/vbEtz18zRNJH3VvA+52q7jt2xAPbWKfLgd0V571UDBhDYTHaPol1M1RGrzi9oYEYHr/xAaiyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXInSR0Q; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B19C1F000E9;
	Wed, 24 Jun 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782314048;
	bh=LEf9GRjVl29E7vbdSKRWdyU5bkqg+GNP4JsLuRfBZ+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CXInSR0QhOH03LPrwcOSP5x+CLFzTuUeBzZRWR0y/AsOnTMfrBj/W8+QHVo64h/fO
	 linLRjLCO2gvKpGiHRuwLa5iYyO2i93Pg7ApsQC5fLiQvMmclPZISZXG2BDtvc0yT/
	 xG9YOrh/XxGA/6z/XEQvB6ea7TrjFNRGGFoUtM23d5gfKHtAyxgRnbC4MdbzUlvm8H
	 hdAX/+P95gHhgATpHeK13oYUdf280sH+dWdHwdM0hWCbWYfxnBQlzy3xbM7rCokcmx
	 j7f+zVs9JRBkfW8CnphYUvSmQiZCDud2dyQG5QJdKCQ4fMcNE4GAEnrZ9sxmWbYpZD
	 DUvDZPo51yx4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] nvdimm/btt: fix sequence endian in btt_log_read
 error print
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ben Dooks" <ben.dooks@codethink.co.uk>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
References: <20260624150602.905561-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:14:07 +0000
Message-Id: <20260624151408.5B19C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-14528-lists,linux-nvdimm=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:ben.dooks@codethink.co.uk,m:nvdimm@lists.linux.dev,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	FORGED_SENDER(0.00)[sashiko-bot@kernel.org,nvdimm@lists.linux.dev];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,lists.linux.dev:from_smtp,codethink.co.uk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E10636BFA19

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The patch open-codes the endianness conversion of the log sequence =
numbers instead of utilizing the existing helper function `log_seq()`.
- [Low] There are multiple spelling errors in the commit message.
--

commit 41767fa21db59b2ed77d8052ff41a18c93ebf763
Author: Ben Dooks <ben.dooks@codethink.co.uk>

nvdimm/btt: fix sequence endian in btt_log_read error print

This commit fixes endianness warnings in btt_log_read() by converting the
log sequence numbers to CPU endianness before printing them. It ensures the
correct sequence number is displayed and resolves sparse warnings.

>     The error reporting in btt_log_read() prints sequence numbers out
>     from the log which are stored in little endian without any endian
>     conversion. Make sure these are passed throuhg endian convesion

[Severity: Low]
This isn't a bug, but there are typos ("throuhg" and "convesion") in the
commit message.

> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32=
 lane,
>  	if (old_ent < 0 || old_ent > 1) {
>  		dev_err(to_dev(arena),
>  				"log corruption (%d): lane %d seq [%d, %d]\n",
> -				old_ent, lane, log.ent[arena->log_index[0]].seq,
> -				log.ent[arena->log_index[1]].seq);
> +				old_ent, lane,
> +				le32_to_cpu(log.ent[arena->log_index[0]].seq),
> +				le32_to_cpu(log.ent[arena->log_index[1]].seq));

[Severity: Low]
Would it be better to use the existing log_seq() helper function here
instead of open-coding the le32_to_cpu() conversion?

For example:
    log_seq(&log, arena->log_index[0]),
    log_seq(&log, arena->log_index[1]));

>  		/* TODO set error state? */
>  		return -EIO;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624150602.9055=
61-1-ben.dooks@codethink.co.uk?part=3D1

