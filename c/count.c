/*
 * count.c - source of count.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-07-04 13:01:34 $ 
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

int main(void) {
	int i, count = 10;

	for(i=0; i < count; i++)
		printf("%d ", i);
	printf("\n");

	for(; count > 0; count--)
		printf("%d ", count);
	printf("\n");

	return 0;
}

/*
 | $Id: count.c,v 1.1 2007-07-04 13:01:34 tolkien Exp $
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
