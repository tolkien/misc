#include <stdio.h>

/* MMU Level 1 Page Table Constants */
#define MMU_FULL_ACCESS	(3 << 10)
#define MMU_DOMAIN	(0 << 5)
#define MMU_SPECIAL	(0 << 4)
#define MMU_CACHEABLE	(1 << 3)
#define MMU_BUFFERABLE	(1 << 2)
#define MMU_SECTION	(2)
#define MMU_SECDESC	(MMU_FULL_ACCESS | MMU_DOMAIN | \
			 MMU_SPECIAL | MMU_SECTION)

#define SZ_1M		0x00100000
#define SZ_32M		0x02000000
#define DRAM_BASE0	0xC0000000
#define DRAM_SIZE0	SZ_32M

#define UNCACHED_FLASH_BASE	0x50000000
#define FLASH_BASE		0x00000000

main() {

  unsigned long int pageoffset;
  int i;

  i = 0;
  printf("\ncached_flash_addr\n");
  for (pageoffset = 0; pageoffset < SZ_32M; pageoffset += SZ_1M) {
    unsigned long cached_flash_addr = FLASH_BASE + pageoffset;
    unsigned long uncached_flash_addr = UNCACHED_FLASH_BASE + pageoffset;
    if (cached_flash_addr != FLASH_BASE) {
	if ((i % 8) == 0)
	    printf("\n%08lx: ", (cached_flash_addr >> 20));
	printf("%08lx ", cached_flash_addr | MMU_SECDESC | MMU_CACHEABLE);
	i++;
    }
  }
  printf("\n");

  i = 0;
  printf("\nuncached_flash_addr\n");
  for (pageoffset = 0; pageoffset < SZ_32M; pageoffset += SZ_1M) {
    unsigned long cached_flash_addr = FLASH_BASE + pageoffset;
    unsigned long uncached_flash_addr = UNCACHED_FLASH_BASE + pageoffset;
    if ((i % 8) == 0)
	printf("\n%08lx: ", (uncached_flash_addr >> 20));
    printf("%08lx ", cached_flash_addr | MMU_SECDESC | MMU_CACHEABLE);
    i++;
  }
  printf("\n");
}
