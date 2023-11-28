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

int counter = 0b0000010000; //for Pulse Width = 500
int counter2 = 0b0001001011; //for Pulse Width = 2400

void interrupt_init(void)
{
    RCONbits.IPEN = 0; //INT priority disable
    INTCONbits.GIE = 1; //General INT enable
    INTCONbits.PEIE = 0; //Peripheral INT disable
    INTCONbits.INT0IF = 0; //Clear INT0 flag
    INTCONbits.INT0IE = 1; //Enable INT0 INT
    INTCON2bits.INTEDG0 = 0; //Falling edge trigger for INT0
}

void __interrupt(high_priority) H_ISR() //press button
{
    if(INTCONbits.INT0IF == 1)
    {
        while(1)
        {
            for(int i=counter; i<= counter2; i++)
            {
                 //Duty cycle
                CCPR1L = (i & 0b1111111100) >> 2; //CCPR1L is 8 bit!
                CCP1CONbits.DC1B = i & 0b0000000011;
                __delay_ms(3);
            } 
            
            for(int i=counter2; i>= counter; i--)
            {
                //Duty cycle
                CCPR1L = (i & 0b1111111100) >> 2; //CCPR1L is 8 bit!
                CCP1CONbits.DC1B = i & 0b0000000011;
                __delay_ms(3);
            } 
            
        }
    }
   
}
void main(void)
{
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    //Duty cycle
    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;    
    interrupt_init();
    
    while(1);
    return;
}