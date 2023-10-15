#include <xc.h>

extern unsigned int multi_signed(unsigned char a , unsigned char b);

void main(void) {
    volatile unsigned int res = multi_signed(127,-8);
//    volatile unsigned int res = multi_signed(1,2);
    while(1);
    return;
}
