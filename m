Return-Path: <nvdimm+bounces-935-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 3351F3F4184
	for <lists+linux-nvdimm@lfdr.de>; Sun, 22 Aug 2021 22:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 776403E0F62
	for <lists+linux-nvdimm@lfdr.de>; Sun, 22 Aug 2021 20:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71BF3FCF;
	Sun, 22 Aug 2021 20:30:59 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E1D3FC3
	for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 20:30:57 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id k24so14691736pgh.8
        for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 13:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D/kZ7nj5OSKqyqEdhRE0ol6CHYKkXXRPvDyFtr0Z+us=;
        b=gEytaoyVPSWgFbX+IBo2okK7N56FWUYyYe5i3Cg7j1PGaRjfgXAL0l3tbI/cpwFkMl
         7MMzBAPY+g7WgVN7zHve2a6HwYG/tk3aZXULbN/9pRr5QTdXNYUxJUBhIUH/sL+ls8Lp
         1EL8b2VfqkLGZHFQJ5ViEDc9xw2tA2HxHe62pZdi/HS4WCUvA7jBYbprO+whtxnWS3yj
         goAKV95p6BVccwrznp5KznU4Hy3BghUMHvqRqodGtx/jxHflWOYwW1NbS8Qe3vk+3yop
         KnRn9PgZz1dJV4/Aa8ddheQA93mGxUvYbMXK7rFuCFSDuG3528s+e0RAFnXVlk5CvUz+
         QRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/kZ7nj5OSKqyqEdhRE0ol6CHYKkXXRPvDyFtr0Z+us=;
        b=Ao4LfvE6kzyokiY4qjjw4eX/PPY+C/9OUdXzlYYrI6I8fvtxeD99Vg78Y3bGZgwddR
         Q5UujekEJu4aFpZtH8pCbywg0qhdDmP/cbrlq91JnX4lNnCGEhbAJscjqKfSRVY1oZOj
         tVsdx7t4eNwrFs+2dJRl5YlMpIYowX3fK/zmvUE0ZwIG0hwzt6EkR1PAXp+RNnHYZtxK
         WBFqLgPnE2uOi17tS/L84CT0/6FpKuQgPNeM8sMS/0W2Tl4VOuqjUrFsE0OpcWSq95ii
         Euofc4ZIqCI7bRYgLmezvcnXKSGJ7uf8E4iW2QUeav5CAnFsRx5mGlrE91puDv3FmU7X
         XcJw==
X-Gm-Message-State: AOAM532fU1LSuxzZW8BSzGJQDIbi4VmncavER5xw10WhR5kHGiWxwPDj
	eeTdCRlgWrrdBWTAAYkJvxq7KSp7XuEoZg==
X-Google-Smtp-Source: ABdhPJzHsWu3KALLLhClWPJCTDtsWuq4crfsyGe8+oP/dsxVRZve52qnt0fkdDyDRzwVqP/0o3Kr0Q==
X-Received: by 2002:a62:8491:0:b029:3dd:a29a:a1e4 with SMTP id k139-20020a6284910000b02903dda29aa1e4mr30316866pfd.13.1629664256926;
        Sun, 22 Aug 2021 13:30:56 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id n30sm13587804pfv.87.2021.08.22.13.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 13:30:56 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 3/5] ndctl: make ndctl support configuration files
Date: Mon, 23 Aug 2021 05:30:13 +0900
Message-Id: <20210822203015.528438-4-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822203015.528438-1-qi.fuli@fujitsu.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add ndctl_configs to ndctl_ctx for supporting ndctl global configuration
files. All files with .conf suffix under {sysconfdir}/ndctl can be
regarded as global configuration files that all ndctl commands can refer
to. Add ndctl_set_configs() public function for setting ndctl default
configuration files. Add ndctl_get_configs() public function for reading
configuration files from ndctl_ctx.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 configure.ac           |  4 ++--
 ndctl/Makefile.am      |  5 ++--
 ndctl/lib/Makefile.am  |  4 ++++
 ndctl/lib/libndctl.c   | 52 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  2 ++
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  2 ++
 ndctl/ndctl.c          |  1 +
 8 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index dc39dbe..42a66e1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,9 +171,9 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
-ndctl_monitorconfdir=${sysconfdir}/ndctl
+ndctl_confdir=${sysconfdir}/ndctl
 ndctl_monitorconf=monitor.conf
-AC_SUBST([ndctl_monitorconfdir])
+AC_SUBST([ndctl_confdir])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index a63b1e0..1caa031 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -7,8 +7,9 @@ BUILT_SOURCES = config.h
 config.h: $(srcdir)/Makefile.am
 	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
 	echo '#define NDCTL_CONF_FILE \
-		"$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
+		"$(ndctl_confdir)/$(ndctl_monitorconf)"' >>$@
 	$(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
+	$(AM_V_GEN) echo '#define NDCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
 
 ndctl_SOURCES = ndctl.c \
 		builtin.h \
@@ -73,7 +74,7 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
-monitor_configdir = $(ndctl_monitorconfdir)
+monitor_configdir = $(ndctl_confdir)
 monitor_config_DATA = $(ndctl_monitorconf)
 
 if ENABLE_SYSTEMD_UNITS
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index e15bb22..f741c44 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -14,6 +14,10 @@ libndctl_la_SOURCES =\
 	../../util/log.h \
 	../../util/sysfs.c \
 	../../util/sysfs.h \
+	../../util/strbuf.h \
+	../../util/strbuf.c \
+	../../util/wrapper.c \
+	../../util/usage.c \
 	../../util/fletcher.h \
 	dimm.c \
 	inject.c \
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 536e142..db2e38b 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -24,6 +24,7 @@
 #include <util/util.h>
 #include <util/size.h>
 #include <util/sysfs.h>
+#include <util/strbuf.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
@@ -265,6 +266,56 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+static int filter_conf(const struct dirent *dir)
+{
+	if (!dir)
+		return 0;
+
+	if (dir->d_type == DT_REG) {
+		const char *ext = strrchr(dir->d_name, '.');
+		if ((!ext) || (ext == dir->d_name))
+			return 0;
+		if (strcmp(ext, ".conf") == 0)
+			return 1;
+	}
+
+	return 0;
+}
+
+NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir)
+{
+	struct dirent **namelist;
+	struct strbuf value = STRBUF_INIT;
+	int rc;
+
+	if ((!ctx) || (!conf_dir))
+		return;
+
+	rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
+	if (rc == -1) {
+		perror("scandir");
+		return;
+	}
+
+	while (rc--) {
+		if (value.len)
+			strbuf_addstr(&value, " ");
+		strbuf_addstr(&value, conf_dir);
+		strbuf_addstr(&value, "/");
+		strbuf_addstr(&value, namelist[rc]->d_name);
+		free(namelist[rc]);
+	}
+	(*ctx)->configs = strbuf_detach(&value, NULL);
+	free(namelist);
+}
+
+NDCTL_EXPORT const char *ndctl_get_configs(struct ndctl_ctx *ctx)
+{
+	if (ctx == NULL)
+		return NULL;
+	return ctx->configs;
+}
+
 /**
  * ndctl_new - instantiate a new library context
  * @ctx: context to establish
@@ -331,6 +382,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	c->daxctl_ctx = daxctl_ctx;
 
 	return 0;
+
  err_ctx:
 	daxctl_unref(daxctl_ctx);
  err_daxctl:
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 58afb74..5bd867d 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -454,4 +454,6 @@ LIBNDCTL_25 {
 
 LIBNDCTL_26 {
 	ndctl_bus_nfit_translate_spa;
+	ndctl_set_configs;
+	ndctl_get_configs;
 } LIBNDCTL_25;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8f4510e..f4ca71f 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -129,6 +129,7 @@ struct ndctl_ctx {
 	int regions_init;
 	void *userdata;
 	struct list_head busses;
+	const char *configs;
 	int busses_init;
 	struct udev *udev;
 	struct udev_queue *udev_queue;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 87d07b7..7ab7691 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -92,6 +92,8 @@ int ndctl_get_log_priority(struct ndctl_ctx *ctx);
 void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority);
 void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata);
 void *ndctl_get_userdata(struct ndctl_ctx *ctx);
+void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir);
+const char *ndctl_get_configs(struct ndctl_ctx *ctx);
 
 enum ndctl_persistence_domain {
 	PERSISTENCE_NONE = 0,
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 31d2c5e..0f00b04 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -125,6 +125,7 @@ int main(int argc, const char **argv)
 	rc = ndctl_new(&ctx);
 	if (rc)
 		goto out;
+	ndctl_set_configs(&ctx, NDCTL_CONF_DIR);
 	main_handle_internal_command(argc, argv, ctx, commands,
 			ARRAY_SIZE(commands), PROG_NDCTL);
 	ndctl_unref(ctx);
-- 
2.31.1


