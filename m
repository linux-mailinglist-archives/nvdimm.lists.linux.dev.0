Return-Path: <nvdimm+bounces-13620-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHY4HzhTu2lMigIAu9opvQ
	(envelope-from <nvdimm+bounces-13620-lists+linux-nvdimm=lfdr.de@lists.linux.dev>)
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 02:36:56 +0100
X-Original-To: lists+linux-nvdimm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E52682C4896
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 02:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E66F23169595
	for <lists+linux-nvdimm@lfdr.de>; Thu, 19 Mar 2026 01:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E872E3AF1;
	Thu, 19 Mar 2026 01:30:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47F62E6CB8
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883858; cv=none; b=S7bYiPhOuM32pU86tWYHWtwE57w+G12eo5HKKEwn6gYZc/cQZRfmdn+RdserQd2ln0HVuNFdbYHkaxmOZLnqCcxxtZPWGmt8ZgcsCoRIikkYwXcMoW28T/3g8HpCJ6ES/7Ctgz/0r4CYTdzvMQakue2iUvjyhfIJWxCwsX4hL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883858; c=relaxed/simple;
	bh=sfA+3bZvB69CzyWGHddi43wMVOfaqDDDp4VXMHtxteE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFf4GOdirwrupbOlY4BQo2TeTA7gMVJ+Azzlx6BXgln0jrAehJEaAIyzTnM3E6azFswYHhK+qrneE8lCn7O1Rfwp5ZEM+di4VTnKPAYl+bZG4gVU0lj3DGnWRb0gLqrD2opjKLea5fQFtXLQxeOnIK+qRIRbTVlabeke5vfltBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE9F01C3C9;
	Thu, 19 Mar 2026 01:30:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf17.hostedemail.com (Postfix) with ESMTPA id 4CF5A17;
	Thu, 19 Mar 2026 01:30:40 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V8 8/8] dax: export dax_dev_get()
Date: Wed, 18 Mar 2026 20:30:38 -0500
Message-ID: <20260319013038.4549-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202737.4344.dax@groves.net>
References: <20260318202737.4344.dax@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j193qn9epbsx3jmggzmtcj51pzrybqki
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX191OAqzPXQRJKjpTo6o4MsYujJdCFxnfJQ=
X-HE-Tag: 1773883840-433547
X-HE-Meta: U2FsdGVkX1+5CnNg1C5ZPYEOZ3Q1aVuXASLCeSLcwrIAfnA8vN/LETLXkZgQ1nTKYAOhT1/3y2pwjY2qLC6UfLMeH30OiVHKZ2BDqs9Hi/h6cw3fm126Rv+3td5TDEYGlqOqTARr/bGHqdaa4fyr3VhusGctg+9X05cv8ImdglvUlN+ecwLMvCtF9EOGeSF29SEP9F3m/aLMDOrO7Jtxf4Ujru7EAatRjqHeCeUnKZjGGp8lRHntGMOzr5ISCwdWq77q1jOEMEUIgGNEtlJ5k4Qe30PA8xMqh5HbVLfpFHOe9kQTmYo0wvInw0NeA7lO3Tbi7kq2Eb0ykgBWc0H8Gz3I8IvnyINl
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[40];
	FREEMAIL_CC(0.00)[micron.com,lwn.net,linuxfoundation.org,intel.com,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.org,gmail.com,huawei.com,redhat.com,toxicpanda.com,uniontech.com,arm.com,google.com,amd.com,gourry.net,vger.kernel.org,lists.linux.dev,groves.net];
	TAGGED_FROM(0.00)[bounces-13620-lists,linux-nvdimm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[groves.net];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[john@groves.net,nvdimm@lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.412];
	TAGGED_RCPT(0.00)[linux-nvdimm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,groves.net:email,groves.net:mid]
X-Rspamd-Queue-Id: E52682C4896
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

famfs needs to look up a dax_device by dev_t when resolving fmap
entries that reference character dax devices.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 3 ++-
 include/linux/dax.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index d4ab60c406bf..25cf99dd9360 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -521,7 +521,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-static struct dax_device *dax_dev_get(dev_t devt)
+struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -544,6 +544,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
+EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index f14fa2147175..2c7aba26a9ad 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -55,6 +55,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
+struct dax_device *dax_dev_get(dev_t devt);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
-- 
2.53.0


