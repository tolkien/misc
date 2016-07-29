/*
 * comma.c - source of comma.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-07-04 14:17:49 $ 
 *
 * $Revision: 1.1 $
 * 
   Wed Jul  4 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>

#define DEFINE_PER_CPU(type, name)	__typeof__(type) per_cpu__##name
#define per_cpu(var, cpu)		(*((void)(cpu), &per_cpu__##var))

int main(void) {
	unsigned long this_cpu = 1;
	unsigned long touch_timestamp = 0;
	DEFINE_PER_CPU(unsigned long, touch_timestamp);

	per_cpu__touch_timestamp = 100;
	printf("this_cpu = %ld\n", this_cpu);
	printf("touch_timestamp = %ld\n", touch_timestamp);
	printf("per_cpu__touch_timestamp = %ld\n", per_cpu__touch_timestamp);

	printf("\n====================\n\n");

	touch_timestamp = per_cpu(touch_timestamp, this_cpu);
	printf("this_cpu = %ld\n", this_cpu);
	printf("touch_timestamp = %ld\n", touch_timestamp);
	printf("per_cpu__touch_timestamp = %ld\n", per_cpu__touch_timestamp);
	return 0;
}

/*
 | $Id: comma.c,v 1.1 2007-07-04 14:17:49 tolkien Exp $
 |
 | Local Variables:
 | mode: c
 | mode: font-lock
 | version-control: t
 | delete-old-versions: t
 | End:
 |
 | -*- End-Of-File -*-
 */
