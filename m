Return-Path: <nvdimm+bounces-3538-lists+linux-nvdimm=lfdr.de@lists.linux.dev>
X-Original-To: lists+linux-nvdimm@lfdr.de
Delivered-To: lists+linux-nvdimm@lfdr.de
Received: from ewr.edge.kernel.org (ewr.edge.kernel.org [147.75.197.195])
	by mail.lfdr.de (Postfix) with ESMTPS id F0CAD50017B
	for <lists+linux-nvdimm@lfdr.de>; Thu, 14 Apr 2022 00:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ewr.edge.kernel.org (Postfix) with ESMTPS id 2A4F21C0F1B
	for <lists+linux-nvdimm@lfdr.de>; Wed, 13 Apr 2022 22:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07CE12F56;
	Wed, 13 Apr 2022 22:01:36 +0000 (UTC)
X-Original-To: nvdimm@lists.linux.dev
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C92F23
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 22:01:33 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id z16so3175649pfh.3
        for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 15:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PuhKkJAkyQmScX7Ist65wo3GNBfQv0kz8A8lNjrlKbg=;
        b=t6v8yplcR2FM0lo6GOTaarMhY9hBmDxYd2D9LMIOcq58o4Q66EUpG7HxHWOJZDaS5s
         VV2Is7VXgtRcdgtGrc821un79nzNpj108xG18fSw6ayfG55s2seKzkjIVtlZCkt/VlDq
         qATF0tQEUXjsxZKPG4CKSKxagyyz+f15i2q9DTSYmFRfVLAVMH0BrPMQ/bNLmg4cdv/J
         m4OCTI65ckTeUcQ7XHnj+7h+Lj2/KNX7cJdzYjZnRB+DPXmg1iI0Vo8JK8RGav4oGdCq
         DIOQNxxJOOA0DYR2Twczz/dNy5al5sdLbl+PRgEHWELs7dgrQLjog955V7p5Jg1sFeam
         9Bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuhKkJAkyQmScX7Ist65wo3GNBfQv0kz8A8lNjrlKbg=;
        b=YvZElll7+21SQvRd6ZXeUlrWQleB/Bji0IVwhQRrdVlWT7YYwlUUzG6gEY8qvEv+M0
         9aimA5kaPold1KkybPGND2z3mTeexzVCMcTr61GPiTLdhW+tYVJmoeRAcOYmJ3WN0gli
         UquxKoFR8oLWO0kSeEekwF3bdBltymwMqeru5pcjlWxqeGSSPnr0j1Cwd0K7eQVpysIp
         7Bv3N2/B9qKgGJdk2eZyrgk2mVdRaYOtXQe24I7F2p/fkdOYHR5Vn6RxIKoXCeHggrXv
         cvY4Jl0MAgYAQuY2ZoNJUFv58LXik9iqmacKq0gF4XjfaDJz4WOUocwvZcFpYpWy9ckO
         CxWA==
X-Gm-Message-State: AOAM533q4jZq9cV4leFz7zhFSkJCnS1So1qVH14mPRcPW/1Fjkyvj9bT
	tNnWmXpxLRqQtuIM+38+G9o4sWP1/0y+Cl66jcZXyw==
X-Google-Smtp-Source: ABdhPJzuqfWFQTa07AecAw9pnLBJPymZ/dSwCJ9Zy1XlqL4VXwYoFjbTX0YlDaWaVFIIX9PeBtZUcPRpnBO8zTkYrJI=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr37576573pgl.40.1649887292498; Wed, 13
 Apr 2022 15:01:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164982969858.684294.17819743973041389492.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220413084309.GV2731@worktop.programming.kicks-ass.net>
In-Reply-To: <20220413084309.GV2731@worktop.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 15:01:21 -0700
Message-ID: <CAPcyv4huZVNkxa7-rQ_J=nVN77+5F1AJg5vi6kLHp8t5khcwHA@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] device-core: Add dev->lock_class to enable
 device_lock() lockdep validation
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-cxl@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Kevin Tian <kevin.tian@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 1:43 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Apr 12, 2022 at 11:01:38PM -0700, Dan Williams wrote:
> > The device_lock() is hidden from lockdep by default because, for
> > example, a device subsystem may do something like:
> >
> > ---
> > device_add(dev1);
> > ...in driver core...
> > device_lock(dev1);
> > bus->probe(dev1); /* where bus->probe() calls driver1_probe() */
> >
> > driver1_probe(struct device *dev)
> > {
> >       ...do some enumeration...
> >       dev2->parent = dev;
> >       /* this triggers probe under device_lock(dev2); */
> >       device_add(dev2);
> > }
> > ---
> >
> > To lockdep, that device_lock(dev2) looks like a deadlock because lockdep
>
> Recursion, you're meaning to say it looks like same lock recursion.

Yes, wrong terminology on my part.

>
> > only sees lock classes, not individual lock instances. All device_lock()
> > instances across the entire kernel are the same class. However, this is
> > not a deadlock in practice because the locking is strictly hierarchical.
> > I.e. device_lock(dev1) is held over device_lock(dev2), but never the
> > reverse.
>
> I have some very vague memories from a conversation with Alan Stern,
> some maybe 10 years ago, where I think he was explaining to me this was
> not in fact a simple hierarchy.
>
> > In order for lockdep to be satisfied and see that it is
> > hierarchical in practice the mutex_lock() call in device_lock() needs to
> > be moved to mutex_lock_nested() where the @subclass argument to
> > mutex_lock_nested() represents the nesting level, i.e.:
>
> That's not an obvious conclusion; lockdep has lots of funny annotations,
> subclasses is just one.
>
> I think the big new development in lockdep since that time with Alan
> Stern is that lockdep now has support for dynamic keys; that is lock
> keys in heap memory (as opposed to static storage).

Ah, I was not aware of that, that should allow for deep cleanups of
this proposal.

>
> > s/device_lock(dev1)/mutex_lock_nested(&dev1->mutex, 1)/
> >
> > s/device_lock(dev2)/mutex_lock_nested(&dev2->mutex, 2)/
> >
> > Now, what if the internals of the device_lock() could be annotated with
> > the right @subclass argument to call mutex_lock_nested()?
> >
> > With device_set_lock_class() a subsystem can optionally add that
> > metadata. The device_lock() still takes dev->mutex, but when
> > dev->lock_class is >= 0 it additionally takes dev->lockdep_mutex with
> > the proper nesting. Unlike dev->mutex, dev->lockdep_mutex is not marked
> > lockdep_set_novalidate_class() and lockdep will become useful... at
> > least for one subsystem at a time.
> >
> > It is still the case that only one subsystem can be using lockdep with
> > lockdep_mutex at a time because different subsystems will collide class
> > numbers. You might say "well, how about subsystem1 gets class ids 0 to 9
> > and subsystem2 gets class ids 10 to 20?". MAX_LOCKDEP_SUBCLASSES is 8,
> > and 8 is just enough class ids for one subsystem of moderate complexity.
>
> Again, that doesn't seem like an obvious suggestion at all. Why not give
> each subsystem a different lock key?
>

Yes, that would also save a source of merge conflicts if every
subsystem needed to add conditional extensions to 'struct device' for
an array of lock metadata.

>
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index af2576ace130..6083e757e804 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -402,6 +402,7 @@ struct dev_msi_info {
> >   * @mutex:   Mutex to synchronize calls to its driver.
> >   * @lockdep_mutex: An optional debug lock that a subsystem can use as a
> >   *           peer lock to gain localized lockdep coverage of the device_lock.
> > + * @lock_class: per-subsystem annotated device lock class
> >   * @bus:     Type of bus device is on.
> >   * @driver:  Which driver has allocated this
> >   * @platform_data: Platform data specific to the device.
> > @@ -501,6 +502,7 @@ struct device {
> >                                          dev_set_drvdata/dev_get_drvdata */
> >  #ifdef CONFIG_PROVE_LOCKING
> >       struct mutex            lockdep_mutex;
> > +     int                     lock_class;
> >  #endif
> >       struct mutex            mutex;  /* mutex to synchronize calls to
> >                                        * its driver.
> > @@ -762,18 +764,100 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
> >       return !!(dev->power.driver_flags & flags);
> >  }
> >
> > +static inline void device_lock_assert(struct device *dev)
> > +{
> > +     lockdep_assert_held(&dev->mutex);
> > +}
> > +
> >  #ifdef CONFIG_PROVE_LOCKING
> >  static inline void device_lockdep_init(struct device *dev)
> >  {
> >       mutex_init(&dev->lockdep_mutex);
> > +     dev->lock_class = -1;
> >       lockdep_set_novalidate_class(&dev->mutex);
> >  }
> > -#else
> > +
> > +static inline void device_lock(struct device *dev)
> > +{
> > +     /*
> > +      * For double-lock programming errors the kernel will hang
> > +      * trying to acquire @dev->mutex before lockdep can report the
> > +      * problem acquiring @dev->lockdep_mutex, so manually assert
> > +      * before that hang.
> > +      */
> > +     lockdep_assert_not_held(&dev->lockdep_mutex);
> > +
> > +     mutex_lock(&dev->mutex);
> > +     if (dev->lock_class >= 0)
> > +             mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
> > +}
> > +
> > +static inline int device_lock_interruptible(struct device *dev)
> > +{
> > +     int rc;
> > +
> > +     lockdep_assert_not_held(&dev->lockdep_mutex);
> > +
> > +     rc = mutex_lock_interruptible(&dev->mutex);
> > +     if (rc || dev->lock_class < 0)
> > +             return rc;
> > +
> > +     return mutex_lock_interruptible_nested(&dev->lockdep_mutex,
> > +                                            dev->lock_class);
> > +}
> > +
> > +static inline int device_trylock(struct device *dev)
> > +{
> > +     if (mutex_trylock(&dev->mutex)) {
> > +             if (dev->lock_class >= 0)
> > +                     mutex_lock_nested(&dev->lockdep_mutex, dev->lock_class);
>
> This must be the weirdest stuff I've seen in a while.
>
> > +             return 1;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static inline void device_unlock(struct device *dev)
> > +{
> > +     if (dev->lock_class >= 0)
> > +             mutex_unlock(&dev->lockdep_mutex);
> > +     mutex_unlock(&dev->mutex);
> > +}
> > +
> > +/*
> > + * Note: this routine expects that the state of @dev->mutex is stable
> > + * from entry to exit. There is no support for changing lockdep
> > + * validation classes, only enabling and disabling validation.
> > + */
> > +static inline void device_set_lock_class(struct device *dev, int lock_class)
> > +{
> > +     /*
> > +      * Allow for setting or clearing the lock class while the
> > +      * device_lock() is held, in which case the paired nested lock
> > +      * might need to be acquired or released now to accommodate the
> > +      * next device_unlock().
> > +      */
> > +     if (dev->lock_class < 0 && lock_class >= 0) {
> > +             /* Enabling lockdep validation... */
> > +             if (mutex_is_locked(&dev->mutex))
> > +                     mutex_lock_nested(&dev->lockdep_mutex, lock_class);
> > +     } else if (dev->lock_class >= 0 && lock_class < 0) {
> > +             /* Disabling lockdep validation... */
> > +             if (mutex_is_locked(&dev->mutex))
> > +                     mutex_unlock(&dev->lockdep_mutex);
> > +     } else {
> > +             dev_warn(dev,
> > +                      "%s: failed to change lock_class from: %d to %d\n",
> > +                      __func__, dev->lock_class, lock_class);
> > +             return;
> > +     }
> > +     dev->lock_class = lock_class;
> > +}
> > +#else /* !CONFIG_PROVE_LOCKING */
>
> This all reads like something utterly surreal... *WHAT*!?!?

Pile of hacks to workaround cases where the lock_class needed to be
specified after the fact. For example, ACPI does not annotate its
locks, but CXL knows that an "ACPI0017" device will always be the root
of a CXL topology. So CXL subsystem can specify that as lock_class 0.

> If you want lockdep validation for one (or more) dev->mutex instances,
> why not pull them out of the no_validate class and use the normal
> locking?

Sounds perfect, just didn't know how to do that with my current
understanding of how to communicate this to lockdep.

>
> This is all quite insane.

Yes, certainly in comparison to your suggestion on the next patch.
That looks much more sane, and even better I think it allows for
optional lockdep validation without even needing to touch
include/linux/device.h.

