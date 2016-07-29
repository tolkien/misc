/*
 * uart1.c
 *
 * register table for XR16L788
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2005-01-17 10:47:26 $ 
 *
 * $Revision: 1.1 $
 */

#include <stdio.h>

#define DEF_OSC		(1.8432*1000*1000)	// 1.8432MHz

static unsigned long bdrate[] = {
	100,
	600,
	1200,
	2400,
	4800,
	9600,
	19200,
	38400,
	57600,
	115200,
	230400,
};
#define SZ_BDRATE	(sizeof(bdrate)/sizeof(bdrate[0]))

void print_table(int p, int m) {
	int i,j;

	printf("prescaler=%d, mode=%dx\n", p, m);
	for(i=0; i < SZ_BDRATE; i++) {
		j = ((DEF_OSC/p)/(bdrate[i]*m));
		printf("%5.1fk = %d(%04x)\n", bdrate[i]/1000.0, j, j);
	}
	printf("\n");
}

int main(void) {
	unsigned long i,j,k;

	print_table(1, 8);
	print_table(1, 16);
	print_table(4, 8);
	print_table(4, 16);

	return 0;
}

/*
 | $Id: uart1.c,v 1.1 2005-01-17 10:47:26 tolkien Exp $
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
