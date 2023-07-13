Return-Path: <nvdimm+bounces-6363-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5CC752AB9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 21:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C513281F1E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 13 Jul 2023 19:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210E61F193;
	Thu, 13 Jul 2023 19:06:23 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5ED1F179
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689275180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mV8Nsc8QqObfioHox/0m6vCcDaS/dZuwe57a5YlQQl8=;
	b=ANg+PkoIRsTuxH2Ts/pL1IW5Q4ZvVO4aGopVQdFHaE8T84hKVIwHHyXFvJZjfBAHYgwjfk
	jkYQSBVz+HyK+xObg13gU1zZdQE35YKaZXh/Q34cJ7UGCZo+X01sNUT4wY+qrsO7vTR4Xl
	Ub/XnTDLhKDpjz9M8AoJqJIe7x8A7ow=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-iCmcfC-GOe-C3oZCLVi3ig-1; Thu, 13 Jul 2023 15:06:15 -0400
X-MC-Unique: iCmcfC-GOe-C3oZCLVi3ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC588D1683;
	Thu, 13 Jul 2023 19:06:13 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F0BB111E3E9;
	Thu, 13 Jul 2023 19:06:13 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,  "Rafael J. Wysocki" <rafael@kernel.org>,  Len Brown <lenb@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Oscar Salvador <osalvador@suse.de>,  Dan Williams <dan.j.williams@intel.com>,  Dave Jiang <dave.jiang@intel.com>,  linux-acpi@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  nvdimm@lists.linux.dev,  linux-cxl@vger.kernel.org,  Huang Ying <ying.huang@intel.com>,  Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 0/3] mm: use memmap_on_memory semantics for dax/kmem
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
	<29c9b998-f453-59f2-5084-9b4482b489cf@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Thu, 13 Jul 2023 15:12:02 -0400
In-Reply-To: <29c9b998-f453-59f2-5084-9b4482b489cf@redhat.com> (David
	Hildenbrand's message of "Fri, 16 Jun 2023 09:44:50 +0200")
Message-ID: <x49fs5r7hj1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

David Hildenbrand <david@redhat.com> writes:

> On 16.06.23 00:00, Vishal Verma wrote:
>> The dax/kmem driver can potentially hot-add large amounts of memory
>> originating from CXL memory expanders, or NVDIMMs, or other 'device
>> memories'. There is a chance there isn't enough regular system memory
>> available to fit ythe memmap for this new memory. It's therefore
>> desirable, if all other conditions are met, for the kmem managed memory
>> to place its memmap on the newly added memory itself.
>>
>> Arrange for this by first allowing for a module parameter override for
>> the mhp_supports_memmap_on_memory() test using a flag, adjusting the
>> only other caller of this interface in dirvers/acpi/acpi_memoryhotplug.c,
>> exporting the symbol so it can be called by kmem.c, and finally changing
>> the kmem driver to add_memory() in chunks of memory_block_size_bytes().
>
> 1) Why is the override a requirement here? Just let the admin
> configure it then then add conditional support for kmem.
>
> 2) I recall that there are cases where we don't want the memmap to
> land on slow memory (which online_movable would achieve). Just imagine
> the slow PMEM case. So this might need another configuration knob on
> the kmem side.

From my memory, the case where you don't want the memmap to land on
*persistent memory* is when the device is small (such as NVDIMM-N), and
you want to reserve as much space as possible for the application data.
This has nothing to do with the speed of access.

-Jeff


