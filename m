Return-Path: <nvdimm+bounces-5171-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 721D762BE87
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 13:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F77280AAC
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 12:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660FF5CB1;
	Wed, 16 Nov 2022 12:46:41 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCE5CAD
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 12:46:39 +0000 (UTC)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id D8C203200A9F;
	Wed, 16 Nov 2022 07:46:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 16 Nov 2022 07:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1668602796; x=1668689196; bh=/o
	UukuCBSust6nyPKGbLJ3SIf7SSntyLyEuv7oQhiss=; b=dhyoKKhGqOzKfeYFrP
	jkKLIWLVlIhYe2DSYp5tGE0/bar5vjOdTijMEKoBwwexXwDc86sHrl4RE9eSfRjX
	QUzfR8qBMY45xI9xaRqAwObSohlEfTH+IJZ1ys2Sl5IErtXcxuRUznEbLgFmdNzu
	JDT9MMYF3H6VloM/JKw4zGRz7Hk8iBTT+OD0LG3CLJUqdt1O3CvVxmaBjEy5GHFn
	/OhWV3oP266+eI1bnhUE4lhlShavvvGOJ3/Lza0nZeJpvKlRK/cqIe1UqzCIcgY+
	PafutUS2RbCSqpek8nGx68iY4bDr+MwS+TnQIXLrGiB9LwAG/6PVk1GuAD+dmKdw
	d8Sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1668602796; x=1668689196; bh=/oUukuCBSust6nyPKGbLJ3SIf7SS
	ntyLyEuv7oQhiss=; b=AvCc9us3lwT1uY97ryMsa0wvCYXwefewlvGh6SfCC7g6
	Ai28R2lv3DV5b/yAoaI3JCEVGcnqqS5Do6casOdN/skoNZWJXMe5MuFREFyvb4+D
	4JPeTgakZghuC4C3La2MzCSB+tcsAA0l4ya3nHqoveaOt1IxJV+8QiWAyZbPD+Wm
	EYZFGc5t4bNCNtaAJ5VudOSBgmRZ9fz/Jchk0iGnOJgVBUPj1CmQc1JIAQWZtvMl
	c/kVemeO0t4DmMVR30wt3lzVkKWSTb9rC6s2AbUyjYwPOWfqlN9NsXptWxXd1rEt
	NXXoFVdz+f5upMYbwlNhz/6sBW8jzJxFwCEaLeQNFQ==
X-ME-Sender: <xms:rNt0Y1CxwpDuv_0XE1z_aRFlNx-ARAWtzWqlutwsiqgE6jIeyOw9RA>
    <xme:rNt0Yzh76avr0oywyyD4WaS1ziBEW0aQ9G9nz1d73SyOXL-2mthMnUfhplufzPSwh
    2NudNFSGAFCm3TgQ40>
X-ME-Received: <xmr:rNt0YwkfHhYyh3ypsi2gJ2Lam-ZZocg1R8p04HMLfUcU1oK1WWKamgqd-vWI80o8_WpmtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeigdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhephfeigefhtdefhedtfedthefghedutddvueehtedt
    tdehjeeukeejgeeuiedvkedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:rNt0Y_y45CkOdj-cqCg9Fu4LTFXucIHM2WhWugIS8UCI1rt-WRHahw>
    <xmx:rNt0Y6TvKKHb5l5DY9ysgJCHYCV1HMTf3c7Tg_sewxituvlWgIiMtQ>
    <xmx:rNt0Yyb90Qm9qd4NFkmYXPqrZHQcyvjbSFWb58bE7vf1pXdCGhDNHA>
    <xmx:rNt0Y9HbpoFG0A-pSr_cncHgor3ILO_oTQfRQ3tFtYBlpYca5YcCTA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Nov 2022 07:46:35 -0500 (EST)
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 49ADD104CEC; Wed, 16 Nov 2022 15:46:34 +0300 (+03)
Date: Wed, 16 Nov 2022 15:46:34 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, liushixin2@huawei.com,
	Chris Piper <chris.d.piper@intel.com>, stable@vger.kernel.org,
	"Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Message-ID: <20221116124634.nlvnsirdnlafdfeh@box.shutemov.name>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
 <20221116075736.1909690-3-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116075736.1909690-3-vishal.l.verma@intel.com>

On Wed, Nov 16, 2022 at 12:57:36AM -0700, Vishal Verma wrote:
> In a system with a single initiator node, and one or more memory-only
> 'target' nodes, the memory-only node(s) would fail to register their
> initiator node correctly. i.e. in sysfs:
> 
>   # ls /sys/devices/system/node/node0/access0/targets/
>   node0
> 
> Where as the correct behavior should be:
> 
>   # ls /sys/devices/system/node/node0/access0/targets/
>   node0 node1
> 
> This happened because hmat_register_target_initiators() uses list_sort()
> to sort the initiator list, but the sort comparision function
> (initiator_cmp()) is overloaded to also set the node mask's bits.
> 
> In a system with a single initiator, the list is singular, and list_sort
> elides the comparision helper call. Thus the node mask never gets set,
> and the subsequent search for the best initiator comes up empty.
> 
> Add a new helper to sort the initiator list, and handle the singular
> list corner case by setting the node mask for that explicitly.
> 
> Reported-by: Chris Piper <chris.d.piper@intel.com>
> Cc: <stable@vger.kernel.org>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/numa/hmat.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 144a84f429ed..cd20b0e9cdfa 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -573,6 +573,30 @@ static int initiator_cmp(void *priv, const struct list_head *a,
>  	return ia->processor_pxm - ib->processor_pxm;
>  }
>  
> +static int initiators_to_nodemask(unsigned long *p_nodes)
> +{
> +	/*
> +	 * list_sort doesn't call @cmp (initiator_cmp) for 0 or 1 sized lists.
> +	 * For a single-initiator system with other memory-only nodes, this
> +	 * means an empty p_nodes mask, since that is set by initiator_cmp().
> +	 * Special case the singular list, and make sure the node mask gets set
> +	 * appropriately.
> +	 */
> +	if (list_empty(&initiators))
> +		return -ENXIO;
> +
> +	if (list_is_singular(&initiators)) {
> +		struct memory_initiator *initiator = list_first_entry(
> +			&initiators, struct memory_initiator, node);
> +
> +		set_bit(initiator->processor_pxm, p_nodes);
> +		return 0;
> +	}
> +
> +	list_sort(p_nodes, &initiators, initiator_cmp);
> +	return 0;
> +}
> +

Hm. I think it indicates that these set_bit()s do not belong to
initiator_cmp().

Maybe remove both set_bit() from the compare helper and walk the list
separately to initialize the node mask? I think it will be easier to
follow.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

