Return-Path: <nvdimm+bounces-12900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGSEI1nWeGmOtgEAu9opvQ
	(envelope-from <nvdimm+bounces-12900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:14:33 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CF00296743
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 16:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4DBE93072BC8
	for <lists+linux-nvdimm@lfdr.de>; Tue, 27 Jan 2026 14:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA3135CBC6;
	Tue, 27 Jan 2026 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9LdphS9"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B1235CB90
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525839; cv=pass; b=aiYCYqNmp7lQrCBg4DyN8Sf0+mQtdLJsXPxf6vVKY3x8UTNp89yGWEPXDtuMyc2OSJVpcKcvHOo1jALdC5U0OmMys+ed5CsrS+7wUmRGGLj4rLHRvmcCFs1qYkMgd4+Hn1Jw/fw8COqG44Cij12reas6unyXJotP57/lZi+c4Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525839; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ecgeuyd2BajS6St0QwMHyhCeA5347zgarkr/yMaZSezsgbeIOC31yUTnj55ULm8tX5FY4cxfNbKQ7/+4JTO1tscj8GJb/jlukQPeb6opQapDy8GeqiY6/FYxZe6Z5qK34mu0m5/bsRpIziYdOxqs+9B6loQyiosEIYe7KkJ/lGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9LdphS9; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b885e8c6727so820541166b.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525836; cv=none;
        d=google.com; s=arc-20240605;
        b=PHdRLi7GacWaYAI1VhfmKMp/BpzvefDaM/PH6maLQKzMFaQRH1vxsYGkSHa7deQcod
         iIFCsYYGvvrnZKqW57i8DiT/F2Ou3ojLebUNOgCA8Cpo3Mdow3aMy6/b99yH2VGKK8jV
         eG2iqdsE+TuXUeWuAceqLaJNJp/4VGZrrjF3XQPXoE6Y9CakOfpBEWdBjAGhJ6j9oVME
         dUthXb8Hbdh7LANj5pU4y+4Qw76AHs7xYCwtDDIS0EC54Qh73ARYlRIYiD4TuaK2Eu+d
         fsFXWIuRfAhBy45voT3M++53wYwOtJn8WkvFV5iVVO9Mkb6UJkUNDOGasU6JYRjeZGxU
         V3VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=hwL7FCjS3KHoPm09zmTsKwFPo9YCs2P3EkECr85bkqc=;
        b=ap0r1v+PjxGzRzXIhPLzeyurSG/RgEqxHxpVC2RneATk13cEq58K16gSmqryRjyfpK
         9nRPG95nFfshbM/+ljslpi5bq+YnjTJfY7SnzIg1fKFCUIeh2w6iExggR8o/2iDbmBmE
         944Gc4dUqgw4qy9ftPvz2aH6fviqMBV6Zo8XpiXG0P2P3iwu6Z0z4VFT4rnLrhcj4NJw
         qLWrSMX20SEj+0Yul5+uNaWm9ObrTlTllEYAaLhcHhriJ+IjareKBxNU4unHjxCq84kG
         gpX0DQ6tVJ1p7YjBrbRRWRkQkhcVUMzBgvZTTxudNngHiESiIlCaHvAbc0I0Uu2aNDOX
         flow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525836; x=1770130636; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=D9LdphS9igmbfXcuuEKl/I5W1WYUKZakgYgExBQ4yVoMQ7Jr0/hrPXP/tPc9JXC0p0
         suj2/ZrThmSu326ow4E9nYfY70lWyGswOhgGDAkltkOyaXFrChpuwOuxjUJk55ntI3SW
         CVGfPpbBogoZWT9VuL1hylm2ZKxXA3EinZg8FhBfANTUjqOynOArK/+KX7TAFx2eazzT
         GCp9MO72gdy5+FGP3JgPh4vPrgp4BzFQu0cuPY0s2UH6LNSQALKjfnJinDBKdG9yGttF
         jyMRNcFUM2U9mSwl1Wk358ugDZueyI0w20Tgy/922L4aifCbxFHn/GdFh+uLfp0qKjBC
         gjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525836; x=1770130636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=KtRStLtPUeaWnGnFcq3NU8Lxn9GoFpgphsHsNFfpsIoBB/AF5WHZVcq9dW8kiDG5gB
         Ihy684fQ12kiD6ryR8T/ND4PA8fSopXl7q1z4Pbta/+dX/k2MYbh0A98rnF/+4ayss6W
         T8XaK559WGotxd8wr8hIRUZ4h1UNd226cx2GSMMyWU+JKWH1wsZEDNsalEGoT/DwViPq
         PQ8koVH5CW3vP2xaV3nirLk69ziAL7NNWkc/qt169Tp105UZp5ZhEK2vhw7Tefj8jdPa
         m9Qed5jwLuir6xzpC4eeAsNB6xCCVQKrDv8RBMocE0ytnIQjz8fuIg2jt8SyHVebQjg5
         bB6w==
X-Forwarded-Encrypted: i=1; AJvYcCV98e2oyRAn4ltEDGSxBp0fmNknFKgYxwmSCkz0Vtg9lXhS6HCLA/9b0wjJ6C5bmJbPI/icKDk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7CH6V9hXeooWyULXaU1JLd4buA/JKQIfJOY5E9O1HP063evbl
	Dh7OEWLbu1VjOcHq311V1UfEQd9RVC1NuR6mCXQayiXaxhYkVSKhIfpwnzTpg0+M0KZTizdM4pj
	axFNRQPwFJZ8AsTytKwWjSG82SOKK0g==
X-Gm-Gg: AZuq6aKisHeJfxCF4vMfi9SzzeAHNDXgnpgYJR5qLv/J9lHGb+EHkntgHyTaLNofVVI
	eBy3n3RFsNNCm409Wk1a03i9N3GSzA7jlkMFRMN9aUhVdTyml94lmoxP4AcHNNON6xvbkAAgB5H
	JkRDb9NEhP5iHcrvDGEYsixGnprxfSro6xqEjXK4rceHHPSQzS6Db4z7rm6LEwnrOzySyULbhWP
	Q/YKUO3RBrALidmbWdB/UXw7aCLRTIjRTetur6iNc6HDEI63mH2xKcthFH+ffWi22dJ6y4IGl3+
	a59X/mfMSA546NGP0alXQxtjjhjnN1Fnnhl89VDaBYNBhdm1wnrvhoC1xg==
X-Received: by 2002:a17:907:3c94:b0:b88:4ff8:1300 with SMTP id
 a640c23a62f3a-b8daca89e5emr131696566b.26.1769525835895; Tue, 27 Jan 2026
 06:57:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-6-hch@lst.de>
In-Reply-To: <20260121064339.206019-6-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:26:37 +0530
X-Gm-Features: AZwV_Qh-bXQokozgO9CYibn8UPXNXVRECr1GxeaPZ8jRlXI3X_4jeQcXdNJkNL8
Message-ID: <CACzX3Avvr4e2LR9P_XDVtAXaU_KJqnO2SeUMc8Gh19H8-BpwgQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] block: make max_integrity_io_size public
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12900-lists,linux-nvdimm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,samsung.com:email]
X-Rspamd-Queue-Id: CF00296743
X-Rspamd-Action: no action

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

