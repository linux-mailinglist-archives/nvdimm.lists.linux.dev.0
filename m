Return-Path: <nvdimm+bounces-5022-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4DF616352
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Nov 2022 14:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F8D21C20949
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Nov 2022 13:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F84E211F;
	Wed,  2 Nov 2022 13:05:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885312108
	for <nvdimm@lists.linux.dev>; Wed,  2 Nov 2022 13:04:58 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2D2ddc010456;
	Wed, 2 Nov 2022 13:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=fBMsh0qWbBU7AjpN4D6Xh6IAPjIyRElHVfVtLuyIqtw=;
 b=AWLQqLrM1IqlDvxrj73BO24QRgwdmJ1KSu3MLlzZOutY/VnR9soOC/vST6oijvQOQ7aD
 vxeyw4mlTcy9FmXeoOyLi41H7MZEXv4iRLLCvBZE/fYMnTlEOzSm/9+spWwkT1v5pcD4
 qeKBZ9gU0K37wYS7I6cvcoPMJN2XcejEPOsh93k6Dy6ppI1Ceh6IHHDGxPcMGZBVl6u4
 WxODZRFFRhHI/ds2NJUXvmkE82J8X6+O58xGe5gVWY3GNJhVzre25QSmmDar7Ve33znz
 W0VrE7t5+pUTrlIzudj0NV36gu1UidW/g/LmVPhSnXuIFrd+S+Q8PGhf0G7BpzfCiAI3 mQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkqxwjnbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Nov 2022 13:04:26 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
	by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2CoErs019765;
	Wed, 2 Nov 2022 13:04:25 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by ppma01wdc.us.ibm.com with ESMTP id 3kgut9tucc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Nov 2022 13:04:25 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2D4OSZ53412310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Nov 2022 13:04:24 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E491858059;
	Wed,  2 Nov 2022 13:04:23 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEAE358068;
	Wed,  2 Nov 2022 13:04:19 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.108.109])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Nov 2022 13:04:19 +0000 (GMT)
X-Mailer: emacs 29.0.50 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>, david@fromorbit.com,
        nvdimm@lists.linux.dev, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 04/25] fsdax: Introduce dax_zap_mappings()
In-Reply-To: <166579183976.2236710.17370760087488536715.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
 <166579183976.2236710.17370760087488536715.stgit@dwillia2-xfh.jf.intel.com>
Date: Wed, 02 Nov 2022 18:34:17 +0530
Message-ID: <87tu3h1p9q.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WqL3YTkfmvD5OiTzJZde57cM9Nmht9a8
X-Proofpoint-GUID: WqL3YTkfmvD5OiTzJZde57cM9Nmht9a8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_09,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 mlxlogscore=799
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020082

Dan Williams <dan.j.williams@intel.com> writes:

> Typical pages take a reference at pte insertion and drop it at
> zap_pte_range() time. That reference management is missing for DAX
> leading to a situation where DAX pages are mapped in user page tables,
> but are not referenced.
>
> Once fsdax decides it wants to unmap the page it can drop its reference,
> but unlike typical pages it needs to maintain the association of the
> page to the inode that arbitrated the access in the first instance. It
> maintains that association until explicit truncate(), or the implicit
> truncate() that occurs at inode death, truncate_inode_pages_final().
>
> The zapped state tracks whether the fsdax has dropped its interest in a
> page, but still allows the associated i_pages entry to live until
> truncate. This facilitates inode lookup while awaiting any page pin
> users to drop their pins. For example, if memory_failure() is triggered
> on the page after it has been unmapped, but before it has been truncated
> from the inode, memory_failure() can still associate the event with the
> inode.
>
> Once truncate begins fsdax unmaps the page to prevent any new references
> from being taken without calling back into fsdax core to reestablish
> the mapping.

The gup path should now check dax_is_zap()?  Where do we
prevent new referenced from being taken?

-aneesh

