Return-Path: <nvdimm+bounces-1596-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E78A4309AD
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Oct 2021 16:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 0E20B1C0B8E
	for <lists+linux-nvdimm@lfdr.de>; Sun, 17 Oct 2021 14:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1A32C87;
	Sun, 17 Oct 2021 14:12:30 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352ED2C82
	for <nvdimm@lists.linux.dev>; Sun, 17 Oct 2021 14:12:29 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C7F0604DB;
	Sun, 17 Oct 2021 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1634479948;
	bh=RmSMKTg5TcL3qjURkxbM+BvVnDKiX6oL/7vB+Xbd55c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9N+SfeMaoSGCiyxtDBec1UPv6WMgXjFcy/M3JLFPbVafXBNaxdjpG9B30dDW+YCM
	 1w7o17spKr/RDQdS/NDnncfMCzYUuyBikegmGijUFJIAFKXC6JxKBQkOyxWpOPSkMG
	 Xcf3Ny84a19kDTXcxLIlTN6rmnIPZn1mjgXZZ9+Dc8WFgbhY12z4AcuEe7HWqRja5M
	 sJePhxIZkZFRjmpYsRgp1Xe1IXRkzbSJzbuO1E9W0NfEhJS5mWuBnyV95F9ShTR0m/
	 N7QNQaMRxo2QFps6aw3PgKihE2TivErXbQejJdKE4pf9mljG1KyIeEc1cS3pdn6VoR
	 5yxzQIavynIbg==
Date: Sun, 17 Oct 2021 16:12:19 +0200
From: Wolfram Sang <wsa@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@linux.ie>, Gerd Hoffmann <kraxel@redhat.com>,
	Daniel Vetter <daniel@ffwll.ch>, Jie Deng <jie.deng@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-um@lists.infradead.org,
	virtualization@lists.linux-foundation.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, kvm@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH RFC] virtio: wrap config->reset calls
Message-ID: <YWwvQ+YMAKzX1aO3@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@linux.ie>, Gerd Hoffmann <kraxel@redhat.com>,
	Daniel Vetter <daniel@ffwll.ch>, Jie Deng <jie.deng@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-um@lists.infradead.org,
	virtualization@lists.linux-foundation.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, kvm@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <20211013105226.20225-1-mst@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="byZ/nyBYz0KyHzOz"
Content-Disposition: inline
In-Reply-To: <20211013105226.20225-1-mst@redhat.com>


--byZ/nyBYz0KyHzOz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 13, 2021 at 06:55:31AM -0400, Michael S. Tsirkin wrote:
> This will enable cleanups down the road.
> The idea is to disable cbs, then add "flush_queued_cbs" callback
> as a parameter, this way drivers can flush any work
> queued after callbacks have been disabled.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C changes


--byZ/nyBYz0KyHzOz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmFsLz8ACgkQFA3kzBSg
KbbhcRAAqrAP/5XyaQEyoVcqsJ6xfTgBJXC8/fUFVary0yMagmjEQLKzCbVBRQiF
UyKdQuoAJkemPBp13oZuYHgojk26k9r+hRKLoXigmy0tMboLZisXMh7/pcFDyz2e
1C+0lbx3IQ5Q9LV590CAlOS1i7wPOXFDW0LkIu1mb8TX2Z2NU4G7Tz9TQlGBXO39
MhIC6ggPDf141nztlFknKIlcLzpBXatCQrhN7cdcr3LxTjoKa20bHHVIGokKmFma
sJK0vVc5vuqlye+Ea8AZ1jzol4xFQRcSHoNCC5MfHUfxVaJ3mvYQ6jXl9cAfYkLN
0V5IehblsGFyBZ/Kpw/9SnPGTBV2Chs/o4JURyiKp3wVIpkAMagVz9OI4cOC+TTt
8007Fqv9jQtFpu+w9FC3//i0C+JiUH12eYjCt8Me4FZC4EHIosqfm8i7yRB+MZIv
WtaR04OJSlPS/DVFNb1AhUrvITU7uOw2fvVRyyC33iPXIJpvDoyoS9voJTGWYxRn
u7CYO2yy9EfLoB6bPLn4wbfk1TUlbBpSuuycqOpSfjJ0CSEK0d/t4fKkwsDZ+gxb
bS6NiNuzBiaxzsm8EUVR1q+gqY46ywMDIOYmbBykiXipERJofhxjro8Czauj9+b6
FgdQ6J1aFiV8/k36NqD1M5WdM3VecyPECGa7Ba2Nce+uc/k8jCw=
=Y+5l
-----END PGP SIGNATURE-----

--byZ/nyBYz0KyHzOz--

