#include <stdio.h>
#include <stdlib.h>

int main(void) {
	char buf[256];
	char *buf_hp, *buf_tp;

	sprintf(buf, "mmc/disc0");
	printf("before: %s(%d)\n", buf, strlen(buf));
	buf_hp = &buf[0];
	while (*buf_hp != '\0') {
		if (*buf_hp == '/') {
			buf_tp = &buf[strlen(buf)];
			while (buf_tp >= buf_hp) {
				*(buf_tp + 2) = *(buf_tp);
				buf_tp--;
			}
			*buf_hp = '%';	buf_hp++;
			*buf_hp = '2';	buf_hp++;
			*buf_hp = 'F';
		}
		buf_hp++;
	}
	printf("after: %s(%d)\n", buf, strlen(buf));
	return 0;
}
