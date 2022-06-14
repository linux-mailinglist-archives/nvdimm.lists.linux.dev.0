Return-Path: <nvdimm+bounces-3907-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from da.mirrors.kernel.org (da.mirrors.kernel.org [IPv6:2604:1380:4040:4f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C4754B763
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Jun 2022 19:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by da.mirrors.kernel.org (Postfix) with ESMTPS id 920FD2E09F1
	for <lists+linux-nvdimm@lfdr.de>; Tue, 14 Jun 2022 17:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90B91FB6;
	Tue, 14 Jun 2022 17:12:38 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FB51FB0
	for <nvdimm@lists.linux.dev>; Tue, 14 Jun 2022 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UnkcKB4NsDJ0e+mJiYWNx+eCTEwD4IDtNjFvnXDcokg=; b=JXA09RScBAaWksG9w8f1eTRDx4
	jPYffuxU/Oy99uzq/dqd//WYwokS38bI/QGvYknm8zFgS3vrQtkcoOX6qIO7tKKQRLFroHKgAkjSb
	/tvxwZw2q5CrF7NG3K0+O5rp7pIMysDT64NN6/ccTPvjXzCgRYF4ZXZWRGSgm/GTaAwh3ankYtsj2
	i1oLpSEKv0CjPVVjmPZkIIBFcgaJA+8/C78nDnACERWnKrtVFsFAjbuPdTHnA3fHbQqUY3QahA2TN
	IYY426fKPxYxFAz+mA4FdDG8SpuVxjKd2wLkgh7y/iu+e9O/fTibDiIVfWIcDfvjF3seVpliF0mH6
	h7djO54g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
	id 1o1A5W-000L3R-Dg;
	Tue, 14 Jun 2022 17:12:22 +0000
Date: Tue, 14 Jun 2022 18:12:22 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	nvdimm@lists.linux.dev, David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
Message-ID: <YqjBdtzXSKgwUi8f@ZenIV>
References: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
 <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
 <Yqe6EjGTpkvJUU28@ZenIV>
 <YqfcHiBldIqgbu7e@ZenIV>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqfcHiBldIqgbu7e@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jun 14, 2022 at 01:53:50AM +0100, Al Viro wrote:

> FWIW, I've got quite a bit of cleanups in the local tree; reordering and
> cleaning that queue up at the moment, will post tonight or tomorrow.
> 
> I've looked into doing allocations page-by-page (instead of single
> push_pipe(), followed by copying into those).  Doable, but it ends
> up being much messier.

Hmm...  Maybe not - a possible interface would be
	append_pipe(iter, size, &off)

that would either do kmap_local_page() on the last buffer (if it's
anonymous and has space in it) or allocated and mapped a page and
added a new buffer.  Returning the mapped address and offset from it.
Then these loops would looks like this:

	while (left) {
		p = append_pipe(iter, left, &off);
		if (!p)
			break;
		chunk = min(left, PAGE_SIZE - off);
		rem = copy(p + off, whatever, chunk);
		chunk -= rem;
		kunmap_local(p);

		copied += chunk;
		left -= chunk;

		if (unlikely(rem)) {
			pipe_revert(i, rem);
			break;
		}
	}
	return copied;

with no push_pipe() used at all.  For operations that can't fail,
the things are simplified in an obvious way (rem is always 0).

Or we could have append_pipe() return a struct page * and leave
kmap_local_page() to the caller...

struct page *append_pipe(struct iov_iter *i, size_t size, unsigned *off)
{
	struct pipe_inode_info *pipe = i->pipe;
	unsigned offset = i->iov_offset;
	struct page_buffer *buf;
	struct page *page;

	if (offset && offset < PAGE_SIZE) {
		// some space in the last buffer; can we add to it?
		buf = pipe_buf(pipe, pipe->head - 1);
		if (allocated(buf)) {
			size = min(size, PAGE_SIZE - offset);
			buf->len += size;
			i->iov_offset += size;
			i->count -= size;
			*off = offset;
			return buf->page;	// or kmap_local_page(...)
		}
	}
	// OK, we need a new buffer
	size = min(size, PAGE_SIZE);
	if (pipe_full(.....))
		return NULL;
	page = alloc_page(GFP_USER);
	if (!page)
		return NULL;
	// got it...
	buf = pipe_buf(pipe, pipe->head++);
	*buf = (struct pipe_buffer){.ops = &default_pipe_buf_ops,
				    .page = page, .len = size };
	i->head = pipe->head - 1;
	i->iov_offset = size;
	i->count -= size;
	*off = 0;
	return page;	 // or kmap_local_page(...)
}

(matter of fact, the last part could use another helper in my tree - there
the tail would be
	// OK, we need a new buffer
	size = min(size, PAGE_SIZE);
	page = push_anon(pipe, size);
	if (!page)
		return NULL;
	i->head = pipe->head - 1;
	i->iov_offset = size;
	i->count -= size;
	*off = 0;
	return page;
)

Would that be readable enough from your POV?  That way push_pipe()
loses almost all callers and after the "make iov_iter_get_pages()
advancing" part of the series it simply goes away...

It's obviously too intrusive for backports, though - there I'd very much
prefer the variant I posted.

Comments?

PS: re local helpers:

static inline struct pipe_buffer *pipe_buf(const struct pipe_inode_info *pipe,
                                           unsigned int slot)
{
	return &pipe->bufs[slot & (pipe->ring_size - 1)];
}

pretty much all places where we cache pipe->ring_size - 1 had been
absolutely pointless; there are several exceptions, but back in 2019
"pipe: Use head and tail pointers for the ring, not cursor and length"
went overboard with microoptimizations...

