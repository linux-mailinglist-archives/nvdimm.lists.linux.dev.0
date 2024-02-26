Return-Path: <nvdimm+bounces-7561-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C896586766A
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 14:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 766E41F274FA
	for <lists+linux-nvdimm@lfdr.de>; Mon, 26 Feb 2024 13:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C56127B79;
	Mon, 26 Feb 2024 13:25:44 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BD2127B61
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 13:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708953944; cv=none; b=lJwgNKaXNGJFTbL+Fqr3T8vDyx/GiPi851wwT3GWXUy/wOOqq5iK+rh6LkDcIaBPTNGQRP+M2RSFkwnbi8Yv2uuwSa5fRosoHitLD0pXncJcBnEhyy+hYHrjAIraSEq4fiH/5yuz1lIyttEEuZtvMokcm3Ur5KNphF7STD4axxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708953944; c=relaxed/simple;
	bh=u2OYFseBDBv+gj6x9L887oAOOsq7PZaQa4/b9bbukLo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SI/o2ZW8OSUd5fo2a7nov0M0fK7lwia//CEm0S3l6acfoNcUL14qKEb8GX5dv20tL4Io2VpQXBEfh0jPyDhpplrz48DTIvUCqVfuCpAdNwOFQeaKckgNLqW3kS/kGIqr+r6iko4LcVBw7imQB14DynkzbbfchqIKCwlC9bwoY5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk1Ts4xsjz6K5xc;
	Mon, 26 Feb 2024 21:21:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 503B8140CB9;
	Mon, 26 Feb 2024 21:25:40 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 13:25:39 +0000
Date: Mon, 26 Feb 2024 13:25:38 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: John Groves <John@Groves.net>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <john@jagalactic.com>, Dave Chinner
	<david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	<dave.hansen@linux.intel.com>, <gregory.price@memverge.com>
Subject: Re: [RFC PATCH 12/20] famfs: Add inode_operations and
 file_system_type
Message-ID: <20240226132538.00002656@Huawei.com>
In-Reply-To: <bd2bbdd7523d1c74ca559d8912984e7facabe5c6.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
	<bd2bbdd7523d1c74ca559d8912984e7facabe5c6.1708709155.git.john@groves.net>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Feb 2024 11:41:56 -0600
John Groves <John@Groves.net> wrote:

> This commit introduces the famfs inode_operations. There is nothing really
> unique to famfs here in the inode_operations..
> 
> This commit also introduces the famfs_file_system_type struct and the
> famfs_kill_sb() function.
> 
> Signed-off-by: John Groves <john@groves.net>

Trivial comments only.

> +
> +/*
> + * File creation. Allocate an inode, and we're done..
> + */
> +/* SMP-safe */
> +static int
> +famfs_mknod(
> +	struct mnt_idmap *idmap,
> +	struct inode     *dir,
> +	struct dentry    *dentry,
> +	umode_t           mode,
> +	dev_t             dev)
> +{
> +	struct inode *inode = famfs_get_inode(dir->i_sb, dir, mode, dev);
> +	int error           = -ENOSPC;
> +
> +	if (inode) {

As below. I would flip it for cleaner code/ shorter indent etc.

> +		struct timespec64       tv;
> +
> +		d_instantiate(dentry, inode);
> +		dget(dentry);	/* Extra count - pin the dentry in core */
> +		error = 0;
> +		tv = inode_set_ctime_current(inode);
> +		inode_set_mtime_to_ts(inode, tv);
> +		inode_set_atime_to_ts(inode, tv);
> +	}
> +	return error;
> +}
> +
> +static int famfs_mkdir(
> +	struct mnt_idmap *idmap,
> +	struct inode     *dir,
> +	struct dentry    *dentry,
> +	umode_t           mode)
> +{
> +	int retval = famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
> +
> +	if (!retval)
> +		inc_nlink(dir);

Copy local style, so fine if this is common pattern, otherwise I'd go for
consistent error cases out of line as easier for us sleepy caffeine 
deprived reviewers.


	if (retval)
		return retval;

	inc_nlink(dir);

	return 0;
> +
> +	return retval;
> +}
> +
> +static int famfs_create(
> +	struct mnt_idmap *idmap,
> +	struct inode     *dir,
> +	struct dentry    *dentry,
> +	umode_t           mode,
> +	bool              excl)
> +{
> +	return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
> +}
> +
> +static int famfs_symlink(
> +	struct mnt_idmap *idmap,
> +	struct inode     *dir,
> +	struct dentry    *dentry,
> +	const char       *symname)
> +{
> +	struct inode *inode;
> +	int error = -ENOSPC;
> +
> +	inode = famfs_get_inode(dir->i_sb, dir, S_IFLNK | 0777, 0);
	if (!inode)
		return -ENOSPC;

> +	if (inode) {
> +		int l = strlen(symname)+1;
> +
> +		error = page_symlink(inode, symname, l);
	if (error) {
		iput(inode);
		return error;
	}
	
	...

> +		if (!error) {
> +			struct timespec64       tv;
> +
> +			d_instantiate(dentry, inode);
> +			dget(dentry);
> +			tv = inode_set_ctime_current(inode);
> +			inode_set_mtime_to_ts(inode, tv);
> +			inode_set_atime_to_ts(inode, tv);
> +		} else
> +			iput(inode);
> +	}
> +	return error;
> +}



