#include <stdio.h>
#include <math.h>

main() {

    unsigned long int ns, cpu_khz;
    double tmp, tmp2, tmp3;
    unsigned long int tmp4, tmp5, tmp6;

    ns = 300;
    cpu_khz = 206400;

    tmp = 300 * 206400;
    tmp2 = tmp / 6;
    tmp3 = (tmp2 - 1000000) / 1000000;
    printf("%lf %lf %lf\n", tmp, tmp2, tmp3);

    tmp4 = 300 * 206400;
    tmp5 = tmp4 / 6;
    tmp6 = (tmp5 - 1000000) / 1000000;
    printf("%ld %ld %ld\n", tmp4, tmp5, tmp6);
}
