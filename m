Return-Path: <nvdimm+bounces-5479-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6706465EE
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 01:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63895280C32
	for <lists+linux-nvdimm@lfdr.de>; Thu,  8 Dec 2022 00:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283CE38F;
	Thu,  8 Dec 2022 00:36:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93002372
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 00:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF6C433C1;
	Thu,  8 Dec 2022 00:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670459763;
	bh=8EqImzFDFK7SCDTb85EZXzmxEthwAPbCP4u3wA+fVVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qj8Ws3/FmYV9fzKhoMQtZHpgfiJPp8CSx2k3z/uJYemAhWfiuguoZUtJhnQHpjxTN
	 kAOwhDMb+3g2v60wt+E/ozBrWcN+iAy1T7zW4jScRe1kZMeAY51aT3uLWqyTEkLCIg
	 wObJgbcpW/t56PgtA6J40EnoAILsAVmP7mtN5dzBthLb32oQ2MoczwQgGWI2PHzxMc
	 XfgcYqvOB6UfnujKHBnXLFPww/KeIdmPdPuRzD7XPsKoRg5Az8bfQVGpEDdkDFadoC
	 m/2roapq2yF9V3+XdCIyDjtcP348AvcPbX+5jc8CCN9CbJ7HEmWCEySFVIoXuiAH2L
	 ee3NvjHxGvObw==
Date: Thu, 8 Dec 2022 00:35:55 +0000
From: Keith Busch <kbusch@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>, Gulam Mohamed <gulam.mohamed@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
	"minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"colyli@suse.de" <colyli@suse.de>,
	"kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"song@kernel.org" <song@kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"joe.jin@oracle.com" <joe.jin@oracle.com>
Subject: Re: [RFC for-6.2/block V2] block: Change the granularity of io ticks
 from ms to ns
Message-ID: <Y5Exa1TV/2VLcEWR@kbusch-mbp>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
 <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>

On Wed, Dec 07, 2022 at 11:17:12PM +0000, Chaitanya Kulkarni wrote:
> On 12/7/22 15:08, Jens Axboe wrote:
> > 
> > My default peak testing runs at 122M IOPS. That's also the peak IOPS of
> > the devices combined, and with iostats disabled. If I enabled iostats,
> > then the performance drops to 112M IOPS. It's no longer device limited,
> > that's a drop of about 8.2%.
> > 
> 
> Wow, clearly not acceptable that's exactly I asked for perf
> numbers :).

For the record, we did say per-io ktime_get() has a measurable
performance harm and should be aggregated.

  https://www.spinics.net/lists/linux-block/msg89937.html

