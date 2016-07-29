/*
 * mmc_max.c - source of mmc_max.c
 * Copyright 2000-2006 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2007-02-06 09:33:39 $ 
 *
 * $Revision: 1.1 $
 * 
   Mon Nov 27 2006 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>

#define PXA_MMC_BLKSZ_MAX		(1<<11)		/* actually 1023 */
#define PXA_MMC_NOB_MAX			((1<<16)-2)
#define PXA_MMC_BLOCKS_PER_BUFFER	(2)

#define PXA_MMC_IODATA_SIZE		(PXA_MMC_BLOCKS_PER_BUFFER *	\
					 PXA_MMC_BLKSZ_MAX)	/* 1K */

int main(void) {

   printf("PXA_MMC_BLKSZ_MAX = %d\n", PXA_MMC_BLKSZ_MAX);
   printf("PXA_MMC_NOB_MAX = %d\n", PXA_MMC_NOB_MAX);
   printf("PXA_MMC_BLOCKS_PER_BUFFER = %d\n", PXA_MMC_BLOCKS_PER_BUFFER);
   printf("PXA_MMC_IODATA_SIZE = %d\n", PXA_MMC_IODATA_SIZE);

   return 0;
}


/*
 | $Id: mmc_max.c,v 1.1 2007-02-06 09:33:39 tolkien Exp $
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
