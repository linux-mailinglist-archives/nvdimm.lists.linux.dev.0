Return-Path: <nvdimm+bounces-7324-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E8F84A3B9
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Feb 2024 20:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A62131F2263D
	for <lists+linux-nvdimm@lfdr.de>; Mon,  5 Feb 2024 19:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F12B8563C;
	Mon,  5 Feb 2024 19:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eom6jy+X"
X-Original-To: nvdimm@lists.linux.dev
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37708405D;
	Mon,  5 Feb 2024 19:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707159807; cv=none; b=h8gJ7Yq1mVGGzGFxXxEz3/bvN1KlnYUSEQx2MF18qCTN/rfUFita7sfWIp5h6wr7EiIAl23hjY8uLSJiAK0gPHRTcwrsewepe9eOA06fqCx7dFnQmLJa+4xhoQXqpA0J35RnNvIE8Xt9nzcLEA2GxyZbKTaZu0pRg9ealYZwHfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707159807; c=relaxed/simple;
	bh=l8E48JqEiLUq+g7VXEPmj7k+iRCuEuoIVhBVcSOCs+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsV49zVEQAoNIDoFMsTcBHZhGXb1E8ya79oN04GIDrFS/If5ldhgckg/vMjn1XJn/e+SGVUQ5nsknEI0f2v1ouiMabnkjdUvcseZrpssCfM1WhSuyPyLBKol/53AJ7GZn4OAjDhvWgGYBJo8B6JTiR9ITEVNd0HSbUvyTMZbtto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eom6jy+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE90C433F1;
	Mon,  5 Feb 2024 19:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707159807;
	bh=l8E48JqEiLUq+g7VXEPmj7k+iRCuEuoIVhBVcSOCs+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eom6jy+XEN1NN3CYocxdgzjSQF/uhre/cwG8T814AzSfNPI6TUsKWkY84As27C2kJ
	 UnoQzbZzpncGeAbm4nDIcqmeKY98s1m733MWG4w4QGuTrjc87bl0fSJZ6kH94jQl5f
	 EZJFPTNVTXNd+vKhKGWRo9UTF5CKwTYNOsQ5m/wM=
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

