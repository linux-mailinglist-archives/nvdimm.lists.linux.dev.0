Return-Path: <nvdimm+bounces-4557-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3E759B6C3
	for <lists+linux-nvdimm@lfdr.de>; Mon, 22 Aug 2022 01:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD009280BDA
	for <lists+linux-nvdimm@lfdr.de>; Sun, 21 Aug 2022 23:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373554A02;
	Sun, 21 Aug 2022 23:33:05 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E40246AA
	for <nvdimm@lists.linux.dev>; Sun, 21 Aug 2022 23:33:03 +0000 (UTC)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 024CE62D65C;
	Mon, 22 Aug 2022 09:32:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1oPuR1-00FxHU-PQ; Mon, 22 Aug 2022 09:32:51 +1000
Date: Mon, 22 Aug 2022 09:32:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"jane.chu@oracle.com" <jane.chu@oracle.com>
Subject: Re: [PATCH] xfs: on memory failure, only shut down fs after scanning
 all mappings
Message-ID: <20220821233251.GI3600936@dread.disaster.area>
References: <Yv5wIa2crHioYeRr@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv5wIa2crHioYeRr@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6302c0a8
	a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
	a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
	a=7-415B0cAAAA:8 a=1mAKx1ogGfV0O7zOtsIA:9 a=CjuIK1q_8ugA:10
	a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Thu, Aug 18, 2022 at 10:00:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_dax_failure_fn is used to scan the filesystem during a memory
> failure event to look for memory mappings to revoke.  Unfortunately, if
> it encounters an rmap record for filesystem metadata, it will shut down
> the filesystem and the scan immediately.  This means that we don't
> complete the mapping revocation scan and instead leave live mappings to
> failed memory.  Fix the function to defer the shutdown until after we've
> finished culling mappings.
> 
> While we're at it, add the usual "xfs_" prefix to struct failure_info,
> and actually initialize mf_flags.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

