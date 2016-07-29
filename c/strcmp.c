/*
 * strcmp() test
 */
#include <stdio.h>
#include <string.h>

int main(void) {
	int s1, s2, s3, s4;

	s1 = strcmp("12", "123");
	s2 = strcmp("12", "12");
	s3 = strcmp("123", "12");
	s4 = strcmp("123", "124");
	printf("%d, %d, %d, %d\n", s1, s2, s3, s4);
	return 0;
}
