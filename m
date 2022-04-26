Return-Path: <nvdimm+bounces-3716-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F63E5103AE
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 Apr 2022 18:38:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A9DA280AA7
	for <lists+linux-nvdimm@lfdr.de>; Tue, 26 Apr 2022 16:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718E7258F;
	Tue, 26 Apr 2022 16:38:39 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AA57B
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 16:38:37 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0EE181F380;
	Tue, 26 Apr 2022 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1650991116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LKA1JyRJjWGTYGvEGOHmNW4L3n55zJuXWA5Ivf87G6g=;
	b=bq3BKyRf9nqWYObxLiA3xYv2x8AjnXL++n1W94XOSlTwy+3qJLjpNv+SbF32fVMshT/KbK
	+mObCDP09xSauz4EEL8+/7k781+JbJYShAuyoRblULNi0HttyfzBzwt8oHOsYnqG/PP/xG
	wdGHcwUxStqJVNqFVXpsgIOXRKS+yJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1650991116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LKA1JyRJjWGTYGvEGOHmNW4L3n55zJuXWA5Ivf87G6g=;
	b=RyhyT905GqUAiZiQVsqHmK+dZMfokmVv8mH3a+pwypj56jiMhMb9ZS3bJ1uEKIYb93bqYa
	BRsD0RDFf5P7aGCQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id ECE0D2C141;
	Tue, 26 Apr 2022 16:38:35 +0000 (UTC)
Date: Tue, 26 Apr 2022 18:38:34 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: ndctl tests usable?
Message-ID: <20220426163834.GI163591@kunlun.suse.cz>
References: <20220426123839.GF163591@kunlun.suse.cz>
 <CAPcyv4j66HAE_x-eAHQR71pNyR0mk5b463S6OfeokLzZHq5ezw@mail.gmail.com>
 <20220426161435.GH163591@kunlun.suse.cz>
 <CAPcyv4iG4L3rA3eX-H=6nVkwhO2FGqDCbQHB2Lv_gLb+jy3+bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4iG4L3rA3eX-H=6nVkwhO2FGqDCbQHB2Lv_gLb+jy3+bw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Apr 26, 2022 at 09:32:24AM -0700, Dan Williams wrote:
> On Tue, Apr 26, 2022 at 9:15 AM Michal Such�nek <msuchanek@suse.de> wrote:
> >
> > On Tue, Apr 26, 2022 at 08:51:25AM -0700, Dan Williams wrote:
> > > On Tue, Apr 26, 2022 at 5:39 AM Michal Such�nek <msuchanek@suse.de> wrote:
> > > >
> > > > Hello,
> > > >
> > > > there is some testsuite included with ndctl, and when following the
> > > > instructions to build it most tests fail or are skipped:
> > > >
> > > > [   95s] Ok:                 3
> > > > [   95s] Expected Fail:      0
> > > > [   95s] Fail:               5
> > > > [   95s] Unexpected Pass:    0
> > > > [   95s] Skipped:            15
> > > > [   95s] Timeout:            0
> > > >
> > > > Is this the expected outcome or is this a problem with the ndctl build?
> > > >
> > > > Attaching test run log.
> > >
> > > I see a few missing prerequisites:
> > >
> > > [   78s] /usr/src/packages/BUILD/ndctl-73/test/pmem-errors.sh: line
> > > 64: mkfs.ext4: command not found
> > > [   95s] /usr/src/packages/BUILD/ndctl-73/test/security.sh: line 25:
> > > jq: command not found
> >
> > Indeed, with those installed I get much more tests passing:
> >
> > [  148s] Ok:                 13
> > [  148s] Expected Fail:      0
> > [  148s] Fail:               4
> > [  148s] Unexpected Pass:    0
> > [  148s] Skipped:            6
> > [  148s] Timeout:            0
> >
> > >
> > > This report:
> > >
> > > [   51s]  1/23 ndctl:ndctl / libndctl               SKIP
> > > 0.02s   exit status 77
> > >
> > > ...seems to indicate that the nfit_test modules did not appear to load
> > > correctly. I never expected that the nfit_test modules would be
> > > redistributable, so I was surprised to see them being installed by an
> > > actual package "nfit_test-kmp-default-0_k5.17.4_1-6.1". The reason
> > > they are not redistributable is because they require replacing the
> > > production build of the kernel provided modules libnvdimm.ko,
> > > nd_pmem.ko, etc... What I expect is happening is that the production
> > > version of libnvdimm.ko is already loaded (or is the only one on the
> >
> > AFAICT neither is the case, that's why I dump the module information in
> > the log.
> 
> The modinfo just tells you what modules are available, but it does not
> necessarily indicate which modules are actively loaded in the system
> which is what ndctl_test_init() validates.

Isn't what modinfo lists also what modrobe loads?

There isn't any pmem so I don't see why production modules would be
loaded before the test modules are installed. Unloading the modules
first does not really make any difference.

Thanks

Michal

