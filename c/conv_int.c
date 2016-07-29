/*
 * conv_int.c - source of conv_int.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-07-30 12:46:09 $ 
 *
 * $Revision: 1.1 $
 * 
   Mon Jul 30 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <string.h>

int main(void) {
	char buf[4];
	short tmp1;
	unsigned long tmp2;
	int i;

	tmp1 = 0x1234;
	//buf = (char *)&tmp1;
	memcpy(buf, &tmp1, sizeof(tmp1));

	printf("%x\n", tmp1);

	printf("buf[");
	for(i=0; i < sizeof(tmp1); i++) {
		printf("%02x", buf[i]);
		if ((i+1) < sizeof(tmp1))
			putchar(' ');
	}
	printf("]\n");


	tmp2 = 0x12345678;
	memcpy(buf, &tmp2, sizeof(tmp2));

	printf("%lx\n", tmp2);

	printf("buf[");
	for(i=0; i < sizeof(tmp2); i++) {
		printf("%02x", buf[i]);
		if ((i+1) < sizeof(tmp2))
			putchar(' ');
	}
	printf("]\n");
	return 0;
}

/*
 | $Id: conv_int.c,v 1.1 2007-07-30 12:46:09 tolkien Exp $
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
