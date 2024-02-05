Return-Path: <nvdimm+bounces-7319-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D8D84A3AA
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Feb 2024 20:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A46F11F2158A
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Feb 2024 19:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C1382D86;
	Mon,  5 Feb 2024 19:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5W4DRtA"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C2823D2;
	Mon,  5 Feb 2024 19:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707159806; cv=none; b=FsfOXE9gezVZYCxC8fLSP24DnAEH4viTw29GczA2s5hHTVDWayEqsmAWeQ8xn928PtHcgR+qp71sKXqcVHtMK+lBD6OiT5De54CamQNa0DikjgbdZJsHvi1A0Bc8jqTDQETRtBnaGBgVPTzzEJ7lPbL5JnhDUnn1oSUIRtw0QvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707159806; c=relaxed/simple;
	bh=l8E48JqEiLUq+g7VXEPmj7k+iRCuEuoIVhBVcSOCs+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyFwhWaXFizdeXC2y/NVWlwFH2w70W98Q7j6HLTUgUSFs0UyTGsBzZjHRBd1iCMDOcg8vw8dyLj6S1Qwtvg7YDINsYHRgGO30Ng7iQWjj6OC0g3cT0aq+W/7NoHQCOI7LZ6x3N7KZhK2EhDQ798wPLtQozWWabteLeUtdjLL/1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5W4DRtA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA30DC433B2;
	Mon,  5 Feb 2024 19:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707159806;
	bh=l8E48JqEiLUq+g7VXEPmj7k+iRCuEuoIVhBVcSOCs+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5W4DRtAaPYQYLTI2GDpbNqZhArXyaYqwC4gD1Nf/8IEAjgXZGTfZszxi9zmzxfC7
	 Jw82qTWG8pjVcPalq8zzEHZ4rTRkUbGRPbPvoIIFb8/Mqw1XsK+vUMamBGa7zGEb8o
	 qVIYjqI+qLw4D0l8W+7faoQ3m+H4kALXeAaChqTE=
Date: Mon, 5 Feb 2024 04:48:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Ricardo B. Marliere" <ricardo@marliere.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm: make nvdimm_bus_type const
Message-ID: <2024020512-bondless-suction-9ad5@gregkh>
References: <20240204-bus_cleanup-nvdimm-v1-1-77ae19fa3e3b@marliere.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204-bus_cleanup-nvdimm-v1-1-77ae19fa3e3b@marliere.net>

On Sun, Feb 04, 2024 at 05:20:07PM -0300, Ricardo B. Marliere wrote:
> Now that the driver core can properly handle constant struct bus_type,
> move the nvdimm_bus_type variable to be a constant structure as well,
> placing it into read-only memory which can not be modified at runtime.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

