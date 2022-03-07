Return-Path: <nvdimm+bounces-3254-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8144D092F
	for <lists+linux-nvdimm@lfdr.de>; Mon,  7 Mar 2022 22:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A76F71C0A08
	for <lists+linux-nvdimm@lfdr.de>; Mon,  7 Mar 2022 21:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725414352;
	Mon,  7 Mar 2022 21:07:53 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F60838FE
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646687271; x=1678223271;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=p4+XYuX+nIWpowqjRazp4rkuKNVVPKwEoBkW3G1FT00=;
  b=mT+wMxZiiih5ivEQaFXxlxrNwlWKddbwvmJis8geUoVt5SgeSIoAAUph
   7BNDfIsaz30AWRMpNe63nNl3rukWsCLAHX3Q+ptGZzIh7HHVdbHuZqHuc
   Sw1F0JUOWwlaJgZzoKnNsIL64u52er2+dHB4mV6ANNKz6Kf4LryRFzYDI
   e2pUBLWqW5nndGQOjd3552mNMx6KfuKHvcbN7EWWEM4u3b1XGM/q2PADD
   POely2cefa1j92QG19jYIg/beQYjqNowcy71oo/QqHWKRH/LceRIYVntd
   zNioJKTBJum1EDgpoUwFEErTMDtDnUJKK4SSUzJhW+Kf9dNH7/3VxUM6f
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="317738667"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="317738667"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 13:07:51 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="537276194"
Received: from sonalsha-mobl.amr.corp.intel.com (HELO localhost) ([10.212.67.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 13:07:50 -0800
Date: Mon, 7 Mar 2022 13:07:50 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: lsf-pc@lists.linux-foundation.org
Cc: ira.weiny@intel.com, 'Ben Widawsky' <ben.widawsky@intel.com>,
	'Vishal Verma' <vishal.l.verma@intel.com>,
	'Dan Williams' <dan.j.williams@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	linux-mm@kvack.org, nvdimm@lists.linux.dev
Subject: [LSF/MM/BPF BOF idea] CXL BOF discussion
Message-ID: <YiZ0Jmhyf515EJzD@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I was curious if anyone attending LSF/mm would be interested in a CXL BOF?

I'm still hoping to get an invite, but if I do I would be happy to organize
some time to discuss the work being done.  It would be great to meet people
face to face if possible too.

Ira Weiny

