#include <stdio.h>
#include <stdlib.h>

#define __MSCx(a,b,c)	((a) << ((b) + (((c) & 0x1)*16)))
#define RBUFF_SLOW(x)	__MSCx(0, 15, x)	/* Slower Device (Return Data Buffer) */
#define RBUFF_FAST(x)	__MSCx(1, 15, x)	/* Faster Device (Streaming behavior) */
#define RRR(x,y)	__MSCx((y) & 0x7, 12, x) /* ROM/SRAM recovery time */
#define RDN(x,y)	__MSCx((y) & 0xf, 8, x)	/* ROM Delay next access */
#define RDF(x,y)	__MSCx((y) & 0xf, 4, x)	/* ROM Delay first access */
#define RBW_32(x)	__MSCx(0, 3, x)		/* ROM bus width; 32 bits */
#define RBW_16(x)	__MSCx(1, 3, x)		/* ROM bus width; 16 bits */
#define RT_NROM(x)	__MSCx(0, 0, x)		/* Nonburst ROM, Flash */
#define RT_SRAM(x)	__MSCx(1, 0, x)		/* SRAM */
#define RT_4ROM(x)	__MSCx(2, 0, x)		/* burst-of-four ROM, Flash */
#define RT_8ROM(x)	__MSCx(3, 0, x)		/* burst-of-eight ROM, Flash */
#define RT_VLIO(x)	__MSCx(4, 0, x)		/* Variable Latency I/O */
#define RT_NONE(x)	__MSCx(7, 0, x)		/* reserved */

/* Static RAM
   MSC0: 0x7fff1888
   MSC1: 0x3ff1a449
   MSC2: 0x7ff17ff1
   when kernel boot by vivi
 */
#define MSC0_VAL	\
  RBUFF_SLOW(1) | RRR(1,7) | RDN(1,15) | RDF(1,15) | RBW_16(1) | RT_NONE(1) | \
  RBUFF_SLOW(0) | RRR(0,1) | RDN(0,8) | RDF(0,8) | RBW_16(0) | RT_NROM(0)
#define MSC1_VAL	\
  RBUFF_SLOW(3) | RRR(3,3) | RDN(3,15) | RDF(3,15) | RBW_32(3) | RT_SRAM(3) | \
  RBUFF_FAST(2) | RRR(2,2) | RDN(2,4) | RDF(2,4) | RBW_16(2) | RT_SRAM(2)
#define MSC2_VAL	\
  RBUFF_SLOW(5) | RRR(5,7) | RDN(5,15) | RDF(5,15) | RBW_32(5) | RT_SRAM(5) | \
  RBUFF_FAST(4) | RRR(4,1) | RDN(4,0x2) | RDF(4,0x3) | RBW_16(4) | RT_VLIO(4)

int main(void) {
   unsigned long val;

   val = MSC0_VAL;   printf("MSC0: %08lx\n", val);
   val = MSC1_VAL;   printf("MSC1: %08lx\n", val);
   val = MSC2_VAL;   printf("MSC2: %08lx\n", val);
   return 0;
}
