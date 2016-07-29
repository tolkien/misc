/*
 * strncmp() test
 */
#include <stdio.h>
#include <string.h>

struct _test_strncmp_t {
	char *src;
	char *dst;
};

struct _test_strncmp_t test_case[] = {
	{
		.src	= "12",
		.dst	= "12",
	},{
		.src	= "12",
		.dst	= "123",
	},{
		.src	= "123",
		.dst	= "12",
	},{
		.src	= "123",
		.dst	= "123",
	},{
		.src	= "123",
		.dst	= "124",
	},
};
#define NUM_TEST_CASE	(sizeof(test_case)/sizeof(test_case[0]))

int main(void) {
	int ret, len, i;

	len = 3;
	printf("len is fixed (%d)\n", len);
	for(i=0; i < NUM_TEST_CASE; i++) {
		ret = strncmp(test_case[i].src, test_case[i].dst, len);
		printf("\tstrncmp(\"%s\", \"%s\", %d) = %d\n",
		       test_case[i].src, test_case[i].dst, len, ret);
	}

	printf("len is strlen(src)\n");
	for(i=0; i < NUM_TEST_CASE; i++) {
		len = strlen(test_case[i].src);
		ret = strncmp(test_case[i].src, test_case[i].dst, len);
		printf("\tstrncmp(\"%s\", \"%s\", %d) = %d\n",
		       test_case[i].src, test_case[i].dst, len, ret);
	}

	printf("len is strlen(dst)\n");
	for(i=0; i < NUM_TEST_CASE; i++) {
		len = strlen(test_case[i].dst);
		ret = strncmp(test_case[i].src, test_case[i].dst, len);
		printf("\tstrncmp(\"%s\", \"%s\", %d) = %d\n",
		       test_case[i].src, test_case[i].dst, len, ret);
	}

	return 0;
}
