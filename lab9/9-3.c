#include <xc.h>
#include <pic18f4520.h>
#define _XTAL_FREQ 4000000

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

int value;
void __interrupt(high_priority) H_ISR()
{
    //step4   
    value = ADRESL + (ADRESH * 256);
    //Duty cycle
    CCPR1L = value >> 2;
    CCP1CONbits.DC1B = value;

    for(int i=0; i<= value; i++) //in duty cycle, light on
    {
        LATA = 0b00011110;
    }
    LATA = 0b00000000;
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    
    //delay at least 2tad
     __delay_us(100);
    ADCON0bits.GO = 1;
    
    
    return;
}
void main(void)
{
    ///////////////////////////PWM///////////////////////////////
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
    CCPR1L = 0x00;
    CCP1CONbits.DC1B = 0b00;    
    
    RCONbits.IPEN = 0; //INT priority disable
    INTCONbits.GIE = 1; //General INT enable
    //INTCONbits.PEIE = 0; //Peripheral INT disable

    ///////////////////////////variable resistor///////////////////////////////
    //configure OSC and port
    OSCCONbits.IRCF = 0b001; // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    TRISAbits.RA0 = 1;       //analog input port
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 is analog input,other are digital
    ADCON0bits.CHS = 0b0000;  //AN0 is analog input
    ADCON2bits.ADCS = 0b000;  //check table => 000(0.125Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time = 2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;    //right justified = 1
    
    
    //step2
    PIE1bits.ADIE = 1; //set enable
    PIR1bits.ADIF = 0; //clear flag bit
    INTCONbits.PEIE = 1; //set peripheral interrupt
    INTCONbits.GIE = 1; //set global interrupt


    //step3
    ADCON0bits.GO = 1; //start to ADC
    
    //set led
    TRISAbits.RA1 = 0;
    TRISAbits.RA2 = 0;
    TRISAbits.RA3 = 0;
    TRISAbits.RA4 = 0;
    LATA = 0b00000000;
    
    value = 0;
    while(1);
    return;
}