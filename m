Return-Path: <nvdimm+bounces-272-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 542113B2552
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Jun 2021 05:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 1F96C1C0E56
	for <lists+linux-nvdimm@lfdr.de>; Thu, 24 Jun 2021 03:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C0B6D0D;
	Thu, 24 Jun 2021 03:17:25 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from ozlabs.org (ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19D02FB6
	for <nvdimm@lists.linux.dev>; Thu, 24 Jun 2021 03:17:22 +0000 (UTC)
Received: by ozlabs.org (Postfix, from userid 1007)
	id 4G9QKr3bV4z9sjD; Thu, 24 Jun 2021 13:17:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=gibson.dropbear.id.au; s=201602; t=1624504640;
	bh=bWpkMV1GoAPLGjKvnT7D1NkoVkzaXZbs9Np3gm+6x98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lS5+aZvCTDU85t9l/OAVvN+rKvZeiC6b/k3uIDYmt7/4MHL7iJAvp3RA7ogRgVmsQ
	 MPqlAL9uEhubKjzvQBVF79sWFDVhRgv83nnmBFDrCAW0lB77s/CkJg04QsRAlh2Vtk
	 PfaX6y3WlKUzwMagJPPgUBJPjcUU7clMO4JRLZ2Q=
Date: Thu, 24 Jun 2021 13:11:32 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH v4 4/7] powerpc/pseries: Consolidate DLPAR NUMA distance
 update
Message-ID: <YNP35EN3ioj5q6AW@yekko>
References: <20210617165105.574178-1-aneesh.kumar@linux.ibm.com>
 <20210617165105.574178-5-aneesh.kumar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LepjA2U5dklhB850"
Content-Disposition: inline
In-Reply-To: <20210617165105.574178-5-aneesh.kumar@linux.ibm.com>


--LepjA2U5dklhB850
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 10:21:02PM +0530, Aneesh Kumar K.V wrote:
> The associativity details of the newly added resourced are collected from
> the hypervisor via "ibm,configure-connector" rtas call. Update the numa
> distance details of the newly added numa node after the above call. In
> later patch we will remove updating NUMA distance when we are looking
> for node id from associativity array.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

I think this patch and the next would be easier to review if merged
together.  That would make the fact that this is (half of) a code
motion clearer.

> ---
>  arch/powerpc/mm/numa.c                        | 41 +++++++++++++++++++
>  arch/powerpc/platforms/pseries/hotplug-cpu.c  |  2 +
>  .../platforms/pseries/hotplug-memory.c        |  2 +
>  arch/powerpc/platforms/pseries/pseries.h      |  1 +
>  4 files changed, 46 insertions(+)
>=20
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 0ec16999beef..645a95e3a7ea 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -287,6 +287,47 @@ int of_node_to_nid(struct device_node *device)
>  }
>  EXPORT_SYMBOL(of_node_to_nid);
> =20
> +static void __initialize_form1_numa_distance(const __be32 *associativity)
> +{
> +	int i, nid;
> +
> +	if (of_read_number(associativity, 1) >=3D primary_domain_index) {
> +		nid =3D of_read_number(&associativity[primary_domain_index], 1);
> +
> +		for (i =3D 0; i < max_domain_index; i++) {
> +			const __be32 *entry;
> +
> +			entry =3D &associativity[be32_to_cpu(distance_ref_points[i])];
> +			distance_lookup_table[nid][i] =3D of_read_number(entry, 1);
> +		}
> +	}
> +}
> +
> +static void initialize_form1_numa_distance(struct device_node *node)
> +{
> +	const __be32 *associativity;
> +
> +	associativity =3D of_get_associativity(node);
> +	if (!associativity)
> +		return;
> +
> +	__initialize_form1_numa_distance(associativity);
> +	return;
> +}
> +
> +/*
> + * Used to update distance information w.r.t newly added node.
> + */
> +void update_numa_distance(struct device_node *node)
> +{
> +	if (affinity_form =3D=3D FORM0_AFFINITY)
> +		return;
> +	else if (affinity_form =3D=3D FORM1_AFFINITY) {
> +		initialize_form1_numa_distance(node);
> +		return;
> +	}
> +}
> +
>  static int __init find_primary_domain_index(void)
>  {
>  	int index;
> diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/=
platforms/pseries/hotplug-cpu.c
> index 7e970f81d8ff..778b6ab35f0d 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> @@ -498,6 +498,8 @@ static ssize_t dlpar_cpu_add(u32 drc_index)
>  		return saved_rc;
>  	}
> =20
> +	update_numa_distance(dn);
> +
>  	rc =3D dlpar_online_cpu(dn);
>  	if (rc) {
>  		saved_rc =3D rc;
> diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/power=
pc/platforms/pseries/hotplug-memory.c
> index 8377f1f7c78e..0e602c3b01ea 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-memory.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
> @@ -180,6 +180,8 @@ static int update_lmb_associativity_index(struct drme=
m_lmb *lmb)
>  		return -ENODEV;
>  	}
> =20
> +	update_numa_distance(lmb_node);
> +
>  	dr_node =3D of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
>  	if (!dr_node) {
>  		dlpar_free_cc_nodes(lmb_node);
> diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/plat=
forms/pseries/pseries.h
> index 1f051a786fb3..663a0859cf13 100644
> --- a/arch/powerpc/platforms/pseries/pseries.h
> +++ b/arch/powerpc/platforms/pseries/pseries.h
> @@ -113,4 +113,5 @@ extern u32 pseries_security_flavor;
>  void pseries_setup_security_mitigations(void);
>  void pseries_lpar_read_hblkrm_characteristics(void);
> =20
> +void update_numa_distance(struct device_node *node);
>  #endif /* _PSERIES_PSERIES_H */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--LepjA2U5dklhB850
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDT9+QACgkQbDjKyiDZ
s5IImw//TTI3gZSPIX8P3mzFBXxeXho478ZYmNDV1IKIzBsnKIMRnGZsrOzSze1Q
N6u9Ryw4AocMqdVzLvutPToLJTcSRrKamfCWVvdqMOirBZG7prvupveKm96w+TK/
3gpEujch0J4ApGD5FS8NXXBFYQSfKiHzUgio8S9FTZxdD47V+MHwnWRmokHh498E
u8ujQIozPDQNiFwFaBYxywELyyYMnzjuheoWW17n/hqlk4ZU1dRZtbI3T0jqgyNZ
8M01o5H33/AfhfDwkAXMNv0wA6kXRQ5ShMlP2RGkDSIWnASLvCY4nPa2jrB3ORdp
KXvi5MiY1AqKko+A5xLpJIl0b6D9Sly+7g62jjbNWt7n6bGVIXCEJjiIgccjyLdG
izzp7r9XJM9Pcqsh0p+mAb/MTkikFnrMRqKAtE9hbn3Tqm//6QFfSs+S6eUaW50J
IJXq096N8Sd94sDCTcspvGnnLe4BEWBkao5PxvfykDYmJ6HXMXgKlxOPR97yMFda
QKx7W0Uhup5SLggu97r7Y77Lj1q9uzq8025IkZCH9DWbT2lieR+iOrLxKuysJQvn
H3lU3l9EMjuhgavygM61GgLZkS+mB8Kx5UEaolMz/jcdb8M7/nNOtKPg9WeO+O/h
a7hoyMS3XexyKhKt2N1lo+pceChs30iCrswx2ycGoet8ZVBFSZQ=
=iT3y
-----END PGP SIGNATURE-----

--LepjA2U5dklhB850--

