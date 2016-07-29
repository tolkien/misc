#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
   time_t otime;
   struct tm *local;
   char buf[256];

   //time(&otime);
   otime = time(NULL);

   sprintf(buf, "%s_\n", ctime(&otime));
   printf("%s", buf);

   local = localtime(&otime);
   strftime(buf, 255, "%D %T", local);
   printf("%s\n", buf);
   return 0;
}
