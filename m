Return-Path: <nvdimm+bounces-4368-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB43957B0E6
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 08:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6217E1C20962
	for <lists+linux-nvdimm@lfdr.de>; Wed, 20 Jul 2022 06:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947B91FD7;
	Wed, 20 Jul 2022 06:17:43 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from donkey.elm.relay.mailchannels.net (donkey.elm.relay.mailchannels.net [23.83.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A131FBC
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 06:17:41 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 510038E149D;
	Wed, 20 Jul 2022 06:17:34 +0000 (UTC)
Received: from pdx1-sub0-mail-a292.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 530BF8E17D3;
	Wed, 20 Jul 2022 06:17:33 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658297853; a=rsa-sha256;
	cv=none;
	b=BQxR1FOAt32mzUZXlcBSZ3MsVIVMRhMHKmdBqkzO9KG11jMFLmyUyHLp17lBfMXkE3JhnO
	0ns7sCD/JjVnuq+jXGNRXw+u0KK8AqoRTHFQVYAiYb9hji8SfFfiYTHs3UENgHovEsJndC
	dWpDsLNjnzhkrAby4sw7G+NDFRr7p+DJGGgUmCePBY36Ge1zsSfb9nMjnixuRnQwh63xqe
	0+AMWAKASHkqVgzZe3LHaDqld4N50igtD1ydWpKh0637vKm0oO/2bPf80mktx193AzGV1D
	Uckwyfbs0mipd2reUmswRQiqQ0OkQzo1pYSBmf539+n8PJ8IeCqoMUaWy6IryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658297853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E2GwWipJtnq7yt5QT1h0NzHwAVhNO0D38gMoXwy9rg=;
	b=SkMoMRnDqT9ttGNGplaP+tQflwjxgmhdatZzleL+7/6ZiBxQe73ec98gC7SV7VsKoseeyT
	QrchBdAvwwKhNeJls0y3ijccekKevBYkdV0h8C4v9cUNZwOx25NkZmTKao2NVLeRnUfYHb
	jKM/4OrzIuUsCh6FOu/AD4C81aog9Ok3CY8LAdv0Y9aEUFMkGLTrgnktKYL0meBkZ4zxjl
	K+WGG8b+Cw3ZcP8qVNYeIhsyJ/IYYA+Rn29zs1Pt1qDXxXcZvZAdhdVWhdIoewl+Ctmqcg
	7uc6i+X9doNlso/ieN2J5igvdkQ3fK7QKiNbbIN6/UNV/FZpB/7C+akerTi12A==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-jvtlh;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Oafish-Society: 218982665cd041b0_1658297853920_73675413
X-MC-Loop-Signature: 1658297853920:935087253
X-MC-Ingress-Time: 1658297853920
Received: from pdx1-sub0-mail-a292.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.67.142 (trex/6.7.1);
	Wed, 20 Jul 2022 06:17:33 +0000
Received: from offworld (unknown [104.36.29.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a292.dreamhost.com (Postfix) with ESMTPSA id 4LnlqJ2RBsz2P;
	Tue, 19 Jul 2022 23:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658297852;
	bh=9E2GwWipJtnq7yt5QT1h0NzHwAVhNO0D38gMoXwy9rg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=dAno5u+9ZpKMJAkMJdfScCx5+4A0fZP4z/P/Ih7DegqZh4BnmxGtwpu9RyY439U4Q
	 Yg/hBpE6zsnZAx5MBd0fXdSUBqbok4NLumLHFSltYxhv7WWI+J/peRJ7IeaJvrXh9C
	 CFNahr0R1x93Snlvn0BQseTImVvl8jZZD2DvtsisKQ2SJXtKmDl0qzmsRQjZJnoiXG
	 TFREOwDtcMgulWjEUAwzbk3NCu09K034Od7z5inb3XAHz5PY2ITg5XDw4DhFKHSnQo
	 nyZJqOcIaHcV9ph+Tiklc1c5D1K9bG7BwQah8cSDuSKhMU/Rwif5+VlZTq7xU0oruM
	 v5ZRAEd4MTk/w==
Date: Tue, 19 Jul 2022 23:17:27 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	a.manzanares@samsung.com
Subject: Re: [PATCH RFC 13/15] cxl/pmem: Add "Passphrase Secure Erase"
 security command support
Message-ID: <20220720061727.ufygesevkonmeelr@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791938847.2491387.8701829648751368015.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165791938847.2491387.8701829648751368015.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Fri, 15 Jul 2022, Dave Jiang wrote:

>Create callback function to support the nvdimm_security_ops() ->erase()
>callback. Translate the operation to send "Passphrase Secure Erase"
>security command for CXL memory device.
>
>When the mem device is secure erased, arch_invalidate_nvdimm_cache() is
>called in order to invalidate all CPU caches before attempting to access
>the mem device again.
>
>See CXL 2.0 spec section 8.2.9.5.6.6 for reference.

So something like the below is what I picture for 8.2.9.5.5.2
(I'm still thinking about the background command polling semantics
and corner cases for the overwrite/sanitize - also needed for
scan media - so I haven't implemented 8.2.9.5.5.1, but should
otherwise be straightforward).

The use cases here would be:

$> cxl sanitize --crypto-erase memN
$> cxl sanitize --overwrite memN
$> cxl sanitize --wait-overwrite memN

While slightly out of the scope of this series, it still might be
worth carrying as they are that unrelated unless there is something
fundamentally with my approach.

Thanks,
Davidlohr

-----<8----------------------------------------------------
[PATCH 16/15] cxl/mbox: Add "Secure Erase" security command support

To properly support this feature, create a 'security' sysfs
file that when read will list the current pmem security state,
and when written to, perform the requested operation (only
secure erase is currently supported).

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
  Documentation/ABI/testing/sysfs-bus-cxl | 13 +++++++
  drivers/cxl/core/mbox.c                 | 44 +++++++++++++++++++++
  drivers/cxl/core/memdev.c               | 51 +++++++++++++++++++++++++
  drivers/cxl/cxlmem.h                    |  3 ++
  4 files changed, 111 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 7c2b846521f3..ca5216b37bcf 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -52,6 +52,19 @@ Description:
  		host PCI device for this memory device, emit the CPU node
  		affinity for this device.
  
+What:		/sys/bus/cxl/devices/memX/security
+Date:		July, 2022
+KernelVersion:	v5.21
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Reading this file will display the security state for that
+		device. The following states are available: disabled, frozen,
+		locked and unlocked. When writing to the file, the following
+		command(s) are supported:
+		erase - Secure Erase user data by changing the media encryption
+			keys for all user data areas of the device. This causes
+			all CPU caches to be flushed.
+
  What:		/sys/bus/cxl/devices/*/devtype
  Date:		June, 2021
  KernelVersion:	v5.14
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 54f434733b56..54b4aec615ee 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -787,6 +787,50 @@ int cxl_dev_state_identify(struct cxl_dev_state *cxlds)
  }
  EXPORT_SYMBOL_NS_GPL(cxl_dev_state_identify, CXL);
  
+/**
+ * cxl_mem_sanitize() - Send sanitation related commands to the device.
+ * @cxlds: The device data for the operation
+ * @cmd: The command opcode to send
+ *
+ * Return: 0 if the command was executed successfully, regardless of
+ * whether or not the actual security operation is done in the background.
+ * Upon error, return the result of the mailbox command or -EINVAL if
+ * security requirements are not met.
+ *
+ * See CXL 2.0 @8.2.9.5.5 Sanitize.
+ */
+int cxl_mem_sanitize(struct cxl_dev_state *cxlds, enum cxl_opcode cmd)
+{
+	int rc;
+	u32 sec_out;
+
+	/* TODO: CXL_MBOX_OP_SECURE_SANITIZE */
+	if (cmd != CXL_MBOX_OP_SECURE_ERASE)
+		return -EINVAL;
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE,
+			       NULL, 0, &sec_out, sizeof(sec_out));
+	if (rc)
+		return rc;
+	/*
+	 * Prior to using these commands, any security applied to
+	 * the user data areas of the device shall be DISABLED (or
+	 * UNLOCKED for secure erase case).
+	 */
+	if (sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET ||
+	    sec_out & CXL_PMEM_SEC_STATE_LOCKED)
+		return -EINVAL;
+
+	rc = cxl_mbox_send_cmd(cxlds, cmd, NULL, 0, NULL, 0);
+	if (rc == 0) {
+		/* flush all CPU caches before we read it */
+		flush_cache_all();
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_mem_sanitize, CXL);
+
  int cxl_mem_create_range_info(struct cxl_dev_state *cxlds)
  {
  	int rc;
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index f7cdcd33504a..13563facfd62 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -106,12 +106,63 @@ static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
  }
  static DEVICE_ATTR_RO(numa_node);
  
+#define CXL_SEC_CMD_SIZE 32
+
+static ssize_t security_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	u32 sec_out;
+	int rc;
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE,
+			       NULL, 0, &sec_out, sizeof(sec_out));
+	if (rc)
+		return rc;
+
+	if (!(sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET))
+		return sprintf(buf, "disabled\n");
+	if (sec_out & CXL_PMEM_SEC_STATE_FROZEN)
+		return sprintf(buf, "frozen\n");
+	if (sec_out & CXL_PMEM_SEC_STATE_LOCKED)
+		return sprintf(buf, "locked\n");
+	else
+		return sprintf(buf, "unlocked\n");
+}
+
+static ssize_t security_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	char cmd[CXL_SEC_CMD_SIZE+1];
+	ssize_t rc;
+
+	rc = sscanf(buf, "%"__stringify(CXL_SEC_CMD_SIZE)"s", cmd);
+	if (rc < 1)
+		return -EINVAL;
+
+	if (sysfs_streq(cmd, "erase")) {
+		dev_dbg(dev, "secure-erase\n");
+		rc = cxl_mem_sanitize(cxlds, CXL_MBOX_OP_SECURE_ERASE);
+	} else
+		rc = -EINVAL;
+
+	if (rc == 0)
+		rc = len;
+	return rc;
+}
+static DEVICE_ATTR_RW(security);
+
  static struct attribute *cxl_memdev_attributes[] = {
  	&dev_attr_serial.attr,
  	&dev_attr_firmware_version.attr,
  	&dev_attr_payload_max.attr,
  	&dev_attr_label_storage_size.attr,
  	&dev_attr_numa_node.attr,
+	&dev_attr_security.attr,
  	NULL,
  };
  
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index a375a69040d2..cd6650ff757f 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -250,6 +250,7 @@ enum cxl_opcode {
  	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
  	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
  	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
+	CXL_MBOX_OP_SECURE_ERASE        = 0x4401,
  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
  	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
  	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
@@ -348,6 +349,8 @@ struct cxl_mem_command {
  #define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
  };
  
+int cxl_mem_sanitize(struct cxl_dev_state *cxlds, enum cxl_opcode cmd);
+
  #define CXL_PMEM_SEC_STATE_USER_PASS_SET	0x01
  #define CXL_PMEM_SEC_STATE_MASTER_PASS_SET	0x02
  #define CXL_PMEM_SEC_STATE_LOCKED		0x04
-- 
2.36.1

