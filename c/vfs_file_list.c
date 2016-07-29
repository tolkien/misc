/*
 * vivi의 vfs area중에서 file_list[]의 위치를 계산하다.
 */
#include <stdio.h>

int main(void) {
	int i;
	unsigned long addr = 0x0200;

	for(i=0; i < 11; i++) {
		printf("0x%08lx\n", addr);
		addr += 72;
	}
	return 0;
}
