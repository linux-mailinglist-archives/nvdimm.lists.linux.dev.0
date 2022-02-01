Return-Path: <nvdimm+bounces-2764-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 857064A62D2
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 18:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id C3D3F3E0F79
	for <lists+linux-nvdimm@lfdr.de>; Tue,  1 Feb 2022 17:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111CF2C9D;
	Tue,  1 Feb 2022 17:45:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BA42F25
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643737547; x=1675273547;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wo0ruSODN2J2aAjmhR6V0progvo1o7OpOk+t943iN4c=;
  b=SmhuD1+oqjqn64CHSXNy5hSoaasvXY0R2B92h1fwpwF38ZiOUgWEzakl
   xSoMxpCDgrKPDAljYhfLk3e3y18JtsZvhP73THBHkaaUUdTol0EYj5ANj
   2RqlykqX1fDDiAyAQCW40k0D17hcu/ukfmGSokVYlog2Yc/Po5AgYVkoF
   CCV+yMNNyxuFicFnquoiYlOmHyYnnyFZpSFFe23S/2Rbd/nJNR7t1dUug
   Gz/fw+JyxZRWXrwW63MyxqT+kMEkCX7uEd78mGQu9Yq+F+Gx2n9tPZs3B
   CLgj44Obof1k7veV5VhIWoXP6QQ18nLEKNwJXianC5o/jPlhsY/mJf7xP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="247699032"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="247699032"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 09:45:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="534591256"
Received: from rashmigh-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.8])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 09:45:46 -0800
Date: Tue, 1 Feb 2022 09:45:45 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 34/40] cxl/core: Move target_list out of base decoder
 attributes
Message-ID: <20220201174545.z45ofgv7cuxcbjze@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298430100.3018233.4715072508880290970.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298430100.3018233.4715072508880290970.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:31:41, Dan Williams wrote:
> In preparation for introducing endpoint decoder objects, move the
> target_list attribute out of the common set since it has no meaning for
> endpoint decoders.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Could add DPA skip at some point to replace it.

Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]

