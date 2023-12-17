#include <xc.h>
#include "uart.h"
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 4000000

void OSC_INIT(){
    OSCCONbits.IRCF = 0b110;
    return;
}

void INT_INIT(){
    RCONbits.IPEN = 1;      //enable Interrupt Priority mode
    INTCONbits.GIEH = 1;    //enable high priority interrupt
    INTCONbits.GIEL = 1;     //disable low priority interrupt
    
    TRISBbits.TRISB0 = 1;  //INT0 for input
    INTCONbits.INT0IF = 0; //Clear INT0 flag
    INTCONbits.INT0IE = 1; //Enable INT0 INT
    INTCON2bits.INTEDG0 = 0; //Falling edge trigger for INT0
    return;
}

void LED_INIT(){
    TRISDbits.TRISD0 = 0;
    TRISDbits.TRISD1 = 0;
    TRISDbits.TRISD2 = 0;
    TRISDbits.TRISD3 = 0;
    LATD = 0;
    return;
}

void main() {
    OSC_INIT();
    INT_INIT();
    LED_INIT();
    UART_INIT();
    while(1);
    return;
}

void __interrupt(high_priority)H_ISR(){
    for(int i=0;;i++){
        if(i==16){
            i=0;
        }
        LATD = i;
        switch(i){
            case 10:
                UART_Write_Text("10\r\n");
                break;
            case 11:
                UART_Write_Text("11\r\n");
                break;
            case 12:
                UART_Write_Text("12\r\n");
                break;
            case 13:
                UART_Write_Text("13\r\n");
                break;
            case 14:
                UART_Write_Text("14\r\n");
                break;
            case 15:
                UART_Write_Text("15\r\n");
                break;
            default:
                UART_Write(i+48);
                UART_Write_Text("\r\n");
                break;
        }
        __delay_ms(500);
    }
    INTCONbits.INT0IF = 0;
    return;
}
