#include <xc.h>

extern unsigned char is_square(unsigned int a);

void main(void) {
    volatile unsigned char ans = is_square(25);
    while(1);
    return;
}

//1+3+5+7+....+(2*n-1)=n^2
/*
bool isSqrt(int n)
{
for(int i=1;n>0;i+=2) n-=i;
return 0 == n;
}
*/