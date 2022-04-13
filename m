Return-Path: <nvdimm+bounces-3516-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 633144FF85A
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 16:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 288613E0EFD
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 14:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAEE2908;
	Wed, 13 Apr 2022 14:02:49 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA828FE
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649858566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAfD3NhN7fayTDj+zqA64IJMnx8ZxzqbVRBoMThFMGA=;
	b=DpXmLyETWnY+UTtNVFfLoDQsbCtlVDvmXpz7H/kcYaiRwRjJ9Ea3VLmbhfnHp/Y8VS13W6
	IndVnyRCksUN7h7EQIMG3T+xDD4Jb6do5FXlxu1Z1nJ6LAVjNgwun5xpjY+KvgWbBbWvnv
	qcDScLvmEAZouIRU85eox+y9+OaHULI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-xzrjdR4XMWORsqlOI_ibHw-1; Wed, 13 Apr 2022 10:02:44 -0400
X-MC-Unique: xzrjdR4XMWORsqlOI_ibHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D49A129DD987;
	Wed, 13 Apr 2022 14:02:35 +0000 (UTC)
Received: from [10.18.17.215] (dhcp-17-215.bos.redhat.com [10.18.17.215])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 569B4C28109;
	Wed, 13 Apr 2022 14:02:35 +0000 (UTC)
Message-ID: <06ed6ba2-00c4-ab38-4fcf-611133865615@redhat.com>
Date: Wed, 13 Apr 2022 10:02:35 -0400
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 00/12] device-core: Enable device_lock() lockdep
 validation
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Will Deacon <will@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8

On 4/13/22 02:01, Dan Williams wrote:
> Changes since v1 [1]:
> - Improve the clarity of the cover letter and changelogs of the
>    major patches (Patch2 and Patch12) (Pierre, Kevin, and Dave)
> - Fix device_lock_interruptible() false negative deadlock detection
>    (Kevin)
> - Fix off-by-one error in the device_set_lock_class() enable case (Kevin)
> - Spelling fixes in Patch2 changelog (Pierre)
> - Compilation fixes when both CONFIG_CXL_BUS=n and
>    CONFIG_LIBNVDIMM=n. (0day robot)
>
> [1]: https://lore.kernel.org/all/164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com/
>
> ---
>
> The device_lock() is why the lockdep_set_novalidate_class() API exists.
> The lock is taken in too many disparate contexts, and lockdep by design
> assumes that all device_lock() acquisitions are identical. The lack of
> lockdep coverage leads to deadlock scenarios landing upstream. To
> mitigate that problem the lockdep_mutex was added [2].
>
> The lockdep_mutex lets a subsystem mirror device_lock() acquisitions
> without lockdep_set_novalidate_class() to gain some limited lockdep
> coverage. The mirroring approach is limited to taking the device_lock()
> after-the-fact in a subsystem's 'struct bus_type' operations and fails
> to cover device_lock() acquisition in the driver-core. It also can only
> track the needs of one subsystem at a time so, for example the kernel
> needs to be recompiled between CONFIG_PROVE_NVDIMM_LOCKING and
> CONFIG_PROVE_CXL_LOCKING depending on which subsystem is being
> regression tested. Obviously that also means that intra-subsystem
> locking dependencies can not be validated.

Instead of using a fake lockdep_mutex, maybe you can just use a unique 
lockdep key for each subsystem and call lockdep_set_class() in the 
device_initialize() if such key is present or 
lockdep_set_novalidate_class() otherwise. The unique key can be passed 
either as a parameter to device_initialize() or as part of the device 
structure. It is certainly less cumbersome that having a fake 
lockdep_mutex array in the device structure.

Cheers,
Longman


