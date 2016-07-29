#include <stdio.h>
#include <stdlib.h>

static int e = 0;
static void *p = NULL;
int main(void) {
   double a, b, c;
   int d;

   a = 1.0;
   b = 0.4523009;
   c = a + b;
   printf("a+b = %f\n", c);
   printf("%d,%d,%p\n", d,e,p);
   return 0;
}
