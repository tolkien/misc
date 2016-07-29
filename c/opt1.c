/*
 * example of compiler optimization
 *
 * [tolkien@tolkien tolkien]$ gcc --version
 * gcc (GCC) 3.2 20020903 (Red Hat Linux 8.0 3.2-7)
 * Copyright (C) 2002 Free Software Foundation, Inc.
 * This is free software; see the source for copying conditions.  There is NO
 * warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
gcc -O3 opt1.c

	[tolkien@tolkien c]$ time ./a.out f 1322
	inf

	real    38m55.904s
	user    32m48.110s
	sys     0m0.400s

 *
gcc -O3 -march=pentium4 -pipe -mmmx -msse -msse2 \
	-frename-registers -fforce-addr -falign-functions=64 \
	-fprefetch-loop-arrays -mfpmath=sse \
	-fomit-frame-pointer -maccumulate-outgoing-args -mno-push-args \
	opt1.c

	[tolkien@tolkien c]$ time ./a.out f 1322
	inf

	real    0m15.222s
	user    0m12.870s
	sys     0m0.000s
 *
 */ 
#include <stdio.h>
#include <stdlib.h>

main(int argc, char* argv[]) {
        unsigned long i;

	if (argc < 3) {
		printf("usage: %s [f|i] number\n", argv[0]);
		return 0;
	}

	if (argv[1][0] == 'f') {
		double f = atof(argv[2]);

		if (f == 0) {
			printf("INVALID argument: %s\n", argv[2]);
			return 2;
		}

		for(i=0; i< (unsigned long)~0x0; i++)
			f *= f;
    		printf("%lf\n", f);

	} else if (argv[1][0] == 'i') {
		int d = atoi(argv[2]);

		if (d == 0) {
			printf("INVALID argument: %s\n", argv[2]);
			return 2;
		}

		for(i=0; i< (unsigned long)~0x0; i++)
			d *= d;
    		printf("%ld\n", d);

	} else {
		printf("INVALID argument: %s not in {'f', 'i'}\n", argv[1]);
		return 1;
	}
	return 0;
}
