Return-Path: <nvdimm+bounces-904-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD9C3F21B2
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Aug 2021 22:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id D13661C0E85
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Aug 2021 20:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40653FC5;
	Thu, 19 Aug 2021 20:35:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1E3FC0
	for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 20:35:39 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id x1so2068986plg.10
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2lq1/9dzMwse8hgj+nLsRtNNVHy5Ra8cI/pFGIqflik=;
        b=2RKmo3Q2iKNSxDasfmEsswnoQ8z3YAyLtAaZ/HjlU037dI8WGM89auY+HT0DGdfQG5
         U/MVHxJdBMIcF+Bd+xSvtL95UEX2dwFl/L/z3oPUnO/aigHxiu57hkL3swk7sYKK8eoK
         OPWWqbTNA4eO3pFQE3oPGvv1E3fjsnrOGOVy65plV9Zqf0TYsbeSGghf1ADPutP9iZR1
         5qcOPhlcQ0vwLOx7+tVxh274/kANbc4PzXIIj1zUrQt/iw6E5iILNWMZccVLZCykIsql
         szt7T9dgmeVXyvOI4dVbuIMMnv9/0iFbmrxmbHF8Fdu9z40bAQVIYwD2gzFvHS2c+7l1
         Qchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2lq1/9dzMwse8hgj+nLsRtNNVHy5Ra8cI/pFGIqflik=;
        b=Km+mRghHdGDZbAuC6OtiRFeBpawc+VtCLrIyWax4DdwP41PLWV4vbyqTzfTquFmnNm
         K62vviabzb9Rze5RJwbxRn5C/pmC3I3wEGppPFjm/3WfRjQNlEhYcdRkO8nK8o8gY/wA
         JiaVn/vlxYj8izQXe2wXpvklakkGCJHUjveWkw2Y+1uorifG3IZvlC6++dPa7EpFKHR4
         4VM2LmWH8H6Wr14fuYb/z8rw0mvdi5+7A1VWOqgwXvujmvs9Qkpkg565N7Cxz3Jbiju5
         S/3wbltd2MyoypIxDR6RREfFtBMyOZdB0y1kljIxBeIBr6+ZGCEPc4JcimUufgCh9rIt
         vOoQ==
X-Gm-Message-State: AOAM531ylVJXE+34RQ87xsn0/edHxWZh6d9mXLzqWYVDCBVd6nwbKpIB
	uKwKWO5Ztyoz7o/l3sO0uxdLxoUdniWUPhbYgKGeiw==
X-Google-Smtp-Source: ABdhPJxSp6xtccEDJJJY44GOHyKJniTxZ6vHD+7V+PQJrY3uECT6oRKOpiFktsbnpDGqKIO/PuciS0G+rhFl437R2uk=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr628765pjk.13.1629405339323;
 Thu, 19 Aug 2021 13:35:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-8-hch@lst.de>
In-Reply-To: <20210809061244.1196573-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 13:35:28 -0700
Message-ID: <CAPcyv4iRUYcZAMgiDLXDW-bRZxeRzAnWOgNJ4UL==CQX83_jxQ@mail.gmail.com>
Subject: Re: [PATCH 07/30] fsdax: mark the iomap argument to dax_iomap_sector
 as const
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 8, 2021 at 11:19 PM Christoph Hellwig <hch@lst.de> wrote:

I'd prefer a non-empty changelog that said something like:

"In preparation for iomap_iter() update iomap helpers to treat the
iomap argument as read-only."

Just to leave a breadcrumb for the motivation for this change, but no
major worry if you don't respin for that.

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Otherwise, LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

