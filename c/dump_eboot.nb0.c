/*
 * t4.c
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2003-12-04 08:20:18 $ 
 *
 * $Revision: 1.1 $
 */

#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *fp;
    int c, ret;

    fp = fopen("/tmp/eboot.nb0", "r");
    if (fp == NULL)
      return -1;

    ret = fseek(fp, 0x18bc, SEEK_SET);
    for(ret = 0x18bc; ret < 0x1b9c; ret++) {
      c = fgetc(fp);
      if (c == '\0')
	c = '\n';
      putchar(c);
    }

    fclose(fp);

    return 0;
}

/*
 | $Id: dump_eboot.nb0.c,v 1.1 2003-12-04 08:20:18 tolkien Exp $
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
