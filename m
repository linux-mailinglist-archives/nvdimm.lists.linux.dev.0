Return-Path: <nvdimm+bounces-2798-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AE64A6D75
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 10:03:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 678863E0FFF
	for <lists+linux-nvdimm@lfdr.de>; Wed,  2 Feb 2022 09:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786172CA1;
	Wed,  2 Feb 2022 09:03:37 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E7F2F25
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 09:03:35 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2127BaA9003119;
	Wed, 2 Feb 2022 09:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=o6CASbL39jGOvJT/f4lnwIj4vwO5HWj+YmtE/MIN+/8=;
 b=WYfQroQl5G4ACT9/5kKlH2UVVk7Au7kqa8aX975j6Y8Kd5QKNKKSzyK5BNJ+6Ltd8xkN
 7ayo3/Cn3DA95LA3x8tx69XDwC9oJgPEEEXSkVbuJ4eg59LG3zJncs2iApWLEy4PSx9z
 sXQDe7vMtok01sR529Vta9U6fJGl0B+nS3kKsckYVEqX48+48PzcbfbWnIJvBU1wcJks
 h+zDkPH//OD4jXUDbns1k0+PzR6IRzmyW0KH72p3U7XdnLhdMSZITbizDEjeWbOc7gqL
 YyD2gwNDZ49mZiuClfbvb0z63d5cEPNb9Rz429rNr9UhboLcfEMu1vO47CYtsqJLLPsd PQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dynbmsty9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Feb 2022 09:03:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
	by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21292dkn030654;
	Wed, 2 Feb 2022 09:03:18 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by ppma02dal.us.ibm.com with ESMTP id 3dvw7b9uwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Feb 2022 09:03:17 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21293Gsq21168398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Feb 2022 09:03:16 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44BDEC605D;
	Wed,  2 Feb 2022 09:03:16 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A3BCC605A;
	Wed,  2 Feb 2022 09:03:13 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.57.115])
	by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
	Wed,  2 Feb 2022 09:03:12 +0000 (GMT)
X-Mailer: emacs 29.0.50 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v4] powerpc/papr_scm: Implement initial support for
 injecting smart errors
In-Reply-To: <20220124202204.1488346-1-vaibhav@linux.ibm.com>
References: <20220124202204.1488346-1-vaibhav@linux.ibm.com>
Date: Wed, 02 Feb 2022 14:33:10 +0530
Message-ID: <8735l18wtt.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4F-1E3cGoWwhB0NOCyo5jc1fCFPdV1_i
X-Proofpoint-ORIG-GUID: 4F-1E3cGoWwhB0NOCyo5jc1fCFPdV1_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_03,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 spamscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202020047

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Presently PAPR doesn't support injecting smart errors on an
> NVDIMM. This makes testing the NVDIMM health reporting functionality
> difficult as simulating NVDIMM health related events need a hacked up
> qemu version.
>
> To solve this problem this patch proposes simulating certain set of
> NVDIMM health related events in papr_scm. Specifically 'fatal' health
> state and 'dirty' shutdown state. These error can be injected via the
> user-space 'ndctl-inject-smart(1)' command. With the proposed patch and
> corresponding ndctl patches following command flow is expected:
>
> $ sudo ndctl list -DH -d nmem0
> ...
>       "health_state":"ok",
>       "shutdown_state":"clean",
> ...
>  # inject unsafe shutdown and fatal health error
> $ sudo ndctl inject-smart nmem0 -Uf
> ...
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
> ...
>  # uninject all errors
> $ sudo ndctl inject-smart nmem0 -N
> ...
>       "health_state":"ok",
>       "shutdown_state":"clean",
> ...
>
> The patch adds a new member 'health_bitmap_inject_mask' inside struct
> papr_scm_priv which is then bitwise ANDed to the health bitmap fetched from the
> hypervisor. The value for 'health_bitmap_inject_mask' is accessible from sysfs
> at nmemX/papr/health_bitmap_inject.
>
> A new PDSM named 'SMART_INJECT' is proposed that accepts newly
> introduced 'struct nd_papr_pdsm_smart_inject' as payload thats
> exchanged between libndctl and papr_scm to indicate the requested
> smart-error states.
>
> When the processing the PDSM 'SMART_INJECT', papr_pdsm_smart_inject()
> constructs a pair or 'inject_mask' and 'clear_mask' bitmaps from the payload
> and bit-blt it to the 'health_bitmap_inject_mask'. This ensures the after being
> fetched from the hypervisor, the health_bitmap reflects requested smart-error
> states.
>

 Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
> Changelog:
>
> Since v3:
> * Renamed the sysfs entry from 'health_bitmap_override' to
> 'health_bitmap_inject'.
> * Simplified the variable names and removed the 'health_bitmap_{mask,override}'
> members. Instead replaced them with a single 'health_bitmap_inject_mask'
> member. [Aneesh]
> * Updated the sysfs documentations and commit description.
> * Used READ/WRITE_ONCE macros at places where 'health_bitmap_inject_mask' may be
> accessed concurrently.
>
> Since v2:
> * Rebased the patch to ppc-next
> * Added documentation for newly introduced sysfs attribute 'health_bitmap_override'
>
> Since v1:
> * Updated the patch description.
> * Removed dependency of a header movement patch.
> * Removed '__packed' attribute for 'struct nd_papr_pdsm_smart_inject' [Aneesh]
> ---
>  Documentation/ABI/testing/sysfs-bus-papr-pmem | 12 +++
>  arch/powerpc/include/uapi/asm/papr_pdsm.h     | 18 ++++
>  arch/powerpc/platforms/pseries/papr_scm.c     | 90 ++++++++++++++++++-
>  3 files changed, 117 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
> index 95254cec92bf..4ac0673901e7 100644
> --- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
> +++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
> @@ -61,3 +61,15 @@ Description:
>  		* "CchRHCnt" : Cache Read Hit Count
>  		* "CchWHCnt" : Cache Write Hit Count
>  		* "FastWCnt" : Fast Write Count
> +
> +What:		/sys/bus/nd/devices/nmemX/papr/health_bitmap_inject
> +Date:		Jan, 2022
> +KernelVersion:	v5.17
> +Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nvdimm@lists.linux.dev,
> +Description:
> +		(RO) Reports the health bitmap inject bitmap that is applied to
> +		bitmap received from PowerVM via the H_SCM_HEALTH. This is used
> +		to forcibly set specific bits returned from Hcall. These is then
> +		used to simulate various health or shutdown states for an nvdimm
> +		and are set by user-space tools like ndctl by issuing a PAPR DSM.
> +
> diff --git a/arch/powerpc/include/uapi/asm/papr_pdsm.h b/arch/powerpc/include/uapi/asm/papr_pdsm.h
> index 82488b1e7276..17439925045c 100644
> --- a/arch/powerpc/include/uapi/asm/papr_pdsm.h
> +++ b/arch/powerpc/include/uapi/asm/papr_pdsm.h
> @@ -116,6 +116,22 @@ struct nd_papr_pdsm_health {
>  	};
>  };
>  
> +/* Flags for injecting specific smart errors */
> +#define PDSM_SMART_INJECT_HEALTH_FATAL		(1 << 0)
> +#define PDSM_SMART_INJECT_BAD_SHUTDOWN		(1 << 1)
> +
> +struct nd_papr_pdsm_smart_inject {
> +	union {
> +		struct {
> +			/* One or more of PDSM_SMART_INJECT_ */
> +			__u32 flags;
> +			__u8 fatal_enable;
> +			__u8 unsafe_shutdown_enable;
> +		};
> +		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
> +	};
> +};
> +
>  /*
>   * Methods to be embedded in ND_CMD_CALL request. These are sent to the kernel
>   * via 'nd_cmd_pkg.nd_command' member of the ioctl struct
> @@ -123,12 +139,14 @@ struct nd_papr_pdsm_health {
>  enum papr_pdsm {
>  	PAPR_PDSM_MIN = 0x0,
>  	PAPR_PDSM_HEALTH,
> +	PAPR_PDSM_SMART_INJECT,
>  	PAPR_PDSM_MAX,
>  };
>  
>  /* Maximal union that can hold all possible payload types */
>  union nd_pdsm_payload {
>  	struct nd_papr_pdsm_health health;
> +	struct nd_papr_pdsm_smart_inject smart_inject;
>  	__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>  } __packed;
>  
> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> index f48e87ac89c9..20aafd387840 100644
> --- a/arch/powerpc/platforms/pseries/papr_scm.c
> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> @@ -120,6 +120,10 @@ struct papr_scm_priv {
>  
>  	/* length of the stat buffer as expected by phyp */
>  	size_t stat_buffer_len;
> +
> +	/* The bits which needs to be overridden */
> +	u64 health_bitmap_inject_mask;
> +
>  };
>  
>  static int papr_scm_pmem_flush(struct nd_region *nd_region,
> @@ -347,19 +351,29 @@ static ssize_t drc_pmem_query_stats(struct papr_scm_priv *p,
>  static int __drc_pmem_query_health(struct papr_scm_priv *p)
>  {
>  	unsigned long ret[PLPAR_HCALL_BUFSIZE];
> +	u64 bitmap = 0;
>  	long rc;
>  
>  	/* issue the hcall */
>  	rc = plpar_hcall(H_SCM_HEALTH, ret, p->drc_index);
> -	if (rc != H_SUCCESS) {
> +	if (rc == H_SUCCESS)
> +		bitmap = ret[0] & ret[1];
> +	else if (rc == H_FUNCTION)
> +		dev_info_once(&p->pdev->dev,
> +			      "Hcall H_SCM_HEALTH not implemented, assuming empty health bitmap");
> +	else {
> +
>  		dev_err(&p->pdev->dev,
>  			"Failed to query health information, Err:%ld\n", rc);
>  		return -ENXIO;
>  	}
>  
>  	p->lasthealth_jiffies = jiffies;
> -	p->health_bitmap = ret[0] & ret[1];
> -
> +	/* Allow injecting specific health bits via inject mask. */
> +	if (p->health_bitmap_inject_mask)
> +		bitmap = (bitmap & ~p->health_bitmap_inject_mask) |
> +			p->health_bitmap_inject_mask;
> +	WRITE_ONCE(p->health_bitmap, bitmap);
>  	dev_dbg(&p->pdev->dev,
>  		"Queried dimm health info. Bitmap:0x%016lx Mask:0x%016lx\n",
>  		ret[0], ret[1]);
> @@ -669,6 +683,56 @@ static int papr_pdsm_health(struct papr_scm_priv *p,
>  	return rc;
>  }
>  
> +/* Inject a smart error Add the dirty-shutdown-counter value to the pdsm */
> +static int papr_pdsm_smart_inject(struct papr_scm_priv *p,
> +				  union nd_pdsm_payload *payload)
> +{
> +	int rc;
> +	u32 supported_flags = 0;
> +	u64 inject_mask = 0, clear_mask = 0;
> +	u64 mask;
> +
> +	/* Check for individual smart error flags and update inject/clear masks */
> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_HEALTH_FATAL) {
> +		supported_flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
> +		if (payload->smart_inject.fatal_enable)
> +			inject_mask |= PAPR_PMEM_HEALTH_FATAL;
> +		else
> +			clear_mask |= PAPR_PMEM_HEALTH_FATAL;
> +	}
> +
> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_BAD_SHUTDOWN) {
> +		supported_flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
> +		if (payload->smart_inject.unsafe_shutdown_enable)
> +			inject_mask |= PAPR_PMEM_SHUTDOWN_DIRTY;
> +		else
> +			clear_mask |= PAPR_PMEM_SHUTDOWN_DIRTY;
> +	}
> +
> +	dev_dbg(&p->pdev->dev, "[Smart-inject] inject_mask=%#llx clear_mask=%#llx\n",
> +		inject_mask, clear_mask);
> +
> +	/* Prevent concurrent access to dimm health bitmap related members */
> +	rc = mutex_lock_interruptible(&p->health_mutex);
> +	if (rc)
> +		return rc;
> +
> +	/* Use inject/clear masks to set health_bitmap_inject_mask */
> +	mask = READ_ONCE(p->health_bitmap_inject_mask);
> +	mask = (mask & ~clear_mask) | inject_mask;
> +	WRITE_ONCE(p->health_bitmap_inject_mask, mask);
> +
> +	/* Invalidate cached health bitmap */
> +	p->lasthealth_jiffies = 0;
> +
> +	mutex_unlock(&p->health_mutex);
> +
> +	/* Return the supported flags back to userspace */
> +	payload->smart_inject.flags = supported_flags;
> +
> +	return sizeof(struct nd_papr_pdsm_health);
> +}
> +
>  /*
>   * 'struct pdsm_cmd_desc'
>   * Identifies supported PDSMs' expected length of in/out payloads
> @@ -702,6 +766,12 @@ static const struct pdsm_cmd_desc __pdsm_cmd_descriptors[] = {
>  		.size_out = sizeof(struct nd_papr_pdsm_health),
>  		.service = papr_pdsm_health,
>  	},
> +
> +	[PAPR_PDSM_SMART_INJECT] = {
> +		.size_in = sizeof(struct nd_papr_pdsm_smart_inject),
> +		.size_out = sizeof(struct nd_papr_pdsm_smart_inject),
> +		.service = papr_pdsm_smart_inject,
> +	},
>  	/* Empty */
>  	[PAPR_PDSM_MAX] = {
>  		.size_in = 0,
> @@ -838,6 +908,19 @@ static int papr_scm_ndctl(struct nvdimm_bus_descriptor *nd_desc,
>  	return 0;
>  }
>  
> +static ssize_t health_bitmap_inject_show(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct nvdimm *dimm = to_nvdimm(dev);
> +	struct papr_scm_priv *p = nvdimm_provider_data(dimm);
> +
> +	return sprintf(buf, "%#llx\n",
> +		       READ_ONCE(p->health_bitmap_inject_mask));
> +}
> +
> +static DEVICE_ATTR_ADMIN_RO(health_bitmap_inject);
> +
>  static ssize_t perf_stats_show(struct device *dev,
>  			       struct device_attribute *attr, char *buf)
>  {
> @@ -952,6 +1035,7 @@ static struct attribute *papr_nd_attributes[] = {
>  	&dev_attr_flags.attr,
>  	&dev_attr_perf_stats.attr,
>  	&dev_attr_dirty_shutdown.attr,
> +	&dev_attr_health_bitmap_inject.attr,
>  	NULL,
>  };
>  
> -- 
> 2.34.1

