Return-Path: <nvdimm+bounces-14519-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bZCNMmD1O2r/gQgAu9opvQ
	(envelope-from <nvdimm+bounces-14519-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:18:56 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC996BF902
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 17:18:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=rfwvfeFq;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14519-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14519-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E054313929C
	for <lists+linux-nvdimm@lfdr.de>; Wed, 24 Jun 2026 15:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2B93D8131;
	Wed, 24 Jun 2026 15:07:29 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC33B7B7B;
	Wed, 24 Jun 2026 15:07:27 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313649; cv=none; b=Uwwk3vpYBl+WlCHoRZIMjaxFIENMiWYb0l9elS3rnHDnkTk6QQ1XAAzFg6B/ChXn2FWG7ZpGiIW93ZnFUkGWT8SV+NYxdRi+YZcWRCzg1HePgl8+MJduCDz6+tGMu7l6DRluFvCYl5JTVDxJ48TkgRX6EoJLfgP/whXQLYX7EmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313649; c=relaxed/simple;
	bh=l47BwNV4FbSGQ7kxOpU8tVlitZeXZd11zYwrbfYg/0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvLJuwHbxl5y/66xX+C/LD04k+r/1fd0saLP7jzC0GYayq/pvayy8hjs1EmRzh4BDcLha/NDqyJ+Sg1WDrySU1UFffRysK2NGuFkNlw++JIYGVzhBN4eKPhD4NandByq0k/OJh/F12VSQG69rZ3ZtHCi40XrJggqZK4y/jC3nQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.co.uk; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=rfwvfeFq; arc=none smtp.client-ip=188.40.203.114
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=sZtRwSHBG39kFYsblWRkqc3V1NEZRJ5ugiBZSqoq2i4=; b=rfwvfeFqnZextBS2
	SuOcrLDUroi2DEez9AUt/h4Cgvzw0x7itKV2Mj31YX4iRwWBnVYH735YDgR+Vf+xJvIt7f1hcL18p
	kbeevGbEg/cWYrj9Djab3IF05rPUAzSolOFoUApmgYAIIJisA96BD0u5F07+CEzYKtwUiBOBUbB49
	GwwQ+CfDAO9u1xeKG70tdo6iSl9AspIR1Am7cozMYlYacmrsGVxJqU/XFRHes3uKM6KfzqungtHbC
	lN35fajdwpx/819Q23sDRipSHMHp1H4aVwYl7xVPrI2v9Ud1iGHidd8n2cyYKJqhGOLq6FE9ure1A
	1SWp//t7kXbE60BIuw==;
Received: from [167.98.27.226] (helo=[10.35.6.194])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wcPC9-00HXJw-5j; Wed, 24 Jun 2026 16:07:17 +0100
Message-ID: <2ebb44d6-43b2-4e57-a044-9d3ec67ca6c7@codethink.co.uk>
Date: Wed, 24 Jun 2026 16:07:15 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm/btt: add endian conversion in dev_err in
 btt_log_read
To: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
 <ajscAZsK9ulXov8w@aschofie-mobl2.lan>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <ajscAZsK9ulXov8w@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ben.dooks@codethink.co.uk
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[codethink.co.uk,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[codethink.co.uk:s=imap4-20230908];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14519-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[ben.dooks@codethink.co.uk,nvdimm@lists.linux.dev];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:alison.schofield@intel.com,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:iweiny@kernel.org,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[codethink.co.uk:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.dooks@codethink.co.uk,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[codethink.co.uk:dkim,codethink.co.uk:mid,codethink.co.uk:url,codethink.co.uk:from_mime,lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1BC996BF902

On 24/06/2026 00:51, Alison Schofield wrote:
> On Mon, Jun 22, 2026 at 03:20:11PM +0100, Ben Dooks wrote:
>> The dev_err() call in btt_log_read() is passing a seq value
>> into dev_err() which is a __le32 without any conversion.
>>
>> Fix the following (prototype) sparse warnings:
>> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
>> drivers/nvdimm/btt.c:342:17:    expected int
>> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
>> drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
>> drivers/nvdimm/btt.c:342:17:    expected int
>> drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
> 
> Hi Ben,
> 
> Please revise the commit log.
> 
> The commit log is a message to all future readers, not a place to
> paste static analysis warnings and leave the user visible impact
> assumed, or as an exercise for the reader.
> 
> Prefer something like this:
> 
> 	When BTT log corruption is detected, btt_log_read() reports the
> 	sequence numbers of the two log entries. Those values are stored
> 	little-endian, so printing them without conversion can report
> 	byte-swapped sequence numbers on big-endian systems.
> 
> 	Convert the sequence numbers to CPU endianness before passing
> 	them to dev_err().
> 
> 	Issue reported by sparse.
> 
> 
> (There is no need for the sparse pastings.)

Thanks, I've posted a v2, with a reworded patch commit log.

The only comment is that I like the sparse warnings as it makes it
easier to search if there is a patch in flight for this.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

