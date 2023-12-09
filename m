Return-Path: <nvdimm+bounces-7029-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDFD80B537
	for <lists+linux-nvdimm@lfdr.de>; Sat,  9 Dec 2023 17:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3095A281011
	for <lists+linux-nvdimm@lfdr.de>; Sat,  9 Dec 2023 16:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0679D171D0;
	Sat,  9 Dec 2023 16:28:02 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D1214A92
	for <nvdimm@lists.linux.dev>; Sat,  9 Dec 2023 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from dinghao.liu$zju.edu.cn ( [10.181.205.210] ) by
 ajax-webmail-mail-app2 (Coremail) ; Sun, 10 Dec 2023 00:27:43 +0800
 (GMT+08:00)
Date: Sun, 10 Dec 2023 00:27:43 +0800 (GMT+08:00)
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
In-Reply-To: <6573a0451c4b7_1e7d27294ea@iweiny-mobl.notmuch>
References: <20231207034332.24107-1-dinghao.liu@zju.edu.cn>
 <23a91617-4562-4399-a8c6-df2f3f28c7a9@intel.com>
 <65722f2a94d68_1c7b6229452@iweiny-mobl.notmuch>
 <7205fcd5.258f3.18c48233162.Coremail.dinghao.liu@zju.edu.cn>
 <6573a0451c4b7_1e7d27294ea@iweiny-mobl.notmuch>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7360ec74.281bc.18c4f67fac7.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:by_KCgDnDip_lXRlYMRpAA--.21927W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgcEBmV0OhUI9wAAsG
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

PiBkaW5naGFvLmxpdUAgd3JvdGU6Cj4gPiA+IERhdmUgSmlhbmcgd3JvdGU6Cj4gCj4gW3NuaXBd
Cj4gCj4gPiA+IFRoYXQgc2FpZCwgdGhpcyBwYXRjaCBkb2VzIG5vdCBjb21wbGV0ZWx5IGZpeCBm
cmVlbGlzdCBmcm9tIGxlYWtpbmcgaW4gdGhlCj4gPiA+IGZvbGxvd2luZyBlcnJvciBwYXRoLgo+
ID4gPiAKPiA+ID4gCWRpc2NvdmVyX2FyZW5hcygpCj4gPiA+IAkJYnR0X2ZyZWVsaXN0X2luaXQo
KSAtPiBvayAobWVtb3J5IGFsbG9jYXRlZCkKPiA+ID4gCQlidHRfcnR0X2luaXQoKSAtPiBmYWls
Cj4gPiA+IAkJCWdvdG8gb3V0Owo+ID4gPiAJCQkobGVhayBiZWNhdXNlIGFyZW5hIGlzIG5vdCB5
ZXQgb24gYnR0LT5hcmVuYV9saXN0KQo+ID4gPiAJCU9SCj4gPiA+IAkJYnR0X21hcGxvY2tzX2lu
aXQoKSAtPiBmYWlsCj4gPiA+IAkJCWdvdG8gb3V0Owo+ID4gPiAJCQkobGVhayBiZWNhdXNlIGFy
ZW5hIGlzIG5vdCB5ZXQgb24gYnR0LT5hcmVuYV9saXN0KQo+ID4gPiAKPiA+IAo+ID4gVGhhbmtz
IGZvciBwb2ludGluZyBvdXQgdGhpcyBpc3N1ZSEgSSByZWNoZWNrZWQgZGlzY292ZXJfYXJlbmFz
KCkgYW5kIGZvdW5kCj4gPiB0aGF0IGJ0dF9ydHRfaW5pdCgpIG1heSBhbHNvIHRyaWdnZXIgYSBt
ZW1sZWFrIGZvciB0aGUgc2FtZSByZWFzb24gYXMKPiA+IGJ0dF9mcmVlbGlzdF9pbml0KCkuIEFs
c28sIEkgY2hlY2tlZCBhbm90aGVyIGNhbGwgdHJhY2U6Cj4gPiAKPiA+ICAgICBidHRfaW5pdCgp
IC0+IGJ0dF9tZXRhX2luaXQoKSAtPiBidHRfbWFwbG9ja3NfaW5pdCgpCj4gPiAKPiA+IEkgdGhp
bmsgdGhlcmUgaXMgYSBtZW1sZWFrIGlmIGJ0dF9tYXBsb2Nrc19pbml0KCkgc3VjY2VlZHMgYnV0
IGFuIGVycm9yCj4gPiBoYXBwZW5zIGluIGJ0dF9pbml0KCkgYWZ0ZXIgYnR0X21ldGFfaW5pdCgp
IChlLmcuLCB3aGVuIGJ0dF9ibGtfaW5pdCgpCj4gPiByZXR1cm5zIGFuIGVycm9yKS4gVGhlcmVm
b3JlLCB3ZSBtYXkgbmVlZCB0byBmaXggdGhyZWUgZnVuY3Rpb25zLgo+IAo+IFllYSBJIHRoaW5r
IHdlIG5lZWQgdG8gdHJhY2UgdGhpcyBjb2RlIGJldHRlci4gIFRoaXMgaXMgd2h5IGRldm1fIGlz
IG5pY2UgZm9yCj4gbWVtb3J5IGFsbG9jYXRlZCBmb3IgdGhlIGxpZmUgb2YgdGhlIGRldmljZS4K
PiAKPiA+IAo+ID4gPiBUaGlzIGVycm9yIGNvdWxkIGJlIGZpeGVkIGJ5IGFkZGluZyB0byBhcmVu
YV9saXN0IGVhcmxpZXIgYnV0IGRldm1fKigpCj4gPiA+IGFsc28gdGFrZXMgY2FyZSBvZiB0aGlz
IHdpdGhvdXQgaGF2aW5nIHRvIHdvcnJ5IGFib3V0IHRoYXQgbG9naWMuCj4gPiA+IAo+ID4gPiBP
biBub3JtYWwgb3BlcmF0aW9uIGFsbCBvZiB0aGlzIG1lbW9yeSBjYW4gYmUgZnJlZSdlZCB3aXRo
IHRoZQo+ID4gPiBjb3JyZXNwb25kaW5nIGRldm1fa2ZyZWUoKSBhbmQvb3IgZGV2bV9hZGRfYWN0
aW9uXyooKSBjYWxscyBpZiBhcmVuYXMgY29tZQo+ID4gPiBhbmQgZ28uICBJJ20gbm90IHN1cmUg
b2ZmIHRoZSB0b3Agb2YgbXkgaGVhZC4KPiA+ID4gCj4gPiA+IEluIGFkZGl0aW9uLCBsb29raW5n
IGF0IHRoaXMgY29kZS4gIGRpc2NvdmVyX2FyZW5hcygpIGNvdWxkIG1ha2UgdXNlIG9mCj4gPiA+
IHRoZSBzY29wZWQgYmFzZWQgbWFuYWdlbWVudCBmb3Igc3RydWN0IGJ0dF9zYiAqc3VwZXIhCj4g
PiA+IAo+ID4gPiBEaW5naGFvIHdvdWxkIHlvdSBiZSB3aWxsaW5nIHRvIHN1Ym1pdCBhIHNlcmll
cyBvZiAyIG9yIDMgcGF0Y2hlcyB0byBmaXgKPiA+ID4gdGhlIGFib3ZlIGlzc3Vlcz8KPiA+ID4g
Cj4gPiAKPiA+IFN1cmUuIEN1cnJlbnRseSBJIHBsYW4gdG8gc2VuZCAyIHBhdGNoZXMgYXMgZm9s
bG93czoKPiA+IDEuIFVzaW5nIGRldm1fa2NhbGxvYygpIHRvIHJlcGxhY2Uga2NhbGxvYygpIGlu
IGJ0dF9mcmVlbGlzdF9pbml0KCksIAo+ID4gICAgYnR0X3J0dF9pbml0KCksIGFuZCBidHRfbWFw
bG9ja3NfaW5pdCgpLCBhbmQgcmVtb3ZpbmcgdGhlIGNvcnJlc3BvbmRpbmcKPiA+ICAgIGtmcmVl
IGluIGZyZWVfYXJlbmFzKCkuIEkgY2hlY2tlZCBzb21lIHVzZXMgb2YgZGV2bV9rY2FsbG9jKCkg
YW5kIGl0Cj4gPiAgICBzZWVtcyB0aGF0IHdlIG5lZWQgbm90IHRvIGNhbGwgZGV2bV9rZnJlZSgp
LiBUaGUgbWVtb3J5IGlzIGF1dG9tYXRpY2FsbHkKPiA+ICAgIGZyZWVkIG9uIGRyaXZlciBkZXRh
Y2gsIHJpZ2h0Pwo+IAo+IE9uIGRldmljZSBwdXQgeWVzLiAgU28gaWYgdGhlc2UgYWxsb2NhdGlv
bnMgYXJlIHNjb3BlZCB0byB0aGUgbGlmZSBvZiB0aGUKPiBkZXZpY2UgdGhlcmUgd291bGQgYmUg
bm8gcmVhc29uIHRvIGNhbGwgZGV2bV9rZnJlZSgpIG9uIHRoZW0gYXQgYWxsLiAgSSB3YXMgbm90
Cj4gc3VyZSBpZiB0aGV5IGdvdCByZWFsbG9jYXRlZCBhdCBzb21lIHBvaW50IG9yIG5vdC4KPiAK
PiA+IDIuIFVzaW5nIHRoZSBzY29wZWQgYmFzZWQgbWFuYWdlbWVudCBmb3Igc3RydWN0IGJ0dF9z
YiAqc3VwZXIgKG5vdCBhIGJ1ZywKPiA+ICAgIGJ1dCBpdCBjb3VsZCBpbXByb3ZlIHRoZSBjb2Rl
KS4KPiAKPiBHb29kIQo+IAo+ID4gCj4gPiBJJ20gbm90IHF1aXRlIHN1cmUgd2hldGhlciBteSB1
bmRlcnN0YW5kaW5nIG9yIGJ1ZyBmaXhpbmcgcGxhbiBpcyBjb3JyZWN0Lgo+ID4gSWYgdGhlcmUg
YXJlIGFueSBpc3N1ZXMsIHBsZWFzZSBjb3JyZWN0IG1lLCB0aGFua3MhCj4gCj4gVGhlIGFib3Zl
IHNvdW5kcyByaWdodC4KPiBJcmEKClRoYW5rcyBmb3IgdGhlIHJldmlldyEgSSB3aWxsIHNlbmQg
dGhlIHBhdGNoZXMgc29vbi4KClJlZ2FyZHMsCkRpbmdoYW8K

