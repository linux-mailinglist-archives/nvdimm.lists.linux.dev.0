Return-Path: <nvdimm+bounces-7063-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2917810893
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Dec 2023 04:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FC5C282383
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Dec 2023 03:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D486120;
	Wed, 13 Dec 2023 03:12:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2313B1C2F
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 03:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from dinghao.liu$zju.edu.cn ( [10.190.71.15] ) by
 ajax-webmail-mail-app4 (Coremail) ; Wed, 13 Dec 2023 11:12:15 +0800
 (GMT+08:00)
Date: Wed, 13 Dec 2023 11:12:15 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: dinghao.liu@zju.edu.cn
To: "Dave Jiang" <dave.jiang@intel.com>
Cc: "Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dan Williams" <dan.j.williams@intel.com>, 
	"Ira Weiny" <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm-btt: simplify code with the scope based resource
 management
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.2-cmXT5 build
 20230825(e13b6a3b) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4df6dc2c-e274-4d1c-b502-72c5c3dfa9ce-zj.edu.cn
In-Reply-To: <8716bf72-e4ca-4f83-8a30-327baf459dbb@intel.com>
References: <20231210102747.13545-1-dinghao.liu@zju.edu.cn>
 <8716bf72-e4ca-4f83-8a30-327baf459dbb@intel.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <369f7d97.32dac.18c6129229a.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cS_KCgBXXzcPIXllrASFAA--.12142W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgIIBmV4LpY5mAAAsK
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

PiAKPiBPbiAxMi8xMC8yMyAwMzoyNywgRGluZ2hhbyBMaXUgd3JvdGU6Cj4gPiBVc2UgdGhlIHNj
b3BlIGJhc2VkIHJlc291cmNlIG1hbmFnZW1lbnQgKGRlZmluZWQgaW4KPiA+IGxpbnV4L2NsZWFu
dXAuaCkgdG8gYXV0b21hdGUgcmVzb3VyY2UgbGlmZXRpbWUKPiA+IGNvbnRyb2wgb24gc3RydWN0
IGJ0dF9zYiAqc3VwZXIgaW4gZGlzY292ZXJfYXJlbmFzKCkuCj4gPiAKPiA+IFNpZ25lZC1vZmYt
Ynk6IERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1LmNuPgo+ID4gLS0tCj4gPiAgZHJp
dmVycy9udmRpbW0vYnR0LmMgfCAxMiArKysrLS0tLS0tLS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9udmRpbW0vYnR0LmMgYi9kcml2ZXJzL252ZGltbS9idHQuYwo+ID4gaW5kZXggZDU1OTNi
MGRjNzAwLi5mZjQyNzc4YjUxZGUgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL252ZGltbS9idHQu
Ywo+ID4gKysrIGIvZHJpdmVycy9udmRpbW0vYnR0LmMKPiA+IEBAIC0xNiw2ICsxNiw3IEBACj4g
PiAgI2luY2x1ZGUgPGxpbnV4L2ZzLmg+Cj4gPiAgI2luY2x1ZGUgPGxpbnV4L25kLmg+Cj4gPiAg
I2luY2x1ZGUgPGxpbnV4L2JhY2tpbmctZGV2Lmg+Cj4gPiArI2luY2x1ZGUgPGxpbnV4L2NsZWFu
dXAuaD4KPiA+ICAjaW5jbHVkZSAiYnR0LmgiCj4gPiAgI2luY2x1ZGUgIm5kLmgiCj4gPiAgCj4g
PiBAQCAtODQ3LDcgKzg0OCw3IEBAIHN0YXRpYyBpbnQgZGlzY292ZXJfYXJlbmFzKHN0cnVjdCBi
dHQgKmJ0dCkKPiA+ICB7Cj4gPiAgCWludCByZXQgPSAwOwo+ID4gIAlzdHJ1Y3QgYXJlbmFfaW5m
byAqYXJlbmE7Cj4gPiAtCXN0cnVjdCBidHRfc2IgKnN1cGVyOwo+ID4gKwlzdHJ1Y3QgYnR0X3Ni
ICpzdXBlciBfX2ZyZWUoa2ZyZWUpID0gTlVMTDsKPiA+ICAJc2l6ZV90IHJlbWFpbmluZyA9IGJ0
dC0+cmF3c2l6ZTsKPiA+ICAJdTY0IGN1cl9ubGJhID0gMDsKPiA+ICAJc2l6ZV90IGN1cl9vZmYg
PSAwOwo+ID4gQEAgLTg2MCwxMCArODYxLDggQEAgc3RhdGljIGludCBkaXNjb3Zlcl9hcmVuYXMo
c3RydWN0IGJ0dCAqYnR0KQo+ID4gIAl3aGlsZSAocmVtYWluaW5nKSB7Cj4gPiAgCQkvKiBBbGxv
YyBtZW1vcnkgZm9yIGFyZW5hICovCj4gPiAgCQlhcmVuYSA9IGFsbG9jX2FyZW5hKGJ0dCwgMCwg
MCwgMCk7Cj4gPiAtCQlpZiAoIWFyZW5hKSB7Cj4gPiAtCQkJcmV0ID0gLUVOT01FTTsKPiA+IC0J
CQlnb3RvIG91dF9zdXBlcjsKPiA+IC0JCX0KPiA+ICsJCWlmICghYXJlbmEpCj4gPiArCQkJcmV0
dXJuIC1FTk9NRU07Cj4gPiAgCj4gPiAgCQlhcmVuYS0+aW5mb29mZiA9IGN1cl9vZmY7Cj4gPiAg
CQlyZXQgPSBidHRfaW5mb19yZWFkKGFyZW5hLCBzdXBlcik7Cj4gPiBAQCAtOTE5LDE0ICs5MTgs
MTEgQEAgc3RhdGljIGludCBkaXNjb3Zlcl9hcmVuYXMoc3RydWN0IGJ0dCAqYnR0KQo+ID4gIAli
dHQtPm5sYmEgPSBjdXJfbmxiYTsKPiA+ICAJYnR0LT5pbml0X3N0YXRlID0gSU5JVF9SRUFEWTsK
PiA+ICAKPiA+IC0Ja2ZyZWUoc3VwZXIpOwo+ID4gIAlyZXR1cm4gcmV0Owo+ID4gIAo+ID4gICBv
dXQ6Cj4gPiAgCWtmcmVlKGFyZW5hKTsKPiA+ICAJZnJlZV9hcmVuYXMoYnR0KTsKPiA+IC0gb3V0
X3N1cGVyOgo+ID4gLQlrZnJlZShzdXBlcik7Cj4gPiAgCXJldHVybiByZXQ7Cj4gPiAgfQo+ID4g
IAo+IAo+IEkgd291bGQgZG8gdGhlIGFsbG9jYXRpb24gbGlrZSBzb21ldGhpbmcgYmVsb3cgZm9y
IHRoZSBmaXJzdCBjaHVuay4gT3RoZXJ3aXNlIHRoZSByZXN0IExHVE0uIAo+IAo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL252ZGltbS9idHQuYyBiL2RyaXZlcnMvbnZkaW1tL2J0dC5jCj4gaW5kZXgg
ZDU1OTNiMGRjNzAwLi4xNDM5MjFlN2YyNmMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9udmRpbW0v
YnR0LmMKPiArKysgYi9kcml2ZXJzL252ZGltbS9idHQuYwo+IEBAIC0xNiw2ICsxNiw3IEBACj4g
ICNpbmNsdWRlIDxsaW51eC9mcy5oPgo+ICAjaW5jbHVkZSA8bGludXgvbmQuaD4KPiAgI2luY2x1
ZGUgPGxpbnV4L2JhY2tpbmctZGV2Lmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9jbGVhbnVwLmg+Cj4g
ICNpbmNsdWRlICJidHQuaCIKPiAgI2luY2x1ZGUgIm5kLmgiCj4gIAo+IEBAIC04NDUsMjUgKzg0
NiwyMyBAQCBzdGF0aWMgdm9pZCBwYXJzZV9hcmVuYV9tZXRhKHN0cnVjdCBhcmVuYV9pbmZvICph
cmVuYSwgc3RydWN0IGJ0dF9zYiAqc3VwZXIsCj4gIAo+ICBzdGF0aWMgaW50IGRpc2NvdmVyX2Fy
ZW5hcyhzdHJ1Y3QgYnR0ICpidHQpCj4gIHsKPiArICAgICAgIHN0cnVjdCBidHRfc2IgKnN1cGVy
IF9fZnJlZShrZnJlZSkgPQo+ICsgICAgICAgICAgICAgICBremFsbG9jKHNpemVvZigqc3VwZXIp
LCBHRlBfS0VSTkVMKTsKPiAgICAgICAgIGludCByZXQgPSAwOwo+ICAgICAgICAgc3RydWN0IGFy
ZW5hX2luZm8gKmFyZW5hOwo+IC0gICAgICAgc3RydWN0IGJ0dF9zYiAqc3VwZXI7Cj4gICAgICAg
ICBzaXplX3QgcmVtYWluaW5nID0gYnR0LT5yYXdzaXplOwo+ICAgICAgICAgdTY0IGN1cl9ubGJh
ID0gMDsKPiAgICAgICAgIHNpemVfdCBjdXJfb2ZmID0gMDsKPiAgICAgICAgIGludCBudW1fYXJl
bmFzID0gMDsKPiAgCj4gLSAgICAgICBzdXBlciA9IGt6YWxsb2Moc2l6ZW9mKCpzdXBlciksIEdG
UF9LRVJORUwpOwo+ICAgICAgICAgaWYgKCFzdXBlcikKPiAgICAgICAgICAgICAgICAgcmV0dXJu
IC1FTk9NRU07Cj4gIAo+ICAgICAgICAgd2hpbGUgKHJlbWFpbmluZykgewo+ICAgICAgICAgICAg
ICAgICAvKiBBbGxvYyBtZW1vcnkgZm9yIGFyZW5hICovCgpJdCdzIGEgbGl0dGxlIHN0cmFuZ2Ug
dGhhdCB3ZSBkbyBub3QgY2hlY2sgc3VwZXIgaW1tZWRpYXRlbHkgYWZ0ZXIgYWxsb2NhdGlvbi4K
SG93IGFib3V0IHRoaXM6Cgogc3RhdGljIGludCBkaXNjb3Zlcl9hcmVuYXMoc3RydWN0IGJ0dCAq
YnR0KQogewogICAgICAgIGludCByZXQgPSAwOwogICAgICAgIHN0cnVjdCBhcmVuYV9pbmZvICph
cmVuYTsKLSAgICAgICBzdHJ1Y3QgYnR0X3NiICpzdXBlcjsKICAgICAgICBzaXplX3QgcmVtYWlu
aW5nID0gYnR0LT5yYXdzaXplOwogICAgICAgIHU2NCBjdXJfbmxiYSA9IDA7CiAgICAgICAgc2l6
ZV90IGN1cl9vZmYgPSAwOwogICAgICAgIGludCBudW1fYXJlbmFzID0gMDsKIAotICAgICAgIHN1
cGVyID0ga3phbGxvYyhzaXplb2YoKnN1cGVyKSwgR0ZQX0tFUk5FTCk7CisgICAgICAgc3RydWN0
IGJ0dF9zYiAqc3VwZXIgX19mcmVlKGtmcmVlKSA9IAorICAgICAgICAgICAgICAga3phbGxvYyhz
aXplb2YoKnN1cGVyKSwgR0ZQX0tFUk5FTCk7CiAgICAgICAgaWYgKCFzdXBlcikKICAgICAgICAg
ICAgICAgIHJldHVybiAtRU5PTUVNOwogCiAgICAgICAgd2hpbGUgKHJlbWFpbmluZykgewog

