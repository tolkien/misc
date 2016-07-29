#include <stdio.h>
#include <stdlib.h>

int main(void) {
   char a[] = "a128";
   char b[] = "128p";

   printf("%s = %d\n", a, atoi(a));
   printf("%s = %d\n", b, atoi(b));
   return 0;
}
