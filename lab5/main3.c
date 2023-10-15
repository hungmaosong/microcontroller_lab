#include <xc.h>

extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int lcm_result = lcm(45,36);
    while(1);
    return;
}

/*
int gcd(int x, int y) {
    int tmp;
    while (x % y != 0) {
        tmp = y;
        y = x % y;
        x = tmp;
    }
    return y;
}
 */