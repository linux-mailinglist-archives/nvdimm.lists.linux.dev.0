Return-Path: <nvdimm+bounces-7021-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C448A809C7B
	for <lists+linux-nvdimm@lfdr.de>; Fri,  8 Dec 2023 07:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 020651C20C90
	for <lists+linux-nvdimm@lfdr.de>; Fri,  8 Dec 2023 06:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BC0D533;
	Fri,  8 Dec 2023 06:35:31 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CFA4A29
	for <nvdimm@lists.linux.dev>; Fri,  8 Dec 2023 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from dinghao.liu$zju.edu.cn ( [10.190.70.178] ) by
 ajax-webmail-mail-app2 (Coremail) ; Fri, 8 Dec 2023 14:35:15 +0800
 (GMT+08:00)
Date: Fri, 8 Dec 2023 14:35:15 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: dinghao.liu@zju.edu.cn
To: "Ira Weiny" <ira.weiny@intel.com>
Cc: "Dave Jiang" <dave.jiang@intel.com>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dan Williams" <dan.j.williams@intel.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm-btt: fix a potential memleak in
 btt_freelist_init
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.2-cmXT5 build
 20230825(e13b6a3b) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4df6dc2c-e274-4d1c-b502-72c5c3dfa9ce-zj.edu.cn
In-Reply-To: <65722f2a94d68_1c7b6229452@iweiny-mobl.notmuch>
References: <20231207034332.24107-1-dinghao.liu@zju.edu.cn>
 <23a91617-4562-4399-a8c6-df2f3f28c7a9@intel.com>
 <65722f2a94d68_1c7b6229452@iweiny-mobl.notmuch>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7205fcd5.258f3.18c48233162.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:by_KCgDnDiojuXJlaQReAA--.20505W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgMDBmVxlxQ-zwABsi
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

PiBEYXZlIEppYW5nIHdyb3RlOgo+ID4gCj4gCj4gW3NuaXBdCj4gCj4gRmlyc3Qgb2ZmIHRoYW5r
cyBmb3IgdGhlIHBhdGNoLiAgVGhpcyBjb2RlIHNlZW1zIHRvIGhhdmUgYSBmZXcgdGhpbmdzIHRv
Cj4gY2xlYW4gdXAuCj4gCj4gPiAKPiA+IE9uIDEyLzYvMjMgMjA6NDMsIERpbmdoYW8gTGl1IHdy
b3RlOgo+ID4gPiBXaGVuIGFuIGVycm9yIGhhcHBlbnMgaW4gYnR0X2ZyZWVsaXN0X2luaXQoKSwg
aXRzIGNhbGxlcgo+ID4gPiBkaXNjb3Zlcl9hcmVuYXMoKSB3aWxsIGRpcmVjdGx5IGZyZWUgYXJl
bmEsIHdoaWNoIG1ha2VzCj4gPiA+IGFyZW5hLT5mcmVlbGlzdCBhbGxvY2F0ZWQgaW4gYnR0X2Zy
ZWVsaXN0X2luaXQoKSBhIGxlYWtlZAo+ID4gPiBtZW1vcnkuIEZpeCB0aGlzIGJ5IGZyZWVpbmcg
YXJlbmEtPmZyZWVsaXN0IGluIGFsbCBlcnJvcgo+ID4gPiBoYW5kbGluZyBwYXRocyBvZiBidHRf
ZnJlZWxpc3RfaW5pdCgpLgo+ID4gPiAKPiA+ID4gRml4ZXM6IDUyMTJlMTFmZGU0ZCAoIm5kX2J0
dDogYXRvbWljIHNlY3RvciB1cGRhdGVzIikKPiA+ID4gU2lnbmVkLW9mZi1ieTogRGluZ2hhbyBM
aXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+Cj4gPiAKPiA+IEhvdyBhYm91dCB1c2UgdGhlIG5l
dyBzY29wZSBiYXNlZCByZXNvdXJjZSBtYW5hZ2VtZW50IGFuZCB3ZSBjYW4gYXZvaWQgdGhlIGdv
dG8gbWVzcyBhbHRvZ2V0aGVyPwo+ID4gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzkzNDY3OS8K
PiA+IAo+IAo+IFRoZSBmcmVlbGlzdCBpcyByZXR1cm5lZCBhcyBwYXJ0IG9mIGFyZW5hLiAgSSd2
ZSBub3QgdHJhY2VkIGJvdGggcGF0aHMgb2YKPiBidHRfZnJlZWxpc3RfaW5pdCgpIGNvbXBsZXRl
bHkgYnV0IGRldm1fa2NhbGxvYygpIGxvb2tzIGxpa2UgYSBiZXR0ZXIKPiBzb2x1dGlvbiBoZXJl
IGJlY2F1c2UgdGhpcyBtZW1vcnkgbmVlZHMgdG8gbGl2ZSBwYXN0IHRoZSBmdW5jdGlvbiBzY29w
ZS4KPiAKPiBUaGF0IHNhaWQsIHRoaXMgcGF0Y2ggZG9lcyBub3QgY29tcGxldGVseSBmaXggZnJl
ZWxpc3QgZnJvbSBsZWFraW5nIGluIHRoZQo+IGZvbGxvd2luZyBlcnJvciBwYXRoLgo+IAo+IAlk
aXNjb3Zlcl9hcmVuYXMoKQo+IAkJYnR0X2ZyZWVsaXN0X2luaXQoKSAtPiBvayAobWVtb3J5IGFs
bG9jYXRlZCkKPiAJCWJ0dF9ydHRfaW5pdCgpIC0+IGZhaWwKPiAJCQlnb3RvIG91dDsKPiAJCQko
bGVhayBiZWNhdXNlIGFyZW5hIGlzIG5vdCB5ZXQgb24gYnR0LT5hcmVuYV9saXN0KQo+IAkJT1IK
PiAJCWJ0dF9tYXBsb2Nrc19pbml0KCkgLT4gZmFpbAo+IAkJCWdvdG8gb3V0Owo+IAkJCShsZWFr
IGJlY2F1c2UgYXJlbmEgaXMgbm90IHlldCBvbiBidHQtPmFyZW5hX2xpc3QpCj4gCgpUaGFua3Mg
Zm9yIHBvaW50aW5nIG91dCB0aGlzIGlzc3VlISBJIHJlY2hlY2tlZCBkaXNjb3Zlcl9hcmVuYXMo
KSBhbmQgZm91bmQKdGhhdCBidHRfcnR0X2luaXQoKSBtYXkgYWxzbyB0cmlnZ2VyIGEgbWVtbGVh
ayBmb3IgdGhlIHNhbWUgcmVhc29uIGFzCmJ0dF9mcmVlbGlzdF9pbml0KCkuIEFsc28sIEkgY2hl
Y2tlZCBhbm90aGVyIGNhbGwgdHJhY2U6CgogICAgYnR0X2luaXQoKSAtPiBidHRfbWV0YV9pbml0
KCkgLT4gYnR0X21hcGxvY2tzX2luaXQoKQoKSSB0aGluayB0aGVyZSBpcyBhIG1lbWxlYWsgaWYg
YnR0X21hcGxvY2tzX2luaXQoKSBzdWNjZWVkcyBidXQgYW4gZXJyb3IKaGFwcGVucyBpbiBidHRf
aW5pdCgpIGFmdGVyIGJ0dF9tZXRhX2luaXQoKSAoZS5nLiwgd2hlbiBidHRfYmxrX2luaXQoKQpy
ZXR1cm5zIGFuIGVycm9yKS4gVGhlcmVmb3JlLCB3ZSBtYXkgbmVlZCB0byBmaXggdGhyZWUgZnVu
Y3Rpb25zLgoKPiBUaGlzIGVycm9yIGNvdWxkIGJlIGZpeGVkIGJ5IGFkZGluZyB0byBhcmVuYV9s
aXN0IGVhcmxpZXIgYnV0IGRldm1fKigpCj4gYWxzbyB0YWtlcyBjYXJlIG9mIHRoaXMgd2l0aG91
dCBoYXZpbmcgdG8gd29ycnkgYWJvdXQgdGhhdCBsb2dpYy4KPiAKPiBPbiBub3JtYWwgb3BlcmF0
aW9uIGFsbCBvZiB0aGlzIG1lbW9yeSBjYW4gYmUgZnJlZSdlZCB3aXRoIHRoZQo+IGNvcnJlc3Bv
bmRpbmcgZGV2bV9rZnJlZSgpIGFuZC9vciBkZXZtX2FkZF9hY3Rpb25fKigpIGNhbGxzIGlmIGFy
ZW5hcyBjb21lCj4gYW5kIGdvLiAgSSdtIG5vdCBzdXJlIG9mZiB0aGUgdG9wIG9mIG15IGhlYWQu
Cj4gCj4gSW4gYWRkaXRpb24sIGxvb2tpbmcgYXQgdGhpcyBjb2RlLiAgZGlzY292ZXJfYXJlbmFz
KCkgY291bGQgbWFrZSB1c2Ugb2YKPiB0aGUgc2NvcGVkIGJhc2VkIG1hbmFnZW1lbnQgZm9yIHN0
cnVjdCBidHRfc2IgKnN1cGVyIQo+IAo+IERpbmdoYW8gd291bGQgeW91IGJlIHdpbGxpbmcgdG8g
c3VibWl0IGEgc2VyaWVzIG9mIDIgb3IgMyBwYXRjaGVzIHRvIGZpeAo+IHRoZSBhYm92ZSBpc3N1
ZXM/Cj4gCgpTdXJlLiBDdXJyZW50bHkgSSBwbGFuIHRvIHNlbmQgMiBwYXRjaGVzIGFzIGZvbGxv
d3M6CjEuIFVzaW5nIGRldm1fa2NhbGxvYygpIHRvIHJlcGxhY2Uga2NhbGxvYygpIGluIGJ0dF9m
cmVlbGlzdF9pbml0KCksIAogICBidHRfcnR0X2luaXQoKSwgYW5kIGJ0dF9tYXBsb2Nrc19pbml0
KCksIGFuZCByZW1vdmluZyB0aGUgY29ycmVzcG9uZGluZwogICBrZnJlZSBpbiBmcmVlX2FyZW5h
cygpLiBJIGNoZWNrZWQgc29tZSB1c2VzIG9mIGRldm1fa2NhbGxvYygpIGFuZCBpdAogICBzZWVt
cyB0aGF0IHdlIG5lZWQgbm90IHRvIGNhbGwgZGV2bV9rZnJlZSgpLiBUaGUgbWVtb3J5IGlzIGF1
dG9tYXRpY2FsbHkKICAgZnJlZWQgb24gZHJpdmVyIGRldGFjaCwgcmlnaHQ/CjIuIFVzaW5nIHRo
ZSBzY29wZWQgYmFzZWQgbWFuYWdlbWVudCBmb3Igc3RydWN0IGJ0dF9zYiAqc3VwZXIgKG5vdCBh
IGJ1ZywKICAgYnV0IGl0IGNvdWxkIGltcHJvdmUgdGhlIGNvZGUpLgoKSSdtIG5vdCBxdWl0ZSBz
dXJlIHdoZXRoZXIgbXkgdW5kZXJzdGFuZGluZyBvciBidWcgZml4aW5nIHBsYW4gaXMgY29ycmVj
dC4KSWYgdGhlcmUgYXJlIGFueSBpc3N1ZXMsIHBsZWFzZSBjb3JyZWN0IG1lLCB0aGFua3MhCgpS
ZWdhcmRzLApEaW5naGFvCgoKCg==

