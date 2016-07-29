/*
 * accr_value.c - source of accr_value.c
 * Copyright 2000-2008 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2008-01-26 06:42:02 $ 
 *
 * $Revision: 1.1 $
 * 
   Fri Jan 11 2008 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>

/*
	@ldr	r0, =0x00033108		@ 104MHz (Run)	
	@ldr	r0, =0x01073110		@ 208MHz (Run)	
	@ldr	r0, =0x010b7210		@ 416MHz (Turbo)
	@ldr	r0, =0x028fb218		@ 624MHz (Turbo)
	@ldr	r0, =0x028fb21f		@ 806MHz (Turbo)
	ldr	r0, =0x028fb218		@ 624MHz (Turbo)
*/

#define ACCR_SMCFS_MASK	0x03800000	/* Static Memory Controller Frequency Select */
#define ACCR_SRAM_MASK	0x000c0000	/* SRAM Controller Frequency Select */
#define ACCR_FC_MASK	0x00030000	/* Frequency Change Frequency Select */
#define ACCR_XSPCLK_MASK	ACCR_FC_MASK
#define ACCR_HSIO_MASK	0x0000c000	/* High Speed IO Frequency Select */
#define ACCR_HSS_MASK	ACCR_HSIO_MASK
#define ACCR_DMCFS_MASK	0x00003000	/* DDR Memory Controller Frequency Select */
#define ACCR_XN_MASK	0x00000700	/* Run Mode Frequency to Turbo Mode Frequency Multiplier */
#define ACCR_XL_MASK	0x0000001f	/* Crystal Frequency to Memory Frequency Multiplier */

#define ACCR_XN(x)	(ACCR_XN_MASK & ((x) << 8))
#define ACCR_XL(x)	(ACCR_XL_MASK & (x))
#define ACCR_DMCFS(x)	(ACCR_DMCFS_MASK & ((x) << 12))
#define ACCR_HSIO(x)	(ACCR_HSIO_MASK & ((x) << 14))
#define ACCR_XSPCLK(x)	(ACCR_XSPCLK_MASK & ((x) << 16))
#define ACCR_SMCFS(x)	(ACCR_SMCFS_MASK & ((x) << 23))

#define ACCR_104_VAL	(ACCR_DMCFS(3)| ACCR_XN(1) | ACCR_XL(8))
#define ACCR_208_VAL	(ACCR_DMCFS(3)| ACCR_XN(1) | ACCR_XL(16))
#define ACCR_416_VAL	(ACCR_DMCFS(3)| ACCR_HSIO(1) | ACCR_XN(2) | ACCR_XL(16))
#define ACCR_624_VAL	(ACCR_DMCFS(3)| ACCR_HSIO(2) | ACCR_XN(2) | ACCR_XL(24))

int main(int argc, char *argv[]) {
	printf("104: %08x\n", ACCR_104_VAL);
	printf("208: %08x\n", ACCR_208_VAL);
	printf("416: %08x\n", ACCR_416_VAL);
	printf("624: %08x\n", ACCR_624_VAL);
	return 0;
}

/*
 | $Id: accr_value.c,v 1.1 2008-01-26 06:42:02 tolkien Exp $
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
