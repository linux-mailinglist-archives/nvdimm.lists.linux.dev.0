Return-Path: <nvdimm+bounces-3798-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7206F522A9C
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 May 2022 05:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 324272E0A12
	for <lists+linux-nvdimm@lfdr.de>; Wed, 11 May 2022 03:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2690515C7;
	Wed, 11 May 2022 03:56:34 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C16F15B4
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 03:56:32 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d22so659737plr.9
        for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 20:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elq3ZqCelpCSxkkjk1LXdyA6w9hgB+SCHXKMgxWGx/U=;
        b=f0WEcC7jjPTFG6Q6v9mT/VTbUk6akakqKqThuRBA10OtcmKjJs4FotEBdprRTmZrZF
         Kb8j00IvxlaVvxLhVF+olvEM7z068yqNY7DUksi25Wuhc+ittQMbF3sNNuMlrjp0trft
         jPe+SBWtYADIgBt1U9crcisYDlPyJy9V3ts222QP9S+ZNj9WdGzgEwTfgBNGgl9lTyX0
         2Fv+/xdOFKMtT6Hvk7/sOzspO4aPku8B/XAFXgUu6zqe5yJcQO9LXB8JSfcNQzqAzBt6
         y50LLDXRRm0M8Qj3TiD3Vhrh3vbutMS5qxe2s2RBw/glkC+5rS+kVBVhvbLF5i3xYVL7
         tJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elq3ZqCelpCSxkkjk1LXdyA6w9hgB+SCHXKMgxWGx/U=;
        b=wn4lwF+ELxek2dP4Nb3zE2kfYzAyfqWlng4fzXcg+QiL1JFCEgH8DMp/wvgIlyC85a
         hsqhRDVuGruBUDLalsDnnWmIBkH9xAtOcqVcnDhZMBHEsJV79+z/hDouSKfrFiTD2dNj
         Ve4oN81l+rkYSM2fK7ikYQsZzMfD/kXhfrBqkQGYYvjiGIMOz1iQHGivxCPfpppYDsrs
         5gh73SmljX2g3E0g4EkXu7u11+iz/4X/fUag2VRQHUs02qFbr+dr9/ayyN44hvXwXomO
         5/hg6FRhjHgWKkUs8monPtPrz6XBXfjSriyQEhyTmJm2r7iE6LxQSyKeXjgSCr58pSy8
         SHyw==
X-Gm-Message-State: AOAM532y1ycgIwaQruqzm44woilEx1xJeerRihz/VLRLo6IgnkFSt5PE
	Do+tnzVIa29nYSypC23K43mTZDOPnrLHQLPWuf0PmA==
X-Google-Smtp-Source: ABdhPJw5n1KJcz8j1FP3c7A6fBBMc1hcuPZsn2gE31BtaT8knvxsmvrFDZQnLCp0J+6DmYbEonpCWUJBRb2zAP6Umfo=
X-Received: by 2002:a17:902:da8b:b0:15e:c0e8:d846 with SMTP id
 j11-20020a170902da8b00b0015ec0e8d846mr23539490plx.34.1652241391912; Tue, 10
 May 2022 20:56:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com> <20220422224508.440670-4-jane.chu@oracle.com>
 <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
In-Reply-To: <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 May 2022 20:56:21 -0700
Message-ID: <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] mce: fix set_mce_nospec to always unmap the whole page
To: Jane Chu <jane.chu@oracle.com>, Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	"Luck, Tony" <tony.luck@intel.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 22, 2022 at 4:25 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> [ Add Tony as the originator of the whole_page() logic and Jue who
> reported the issue that lead to 17fae1294ad9 x86/{mce,mm}: Unmap the
> entire page if the whole page is affected and poisoned ]
>
>
> On Fri, Apr 22, 2022 at 3:46 PM Jane Chu <jane.chu@oracle.com> wrote:
> >
> > The set_memory_uc() approach doesn't work well in all cases.
> > As Dan pointed out when "The VMM unmapped the bad page from
> > guest physical space and passed the machine check to the guest."
> > "The guest gets virtual #MC on an access to that page. When
> > the guest tries to do set_memory_uc() and instructs cpa_flush()
> > to do clean caches that results in taking another fault / exception
> > perhaps because the VMM unmapped the page from the guest."
> >
> > Since the driver has special knowledge to handle NP or UC,
> > mark the poisoned page with NP and let driver handle it when
> > it comes down to repair.
> >
> > Please refer to discussions here for more details.
> > https://lore.kernel.org/all/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com/
> >
> > Now since poisoned page is marked as not-present, in order to
> > avoid writing to a not-present page and trigger kernel Oops,
> > also fix pmem_do_write().
> >
> > Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Jane Chu <jane.chu@oracle.com>

Boris,

This is the last patch in this set that needs an x86 maintainer ack.
Since you have been involved in the history for most of this, mind
giving it an ack so I can pull it in for v5.19? Let me know if you
want a resend.

