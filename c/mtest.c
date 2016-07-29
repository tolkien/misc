/*
 * mtest.c
 *
 * memory test from ppcboot-2.0.0/common/cmd_mem.c
 *
 * Perform a memory test. A more complete alternative test can be
 * configured using CFG_ALT_MEMTEST. The complete test loops until
 * interrupted by ctrl-c or by a failure of one of the sub-tests.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2004-10-26 08:47:09 $ 
 *
 * $Revision: 1.1 $
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define CFG_ALT_MEMTEST
#define CFG_MEMTEST_SIZE	(8*1024*1024)

#define simple_strtoul		strtoul
typedef unsigned long	ulong;
typedef unsigned int	uint;
typedef volatile unsigned long	vu_long;
//typedef unsigned long	vu_long;
#define PRINTF(fmt, args...)
//	printf("[%s:%d] " fmt, __FUNCTION__, __LINE__, args)

#ifdef CFG_ALT_MEMTEST
int do_mem_mtest_alt(vu_long *start, vu_long *end) {
	vu_long *addr;
	ulong	val;
	ulong	readback;

	vu_long	addr_mask;
	vu_long	offset;
	vu_long	test_offset;
	vu_long	pattern;
	vu_long	temp;
	vu_long	anti_pattern;
	vu_long	num_words;
	vu_long *dummy = NULL;
	int	j;

	static const ulong bitpattern[] = {
		0x00000001,	/* single bit */
		0x00000003,	/* two adjacent bits */
		0x00000007,	/* three adjacent bits */
		0x0000000F,	/* four adjacent bits */
		0x00000005,	/* two non-adjacent bits */
		0x00000015,	/* three non-adjacent bits */
		0x00000055,	/* four non-adjacent bits */
		0xaaaaaaaa,	/* alternating 1/0 */
	};

	/*
	 * Data line test: write a pattern to the first
	 * location, write the 1's complement to a 'parking'
	 * address (changes the state of the data bus so a
	 * floating bus doen't give a false OK), and then
	 * read the value back. Note that we read it back
	 * into a variable because the next time we read it,
	 * it might be right (been there, tough to explain to
	 * the quality guys why it prints a failure when the
	 * "is" and "should be" are obviously the same in the
	 * error message).
	 *
	 * Rather than exhaustively testing, we test some
	 * patterns by shifting '1' bits through a field of
	 * '0's and '0' bits through a field of '1's (i.e.
	 * pattern and ~pattern).
	 */
	addr = start;
	for (j = 0; j < sizeof(bitpattern)/sizeof(bitpattern[0]); j++) {
		val = bitpattern[j];
		for(; val != 0; val <<= 1) {
			*addr  = val;
			//*dummy  = ~val; /* clear the test data off of the bus */
			readback = *addr;
			if(readback != val) {
				printf ("FAILURE (data line): "
					"expected %08lx, actual %08lx\n",
					val, readback);
			}
			*addr  = ~val;
			//*dummy  = val;
			readback = *addr;
			if(readback != ~val) {
				printf ("FAILURE (data line): "
					"Is %08lx, should be %08lx\n",
					val, readback);
			}
		}
	}

	/*
	 * Based on code whose Original Author and Copyright
	 * information follows: Copyright (c) 1998 by Michael
	 * Barr. This software is placed into the public
	 * domain and may be used for any purpose. However,
	 * this notice must not be changed or removed and no
	 * warranty is either expressed or implied by its
	 * publication or distribution.
	 */

	/*
	 * Address line test
	 *
	 * Description: Test the address bus wiring in a
	 *              memory region by performing a walking
	 *              1's test on the relevant bits of the
	 *              address and checking for aliasing.
	 *              This test will find single-bit
	 *              address failures such as stuck -high,
	 *              stuck-low, and shorted pins. The base
	 *              address and size of the region are
	 *              selected by the caller.
	 *
	 * Notes:	For best results, the selected base
	 *              address should have enough LSB 0's to
	 *              guarantee single address bit changes.
	 *              For example, to test a 64-Kbyte
	 *              region, select a base address on a
	 *              64-Kbyte boundary. Also, select the
	 *              region size as a power-of-two if at
	 *              all possible.
	 *
	 * Returns:     0 if the test succeeds, 1 if the test fails.
	 *
	 * ## NOTE ##	Be sure to specify start and end
	 *              addresses such that addr_mask has
	 *              lots of bits set. For example an
	 *              address range of 01000000 02000000 is
	 *              bad while a range of 01000000
	 *              01ffffff is perfect.
	 */
	addr_mask = ((ulong)end - (ulong)start)/sizeof(vu_long);
	pattern = (vu_long) 0xaaaaaaaa;
	anti_pattern = (vu_long) 0x55555555;

	PRINTF("%s:%d: addr mask = 0x%.8lx\n",
	       __FUNCTION__, __LINE__, addr_mask);
	/*
	 * Write the default pattern at each of the
	 * power-of-two offsets.
	 */
	for (offset = 1; (offset & addr_mask) != 0; offset <<= 1) {
		start[offset] = pattern;
	}

	/*
	 * Check for address bits stuck high.
	 */
	test_offset = 0;
	start[test_offset] = anti_pattern;

	for (offset = 1; (offset & addr_mask) != 0; offset <<= 1) {
		temp = start[offset];
		if (temp != pattern) {
			printf ("\nFAILURE: Address bit stuck high @ 0x%.8lx:"
				" expected 0x%.8lx, actual 0x%.8lx\n",
				(ulong)&start[offset], pattern, temp);
			return 1;
		}
	}
	start[test_offset] = pattern;

	/*
	 * Check for addr bits stuck low or shorted.
	 */
	for(test_offset = 1; (test_offset & addr_mask) != 0; test_offset <<= 1){
		start[test_offset] = anti_pattern;

		for (offset = 1; (offset & addr_mask) != 0; offset <<= 1) {
			temp = start[offset];
			if ((temp != pattern) && (offset != test_offset)) {
				printf ("\nFAILURE: "
					"Address bit stuck low or shorted @"
					" 0x%.8lx: expected 0x%.8lx,"
					" actual 0x%.8lx\n",
					(ulong)&start[offset], pattern, temp);
				return 1;
			}
		}
		start[test_offset] = pattern;
	}

	/*
	 * Description: Test the integrity of a physical
	 *		memory device by performing an
	 *		increment/decrement test over the
	 *		entire region. In the process every
	 *		storage bit in the device is tested
	 *		as a zero and a one. The base address
	 *		and the size of the region are
	 *		selected by the caller.
	 *
	 * Returns:     0 if the test succeeds, 1 if the test fails.
	 */
	//num_words = ((ulong)end - (ulong)start)/sizeof(vu_long) + 1;
	num_words = ((ulong)end - (ulong)start)/sizeof(vu_long);

	/*
	 * Fill memory with a known pattern.
	 */
	for (pattern = 1, offset = 0; offset < num_words; pattern++, offset++) {
		start[offset] = pattern;
	}

	/*
	 * Check each location and invert it for the second pass.
	 */
	for (pattern = 1, offset = 0; offset < num_words; pattern++, offset++) {
		temp = start[offset];
		if (temp != pattern) {
			printf ("\nFAILURE (read/write) @ 0x%.8lx:"
				" expected 0x%.8lx, actual 0x%.8lx)\n",
				(ulong)&start[offset], pattern, temp);
			return 1;
		}

		anti_pattern = ~pattern;
		start[offset] = anti_pattern;
	}

	/*
	 * Check each location for the inverted pattern and zero it.
	 */
	for (pattern = 1, offset = 0; offset < num_words; pattern++, offset++) {
		anti_pattern = ~pattern;
		temp = start[offset];
		if (temp != anti_pattern) {
			printf ("\nFAILURE (read/write): @ 0x%.8lx:"
				" expected 0x%.8lx, actual 0x%.8lx)\n",
				(ulong)&start[offset], anti_pattern, temp);
			return 1;
		}
		start[offset] = 0;
	}

	return 0;
}
#endif

int do_mem_mtest(vu_long *start, vu_long *end, ulong pattern) {
	//	vu_long	*addr, *start, *end;
	vu_long *addr;
	ulong	val;
	ulong	readback;

	ulong	incr = 1;
	int i;

	for(i=0; i < 2; i++) {
		for (addr=start,val=pattern; addr < end; addr++) {
			*addr = val;
			val  += incr;
		}

		printf("\nReading...");

		for (addr=start,val=pattern; addr < end; addr++) {
			readback = *addr;
			if (readback != val) {
				printf ("\nMem error @ 0x%08X: "
					"found %08lX, expected %08lX\n",
					(uint)addr, readback, val);
				return 1;
			}
			val += incr;
		}

		/*
		 * Flip the pattern each time to make lots of zeros and
		 * then, the next time, lots of ones.  We decrement
		 * the "negative" patterns and increment the "positive"
		 * patterns to preserve this feature.
		 */
		if (pattern & 0x80000000) {
			pattern = -pattern;	/* complement & increment */
		} else {
			pattern = ~pattern;
		}
		incr = -incr;
	}

	return 0;
}

int main(int argc, char *argv[]) {
	int iterations = 1;
	ulong size, pattern;
	vu_long	*start, *end;

	if (argc > 1) {
		size = (ulong)simple_strtoul(argv[1], NULL, 16);
	} else {
		size = (ulong)CFG_MEMTEST_SIZE;
	}

	if (argc > 2) {
		pattern = (ulong)simple_strtoul(argv[2], NULL, 16);
	} else {
		pattern = 0;
	}

	start = (vu_long *)malloc(size);
	if (start == NULL)
		return -ENOMEM;
	end = (vu_long *)(start + (size/sizeof(vu_long)));

#ifdef CFG_ALT_MEMTEST
	if (pattern == 0) {

		printf ("Testing %08x ... %08x:\n", (uint)start, (uint)end);
		PRINTF("%s:%d: start 0x%p end 0x%p\n",
		       __FUNCTION__, __LINE__, start, end);

		for (; iterations > 0; iterations--) {
			printf("Iteration: %6d\r", iterations);

			do_mem_mtest_alt(start, end);
		}

		return 0;
	}
#endif

	printf ("\rPattern %08lX  Writing...", pattern);
	do_mem_mtest(start, end, pattern);
	printf ("\n");

	free((void *)start);
	return 0;
}

/*
 | $Id: mtest.c,v 1.1 2004-10-26 08:47:09 tolkien Exp $
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
