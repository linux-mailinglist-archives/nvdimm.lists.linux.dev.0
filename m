Return-Path: <nvdimm+bounces-2707-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [IPv6:2604:1380:1000:8100::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE304A51CD
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 22:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id 1EFDC3E0F04
	for <lists+linux-nvdimm@lfdr.de>; Mon, 31 Jan 2022 21:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB4A3FE5;
	Mon, 31 Jan 2022 21:44:00 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680FC2C82
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 21:43:58 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id a8so14016996pfa.6
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 13:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3jxXZThJIzE+4Gckt++FGSz2Pu9JjRopo3Xig1HrSHc=;
        b=bm/ITtXnJAD8LJUGDmeSbRM0VzFtUZbpQLz+fe9NO1jtm0zEh1YFv0w7rpmV0QuTUM
         KOuoX0HrFRAhgotl19/vPQo738rMhYe0ape2cBDj3f5on/+ZLrDd7G1jwp28eKzNoLPb
         Gwu0QSt2rkHVn9MWXj65Q4Nfj6fjpNbaFVSEN+6u6M/5bCNclkszdjoCKEnxNbvjZtdF
         fpc9D1snIXJpLrk3THD042HgEdgbda3Kb+7HlzQZbrqUBOEd2TWSqVj/FS9KAwLGra/J
         lJmfWX1Zm8riG8RLudJhP5y5Ohfsdsw2LTL0GgDqgmEgUsd89fLa3Gh5M/AsSLgjdYuz
         juSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3jxXZThJIzE+4Gckt++FGSz2Pu9JjRopo3Xig1HrSHc=;
        b=I08xjG9vks+F/lk7pf76eWCZ55YdEhEgFkYMSB6K8B11/ZLr56qYQ8WCU4f0r+9Qrw
         9oDsUUDLRggAfGuEM7WbdI6xkDb69HIQwMScJ0NqzFxoNAKrYJ+LU4RYYyTff79qcYwV
         wzwuZS4WVNoe8syAXj8rZ5t/h0+hMzsR608WXxQDpxcHc0n5hDsyjuvnHHPtN0Dp+Gx5
         zTpbjy2ZBRt2F7T2e8+0Aa1LrO26xCVnyQ8SgRgpobSrtH8xnZtrQI3243/K8j4TP+gY
         1w8kI7vT1IZIVynQoEwXQPQmi2Z5K5+BWUpq4gxF73GRxMdO0TfK1v+rW2qBMjhT/q1E
         +sqw==
X-Gm-Message-State: AOAM531OCWoAjsLqw3C9ZlNemJaQhyhwvBGWWRd1PPhAhRQHdsoNarln
	RmcbAX61Ey4IEWd1sP9/0CfIzjWOCQ+fG2qDdmtzlplADXk=
X-Google-Smtp-Source: ABdhPJzEa/9vbL2N945MJQj/FXMyvKX4BKl7uBKY3Lynyxr/tHKAKoiBX6hODCEUse1ZaD0Jhb4Pnl6ZixV5SFUJWTE=
X-Received: by 2002:a63:4717:: with SMTP id u23mr18605335pga.74.1643665437778;
 Mon, 31 Jan 2022 13:43:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298427918.3018233.8524862534398549106.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131183339.00004b6d@Huawei.com>
In-Reply-To: <20220131183339.00004b6d@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 13:43:49 -0800
Message-ID: <CAPcyv4g55upvoFpjF4+z8GHHH887nx6Hh6Hr0Z+Qws_HXiynww@mail.gmail.com>
Subject: Re: [PATCH v3 30/40] cxl/pci: Emit device serial number
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 10:34 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:31:19 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Per the CXL specification (8.1.12.2 Memory Device PCIe Capabilities and
> > Extended Capabilities) the Device Serial Number capability is mandatory.
> > Emit it for user tooling to identify devices.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Guess we should add this to the todo list for Qemu emulation.
> I wonder a bit if it is something that should really be done at the
> PCI device level.  Maybe a question for Bjorn.

The PCI layer can optionally emit it too, but on the CXL side I am
aiming to preserve its independence and the possibility of CXL
topologies with non-PCI devices in it. To date that has only proven
useful for the 'cxl_test' model, but as we've already seen with
ACPI0016 devices, sometimes all that is needed is a platform firmware
table to point to component registers in MMIO space to define a "CXL"
device.

> If not, then this is fine as far as I am concerned.

I can at least add the above note to the changelog to clarify.

>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl |    9 +++++++++
> >  drivers/cxl/core/memdev.c               |   11 +++++++++++
> >  drivers/cxl/cxlmem.h                    |    2 ++
> >  drivers/cxl/pci.c                       |    1 +
> >  tools/testing/cxl/test/mem.c            |    1 +
> >  5 files changed, 24 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 6d8cbf3355b5..87c0e5e65322 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -25,6 +25,15 @@ Description:
> >               identically named field in the Identify Memory Device Output
> >               Payload in the CXL-2.0 specification.
> >
> > +What:                /sys/bus/cxl/devices/memX/serial
> > +Date:                January, 2022
> > +KernelVersion:       v5.18
> > +Contact:     linux-cxl@vger.kernel.org
> > +Description:
> > +             (RO) 64-bit serial number per the PCIe Device Serial Number
> > +             capability. Mandatory for CXL devices, see CXL 2.0 8.1.12.2
> > +             Memory Device PCIe Capabilities and Extended Capabilities.
> > +
> >  What:                /sys/bus/cxl/devices/*/devtype
> >  Date:                June, 2021
> >  KernelVersion:       v5.14
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index 61029cb7ac62..1e574b052583 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -89,7 +89,18 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
> >  static struct device_attribute dev_attr_pmem_size =
> >       __ATTR(size, 0444, pmem_size_show, NULL);
> >
> > +static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
> > +                        char *buf)
> > +{
> > +     struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > +     struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +
> > +     return sysfs_emit(buf, "%#llx\n", cxlds->serial);
> > +}
> > +static DEVICE_ATTR_RO(serial);
> > +
> >  static struct attribute *cxl_memdev_attributes[] = {
> > +     &dev_attr_serial.attr,
> >       &dev_attr_firmware_version.attr,
> >       &dev_attr_payload_max.attr,
> >       &dev_attr_label_storage_size.attr,
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index e70838e5dc17..0ba0cf8dcdbc 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -131,6 +131,7 @@ struct cxl_endpoint_dvsec_info {
> >   * @next_persistent_bytes: persistent capacity change pending device reset
> >   * @component_reg_phys: register base of component registers
> >   * @info: Cached DVSEC information about the device.
> > + * @serial: PCIe Device Serial Number
> >   * @mbox_send: @dev specific transport for transmitting mailbox commands
> >   * @wait_media_ready: @dev specific method to await media ready
> >   *
> > @@ -164,6 +165,7 @@ struct cxl_dev_state {
> >
> >       resource_size_t component_reg_phys;
> >       struct cxl_endpoint_dvsec_info info;
> > +     u64 serial;
> >
> >       int (*mbox_send)(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd);
> >       int (*wait_media_ready)(struct cxl_dev_state *cxlds);
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 513cb0e2a70a..9252e1f4b18c 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -557,6 +557,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       if (IS_ERR(cxlds))
> >               return PTR_ERR(cxlds);
> >
> > +     cxlds->serial = pci_get_dsn(pdev);
> >       cxlds->cxl_dvsec = pci_find_dvsec_capability(
> >               pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC);
> >       if (!cxlds->cxl_dvsec) {
> > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > index 3af3f94de0c3..36ef337c775c 100644
> > --- a/tools/testing/cxl/test/mem.c
> > +++ b/tools/testing/cxl/test/mem.c
> > @@ -268,6 +268,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >       if (IS_ERR(cxlds))
> >               return PTR_ERR(cxlds);
> >
> > +     cxlds->serial = pdev->id;
> >       cxlds->mbox_send = cxl_mock_mbox_send;
> >       cxlds->wait_media_ready = cxl_mock_wait_media_ready;
> >       cxlds->payload_size = SZ_4K;
> >
>

