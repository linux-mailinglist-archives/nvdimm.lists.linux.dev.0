Return-Path: <nvdimm+bounces-9214-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B30919B82B3
	for <lists+linux-nvdimm@lfdr.de>; Thu, 31 Oct 2024 19:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38BE31F22E5D
	for <lists+linux-nvdimm@lfdr.de>; Thu, 31 Oct 2024 18:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE851C4612;
	Thu, 31 Oct 2024 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQoioL4u"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E51BD4E2
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400071; cv=none; b=AZZJFlY5ePfpEkCjG4X7Lazxnhvuqo7l+Gapt2SllHQNSv7EIBCO2TCrH1duKK2MmHJMWRM6jCU8skzFKMO4eczXRn1p2+C29GKOoMh+ChdXpVbVJDg2wdKRoGRGU7+l+xn6Z0fq2I9l8DEXp3nxw4K4dPP0Q4kuSAH/2h7bxzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400071; c=relaxed/simple;
	bh=ATzfaiMsqBx57p9O74SscSL8vl2VTBl4qKHEBfan6Fo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzxQy6nvRmwVIO/DUvP9Q1iif/xELnfP6a/UlP0v7fTcgv5mb4h+oRBnSkqDdxp7e0uz4yHxqTjon1Jn5u0WPT8KW/0C99fP8J5fAtfyOY+Nm4BtJB7QqnXA0mIYfnMq8bhFb2eN3NGul8Nyste+Q4W9g6o+QGkQcrgd2FI0w+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQoioL4u; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71e79f73aaeso1006746b3a.3
        for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 11:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730400066; x=1731004866; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FTyO5O8hrz6D/sk4zBFC8klAI6IuIMjz1bUth36Glgk=;
        b=IQoioL4uxBYH881fY/P/RhILoshh9sVeqG0WVjghTAvqSjgNCpv8z7zu6rHwlzBvYX
         5qv7CmJGu/cQFj/0YtTKj9eRPYcxNq8V7CkyqG16E94zV2SjE/8ZBeKig7ImP1ngcyb1
         kn31al2dlZ7zh4fddtYV4U78ElUNri3XIw5HVrOPF/xqpPS7CIQDrzgGCnfue3uXUG3r
         vhZA4uwtUKX1HT3v/sDPpl332zFE5m7cm8WKbDRbOVg6AoOn6cSCrJQ5n2BnryJkfIWD
         pmYzrjmB7i9vqGjMkwIqm8azLllbGLO5JonvWJGqaYaA0SoruNoWqeYNmrUPTRF4SbhC
         o3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730400066; x=1731004866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTyO5O8hrz6D/sk4zBFC8klAI6IuIMjz1bUth36Glgk=;
        b=dsh4wSg2s9njg3OAc5cr4lJJHREY8tUouONZnYcoZtLKo39WZnoPqiEmFZqdVaFPjf
         nVE7ZsipwX4sOefPrmHTSYn1XfYcG75ftPTthrjKQVFNLc3uGN56S0LebQb0A350GyJZ
         uoXTZEE205xIlPhaAy7LOIjsmlHWSudJfEdVovARHfHkplUWnzIoxF/1aHVWcoxDIZMv
         128C/oQaePl1FUCQfL8oXrioWaGyaIIGhSU+Toub28ZakG7rgKrBSvGR+yiZ8IfW0Vt3
         ttVS7CEE3xY/OVahulMDxGH37roaT7QOx4Y6izmFN2n6wAVqCHqDHWLfeCMZwi2d7vqi
         OFxg==
X-Forwarded-Encrypted: i=1; AJvYcCVYSudKfzGa2BohGEk80hQwCqgEDAg2eUGTmUTzrswAuwauYuvQYshnzJJZ3BaNHxz16AyooqY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE04n2YWdibEVbrqwkzH/E7gsd518MNlEbtWhVW4HugdoYLGP7
	6AB2MVJEWPN/WL6TqsaMSbUfWJJq2Y7HdjXqBbnCU6dAroNdUNwW
X-Google-Smtp-Source: AGHT+IEMqFfhzF37txKGB4mgl9aFV5BiYFpDQVoCx1slqIHQTcDd0sT5M2DYzAUEu8SltFhxfQaJaA==
X-Received: by 2002:a05:6a00:4b52:b0:71e:b1dc:f229 with SMTP id d2e1a72fcca58-7206306ecbbmr28473733b3a.19.1730400066088;
        Thu, 31 Oct 2024 11:41:06 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:1a14:7759:606e:c90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1b9cdbsm1429621b3a.26.2024.10.31.11.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 11:41:05 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 31 Oct 2024 11:41:03 -0700
To: ira.weiny@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH 4/6] cxl/region: Add creation of Dynamic capacity
 regions
Message-ID: <ZyPPPycLXADj2Lvb@fan>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
 <20241030-dcd-region2-v1-4-04600ba2b48e@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030-dcd-region2-v1-4-04600ba2b48e@intel.com>

On Wed, Oct 30, 2024 at 04:54:47PM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> spare and defined as dynamic capacity (dc).
> 
> Add support for DCD devices.  Query for DCD capabilities.  Add the
> ability to add DC partitions to a CXL DC region.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: adjust to new sysfs interface.]
> [iweiny: Rebase to latest pending]
> [iweiny: Adjust DCD region code to new upstream sysfs entries]
> [iweiny: Ensure backwards compatibility for non-DC kernels]
> [iweiny: fixup help message to show DC type]
> [iweiny: don't double declare decoder mode is dc]
> [iweiny: simplify __reserve_dpa() with decoder mode to index]
> [iweiny: Adjust to the new region mode]
> ---
>  cxl/json.c         | 26 +++++++++++++++
>  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  cxl/lib/libcxl.sym |  3 ++
>  cxl/lib/private.h  |  6 +++-
>  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
>  cxl/memdev.c       |  7 +++-
>  cxl/region.c       | 49 ++++++++++++++++++++++++++--
>  7 files changed, 234 insertions(+), 7 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index dcd3cc28393faf7e8adf299a857531ecdeaac50a..4276b9678d7e03eaf2aec581a08450f2a0b857f2 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -754,10 +754,12 @@ err_free:
>  	return jpoison;
>  }
>  
> +#define DC_SIZE_NAME_LEN 64
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
>  {
>  	const char *devname = cxl_memdev_get_devname(memdev);
> +	char size_name[DC_SIZE_NAME_LEN];
>  	struct json_object *jdev, *jobj;
>  	unsigned long long serial, size;
>  	const char *fw_version;
> @@ -800,6 +802,17 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		}
>  	}
>  
> +	for (int index; index < MAX_NUM_DC_REGIONS; index++) {

index is not initialized.
Should be index = 0;

Also, the "cxl list" looks like below, the size of each DC region is
attached to each DCD device, that seems not quite aligned with what
"_size" means for pmem/ram. Should we have a separate option for "cxl
list" to show DC region info??

Fan

----------
  {
        "memdev":"mem1",
        "dc0_size":"2.00 GiB (2.15 GB)",
        "dc1_size":"2.00 GiB (2.15 GB)",
        "serial":"0xf02",
        "host":"0000:11:00.0",
        "firmware_version":"BWFW VERSION 00"
      },
      {
        "memdev":"mem3",
        "dc0_size":"2.00 GiB (2.15 GB)",
        "dc1_size":"2.00 GiB (2.15 GB)",
        "serial":"0xf03",
        "host":"0000:12:00.0",
        "firmware_version":"BWFW VERSION 00"
      },
----------


> +		size = cxl_memdev_get_dc_size(memdev, index);
> +		if (size) {
> +			jobj = util_json_object_size(size, flags);
> +			if (jobj) {
> +				sprintf(size_name, "dc%d_size", index);
> +				json_object_object_add(jdev,
> +						       size_name, jobj);
> +			}
> +		}
> +	}
>  	if (flags & UTIL_JSON_HEALTH) {
>  		jobj = util_cxl_memdev_health_to_json(memdev, flags);
>  		if (jobj)
> @@ -948,11 +961,13 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  	return jbus;
>  }
>  
> +#define DC_CAPABILITY_NAME_LEN 16
>  struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  					     unsigned long flags)
>  {
>  	const char *devname = cxl_decoder_get_devname(decoder);
>  	struct cxl_port *port = cxl_decoder_get_port(decoder);
> +	char dc_capable_name[DC_CAPABILITY_NAME_LEN];
>  	struct json_object *jdecoder, *jobj;
>  	struct cxl_region *region;
>  	u64 val, size;
> @@ -1059,6 +1074,17 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  				json_object_object_add(
>  					jdecoder, "volatile_capable", jobj);
>  		}
> +		for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
> +			if (cxl_decoder_is_dc_capable(decoder, index)) {
> +				jobj = json_object_new_boolean(true);
> +				if (jobj) {
> +					sprintf(dc_capable_name, "dc%d_capable", index);
> +					json_object_object_add(jdecoder,
> +							       dc_capable_name,
> +							       jobj);
> +				}
> +			}
> +		}
>  	}
>  
>  	if (cxl_port_is_root(port) &&
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 5cbfb3e7d466b491ef87ea285f7e50d3bac230db..4caa2d02313bf71960971c4eaa67fa42cea08d55 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1267,7 +1267,6 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>  	char buf[SYSFS_ATTR_SIZE];
>  	struct stat st;
>  	char *host;
> -
>  	if (!path)
>  		return NULL;
>  	dbg(ctx, "%s: base: \'%s\'\n", devname, cxlmem_base);
> @@ -1304,6 +1303,19 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>  	else
>  		memdev->ram_qos_class = atoi(buf);
>  
> +	memdev->dc_partition_count = 0;
> +	for (int partition = 0; partition < MAX_NUM_DC_REGIONS; partition++) {
> +		sprintf(path, "%s/dc%d/size", cxlmem_base, partition);
> +		if (sysfs_read_attr(ctx, path, buf) < 0)
> +			continue;
> +		memdev->dc_size[partition] = strtoull(buf, NULL, 0);
> +		memdev->dc_partition_count++;
> +		sprintf(path, "%s/dc%d/qos_class", cxlmem_base, partition);
> +		if (sysfs_read_attr(ctx, path, buf) < 0)
> +			continue;
> +		memdev->dc_qos_class[partition] = strtoull(buf, NULL, 0);
> +	}
> +
>  	sprintf(path, "%s/payload_max", cxlmem_base);
>  	if (sysfs_read_attr(ctx, path, buf) == 0) {
>  		memdev->payload_max = strtoull(buf, NULL, 0);
> @@ -1540,6 +1552,14 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
>  	return memdev->ram_qos_class;
>  }
>  
> +CXL_EXPORT unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, int index)
> +{
> +	if (index >= 0 && index < MAX_NUM_DC_REGIONS)
> +		return memdev->dc_size[index];
> +
> +	return 0;
> +}
> +
>  CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
>  {
>  	return memdev->firmware_version;
> @@ -2275,6 +2295,22 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			decoder->mode = CXL_DECODER_MODE_RAM;
>  		else if (strcmp(buf, "pmem") == 0)
>  			decoder->mode = CXL_DECODER_MODE_PMEM;
> +		else if (strcmp(buf, "dc0") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC0;
> +		else if (strcmp(buf, "dc1") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC1;
> +		else if (strcmp(buf, "dc2") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC2;
> +		else if (strcmp(buf, "dc3") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC3;
> +		else if (strcmp(buf, "dc4") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC4;
> +		else if (strcmp(buf, "dc5") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC5;
> +		else if (strcmp(buf, "dc6") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC6;
> +		else if (strcmp(buf, "dc7") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC7;
>  		else if (strcmp(buf, "mixed") == 0)
>  			decoder->mode = CXL_DECODER_MODE_MIXED;
>  		else if (strcmp(buf, "none") == 0)
> @@ -2318,6 +2354,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  	case CXL_PORT_SWITCH:
>  		decoder->pmem_capable = true;
>  		decoder->volatile_capable = true;
> +		decoder->dc_capable[0] = true;
> +		decoder->dc_capable[1] = true;
> +		decoder->dc_capable[2] = true;
> +		decoder->dc_capable[3] = true;
> +		decoder->dc_capable[4] = true;
> +		decoder->dc_capable[5] = true;
> +		decoder->dc_capable[6] = true;
> +		decoder->dc_capable[7] = true;
>  		decoder->mem_capable = true;
>  		decoder->accelmem_capable = true;
>  		sprintf(path, "%s/locked", cxldecoder_base);
> @@ -2341,6 +2385,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			{ "cap_type2", &decoder->accelmem_capable },
>  			{ "cap_type3", &decoder->mem_capable },
>  			{ "cap_ram", &decoder->volatile_capable },
> +			{ "cap_ram", &decoder->dc_capable[0] },
> +			{ "cap_ram", &decoder->dc_capable[1] },
> +			{ "cap_ram", &decoder->dc_capable[2] },
> +			{ "cap_ram", &decoder->dc_capable[3] },
> +			{ "cap_ram", &decoder->dc_capable[4] },
> +			{ "cap_ram", &decoder->dc_capable[5] },
> +			{ "cap_ram", &decoder->dc_capable[6] },
> +			{ "cap_ram", &decoder->dc_capable[7] },
>  			{ "cap_pmem", &decoder->pmem_capable },
>  			{ "locked", &decoder->locked },
>  		};
> @@ -2592,6 +2644,30 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
>  	case CXL_DECODER_MODE_RAM:
>  		sprintf(buf, "ram");
>  		break;
> +	case CXL_DECODER_MODE_DC0:
> +		sprintf(buf, "dc0");
> +		break;
> +	case CXL_DECODER_MODE_DC1:
> +		sprintf(buf, "dc1");
> +		break;
> +	case CXL_DECODER_MODE_DC2:
> +		sprintf(buf, "dc2");
> +		break;
> +	case CXL_DECODER_MODE_DC3:
> +		sprintf(buf, "dc3");
> +		break;
> +	case CXL_DECODER_MODE_DC4:
> +		sprintf(buf, "dc4");
> +		break;
> +	case CXL_DECODER_MODE_DC5:
> +		sprintf(buf, "dc5");
> +		break;
> +	case CXL_DECODER_MODE_DC6:
> +		sprintf(buf, "dc6");
> +		break;
> +	case CXL_DECODER_MODE_DC7:
> +		sprintf(buf, "dc7");
> +		break;
>  	default:
>  		err(ctx, "%s: unsupported mode: %d\n",
>  		    cxl_decoder_get_devname(decoder), mode);
> @@ -2648,6 +2724,14 @@ CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
>  	return decoder->mem_capable;
>  }
>  
> +CXL_EXPORT bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, int index)
> +{
> +	if (index >= 0 && index < MAX_NUM_DC_REGIONS)
> +		return decoder->dc_capable[index];
> +
> +	return 0;
> +}
> +
>  CXL_EXPORT bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder)
>  {
>  	return decoder->accelmem_capable;
> @@ -2717,6 +2801,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
>  		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
>  	else if (mode == CXL_DECODER_MODE_RAM)
>  		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> +	else if (cxl_decoder_mode_is_dc(mode))
> +		sprintf(path, "%s/create_dc_region", decoder->dev_path);
>  
>  	rc = sysfs_read_attr(ctx, path, buf);
>  	if (rc < 0) {
> @@ -2768,6 +2854,13 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
>  	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
>  }
>  
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_dc_region(struct cxl_decoder *decoder,
> +			     enum cxl_decoder_mode mode)
> +{
> +	return cxl_decoder_create_region(decoder, mode);
> +}
> +
>  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
>  {
>  	return decoder->nr_targets;
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index b5d9bdcc38e09812f26afc1cb0e804f86784b8e6..351da7512e05080d847fd87740488d613462dbc9 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -19,6 +19,7 @@ global:
>  	cxl_memdev_get_ctx;
>  	cxl_memdev_get_pmem_size;
>  	cxl_memdev_get_ram_size;
> +	cxl_memdev_get_dc_size;
>  	cxl_memdev_get_firmware_verison;
>  	cxl_cmd_get_devname;
>  	cxl_cmd_new_raw;
> @@ -247,6 +248,8 @@ LIBCXL_5 {
>  global:
>  	cxl_region_get_mode;
>  	cxl_decoder_create_ram_region;
> +	cxl_decoder_is_dc_capable;
> +	cxl_decoder_create_dc_region;
>  	cxl_region_get_daxctl_region;
>  	cxl_port_get_parent_dport;
>  } LIBCXL_4;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 0f45be89b6a00477d13fb6d7f1906213a3073c48..10abfa63dfc759b1589f9f039da1b920f8eb605e 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -12,7 +12,6 @@
>  #include <util/bitmap.h>
>  
>  #define CXL_EXPORT __attribute__ ((visibility("default")))
> -
>  struct cxl_pmem {
>  	int id;
>  	void *dev_buf;
> @@ -47,6 +46,9 @@ struct cxl_memdev {
>  	struct list_node list;
>  	unsigned long long pmem_size;
>  	unsigned long long ram_size;
> +	unsigned long long dc_size[MAX_NUM_DC_REGIONS];
> +	unsigned long long dc_qos_class[MAX_NUM_DC_REGIONS];
> +	int dc_partition_count;
>  	int ram_qos_class;
>  	int pmem_qos_class;
>  	int payload_max;
> @@ -111,6 +113,7 @@ struct cxl_endpoint {
>  	struct cxl_memdev *memdev;
>  };
>  
> +
>  struct cxl_target {
>  	struct list_node list;
>  	struct cxl_decoder *decoder;
> @@ -140,6 +143,7 @@ struct cxl_decoder {
>  	bool pmem_capable;
>  	bool volatile_capable;
>  	bool mem_capable;
> +	bool dc_capable[MAX_NUM_DC_REGIONS];
>  	bool accelmem_capable;
>  	bool locked;
>  	enum cxl_decoder_target_type target_type;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 06b87a0924faafec6c80eca83ea7551d4e117256..17ed682548b970d57f016942badc76dce61bdeaf 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -72,6 +72,7 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
>  struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> +unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, int index);
>  int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
>  int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
> @@ -191,11 +192,20 @@ unsigned long long
>  cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
>  int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
>  
> +#define MAX_NUM_DC_REGIONS 8
>  enum cxl_decoder_mode {
>  	CXL_DECODER_MODE_NONE,
>  	CXL_DECODER_MODE_MIXED,
>  	CXL_DECODER_MODE_PMEM,
>  	CXL_DECODER_MODE_RAM,
> +	CXL_DECODER_MODE_DC0,
> +	CXL_DECODER_MODE_DC1,
> +	CXL_DECODER_MODE_DC2,
> +	CXL_DECODER_MODE_DC3,
> +	CXL_DECODER_MODE_DC4,
> +	CXL_DECODER_MODE_DC5,
> +	CXL_DECODER_MODE_DC6,
> +	CXL_DECODER_MODE_DC7,
>  };
>  
>  static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> @@ -205,9 +215,17 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
>  		[CXL_DECODER_MODE_MIXED] = "mixed",
>  		[CXL_DECODER_MODE_PMEM] = "pmem",
>  		[CXL_DECODER_MODE_RAM] = "ram",
> +		[CXL_DECODER_MODE_DC0] = "dc0",
> +		[CXL_DECODER_MODE_DC1] = "dc1",
> +		[CXL_DECODER_MODE_DC2] = "dc2",
> +		[CXL_DECODER_MODE_DC3] = "dc3",
> +		[CXL_DECODER_MODE_DC4] = "dc4",
> +		[CXL_DECODER_MODE_DC5] = "dc5",
> +		[CXL_DECODER_MODE_DC6] = "dc6",
> +		[CXL_DECODER_MODE_DC7] = "dc7",
>  	};
>  
> -	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
> +	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DC7)
>  		mode = CXL_DECODER_MODE_NONE;
>  	return names[mode];
>  }
> @@ -221,9 +239,35 @@ cxl_decoder_mode_from_ident(const char *ident)
>  		return CXL_DECODER_MODE_RAM;
>  	else if (strcmp(ident, "pmem") == 0)
>  		return CXL_DECODER_MODE_PMEM;
> +	else if (strcmp(ident, "dc0") == 0)
> +		return CXL_DECODER_MODE_DC0;
> +	else if (strcmp(ident, "dc1") == 0)
> +		return CXL_DECODER_MODE_DC1;
> +	else if (strcmp(ident, "dc2") == 0)
> +		return CXL_DECODER_MODE_DC2;
> +	else if (strcmp(ident, "dc3") == 0)
> +		return CXL_DECODER_MODE_DC3;
> +	else if (strcmp(ident, "dc4") == 0)
> +		return CXL_DECODER_MODE_DC4;
> +	else if (strcmp(ident, "dc5") == 0)
> +		return CXL_DECODER_MODE_DC5;
> +	else if (strcmp(ident, "dc6") == 0)
> +		return CXL_DECODER_MODE_DC6;
> +	else if (strcmp(ident, "dc7") == 0)
> +		return CXL_DECODER_MODE_DC7;
>  	return CXL_DECODER_MODE_NONE;
>  }
>  
> +static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
> +{
> +	return (mode >= CXL_DECODER_MODE_DC0 && mode <= CXL_DECODER_MODE_DC7);
> +}
> +
> +static inline int cxl_decoder_dc_mode_to_index(enum cxl_decoder_mode mode)
> +{
> +	return mode - CXL_DECODER_MODE_DC0;
> +}
> +
>  enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
>  int cxl_decoder_set_mode(struct cxl_decoder *decoder,
>  			 enum cxl_decoder_mode mode);
> @@ -248,6 +292,7 @@ enum cxl_decoder_target_type {
>  enum cxl_decoder_target_type
>  cxl_decoder_get_target_type(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
> +bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, int index);
>  bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
> @@ -258,6 +303,8 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
> +struct cxl_region *cxl_decoder_create_dc_region(struct cxl_decoder *decoder,
> +						enum cxl_decoder_mode mode);
>  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
>  					    const char *ident);
>  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
> @@ -308,6 +355,7 @@ enum cxl_region_mode {
>  	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
>  	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
>  	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
> +	CXL_REGION_MODE_DC,
>  };
>  
>  static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
> @@ -317,9 +365,10 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
>  		[CXL_REGION_MODE_MIXED] = "mixed",
>  		[CXL_REGION_MODE_PMEM] = "pmem",
>  		[CXL_REGION_MODE_RAM] = "ram",
> +		[CXL_REGION_MODE_DC] = "dc",
>  	};
>  
> -	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
> +	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_DC)
>  		mode = CXL_REGION_MODE_NONE;
>  	return names[mode];
>  }
> @@ -333,6 +382,8 @@ cxl_region_mode_from_ident(const char *ident)
>  		return CXL_REGION_MODE_RAM;
>  	else if (strcmp(ident, "pmem") == 0)
>  		return CXL_REGION_MODE_PMEM;
> +	else if (strcmp(ident, "dc") == 0)
> +		return CXL_REGION_MODE_DC;
>  	return CXL_REGION_MODE_NONE;
>  }
>  
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 6e44d1578d03b6af998502e54714635b8f31b556..0a7d350efe9e612cd67d32328cca286dcdcb2991 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -269,8 +269,13 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
>  
>  	if (mode == CXL_DECODER_MODE_RAM)
>  		avail_dpa = cxl_memdev_get_ram_size(memdev);
> -	else
> +	else if (mode == CXL_DECODER_MODE_PMEM)
>  		avail_dpa = cxl_memdev_get_pmem_size(memdev);
> +	else if (cxl_decoder_mode_is_dc(mode)) {
> +		int i = cxl_decoder_dc_mode_to_index(mode);
> +
> +		avail_dpa = cxl_memdev_get_dc_size(memdev, i);
> +	}
>  
>  	cxl_decoder_foreach(port, decoder) {
>  		size = cxl_decoder_get_dpa_size(decoder);
> diff --git a/cxl/region.c b/cxl/region.c
> index 207cf2d003148992255c715f286bc0f38de2ca84..310694ae07fae25f13d032a30c130bf7d3394388 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -78,7 +78,7 @@ OPT_INTEGER('w', "ways", &param.ways, \
>  OPT_INTEGER('g', "granularity", &param.granularity,  \
>  	    "granularity of the interleave set"), \
>  OPT_STRING('t', "type", &param.type, \
> -	   "region type", "region type - 'pmem' or 'ram'"), \
> +	   "region type", "region type - 'pmem', 'ram', 'dcX'"), \
>  OPT_STRING('U', "uuid", &param.uuid, \
>  	   "region uuid", "uuid for the new region (default: autogenerate)"), \
>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
> @@ -400,9 +400,22 @@ static int parse_region_options(int argc, const char **argv,
>  	}
>  }
>  
> +static int dc_mode_to_region_index(enum cxl_decoder_mode mode)
> +{
> +	int index = 0;
> +
> +	for (unsigned int i = CXL_DECODER_MODE_DC0; i <= CXL_DECODER_MODE_DC7; i++) {
> +		if (mode == i)
> +			return index;
> +		index++;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
>  {
> -	int i;
> +	int i, index;
>  
>  	for (i = 0; i < p->ways; i++) {
>  		struct json_object *jobj =
> @@ -417,6 +430,10 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
>  		case CXL_DECODER_MODE_PMEM:
>  			size = cxl_memdev_get_pmem_size(memdev);
>  			break;
> +		case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
> +			index =  dc_mode_to_region_index(p->mode);
> +			size = cxl_memdev_get_dc_size(memdev, index);
> +			break;
>  		default:
>  			/* Shouldn't ever get here */ ;
>  		}
> @@ -473,6 +490,7 @@ static int validate_decoder(struct cxl_decoder *decoder,
>  			    struct parsed_params *p)
>  {
>  	const char *devname = cxl_decoder_get_devname(decoder);
> +	int index;
>  	int rc;
>  
>  	switch(p->mode) {
> @@ -488,6 +506,13 @@ static int validate_decoder(struct cxl_decoder *decoder,
>  			return -EINVAL;
>  		}
>  		break;
> +	case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
> +		index =  dc_mode_to_region_index(p->mode);
> +		if (!cxl_decoder_is_dc_capable(decoder, index)) {
> +			log_err(&rl, "%s is not dc%d capable\n", devname, index);
> +			return -EINVAL;
> +		}
> +		break;
>  	default:
>  		log_err(&rl, "unknown type: %s\n", param.type);
>  		return -EINVAL;
> @@ -502,12 +527,25 @@ static int validate_decoder(struct cxl_decoder *decoder,
>  	return 0;
>  }
>  
> +static enum cxl_decoder_mode dc_region_index_to_mode(int index)
> +{
> +	return (CXL_DECODER_MODE_DC0 + index);
> +}
> +
>  static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>  {
>  	/* if param.type was explicitly specified, nothing to do here */
>  	if (param.type)
>  		return;
>  
> +	/* Only chose DC if it is the only type available */
> +	for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
> +		if (cxl_decoder_is_dc_capable(p->root_decoder, index)) {
> +			p->mode = dc_region_index_to_mode(index);
> +			break;
> +		}
> +	}
> +
>  	/*
>  	 * default to pmem if both types are set, otherwise the single
>  	 * capability dominates.
> @@ -699,6 +737,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  				param.root_decoder);
>  			return -ENXIO;
>  		}
> +	} else if (cxl_decoder_mode_is_dc(p->mode)) {
> +		region = cxl_decoder_create_dc_region(p->root_decoder, p->mode);
> +		if (!region) {
> +			log_err(&rl, "failed to create region under %s\n",
> +				param.root_decoder);
> +			return -ENXIO;
> +		}
>  	} else {
>  		log_err(&rl, "region type '%s' is not supported\n",
>  			param.type);
> 
> -- 
> 2.47.0
> 

-- 
Fan Ni

