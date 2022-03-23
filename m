Return-Path: <nvdimm+bounces-3378-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id E53A74E4FFC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Mar 2022 11:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id F310A1C0EC4
	for <lists+linux-nvdimm@lfdr.de>; Wed, 23 Mar 2022 10:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6317D139E;
	Wed, 23 Mar 2022 10:05:15 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042B1391
	for <nvdimm@lists.linux.dev>; Wed, 23 Mar 2022 10:05:12 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4KNkVg0wsYz4xc3;
	Wed, 23 Mar 2022 21:04:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1648029904;
	bh=TnQ5wsxyVAGgIDqyTCVQtPFJ+SPrs/6MaUbQuhN/DUw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rBixC8p0PkivEvxa7o1L3zMq0K5Cu/hu9x6+WtdtKaRQsAE40Bzwztum4x6OtyAdm
	 /bd4Fp1TS3gr/VEV/32apsTWCgIr20zBG9wLEdpJG5+MsJIWWjyMRelu8/Kjr0V3xR
	 sQuJmokWuZ/N8cxlRzUGxsD1o4qyVot29ud73GMqllKPfjyf+UrSE2LIjRBAYXZY6+
	 sTdM5fTO4LCRiW1Eka7kpZ5C6ULMe/f/oxd9qXTk/k+iwAb81TcyMxEOwVIl9SPUX8
	 7bdtP2Cf/GxkppARAjSCZTVrrhp3viS8hWcoN2YKMb3DXgaAThqE4JHwOGbQ8zhMhQ
	 dIn8J+MUDcN4A==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Dan Williams <dan.j.williams@intel.com>, kajoljain <kjain@linux.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Linux NVDIMM
 <nvdimm@lists.linux.dev>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux-Next Mailing List
 <linux-next@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma
 <vishal.l.verma@intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
 Santosh Sivaraj <santosh@fossix.org>, maddy@linux.ibm.com,
 rnsastry@linux.ibm.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 atrajeev@linux.vnet.ibm.com, Vaibhav Jain <vaibhav@linux.ibm.com>, Thomas
 Gleixner <tglx@linutronix.de>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] powerpc/papr_scm: Fix build failure when
 CONFIG_PERF_EVENTS is not set
In-Reply-To: <CAPcyv4j9NQ-Msr6JCp95QWAdDyTfYr65fXCoHHtjipLA=oJeHA@mail.gmail.com>
References: <20220318114133.113627-1-kjain@linux.ibm.com>
 <20220318114133.113627-2-kjain@linux.ibm.com>
 <CAPcyv4iqpTn89WLOW1XjFXGZEYG_MmPg+VQbcDJ9ygJ4Jaybtw@mail.gmail.com>
 <c198a1b5-cc7e-4e51-533b-a5794f506b17@linux.ibm.com>
 <CAPcyv4j9NQ-Msr6JCp95QWAdDyTfYr65fXCoHHtjipLA=oJeHA@mail.gmail.com>
Date: Wed, 23 Mar 2022 21:04:57 +1100
Message-ID: <877d8lgf1y.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dan Williams <dan.j.williams@intel.com> writes:
> On Tue, Mar 22, 2022 at 7:30 AM kajoljain <kjain@linux.ibm.com> wrote:
>> On 3/22/22 03:09, Dan Williams wrote:
>> > On Fri, Mar 18, 2022 at 4:42 AM Kajol Jain <kjain@linux.ibm.com> wrote:
>> >>
>> >> The following build failure occures when CONFIG_PERF_EVENTS is not set
>> >> as generic pmu functions are not visible in that scenario.
>> >>
>> >> arch/powerpc/platforms/pseries/papr_scm.c:372:35: error: =E2=80=98str=
uct perf_event=E2=80=99 has no member named =E2=80=98attr=E2=80=99
>> >>          p->nvdimm_events_map[event->attr.config],
>> >>                                    ^~
>> >> In file included from ./include/linux/list.h:5,
>> >>                  from ./include/linux/kobject.h:19,
>> >>                  from ./include/linux/of.h:17,
>> >>                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
>> >> arch/powerpc/platforms/pseries/papr_scm.c: In function =E2=80=98papr_=
scm_pmu_event_init=E2=80=99:
>> >> arch/powerpc/platforms/pseries/papr_scm.c:389:49: error: =E2=80=98str=
uct perf_event=E2=80=99 has no member named =E2=80=98pmu=E2=80=99
>> >>   struct nvdimm_pmu *nd_pmu =3D to_nvdimm_pmu(event->pmu);
>> >>                                                  ^~
>> >> ./include/linux/container_of.h:18:26: note: in definition of macro =
=E2=80=98container_of=E2=80=99
>> >>   void *__mptr =3D (void *)(ptr);     \
>> >>                           ^~~
>> >> arch/powerpc/platforms/pseries/papr_scm.c:389:30: note: in expansion =
of macro =E2=80=98to_nvdimm_pmu=E2=80=99
>> >>   struct nvdimm_pmu *nd_pmu =3D to_nvdimm_pmu(event->pmu);
>> >>                               ^~~~~~~~~~~~~
>> >> In file included from ./include/linux/bits.h:22,
>> >>                  from ./include/linux/bitops.h:6,
>> >>                  from ./include/linux/of.h:15,
>> >>                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
>> >>
>> >> Fix the build issue by adding check for CONFIG_PERF_EVENTS config opt=
ion
>> >> and disabling the papr_scm perf interface support incase this config
>> >> is not set
>> >>
>> >> Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support") =
(Commit id
>> >> based on linux-next tree)
>> >> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
>> >> ---
>> >>  arch/powerpc/platforms/pseries/papr_scm.c | 15 +++++++++++++++
>> >
>> > This is a bit messier than I would have liked mainly because it dumps
>> > a bunch of ifdefery into a C file contrary to coding style, "Wherever
>> > possible, don't use preprocessor conditionals (#if, #ifdef) in .c
>> > files". I would expect this all to move to an organization like:
>>
>> Hi Dan,
>>       Thanks for reviewing the patches. Inorder to avoid the multiple
>> ifdefs checks, we can also add stub function for papr_scm_pmu_register.
>> With that change we will just have one ifdef check for
>> CONFIG_PERF_EVENTS config in both papr_scm.c and nd.h file. Hence we can
>> avoid adding new files specific for papr_scm perf interface.
>>
>> Below is the code snippet for that change, let me know if looks fine to
>> you. I tested it
>> with set/unset PAPR_SCM config value and set/unset PERF_EVENTS config
>> value combinations.
>>
>> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c
>> b/arch/powerpc/platforms/pseries/papr_scm.c
>> index 4dd513d7c029..38fabb44d3c3 100644
>> --- a/arch/powerpc/platforms/pseries/papr_scm.c
>> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
>> @@ -69,8 +69,6 @@
>>  #define PAPR_SCM_PERF_STATS_EYECATCHER __stringify(SCMSTATS)
>>  #define PAPR_SCM_PERF_STATS_VERSION 0x1
>>
>> -#define to_nvdimm_pmu(_pmu)    container_of(_pmu, struct nvdimm_pmu, pm=
u)
>> -
>>  /* Struct holding a single performance metric */
>>  struct papr_scm_perf_stat {
>>         u8 stat_id[8];
>> @@ -346,6 +344,9 @@ static ssize_t drc_pmem_query_stats(struct
>> papr_scm_priv *p,
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_PERF_EVENTS
>> +#define to_nvdimm_pmu(_pmu)    container_of(_pmu, struct nvdimm_pmu, pm=
u)
>> +
>>  static int papr_scm_pmu_get_value(struct perf_event *event, struct
>> device *dev, u64 *count)
>>  {
>>         struct papr_scm_perf_stat *stat;
>> @@ -558,6 +559,10 @@ static void papr_scm_pmu_register(struct
>> papr_scm_priv *p)
>>         dev_info(&p->pdev->dev, "nvdimm pmu didn't register rc=3D%d\n", =
rc);
>>  }
>>
>> +#else
>> +static inline void papr_scm_pmu_register(struct papr_scm_priv *p) { }
>
> Since this isn't in a header file, it does not need to be marked
> "inline" the compiler will figure it out.
>
>> +#endif
>
> It might be time to create:
>
> arch/powerpc/platforms/pseries/papr_scm.h
>
> ...there is quite a bit of header material accrued in papr_scm.c and
> once the ifdefs start landing in it then it becomes a nominal coding
> style issue. That said, this is certainly more palatable than the
> previous version. So if you don't want to create papr_scm.h yet for
> this, at least make a note in the changelog that the first portion of
> arch/powerpc/platforms/pseries/papr_scm.c is effectively papr_scm.h
> content and may move there in the future, or something like that.

IMHO the only thing that belongs in a header is content that's needed by
other C files. As long as those types/declarations are only used in
papr_scm.c then they should stay in the C file, and there's no need for
a header.

I know the coding style rule is "avoid ifdefs in .c files", but I'd
argue that rule should be ignored if you're creating a header file
purely so that you can use an ifdef :)

Coding style also says:

  Prefer to compile out entire functions, rather than portions of functions=
 or
  portions of expressions.  Rather than putting an ifdef in an expression, =
factor
  out part or all of the expression into a separate helper function and app=
ly the
  conditional to that function.

Which is what we're doing here with eg. papr_scm_pmu_register().

Certainly for this merge window I think introducing a header is likely
to cause more problems than it solves, so let's not do that for now. We
can revisit it for the next merge window.

cheers

