Return-Path: <nvdimm+bounces-11315-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25EEDB235BB
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Aug 2025 20:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811AE1896BD6
	for <lists+linux-nvdimm@lfdr.de>; Tue, 12 Aug 2025 18:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2822FE570;
	Tue, 12 Aug 2025 18:50:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B749284685
	for <nvdimm@lists.linux.dev>; Tue, 12 Aug 2025 18:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024636; cv=none; b=dbLrChAAMMDU+7g/1T6TasFbe4QsMf6aStfbgNAsvfj027sBMJgGxbqRSQT+17T8Cdl4iUwOKoQb3AXqwwzqCBpXBtFeun6bAb7DPjH6UYfdntDUubE9EsDRHlb6gkQZnlkPY5o4NLalH7QJH/J6bNMSti6e7IBkjetVxjgk4ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024636; c=relaxed/simple;
	bh=HlHptNenjmRuN7S5bI/iQBjtU0MTLhoVqeYVibkxhH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEBBYsuQu/4koMVX0vsHJnjgJNqWYRlB4HRGZMrhv3BImmkCRO6mYEUhikt58TidtlmRbvyM7YPRPIAHsERTW+ZotKeQ5pYhmFvTYBwzkmBIbcawfuTRKDC90kMdAVJ7Xh7DDN5kpoG7WMK4JmknixfWIkeTyvYVOTB23kvElT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c1gK71N21z9sSN;
	Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W34agYFEkjYq; Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c1gK707Z2z9sSL;
	Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D45368B764;
	Tue, 12 Aug 2025 20:39:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id KCsZS5tQGZ3E; Tue, 12 Aug 2025 20:39:38 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 03CD88B763;
	Tue, 12 Aug 2025 20:39:36 +0200 (CEST)
Message-ID: <1cc6f739-3891-4cc7-84ac-676fef62c445@csgroup.eu>
Date: Tue, 12 Aug 2025 20:39:36 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to
 "struct ptdump_pglevel"
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-7-david@redhat.com>
 <dac9e243-33ce-4203-a598-2877cf908cad@lucifer.local>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <dac9e243-33ce-4203-a598-2877cf908cad@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Lorenzo,

Le 12/08/2025 à 20:23, Lorenzo Stoakes a écrit :
> On Mon, Aug 11, 2025 at 01:26:26PM +0200, David Hildenbrand wrote:
>> We want to make use of "pgtable_level" for an enum in core-mm. Other
>> architectures seem to call "struct pgtable_level" either:
>> * "struct pg_level" when not exposed in a header (riscv, arm)
>> * "struct ptdump_pg_level" when expose in a header (arm64)
>>
>> So let's follow what arm64 does.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> This LGTM, but I'm super confused what these are for, they don't seem to be
> used anywhere? Maybe I'm missing some macro madness, but it seems like dead
> code anyway?

pg_level[] are used several times in arch/powerpc/mm/ptdump/ptdump.c, 
for instance here:

static void note_page_update_state(struct pg_state *st, unsigned long 
addr, int level, u64 val)
{
	u64 flag = level >= 0 ? val & pg_level[level].mask : 0;
	u64 pa = val & PTE_RPN_MASK;

	st->level = level;
	st->current_flags = flag;
	st->start_address = addr;
	st->start_pa = pa;

	while (addr >= st->marker[1].start_address) {
		st->marker++;
		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
	}
}

> 
> Anyway:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   arch/powerpc/mm/ptdump/8xx.c      | 2 +-
>>   arch/powerpc/mm/ptdump/book3s64.c | 2 +-
>>   arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
>>   arch/powerpc/mm/ptdump/shared.c   | 2 +-
>>   4 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
>> index b5c79b11ea3c2..4ca9cf7a90c9e 100644
>> --- a/arch/powerpc/mm/ptdump/8xx.c
>> +++ b/arch/powerpc/mm/ptdump/8xx.c
>> @@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
>> index 5ad92d9dc5d10..6b2da9241d4c4 100644
>> --- a/arch/powerpc/mm/ptdump/book3s64.c
>> +++ b/arch/powerpc/mm/ptdump/book3s64.c
>> @@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
>> index 154efae96ae09..4232aa4b57eae 100644
>> --- a/arch/powerpc/mm/ptdump/ptdump.h
>> +++ b/arch/powerpc/mm/ptdump/ptdump.h
>> @@ -11,12 +11,12 @@ struct flag_info {
>>   	int		shift;
>>   };
>>
>> -struct pgtable_level {
>> +struct ptdump_pg_level {
>>   	const struct flag_info *flag;
>>   	size_t num;
>>   	u64 mask;
>>   };
>>
>> -extern struct pgtable_level pg_level[5];
>> +extern struct ptdump_pg_level pg_level[5];
>>
>>   void pt_dump_size(struct seq_file *m, unsigned long delta);
>> diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
>> index 39c30c62b7ea7..58998960eb9a4 100644
>> --- a/arch/powerpc/mm/ptdump/shared.c
>> +++ b/arch/powerpc/mm/ptdump/shared.c
>> @@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> --
>> 2.50.1
>>


