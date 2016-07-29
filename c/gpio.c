#include <stdio.h>
#include <stdlib.h>

int main(void) {
	int gpio, cmd;

	for(gpio = 0; gpio < 32; gpio++) {
		cmd = (0x1f & ~gpio) + 1;
		printf("gpio(%c%c%c%c%c), cmd(%2d)\n",
		       (gpio & 0x10) ? '1' : '0',
		       (gpio & 0x08) ? '1' : '0',
		       (gpio & 0x04) ? '1' : '0',
		       (gpio & 0x02) ? '1' : '0',
		       (gpio & 0x01) ? '1' : '0',
		       cmd);
	}
	return 0;
}
