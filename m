Return-Path: <nvdimm+bounces-5202-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CCE62CF2E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 17 Nov 2022 00:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69DC1C2095E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Nov 2022 23:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347C1EAC2;
	Wed, 16 Nov 2022 23:55:03 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD2815C9A
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 23:55:00 +0000 (UTC)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id 8FBA832003C0;
	Wed, 16 Nov 2022 18:54:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 16 Nov 2022 18:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1668642899; x=1668729299; bh=E6
	JF0cEeUYzVPtpcCWq54L+1lUQkLjUmOjkjEOpTZQs=; b=HxYk+rY3975eYJAPSW
	Ph7ZU1IwAnV4TanjbmZUbDB6VzD/zAZfucXLQXGfvHyoibQO0lD1E2qcwXsf3Alp
	7PPDHs2Y7WKoBapqB+/iV0/iTm0RXFCMrsgHaag5LHGYqbiLx/IuUsTwkZsCbBRG
	0Z3zd3w0NkBhAfzrNz8A/8Ll+OU1CmIwCLOtNvkPGmvh7+EjfSFMHTGC7Xjqz3Wn
	wi7vbkyOHminV0tsPsCiMU3LBwZeDZ9ErNMA4tICmPEqmoCe6R+Ei1yI4avkZ9wy
	leIpyBk4x1WB7nUXHJu1FP4KLZZ+rVhChhJNTuarphOpvXAIlq4Vknwov//y13RI
	s8sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1668642899; x=1668729299; bh=E6JF0cEeUYzVPtpcCWq54L+1lUQk
	LjUmOjkjEOpTZQs=; b=G07M2l3GSh3PLRpUpbkrFfJDVMCtKW0iGwiKO8yVW688
	ZPOucYUGnER+7H6ToVIvXVQDpXtrNMor5uRwNLLAKXFG9fk5/97wq7YoI0/rNtLd
	IWWocrNz3QIS/18Ltl2wAuGImJe8BZizYkyzEoz29+wFZBwXrrjnnY4Vw+5naKL/
	1QQ9Ol7iYPlEtwt+C0WBLRenclkgXHuCJvxo3anJr/aJmTRWP7Q/9ujfOd8KSnjl
	VABLD32s5ltm4PfAvK7gBzffZyDqQTO9BFVPARHIElY2Gu5jV0YDLka5u6YlmMFL
	0kUe9ac6M5uXZ4U43WwFBojxgvm5W+DQNIGNHJaJLw==
X-ME-Sender: <xms:Unh1Y854ORzk8SFRgynH9lD4k_-BLpT6Vg3ODpSR1Vcs_p_sVrMZyg>
    <xme:Unh1Y96f3_BXmDZJ0FjEkx0fsO4UhHjD3_O2O04XZdLpFg-nlIP5BwgDJD9SA1yLv
    zBCtXTsXwOrwcxKrSY>
X-ME-Received: <xmr:Unh1Y7fd4FQnxXfNnAs_lVR-Ad9HbRsJXxBHKEG-UNlH3z-s5DLQ-AdYoRnBPYubNhnp3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeejgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhephfeigefhtdefhedtfedthefghedutddvueehtedt
    tdehjeeukeejgeeuiedvkedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:Unh1YxI9iIYdKgHxx2SGafkvR7A5ElwzVHFEn0Dgj5n8wQrEVljFbw>
    <xmx:Unh1YwLxu9M0RFU14x20Qo__UDf-WabQX-f-fkbHcvELqCyBSXadCA>
    <xmx:Unh1YywGTGww3BJL_IVBSnir7p7Ut6GxjQPE6OWW3E-wURkQ0M9CNg>
    <xmx:U3h1Y1XGTsKaY2E1nHo6LGGHZAd7Gxgkw29BGhfWxjRD5Qq8EuHuRQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Nov 2022 18:54:58 -0500 (EST)
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 9E6CC109702; Thu, 17 Nov 2022 02:54:55 +0300 (+03)
Date: Thu, 17 Nov 2022 02:54:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	linux-kernel@vger.kernel.org, Chris Piper <chris.d.piper@intel.com>,
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Message-ID: <20221116235455.74nqyfdcqe72mhbi@box.shutemov.name>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
 <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>

On Wed, Nov 16, 2022 at 04:37:37PM -0700, Vishal Verma wrote:
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
> Add a new helper to consume the sorted initiator list, and generate the
> nodemask, decoupling it from the overloaded initiator_cmp() comparision
> callback. This prevents the singular list corner case naturally, and
> makes the code easier to follow as well.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Chris Piper <chris.d.piper@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

