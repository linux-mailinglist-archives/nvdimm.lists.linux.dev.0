Return-Path: <nvdimm+bounces-7140-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1A181EB9B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 Dec 2023 03:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 599FE1C221B7
	for <lists+linux-nvdimm@lfdr.de>; Wed, 27 Dec 2023 02:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15C223C5;
	Wed, 27 Dec 2023 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dmHIiMJ/"
X-Original-To: nvdimm@lists.linux.dev
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1920F4
	for <nvdimm@lists.linux.dev>; Wed, 27 Dec 2023 02:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703645503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmZLPQJsVtVQHC/JLIPTyVYQXOj/3YM37JIK9qxubc0=;
	b=dmHIiMJ/SS+2zTIcwCyeXurtI45gK0/LVF5P0BSMAGQfz8fPiL6fequwQ7kw/6c0+kZ1Uk
	upb2pd3XscALMxsvPaQqJ+alDGSXf2uFndCj+rz5McReNRys/BvB36V44Vn05/FB2SITGM
	LuxKD4uePRPdmIK2bAcL1KJNpPhllVM=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-kScb362QNLyjk_q9PCXkbA-1; Tue, 26 Dec 2023 21:51:42 -0500
X-MC-Unique: kScb362QNLyjk_q9PCXkbA-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6dbfebd2767so892277a34.2
        for <nvdimm@lists.linux.dev>; Tue, 26 Dec 2023 18:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703645501; x=1704250301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmZLPQJsVtVQHC/JLIPTyVYQXOj/3YM37JIK9qxubc0=;
        b=MBQvt90lTR5qd0WM35E1dNbCcL7TVuNmqyqzwtprzBCtlwXbR8mJbt4Sz53+q+0Lvm
         onPWbrH32mXqHvUHPnqpCSnkPy4pILvXHlhhkiDBFGUobcxwc8qnLKkbKPuInDVtU2YK
         SFmvaR88qVfBhCvoHV6NDyo2+QfQmY7TSkTgw+dOFcxb+TmQW2AeinfK7MxoTk8oODnz
         2OPnw5NfyUhAx5Ynd6UsQd9NL+lQye4IsesuUseUU2hKAtirRJvSPuIEbyrL0Gxw9JVM
         XaHcQvqBcMogs2//98JXzaN8bFCSdRk1I1vyAJq5swpY50QRE+KXblM8ecMMc5wiqRtW
         gaGQ==
X-Gm-Message-State: AOJu0YxC7I1hJ9o/jrnmJWhnVz/UR9jQ6233CYoiYitOn6JCeJVw4Zwh
	O9JQ019vdcAPemnG98qN1uk7WKZ/Z1cr5ywnPX/MixqIAC1D4SadWYf3gArn+8/0k+lOhIX9Aja
	3ws93Gc92OKajJgzNwubtW2o72+TJeUMV1Vbna+M9
X-Received: by 2002:a05:6808:200c:b0:3ba:30dc:56cf with SMTP id q12-20020a056808200c00b003ba30dc56cfmr9655177oiw.76.1703645501554;
        Tue, 26 Dec 2023 18:51:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeFdi768mrXfzCB8lo5YDxnHvJui2SAOMX1WmHMi8zTEG0EvNWBLg7ICwAAWhGxQMdGlhXs9/SYx6CwbQ5OLM=
X-Received: by 2002:a05:6808:200c:b0:3ba:30dc:56cf with SMTP id
 q12-20020a056808200c00b003ba30dc56cfmr9655170oiw.76.1703645501355; Tue, 26
 Dec 2023 18:51:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231220023653-mutt-send-email-mst@kernel.org> <20231220204906.566922-1-changyuanl@google.com>
In-Reply-To: <20231220204906.566922-1-changyuanl@google.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 27 Dec 2023 10:51:30 +0800
Message-ID: <CACGkMEuZUbkWGcrmuSFdpFmk7gbZvV3Rr6mqdhfYF1W13_Yw6Q@mail.gmail.com>
Subject: Re: [PATCH v4] virtio_pmem: support feature SHMEM_REGION
To: Changyuan Lyu <changyuanl@google.com>
Cc: mst@redhat.com, dan.j.williams@intel.com, dave.jiang@intel.com, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	pankaj.gupta.linux@gmail.com, virtualization@lists.linux.dev, 
	vishal.l.verma@intel.com, xuanzhuo@linux.alibaba.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 4:49=E2=80=AFAM Changyuan Lyu <changyuanl@google.co=
m> wrote:
>
> Thanks Michael for the feedback!
>
> On Tue, Dec 19, 2023 at 11:44 PM Michael S. Tsirkin <mst@redhat.com> wrot=
e:
> >
> > > On Tue, Dec 19, 2023 at 11:32:27PM -0800, Changyuan Lyu wrote:
> > >
> > > +           if (!have_shm) {
> > > +                   dev_err(&vdev->dev, "failed to get shared memory =
region %d\n",
> > > +                                   VIRTIO_PMEM_SHMEM_REGION_ID);
> > > +                   err =3D -ENXIO;
> > > +                   goto out_vq;
> > > +           }
> >
> > Maybe additionally, add a validate callback and clear
> > VIRTIO_PMEM_F_SHMEM_REGION if VIRTIO_PMEM_SHMEM_REGION_ID is not there.
>
> Done.
>
> > > +/* Feature bits */
> > > +#define VIRTIO_PMEM_F_SHMEM_REGION 0       /* guest physical address=
 range will be
> > > +                                    * indicated as shared memory reg=
ion 0
> > > +                                    */
> >
> > Either make this comment shorter to fit in one line, or put the
> > multi-line comment before the define.
>
> Done.
>
> ---8<---
>
> This patch adds the support for feature VIRTIO_PMEM_F_SHMEM_REGION
> (virtio spec v1.2 section 5.19.5.2 [1]).
>
> During feature negotiation, if VIRTIO_PMEM_F_SHMEM_REGION is offered
> by the device, the driver looks for a shared memory region of id 0.
> If it is found, this feature is understood. Otherwise, this feature
> bit is cleared.
>
> During probe, if VIRTIO_PMEM_F_SHMEM_REGION has been negotiated,
> virtio pmem ignores the `start` and `size` fields in device config
> and uses the physical address range of shared memory region 0.
>
> [1] https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd0=
1.html#x1-6480002
>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
> v4:
>   * added virtio_pmem_validate callback.
> v3:
>   * updated the patch description.
> V2:
>   * renamed VIRTIO_PMEM_SHMCAP_ID to VIRTIO_PMEM_SHMEM_REGION_ID
>   * fixed the error handling when region 0 does not exist
> ---
>  drivers/nvdimm/virtio_pmem.c     | 36 ++++++++++++++++++++++++++++----
>  include/uapi/linux/virtio_pmem.h |  7 +++++++
>  2 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index a92eb172f0e7..4ceced5cefcf 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -29,12 +29,27 @@ static int init_vq(struct virtio_pmem *vpmem)
>         return 0;
>  };
>
> +static int virtio_pmem_validate(struct virtio_device *vdev)
> +{
> +       struct virtio_shm_region shm_reg;
> +
> +       if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION) &&
> +               !virtio_get_shm_region(vdev, &shm_reg, (u8)VIRTIO_PMEM_SH=
MEM_REGION_ID)
> +       ) {
> +               dev_notice(&vdev->dev, "failed to get shared memory regio=
n %d\n",
> +                               VIRTIO_PMEM_SHMEM_REGION_ID);
> +               __virtio_clear_bit(vdev, VIRTIO_PMEM_F_SHMEM_REGION);
> +       }
> +       return 0;
> +}
> +
>  static int virtio_pmem_probe(struct virtio_device *vdev)
>  {
>         struct nd_region_desc ndr_desc =3D {};
>         struct nd_region *nd_region;
>         struct virtio_pmem *vpmem;
>         struct resource res;
> +       struct virtio_shm_region shm_reg;
>         int err =3D 0;
>
>         if (!vdev->config->get) {
> @@ -57,10 +72,16 @@ static int virtio_pmem_probe(struct virtio_device *vd=
ev)
>                 goto out_err;
>         }
>
> -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -                       start, &vpmem->start);
> -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -                       size, &vpmem->size);
> +       if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
> +               virtio_get_shm_region(vdev, &shm_reg, (u8)VIRTIO_PMEM_SHM=
EM_REGION_ID);
> +               vpmem->start =3D shm_reg.addr;
> +               vpmem->size =3D shm_reg.len;
> +       } else {
> +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +                               start, &vpmem->start);
> +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +                               size, &vpmem->size);
> +       }
>
>         res.start =3D vpmem->start;
>         res.end   =3D vpmem->start + vpmem->size - 1;
> @@ -122,10 +143,17 @@ static void virtio_pmem_remove(struct virtio_device=
 *vdev)
>         virtio_reset_device(vdev);
>  }
>
> +static unsigned int features[] =3D {
> +       VIRTIO_PMEM_F_SHMEM_REGION,
> +};
> +
>  static struct virtio_driver virtio_pmem_driver =3D {
> +       .feature_table          =3D features,
> +       .feature_table_size     =3D ARRAY_SIZE(features),
>         .driver.name            =3D KBUILD_MODNAME,
>         .driver.owner           =3D THIS_MODULE,
>         .id_table               =3D id_table,
> +       .validate               =3D virtio_pmem_validate,
>         .probe                  =3D virtio_pmem_probe,
>         .remove                 =3D virtio_pmem_remove,
>  };
> diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio=
_pmem.h
> index d676b3620383..ede4f3564977 100644
> --- a/include/uapi/linux/virtio_pmem.h
> +++ b/include/uapi/linux/virtio_pmem.h
> @@ -14,6 +14,13 @@
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
>
> +/* Feature bits */
> +/* guest physical address range will be indicated as shared memory regio=
n 0 */
> +#define VIRTIO_PMEM_F_SHMEM_REGION 0
> +
> +/* shmid of the shared memory region corresponding to the pmem */
> +#define VIRTIO_PMEM_SHMEM_REGION_ID 0
> +
>  struct virtio_pmem_config {
>         __le64 start;
>         __le64 size;
> --
> 2.43.0.472.g3155946c3a-goog
>


