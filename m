Return-Path: <nvdimm+bounces-5900-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CFE6C7BEB
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Mar 2023 10:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D08E1C20922
	for <lists+linux-nvdimm@lfdr.de>; Fri, 24 Mar 2023 09:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD07443C;
	Fri, 24 Mar 2023 09:49:21 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AFF3C24
	for <nvdimm@lists.linux.dev>; Fri, 24 Mar 2023 09:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679651356; i=@fujitsu.com;
	bh=Pxpk4CSw0qrpM2DP+X1AdjLT3KYQnQt8U9Qz9IB7N+U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=wRrqAhZq/4Yj0ectfoivQwTsfOHqmkGelD0V0/AEQsPj2mQG3F9NQU0bywwt0o9ke
	 7VnnPZidpLCt7SD1nH1igc6gQOgUTXMJJ6lJAjkLESlGNaO3mt+OrWHl9hltO4Sdar
	 obtO56zs2Mh1nRCPhCdwmNeWnUD7Ig/0zbIJQ4NUHp+xKkQWh6rxazFHNmKXQ8HKEm
	 e+hH2CL35WMVPDHKvJIw7X2wmmqqu3nSizqv8B+dridieTEAQJWhPR3rxWfQoIwSg8
	 D2S90Jw+cjl2qCzW1u3Vr2ShZTdcZriLymdYCqUt0rmOv3upXF5Kmkrl52d+PcjppL
	 SkPKIlIYW84qA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRWlGSWpSXmKPExsViZ8ORpCtdJJt
  isGOhnMWc9WvYLKZPvcBoseXYPUaLy0/4LE5PWMRksfv1TTaLPXtPsljcW/Of1WLXnx3sFit/
  /GG1+P1jDpsDt8epRRIem1doeSze85LJY9OqTjaPTZ8msXucmPGbxePF5pmMHh+f3mLx+LxJL
  oAzijUzLym/IoE1Y9akBvaCHo2Kps8XGBsYdyh2MXJxCAlsZJTY//wBG4SzhEliSUMDE4SzjV
  Fiw+Ib7F2MnBy8AnYSWzbNZAaxWQRUJV4tmMwGEReUODnzCQuILSqQLHHsfCtQnINDWMBP4sI
  ac5Awm4COxIUFf1lBbBEBNYlJk3aAjWEWaGGS2NJdAbFrKpPEuWVNTCAJTgF7iUXd96CKLCQW
  vznIDmHLSzRvnQ0WlxBQkrj49Q4rhF0h0Tj9EBOErSZx9dwm5gmMQrOQnDcLyahZSEYtYGRex
  WhenFpUllqka2iil1SUmZ5RkpuYmaOXWKWbqJdaqpuXX1SSoWuol1herJdaXKxXXJmbnJOil5
  dasokRGJ0pxYnHdzC+6vurd4hRkoNJSZRXIlQ6RYgvKT+lMiOxOCO+qDQntfgQowwHh5IEr1a
  BbIqQYFFqempFWmYOMFHApCU4eJREeNdnAaV5iwsSc4sz0yFSpxh1OdY2HNjLLMSSl5+XKiXO
  G1EIVCQAUpRRmgc3Apa0LjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5tXMBZrCk5lXArfpF
  dARTEBHONfIgBxRkoiQkmpgKuc4EBDT9bzHvyPzY5QHy6nk5zEJD1zUBU+mXzjQsENW90dkT2
  5wyewnbBvW/GoMFxU5q5wf5R91Os7k9OOHH953X79v/9h85VSL6TOv3Pli4cz0sXrSpVNOzZo
  /Ej7GTdfvXch1+WHWO3XDIC/T7/f37dlbrzM7fNLKKz/609OkmxatlfJ1KAj0PLtu78eLj64a
  H7fePqutn3/bNimried1PI5U7rFOKIuQOCX18YJlekPk9eLGuYynX4Zl/zf/H/jze+ZlZi19v
  14bZbVTz87O9+rPzPzBLF6dUN9tfLSwyO/SXv7klaprDY6+ETHs0qzNNJp9hdHSxYljS92eN1
  O9ZlgfF45vO/lgY0WCEktxRqKhFnNRcSIA4qC5ctUDAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-2.tower-732.messagelabs.com!1679651354!283082!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 27032 invoked from network); 24 Mar 2023 09:49:15 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-2.tower-732.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 24 Mar 2023 09:49:15 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id C28BC1AF;
	Fri, 24 Mar 2023 09:49:14 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id B61461AE;
	Fri, 24 Mar 2023 09:49:14 +0000 (GMT)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Fri, 24 Mar 2023 09:49:10 +0000
Message-ID: <7ba8c1f6-b9fe-714a-cd40-2b9e17ea61e7@fujitsu.com>
Date: Fri, 24 Mar 2023 17:49:04 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
CC: <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <djwong@kernel.org>,
	<dan.j.williams@intel.com>, <hch@infradead.org>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <willy@infradead.org>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-4-git-send-email-ruansy.fnst@fujitsu.com>
 <20230227000759.GZ360264@dread.disaster.area>
 <56e0a5e8-74db-95eb-d6fb-5d4a3b5cb156@fujitsu.com>
 <b1d9fc03-1a71-a75f-f87b-5819991e4eb2@fujitsu.com>
In-Reply-To: <b1d9fc03-1a71-a75f-f87b-5819991e4eb2@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP



在 2023/3/21 18:59, Shiyang Ruan 写道:
> 
> 
> 在 2023/2/27 18:06, Shiyang Ruan 写道:
>>
>>
>> 在 2023/2/27 8:07, Dave Chinner 写道:
>>> On Fri, Feb 17, 2023 at 02:48:32PM +0000, Shiyang Ruan wrote:
>>>> This patch is inspired by Dan's "mm, dax, pmem: Introduce
>>>> dev_pagemap_failure()"[1].  With the help of dax_holder and
>>>> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
>>>> (or mapped device) on it to unmap all files in use and notify processes
>>>> who are using those files.
>>>>
>>>> Call trace:
>>>> trigger unbind
>>>>   -> unbind_store()
>>>>    -> ... (skip)
>>>>     -> devres_release_all()   # was pmem driver ->remove() in v1
>>>>      -> kill_dax()
>>>>       -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, 
>>>> MF_MEM_PRE_REMOVE)
>>>>        -> xfs_dax_notify_failure()
>>>>
>>>> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
>>>> event.  So do not shutdown filesystem directly if something not
>>>> supported, or if failure range includes metadata area.  Make sure all
>>>> files and processes are handled correctly.
>>>>
>>>> [1]: 
>>>> https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
>>>>
>>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>>
>>> .....
>>>
>>>> ---
>>>> @@ -225,6 +242,15 @@ xfs_dax_notify_failure(
>>>>       if (offset + len - 1 > ddev_end)
>>>>           len = ddev_end - offset + 1;
>>>> +    if (mf_flags & MF_MEM_PRE_REMOVE) {
>>>> +        xfs_info(mp, "device is about to be removed!");
>>>> +        error = freeze_super(mp->m_super);
>>>> +        if (error)
>>>> +            return error;
>>>> +        /* invalidate_inode_pages2() invalidates dax mapping */
>>>> +        super_drop_pagecache(mp->m_super, invalidate_inode_pages2);
>>>> +    }
>>>
>>> Why do you still need to drop the pagecache here? My suggestion was
>>> to replace it with freezing the filesystem at this point is to stop
>>> it being dirtied further before the device remove actually occurs.
>>> The userspace processes will be killed, their DAX mappings reclaimed
>>> and the filesystem shut down before device removal occurs, so
>>> super_drop_pagecache() is largely superfluous as it doesn't actually
>>> provide any protection against racing with new mappings or dirtying
>>> of existing/newly created mappings.
>>>
>>> Freezing doesn't stop the creation of new mappings, either, it just
>>> cleans all the dirty mappings and halts anything that is trying to
>>
>> This is the point I wasn't aware of.
>>
>>> dirty existing clean mappings. It's not until we kill the userspace
>>> processes that new mappings will be stopped, and it's not until we
>>> shut the filesystem down that the filesystem itself will stop
>>> accessing the storage.
>>>
>>> Hence I don't see why you retained super_drop_pagecache() here at
>>> all. Can you explain why it is still needed?
>>
>>
>> So I was just afraid that it's not enough for rmap & processes killer 
>> to invalidate the dax mappings.  If something error happened during 
>> the rmap walker, the fs will shutdown and there is no chance to 
>> invalidate the rest mappings whose user didn't be killed yet.
>>
>> Now that freezing the fs is enough, I will remove the drop cache code.
> 
> I removed the drop cache code, then kernel always went into crash when 
> running the test[1].  After the investigation, I found that the crash is 
> cause by accessing (invalidate dax pages when umounting fs) the page of 
> a pmem while the pmem has been removed.
> 
> According to the design, the dax page should have been invalidated by 
> mf_dax_kill_procs() but it didn't.  I found two reasons:
>   1. collect_procs_fsdax() only kills the current process
>   2. unmap_mapping_range() doesn't invalidate the dax pages 
> (disassociate dax entry in fs/dax.c), which causes the crash in my test
> 
> So, I think we should:
>   1. pass the mf_flag to collect_procs_fsdax() to let it collect all 
> processes associated with the file on the XFS.
>   2. drop cache is still needed, but just drop the associated files' 
> cache after mf_dax_kill_procs(), instead of dropping cache of the whole 
> filesystem.
> 
> Then the logic shuld be looked like this:
> unbind
>   `-> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>     `-> xfs_dax_notify_failure()
>       `-> freeze_super()
>       `-> do xfs rmap
>         `-> mf_dax_kill_procs()
>           `-> collect_procs_fsdax()   // all associated
>           `-> unmap_and_kill()
>         `-> invalidate_inode_pages2() // drop file's cache
>       `-> thaw_super()
> 
> 
> [1] The step of unbind test:
>   1. create fsdax namespace on a pmem
>   2. mkfs.xfs on it
>   3. run fsx test in background
>   4. wait 1s
>   5. echo "pfn0.1" > unbind
>   6. wait 1s
>   7. umount xfs       --> crash happened
> 

Hi,

Any comments?


> 
> -- 
> Thanks,
> Ruan.
> 
>>
>>
>> -- 
>> Thanks,
>> Ruan.
>>
>>>
>>> -Dave.

