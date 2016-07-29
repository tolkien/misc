/*
 * before_main.c - test code for constructor
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-04-19 07:36:43 $ 
 *
 * $Revision: 1.1 $
 * 
   Mon Apr  2 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>

#ifdef STRIP_ATTR
#define __attribute__(x)
#endif

void __attribute__((constructor)) before_main( void )
{
	printf("I miss you Lorthlorien ever beauty.\n");
}

void __attribute__((constructor)) before_main_2nd( void )
{
	printf("Bombadil, where have you been in the morning?\n");
}

void __attribute__((destructor)) after_main( void )
{
	printf("Mithlandir, help me!\n");
}

int main(void)
{
	printf("I am working, no touch!\n");
	return 0;
}


/*
 | $Id: before_main.c,v 1.1 2007-04-19 07:36:43 tolkien Exp $
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
