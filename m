Return-Path: <nvdimm+bounces-7694-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6268887798A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Mar 2024 02:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 102872818E7
	for <lists+linux-nvdimm@lfdr.de>; Mon, 11 Mar 2024 01:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA6123A6;
	Mon, 11 Mar 2024 01:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="A8nY/tsh"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E13A15A5
	for <nvdimm@lists.linux.dev>; Mon, 11 Mar 2024 01:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710120571; cv=none; b=BeXRcecjFPUbmZfd2cbj9QOcmYIcJYPqFEXNvaeTH11/YkPwxeiiaPsQau90W0KtdVqZXFNCRbyktWWDWCNBd7PMZe9PG2qpcZ+Jf9eTZBslpB3B9BOcRQ5nrdD9gAjWL/c802RAIHaexdgrYH6HKPdFvQNNQ7eT3xSPsu+H6AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710120571; c=relaxed/simple;
	bh=D+LFpG+DtzDxbDphPWqUCew6+zoXZ3tpB6Glycfh6Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvxKlgAw8y8J/SZfDV4fnionUyWWt0pjv6uwG0e8FtTcYdHPO2r6jKjdHZZPCKnUyviFGN2i0ft8C33rKSwsvAa3KzoBPYOZyYeDns13PoulLHFotE5B0YVfuJdRysVi7eDMj+bYJHlAxQYaSR/oP4G2xg2UnA97NPKE8tNneYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=A8nY/tsh; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-29b9f258cd9so2383567a91.3
        for <nvdimm@lists.linux.dev>; Sun, 10 Mar 2024 18:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710120569; x=1710725369; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hOSvhcvJGLEL7J8lpsnrtr4vlODvqiYxIBXUcrpqgiE=;
        b=A8nY/tsh8pSKgvRZWdk9m4ZOziRng81P23ZDI5zaOxBO2P2KGCub6XZOI6Hss6iPeL
         8hLNMIVqRu0MD3/bvZJOa8j7mJJS+GYh4NXpHUQB22ar/8bhQiLIWTU61aHMW0uOquXb
         Rf/9ut1cvlHA7HqDp+7daCYTgJvnpHS0qYAqToE4rYb+EHuzzzhdgsxw2tyDNiUVVDYb
         IQfIKBpRJhdtThgoGkVxWP2ADhYzi1XZ9HW7gB/d0W0NWjZYTOj4Ezgcixpdpyr0mOap
         l+ospMJqgeDyhOe9VuZsKAGdweQx94LINjlMVtwcfVgmU8L8UrLOOCHBMX4rRni2kd5p
         tQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710120569; x=1710725369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOSvhcvJGLEL7J8lpsnrtr4vlODvqiYxIBXUcrpqgiE=;
        b=PK90V4hdyAoIrGX/MuYcjDd+vBK7fwfbPWF2C6JcxePs4+t/JlnvKQJbCUqd1gsA+B
         OC3n/FFbcYj/nOhDF0UAjMNPI32lCrbA/I+dr2dayQrTsy/PbgJ9DXODbXgy7VrQFDqV
         UCp0BViRTy7zHlbmKsuDntBo396PSMWL026bS3Z2rbm9cTaNZ4IDxnaiVrgFYVTyRtPv
         hngyoHp6Epm7gSxEWzP23OcNvtwfVpflFft2qBx7NInvMzOikCfXHtdLyfhtD2S5IWR1
         /MXt4VDsFncQ/CBwmgn2hza/Ov+eOsGD0qyAuBa7lRcrzS0Ylt261J4rPUyQmHFSeC5b
         rhhg==
X-Forwarded-Encrypted: i=1; AJvYcCWl0TnmZ8lzBb3qADVKtE2xUQhmmPJvTa9yCIfL5M4mwN4pguJu0KmJAd3GYjkeJ6VItjfew28GIAvthRvSXzGPQrRVKfgU
X-Gm-Message-State: AOJu0YyADk7+UAz0kf6WRXDznMTeoQUIiJOF0cndD/cF0WibMGHaqEWY
	tNxhzKZf/BcCmEzqMLCj0k/G0FhloB/kS91lkMht9YJf+J0kahcv78UtuyVYAGM=
X-Google-Smtp-Source: AGHT+IFdH2KMViIbM49wC4hqTijDXwXYely9IKxeBYRM5XJT/JRC71uwCtS4jPxQ9NJv+E+Vquza9g==
X-Received: by 2002:a17:90b:e0e:b0:29b:ab0e:4f0a with SMTP id ge14-20020a17090b0e0e00b0029bab0e4f0amr3210258pjb.23.1710120568734;
        Sun, 10 Mar 2024 18:29:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a490300b0029bb4712610sm3400554pjh.6.2024.03.10.18.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 18:29:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rjUTl-000FPe-0k;
	Mon, 11 Mar 2024 12:29:25 +1100
Date: Mon, 11 Mar 2024 12:29:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Groves <John@groves.net>
Cc: Luis Chamberlain <mcgrof@kernel.org>, John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	john@jagalactic.com, Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <Ze5edU3JbLEFwJOH@dread.disaster.area>
References: <cover.1708709155.git.john@groves.net>
 <ZdkzJM6sze-p3EWP@bombadil.infradead.org>
 <cc2pabb3szzpm5jxxeku276csqu5vwqgzitkwevfluagx7akiv@h45faer5zpru>
 <Zdy0CGL6e0ri8LiC@bombadil.infradead.org>
 <w5cqtmdgqtjvbnrg5okdgmxe45vjg5evaxh6gg3gs6kwfqmn5p@wgakpqcumrbt>
 <CAB=NE6UvHSvTJJCq-YuBEZNo8F5Kg25aK+2im=V7DgEsTJ8wPg@mail.gmail.com>
 <mw4yhbmza4idassgbqeiti4ue7jq377ezxfrqrcbsbzsrmfiln@kn7qmqljvswl>
 <Zd/ovHqO/16PsUsp@dread.disaster.area>
 <5segby7xk6wbyblovpapdymiuvg63e5qarahc4pramhsqikx2x@y3zmih6mgs33>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5segby7xk6wbyblovpapdymiuvg63e5qarahc4pramhsqikx2x@y3zmih6mgs33>

On Thu, Feb 29, 2024 at 08:52:48AM -0600, John Groves wrote:
> On 24/02/29 01:15PM, Dave Chinner wrote:
> > On Mon, Feb 26, 2024 at 08:05:58PM -0600, John Groves wrote:
> > >    bw (  MiB/s): min= 5085, max=27367, per=100.00%, avg=14361.95, stdev=165.61, samples=719
> > >    iops        : min= 2516, max=13670, avg=7160.17, stdev=82.88, samples=719
> > >   lat (usec)   : 4=0.05%, 10=0.72%, 20=2.23%, 50=2.48%, 100=3.02%
> > >   lat (usec)   : 250=1.54%, 500=2.37%, 750=1.34%, 1000=0.75%
> > >   lat (msec)   : 2=3.20%, 4=43.10%, 10=23.05%, 20=14.81%, 50=1.25%
> > 
> > Most of the IO latencies are up round the 4-20ms marks. That seems
> > kinda high for a 2MB IO. With a memcpy speed of 10GB/s, the 2MB
> > should only take a couple of hundred microseconds. For Famfs, the
> > latencies appear to be around 1-4ms.
> > 
> > So where's all that extra time coming from?
> 
> Below, you will see two runs with performance and latency distribution
> about the same as famfs (the answer for that was --fallocate=native).

Ah, that is exactly what I suspected, and was wanting profiles
because that will show up in them clearly.

> > >   lat (msec)   : 100=0.08%
> > >   cpu          : usr=10.18%, sys=0.79%, ctx=67227, majf=0, minf=38511
> > 
> > And why is system time reporting at almost zero instead of almost
> > all the remaining cpu time (i.e. up at 80-90%)?
> 
> Something weird is going on with the cpu reporting. Sometimes sys=~0, but other times
> it's about what you would expect. I suspect some sort of measurement error,
> like maybe the method doesn't work with my cpu model? (I'm grasping, but with
> a somewhat rational basis...)
> 
> I pasted two xfs runs below. The first has the wonky cpu sys value, and
> the second looks about like what one would expect.
> 
> > 
> > Can you run call-graph kernel profiles for XFS and famfs whilst
> > running this workload so we have some insight into what is behaving
> > differently here?
> 
> Can you point me to an example of how to do that?

perf record --call-graph ...
pref report --call-graph ...


> I'd been thinking about the ~2x gap for a few days, and the most obvious
> difference is famfs files must be preallocated (like fallocate, but works
> a bit differently since allocation happens in user space). I just checked 
> one of the xfs files, and it had maybe 80 extents (whereas the famfs 
> files always have 1 extent here).

Which is about 4MB per extent. Extent size is not the problem for
zero-seek-latency storage hardware, though.

Essentially what you are seeing is interleaving extent allocation
between all the files because they are located in the same
directory. The locality algorithm is trying to place the data
extents close to the owner inode, but the indoes are also all close
together because they are located in the same AG as the parent
directory inode. Allocation concurrency is created by placing new
directories in different allocation groups, so we end up with
workloads in different directories being largely isolated from each
other.

However, that means when you are trying to write to many files in
the same directory at the same time, they are largely all competing
for the same AG lock to do block allocation during IO submission.
That creates interleaving of write() sized extents between different
files. We use speculative preallocation for buffered IO to avoid
this, and for direct IO the application needs to use extent size hints
or preallocation to avoid this contention based interleaving.

IOWs, by using fallocate() to preallocate all the space there will
be no allocation during IO submission and so the serialisation that
occurs due to competing allocations just goes away...

> FWIW I ran xfs with and without io_uring, and there was no apparent
> difference (which makes sense to me because it's not block I/O).
> 
> The prior ~2x gap still seems like a lot of overhead for extent list 
> mapping to memory, but adding --fallocate=native to the xfs test brought 
> it into line with famfs:

As I suspected. :)

As for CPU usage accounting, the number of context switches says it
all.

"Bad":

>   cpu          : usr=15.48%, sys=1.17%, ctx=62654, majf=0, minf=22801

"good":

>   cpu          : usr=14.43%, sys=78.18%, ctx=5272, majf=0, minf=15708

I'd say that in the "bad" case most of the kernel work is being
shuffled off to kernel threads to do the work and so it doesn't get
accounted to the submission task.  In comparison, in the "good" case
the work is being done in the submission thread and hence there's a
lot fewer context switches and the system time is correctly
accounted to the submission task.

Perhaps an io_uring task accounting problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

