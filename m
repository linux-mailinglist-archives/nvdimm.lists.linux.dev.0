Return-Path: <nvdimm+bounces-14916-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id UG+rFoHFU2pzewMAu9opvQ
	(envelope-from <nvdimm+bounces-14916-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 18:49:05 +0200
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B520474561E
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 18:49:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gourry.net header.s=google header.b=AlZ2b4ad;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "nvdimm+bounces-14916-lists+linux-nvdimm=lfdr.de@lists.linux.dev" designates 172.234.253.10 as permitted sender) smtp.mailfrom="nvdimm+bounces-14916-lists+linux-nvdimm=lfdr.de@lists.linux.dev";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0829B3010B85
	for <lists+linux-nvdimm@lfdr.de>; Sun, 12 Jul 2026 16:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2401364EAF;
	Sun, 12 Jul 2026 16:48:57 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08874145B11
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 16:48:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783874937; cv=none; b=E4QcPhzXXOhjDNvPUDg3zVgONK4el8oUQwLOg8Qpwud00uI7jrw2zgQ+gBqkF3+QxTsjAF3JNvNnV3NDyruzvs40V6DdU0KEhkTMo3SRsZu5apWivcxVcO4wFDJND/Sat6bKgp6PWRym431LEUzlyzDG7GR4Pdh4n37vxTeaRCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783874937; c=relaxed/simple;
	bh=Qt4v/dZ/atl2InBXlF6Qg0mek0k2Z3U8e5b5n5VxTGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YC68S0JpSPCoU+scdqGqDbdsS2A6v3K6bkZwnYkZz51+ZoW0xFFhq3kYrwLufMw+T7iUW6dvR/t6NcWKA/rjS6NTCJIZ5Uv0aSb37a5+d5fqztmAJ53hyOM+duxsAKFRWYl5AIKVxtSICeTE4x8xhro8JlNqJPQOOZeQgqk95OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=AlZ2b4ad; arc=none smtp.client-ip=209.85.160.181
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0006ea8eso17023181cf.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783874935; x=1784479735; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=AlZ2b4adlO/33HSkXMDDCW149dMGp+mJTCqNFPJRs+iYc8dTvU6nR68GE605F2mYri
         +++4Oiw+5heupEolKZsrf7ncCLih34vOnH4lCnKtGRxai6RDQ15X593PrJPbumse8iUr
         Ywrluk89EoUnwvpJRYFWtw+YnzgMea69CkXn9faE0GCAtfv2MYzh1FMe5jtJDUMKlr5l
         IqSmB9DBPmjweiyZOhqS0S/b2FqnyE/OVTdTqGthpBoX3NluFTRsQWG8xkoBhr3WYFJb
         KQx0r/cQmtaF/TT2k9QtrzM6laAF8sZMFWULbJpL0MzPhuhZV58UrBsnAgkzaqIpkggo
         oh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783874935; x=1784479735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=OkWPTDbNgJNeta3Eh0rNE7z8ruhJBlYNeeigGD3VQ3n49zzfkbHrjdnqL8+QQcrFRF
         r3CSWzlNtLg6i8KRd8Y0iNgJ+O37KjSSeqJey1m8tgi04V8HHvy/0vpVKDFJqFNNmsF7
         Mckn7Iy8JwvvuJibuPFQTRKmEDqoP+gXN66IQJqkeaEHG+8ebFMZOWGnVKU5+2rs/rb9
         6nXiiQANixFQng3Hk2SEh0vQiC/gmIh6X4HT7yVyOTcrFL2hs7pdecCmeq4M/KLdxlBB
         JGeP3/FEdEPoiXQObRfPXpKkU+xCRl+IKBflhvObQUEt0GP+6q92/cg256CgDaOUP7nv
         yqIA==
X-Forwarded-Encrypted: i=1; AHgh+RqhUYc6xeYHQgrmPRhWYGHMSgQRBdZ4yZ3OsvcGQ/KXMRbkzl8rj9P8ueICtCZntTFS8iXNSe4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/tGam6oeJ06r6NxUPEzpMr1WHe4CdJkecxSOdRsDNEGi6YWEZ
	iORI3g++o/zThg3vfkMKs8+9+BoPMmJ7plmMV1x1NwYedq0VDEApz4WnYmSdjZIwX4Y=
X-Gm-Gg: AfdE7cncVjgkBmqQeGaaOY6WWiOhrDlhKP9RIPlBEr6oAsZfpZrhg3oz+0VaDdVhBpT
	UJyUc5krCdlKHUu5uj0dCccUbHtx+4erZ5ymywak8ZhRPypyBhYVC1BSMbB2CZX3xJiG8Bkz/Qs
	JRbOqHuD/1MJjWL1i4zzRFoNZs0yQAYNKrfZ5PD5sX+wNCjzForTFtN7eNrxadfr7XoOOP8b9ol
	O26MsXUA8sebR15xRCcFamMzYL+CKbr0k34r1pnfKP1N863j1MHTw13vi2xkfIXYsTuGRT7zrgO
	ZELssdWDWkEgZN1l4FGK26ktRqXGg8PYjJ4jpxv2qNgfCmJae2os6jWSRGRVHS+p7486ZCCiLJm
	QfuiC8gftHaYIK0xhS1A9ZEShkRGLa0PIBJFUiGYkRf+b5rYSlc2tG1hVVLVUl3yV1miFw3poiT
	9d/g3LHiFatJnKRhFC5HN1RsGmDarpCCBjFKEGbsFzmS1Q/6bBKXNt8UVPYkGcQjiwuQbD
X-Received: by 2002:a05:622a:7281:b0:51b:f98f:ea5e with SMTP id d75a77b69052e-51cc9d5d02amr30044441cf.22.1783874935089;
        Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caae20a40sm68575071cf.15.2026.07.12.09.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 09:48:53 -0700 (PDT)
Date: Sun, 12 Jul 2026 12:48:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org
Subject: Re: [PATCH v7 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <alPFcfjlzSHYk3jA@gourry-fedora-PF4VCD3F>
References: <20260712154505.3564379-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gourry.net:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-14916-lists,linux-nvdimm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-mm@kvack.org,m:linux-kernel@vger.kernel.org,m:linux-cxl@vger.kernel.org,m:driver-core@lists.linux.dev,m:nvdimm@lists.linux.dev,m:linux-kselftest@vger.kernel.org,m:kernel-team@meta.com,m:david@kernel.org,m:osalvador@suse.de,m:gregkh@linuxfoundation.org,m:rafael@kernel.org,m:dakr@kernel.org,m:djbw@kernel.org,m:vishal.l.verma@intel.com,m:dave.jiang@intel.com,m:alison.schofield@intel.com,m:akpm@linux-foundation.org,m:ljs@kernel.org,m:liam@infradead.org,m:vbabka@kernel.org,m:rppt@kernel.org,m:surenb@google.com,m:mhocko@suse.com,m:shuah@kernel.org,s:lists@lfdr.de];
	DMARC_NA(0.00)[gourry.net];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gourry.net:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gourry@gourry.net,nvdimm@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B520474561E

On Sun, Jul 12, 2026 at 11:44:54AM -0400, Gregory Price wrote:
> The dax kmem driver onlines memory during probe using the system
> default policy, with no atomic control for the state of an entire
> region at runtime - only by toggling individual memory blocks.
> 

Took a look at Sashiko reviews.

All are either false-positive, pre-existing issues on isolated patches
that are actually resolved by later patches, or something we previously
agreed on (WARN/pass in phase 2 of offline_and_remove_memory_ranges).

So series is clean as-is.

~Gregory

