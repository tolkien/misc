/*
 * t14.c - test source of mizi_mmap.c
 * Copyright 2000-2005 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2006-02-21 06:05:30 $ 
 *
 * $Revision: 1.5 $
 * 
   Mon Apr 25 2005 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include "list.h"
#define PAGE_SHIFT		12	/* 4k */
#define PAGE_SIZE		(1UL << PAGE_SHIFT)
#define PAGE_MASK		(~(PAGE_SIZE-1))
#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
#define PTE_BUFFERABLE		0
#define GFP_KERNEL		0
#define get_order(size)		((size) >> PAGE_SHIFT)
#define __ioremap(p, s, f)	malloc(s)
struct page {
	int dummy;
} dummy_p;
#define set_page_count(p, i)	(p)->dummy = i
#define alloc_pages(x, s)	(&dummy_p)
#define page_to_pfn(p)		((p)->dummy)
#define __free_page(p)		(p)->dummy = 0
#define __free_pages(p, x)	(p)->dummy = 0
#define SetPageReserved(p)	(p)->dummy = -1

#define EXPORT_SYMBOL(x)	//x
#define __init
#define printk(x...)		printf(x)

#define DECLARE_MUTEX(x)	int x = 0
#define down(x)			*(x) = 1
#define up(x)			*(x) = 0

/*
 * start of code to be tested
 */
#define MMAP_SIZE		PAGE_SIZE

static DECLARE_MUTEX(mzcm_lock);
static LIST_HEAD(root_mz_kmap_t);

static void *mzcm_base = NULL;
static struct page *mzcm_page = NULL;

#define MZCM_SHIFT		4
#define MZCM_SIZE		(1 << MZCM_SHIFT)	/* 16byte */
#define MZCM_MASK		(MZCM_SIZE - 1)
#define OFFSET2MZCM(x)		((x) >> MZCM_SHIFT)
#define MZCM2OFFSET(x)		((x) << MZCM_SHIFT)

#define BMAP_UNIT_SHIFT		3
#define BMAP_UNIT_SIZE		(1 << BMAP_UNIT_SHIFT)	/* 8bit */
#define BMAP_UNIT_MASK		(BMAP_UNIT_SIZE - 1)
#define BMAP_SIZE		(MMAP_SIZE/(BMAP_UNIT_SIZE*MZCM_SIZE))
#define BMAP_BIT(x)		(1 << (BMAP_UNIT_MASK - ((x) & BMAP_UNIT_MASK)))
#define BMAP_IDX(x)		((x) >> BMAP_UNIT_SHIFT)
static unsigned char mzcm_bmap[BMAP_SIZE];

#define DPRINTK(x...)		printk(x)

typedef struct __mz_mmap_t {
	int id;
	unsigned long offset;
	unsigned long size;
} mz_mmap_t;

typedef struct __mz_kmap_t {
	mz_mmap_t m;
	void *data;

	struct list_head entry;
} mz_kmap_t;

#define MZ_BMAP_CHECK		0
#define MZ_BMAP_SET		1
#define MZ_BMAP_CLR		2
/* offset, size must be MZCM_SHIFTed */
static int __mz_do_bmap(int *offset, unsigned long size, int set) {
	unsigned int bmap_idx;
	unsigned char bmap_bit;
	int j, tmp;

	tmp = *offset;
	for(j=0; j < size; j++, tmp++) {
		bmap_idx = BMAP_IDX(tmp);
		bmap_bit = BMAP_BIT(tmp);
		DPRINTK("[%s,%d] %3d %02x %02x!\n", __FUNCTION__,
			set, bmap_idx, bmap_bit, mzcm_bmap[bmap_idx]);
		switch (set) {
		case MZ_BMAP_SET:
			mzcm_bmap[bmap_idx] |= bmap_bit;
			break;
		case MZ_BMAP_CLR:
			mzcm_bmap[bmap_idx] &= ~bmap_bit;
			break;
		default:	/* just check */
			if (mzcm_bmap[bmap_idx] & bmap_bit) {
				DPRINTK("[%s] it's mmaped(2)!\n", __FUNCTION__);
				*offset = tmp;
				return -EINVAL;
			}
		}
	}
	return 0;
}

int mz_request_mmap(mz_kmap_t *src) {
	unsigned long size_s;
	unsigned int bmap_idx;
	unsigned char bmap_bit;
	int offset_s, i, ret;

	if (src->m.id == 0) {
		printk("[%s] mz_kmap_t.m.id is required\n", __FUNCTION__);
		return -EINVAL;
	}

	if ( (src->m.size == 0) ||
	     (src->m.size & MZCM_MASK) ||
	     (src->m.size > MMAP_SIZE) || (src->m.size & PAGE_MASK) ) {
		printk("[%s] mz_kmap_t.m.size is invalid\n", __FUNCTION__);
		return -EINVAL;
	}
	size_s = OFFSET2MZCM(src->m.size);

	if (src->m.offset != 0) {
		if (src->m.offset & MZCM_MASK)
			return -EINVAL;
		offset_s = OFFSET2MZCM(src->m.offset);

		bmap_idx = BMAP_IDX(offset_s);
		bmap_bit = BMAP_BIT(offset_s);
		if (mzcm_bmap[bmap_idx] & bmap_bit) {
			DPRINTK("[%s] it's mmaped!\n", __FUNCTION__);
			return -EINVAL;
		}

		ret = __mz_do_bmap(&offset_s, size_s, MZ_BMAP_CHECK);
		if (ret < 0)
			return ret;
	} else {
		offset_s = OFFSET2MZCM(MMAP_SIZE);
		for(i=0; i < offset_s; i++) {
			bmap_idx = BMAP_IDX(i);
			bmap_bit = BMAP_BIT(i);
			if (mzcm_bmap[bmap_idx] & bmap_bit)
				continue;

			ret = __mz_do_bmap(&i, size_s, MZ_BMAP_CHECK);
			if (ret == 0) {
				break;
			} else {
				DPRINTK("[%s] bmap_idx(%d)\n", __FUNCTION__, i);
			}
		}

		if (i >= offset_s) {
			printk("[%s] there is no free space\n", __FUNCTION__);
			return -EINVAL;
		} else {
			DPRINTK("[%s] return bmap_idx(%d)\n", __FUNCTION__, i);
		}

		src->m.offset = MZCM2OFFSET(i);
	}

	offset_s = OFFSET2MZCM(src->m.offset);

	down(&mzcm_lock);
	ret = __mz_do_bmap(&offset_s, size_s, MZ_BMAP_SET);
	if (ret >= 0) {
		src->data = (mzcm_base + src->m.offset);
		list_add(&(src->entry), &root_mz_kmap_t);
	}
	up(&mzcm_lock);
	return ret;
}
EXPORT_SYMBOL(mz_request_mmap);

void mz_free_mmap(int id) {
	int ret = 0;
	struct list_head *entry;
	mz_kmap_t *mmap;

	list_for_each(entry, &root_mz_kmap_t) {
		mmap = list_entry(entry, mz_kmap_t, entry);

		if (mmap->m.id == id) {
			int offset = OFFSET2MZCM(mmap->m.offset);

			down(&mzcm_lock);
			ret = __mz_do_bmap(&offset, OFFSET2MZCM(mmap->m.size),
					   MZ_BMAP_CLR);
			list_del(&(mmap->entry));
			up(&mzcm_lock);
			break;
		}
	}
}
EXPORT_SYMBOL(mz_free_mmap);

static void * __init __mz_mmap(unsigned long size, struct page **mpage) {
	struct page *page, *end, *free;
	unsigned long order;
	void *ret;

	order = get_order(size);

	page = alloc_pages(GFP_KERNEL, order);
	if (page == NULL)
		goto no_page;

	*mpage = page;
	ret = __ioremap(page_to_pfn(page) << PAGE_SHIFT, size, PTE_BUFFERABLE);
	if (ret == NULL)
		goto no_remap;

	/*
	 * free wasted pages.  We skip the first page since we know
	 * that it will have count = 1 and won't require freeing.
	 * We also mark the pages in use as reserved so that
	 * remap_page_range works.
	 */
	free = page + (size >> PAGE_SHIFT);
	end  = page + (1 << order);

	for (; page < end; page++) {
		set_page_count(page, 1);
		if (page >= free)
			__free_page(page);
		else
			SetPageReserved(page);
	}
	return ret;

no_remap:
	__free_pages(page, order);
no_page:
	return NULL;
}

int __init mz_mmap_init(void) {
	int i;

	mzcm_base = __mz_mmap(PAGE_ALIGN(MMAP_SIZE), &mzcm_page);
	if (mzcm_base == NULL) {
		printk("__mz_mmap failed\n");
		return -1;
	}

	for(i=0; i < BMAP_SIZE; i++)
		mzcm_bmap[i] = 0;

	return 0;
}
/*
 * end of code to be tested
 * start test code
 */

static void mz_mmap_dump(void) {
	int i;

	printf("[%-16s]%2d%20d%20d\n", __FUNCTION__, 1, 2, 3);
	for(i=0; i < BMAP_SIZE; i++)
		printf("%02x", mzcm_bmap[i] & 0xff);
	printf("\n");
}

static void mz_list_dump(void) {
	struct list_head *entry;
	mz_kmap_t *mmap;

	printf("[%s]\n", __FUNCTION__);
	list_for_each(entry, &root_mz_kmap_t) {
		mmap = list_entry(entry, mz_kmap_t, entry);

		printf("%02d, %04ld, %04ld, %p\n",
		       mmap->m.id, mmap->m.offset, mmap->m.size, mmap->data);
	}
}

int main(void) {
	mz_kmap_t mm[] = {
		{
			.m = {
				.id	= 1,
				.offset	= 0,
				.size	= MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 2,
				.offset	= 0,
				.size	= 3*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 3,
				.offset	= 16*MZCM_SIZE,
				.size	= 2*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 4,
				.offset	= 14*MZCM_SIZE,
				.size	= 2*MZCM_SIZE,
			},
			.data	= NULL,
		},
	};
	mz_kmap_t mm2[] = {
		{
			.m = {
				.id	= 12,
				.offset	= 0,
				.size	= 3*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 13,
				.offset	= 0,
				.size	= 3*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 14,
				.offset	= 17*MZCM_SIZE,
				.size	= 2*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 15,
				.offset	= 16*MZCM_SIZE,
				.size	= 2*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 17,
				.offset	= 0,
				.size	= 128*MZCM_SIZE,
			},
			.data	= NULL,
		},
		{
			.m = {
				.id	= 18,
				.offset	= 0,
				.size	= 16*MZCM_SIZE,
			},
			.data	= NULL,
		},
	};
	int i, ret;

	mz_mmap_init();
	printf("mzcm_base(%p)\n"
	       "chunk(shift %d, size %2d, mask %02x, max %ld)\n"
	       "bmap (shift %d, size %2d, mask %02x, tsize %ld)\n",
	       mzcm_base,
	       MZCM_SHIFT, MZCM_SIZE, MZCM_MASK, MMAP_SIZE/MZCM_SIZE,
	       BMAP_UNIT_SHIFT, BMAP_UNIT_SIZE, BMAP_UNIT_MASK, BMAP_SIZE);

	for(i=0; i < sizeof(mm)/sizeof(mm[0]); i++) {
		ret = mz_request_mmap(&mm[i]);
		printf("[%s] %d\n", __FILE__, ret);
	}

	mz_mmap_dump();
	mz_list_dump();

	mz_request_mmap(&mm2[1]);

	mz_mmap_dump();
	mz_list_dump();

	mz_free_mmap(mm[1].m.id);
	mz_request_mmap(&mm2[0]);

	mz_mmap_dump();
	mz_list_dump();

	mz_request_mmap(&mm2[2]);
	mz_request_mmap(&mm2[3]);
	mz_request_mmap(&mm2[4]);
	mz_request_mmap(&mm2[5]);

	mz_mmap_dump();
	mz_list_dump();

	free(mzcm_base);
	return 0;
}

/*
 | $Id: mizi_mmap.c,v 1.5 2006-02-21 06:05:30 tolkien Exp $
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
