Return-Path: <nvdimm+bounces-361-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468A43BC587
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 06:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 68F101C0772
	for <lists+linux-nvdimm@lfdr.de>; Tue,  6 Jul 2021 04:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347F62F80;
	Tue,  6 Jul 2021 04:33:13 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9972
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 04:33:10 +0000 (UTC)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJqMz66qwzZn0N
	for <nvdimm@lists.linux.dev>; Tue,  6 Jul 2021 12:29:51 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 12:33:02 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 6 Jul
 2021 12:33:02 +0800
Subject: [ndctl PATCH v2 2/2] namespace: Close fd before return in
 do_xaction_namespace()
To: <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, linfeilong <linfeilong@huawei.com>,
	<lixiaokeng@huawei.com>, Alison Schofield <alison.schofield@intel.com>,
	<liuzhiqiang26@huawei.com>
References: <c3c08075-4815-8e84-2ba6-64644e72abee@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <a10193c0-e56b-8bf1-7ce4-d0c0f7bdc35b@huawei.com>
Date: Tue, 6 Jul 2021 12:33:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c3c08075-4815-8e84-2ba6-64644e72abee@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected


Recently, we use Coverity to analysis the ndctl package,
one issue in do_xaction_namespace() is reported as follows,
	CID 11690564: (RESOURCE_LEAK)
	2058. leaked_storage: Variable "ri_ctx" going out of scope
	      leaks the storage "ri_ctx.f_out" points to.

In do_xaction_namespace(), ri_ctx.f_out should be closed after
being opened. This prevents a potential file descriptor leak
in do_xaction_namespace().

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
v1->v2: add coverity report info as suggested by Alison

 ndctl/namespace.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 21089d7..55364ac 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2141,7 +2141,7 @@ static int do_xaction_namespace(const char *namespace,
 				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
 			if (rc >= 0)
 				(*processed)++;
-			return rc;
+			goto out;
 		}
 	}

@@ -2152,11 +2152,11 @@ static int do_xaction_namespace(const char *namespace,
 		rc = file_write_infoblock(param.outfile);
 		if (rc >= 0)
 			(*processed)++;
-		return rc;
+		goto out;
 	}

 	if (!namespace && action != ACTION_CREATE)
-		return rc;
+		goto out;

 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
@@ -2212,7 +2212,7 @@ static int do_xaction_namespace(const char *namespace,
 						saved_rc = rc;
 						continue;
 				}
-				return rc;
+				goto out;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
@@ -2259,7 +2259,7 @@ static int do_xaction_namespace(const char *namespace,
 					rc = namespace_reconfig(region, ndns);
 					if (rc == 0)
 						*processed = 1;
-					return rc;
+					goto out;
 				case ACTION_READ_INFOBLOCK:
 					rc = namespace_rw_infoblock(ndns, &ri_ctx, READ);
 					if (rc == 0)
@@ -2281,9 +2281,6 @@ static int do_xaction_namespace(const char *namespace,
 	if (ri_ctx.jblocks)
 		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);

-	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
-		fclose(ri_ctx.f_out);
-
 	if (action == ACTION_CREATE && rc == -EAGAIN) {
 		/*
 		 * Namespace creation searched through all candidate
@@ -2301,6 +2298,10 @@ static int do_xaction_namespace(const char *namespace,
 	if (saved_rc)
 		rc = saved_rc;

+out:
+	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
+		fclose(ri_ctx.f_out);
+
 	return rc;
 }

-- 
2.23.0




