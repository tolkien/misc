/*
 * random.c - source of random.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-02-06 09:33:39 $ 
 *
 * $Revision: 1.1 $
 * 
   Fri Jan  5 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>

#define NUM1	47
#define NUM2	16

int main(void) {
	int i;
	unsigned long num = 0;

	for (i=0; i < 64; i++) {
		printf("%8d, %4d, %4d\n", num, num % NUM1, num % NUM2);
		num += NUM1;
	}

	return 0;
}

/*
 | $Id: random.c,v 1.1 2007-02-06 09:33:39 tolkien Exp $
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
