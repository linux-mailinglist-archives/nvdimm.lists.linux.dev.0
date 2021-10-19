Return-Path: <nvdimm+bounces-1635-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id E9EAE432DAD
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Oct 2021 08:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 9BC041C0F8A
	for <lists+linux-nvdimm@lfdr.de>; Tue, 19 Oct 2021 06:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33342C8E;
	Tue, 19 Oct 2021 06:03:19 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from usmail.montage-tech.com (usmail.montage-tech.com [12.176.92.53])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F6E2C88
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 06:03:17 +0000 (UTC)
X-MDAV-Result: clean
X-MDAV-Processed: usmail.montage-tech.com, Mon, 18 Oct 2021 23:00:07 -0700
Received: from shmail.montage-tech.com by usmail.montage-tech.com with ESMTP id md5001005844912.msg; 
	Mon, 18 Oct 2021 23:00:07 -0700
X-Spam-Processed: usmail.montage-tech.com, Mon, 18 Oct 2021 23:00:07 -0700
	(not processed: message from trusted or authenticated source)
X-MDArrival-Date: Mon, 18 Oct 2021 23:00:07 -0700
X-Return-Path: prvs=1926c3430e=johnny.li@montage-tech.com
X-Envelope-From: johnny.li@montage-tech.com
X-MDaemon-Deliver-To: nvdimm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=montage-tech.com;
	s=MDaemon; t=1634623176; x=1635227976;
	i=johnny.li@montage-tech.com; q=dns/txt; h=Date:From:To:Cc:
	Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	User-Agent; bh=M/QuCl6WZdO0B/paCrxMr6uASsEqFdAnmlfzM40rt9E=; b=Q
	5L9rwkscQYJ12KLe3NVMbxqbac71pfhRgpx73HcVOw6xk0KYsJeSwdXW4HcnwIM4
	lFY2aM+S60c9rnfDRG4n5V+SXb5QLHjgeAHzlb/tobNQaqK2J1mNUy2cpBGjWTSJ
	DLvyrfgrcojvlbOqTkaUXVgds6qodQ4aFldN4JYZ04=
X-MDAV-Result: clean
X-MDAV-Processed: shmail.montage-tech.com, Tue, 19 Oct 2021 13:59:36 +0800
Received: from montage-desktop by shmail.montage-tech.com with ESMTPA id pp5001017663793.msg; 
	Tue, 19 Oct 2021 13:59:35 +0800
X-Spam-Processed: shmail.montage-tech.com, Tue, 19 Oct 2021 13:59:35 +0800
	(not processed: message from trusted or authenticated source)
Date: Tue, 19 Oct 2021 13:55:18 -0400
From: Li Qiang <johnny.li@montage-tech.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: can call libcxl function outside ndctl tool?
Message-ID: <20211019175518.GB47179@montage-desktop>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-MDCFSigsAdded: montage-tech.com

Take cxl_cmd_new_identify as example.
There is CXL_EXPORT prefix, it seems can be called outside ndctl tool.
While the intput and outpust struct cxl_memdev and cxl_cmd are private.

```

CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
{
	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
}

```


Thanks
Johnny




