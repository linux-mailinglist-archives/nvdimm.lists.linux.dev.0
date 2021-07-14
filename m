Return-Path: <nvdimm+bounces-477-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sjc.edge.kernel.org (sjc.edge.kernel.org [147.75.69.165])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F55C3C808E
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Jul 2021 10:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sjc.edge.kernel.org (Postfix) with ESMTPS id A18E53E1071
	for <lists+linux-nvdimm@lfdr.de>; Wed, 14 Jul 2021 08:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DDA2FAF;
	Wed, 14 Jul 2021 08:44:20 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B2570;
	Wed, 14 Jul 2021 08:44:19 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id c20so340386uar.12;
        Wed, 14 Jul 2021 01:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r5k/nzvm++7I0kjlsxJbLPoLxldn2GkCJzAXrc4Q3tE=;
        b=gOcGreojsNbRIYOKX7kOgl/ufE/L+LqxyGLnyxvRl5Anx0Ya5qm94oYNaw6rVaK4f9
         93H6AgBtNXYspn0rZJ+yFqnYfUjuwnTRFeJ/ZIuM/uTGwod8W75AVOQxJSq+P5as0atV
         pHp6XaiIr+JYSzM/Zh1IY+Q6jHxcyJ6zoFJKkab1K/WXPwsLJYVerZxrgYs7Ntp7xvlz
         TNQk23Tt2gPZugCEoqqXFwL9OCCm37+yYZvyj82H0U3cTU5mm6851CigDqHoPFv3jklV
         Hqzhjfp8WKC+WvkDiObZRrgP8HDnXVNZ8Al9IseEjbqXGxvpiqfNGQIAn+EcnZX/AVIU
         MrvQ==
X-Gm-Message-State: AOAM532114POD1ju6cEg2bq3tYCtLHsnj+Zs37nO9oapq8U42jo38t31
	o5aj4VUQpXibIHIKHPxZ/wHWdu5lI7DntabwEzY=
X-Google-Smtp-Source: ABdhPJw+Y3tnjfY/zI+Y1qOhR0PNRzn2MQD3PHuwf/AzIRJfXjUIjP825Ll9FtnbmVsf04QAqWLG0Tq2dErAW2+m0rM=
X-Received: by 2002:a9f:3f0d:: with SMTP id h13mr12412958uaj.100.1626252258156;
 Wed, 14 Jul 2021 01:44:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210713193522.1770306-1-u.kleine-koenig@pengutronix.de> <20210713193522.1770306-6-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210713193522.1770306-6-u.kleine-koenig@pengutronix.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 14 Jul 2021 10:44:06 +0200
Message-ID: <CAMuHMdW8r6u4O5zv2ee-3=jPP6qwnOSHdSzf8pPE_y=jY3Bn5A@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] bus: Make remove callback return void
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sascha Hauer <kernel@pengutronix.de>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Alexandre Bounine <alex.bou9@gmail.com>, 
	Alex Dubov <oakad@yahoo.com>, Alex Elder <elder@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Alison Schofield <alison.schofield@intel.com>, 
	Allen Hubbe <allenbh@gmail.com>, Andreas Noever <andreas.noever@gmail.com>, 
	Andy Gross <agross@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	Benjamin Tissoires <benjamin.tissoires@redhat.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Chen-Yu Tsai <wens@csie.org>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Cornelia Huck <cohuck@redhat.com>, Cristian Marussi <cristian.marussi@arm.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"David S. Miller" <davem@davemloft.net>, David Woodhouse <dwmw@amazon.co.uk>, 
	Dexuan Cui <decui@microsoft.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, Finn Thain <fthain@linux-m68k.org>, 
	Florian Fainelli <f.fainelli@gmail.com>, Frank Li <lznuaa@gmail.com>, 
	Geoff Levand <geoff@infradead.org>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Ira Weiny <ira.weiny@intel.com>, 
	Jakub Kicinski <kuba@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Wang <jasowang@redhat.com>, Jens Taprogge <jens.taprogge@taprogge.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Jiri Slaby <jirislaby@kernel.org>, Joey Pabalan <jpabalanb@gmail.com>, 
	Johan Hovold <johan@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Johannes Thumshirn <morbidrsa@gmail.com>, Jon Mason <jdmason@kudzu.us>, Juergen Gross <jgross@suse.com>, 
	Julien Grall <jgrall@amazon.com>, Kai-Heng Feng <kai.heng.feng@canonical.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, Kishon Vijay Abraham I <kishon@ti.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>, 
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Manohar Vanga <manohar.vanga@gmail.com>, 
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, Mark Gross <mgross@linux.intel.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Martyn Welch <martyn@welchs.me.uk>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Matt Porter <mporter@kernel.crashing.org>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, 
	Maximilian Luz <luzmaximilian@gmail.com>, Maxim Levitsky <maximlevitsky@gmail.com>, 
	Michael Buesch <m@bues.ch>, Michael Ellerman <mpe@ellerman.id.au>, Michael Jamet <michael.jamet@intel.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	Mike Christie <michael.christie@oracle.com>, Moritz Fischer <mdf@kernel.org>, 
	Ohad Ben-Cohen <ohad@wizery.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Paul Mackerras <paulus@samba.org>, Peter Oberparleiter <oberpar@linux.ibm.com>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, 
	Rich Felker <dalias@libc.org>, Rikard Falkeborn <rikard.falkeborn@gmail.com>, 
	Rob Herring <robh@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>, Samuel Holland <samuel@sholland.org>, 
	Samuel Iglesias Gonsalvez <siglesias@igalia.com>, SeongJae Park <sjpark@amazon.de>, 
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, 
	Stephen Boyd <sboyd@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Sven Van Asbroeck <TheSven73@gmail.com>, 
	Takashi Iwai <tiwai@suse.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thorsten Scherer <t.scherer@eckelmann.de>, Tomas Winkler <tomas.winkler@intel.com>, 
	Tom Rix <trix@redhat.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Vasily Gorbik <gor@linux.ibm.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, Vinod Koul <vkoul@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Wei Liu <wei.liu@kernel.org>, 
	William Breathitt Gray <vilhelm.gray@gmail.com>, Wolfram Sang <wsa@kernel.org>, Wu Hao <hao.wu@intel.com>, 
	Yehezkel Bernat <YehezkelShB@gmail.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	YueHaibing <yuehaibing@huawei.com>, Yufen Yu <yuyufen@huawei.com>, alsa-devel@alsa-project.org, 
	dmaengine@vger.kernel.org, greybus-dev@lists.linaro.org, 
	industrypack-devel@lists.sourceforge.net, kvm@vger.kernel.org, 
	linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-fpga@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-i3c@lists.infradead.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-ntb@googlegroups.com, 
	linux-parisc@vger.kernel.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-sunxi@lists.linux.dev, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	nvdimm@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	sparclinux@vger.kernel.org, target-devel@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, 
	Johannes Thumshirn <jth@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 13, 2021 at 9:35 PM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
>
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
>
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.

>  drivers/zorro/zorro-driver.c              | 3 +--

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

