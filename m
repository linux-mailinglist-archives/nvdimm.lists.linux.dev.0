Return-Path: <nvdimm+bounces-7805-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BFB88F716
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Mar 2024 06:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5212E2987D9
	for <lists+linux-nvdimm@lfdr.de>; Thu, 28 Mar 2024 05:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DF74CE08;
	Thu, 28 Mar 2024 05:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHgMJrvU"
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CD40865
	for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711602998; cv=none; b=b6Dxfl2xCDUJm0Xy2t2iSkzS9TQElmO/aawGVRo3suBGN+1puJU78a84PzaQmN1LVVsVbkbkJVBC20E/RFUhVQhp8zaOrkl7Ihks9YHKosD+Q0XUI34eeGFYrN+furLSS5f4meCEUHsm4vhPTu3EOAZCpug4dDKKKTdRIzmjKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711602998; c=relaxed/simple;
	bh=sBPTJcGEYTbv3hcgUwqNauzYtskOKb+GWpnb7br0MOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbSKhW5A/+hpvvIL1eV++hH/cbKIwU4PeM849tC0zZfq6YP6K2P0umvdJ7Y8mrcxfFNssLMcygGXHWjHYuVrC6tUtTEIVrSbv/eBR3RPtl2deNwZ8Th02pL7PhmFmOL4qpj7QckhwOeRaEZzH+4cQF9NhwwWtfLZ8LB6IaIUFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cHgMJrvU; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a58009fe88so308071eaf.0
        for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 22:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711602994; x=1712207794; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCBBqATkrmhAqNvcc7V5yUc6Bj0MDD2J9Hd2vuTQUac=;
        b=cHgMJrvUnb2PD1Oof8B3R/yBuTD8xTU/oKbU/K57hm4zxFGGBxCZiKpQd6q6JpR6IK
         QUiUAmAJt1W15jf34xLRAzPr6MpBpu6DtZHEhfOXI+Lk9F5t1egIY9P3fZ5mQf+cFffA
         IcSiYK474na2fIQ/Zu1WTw1ZDiIdASt+umyc9tmGtXIEUlyTPEdLHio+adAu0rUS52n6
         2JaalArhzpecCw7Z5Axnj8ndfh1jA5XS026w21sj7xOFdScEnxQzkW+kWw5mj7aPXArE
         92HelhGwyh3pDaA61QyvcF9/h2qCos9BbMSTs8fqABUsMSoilo4s0cu9men8+VyzOj50
         FwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711602994; x=1712207794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCBBqATkrmhAqNvcc7V5yUc6Bj0MDD2J9Hd2vuTQUac=;
        b=lOw6ScB7mUuDsm6Ox4X5S8avH89B+DI6zanH+wD8q1uQqGsCDEZNUpRawtRuowH53k
         O9gfYIzcrSTwI697/nKq+P/LGzmVq9IiKurgjsHxIxYLx6goC7dPhaJnSi78fTVs8fjy
         bOrIJ/szC7j3LADXcEfGM+BkhqZncJHtYBX1OVvqDHgh24GhRIZUZyjC/j9pkzH8UB17
         z5rLfSNR57WsN4DylJMr2wSVf58XrqlzGjvxtifsUgd2N2iVObAvXC16d8r77Bv6bCCB
         vGI0D1TA3IcPM0wOlWPCrOWUYuGLPRI+bdnQt+WSZl2D0DCpm3vay0a0AUMEaNsUDSds
         fr/w==
X-Forwarded-Encrypted: i=1; AJvYcCW/ls6z3LWw3rBwiJzEyKLorw2H6BQqTtOgTxsZ1U0Oirnc/g+L1k1c4Rmf9PITE8xCfvdFsS7j9gwq+/devYs/gS4KlwRf
X-Gm-Message-State: AOJu0YzwEmL0aMFMhaSmpP4NPMdJeSpz87j/X/KsBjvzv4sznV1xTd8j
	/D66Wh7qAb/qNr0YF/ST3Lu7VNoQzp7MVIQxtqLom6LyHl/SgGq/rhj4gzVkuPE=
X-Google-Smtp-Source: AGHT+IENjWm30W77Sho1F7STKjVDKRSghd/5qoLRwkalJNx2D7PN+W1+MnXgZZvq+TiwN/1tI/fojA==
X-Received: by 2002:a05:6358:5307:b0:17e:8f90:dd31 with SMTP id n7-20020a056358530700b0017e8f90dd31mr1555244rwf.32.1711602994298;
        Wed, 27 Mar 2024 22:16:34 -0700 (PDT)
Received: from localhost ([122.172.85.206])
        by smtp.gmail.com with ESMTPSA id u23-20020a63df17000000b005e857bba96csm433309pgg.10.2024.03.27.22.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 22:16:33 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:46:31 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kalle Valo <kvalo@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 09/22] gpio: virtio: drop owner assignment
Message-ID: <20240328051631.c5eitp4mzaj4bh6i@vireshk-i7>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
 <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>

On 27-03-24, 13:41, Krzysztof Kozlowski wrote:
> virtio core already sets the .owner, so driver does not need to.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Depends on the first patch.
> ---
>  drivers/gpio/gpio-virtio.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> index fcc5e8c08973..9fae8e396c58 100644
> --- a/drivers/gpio/gpio-virtio.c
> +++ b/drivers/gpio/gpio-virtio.c
> @@ -653,7 +653,6 @@ static struct virtio_driver virtio_gpio_driver = {
>  	.remove			= virtio_gpio_remove,
>  	.driver			= {
>  		.name		= KBUILD_MODNAME,
> -		.owner		= THIS_MODULE,
>  	},
>  };
>  module_virtio_driver(virtio_gpio_driver);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

