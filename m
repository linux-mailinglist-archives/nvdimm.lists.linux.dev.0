Return-Path: <nvdimm+bounces-14485-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id EPYtIA5FOmpE5AcAu9opvQ
	(envelope-from <nvdimm+bounces-14485-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Jun 2026 10:34:22 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B249E6B54CC
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Jun 2026 10:34:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lgz/wib2";
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14485-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="nvdimm+bounces-14485-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3DBB13026A9C
	for <lists+linux-nvdimm@lfdr.de>; Tue, 23 Jun 2026 08:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5413C5DBB;
	Tue, 23 Jun 2026 08:34:14 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7750823EA84
	for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 08:34:13 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203654; cv=pass; b=iXm7G+X7Z47jcPZG/+H3dO65cOdmjMpbClFNg9sV092V/E0ntN3deO8piow7hw38KKFidveG4wIGmjnVC0Eg/dZFv/9dnwpCe6hEExQlviIjqCD+UkMKWXeBW5Ue6ZUEo+Ld5feeUKjYmOqKWvda6c6zWBCI2ofQgznPR4Sj3FU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203654; c=relaxed/simple;
	bh=OV2fW3pCtMFTTEV7ESe1I9XaCMwurSyjPz18E6Kt5OM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K+2cjDV4OOg8se2d/3NZJU0pJoM/ksRmTgRKw2ozPub66On29uflnpcdL68ZZHeLL0w/Mxyt/sCdj/dRiC3Eps+Vp5MKGZ1QpGmagI6Bh9mQ9Bvu5rc+Jxybos3BFnVsA2voWXjjvlIdE0bRa1SiPxHqfosTWjosvBGUW5E/2zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lgz/wib2; arc=pass smtp.client-ip=209.85.210.46
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6cdd78fe6so2803810a34.2
        for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 01:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782203652; cv=none;
        d=google.com; s=arc-20240605;
        b=Hvg/CkT1vpev5fsxAZPvZemNNoO9DgVj+45Y3tp56ynJ2p1/bdPwQPToGFK/9gsB6n
         b3b1naukDNfb08LTOgde5BFqApOkhnpWR0WMZRCmfZLUzTdIcp0q4OHvHjppjvxdBEuQ
         BadU+yAED/nY4S9exHIYKQdxZtBgBAs/CCmS6PNPlYtndxmemKjVHnCsigUpG5KNHN2d
         j7rueU+Jt9fouBzlK+31U1ScAfDnk7xr3z5cRdi/mh9CEkEsmIbLEREf5azJ5Dhy3KL0
         p0V6IkdZdHHfjqFMT1qYXvUWT1jxhqIibcUj8cmQc2EwA9q4fvXKDeurs4A/oANDnL1F
         YsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f1l2abI1ryKdUdqmih7/lMXELbJLXJ4khadRoH+x27k=;
        fh=gJ/Y/mlp/+0OmW0a4+J7hcfi0wMzHaf2b88rzVYBySU=;
        b=TA69KXlfH9eAPuR5iK1TPzSlLg8atnmOljDG41vnDN9tp+CcM7MHHmZ9JcK3Ao6o5Y
         xJPnwjtRTJ3k3LypSwtIxjxoDXJ1JjdlksPKzJxS6/iBDAku0/5B5esjretXGfkvNHJI
         8tWxh5dbD0l8ZzGXtEF2RGY6mlA6tUeIdhPHtzaLURlaHmNv3VXlnT3bvo3pCnPMUvlK
         eJsgzB1eAwk2Pn4A/1YBMOnbINc6jiinZvOEOHj2GoU+fnXM+/F+HiHPjeeUi2OBOhgw
         LdlaGOY509QVe+01QBkKd9le/bPt3Ar5w/++HF6ir7JuQ+sMwy0yVlX7KWAYwDISa4LY
         7W6Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782203652; x=1782808452; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f1l2abI1ryKdUdqmih7/lMXELbJLXJ4khadRoH+x27k=;
        b=lgz/wib2gHELaRSYlDuJ04Dj3bfNQo3zp3u8WJ0CHywE75BscydVPsgos39XPYb0VZ
         9+BYDzaa8ZTYgGY0QN5ZB4dSBO4FC7/hKBIXUMsSE55ryoWMq/WDqxPMEu6/fa5rTcQC
         9BzN0mO4NbTNiZ7VqetlOayPi5Oq8fBoR30mcLHNuiYY3UmcpOf1Rli/EgOoMa/KRhFC
         HbyLyUKEOyTfiWd5A9AActjGDG9eXg8NGEPuX5o0E1oVhzNwWsOQgFWRDj6AgoxOJZEQ
         5F5npOVT1mXxdLIhY9KiiFNK5Y6gxIQPOly78mRnvfCT5jo5wcSqPvp3cDnBZK+qf7Vt
         rP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782203652; x=1782808452;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1l2abI1ryKdUdqmih7/lMXELbJLXJ4khadRoH+x27k=;
        b=jYBiG2RqGygQnrfhboq6XHblomsuGWjewg52Gnk3a0XKhAL+pFE/L27l10SlvZZMbj
         EB03HohGI2dQA9yYPZ2aQwJ0araf0EE/1IIvJsPzL3xvVn+sDm3NaohvoYucQ6pRhROQ
         98gEkFVeXYRxnPcVK+HuThDyuAHU+2wsGzBFOYCmSynEi/MUVFGMS+6S/euw6lWlWAKm
         sZLuwRArRUwDKraW1LKOTtInjafLZrH8ZsTyZYPIo4T82oocVRF0g4+q9NqWz3ksTW6D
         EqEYHs6hhOd+uvNEPJRlN6e/FT4VW+/dZyv3RkCQTwapjjhddWu6ZphFv9yyKLYlb9LK
         A9mQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ZuB1j+lHRnfBm7Rb3HDk3xU6chwRYgqUCxcjnkAssFGJ3MUMIj41/nB5bvmlBd07sB3UTOxg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDkD2cuBDrL80ey1YIWZVjOM/9iWhGgmsV1OAjSp0Iu71lzA8j
	wTHgGwk4QXUV9V/ngJFEMXHa5iELZpCM8pECH91YYLYcslq5xdhqJeg3XPHH5er94sKLEV9B6zi
	xDlJuCN4Up+9Z+1Xo2aAnsowFA8fHxtQ=
X-Gm-Gg: AfdE7cliMFIsZBh8qnYt8yeNwo6UAAB/h9FGh0ADJ+zAJ+NMQmqE5MTRfGokxRSoCkx
	dbCQDvkMtGMWGpsxRFxfx01+J9c/iTN27/bk4HGbd2RoNSXLuWAoqmADX9n/+Y6QlHZ0iFcl4vf
	OuTfSOTUF764L4FW4d87gh3T4KHAign9OXhvt49vKzATvcpqU1j9lpcNDt265SRK7HDh0Ig6nw7
	s8UL9PJgggWJU9tiIeXLYt39MVuaClOjarozNvyENEQWPEnAC0Tn/ZV5ugcAwd6rqEYaXz4qwc=
X-Received: by 2002:a05:6830:4489:b0:7e6:ff83:4b36 with SMTP id
 46e09a7af769-7e979744c03mr1083770a34.8.1782203652447; Tue, 23 Jun 2026
 01:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-8-me@linux.beauty>
In-Reply-To: <20260621130246.2973254-8-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 23 Jun 2026 10:34:01 +0200
X-Gm-Features: AVVi8CfWC-Vqu4iDrDySDkpltMedRJpJ6Gq-lDYV2aqtP04PGGTk3D_rgV39oMw
Message-ID: <CAM9Jb+jeNUjOawATgq7+cU8KVq3ujxNaXF9y5bnta6jJ3_T+-w@mail.gmail.com>
Subject: Re: [PATCH v6 07/12] nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE()
 for wait flags
To: Li Chen <me@linux.beauty>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, virtualization@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-14485-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:me@linux.beauty,m:dan.j.williams@intel.com,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:ira.weiny@intel.com,m:alison.schofield@intel.com,m:virtualization@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[pankajguptalinux@gmail.com,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pankajguptalinux@gmail.com,nvdimm@lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,linux.beauty:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B249E6B54CC

> Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
> wq_buf_avail). They are observed by waiters without pmem_lock, so make
> the accesses explicit single loads/stores and avoid compiler
> reordering/caching across the wait/wake paths.
>
> Signed-off-by: Li Chen <me@linux.beauty>

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com

> ---
> v2->v3:
> - Split out READ_ONCE()/WRITE_ONCE() updates from patch 3/7 (no functional
>   change intended).
> v3->v4:
> - Rebased onto v7.1-rc7 and renumbered after the flush error patches.
>
>  drivers/nvdimm/nd_virtio.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 8ed4d6b3a9284..da829e9f4bdff 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -18,9 +18,9 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
>
>         req_buf = list_first_entry(&vpmem->req_list,
>                                    struct virtio_pmem_request, list);
> -       req_buf->wq_buf_avail = true;
> +       list_del_init(&req_buf->list);
> +       WRITE_ONCE(req_buf->wq_buf_avail, true);
>         wake_up(&req_buf->wq_buf);
> -       list_del(&req_buf->list);
>  }
>
>   /* The interrupt handler */
> @@ -34,7 +34,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
>         spin_lock_irqsave(&vpmem->pmem_lock, flags);
>         while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
>                 virtio_pmem_wake_one_waiter(vpmem);
> -               req_data->done = true;
> +               WRITE_ONCE(req_data->done, true);
>                 wake_up(&req_data->host_acked);
>         }
>         spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> @@ -66,7 +66,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>         if (!req_data)
>                 return -ENOMEM;
>
> -       req_data->done = false;
> +       WRITE_ONCE(req_data->done, false);
>         init_waitqueue_head(&req_data->host_acked);
>         init_waitqueue_head(&req_data->wq_buf);
>         INIT_LIST_HEAD(&req_data->list);
> @@ -87,12 +87,12 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                                         GFP_ATOMIC)) == -ENOSPC) {
>
>                 dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
> -               req_data->wq_buf_avail = false;
> +               WRITE_ONCE(req_data->wq_buf_avail, false);
>                 list_add_tail(&req_data->list, &vpmem->req_list);
>                 spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
>
>                 /* A host response results in "host_ack" getting called */
> -               wait_event(req_data->wq_buf, req_data->wq_buf_avail);
> +               wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
>                 spin_lock_irqsave(&vpmem->pmem_lock, flags);
>         }
>         err1 = virtqueue_kick(vpmem->req_vq);
> @@ -106,7 +106,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                 err = -EIO;
>         } else {
>                 /* A host response results in "host_ack" getting called */
> -               wait_event(req_data->host_acked, req_data->done);
> +               wait_event(req_data->host_acked, READ_ONCE(req_data->done));
>                 err = le32_to_cpu(req_data->resp.ret);
>         }
>
> --
> 2.52.0

