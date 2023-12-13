Return-Path: <nvdimm+bounces-7039-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 752F880E08D
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 01:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3091D2825A6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Dec 2023 00:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D31264F;
	Tue, 12 Dec 2023 00:56:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E672639
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 00:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VyKKeJX_1702342257;
Received: from 192.168.71.57(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VyKKeJX_1702342257)
          by smtp.aliyun-inc.com;
          Tue, 12 Dec 2023 08:50:59 +0800
Message-ID: <941aff31-6aa4-4c37-bb94-547c46250304@linux.alibaba.com>
Date: Tue, 12 Dec 2023 08:50:56 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC KERNEL] initoverlayfs - a scalable initial filesystem
To: Eric Curtin <ecurtin@redhat.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org
Cc: Daan De Meyer <daan.j.demeyer@gmail.com>,
 Stephen Smoogen <ssmoogen@redhat.com>, Yariv Rachmani <yrachman@redhat.com>,
 Daniel Walsh <dwalsh@redhat.com>, Douglas Landgraf <dlandgra@redhat.com>,
 Alexander Larsson <alexl@redhat.com>, Colin Walters <walters@redhat.com>,
 Brian Masney <bmasney@redhat.com>, Eric Chanudet <echanude@redhat.com>,
 Pavol Brilla <pbrilla@redhat.com>, Lokesh Mandvekar <lmandvek@redhat.com>,
 =?UTF-8?Q?Petr_=C5=A0abata?= <psabata@redhat.com>,
 Lennart Poettering <lennart@poettering.net>, Luca Boccassi
 <bluca@debian.org>, Neal Gompa <neal@gompa.dev>, nvdimm@lists.linux.dev
References: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2023/12/11 21:45, Eric Curtin wrote:
> Hi All,
> 
> We have recently been working on something called initoverlayfs, which
> we sent an RFC email to the systemd and dracut mailing lists to gather
> feedback. This is an exploratory email as we are unsure if a solution
> like this fits in userspace or kernelspace and we would like to gather
> feedback from the community.
> 
> To describe this briefly, the idea is to use erofs+overlayfs as an
> initial filesystem rather than an initramfs. The benefits are, we can
> start userspace significantly faster as we do not have to unpack,
> decompress and populate a tmpfs upfront, instead we can rely on
> transparent decompression like lz4hc instead. What we believe is the
> greater benefit, is that we can have less fear of initial filesystem
> bloat, as when you are using transparent decompression you only pay
> for decompressing the bytes you actually use.
> 
> We implemented the first version of this, by creating a small
> initramfs that only contains storage drivers, udev and a couple of 100
> lines of C code, just enough userspace to mount an erofs with
> transient overlay. Then we build a second initramfs which has all the
> contents of a normal everyday initramfs with all the bells and
> whistles and convert this into an erofs.
> 
> Then at boot time you basically transition to this erofs+overlayfs in
> userspace and everything works as normal as it would in a traditional
> initramfs.
> 
> The current implementation looks like this:
> 
> ```
>  From the filesystem perspective (roughly):
> 
> fw -> bootloader -> kernel -> mini-initramfs -> initoverlayfs -> rootfs
> 
>  From the process perspective (roughly):
> 
> fw -> bootloader -> kernel -> storage-init   -> init ----------------->
> ```
> 
> But we have been asking the question whether we should be implementing
> this in kernelspace so it looks more like:
> 
> ```
>  From the filesystem perspective (roughly):
> 
> fw -> bootloader -> kernel -> initoverlayfs -> rootfs
> 
>  From the process perspective (roughly):
> 
> fw -> bootloader -> kernel -> init ----------------->
> ```
> 
> The kind of questions we are asking are: Would it be possible to
> implement this in kernelspace so we could just mount the initial
> filesystem data as an erofs+overlayfs filesystem without unpacking,
> decompressing, copying the data to a tmpfs, etc.? Could we memmap the
> initramfs buffer and mount it like an erofs? What other considerations
> should be taken into account?

Since Linux 5.15, EROFS has supported FSDAX feature so that it can
mount from persistent memory devices with `-o dax`.

That is already used for virtualization cases like VM rootfs and
container image passthrough with virtio-pmem [1] to share page cache
memory between host and guest.

For non-virtualization cases, I guess you could try to use `memmap`
kernel option [2] to specify a memory region by bootloaders which
contains an EROFS rootfs and a customized init for booting as
erofs+overlayfs at least for `initoverlayfs`.  The main benefit is
that the memory region specified by the bootloader can be directly
used for mounting.  But I never tried if this option actually works.

Furthermore, compared to traditional ramdisks, using direct address
can avoid page cache totally for uncompressed files like it can
just use unencoded data as mmaped memory.  For compressed files, it
still needs page cache to support mmaped access but we could adapt
more for persistent memory scenarios such as disable cache
decompression compared to previous block devices.

I'm not sure if it's worth implementing this in kernelspace since
it's out of scope of an individual filesystem anyway.

[1] https://www.qemu.org/docs/master/system/devices/virtio-pmem.html
[2] https://docs.pmem.io/persistent-memory/getting-started-guide/creating-development-environments/linux-environments/linux-memmap

Thanks,
Gao Xiang

> 
> Echo'ing Lennart we must also "keep in mind from the beginning how
> authentication of every component of your process shall work" as
> that's essential to a couple of different Linux distributions today.
> 
> We kept this email short because we want people to read it and avoid
> duplicating information from elsewhere. The effort is described from
> different perspectives in the systemd/dracut RFC email and github
> README.md if you'd like to learn more, it's worth reading the
> discussion in the systemd mailing list:
> 
> https://marc.info/?l=systemd-devel&m=170214639006704&w=2
> 
> https://github.com/containers/initoverlayfs/blob/main/README.md
> 
> We also received feedback informally in the community that it would be
> nice if we could optionally use btrfs as an alternative.
> 
> Is mise le meas/Regards,
> 
> Eric Curtin
> 

