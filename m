Return-Path: <nvdimm+bounces-5986-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6836F704E
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 May 2023 18:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB8D1C211E2
	for <lists+linux-nvdimm@lfdr.de>; Thu,  4 May 2023 16:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0207BA2C;
	Thu,  4 May 2023 16:58:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480442F48
	for <nvdimm@lists.linux.dev>; Thu,  4 May 2023 16:58:49 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-55a00da4e53so12015487b3.0
        for <nvdimm@lists.linux.dev>; Thu, 04 May 2023 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683219528; x=1685811528;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=FkM9R9r7WXPLqXdaM30XFQwHRcaVSt5370WkHsOS9McrKnpuCHz/vwCy5qVQuxV0z2
         yHfnP1DrSP7tCf8QcvoFXQVHzAiobKAxajLxiUcPLoXBHuM78nU/oiulb10PtGygajdv
         IrohyZyUbKeM4VPDY/bR7CjvjXiKcXd+54QQrL19qzKRR6fIyNDFXb0jeHsPyv4w78RR
         ORDofg9FyqtoR/NYSyAKoAKRzMxqQaNAJyB0w10Pbay04/DzG1nRLyq2+/jovZWejcRW
         b4Nw+bXROnus2O1WcejwK/jTP3JJC9ovOlUFePTLElFreLWBpZBJYHBtb03ywDoT05o1
         qxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683219528; x=1685811528;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=k4TvEs1Lqai0QHW+/J/FVb46fBKn50NicAvP7nv5BTWg9f+huniYTbPdBwN+WgnqIr
         vX8muZYUfsB0hnQwnFXIWqEcyHVOO1FTKao5zH555Vc5+uTffSQh/n8CD3joe7FoL1Nx
         2OOa8Vr1j1nbOJGA2JDOF4kuytG0GiViED1QNveGiFeZvDsYv9QyYud9u78IaeflCgMx
         HrSHZA5hgCxG8/KN7BpmfNkamoTQni5rxcL7WlzoRhjC7vteRj38S6bk9MJTFs1a3gQE
         qIK9rNiYd+gQvyMs7hGDCi0awf3DnlaR01mH42W1X4kAqNQ62MQgLIx+A1vukE6s4jlQ
         RxLA==
X-Gm-Message-State: AC+VfDyXtk+GQvX2k7r4z2JYV7b0lo8xb0k3DDWZWNCYYwno9rvzMsIW
	a/BoaYJPNut5ZFBvRSMNKNRe3oNQb6dY4oXz3+kpSi5w
X-Google-Smtp-Source: ACHHUZ6P046cWmuDfwGSaxCjWenBTlcSwFkr3jqwa6vfdTtDpBhLRilXheCXXp4uATtLlhT4zI5zrCO6nnPV/3d0aHw=
X-Received: by 2002:a25:2406:0:b0:b9e:453e:d0c4 with SMTP id
 k6-20020a252406000000b00b9e453ed0c4mr639634ybk.28.1683219527852; Thu, 04 May
 2023 09:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Minwoo Im <minwoo.im.dev@gmail.com>
Date: Fri, 5 May 2023 01:58:11 +0900
Message-ID: <CAA7jztcKUORco-nxfKQtN=F0f54F_FXefZZe0WamEapF=4y8AQ@mail.gmail.com>
Subject: 
To: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

subscribe

