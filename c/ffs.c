/*
 * ffs.c - source of ffs.c
 * Copyright 2000-2007 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-08-10 14:41:40 $ 
 *
 * $Revision: 1.1 $
 * 
   Fri Aug 10 2007 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>

/**
 * __ffs - find first bit in word.
 * @word: The word to search
 *
 * Undefined if no bit exists, so code should check against 0 first.
 */
static inline unsigned long __ffs(unsigned long word) {
	__asm__("bsfl %1,%0"
		:"=r" (word)
		:"rm" (word));
	return word;
}

int main(void) {
	unsigned long word_tmp;

	word_tmp = 0x81;
	printf("%d\n", __ffs(word_tmp));

	word_tmp = 0x80;
	printf("%d\n", __ffs(word_tmp));

	word_tmp = 0x00;
	printf("%d\n", __ffs(word_tmp));
	return 0;
}

/*
 | $Id: ffs.c,v 1.1 2007-08-10 14:41:40 tolkien Exp $
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
