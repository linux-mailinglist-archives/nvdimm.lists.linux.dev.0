Return-Path: <nvdimm+bounces-11456-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4926BB44A79
	for <lists+linux-nvdimm@lfdr.de>; Fri,  5 Sep 2025 01:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC5951CC0964
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 Sep 2025 23:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC642EC0BF;
	Thu,  4 Sep 2025 23:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNPhuaHM"
X-Original-To: nvdimm@lists.linux.dev
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC31E487
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028797; cv=none; b=QYSVzAFwuzGuMC4Hr1F71lNgP9GNrT49sT/667W+dk5waHdGH5AAXYHtLnAiPm3yMzHYKTtcVoOZNwXqZLhR5IMkqRNgGeNUcIwlfykkno1fXWBEwRtZc3toyv3i5f3WcZrqwnrIha1X/18Zw0UoPRK+fPb9iiZ3zOJgXwSw57k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028797; c=relaxed/simple;
	bh=w0CppdaDeLWxKcRXy1oOGnX7nv3KWlhSP98PJQdvYH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gwjX+nm09zHiSOmpmn85h1JrI0v144b3obQ98hppk3xgBLaAlpQAZc2Fr3g6qkaTNd9J/eEF5K64MqlSblmacIk45NXpRODoqFN1anGrfgo/3M5IdhticQ4fqbLAQB34b9CEUjQTeHfA6FgLyyt+e+Uxf02q5TEYt+KPrwwKFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hNPhuaHM; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757028795; x=1788564795;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=w0CppdaDeLWxKcRXy1oOGnX7nv3KWlhSP98PJQdvYH0=;
  b=hNPhuaHMsrsZRpKim5EspC8qdxRiZgseRTG8/mCRvLhYEhNcHMdnPVPc
   Hh8pBgXr94Uamt0aDxBisZiPwI2tBdR5JuH3LPlUwcF+wJ7huloDxYpKr
   CSKrlS7af7Nd2rr9DKLiMKmLhTk4+01MfNYAehAgaudj0JjgfWCyQdmrs
   vvJCubq+xMbivlYV8UGpXk28+X/QMovcoaBUszl9rzG3tXMSfMJD9QUGJ
   jhPAQlyiHg7qUPQnVidSpfoNgBNIEiJLXgmn76BJlSgC9Q2bIS7iZ4kIN
   3MNsU7Aj6wbbV3Y3+88ZK78/JtOVoSZMky3VIQkspbYr355q0QHXRh6DX
   w==;
X-CSE-ConnectionGUID: TeLwd2zJQNmHvif4782YtA==
X-CSE-MsgGUID: yWxSw0PXRC6T66URFS1TFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="59239290"
X-IronPort-AV: E=Sophos;i="6.18,239,1751266800"; 
   d="scan'208";a="59239290"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 16:33:14 -0700
X-CSE-ConnectionGUID: qpkQB0OiTTG3iaHEjnOxBQ==
X-CSE-MsgGUID: Xe/a8mlURoaXoNbIGk3sWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,239,1751266800"; 
   d="scan'208";a="195683811"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.24]) ([10.125.110.24])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 16:33:13 -0700
Message-ID: <1c8be475-2599-46e4-8997-7e503e18c876@intel.com>
Date: Thu, 4 Sep 2025 16:33:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2] cxl: Add cxl-translate.sh unit test
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20250829204018.3486317-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250829204018.3486317-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/29/25 1:40 PM, Alison Schofield wrote:
> The cxl-translate.sh unit test feeds trusted data sets to a kernel
> test module: cxl_translate. The module accesses the CXL region
> driver's address translation functions.
> 
> The trusted samples are either from the CXL Driver Writers Guide[1]
> or from another source that has been verified. ie a spreadsheet
> reviewed by CXL developers.
> 
> [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Looks ok to me, not that I'm that proficient with BASH.

> ---
> 
> Changes in v2:
> Use shell builtins true|false rather than string compares (Marc)
> Further explain the disable of SC2034 for nameref's  (Marc)
> Use long format journalctl options, ie. --reverse (Marc)
> Correct module name as cxl_translate in commit log
> 
>  test/cxl-translate.sh | 302 ++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build      |   2 +
>  2 files changed, 304 insertions(+)
>  create mode 100755 test/cxl-translate.sh
> 
> diff --git a/test/cxl-translate.sh b/test/cxl-translate.sh
> new file mode 100755
> index 000000000000..af872352d73c
> --- /dev/null
> +++ b/test/cxl-translate.sh
> @@ -0,0 +1,302 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +# shellcheck disable=SC2034
> +#
> +# Arrays in this script are passed by name into helper functions using Bash's
> +# nameref feature `declare -n`. This pattern supports writing generic test
> +# harnesses that can iterate over many different test vector arrays simply by
> +# passing the array name. ShellCheck doesn't track nameref indirection, so it
> +# incorrectly reports these arrays as unused (SC2034). At runtime they are
> +# fully used through the nameref, so these warnings are safe to ignore.
> +
> +# source common to get the err() only
> +. "$(dirname "$0")"/common
> +
> +trap 'err $LINENO' ERR
> +set -ex
> +rc=1
> +
> +MODULO=0
> +XOR=1
> +
> +# Test against 'Sample Sets' and 'XOR Tables'
> +#
> +# Sample Set's have a pattern and the expected HPAs have been verified
> +# although maybe not published. They verify Modulo and XOR translations.
> +#
> +# XOR Table's are extracted from the CXL Driver Writers Guide [1].
> +# Although the XOR Tables do not include an explicit check of the Modulo
> +# translation result, a Modulo calculation is always the first step in
> +# any XOR calculation. ie. if Modulo fails so does XOR.
> +#
> +# [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
> +
> +# Start time for kernel log checking at millisecond granularity
> +set_log_start_time() {
> +        log_start_time=$(date '+%Y-%m-%d %H:%M:%S.%3N')
> +}
> +
> +check_dmesg_results() {
> +        local nr_entries=$1
> +        local expect_failures=${2:-false}  # Optional param, builtin true|false
> +        local log nr_pass nr_fail
> +
> +        log=$(journalctl --reverse --dmesg --since "$log_start_time")
> +
> +	nr_pass=$(echo "$log" | grep -c "CXL Translate Test.*PASS") || nr_pass=0
> +        nr_fail=$(echo "$log" | grep -c "CXL Translate Test.*FAIL") || nr_fail=0
> +
> +        if ! $expect_failures; then
> +                # Expect all PASS and no FAIL
> +                [ "$nr_pass" -eq "$nr_entries" ] || err "$LINENO"
> +                [ "$nr_fail" -eq 0 ] || err "$LINENO"
> +        else
> +                # Expect no PASS and all FAIL
> +		[ "$nr_pass" -eq 0 ] || err "$LINENO"
> +                [ "$nr_fail" -eq "$nr_entries" ] || err "$LINENO"
> +        fi
> +}
> +
> +# Sample Sets
> +#
> +# params_#: dpa, region eiw, region eig, host bridge ways
> +# expect_[modulo|xor]_#: expected spa for each position in the region
> +# 	interleave set for the modulo|xor math.
> +#
> +# Feeds the parameters with an expected SPA for each position in the region
> +# interleave to the test module. Returns success if the calculation matches
> +# the expected SPA and the reverse calculation returns the original DPA and
> +# position.
> +
> +# 4 way region interleave using 4 host bridges
> +# Notation: 1+1+1+1
> +declare -A Sample_4R_4H=(
> +	["params_0"]="0 2 0 4"
> +	["expect_modulo_0"]="0 256 512 768"
> +	["expect_xor_0"]="0 256 512 768"
> +	["params_1"]="256 2 0 4"
> +	["expect_modulo_1"]="1024 1280 1536 1792"
> +	["expect_xor_1"]="1024 1280 1536 1792"
> +	["params_2"]="2048 2 0 4"
> +	["expect_modulo_2"]="8192 8448 8704 8960"
> +	["expect_xor_2"]="8192 8448 8704 8960"
> +)
> +
> +# 12 way region interleave using 12 host bridges
> +# Notation: 1+1+1+1+1+1+1+1+1+1+1+1
> +declare -A Sample_12R_12H=(
> +	["params_0"]="0 10 0 12"
> +	["expect_modulo_0"]="0 256 512 768 1024 1280 1536 1792 2048 2304 2560 2816"
> +	["expect_xor_0"]="0 256 512 768 1024 1280 1536 1792 2304 2048 2816 2560"
> +	["params_1"]="512 10 0 12"
> +	["expect_modulo_1"]="6144 6400 6656 6912 7168 7424 7680 7936 8192 8448 8704 8960"
> +	["expect_xor_1"]="6912 6656 6400 6144 7936 7680 7424 7168 8192 8448 8704 8960"
> +)
> +
> +decode_r_eiw()
> +{
> +	case $1 in
> +		0) echo 1 ;;
> +		1) echo 2 ;;
> +		2) echo 4 ;;
> +		3) echo 8 ;;
> +		4) echo 16 ;;
> +		8) echo 3 ;;
> +		9) echo 6 ;;
> +		10) echo 12 ;;
> +		*) echo "Invalid r_eiw value: $1" ; err "$LINENO" ;;
> +	esac
> +}
> +
> +generate_sample_tests() {
> +        local -n input_sample_set=$1
> +        local -n output_array=$2
> +
> +        # Find all params_* keys and extract the index
> +        local indices=()
> +        for key in "${!input_sample_set[@]}"; do
> +                if [[ $key =~ ^params_([0-9]+)$ ]]; then
> +                        indices+=("${BASH_REMATCH[1]}")
> +                fi
> +        done
> +
> +        # Sort indices to process in order
> +	mapfile -t indices < <(printf '%s\n' "${indices[@]}" | sort -n)
> +
> +        for i in "${indices[@]}"; do
> +                # Split the parameters and expected spa values
> +                IFS=' ' read -r dpa r_eiw r_eig hb_ways <<< "${input_sample_set["params_$i"]}"
> +                IFS=' ' read -r -a expect_modulo_values <<< "${input_sample_set["expect_modulo_$i"]}"
> +                IFS=' ' read -r -a expect_xor_values <<< "${input_sample_set["expect_xor_$i"]}"
> +
> +                ways=$(decode_r_eiw "$r_eiw")
> +                for ((pos = 0; pos < ways; pos++)); do
> +                        expect_spa_modulo=${expect_modulo_values[$pos]}
> +                        expect_spa_xor=${expect_xor_values[$pos]}
> +
> +                        # Add the MODULO test case, then the XOR test case
> +                        output_array+=("$dpa $pos $r_eiw $r_eig $hb_ways $MODULO $expect_spa_modulo")
> +                        output_array+=("$dpa $pos $r_eiw $r_eig $hb_ways $XOR $expect_spa_xor")
> +                done
> +        done
> +}
> +
> +test_sample_sets() {
> +        local sample_name=$1
> +        local -n sample_set=$1
> +        local generated_tests=()
> +
> +        generate_sample_tests sample_set generated_tests
> +
> +        IFS=','
> +        table_string="${generated_tests[*]}"
> +        IFS=' '
> +
> +        modprobe -r cxl-translate
> +        set_log_start_time
> +        echo "Testing $sample_name with ${#generated_tests[@]} test entries"
> +        modprobe cxl-translate "table=$table_string"
> +        check_dmesg_results "${#generated_tests[@]}"
> +}
> +
> +# XOR Tables
> +#
> +# The tables that follow are the XOR translation examples in the
> +# CXL Driver Writers Guide Sections 2.13.24.1 and 25.1
> +# Note that the Guide uses the device number in its table notation.
> +# Here the 'position' of that device number is used, not the
> +# device number itself, which is meaningless in this context.
> +#
> +# Format: "dpa pos r_eiw r_eig hb_ways xor_math(0|1) xor_spa:
> +
> +# 4 way region interleave using 4 host bridges
> +# Notation: 1+1+1+1
> +XOR_Table_4R_4H=(
> +	"248   0 2 0 4 1 248"
> +	"16    1 2 0 4 1 272"
> +	"16    2 2 0 4 1 528"
> +	"32    3 2 0 4 1 800"
> +	"288   0 2 0 4 1 1056"
> +	"288   1 2 0 4 1 1312"
> +	"288   2 2 0 4 1 1568"
> +	"288   3 2 0 4 1 1824"
> +	"544   1 2 0 4 1 2080"
> +	"544   0 2 0 4 1 2336"
> +	"544   3 2 0 4 1 2592"
> +	"1040  2 2 0 4 1 4112"
> +	"1568  3 2 0 4 1 6176"
> +	"32784 1 2 0 4 1 131088"
> +	"65552 2 2 0 4 1 262160"
> +	"98336 3 2 0 4 1 393248"
> +	"98328 2 2 0 4 1 393496"
> +	"98352 2 2 0 4 1 393520"
> +	"443953523 0 2 0 4 1 1775813747"
> +)
> +
> +XOR_Table_8R_4H=(
> +	"248       0 3 0 4 1 248"
> +	"16        1 3 0 4 1 272"
> +	"16        2 3 0 4 1 528"
> +	"32        3 3 0 4 1 800"
> +	"272       1 3 0 4 1 2064"
> +	"528       2 3 0 4 1 4112"
> +	"800       3 3 0 4 1 6176"
> +	"16400     1 3 0 4 1 131088"
> +	"32784     2 3 0 4 1 262160"
> +	"49184     3 3 0 4 1 393248"
> +	"49176     2 3 0 4 1 393496"
> +	"49200     2 3 0 4 1 393520"
> +	"116520373 3 3 0 4 1 932162229"
> +	"244690459 5 3 0 4 1 1957525275"
> +	"292862215 5 3 0 4 1 2342899463"
> +	"30721158  4 3 0 4 1 245769350"
> +	"246386959 4 3 0 4 1 1971096847"
> +	"72701249  5 3 0 4 1 581610561"
> +	"529382429 5 3 0 4 1 4235060509"
> +	"191132300 2 3 0 4 1 1529057420"
> +	"18589081  1 3 0 4 1 148712089"
> +	"344295715 7 3 0 4 1 2754367011"
> +)
> +
> +XOR_Table_12R_12H=(
> +	"224 0 10 0 12 1 224"
> +	"16  1 10 0 12 1 272"
> +	"16  2 10 0 12 1 528"
> +	"32  3 10 0 12 1 800"
> +	"32  4 10 0 12 1 1056"
> +	"32  5 10 0 12 1 1312"
> +	"32  6 10 0 12 1 1568"
> +	"32  7 10 0 12 1 1824"
> +	"32  9 10 0 12 1 2080"
> +	"32  8 10 0 12 1 2336"
> +	"32 11 10 0 12 1 2592"
> +	"32 10 10 0 12 1 2848"
> +	"288 0 10 0 12 1 3360"
> +	"299017087 7 10 0 12 1 3588205439"
> +	"329210435 0 10 0 12 1 3950524995"
> +	"151050637 11 10 0 12 1 1812608653"
> +	"145169214  2 10 0 12 1 1742030654"
> +	"328998732 10 10 0 12 1 3947985996"
> +	"159252439  3 10 0 12 1 1911027415"
> +	"342098916  5 10 0 12 1 4105186020"
> +	"97970344   8 10 0 12 1 1175645096"
> +	"214995572  8 10 0 12 1 2579948404"
> +	"101289661  7 10 0 12 1 1215475645"
> +	"40424079   7 10 0 12 1 485088911"
> +	"231458716  7 10 0 12 1 2777503900"
> +)
> +
> +# A fail table entry is expected to fail the DPA->SPA calculation.
> +# Intent is to show that the test module can tell good from bad.
> +# If one of these cases passes, don't trust other pass results.
> +# This is not a test of module parsing, so don't send garbage.
> +Expect_Fail_Table=(
> +	"544   3 2 0 4 1 2080" # Change position
> +        "544   2 2 0 4 1 2336"
> +        "544   1 2 0 4 1 2592"
> +	"272   1 2 0 4 1 2064" # Change r_eiw
> +	"528   2 1 0 4 1 4112"
> +	"800   3 10 0 4 1 6176"
> +	"32  4 10 0 12 1 1156" # Change expected spa
> +	"32  5 10 0 12 1 1112"
> +	"32  6 10 0 12 1 1168"
> +	"32  7 10 0 12 1 1124"
> +)
> +
> +test_tables() {
> +        local table_name=$1
> +        local -n table_ref=$1
> +        local expect_failures=${2:-false}  # Optional param, builtin true|false
> +        local IFS
> +
> +        IFS=','
> +        table_string="${table_ref[*]}"
> +        IFS=' '
> +
> +        if $expect_failures; then
> +                echo "Testing $table_name with ${#table_ref[@]} entries (expecting FAIL results)"
> +        else
> +                echo "Testing $table_name with ${#table_ref[@]} test entries"
> +        fi
> +
> +        modprobe -r cxl-translate
> +        set_log_start_time
> +        modprobe cxl-translate "table=$table_string"
> +
> +        check_dmesg_results "${#table_ref[@]}" "$expect_failures"
> +}
> +
> +test_tables Expect_Fail_Table true
> +test_sample_sets Sample_4R_4H
> +test_sample_sets Sample_12R_12H
> +test_tables XOR_Table_4R_4H
> +test_tables XOR_Table_8R_4H
> +test_tables XOR_Table_12R_12H
> +
> +echo "Translate test complete with no failures"
> +
> +modprobe -r cxl-translate
> +
> +
> diff --git a/test/meson.build b/test/meson.build
> index 91eb6c2b1363..bf4d73eea918 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -168,6 +168,7 @@ cxl_sanitize = find_program('cxl-sanitize.sh')
>  cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  cxl_qos_class = find_program('cxl-qos-class.sh')
>  cxl_poison = find_program('cxl-poison.sh')
> +cxl_translate = find_program('cxl-translate.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -201,6 +202,7 @@ tests = [
>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
> +  [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()


