Return-Path: <nvdimm+bounces-12896-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KUHJDHWeGmNtQEAu9opvQ
	(envelope-from <nvdimm+bounces-12896-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:13:53 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E15966E0
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3464B3099645
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 14:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE23935CB76;
	Tue, 27 Jan 2026 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAuttghF"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4439133B6C3
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525755; cv=pass; b=mD2dX1crhrUsKM1zjxYDAxwBPvlons8eXMxdKhvuXpjEEIvQeOJ1Atro7r/x3N13iZsdjxyBQ3IaUSUVYj+PM2OdOe2+2t8nChkLw5wyFZdHuQOD3OHmM0a8I0w+ybbdVmbi7vZ56XAwbvcl5OtMETiIOFwwMsSrMEy8WUaSHRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525755; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+ls7vhodPcKg+4REm1CwrTxISAo2UCsWyM5Ab28nwKzKGOSKau/Ie5IWeS6bZKdHWTAzIbGZX9gQ4CjeBNYfc/iPoeTtb4qxbD4YeFyrKfJF/rD0uhiffprGrZJB6iE81aGIPPx0+cH7V0ydPwK/5bBDd00M1nROFPlwmmjiA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAuttghF; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8707005183so885712066b.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:55:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525753; cv=none;
        d=google.com; s=arc-20240605;
        b=kIJe6xl54U7Lpp8CIO32x8n1aO6Gczm3K4WC8/6PpOgzPkHn62IV/UwJ6lWVXgzeIz
         TzrgVNOAdU1pdrbAdT8WcL0Vyi5ZFEwGRPXIVmy7XKV0zebeC+6KGElkiJx8/0OJ5laK
         TuOyKSczj9NPr/GZ/FA/gJ6uxBazX002eda1P/II8Ml6tH6izQc+py57kvlPdkc10tov
         uJDcVlGZhkFrSrb0wLQVYZm8myk9OfaBYhrtEl6V9il1vtkizpbGCGpg+j1Kl0Ketrbz
         ZWZj0ZQq/V5fm0HTT7i2zeeBLMOkYiPdOC84iZQsh3QoqZBR0prbAgOV7xPb+9sKbA08
         /ZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=lN3wFXVBFd2HHKBuQXlNFNOkleVVgEap04HGxFL221M=;
        b=LGJa1kxpEaz6XNQq8m5xfF8er8Ot+ZHlvYidsWKqb1/NZZJWh/uJ/N1a6J1s1AO0v0
         HFIG7EwSLIykNsFW1dwLWnJurAB4g7vZOmIHX0eohLFBq+nzPlQFIHWy2dK34Fp6FdTI
         VKpG2s3Y1LR9aXwfchfgoq7a5CRFhIPck9Qlu7PObjvq/v2H1B0oAWQTxV71YrnF95JY
         HkBvG0EqecFsoT7ZNi1mDRoHPAZ1Y+/1d4lQ6ChzHRjaFMblMqZP2+adokdvhcj0XfXi
         yTszxJg/iarUMzaGmW74TAN8h8T5YMvLv8EexDNKUnKsAtEqX/orcYoDg0LtN8FG/y4x
         E9wQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525753; x=1770130553; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=LAuttghFj27nWA1KcR7wJxu59lejueicvGV+YUyFs/wauTSd83sLrdcmq7jsT3skUc
         IIExxLCHcvhrMCG7Ec5Z7NsA9NxWtciDAdelTXIRBewfMChhQr+GO/8KdMvLj88XsU6a
         IMsmlqvY2ZO8seN6vuEfBMvcrCJx00s6kzKrkV5wmTk1K6WFQ9mzq4/lcO8TEw5+7AWP
         OipscazatcszrT2aYij/YBY6enmhX/eSHAQUmQ0CB5G3Mv/kQPt2fDtHHem8dta1pGAP
         l8V196MyKEUlJn0NrsYkT9eoUL7Y5UXzJKc4IblVtYuoIRBRbHhzSMjkdD8EiIjBYGsl
         ce4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525753; x=1770130553;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=o2miCW7QmkB+5k2re8BeSq21MEa23T0EWHohxVFeqvbhwvWRv1egXgdl3HhDlQTRxm
         fomjBpauAhbBOuEXuUwLIo1Sj+lb0NKYn7OTW6U4V/MB/79r4jACn8QKSQ3tz0fqOUY4
         d+as3AzlIYuHTynHFVEWXqgcAd69F40CsDPmAt51uIfyMgDrCL/T4rcLO+UXb4H94YyA
         aqpUiA2gCo8OIngoKG5V5z4XdzqXNup8nXcx4PNxfHlQAAPivVQ+TffbgrWHGG9V43CJ
         F/VQNJ7g/LfKICJfT7wHKoie5iMBtnG3D7rB0RWRBCKmGSMoi1VuzUTJLHasjddgaC78
         A27Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQkFv1kuzX0+12ERVxrITBs6DUWK79KYVMO/ba9wi8txbKMCJBalJRBJri+zWftU6u6RVgqo0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHcO05DTY2D39rxWmeY16NBICDrCOy8QeAe0VaCHtaxHOjJiFd
	JWGCE13ITtmJXoc6/LCYaq49pPVnj8Ky3dcqgPNhz8JA0sSNh1A389padyy/xNompfvavHz8Q2b
	FoowSmYTVABO15+IDDYiIlsMEpMR5qA==
X-Gm-Gg: AZuq6aI7zHO/N7FkV3cPivfjDqeuy9WxzNKLpMuT238UzR1xXsyW/8DME6h72ZmH1wZ
	zmbCbHgesUP+b9K2NOPirEuzCTLPJumHXKXq8Mp4VcbkHGtrMXRZb8nqQALP+RcV6bbUqKIzDU7
	NaAu4ABAZ5jhSHc1hLMCoYHUi2iRe9LU23yZYS4OfxILHr2njY8vlCIyVpi2avS6OrySt3Idna6
	sLmbtsTIqaWShYgC1NdDAVwfNSXNTvojUGPggbbEJyYmIHwrcyPqbGmtl+6/jyNUqCykOa3WyM8
	xb6mXu1hRZoyzecVuziQ5PE384Tmzd+0R1ZCTJNvfaOEZX7zsK+KBKXgWQ==
X-Received: by 2002:a17:906:fe07:b0:b88:4b1f:5b1f with SMTP id
 a640c23a62f3a-b8dab423cfamr153134566b.38.1769525752488; Tue, 27 Jan 2026
 06:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-2-hch@lst.de>
In-Reply-To: <20260121064339.206019-2-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:14 +0530
X-Gm-Features: AZwV_Qh0N_xMlo-Jek-4Bqvm2KfCqCHKR16PVHuC2EtfsXWdRHcPY9i5RteQhPQ
Message-ID: <CACzX3Av31ZUXb9mVGkEm1=+gbH8SFeCd_k7hG6MD5MHosWKBHA@mail.gmail.com>
Subject: Re: [PATCH 01/15] block: factor out a bio_integrity_action helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12896-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,samsung.com:email]
X-Rspamd-Queue-Id: 06E15966E0
X-Rspamd-Action: no action

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

