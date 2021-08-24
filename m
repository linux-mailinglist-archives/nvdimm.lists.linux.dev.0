Return-Path: <nvdimm+bounces-997-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2C83F6253
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 18:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id A32F81C1004
	for <lists+linux-nvdimm@lfdr.de>; Tue, 24 Aug 2021 16:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEEA3FD8;
	Tue, 24 Aug 2021 16:07:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71BC3FC5
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:51 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="278355890"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="278355890"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="425515204"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:57 -0700
Subject: [PATCH v3 17/28] cxl/mbox: Move mailbox and other non-PCI specific
 infrastructure to the core
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, kernel test robot <lkp@intel.com>,
 vishal.l.verma@intel.com, alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:57 -0700
Message-ID: <162982121720.1124374.4630115550776741892.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the internals of mailbox operations are abstracted from the PCI
specifics a bulk of infrastructure can move to the core.

The CXL_PMEM driver intends to proxy LIBNVDIMM UAPI and driver requests
to the equivalent functionality provided by the CXL hardware mailbox
interface. In support of that intent move the mailbox implementation to
a shared location for the CXL_PCI driver native IOCTL path and CXL_PMEM
nvdimm command proxy path to share.

A unit test framework seeks to implement a unit test backend transport
for mailbox commands to communicate mocked up payloads. It can reuse all
of the mailbox infrastructure minus the PCI specifics, so that also gets
moved to the core.

Finally with the mailbox infrastructure and ioctl handling being
transport generic there is no longer any need to pass file
file_operations to devm_cxl_add_memdev(). That allows all the ioctl
boilerplate to move into the core for unit test reuse.

No functional change intended, just code movement.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/driver-api/cxl/memory-devices.rst |    3 
 drivers/cxl/core/Makefile                       |    1 
 drivers/cxl/core/bus.c                          |    4 
 drivers/cxl/core/core.h                         |    8 
 drivers/cxl/core/mbox.c                         |  834 ++++++++++++++++++++
 drivers/cxl/core/memdev.c                       |   81 ++
 drivers/cxl/cxlmem.h                            |   81 ++
 drivers/cxl/pci.c                               |  941 -----------------------
 8 files changed, 987 insertions(+), 966 deletions(-)
 create mode 100644 drivers/cxl/core/mbox.c

diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index 46847d8c70a0..356f70d28316 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -45,6 +45,9 @@ CXL Core
 .. kernel-doc:: drivers/cxl/core/regs.c
    :internal:
 
+.. kernel-doc:: drivers/cxl/core/mbox.c
+   :doc: cxl mbox
+
 External Interfaces
 ===================
 
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 0fdbf3c6ac1a..07eb8e1fb8a6 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -6,3 +6,4 @@ cxl_core-y := bus.o
 cxl_core-y += pmem.o
 cxl_core-y += regs.o
 cxl_core-y += memdev.o
+cxl_core-y += mbox.o
diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
index 37b87adaa33f..8073354ba232 100644
--- a/drivers/cxl/core/bus.c
+++ b/drivers/cxl/core/bus.c
@@ -636,6 +636,8 @@ static __init int cxl_core_init(void)
 {
 	int rc;
 
+	cxl_mbox_init();
+
 	rc = cxl_memdev_init();
 	if (rc)
 		return rc;
@@ -647,6 +649,7 @@ static __init int cxl_core_init(void)
 
 err:
 	cxl_memdev_exit();
+	cxl_mbox_exit();
 	return rc;
 }
 
@@ -654,6 +657,7 @@ static void cxl_core_exit(void)
 {
 	bus_unregister(&cxl_bus_type);
 	cxl_memdev_exit();
+	cxl_mbox_exit();
 }
 
 module_init(cxl_core_init);
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 036a3c8106b4..c85b7fbad02d 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -14,7 +14,15 @@ static inline void unregister_cxl_dev(void *dev)
 	device_unregister(dev);
 }
 
+struct cxl_send_command;
+struct cxl_mem_query_commands;
+int cxl_query_cmd(struct cxl_memdev *cxlmd,
+		  struct cxl_mem_query_commands __user *q);
+int cxl_send_cmd(struct cxl_memdev *cxlmd, struct cxl_send_command __user *s);
+
 int cxl_memdev_init(void);
 void cxl_memdev_exit(void);
+void cxl_mbox_init(void);
+void cxl_mbox_exit(void);
 
 #endif /* __CXL_CORE_H__ */
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
new file mode 100644
index 000000000000..706fe007c8d6
--- /dev/null
+++ b/drivers/cxl/core/mbox.c
@@ -0,0 +1,834 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2020 Intel Corporation. All rights reserved. */
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/security.h>
+#include <linux/debugfs.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <cxlmem.h>
+#include <cxl.h>
+
+#include "core.h"
+
+static bool cxl_raw_allow_all;
+
+/**
+ * DOC: cxl mbox
+ *
+ * Core implementation of the CXL 2.0 Type-3 Memory Device Mailbox. The
+ * implementation is used by the cxl_pci driver to initialize the device
+ * and implement the cxl_mem.h IOCTL UAPI. It also implements the
+ * backend of the cxl_pmem_ctl() transport for LIBNVDIMM.
+ *
+ */
+
+#define cxl_for_each_cmd(cmd)                                                  \
+	for ((cmd) = &cxl_mem_commands[0];                                     \
+	     ((cmd)-cxl_mem_commands) < ARRAY_SIZE(cxl_mem_commands); (cmd)++)
+
+#define cxl_doorbell_busy(cxlm)                                                \
+	(readl((cxlm)->regs.mbox + CXLDEV_MBOX_CTRL_OFFSET) &                  \
+	 CXLDEV_MBOX_CTRL_DOORBELL)
+
+/* CXL 2.0 - 8.2.8.4 */
+#define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)
+
+#define CXL_CMD(_id, sin, sout, _flags)                                        \
+	[CXL_MEM_COMMAND_ID_##_id] = {                                         \
+	.info =	{                                                              \
+			.id = CXL_MEM_COMMAND_ID_##_id,                        \
+			.size_in = sin,                                        \
+			.size_out = sout,                                      \
+		},                                                             \
+	.opcode = CXL_MBOX_OP_##_id,                                           \
+	.flags = _flags,                                                       \
+	}
+
+/*
+ * This table defines the supported mailbox commands for the driver. This table
+ * is made up of a UAPI structure. Non-negative values as parameters in the
+ * table will be validated against the user's input. For example, if size_in is
+ * 0, and the user passed in 1, it is an error.
+ */
+static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
+	CXL_CMD(IDENTIFY, 0, 0x43, CXL_CMD_FLAG_FORCE_ENABLE),
+#ifdef CONFIG_CXL_MEM_RAW_COMMANDS
+	CXL_CMD(RAW, ~0, ~0, 0),
+#endif
+	CXL_CMD(GET_SUPPORTED_LOGS, 0, ~0, CXL_CMD_FLAG_FORCE_ENABLE),
+	CXL_CMD(GET_FW_INFO, 0, 0x50, 0),
+	CXL_CMD(GET_PARTITION_INFO, 0, 0x20, 0),
+	CXL_CMD(GET_LSA, 0x8, ~0, 0),
+	CXL_CMD(GET_HEALTH_INFO, 0, 0x12, 0),
+	CXL_CMD(GET_LOG, 0x18, ~0, CXL_CMD_FLAG_FORCE_ENABLE),
+	CXL_CMD(SET_PARTITION_INFO, 0x0a, 0, 0),
+	CXL_CMD(SET_LSA, ~0, 0, 0),
+	CXL_CMD(GET_ALERT_CONFIG, 0, 0x10, 0),
+	CXL_CMD(SET_ALERT_CONFIG, 0xc, 0, 0),
+	CXL_CMD(GET_SHUTDOWN_STATE, 0, 0x1, 0),
+	CXL_CMD(SET_SHUTDOWN_STATE, 0x1, 0, 0),
+	CXL_CMD(GET_POISON, 0x10, ~0, 0),
+	CXL_CMD(INJECT_POISON, 0x8, 0, 0),
+	CXL_CMD(CLEAR_POISON, 0x48, 0, 0),
+	CXL_CMD(GET_SCAN_MEDIA_CAPS, 0x10, 0x4, 0),
+	CXL_CMD(SCAN_MEDIA, 0x11, 0, 0),
+	CXL_CMD(GET_SCAN_MEDIA, 0, ~0, 0),
+};
+
+/*
+ * Commands that RAW doesn't permit. The rationale for each:
+ *
+ * CXL_MBOX_OP_ACTIVATE_FW: Firmware activation requires adjustment /
+ * coordination of transaction timeout values at the root bridge level.
+ *
+ * CXL_MBOX_OP_SET_PARTITION_INFO: The device memory map may change live
+ * and needs to be coordinated with HDM updates.
+ *
+ * CXL_MBOX_OP_SET_LSA: The label storage area may be cached by the
+ * driver and any writes from userspace invalidates those contents.
+ *
+ * CXL_MBOX_OP_SET_SHUTDOWN_STATE: Set shutdown state assumes no writes
+ * to the device after it is marked clean, userspace can not make that
+ * assertion.
+ *
+ * CXL_MBOX_OP_[GET_]SCAN_MEDIA: The kernel provides a native error list that
+ * is kept up to date with patrol notifications and error management.
+ */
+static u16 cxl_disabled_raw_commands[] = {
+	CXL_MBOX_OP_ACTIVATE_FW,
+	CXL_MBOX_OP_SET_PARTITION_INFO,
+	CXL_MBOX_OP_SET_LSA,
+	CXL_MBOX_OP_SET_SHUTDOWN_STATE,
+	CXL_MBOX_OP_SCAN_MEDIA,
+	CXL_MBOX_OP_GET_SCAN_MEDIA,
+};
+
+/*
+ * Command sets that RAW doesn't permit. All opcodes in this set are
+ * disabled because they pass plain text security payloads over the
+ * user/kernel boundary. This functionality is intended to be wrapped
+ * behind the keys ABI which allows for encrypted payloads in the UAPI
+ */
+static u8 security_command_sets[] = {
+	0x44, /* Sanitize */
+	0x45, /* Persistent Memory Data-at-rest Security */
+	0x46, /* Security Passthrough */
+};
+
+static bool cxl_is_security_command(u16 opcode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(security_command_sets); i++)
+		if (security_command_sets[i] == (opcode >> 8))
+			return true;
+	return false;
+}
+
+static struct cxl_mem_command *cxl_mem_find_command(u16 opcode)
+{
+	struct cxl_mem_command *c;
+
+	cxl_for_each_cmd(c)
+		if (c->opcode == opcode)
+			return c;
+
+	return NULL;
+}
+
+/**
+ * cxl_mem_mbox_send_cmd() - Send a mailbox command to a memory device.
+ * @cxlm: The CXL memory device to communicate with.
+ * @opcode: Opcode for the mailbox command.
+ * @in: The input payload for the mailbox command.
+ * @in_size: The length of the input payload
+ * @out: Caller allocated buffer for the output.
+ * @out_size: Expected size of output.
+ *
+ * Context: Any context. Will acquire and release mbox_mutex.
+ * Return:
+ *  * %>=0	- Number of bytes returned in @out.
+ *  * %-E2BIG	- Payload is too large for hardware.
+ *  * %-EBUSY	- Couldn't acquire exclusive mailbox access.
+ *  * %-EFAULT	- Hardware error occurred.
+ *  * %-ENXIO	- Command completed, but device reported an error.
+ *  * %-EIO	- Unexpected output size.
+ *
+ * Mailbox commands may execute successfully yet the device itself reported an
+ * error. While this distinction can be useful for commands from userspace, the
+ * kernel will only be able to use results when both are successful.
+ *
+ * See __cxl_mem_mbox_send_cmd()
+ */
+int cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm, u16 opcode, void *in,
+			  size_t in_size, void *out, size_t out_size)
+{
+	const struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
+	struct cxl_mbox_cmd mbox_cmd = {
+		.opcode = opcode,
+		.payload_in = in,
+		.size_in = in_size,
+		.size_out = out_size,
+		.payload_out = out,
+	};
+	int rc;
+
+	if (out_size > cxlm->payload_size)
+		return -E2BIG;
+
+	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
+	if (rc)
+		return rc;
+
+	/* TODO: Map return code to proper kernel style errno */
+	if (mbox_cmd.return_code != CXL_MBOX_SUCCESS)
+		return -ENXIO;
+
+	/*
+	 * Variable sized commands can't be validated and so it's up to the
+	 * caller to do that if they wish.
+	 */
+	if (cmd->info.size_out >= 0 && mbox_cmd.size_out != out_size)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_mem_mbox_send_cmd);
+
+static bool cxl_mem_raw_command_allowed(u16 opcode)
+{
+	int i;
+
+	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
+		return false;
+
+	if (security_locked_down(LOCKDOWN_NONE))
+		return false;
+
+	if (cxl_raw_allow_all)
+		return true;
+
+	if (cxl_is_security_command(opcode))
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(cxl_disabled_raw_commands); i++)
+		if (cxl_disabled_raw_commands[i] == opcode)
+			return false;
+
+	return true;
+}
+
+/**
+ * cxl_validate_cmd_from_user() - Check fields for CXL_MEM_SEND_COMMAND.
+ * @cxlm: &struct cxl_mem device whose mailbox will be used.
+ * @send_cmd: &struct cxl_send_command copied in from userspace.
+ * @out_cmd: Sanitized and populated &struct cxl_mem_command.
+ *
+ * Return:
+ *  * %0	- @out_cmd is ready to send.
+ *  * %-ENOTTY	- Invalid command specified.
+ *  * %-EINVAL	- Reserved fields or invalid values were used.
+ *  * %-ENOMEM	- Input or output buffer wasn't sized properly.
+ *  * %-EPERM	- Attempted to use a protected command.
+ *
+ * The result of this command is a fully validated command in @out_cmd that is
+ * safe to send to the hardware.
+ *
+ * See handle_mailbox_cmd_from_user()
+ */
+static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
+				      const struct cxl_send_command *send_cmd,
+				      struct cxl_mem_command *out_cmd)
+{
+	const struct cxl_command_info *info;
+	struct cxl_mem_command *c;
+
+	if (send_cmd->id == 0 || send_cmd->id >= CXL_MEM_COMMAND_ID_MAX)
+		return -ENOTTY;
+
+	/*
+	 * The user can never specify an input payload larger than what hardware
+	 * supports, but output can be arbitrarily large (simply write out as
+	 * much data as the hardware provides).
+	 */
+	if (send_cmd->in.size > cxlm->payload_size)
+		return -EINVAL;
+
+	/*
+	 * Checks are bypassed for raw commands but a WARN/taint will occur
+	 * later in the callchain
+	 */
+	if (send_cmd->id == CXL_MEM_COMMAND_ID_RAW) {
+		const struct cxl_mem_command temp = {
+			.info = {
+				.id = CXL_MEM_COMMAND_ID_RAW,
+				.flags = 0,
+				.size_in = send_cmd->in.size,
+				.size_out = send_cmd->out.size,
+			},
+			.opcode = send_cmd->raw.opcode
+		};
+
+		if (send_cmd->raw.rsvd)
+			return -EINVAL;
+
+		/*
+		 * Unlike supported commands, the output size of RAW commands
+		 * gets passed along without further checking, so it must be
+		 * validated here.
+		 */
+		if (send_cmd->out.size > cxlm->payload_size)
+			return -EINVAL;
+
+		if (!cxl_mem_raw_command_allowed(send_cmd->raw.opcode))
+			return -EPERM;
+
+		memcpy(out_cmd, &temp, sizeof(temp));
+
+		return 0;
+	}
+
+	if (send_cmd->flags & ~CXL_MEM_COMMAND_FLAG_MASK)
+		return -EINVAL;
+
+	if (send_cmd->rsvd)
+		return -EINVAL;
+
+	if (send_cmd->in.rsvd || send_cmd->out.rsvd)
+		return -EINVAL;
+
+	/* Convert user's command into the internal representation */
+	c = &cxl_mem_commands[send_cmd->id];
+	info = &c->info;
+
+	/* Check that the command is enabled for hardware */
+	if (!test_bit(info->id, cxlm->enabled_cmds))
+		return -ENOTTY;
+
+	/* Check the input buffer is the expected size */
+	if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
+		return -ENOMEM;
+
+	/* Check the output buffer is at least large enough */
+	if (info->size_out >= 0 && send_cmd->out.size < info->size_out)
+		return -ENOMEM;
+
+	memcpy(out_cmd, c, sizeof(*c));
+	out_cmd->info.size_in = send_cmd->in.size;
+	/*
+	 * XXX: out_cmd->info.size_out will be controlled by the driver, and the
+	 * specified number of bytes @send_cmd->out.size will be copied back out
+	 * to userspace.
+	 */
+
+	return 0;
+}
+
+#define cxl_cmd_count ARRAY_SIZE(cxl_mem_commands)
+
+int cxl_query_cmd(struct cxl_memdev *cxlmd,
+		  struct cxl_mem_query_commands __user *q)
+{
+	struct device *dev = &cxlmd->dev;
+	struct cxl_mem_command *cmd;
+	u32 n_commands;
+	int j = 0;
+
+	dev_dbg(dev, "Query IOCTL\n");
+
+	if (get_user(n_commands, &q->n_commands))
+		return -EFAULT;
+
+	/* returns the total number if 0 elements are requested. */
+	if (n_commands == 0)
+		return put_user(cxl_cmd_count, &q->n_commands);
+
+	/*
+	 * otherwise, return max(n_commands, total commands) cxl_command_info
+	 * structures.
+	 */
+	cxl_for_each_cmd(cmd) {
+		const struct cxl_command_info *info = &cmd->info;
+
+		if (copy_to_user(&q->commands[j++], info, sizeof(*info)))
+			return -EFAULT;
+
+		if (j == n_commands)
+			break;
+	}
+
+	return 0;
+}
+
+/**
+ * handle_mailbox_cmd_from_user() - Dispatch a mailbox command for userspace.
+ * @cxlm: The CXL memory device to communicate with.
+ * @cmd: The validated command.
+ * @in_payload: Pointer to userspace's input payload.
+ * @out_payload: Pointer to userspace's output payload.
+ * @size_out: (Input) Max payload size to copy out.
+ *            (Output) Payload size hardware generated.
+ * @retval: Hardware generated return code from the operation.
+ *
+ * Return:
+ *  * %0	- Mailbox transaction succeeded. This implies the mailbox
+ *		  protocol completed successfully not that the operation itself
+ *		  was successful.
+ *  * %-ENOMEM  - Couldn't allocate a bounce buffer.
+ *  * %-EFAULT	- Something happened with copy_to/from_user.
+ *  * %-EINTR	- Mailbox acquisition interrupted.
+ *  * %-EXXX	- Transaction level failures.
+ *
+ * Creates the appropriate mailbox command and dispatches it on behalf of a
+ * userspace request. The input and output payloads are copied between
+ * userspace.
+ *
+ * See cxl_send_cmd().
+ */
+static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
+					const struct cxl_mem_command *cmd,
+					u64 in_payload, u64 out_payload,
+					s32 *size_out, u32 *retval)
+{
+	struct device *dev = cxlm->dev;
+	struct cxl_mbox_cmd mbox_cmd = {
+		.opcode = cmd->opcode,
+		.size_in = cmd->info.size_in,
+		.size_out = cmd->info.size_out,
+	};
+	int rc;
+
+	if (cmd->info.size_out) {
+		mbox_cmd.payload_out = kvzalloc(cmd->info.size_out, GFP_KERNEL);
+		if (!mbox_cmd.payload_out)
+			return -ENOMEM;
+	}
+
+	if (cmd->info.size_in) {
+		mbox_cmd.payload_in = vmemdup_user(u64_to_user_ptr(in_payload),
+						   cmd->info.size_in);
+		if (IS_ERR(mbox_cmd.payload_in)) {
+			kvfree(mbox_cmd.payload_out);
+			return PTR_ERR(mbox_cmd.payload_in);
+		}
+	}
+
+	dev_dbg(dev,
+		"Submitting %s command for user\n"
+		"\topcode: %x\n"
+		"\tsize: %ub\n",
+		cxl_command_names[cmd->info.id].name, mbox_cmd.opcode,
+		cmd->info.size_in);
+
+	dev_WARN_ONCE(dev, cmd->info.id == CXL_MEM_COMMAND_ID_RAW,
+		      "raw command path used\n");
+
+	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
+	if (rc)
+		goto out;
+
+	/*
+	 * @size_out contains the max size that's allowed to be written back out
+	 * to userspace. While the payload may have written more output than
+	 * this it will have to be ignored.
+	 */
+	if (mbox_cmd.size_out) {
+		dev_WARN_ONCE(dev, mbox_cmd.size_out > *size_out,
+			      "Invalid return size\n");
+		if (copy_to_user(u64_to_user_ptr(out_payload),
+				 mbox_cmd.payload_out, mbox_cmd.size_out)) {
+			rc = -EFAULT;
+			goto out;
+		}
+	}
+
+	*size_out = mbox_cmd.size_out;
+	*retval = mbox_cmd.return_code;
+
+out:
+	kvfree(mbox_cmd.payload_in);
+	kvfree(mbox_cmd.payload_out);
+	return rc;
+}
+
+int cxl_send_cmd(struct cxl_memdev *cxlmd, struct cxl_send_command __user *s)
+{
+	struct cxl_mem *cxlm = cxlmd->cxlm;
+	struct device *dev = &cxlmd->dev;
+	struct cxl_send_command send;
+	struct cxl_mem_command c;
+	int rc;
+
+	dev_dbg(dev, "Send IOCTL\n");
+
+	if (copy_from_user(&send, s, sizeof(send)))
+		return -EFAULT;
+
+	rc = cxl_validate_cmd_from_user(cxlmd->cxlm, &send, &c);
+	if (rc)
+		return rc;
+
+	/* Prepare to handle a full payload for variable sized output */
+	if (c.info.size_out < 0)
+		c.info.size_out = cxlm->payload_size;
+
+	rc = handle_mailbox_cmd_from_user(cxlm, &c, send.in.payload,
+					  send.out.payload, &send.out.size,
+					  &send.retval);
+	if (rc)
+		return rc;
+
+	if (copy_to_user(s, &send, sizeof(send)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
+{
+	u32 remaining = size;
+	u32 offset = 0;
+
+	while (remaining) {
+		u32 xfer_size = min_t(u32, remaining, cxlm->payload_size);
+		struct cxl_mbox_get_log {
+			uuid_t uuid;
+			__le32 offset;
+			__le32 length;
+		} __packed log = {
+			.uuid = *uuid,
+			.offset = cpu_to_le32(offset),
+			.length = cpu_to_le32(xfer_size)
+		};
+		int rc;
+
+		rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_LOG, &log,
+					   sizeof(log), out, xfer_size);
+		if (rc < 0)
+			return rc;
+
+		out += xfer_size;
+		remaining -= xfer_size;
+		offset += xfer_size;
+	}
+
+	return 0;
+}
+
+/**
+ * cxl_walk_cel() - Walk through the Command Effects Log.
+ * @cxlm: Device.
+ * @size: Length of the Command Effects Log.
+ * @cel: CEL
+ *
+ * Iterate over each entry in the CEL and determine if the driver supports the
+ * command. If so, the command is enabled for the device and can be used later.
+ */
+static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
+{
+	struct cel_entry {
+		__le16 opcode;
+		__le16 effect;
+	} __packed * cel_entry;
+	const int cel_entries = size / sizeof(*cel_entry);
+	int i;
+
+	cel_entry = (struct cel_entry *)cel;
+
+	for (i = 0; i < cel_entries; i++) {
+		u16 opcode = le16_to_cpu(cel_entry[i].opcode);
+		struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
+
+		if (!cmd) {
+			dev_dbg(cxlm->dev,
+				"Opcode 0x%04x unsupported by driver", opcode);
+			continue;
+		}
+
+		set_bit(cmd->info.id, cxlm->enabled_cmds);
+	}
+}
+
+struct cxl_mbox_get_supported_logs {
+	__le16 entries;
+	u8 rsvd[6];
+	struct gsl_entry {
+		uuid_t uuid;
+		__le32 size;
+	} __packed entry[];
+} __packed;
+
+static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
+{
+	struct cxl_mbox_get_supported_logs *ret;
+	int rc;
+
+	ret = kvmalloc(cxlm->payload_size, GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_SUPPORTED_LOGS, NULL,
+				   0, ret, cxlm->payload_size);
+	if (rc < 0) {
+		kvfree(ret);
+		return ERR_PTR(rc);
+	}
+
+	return ret;
+}
+
+enum {
+	CEL_UUID,
+	VENDOR_DEBUG_UUID,
+};
+
+/* See CXL 2.0 Table 170. Get Log Input Payload */
+static const uuid_t log_uuid[] = {
+	[CEL_UUID] = UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96,
+			       0xb1, 0x62, 0x3b, 0x3f, 0x17),
+	[VENDOR_DEBUG_UUID] = UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f,
+					0xd6, 0x07, 0x19, 0x40, 0x3d, 0x86),
+};
+
+/**
+ * cxl_mem_enumerate_cmds() - Enumerate commands for a device.
+ * @cxlm: The device.
+ *
+ * Returns 0 if enumerate completed successfully.
+ *
+ * CXL devices have optional support for certain commands. This function will
+ * determine the set of supported commands for the hardware and update the
+ * enabled_cmds bitmap in the @cxlm.
+ */
+int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm)
+{
+	struct cxl_mbox_get_supported_logs *gsl;
+	struct device *dev = cxlm->dev;
+	struct cxl_mem_command *cmd;
+	int i, rc;
+
+	gsl = cxl_get_gsl(cxlm);
+	if (IS_ERR(gsl))
+		return PTR_ERR(gsl);
+
+	rc = -ENOENT;
+	for (i = 0; i < le16_to_cpu(gsl->entries); i++) {
+		u32 size = le32_to_cpu(gsl->entry[i].size);
+		uuid_t uuid = gsl->entry[i].uuid;
+		u8 *log;
+
+		dev_dbg(dev, "Found LOG type %pU of size %d", &uuid, size);
+
+		if (!uuid_equal(&uuid, &log_uuid[CEL_UUID]))
+			continue;
+
+		log = kvmalloc(size, GFP_KERNEL);
+		if (!log) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		rc = cxl_xfer_log(cxlm, &uuid, size, log);
+		if (rc) {
+			kvfree(log);
+			goto out;
+		}
+
+		cxl_walk_cel(cxlm, size, log);
+		kvfree(log);
+
+		/* In case CEL was bogus, enable some default commands. */
+		cxl_for_each_cmd(cmd)
+			if (cmd->flags & CXL_CMD_FLAG_FORCE_ENABLE)
+				set_bit(cmd->info.id, cxlm->enabled_cmds);
+
+		/* Found the required CEL */
+		rc = 0;
+	}
+
+out:
+	kvfree(gsl);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(cxl_mem_enumerate_cmds);
+
+/**
+ * cxl_mem_get_partition_info - Get partition info
+ * @cxlm: The device to act on
+ * @active_volatile_bytes: returned active volatile capacity; in bytes
+ * @active_persistent_bytes: returned active persistent capacity; in bytes
+ * @next_volatile_bytes: return next volatile capacity; in bytes
+ * @next_persistent_bytes: return next persistent capacity; in bytes
+ *
+ * Retrieve the current partition info for the device specified.  The active
+ * values are the current capacity in bytes.  If not 0, the 'next' values are
+ * the pending values, in bytes, which take affect on next cold reset.
+ *
+ * Return: 0 if no error: or the result of the mailbox command.
+ *
+ * See CXL @8.2.9.5.2.1 Get Partition Info
+ */
+static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
+{
+	struct cxl_mbox_get_partition_info {
+		__le64 active_volatile_cap;
+		__le64 active_persistent_cap;
+		__le64 next_volatile_cap;
+		__le64 next_persistent_cap;
+	} __packed pi;
+	int rc;
+
+	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_PARTITION_INFO,
+				   NULL, 0, &pi, sizeof(pi));
+
+	if (rc)
+		return rc;
+
+	cxlm->active_volatile_bytes =
+		le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->active_persistent_bytes =
+		le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_volatile_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->next_persistent_bytes =
+		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
+
+	return 0;
+}
+
+/**
+ * cxl_mem_identify() - Send the IDENTIFY command to the device.
+ * @cxlm: The device to identify.
+ *
+ * Return: 0 if identify was executed successfully.
+ *
+ * This will dispatch the identify command to the device and on success populate
+ * structures to be exported to sysfs.
+ */
+int cxl_mem_identify(struct cxl_mem *cxlm)
+{
+	/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
+	struct cxl_mbox_identify {
+		char fw_revision[0x10];
+		__le64 total_capacity;
+		__le64 volatile_capacity;
+		__le64 persistent_capacity;
+		__le64 partition_align;
+		__le16 info_event_log_size;
+		__le16 warning_event_log_size;
+		__le16 failure_event_log_size;
+		__le16 fatal_event_log_size;
+		__le32 lsa_size;
+		u8 poison_list_max_mer[3];
+		__le16 inject_poison_limit;
+		u8 poison_caps;
+		u8 qos_telemetry_caps;
+	} __packed id;
+	int rc;
+
+	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_IDENTIFY, NULL, 0, &id,
+				   sizeof(id));
+	if (rc < 0)
+		return rc;
+
+	cxlm->total_bytes =
+		le64_to_cpu(id.total_capacity) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->volatile_only_bytes =
+		le64_to_cpu(id.volatile_capacity) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->persistent_only_bytes =
+		le64_to_cpu(id.persistent_capacity) * CXL_CAPACITY_MULTIPLIER;
+	cxlm->partition_align_bytes =
+		le64_to_cpu(id.partition_align) * CXL_CAPACITY_MULTIPLIER;
+
+	dev_dbg(cxlm->dev,
+		"Identify Memory Device\n"
+		"     total_bytes = %#llx\n"
+		"     volatile_only_bytes = %#llx\n"
+		"     persistent_only_bytes = %#llx\n"
+		"     partition_align_bytes = %#llx\n",
+		cxlm->total_bytes, cxlm->volatile_only_bytes,
+		cxlm->persistent_only_bytes, cxlm->partition_align_bytes);
+
+	cxlm->lsa_size = le32_to_cpu(id.lsa_size);
+	memcpy(cxlm->firmware_version, id.fw_revision, sizeof(id.fw_revision));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_mem_identify);
+
+int cxl_mem_create_range_info(struct cxl_mem *cxlm)
+{
+	int rc;
+
+	if (cxlm->partition_align_bytes == 0) {
+		cxlm->ram_range.start = 0;
+		cxlm->ram_range.end = cxlm->volatile_only_bytes - 1;
+		cxlm->pmem_range.start = cxlm->volatile_only_bytes;
+		cxlm->pmem_range.end = cxlm->volatile_only_bytes +
+				       cxlm->persistent_only_bytes - 1;
+		return 0;
+	}
+
+	rc = cxl_mem_get_partition_info(cxlm);
+	if (rc) {
+		dev_err(cxlm->dev, "Failed to query partition information\n");
+		return rc;
+	}
+
+	dev_dbg(cxlm->dev,
+		"Get Partition Info\n"
+		"     active_volatile_bytes = %#llx\n"
+		"     active_persistent_bytes = %#llx\n"
+		"     next_volatile_bytes = %#llx\n"
+		"     next_persistent_bytes = %#llx\n",
+		cxlm->active_volatile_bytes, cxlm->active_persistent_bytes,
+		cxlm->next_volatile_bytes, cxlm->next_persistent_bytes);
+
+	cxlm->ram_range.start = 0;
+	cxlm->ram_range.end = cxlm->active_volatile_bytes - 1;
+
+	cxlm->pmem_range.start = cxlm->active_volatile_bytes;
+	cxlm->pmem_range.end =
+		cxlm->active_volatile_bytes + cxlm->active_persistent_bytes - 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_mem_create_range_info);
+
+struct cxl_mem *cxl_mem_create(struct device *dev)
+{
+	struct cxl_mem *cxlm;
+
+	cxlm = devm_kzalloc(dev, sizeof(*cxlm), GFP_KERNEL);
+	if (!cxlm)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&cxlm->mbox_mutex);
+	cxlm->dev = dev;
+	cxlm->enabled_cmds =
+		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
+				   sizeof(unsigned long),
+				   GFP_KERNEL | __GFP_ZERO);
+	if (!cxlm->enabled_cmds)
+		return ERR_PTR(-ENOMEM);
+
+	return cxlm;
+}
+EXPORT_SYMBOL_GPL(cxl_mem_create);
+
+static struct dentry *cxl_debugfs;
+
+void __init cxl_mbox_init(void)
+{
+	struct dentry *mbox_debugfs;
+
+	cxl_debugfs = debugfs_create_dir("cxl", NULL);
+	mbox_debugfs = debugfs_create_dir("mbox", cxl_debugfs);
+	debugfs_create_bool("raw_allow_all", 0600, mbox_debugfs,
+			    &cxl_raw_allow_all);
+}
+
+void cxl_mbox_exit(void)
+{
+	debugfs_remove_recursive(cxl_debugfs);
+}
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 40789558f8c2..a2a9691568af 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -8,6 +8,8 @@
 #include <cxlmem.h>
 #include "core.h"
 
+static DECLARE_RWSEM(cxl_memdev_rwsem);
+
 /*
  * An entire PCI topology full of devices should be enough for any
  * config
@@ -132,16 +134,21 @@ static const struct device_type cxl_memdev_type = {
 	.groups = cxl_memdev_attribute_groups,
 };
 
+static void cxl_memdev_shutdown(struct device *dev)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+
+	down_write(&cxl_memdev_rwsem);
+	cxlmd->cxlm = NULL;
+	up_write(&cxl_memdev_rwsem);
+}
+
 static void cxl_memdev_unregister(void *_cxlmd)
 {
 	struct cxl_memdev *cxlmd = _cxlmd;
 	struct device *dev = &cxlmd->dev;
-	struct cdev *cdev = &cxlmd->cdev;
-	const struct cdevm_file_operations *cdevm_fops;
-
-	cdevm_fops = container_of(cdev->ops, typeof(*cdevm_fops), fops);
-	cdevm_fops->shutdown(dev);
 
+	cxl_memdev_shutdown(dev);
 	cdev_device_del(&cxlmd->cdev, dev);
 	put_device(dev);
 }
@@ -180,16 +187,72 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
 	return ERR_PTR(rc);
 }
 
+static long __cxl_memdev_ioctl(struct cxl_memdev *cxlmd, unsigned int cmd,
+			       unsigned long arg)
+{
+	switch (cmd) {
+	case CXL_MEM_QUERY_COMMANDS:
+		return cxl_query_cmd(cxlmd, (void __user *)arg);
+	case CXL_MEM_SEND_COMMAND:
+		return cxl_send_cmd(cxlmd, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static long cxl_memdev_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct cxl_memdev *cxlmd = file->private_data;
+	int rc = -ENXIO;
+
+	down_read(&cxl_memdev_rwsem);
+	if (cxlmd->cxlm)
+		rc = __cxl_memdev_ioctl(cxlmd, cmd, arg);
+	up_read(&cxl_memdev_rwsem);
+
+	return rc;
+}
+
+static int cxl_memdev_open(struct inode *inode, struct file *file)
+{
+	struct cxl_memdev *cxlmd =
+		container_of(inode->i_cdev, typeof(*cxlmd), cdev);
+
+	get_device(&cxlmd->dev);
+	file->private_data = cxlmd;
+
+	return 0;
+}
+
+static int cxl_memdev_release_file(struct inode *inode, struct file *file)
+{
+	struct cxl_memdev *cxlmd =
+		container_of(inode->i_cdev, typeof(*cxlmd), cdev);
+
+	put_device(&cxlmd->dev);
+
+	return 0;
+}
+
+static const struct file_operations cxl_memdev_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = cxl_memdev_ioctl,
+	.open = cxl_memdev_open,
+	.release = cxl_memdev_release_file,
+	.compat_ioctl = compat_ptr_ioctl,
+	.llseek = noop_llseek,
+};
+
 struct cxl_memdev *
-devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
-		    const struct cdevm_file_operations *cdevm_fops)
+devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm)
 {
 	struct cxl_memdev *cxlmd;
 	struct device *dev;
 	struct cdev *cdev;
 	int rc;
 
-	cxlmd = cxl_memdev_alloc(cxlm, &cdevm_fops->fops);
+	cxlmd = cxl_memdev_alloc(cxlm, &cxl_memdev_fops);
 	if (IS_ERR(cxlmd))
 		return cxlmd;
 
@@ -219,7 +282,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
 	 * The cdev was briefly live, shutdown any ioctl operations that
 	 * saw that state.
 	 */
-	cdevm_fops->shutdown(dev);
+	cxl_memdev_shutdown(dev);
 	put_device(dev);
 	return ERR_PTR(rc);
 }
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index a56d8f26a157..b7122ded3a04 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020-2021 Intel Corporation. */
 #ifndef __CXL_MEM_H__
 #define __CXL_MEM_H__
+#include <uapi/linux/cxl_mem.h>
 #include <linux/cdev.h>
 #include "cxl.h"
 
@@ -28,21 +29,6 @@
 	(FIELD_GET(CXLMDEV_RESET_NEEDED_MASK, status) !=                       \
 	 CXLMDEV_RESET_NEEDED_NOT)
 
-/**
- * struct cdevm_file_operations - devm coordinated cdev file operations
- * @fops: file operations that are synchronized against @shutdown
- * @shutdown: disconnect driver data
- *
- * @shutdown is invoked in the devres release path to disconnect any
- * driver instance data from @dev. It assumes synchronization with any
- * fops operation that requires driver data. After @shutdown an
- * operation may only reference @device data.
- */
-struct cdevm_file_operations {
-	struct file_operations fops;
-	void (*shutdown)(struct device *dev);
-};
-
 /**
  * struct cxl_memdev - CXL bus object representing a Type-3 Memory Device
  * @dev: driver core device object
@@ -62,12 +48,11 @@ static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
 	return container_of(dev, struct cxl_memdev, dev);
 }
 
-struct cxl_memdev *
-devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
-		    const struct cdevm_file_operations *cdevm_fops);
+struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
+				       struct cxl_mem *cxlm);
 
 /**
- * struct mbox_cmd - A command to be submitted to hardware.
+ * struct cxl_mbox_cmd - A command to be submitted to hardware.
  * @opcode: (input) The command set and command submitted to hardware.
  * @payload_in: (input) Pointer to the input payload.
  * @payload_out: (output) Pointer to the output payload. Must be allocated by
@@ -147,4 +132,62 @@ struct cxl_mem {
 
 	int (*mbox_send)(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd);
 };
+
+enum cxl_opcode {
+	CXL_MBOX_OP_INVALID		= 0x0000,
+	CXL_MBOX_OP_RAW			= CXL_MBOX_OP_INVALID,
+	CXL_MBOX_OP_GET_FW_INFO		= 0x0200,
+	CXL_MBOX_OP_ACTIVATE_FW		= 0x0202,
+	CXL_MBOX_OP_GET_SUPPORTED_LOGS	= 0x0400,
+	CXL_MBOX_OP_GET_LOG		= 0x0401,
+	CXL_MBOX_OP_IDENTIFY		= 0x4000,
+	CXL_MBOX_OP_GET_PARTITION_INFO	= 0x4100,
+	CXL_MBOX_OP_SET_PARTITION_INFO	= 0x4101,
+	CXL_MBOX_OP_GET_LSA		= 0x4102,
+	CXL_MBOX_OP_SET_LSA		= 0x4103,
+	CXL_MBOX_OP_GET_HEALTH_INFO	= 0x4200,
+	CXL_MBOX_OP_GET_ALERT_CONFIG	= 0x4201,
+	CXL_MBOX_OP_SET_ALERT_CONFIG	= 0x4202,
+	CXL_MBOX_OP_GET_SHUTDOWN_STATE	= 0x4203,
+	CXL_MBOX_OP_SET_SHUTDOWN_STATE	= 0x4204,
+	CXL_MBOX_OP_GET_POISON		= 0x4300,
+	CXL_MBOX_OP_INJECT_POISON	= 0x4301,
+	CXL_MBOX_OP_CLEAR_POISON	= 0x4302,
+	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
+	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
+	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
+	CXL_MBOX_OP_MAX			= 0x10000
+};
+
+/**
+ * struct cxl_mem_command - Driver representation of a memory device command
+ * @info: Command information as it exists for the UAPI
+ * @opcode: The actual bits used for the mailbox protocol
+ * @flags: Set of flags effecting driver behavior.
+ *
+ *  * %CXL_CMD_FLAG_FORCE_ENABLE: In cases of error, commands with this flag
+ *    will be enabled by the driver regardless of what hardware may have
+ *    advertised.
+ *
+ * The cxl_mem_command is the driver's internal representation of commands that
+ * are supported by the driver. Some of these commands may not be supported by
+ * the hardware. The driver will use @info to validate the fields passed in by
+ * the user then submit the @opcode to the hardware.
+ *
+ * See struct cxl_command_info.
+ */
+struct cxl_mem_command {
+	struct cxl_command_info info;
+	enum cxl_opcode opcode;
+	u32 flags;
+#define CXL_CMD_FLAG_NONE 0
+#define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
+};
+
+int cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm, u16 opcode, void *in,
+			  size_t in_size, void *out, size_t out_size);
+int cxl_mem_identify(struct cxl_mem *cxlm);
+int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm);
+int cxl_mem_create_range_info(struct cxl_mem *cxlm);
+struct cxl_mem *cxl_mem_create(struct device *dev);
 #endif /* __CXL_MEM_H__ */
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index a211b35af4be..b8075b941a3a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1,17 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
-#include <uapi/linux/cxl_mem.h>
-#include <linux/security.h>
-#include <linux/debugfs.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <linux/cdev.h>
-#include <linux/idr.h>
 #include <linux/pci.h>
 #include <linux/io.h>
-#include <linux/io-64-nonatomic-lo-hi.h>
 #include "cxlmem.h"
 #include "pci.h"
 #include "cxl.h"
@@ -38,162 +33,6 @@
 /* CXL 2.0 - 8.2.8.4 */
 #define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)
 
-enum opcode {
-	CXL_MBOX_OP_INVALID		= 0x0000,
-	CXL_MBOX_OP_RAW			= CXL_MBOX_OP_INVALID,
-	CXL_MBOX_OP_GET_FW_INFO		= 0x0200,
-	CXL_MBOX_OP_ACTIVATE_FW		= 0x0202,
-	CXL_MBOX_OP_GET_SUPPORTED_LOGS	= 0x0400,
-	CXL_MBOX_OP_GET_LOG		= 0x0401,
-	CXL_MBOX_OP_IDENTIFY		= 0x4000,
-	CXL_MBOX_OP_GET_PARTITION_INFO	= 0x4100,
-	CXL_MBOX_OP_SET_PARTITION_INFO	= 0x4101,
-	CXL_MBOX_OP_GET_LSA		= 0x4102,
-	CXL_MBOX_OP_SET_LSA		= 0x4103,
-	CXL_MBOX_OP_GET_HEALTH_INFO	= 0x4200,
-	CXL_MBOX_OP_GET_ALERT_CONFIG	= 0x4201,
-	CXL_MBOX_OP_SET_ALERT_CONFIG	= 0x4202,
-	CXL_MBOX_OP_GET_SHUTDOWN_STATE	= 0x4203,
-	CXL_MBOX_OP_SET_SHUTDOWN_STATE	= 0x4204,
-	CXL_MBOX_OP_GET_POISON		= 0x4300,
-	CXL_MBOX_OP_INJECT_POISON	= 0x4301,
-	CXL_MBOX_OP_CLEAR_POISON	= 0x4302,
-	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
-	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
-	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
-	CXL_MBOX_OP_MAX			= 0x10000
-};
-
-static DECLARE_RWSEM(cxl_memdev_rwsem);
-static struct dentry *cxl_debugfs;
-static bool cxl_raw_allow_all;
-
-enum {
-	CEL_UUID,
-	VENDOR_DEBUG_UUID,
-};
-
-/* See CXL 2.0 Table 170. Get Log Input Payload */
-static const uuid_t log_uuid[] = {
-	[CEL_UUID] = UUID_INIT(0xda9c0b5, 0xbf41, 0x4b78, 0x8f, 0x79, 0x96,
-			       0xb1, 0x62, 0x3b, 0x3f, 0x17),
-	[VENDOR_DEBUG_UUID] = UUID_INIT(0xe1819d9, 0x11a9, 0x400c, 0x81, 0x1f,
-					0xd6, 0x07, 0x19, 0x40, 0x3d, 0x86),
-};
-
-/**
- * struct cxl_mem_command - Driver representation of a memory device command
- * @info: Command information as it exists for the UAPI
- * @opcode: The actual bits used for the mailbox protocol
- * @flags: Set of flags effecting driver behavior.
- *
- *  * %CXL_CMD_FLAG_FORCE_ENABLE: In cases of error, commands with this flag
- *    will be enabled by the driver regardless of what hardware may have
- *    advertised.
- *
- * The cxl_mem_command is the driver's internal representation of commands that
- * are supported by the driver. Some of these commands may not be supported by
- * the hardware. The driver will use @info to validate the fields passed in by
- * the user then submit the @opcode to the hardware.
- *
- * See struct cxl_command_info.
- */
-struct cxl_mem_command {
-	struct cxl_command_info info;
-	enum opcode opcode;
-	u32 flags;
-#define CXL_CMD_FLAG_NONE 0
-#define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
-};
-
-#define CXL_CMD(_id, sin, sout, _flags)                                        \
-	[CXL_MEM_COMMAND_ID_##_id] = {                                         \
-	.info =	{                                                              \
-			.id = CXL_MEM_COMMAND_ID_##_id,                        \
-			.size_in = sin,                                        \
-			.size_out = sout,                                      \
-		},                                                             \
-	.opcode = CXL_MBOX_OP_##_id,                                           \
-	.flags = _flags,                                                       \
-	}
-
-/*
- * This table defines the supported mailbox commands for the driver. This table
- * is made up of a UAPI structure. Non-negative values as parameters in the
- * table will be validated against the user's input. For example, if size_in is
- * 0, and the user passed in 1, it is an error.
- */
-static struct cxl_mem_command mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
-	CXL_CMD(IDENTIFY, 0, 0x43, CXL_CMD_FLAG_FORCE_ENABLE),
-#ifdef CONFIG_CXL_MEM_RAW_COMMANDS
-	CXL_CMD(RAW, ~0, ~0, 0),
-#endif
-	CXL_CMD(GET_SUPPORTED_LOGS, 0, ~0, CXL_CMD_FLAG_FORCE_ENABLE),
-	CXL_CMD(GET_FW_INFO, 0, 0x50, 0),
-	CXL_CMD(GET_PARTITION_INFO, 0, 0x20, 0),
-	CXL_CMD(GET_LSA, 0x8, ~0, 0),
-	CXL_CMD(GET_HEALTH_INFO, 0, 0x12, 0),
-	CXL_CMD(GET_LOG, 0x18, ~0, CXL_CMD_FLAG_FORCE_ENABLE),
-	CXL_CMD(SET_PARTITION_INFO, 0x0a, 0, 0),
-	CXL_CMD(SET_LSA, ~0, 0, 0),
-	CXL_CMD(GET_ALERT_CONFIG, 0, 0x10, 0),
-	CXL_CMD(SET_ALERT_CONFIG, 0xc, 0, 0),
-	CXL_CMD(GET_SHUTDOWN_STATE, 0, 0x1, 0),
-	CXL_CMD(SET_SHUTDOWN_STATE, 0x1, 0, 0),
-	CXL_CMD(GET_POISON, 0x10, ~0, 0),
-	CXL_CMD(INJECT_POISON, 0x8, 0, 0),
-	CXL_CMD(CLEAR_POISON, 0x48, 0, 0),
-	CXL_CMD(GET_SCAN_MEDIA_CAPS, 0x10, 0x4, 0),
-	CXL_CMD(SCAN_MEDIA, 0x11, 0, 0),
-	CXL_CMD(GET_SCAN_MEDIA, 0, ~0, 0),
-};
-
-/*
- * Commands that RAW doesn't permit. The rationale for each:
- *
- * CXL_MBOX_OP_ACTIVATE_FW: Firmware activation requires adjustment /
- * coordination of transaction timeout values at the root bridge level.
- *
- * CXL_MBOX_OP_SET_PARTITION_INFO: The device memory map may change live
- * and needs to be coordinated with HDM updates.
- *
- * CXL_MBOX_OP_SET_LSA: The label storage area may be cached by the
- * driver and any writes from userspace invalidates those contents.
- *
- * CXL_MBOX_OP_SET_SHUTDOWN_STATE: Set shutdown state assumes no writes
- * to the device after it is marked clean, userspace can not make that
- * assertion.
- *
- * CXL_MBOX_OP_[GET_]SCAN_MEDIA: The kernel provides a native error list that
- * is kept up to date with patrol notifications and error management.
- */
-static u16 cxl_disabled_raw_commands[] = {
-	CXL_MBOX_OP_ACTIVATE_FW,
-	CXL_MBOX_OP_SET_PARTITION_INFO,
-	CXL_MBOX_OP_SET_LSA,
-	CXL_MBOX_OP_SET_SHUTDOWN_STATE,
-	CXL_MBOX_OP_SCAN_MEDIA,
-	CXL_MBOX_OP_GET_SCAN_MEDIA,
-};
-
-/*
- * Command sets that RAW doesn't permit. All opcodes in this set are
- * disabled because they pass plain text security payloads over the
- * user/kernel boundary. This functionality is intended to be wrapped
- * behind the keys ABI which allows for encrypted payloads in the UAPI
- */
-static u8 security_command_sets[] = {
-	0x44, /* Sanitize */
-	0x45, /* Persistent Memory Data-at-rest Security */
-	0x46, /* Security Passthrough */
-};
-
-#define cxl_for_each_cmd(cmd)                                                  \
-	for ((cmd) = &mem_commands[0];                                         \
-	     ((cmd) - mem_commands) < ARRAY_SIZE(mem_commands); (cmd)++)
-
-#define cxl_cmd_count ARRAY_SIZE(mem_commands)
-
 static int cxl_mem_wait_for_doorbell(struct cxl_mem *cxlm)
 {
 	const unsigned long start = jiffies;
@@ -216,16 +55,6 @@ static int cxl_mem_wait_for_doorbell(struct cxl_mem *cxlm)
 	return 0;
 }
 
-static bool cxl_is_security_command(u16 opcode)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(security_command_sets); i++)
-		if (security_command_sets[i] == (opcode >> 8))
-			return true;
-	return false;
-}
-
 static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
 				 struct cxl_mbox_cmd *mbox_cmd)
 {
@@ -447,433 +276,6 @@ static int cxl_pci_mbox_send(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd)
 	return rc;
 }
 
-/**
- * handle_mailbox_cmd_from_user() - Dispatch a mailbox command for userspace.
- * @cxlm: The CXL memory device to communicate with.
- * @cmd: The validated command.
- * @in_payload: Pointer to userspace's input payload.
- * @out_payload: Pointer to userspace's output payload.
- * @size_out: (Input) Max payload size to copy out.
- *            (Output) Payload size hardware generated.
- * @retval: Hardware generated return code from the operation.
- *
- * Return:
- *  * %0	- Mailbox transaction succeeded. This implies the mailbox
- *		  protocol completed successfully not that the operation itself
- *		  was successful.
- *  * %-ENOMEM  - Couldn't allocate a bounce buffer.
- *  * %-EFAULT	- Something happened with copy_to/from_user.
- *  * %-EINTR	- Mailbox acquisition interrupted.
- *  * %-EXXX	- Transaction level failures.
- *
- * Creates the appropriate mailbox command and dispatches it on behalf of a
- * userspace request. The input and output payloads are copied between
- * userspace.
- *
- * See cxl_send_cmd().
- */
-static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
-					const struct cxl_mem_command *cmd,
-					u64 in_payload, u64 out_payload,
-					s32 *size_out, u32 *retval)
-{
-	struct device *dev = cxlm->dev;
-	struct cxl_mbox_cmd mbox_cmd = {
-		.opcode = cmd->opcode,
-		.size_in = cmd->info.size_in,
-		.size_out = cmd->info.size_out,
-	};
-	int rc;
-
-	if (cmd->info.size_out) {
-		mbox_cmd.payload_out = kvzalloc(cmd->info.size_out, GFP_KERNEL);
-		if (!mbox_cmd.payload_out)
-			return -ENOMEM;
-	}
-
-	if (cmd->info.size_in) {
-		mbox_cmd.payload_in = vmemdup_user(u64_to_user_ptr(in_payload),
-						   cmd->info.size_in);
-		if (IS_ERR(mbox_cmd.payload_in)) {
-			kvfree(mbox_cmd.payload_out);
-			return PTR_ERR(mbox_cmd.payload_in);
-		}
-	}
-
-	dev_dbg(dev,
-		"Submitting %s command for user\n"
-		"\topcode: %x\n"
-		"\tsize: %ub\n",
-		cxl_command_names[cmd->info.id].name, mbox_cmd.opcode,
-		cmd->info.size_in);
-
-	dev_WARN_ONCE(dev, cmd->info.id == CXL_MEM_COMMAND_ID_RAW,
-		      "raw command path used\n");
-
-	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
-	if (rc)
-		goto out;
-
-	/*
-	 * @size_out contains the max size that's allowed to be written back out
-	 * to userspace. While the payload may have written more output than
-	 * this it will have to be ignored.
-	 */
-	if (mbox_cmd.size_out) {
-		dev_WARN_ONCE(dev, mbox_cmd.size_out > *size_out,
-			      "Invalid return size\n");
-		if (copy_to_user(u64_to_user_ptr(out_payload),
-				 mbox_cmd.payload_out, mbox_cmd.size_out)) {
-			rc = -EFAULT;
-			goto out;
-		}
-	}
-
-	*size_out = mbox_cmd.size_out;
-	*retval = mbox_cmd.return_code;
-
-out:
-	kvfree(mbox_cmd.payload_in);
-	kvfree(mbox_cmd.payload_out);
-	return rc;
-}
-
-static bool cxl_mem_raw_command_allowed(u16 opcode)
-{
-	int i;
-
-	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
-		return false;
-
-	if (security_locked_down(LOCKDOWN_NONE))
-		return false;
-
-	if (cxl_raw_allow_all)
-		return true;
-
-	if (cxl_is_security_command(opcode))
-		return false;
-
-	for (i = 0; i < ARRAY_SIZE(cxl_disabled_raw_commands); i++)
-		if (cxl_disabled_raw_commands[i] == opcode)
-			return false;
-
-	return true;
-}
-
-/**
- * cxl_validate_cmd_from_user() - Check fields for CXL_MEM_SEND_COMMAND.
- * @cxlm: &struct cxl_mem device whose mailbox will be used.
- * @send_cmd: &struct cxl_send_command copied in from userspace.
- * @out_cmd: Sanitized and populated &struct cxl_mem_command.
- *
- * Return:
- *  * %0	- @out_cmd is ready to send.
- *  * %-ENOTTY	- Invalid command specified.
- *  * %-EINVAL	- Reserved fields or invalid values were used.
- *  * %-ENOMEM	- Input or output buffer wasn't sized properly.
- *  * %-EPERM	- Attempted to use a protected command.
- *
- * The result of this command is a fully validated command in @out_cmd that is
- * safe to send to the hardware.
- *
- * See handle_mailbox_cmd_from_user()
- */
-static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
-				      const struct cxl_send_command *send_cmd,
-				      struct cxl_mem_command *out_cmd)
-{
-	const struct cxl_command_info *info;
-	struct cxl_mem_command *c;
-
-	if (send_cmd->id == 0 || send_cmd->id >= CXL_MEM_COMMAND_ID_MAX)
-		return -ENOTTY;
-
-	/*
-	 * The user can never specify an input payload larger than what hardware
-	 * supports, but output can be arbitrarily large (simply write out as
-	 * much data as the hardware provides).
-	 */
-	if (send_cmd->in.size > cxlm->payload_size)
-		return -EINVAL;
-
-	/*
-	 * Checks are bypassed for raw commands but a WARN/taint will occur
-	 * later in the callchain
-	 */
-	if (send_cmd->id == CXL_MEM_COMMAND_ID_RAW) {
-		const struct cxl_mem_command temp = {
-			.info = {
-				.id = CXL_MEM_COMMAND_ID_RAW,
-				.flags = 0,
-				.size_in = send_cmd->in.size,
-				.size_out = send_cmd->out.size,
-			},
-			.opcode = send_cmd->raw.opcode
-		};
-
-		if (send_cmd->raw.rsvd)
-			return -EINVAL;
-
-		/*
-		 * Unlike supported commands, the output size of RAW commands
-		 * gets passed along without further checking, so it must be
-		 * validated here.
-		 */
-		if (send_cmd->out.size > cxlm->payload_size)
-			return -EINVAL;
-
-		if (!cxl_mem_raw_command_allowed(send_cmd->raw.opcode))
-			return -EPERM;
-
-		memcpy(out_cmd, &temp, sizeof(temp));
-
-		return 0;
-	}
-
-	if (send_cmd->flags & ~CXL_MEM_COMMAND_FLAG_MASK)
-		return -EINVAL;
-
-	if (send_cmd->rsvd)
-		return -EINVAL;
-
-	if (send_cmd->in.rsvd || send_cmd->out.rsvd)
-		return -EINVAL;
-
-	/* Convert user's command into the internal representation */
-	c = &mem_commands[send_cmd->id];
-	info = &c->info;
-
-	/* Check that the command is enabled for hardware */
-	if (!test_bit(info->id, cxlm->enabled_cmds))
-		return -ENOTTY;
-
-	/* Check the input buffer is the expected size */
-	if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
-		return -ENOMEM;
-
-	/* Check the output buffer is at least large enough */
-	if (info->size_out >= 0 && send_cmd->out.size < info->size_out)
-		return -ENOMEM;
-
-	memcpy(out_cmd, c, sizeof(*c));
-	out_cmd->info.size_in = send_cmd->in.size;
-	/*
-	 * XXX: out_cmd->info.size_out will be controlled by the driver, and the
-	 * specified number of bytes @send_cmd->out.size will be copied back out
-	 * to userspace.
-	 */
-
-	return 0;
-}
-
-static int cxl_query_cmd(struct cxl_memdev *cxlmd,
-			 struct cxl_mem_query_commands __user *q)
-{
-	struct device *dev = &cxlmd->dev;
-	struct cxl_mem_command *cmd;
-	u32 n_commands;
-	int j = 0;
-
-	dev_dbg(dev, "Query IOCTL\n");
-
-	if (get_user(n_commands, &q->n_commands))
-		return -EFAULT;
-
-	/* returns the total number if 0 elements are requested. */
-	if (n_commands == 0)
-		return put_user(cxl_cmd_count, &q->n_commands);
-
-	/*
-	 * otherwise, return max(n_commands, total commands) cxl_command_info
-	 * structures.
-	 */
-	cxl_for_each_cmd(cmd) {
-		const struct cxl_command_info *info = &cmd->info;
-
-		if (copy_to_user(&q->commands[j++], info, sizeof(*info)))
-			return -EFAULT;
-
-		if (j == n_commands)
-			break;
-	}
-
-	return 0;
-}
-
-static int cxl_send_cmd(struct cxl_memdev *cxlmd,
-			struct cxl_send_command __user *s)
-{
-	struct cxl_mem *cxlm = cxlmd->cxlm;
-	struct device *dev = &cxlmd->dev;
-	struct cxl_send_command send;
-	struct cxl_mem_command c;
-	int rc;
-
-	dev_dbg(dev, "Send IOCTL\n");
-
-	if (copy_from_user(&send, s, sizeof(send)))
-		return -EFAULT;
-
-	rc = cxl_validate_cmd_from_user(cxlmd->cxlm, &send, &c);
-	if (rc)
-		return rc;
-
-	/* Prepare to handle a full payload for variable sized output */
-	if (c.info.size_out < 0)
-		c.info.size_out = cxlm->payload_size;
-
-	rc = handle_mailbox_cmd_from_user(cxlm, &c, send.in.payload,
-					  send.out.payload, &send.out.size,
-					  &send.retval);
-	if (rc)
-		return rc;
-
-	if (copy_to_user(s, &send, sizeof(send)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static long __cxl_memdev_ioctl(struct cxl_memdev *cxlmd, unsigned int cmd,
-			       unsigned long arg)
-{
-	switch (cmd) {
-	case CXL_MEM_QUERY_COMMANDS:
-		return cxl_query_cmd(cxlmd, (void __user *)arg);
-	case CXL_MEM_SEND_COMMAND:
-		return cxl_send_cmd(cxlmd, (void __user *)arg);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static long cxl_memdev_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
-{
-	struct cxl_memdev *cxlmd = file->private_data;
-	int rc = -ENXIO;
-
-	down_read(&cxl_memdev_rwsem);
-	if (cxlmd->cxlm)
-		rc = __cxl_memdev_ioctl(cxlmd, cmd, arg);
-	up_read(&cxl_memdev_rwsem);
-
-	return rc;
-}
-
-static int cxl_memdev_open(struct inode *inode, struct file *file)
-{
-	struct cxl_memdev *cxlmd =
-		container_of(inode->i_cdev, typeof(*cxlmd), cdev);
-
-	get_device(&cxlmd->dev);
-	file->private_data = cxlmd;
-
-	return 0;
-}
-
-static int cxl_memdev_release_file(struct inode *inode, struct file *file)
-{
-	struct cxl_memdev *cxlmd =
-		container_of(inode->i_cdev, typeof(*cxlmd), cdev);
-
-	put_device(&cxlmd->dev);
-
-	return 0;
-}
-
-static void cxl_memdev_shutdown(struct device *dev)
-{
-	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-
-	down_write(&cxl_memdev_rwsem);
-	cxlmd->cxlm = NULL;
-	up_write(&cxl_memdev_rwsem);
-}
-
-static const struct cdevm_file_operations cxl_memdev_fops = {
-	.fops = {
-		.owner = THIS_MODULE,
-		.unlocked_ioctl = cxl_memdev_ioctl,
-		.open = cxl_memdev_open,
-		.release = cxl_memdev_release_file,
-		.compat_ioctl = compat_ptr_ioctl,
-		.llseek = noop_llseek,
-	},
-	.shutdown = cxl_memdev_shutdown,
-};
-
-static inline struct cxl_mem_command *cxl_mem_find_command(u16 opcode)
-{
-	struct cxl_mem_command *c;
-
-	cxl_for_each_cmd(c)
-		if (c->opcode == opcode)
-			return c;
-
-	return NULL;
-}
-
-/**
- * cxl_mem_mbox_send_cmd() - Send a mailbox command to a memory device.
- * @cxlm: The CXL memory device to communicate with.
- * @opcode: Opcode for the mailbox command.
- * @in: The input payload for the mailbox command.
- * @in_size: The length of the input payload
- * @out: Caller allocated buffer for the output.
- * @out_size: Expected size of output.
- *
- * Context: Any context. Will acquire and release mbox_mutex.
- * Return:
- *  * %>=0	- Number of bytes returned in @out.
- *  * %-E2BIG	- Payload is too large for hardware.
- *  * %-EBUSY	- Couldn't acquire exclusive mailbox access.
- *  * %-EFAULT	- Hardware error occurred.
- *  * %-ENXIO	- Command completed, but device reported an error.
- *  * %-EIO	- Unexpected output size.
- *
- * Mailbox commands may execute successfully yet the device itself reported an
- * error. While this distinction can be useful for commands from userspace, the
- * kernel will only be able to use results when both are successful.
- *
- * See __cxl_mem_mbox_send_cmd()
- */
-static int cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm, u16 opcode,
-				 void *in, size_t in_size,
-				 void *out, size_t out_size)
-{
-	const struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
-	struct cxl_mbox_cmd mbox_cmd = {
-		.opcode = opcode,
-		.payload_in = in,
-		.size_in = in_size,
-		.size_out = out_size,
-		.payload_out = out,
-	};
-	int rc;
-
-	if (out_size > cxlm->payload_size)
-		return -E2BIG;
-
-	rc = cxlm->mbox_send(cxlm, &mbox_cmd);
-	if (rc)
-		return rc;
-
-	/* TODO: Map return code to proper kernel style errno */
-	if (mbox_cmd.return_code != CXL_MBOX_SUCCESS)
-		return -ENXIO;
-
-	/*
-	 * Variable sized commands can't be validated and so it's up to the
-	 * caller to do that if they wish.
-	 */
-	if (cmd->info.size_out >= 0 && mbox_cmd.size_out != out_size)
-		return -EIO;
-
-	return 0;
-}
-
 static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
 {
 	const int cap = readl(cxlm->regs.mbox + CXLDEV_MBOX_CAPS_OFFSET);
@@ -902,31 +304,6 @@ static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
 	return 0;
 }
 
-static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct cxl_mem *cxlm;
-
-	cxlm = devm_kzalloc(dev, sizeof(*cxlm), GFP_KERNEL);
-	if (!cxlm) {
-		dev_err(dev, "No memory available\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	mutex_init(&cxlm->mbox_mutex);
-	cxlm->dev = dev;
-	cxlm->enabled_cmds =
-		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
-				   sizeof(unsigned long),
-				   GFP_KERNEL | __GFP_ZERO);
-	if (!cxlm->enabled_cmds) {
-		dev_err(dev, "No memory available for bitmap\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	return cxlm;
-}
-
 static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
 					  u8 bar, u64 offset)
 {
@@ -1136,311 +513,6 @@ static int cxl_mem_setup_regs(struct cxl_mem *cxlm)
 	return ret;
 }
 
-static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
-{
-	u32 remaining = size;
-	u32 offset = 0;
-
-	while (remaining) {
-		u32 xfer_size = min_t(u32, remaining, cxlm->payload_size);
-		struct cxl_mbox_get_log {
-			uuid_t uuid;
-			__le32 offset;
-			__le32 length;
-		} __packed log = {
-			.uuid = *uuid,
-			.offset = cpu_to_le32(offset),
-			.length = cpu_to_le32(xfer_size)
-		};
-		int rc;
-
-		rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_LOG, &log,
-					   sizeof(log), out, xfer_size);
-		if (rc < 0)
-			return rc;
-
-		out += xfer_size;
-		remaining -= xfer_size;
-		offset += xfer_size;
-	}
-
-	return 0;
-}
-
-/**
- * cxl_walk_cel() - Walk through the Command Effects Log.
- * @cxlm: Device.
- * @size: Length of the Command Effects Log.
- * @cel: CEL
- *
- * Iterate over each entry in the CEL and determine if the driver supports the
- * command. If so, the command is enabled for the device and can be used later.
- */
-static void cxl_walk_cel(struct cxl_mem *cxlm, size_t size, u8 *cel)
-{
-	struct cel_entry {
-		__le16 opcode;
-		__le16 effect;
-	} __packed * cel_entry;
-	const int cel_entries = size / sizeof(*cel_entry);
-	int i;
-
-	cel_entry = (struct cel_entry *)cel;
-
-	for (i = 0; i < cel_entries; i++) {
-		u16 opcode = le16_to_cpu(cel_entry[i].opcode);
-		struct cxl_mem_command *cmd = cxl_mem_find_command(opcode);
-
-		if (!cmd) {
-			dev_dbg(cxlm->dev,
-				"Opcode 0x%04x unsupported by driver", opcode);
-			continue;
-		}
-
-		set_bit(cmd->info.id, cxlm->enabled_cmds);
-	}
-}
-
-struct cxl_mbox_get_supported_logs {
-	__le16 entries;
-	u8 rsvd[6];
-	struct gsl_entry {
-		uuid_t uuid;
-		__le32 size;
-	} __packed entry[];
-} __packed;
-
-static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_mem *cxlm)
-{
-	struct cxl_mbox_get_supported_logs *ret;
-	int rc;
-
-	ret = kvmalloc(cxlm->payload_size, GFP_KERNEL);
-	if (!ret)
-		return ERR_PTR(-ENOMEM);
-
-	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_SUPPORTED_LOGS, NULL,
-				   0, ret, cxlm->payload_size);
-	if (rc < 0) {
-		kvfree(ret);
-		return ERR_PTR(rc);
-	}
-
-	return ret;
-}
-
-/**
- * cxl_mem_get_partition_info - Get partition info
- * @cxlm: The device to act on
- * @active_volatile_bytes: returned active volatile capacity
- * @active_persistent_bytes: returned active persistent capacity
- * @next_volatile_bytes: return next volatile capacity
- * @next_persistent_bytes: return next persistent capacity
- *
- * Retrieve the current partition info for the device specified.  If not 0, the
- * 'next' values are pending and take affect on next cold reset.
- *
- * Return: 0 if no error: or the result of the mailbox command.
- *
- * See CXL @8.2.9.5.2.1 Get Partition Info
- */
-static int cxl_mem_get_partition_info(struct cxl_mem *cxlm,
-				      u64 *active_volatile_bytes,
-				      u64 *active_persistent_bytes,
-				      u64 *next_volatile_bytes,
-				      u64 *next_persistent_bytes)
-{
-	struct cxl_mbox_get_partition_info {
-		__le64 active_volatile_cap;
-		__le64 active_persistent_cap;
-		__le64 next_volatile_cap;
-		__le64 next_persistent_cap;
-	} __packed pi;
-	int rc;
-
-	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_PARTITION_INFO,
-				   NULL, 0, &pi, sizeof(pi));
-	if (rc)
-		return rc;
-
-	*active_volatile_bytes = le64_to_cpu(pi.active_volatile_cap);
-	*active_persistent_bytes = le64_to_cpu(pi.active_persistent_cap);
-	*next_volatile_bytes = le64_to_cpu(pi.next_volatile_cap);
-	*next_persistent_bytes = le64_to_cpu(pi.next_volatile_cap);
-
-	*active_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*active_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_volatile_bytes *= CXL_CAPACITY_MULTIPLIER;
-	*next_persistent_bytes *= CXL_CAPACITY_MULTIPLIER;
-
-	return 0;
-}
-
-/**
- * cxl_mem_enumerate_cmds() - Enumerate commands for a device.
- * @cxlm: The device.
- *
- * Returns 0 if enumerate completed successfully.
- *
- * CXL devices have optional support for certain commands. This function will
- * determine the set of supported commands for the hardware and update the
- * enabled_cmds bitmap in the @cxlm.
- */
-static int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm)
-{
-	struct cxl_mbox_get_supported_logs *gsl;
-	struct device *dev = cxlm->dev;
-	struct cxl_mem_command *cmd;
-	int i, rc;
-
-	gsl = cxl_get_gsl(cxlm);
-	if (IS_ERR(gsl))
-		return PTR_ERR(gsl);
-
-	rc = -ENOENT;
-	for (i = 0; i < le16_to_cpu(gsl->entries); i++) {
-		u32 size = le32_to_cpu(gsl->entry[i].size);
-		uuid_t uuid = gsl->entry[i].uuid;
-		u8 *log;
-
-		dev_dbg(dev, "Found LOG type %pU of size %d", &uuid, size);
-
-		if (!uuid_equal(&uuid, &log_uuid[CEL_UUID]))
-			continue;
-
-		log = kvmalloc(size, GFP_KERNEL);
-		if (!log) {
-			rc = -ENOMEM;
-			goto out;
-		}
-
-		rc = cxl_xfer_log(cxlm, &uuid, size, log);
-		if (rc) {
-			kvfree(log);
-			goto out;
-		}
-
-		cxl_walk_cel(cxlm, size, log);
-		kvfree(log);
-
-		/* In case CEL was bogus, enable some default commands. */
-		cxl_for_each_cmd(cmd)
-			if (cmd->flags & CXL_CMD_FLAG_FORCE_ENABLE)
-				set_bit(cmd->info.id, cxlm->enabled_cmds);
-
-		/* Found the required CEL */
-		rc = 0;
-	}
-
-out:
-	kvfree(gsl);
-	return rc;
-}
-
-/**
- * cxl_mem_identify() - Send the IDENTIFY command to the device.
- * @cxlm: The device to identify.
- *
- * Return: 0 if identify was executed successfully.
- *
- * This will dispatch the identify command to the device and on success populate
- * structures to be exported to sysfs.
- */
-static int cxl_mem_identify(struct cxl_mem *cxlm)
-{
-	/* See CXL 2.0 Table 175 Identify Memory Device Output Payload */
-	struct cxl_mbox_identify {
-		char fw_revision[0x10];
-		__le64 total_capacity;
-		__le64 volatile_capacity;
-		__le64 persistent_capacity;
-		__le64 partition_align;
-		__le16 info_event_log_size;
-		__le16 warning_event_log_size;
-		__le16 failure_event_log_size;
-		__le16 fatal_event_log_size;
-		__le32 lsa_size;
-		u8 poison_list_max_mer[3];
-		__le16 inject_poison_limit;
-		u8 poison_caps;
-		u8 qos_telemetry_caps;
-	} __packed id;
-	int rc;
-
-	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_IDENTIFY, NULL, 0, &id,
-				   sizeof(id));
-	if (rc < 0)
-		return rc;
-
-	cxlm->total_bytes = le64_to_cpu(id.total_capacity);
-	cxlm->total_bytes *= CXL_CAPACITY_MULTIPLIER;
-
-	cxlm->volatile_only_bytes = le64_to_cpu(id.volatile_capacity);
-	cxlm->volatile_only_bytes *= CXL_CAPACITY_MULTIPLIER;
-
-	cxlm->persistent_only_bytes = le64_to_cpu(id.persistent_capacity);
-	cxlm->persistent_only_bytes *= CXL_CAPACITY_MULTIPLIER;
-
-	cxlm->partition_align_bytes = le64_to_cpu(id.partition_align);
-	cxlm->partition_align_bytes *= CXL_CAPACITY_MULTIPLIER;
-
-	dev_dbg(cxlm->dev,
-		"Identify Memory Device\n"
-		"     total_bytes = %#llx\n"
-		"     volatile_only_bytes = %#llx\n"
-		"     persistent_only_bytes = %#llx\n"
-		"     partition_align_bytes = %#llx\n",
-		cxlm->total_bytes, cxlm->volatile_only_bytes,
-		cxlm->persistent_only_bytes, cxlm->partition_align_bytes);
-
-	cxlm->lsa_size = le32_to_cpu(id.lsa_size);
-	memcpy(cxlm->firmware_version, id.fw_revision, sizeof(id.fw_revision));
-
-	return 0;
-}
-
-static int cxl_mem_create_range_info(struct cxl_mem *cxlm)
-{
-	int rc;
-
-	if (cxlm->partition_align_bytes == 0) {
-		cxlm->ram_range.start = 0;
-		cxlm->ram_range.end = cxlm->volatile_only_bytes - 1;
-		cxlm->pmem_range.start = cxlm->volatile_only_bytes;
-		cxlm->pmem_range.end = cxlm->volatile_only_bytes +
-					cxlm->persistent_only_bytes - 1;
-		return 0;
-	}
-
-	rc = cxl_mem_get_partition_info(cxlm,
-					&cxlm->active_volatile_bytes,
-					&cxlm->active_persistent_bytes,
-					&cxlm->next_volatile_bytes,
-					&cxlm->next_persistent_bytes);
-	if (rc < 0) {
-		dev_err(cxlm->dev, "Failed to query partition information\n");
-		return rc;
-	}
-
-	dev_dbg(cxlm->dev,
-		"Get Partition Info\n"
-		"     active_volatile_bytes = %#llx\n"
-		"     active_persistent_bytes = %#llx\n"
-		"     next_volatile_bytes = %#llx\n"
-		"     next_persistent_bytes = %#llx\n",
-		cxlm->active_volatile_bytes, cxlm->active_persistent_bytes,
-		cxlm->next_volatile_bytes, cxlm->next_persistent_bytes);
-
-	cxlm->ram_range.start = 0;
-	cxlm->ram_range.end = cxlm->active_volatile_bytes - 1;
-
-	cxlm->pmem_range.start = cxlm->active_volatile_bytes;
-	cxlm->pmem_range.end = cxlm->active_volatile_bytes +
-				cxlm->active_persistent_bytes - 1;
-
-	return 0;
-}
-
 static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct cxl_memdev *cxlmd;
@@ -1451,7 +523,7 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	cxlm = cxl_mem_create(pdev);
+	cxlm = cxl_mem_create(&pdev->dev);
 	if (IS_ERR(cxlm))
 		return PTR_ERR(cxlm);
 
@@ -1475,7 +547,7 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlm, &cxl_memdev_fops);
+	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlm);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
@@ -1503,7 +575,6 @@ static struct pci_driver cxl_mem_driver = {
 
 static __init int cxl_mem_init(void)
 {
-	struct dentry *mbox_debugfs;
 	int rc;
 
 	/* Double check the anonymous union trickery in struct cxl_regs */
@@ -1514,17 +585,11 @@ static __init int cxl_mem_init(void)
 	if (rc)
 		return rc;
 
-	cxl_debugfs = debugfs_create_dir("cxl", NULL);
-	mbox_debugfs = debugfs_create_dir("mbox", cxl_debugfs);
-	debugfs_create_bool("raw_allow_all", 0600, mbox_debugfs,
-			    &cxl_raw_allow_all);
-
 	return 0;
 }
 
 static __exit void cxl_mem_exit(void)
 {
-	debugfs_remove_recursive(cxl_debugfs);
 	pci_unregister_driver(&cxl_mem_driver);
 }
 


