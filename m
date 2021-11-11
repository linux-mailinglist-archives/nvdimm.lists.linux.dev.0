Return-Path: <nvdimm+bounces-1907-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id A944E44DC97
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Nov 2021 21:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 3FB631C0B9E
	for <lists+linux-nvdimm@lfdr.de>; Thu, 11 Nov 2021 20:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4432C86;
	Thu, 11 Nov 2021 20:44:54 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CF829CA
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:53 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253817"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253817"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:52 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579042"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:51 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 01/16] ndctl: add .clang-format
Date: Thu, 11 Nov 2021 13:44:21 -0700
Message-Id: <20211111204436.1560365-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5959; h=from:subject; bh=eQnG2CZ2cqjJlZQBxhUfWIN1YKD/mjY4seu18FDnhHY=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DRu4vB4duvmWyVS6f3aPwDEGmROOreXqz3jSBIvuW1wt /iTUUcrCIMbBICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgImc62FkWFy2fkbUyeuX9TYHqX67r3 4pr+7S2+yvOjGM7+9ob1J/84rhr9hXFo+eqeFvbjPH/ej3UFwqfXfKrYVXjRxZBdZczog7xQMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Copy the Linux kernel's .clang-format and modify it for ndctl. Only the
'ForEachMacros' section has been modified from the original kernel copy.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .clang-format | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)
 create mode 100644 .clang-format

diff --git a/.clang-format b/.clang-format
new file mode 100644
index 0000000..4e00fff
--- /dev/null
+++ b/.clang-format
@@ -0,0 +1,161 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# clang-format configuration file. Intended for clang-format >= 4.
+# Copied from Linux's .clang-format
+#
+# For more information, see:
+#
+#   https://clang.llvm.org/docs/ClangFormat.html
+#   https://clang.llvm.org/docs/ClangFormatStyleOptions.html
+#
+---
+AccessModifierOffset: -4
+AlignAfterOpenBracket: Align
+AlignConsecutiveAssignments: false
+AlignConsecutiveDeclarations: false
+#AlignEscapedNewlines: Left # Unknown to clang-format-4.0
+AlignOperands: true
+AlignTrailingComments: false
+AllowAllParametersOfDeclarationOnNextLine: false
+AllowShortBlocksOnASingleLine: false
+AllowShortCaseLabelsOnASingleLine: false
+AllowShortFunctionsOnASingleLine: None
+AllowShortIfStatementsOnASingleLine: false
+AllowShortLoopsOnASingleLine: false
+AlwaysBreakAfterDefinitionReturnType: None
+AlwaysBreakAfterReturnType: None
+AlwaysBreakBeforeMultilineStrings: false
+AlwaysBreakTemplateDeclarations: false
+BinPackArguments: true
+BinPackParameters: true
+BraceWrapping:
+  AfterClass: false
+  AfterControlStatement: false
+  AfterEnum: false
+  AfterFunction: true
+  AfterNamespace: true
+  AfterObjCDeclaration: false
+  AfterStruct: false
+  AfterUnion: false
+  #AfterExternBlock: false # Unknown to clang-format-5.0
+  BeforeCatch: false
+  BeforeElse: false
+  IndentBraces: false
+  #SplitEmptyFunction: true # Unknown to clang-format-4.0
+  #SplitEmptyRecord: true # Unknown to clang-format-4.0
+  #SplitEmptyNamespace: true # Unknown to clang-format-4.0
+BreakBeforeBinaryOperators: None
+BreakBeforeBraces: Custom
+#BreakBeforeInheritanceComma: false # Unknown to clang-format-4.0
+BreakBeforeTernaryOperators: false
+BreakConstructorInitializersBeforeComma: false
+#BreakConstructorInitializers: BeforeComma # Unknown to clang-format-4.0
+BreakAfterJavaFieldAnnotations: false
+BreakStringLiterals: false
+ColumnLimit: 80
+CommentPragmas: '^ IWYU pragma:'
+#CompactNamespaces: false # Unknown to clang-format-4.0
+ConstructorInitializerAllOnOneLineOrOnePerLine: false
+ConstructorInitializerIndentWidth: 8
+ContinuationIndentWidth: 8
+Cpp11BracedListStyle: false
+DerivePointerAlignment: false
+DisableFormat: false
+ExperimentalAutoDetectBinPacking: false
+#FixNamespaceComments: false # Unknown to clang-format-4.0
+
+# Taken from:
+# while read -r sym; do
+# 	printf "  - '%s'\n" "$sym";
+# done < \
+# 	<(cscope -dL6 "foreach|for_each" \
+# 	| awk '{ print $4 $5 }' | grep -E 'foreach|for_each' \
+# 	| sed -e 's/#define//' \
+# 		-e 's/*//' \
+# 		-e 's/://' \
+# 		-e 's/\(.*for_each.*\)(.*/\1/' \
+# 		-e 's/\(.*foreach.*\)(.*/\1/' \
+# 	| sort -u)
+ForEachMacros:
+  - 'daxctl_dev_foreach'
+  - 'daxctl_mapping_foreach'
+  - 'daxctl_region_foreach'
+  - 'kmod_list_foreach'
+  - 'kmod_list_foreach_reverse'
+  - 'list_for_each'
+  - 'list_for_each_off'
+  - 'list_for_each_rev'
+  - 'list_for_each_safe'
+  - 'list_for_each_safe_off'
+  - 'ndctl_btt_foreach'
+  - 'ndctl_btt_foreach_safe'
+  - 'ndctl_bus_foreach'
+  - 'ndctl_dax_foreach'
+  - 'ndctl_dax_foreach_safe'
+  - 'ndctl_dimm_foreach'
+  - 'ndctl_dimm_foreach_in_interleave_set'
+  - 'ndctl_dimm_foreach_in_region'
+  - 'ndctl_interleave_set_foreach'
+  - 'ndctl_mapping_foreach'
+  - 'ndctl_namespace_badblock_foreach'
+  - 'ndctl_namespace_bb_foreach'
+  - 'ndctl_namespace_foreach'
+  - 'ndctl_namespace_foreach_safe'
+  - 'ndctl_pfn_foreach'
+  - 'ndctl_pfn_foreach_safe'
+  - 'ndctl_region_badblock_foreach'
+  - 'ndctl_region_foreach'
+  - 'udev_list_entry_foreach'
+
+#IncludeBlocks: Preserve # Unknown to clang-format-5.0
+IncludeCategories:
+  - Regex: '.*'
+    Priority: 1
+IncludeIsMainRegex: '(Test)?$'
+IndentCaseLabels: false
+#IndentPPDirectives: None # Unknown to clang-format-5.0
+IndentWidth: 8
+IndentWrappedFunctionNames: false
+JavaScriptQuotes: Leave
+JavaScriptWrapImports: true
+KeepEmptyLinesAtTheStartOfBlocks: false
+MacroBlockBegin: ''
+MacroBlockEnd: ''
+MaxEmptyLinesToKeep: 1
+NamespaceIndentation: None
+#ObjCBinPackProtocolList: Auto # Unknown to clang-format-5.0
+ObjCBlockIndentWidth: 8
+ObjCSpaceAfterProperty: true
+ObjCSpaceBeforeProtocolList: true
+
+# Taken from git's rules
+#PenaltyBreakAssignment: 10 # Unknown to clang-format-4.0
+PenaltyBreakBeforeFirstCallParameter: 30
+PenaltyBreakComment: 10
+PenaltyBreakFirstLessLess: 0
+PenaltyBreakString: 10
+PenaltyExcessCharacter: 100
+PenaltyReturnTypeOnItsOwnLine: 60
+
+PointerAlignment: Right
+ReflowComments: false
+SortIncludes: false
+#SortUsingDeclarations: false # Unknown to clang-format-4.0
+SpaceAfterCStyleCast: false
+SpaceAfterTemplateKeyword: true
+SpaceBeforeAssignmentOperators: true
+#SpaceBeforeCtorInitializerColon: true # Unknown to clang-format-5.0
+#SpaceBeforeInheritanceColon: true # Unknown to clang-format-5.0
+SpaceBeforeParens: ControlStatements
+#SpaceBeforeRangeBasedForLoopColon: true # Unknown to clang-format-5.0
+SpaceInEmptyParentheses: false
+SpacesBeforeTrailingComments: 1
+SpacesInAngles: false
+SpacesInContainerLiterals: false
+SpacesInCStyleCastParentheses: false
+SpacesInParentheses: false
+SpacesInSquareBrackets: false
+Standard: Cpp03
+TabWidth: 8
+UseTab: Always
+...
-- 
2.31.1


