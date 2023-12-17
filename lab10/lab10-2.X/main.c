#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
#define _XTAL_FREQ 4000000
// using namespace std;

char str[20];
int counter = 0;

void initial_button(){
    TRISBbits.RB0 = 1;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.INT0IE = 1;
    INTCONbits.INT0IF = 0;

    return ;
}
void initial_LED(){
    TRISA = 0;
    LATA = 0;
    return ;
}
void main(void) 
{
    UART_Write('0');
    SYSTEM_Initialize() ;
    initial_button();
    initial_LED();
    
    while(1);
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    counter++;
    counter %= 16;
    LATA = counter;
    
    switch(counter){
        case 0: UART_Write('0'); break;
        case 1: UART_Write('1'); break;
        case 2: UART_Write('2'); break;
        case 3: UART_Write('3'); break;
        case 4: UART_Write('4'); break;
        case 5: UART_Write('5'); break;
        case 6: UART_Write('6'); break;
        case 7: UART_Write('7'); break;
        case 8: UART_Write('8'); break;
        case 9: UART_Write('9'); break;
        case 10: UART_Write('A'); break;
        case 11: UART_Write('B'); break;
        case 12: UART_Write('C'); break;
        case 13: UART_Write('D'); break;
        case 14: UART_Write('E'); break;
        case 15: UART_Write('F'); break;
    }
  
    __delay_ms(100);
    INTCONbits.INT0IF = 0;
}
