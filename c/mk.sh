#!/bin/sh
gcc -O3 -march=pentium4 -pipe -mmmx -msse -msse2 \
	-frename-registers -fforce-addr -falign-functions=64 \
	-fprefetch-loop-arrays -mfpmath=sse \
	-fomit-frame-pointer -maccumulate-outgoing-args -mno-push-args \
	$*
