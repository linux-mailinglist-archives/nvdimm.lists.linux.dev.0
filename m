Return-Path: <nvdimm+bounces-3019-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [IPv6:2604:1380:1:3600::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C474B5960
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Feb 2022 19:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id DA43E1C09BD
	for <lists+linux-nvdimm@lfdr.de>; Mon, 14 Feb 2022 18:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57E9A38;
	Mon, 14 Feb 2022 18:09:18 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12612A2C;
	Mon, 14 Feb 2022 18:09:15 +0000 (UTC)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyBzV1Dqxz67N27;
	Tue, 15 Feb 2022 02:08:22 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 19:09:12 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:09:11 +0000
Date: Mon, 14 Feb 2022 18:09:10 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>
CC: <linux-cxl@vger.kernel.org>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 08/14] cxl/region: HB port config verification
Message-ID: <20220214180910.00005690@Huawei.com>
In-Reply-To: <20220214175155.uufw4dd77ol4vtwf@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
	<20220128002707.391076-9-ben.widawsky@intel.com>
	<20220214162037.0000104b@Huawei.com>
	<20220214175155.uufw4dd77ol4vtwf@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml718-chm.china.huawei.com (10.201.108.69) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 14 Feb 2022 09:51:55 -0800
Ben Widawsky <ben.widawsky@intel.com> wrote:

> On 22-02-14 16:20:37, Jonathan Cameron wrote:
> > On Thu, 27 Jan 2022 16:27:01 -0800
> > Ben Widawsky <ben.widawsky@intel.com> wrote:
> >   
> > > Host bridge root port verification determines if the device ordering in
> > > an interleave set can be programmed through the host bridges and
> > > switches.
> > > 
> > > The algorithm implemented here is based on the CXL Type 3 Memory Device
> > > Software Guide, chapter 2.13.15. The current version of the guide does
> > > not yet support x3 interleave configurations, and so that's not
> > > supported here either.
> > > 
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>  
> > 
> >   
> > > +static struct cxl_dport *get_rp(struct cxl_memdev *ep)
> > > +{
> > > +	struct cxl_port *port, *parent_port = port = ep->port;
> > > +	struct cxl_dport *dport;
> > > +
> > > +	while (!is_cxl_root(port)) {
> > > +		parent_port = to_cxl_port(port->dev.parent);
> > > +		if (parent_port->depth == 1)
> > > +			list_for_each_entry(dport, &parent_port->dports, list)
> > > +				if (dport->dport == port->uport->parent->parent)
> > > +					return dport;
> > > +		port = parent_port;
> > > +	}
> > > +
> > > +	BUG();  
> > 
> > I know you mentioned you were reworking this patch set anyway, but
> > I thought I'd give some quick debugging related feedback.
> > 
> > When running against a single switch in qemu (patches out once
> > things are actually working), I hit this BUG()
> > printing dev_name for the port->uport->parent->parent gives
> > pci0000:0c but the matches are sort against
> > 0000:0c:00.0 etc
> > 
> > So looks like one too many levels of parent in this case at least.  
> 
> Hmm. This definitely looks dubious now that I see it again. Let me try to figure
> out how to rework it. I think it would be good to ask Dan as well. Much of the
> topology relationship works from bottom up, but top down is less easy.
> Previously I had used pci-isms to do this but Dan has been working on keeping
> the two domains isolated, which I agree is a good idea.
> 
> > 
> > The other bug I haven't chased down yet is that if we happen
> > to have downstream ports of the switch with duplicate ids
> > (far too easy to do in QEMU as port_num is an optional
> > parameter for switch DS ports) it's detected and the probe fails
> > - but then it tries again and we get an infinite loop of new
> > ports being created and failing to probe...  
> 
> Is this allowed by spec? We shouldn't infinite loop, but I can't imagine the
> driver could do anything saner than fail to probe for such a case.

It would be a hardware bug, however I suspect any failure to probe will
cause it rather that this specific case.  I'll inject another failure
when I get back to this properly.

Jonathan

> 
> > I'll get back this one once I have it working with
> > a valid switch config.  
> 
> Thanks.
> 
> > 
> > Jonathan
> >   
> > > +	return NULL;
> > > +}  


