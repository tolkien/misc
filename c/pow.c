/*
 * pow.c - source of pow.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-07-23 02:21:14 $ 
 *
 * $Revision: 1.1 $
 * 
   Mon Jul 23 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <math.h>

int main(void) {
	double x, y;

	x = 2.0;
	y = 2.0;
	printf("pow(%f,%f) = %f\n", x, y, pow(x,y));

	x = 2.0;
	y = 1.54;
	printf("pow(%f,%f) = %f\n", x, y, pow(x,y));

	return 0;
}

/*
 | $Id: pow.c,v 1.1 2007-07-23 02:21:14 tolkien Exp $
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
