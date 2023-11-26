#include <xc.h>
#include <pic18f4520.h>
#define _XTAL_FREQ 1000000

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

////////////////////////////////


int clockwise = 0; //0 = counter clockwise
void initial(void){
    TRISBbits.RB0 = 1; //initialize button
    
    TRISC = 0;
    LATC = 0;
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;
    PIR1bits.TMR2IF = 0;
    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
    OSCCONbits.IRCF = 0b001;
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    /* 
       PWM period
       = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
       = (0x9b + 1) * 4 * 8탎 * 4
       = 0.019968s ~= 20ms
    */
    PR2 = 0x9b; //20ms PWM period
     /*
       Duty cycle
       = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
       = (0x07*4 + 0b10) * 8탎 * 4
       = 0.000960s ~= 975탎
     */
    CCPR1L = 0x07;
    CCP1CONbits.DC1B = 0b10;
    
    return;
}

void interrupt_init(void){
    RCONbits.IPEN = 0; //INT priority disable
    INTCONbits.GIE = 1; //General INT enable
    INTCONbits.PEIE = 0; //Peripheral INT disable
    INTCONbits.INT0IF = 0; //Clear INT0 flag
    INTCONbits.INT0IE = 1; //Enable INT0 INT
    INTCON2bits.INTEDG0 = 0; //Falling edge trigger for INT0
}

void __interrupt(high_priority) H_ISR() //press button
{
    if(INTCONbits.INT0IF == 1){
        if(CCPR1L == 0x07 && CCP1CONbits.DC1B == 0b10){ //-45 => 0
            CCPR1L == 0x0b; 
            CCP1CONbits.DC1B == 0b01;
            clockwise = 0;
        }
        else if(CCPR1L == 0x0f && CCP1CONbits.DC1B == 0b00){ //+45 => 0
            CCPR1L == 0x0b; 
            CCP1CONbits.DC1B == 0b01;
            clockwise = 1;
        }
        else{
            if(clockwise == 0){ //0 => 45
                CCPR1L = 0x0f;
                CCP1CONbits.DC1B = 0b00;
            }
            else //0 => -45
            {
                CCPR1L = 0x07;
                CCP1CONbits.DC1B = 0b10;
            }
        }
        __delay_ms(500);
        INTCONbits.INT0IF = 0;
    }
}

void main(void)
{
    initial();
    interrupt_init();

    while(1);
    return;
}