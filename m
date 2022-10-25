Return-Path: <nvdimm+bounces-5000-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 273C360CCAA
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Oct 2022 14:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC1CF1C20902
	for <lists+linux-nvdimm@lfdr.de>; Tue, 25 Oct 2022 12:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2D91C2D;
	Tue, 25 Oct 2022 12:52:50 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5A9EDA
	for <nvdimm@lists.linux.dev>; Tue, 25 Oct 2022 12:52:48 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id a15so12030925ljb.7
        for <nvdimm@lists.linux.dev>; Tue, 25 Oct 2022 05:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=kUnA9LjoCw6IyxTCKt/bhLI38dMtXS+d/M0RHnRnVOGw/F3Yse6/pgQGYQNlbN1IZ2
         EZpsyM/6zgYAoPUA0u2Wxvnq2Bv56BvFa3GgZ+RGTgF3vQGsqWUXbq11FuhUXXPRRLMf
         yfEsaO7cAWHKct72UemLu5hP8oL+YAEz1VdXJ6MGtK8neRNqqvQUzoPfA6D9XzjqFP5g
         bclDmXIZ/YHlLtK5C5ZIXi5K0lC669KsAYcn+8gz+gdIaIHKMn+SrFtKb0NbuC9+YhQc
         r8kqo+9f7tQv8TPUo2TiAbIel2T3gWwe5Z3AYQ81zFgJHxf1i+6g+0Q5Me654HpyUEI/
         x0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=PPvdC992kA96wBuM5e13xuk1P9PXssy7oR9nxSdIbMOOjlpQ+9zAcSWdBL2cuWG2Ks
         WmM50of5FBX3B4PboJg8Nvaxk4FcntaiUqyYQplPJblu86aSQ4VMthGB2b1UoSdRWxTE
         LGv/LYFmfcBnwW4mAiw17hPv/QImsRjTXLKNrpIA1E10xRNVN88GqlmEfVUdTqHkYVU6
         Hah34yqC1rOQOxSQFhdoqoZ93hfKPF9QY8O4XvKla+nScWAN0HdcZE5u4ed+vtnVuaGw
         vW5we82ueH3+lKLGtXxag/dd6SPMdGAggPHSoS0imcsJA9gNcm3m/GDAlt3IcwXW9Eir
         /OfQ==
X-Gm-Message-State: ACrzQf1JInmPpllO2rS6U1IGwTiZNW87KHxmH2dn6zPDriWXhjdv+s3x
	u2zQneN7b2hMMCjTSApeiEdRIz6IGNLcy+Jy7km8HKNq
X-Google-Smtp-Source: AMsMyM4H2p92A7M/3JiotFDtWrxO91K0JbLbHYsd/k+kHwcHQZ90fVGOymRNe37Hwt/+jJnhZR+0s7dgQQrdu/iRhJo=
X-Received: by 2002:a2e:a5ca:0:b0:26c:1dfd:8f5b with SMTP id
 n10-20020a2ea5ca000000b0026c1dfd8f5bmr13611792ljp.447.1666702366514; Tue, 25
 Oct 2022 05:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Yang Dongsheng <dongsheng.yang.linux@gmail.com>
Date: Tue, 25 Oct 2022 20:52:34 +0800
Message-ID: <CAOMer8mGn=fpmpPt0E88F=tELihqpSKxaef8T1Wtbf6GANPsPg@mail.gmail.com>
Subject: subscribe
To: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"



