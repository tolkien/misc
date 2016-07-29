/*
 * shift.c
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2004-11-08 06:55:47 $ 
 *
 * $Revision: 1.1 $
 */

#include <stdio.h>
#include <stdlib.h>

int main(void) {
	int i;

	printf("%08x\n", 0x40A00040);
	printf("%08x\n", 0x40A00040 - (4 << 2));
	for(i=4; i < 12; i++)
		printf("ch(%02d)= %08x\n",
		       i, 0x40A00040 - (4 << 2) + (i << 2));

	return 0;
}

/*
 | $Id: shift.c,v 1.1 2004-11-08 06:55:47 tolkien Exp $
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
