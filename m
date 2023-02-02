Return-Path: <nvdimm+bounces-5696-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8062C688623
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Feb 2023 19:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7FD71C20905
	for <lists+linux-nvdimm@lfdr.de>; Thu,  2 Feb 2023 18:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D40B8F5B;
	Thu,  2 Feb 2023 18:09:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9658F54
	for <nvdimm@lists.linux.dev>; Thu,  2 Feb 2023 18:09:11 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 48D347DE;
	Thu,  2 Feb 2023 18:09:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 48D347DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1675361345; bh=2+a4mZYwqT3vzf0UQzfkcA5CdDxOuo7YvzN9jr8nkig=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gY7ULbf3et5D4Qc/CNx/w7sCxqXxX6fR0sNacSV7nefpdle702hp6si3iizN6qwiE
	 uEIY7Q78a9h2RN4xfonCmMXE/H1WHGv23zZbRY3a8TD9z3xCs5/ly7iH92i4XVhMfk
	 m1+3SrM+pmOm5qUcXvYL8szbXDpSICOPir4Ff+tNZ80bHoZS0uhfOu3aabBosNVFfP
	 7pgupe9C5u4Sz6v8uZtM64S9OiXXXwx07OTa5szwYHdV6XxaRnf+mq/MpKQwaSbzh0
	 jfCb5rfx6sWATpmne99lGmlwL/b8o+ggGmLTspO1j2VtBWLoL4M3uxU9erIgFeIYC3
	 b3TsgnsFP3UgQ==
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, Tejun
 Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner
 <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org,
 linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Vinod Koul <vkoul@kernel.org>,
 dmaengine@vger.kernel.org, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Jean Delvare
 <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>,
 linux-hwmon@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, Frederic
 Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <quic_neeraju@quicinc.com>, Josh Triplett <josh@joshtriplett.org>,
 rcu@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
Date: Thu, 02 Feb 2023 11:09:04 -0700
Message-ID: <875yckvt1b.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
>
> These patches are based on linux-next-20230127.

So I've applied a bunch of these

>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling

applied

>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling

These have been taken up elsewhere

>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling

I've left these for the SCSI folks for now.  Do we *really* want to be
fixing spelling in ChangeLog files from almost 20 years ago?

>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling

Applied.

Thanks,

jon

