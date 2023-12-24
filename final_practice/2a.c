#include <xc.h>
#include <stdlib.h>
#include <pic18f4520.h>
#include "stdio.h"
#include "string.h"

// CONFIG1H
#pragma config OSC = INTIO67    // Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = OFF       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// CONFIG2L
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)

// CONFIG2H
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)

// CONFIG3H
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

// CONFIG4L
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

// CONFIG5L
#pragma config CP0 = OFF        // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF        // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF        // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF        // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

// CONFIG5H
#pragma config CPB = OFF        // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF        // Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// CONFIG6L
#pragma config WRT0 = OFF       // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF       // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF       // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF       // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

// CONFIG6H
#pragma config WRTC = OFF       // Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
#pragma config WRTB = OFF       // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF       // Data EEPROM Write Protection bit (Data EEPROM not write-protected)

// CONFIG7L
#pragma config EBTR0 = OFF      // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF      // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF      // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF      // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

// CONFIG7H
#pragma config EBTRB = OFF      // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.
#define _XTAL_FREQ 4000000 //for delay!!!!!!!!!!!!!!!!!!!!
int n;
int cycle;
int state;
int duty;
int counter; //for delay 1s

void __interrupt(high_priority) High_interrupt(void) //button pressed
{
    if(INTCONbits.INT0IF == 1){
        if(LATA >= n){
            cycle = 1;
            LATA = 1;
        }
        else{
            cycle++;
            LATA++;
        }
        
        //reset degree to 0
        CCPR1L = 11; //0-255
        CCP1CONbits.DC1B = 0b01; //00 01 10 11
        state = 0;
    
        __delay_ms(10);
        INTCONbits.INT0IF = 0;
    }

}

void __interrupt(low_priority) Low_interrupt(void) 
{
    if(PIR1bits.TMR2IF){
        if(counter == 50){
            counter = 0;
            switch(state){
                case 0:
                    //degree = 0
                    CCPR1L = 11; //0-255
                    CCP1CONbits.DC1B = 0b01; //00 01 10 11
                    state = 1;
                    break;
                case 1:
                    //degree = cycle * (-90/n)
                    duty = (cycle * (-90/n) + 137) / 3;
                    CCPR1L = duty >> 2; //0-255
                    CCP1CONbits.DC1B = duty; //00 01 10 11

                    state = 2;
                    break;
                case 2:
                    //degree = 0
                    CCPR1L = 11; //0-255
                    CCP1CONbits.DC1B = 0b01; //00 01 10 11
                    state = 3;
                    break;
                case 3:
                    //degree = cycle * (90/n)
                    duty = (cycle * (90/n) + 137) / 3;
                    CCPR1L = duty >> 2; //0-255
                    CCP1CONbits.DC1B = duty; //00 01 10 11
                    
                    state = 0;
                    break;
            }
            PIR1bits.TMR2IF = 0;
        }
        else{
            counter++;
            PIR1bits.TMR2IF = 0;
        }     
        
    }
}

void button_initial(){
    INTCONbits.GIE = 1; //open global interrupt
    INTCONbits.PEIE = 1; //open peripheral interrupt
    TRISBbits.RB0 = 1; //RB0/INT0 is input for button
    
    INTCONbits.INT0IE = 1; //enable
    INTCONbits.INT0IF = 0; //flag = 0
}

void LED_initial(){
    ADCON1 = 0x0F; //post A is digital IO (only A,B,E need to set)
    TRISAbits.RA0 = 0; //output
    TRISAbits.RA1 = 0; //output
    TRISAbits.RA2 = 0; //output
    TRISAbits.RA3 = 0; //output
    LATA = 1; //turn on LED
}

void PWM_initial(){    
    IPR1bits.TMR2IP = 0; //low priority
    PIE1bits.TMR2IE = 1;
    PIR1bits.TMR2IF = 0;
    TMR2 = 0;
    
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;
    
    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
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
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    //Duty cycle -> initial: degree 0
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8탎 * 4
     * = 0.00144s ~= 1450탎
     */
    CCPR1L = 11; //0-255
    CCP1CONbits.DC1B = 0b01; //00 01 10 11
}

void main(void){
    RCONbits.IPEN = 1;
    
    button_initial();
    LED_initial();
    PWM_initial();

    n = 9;
    state = 0;
    cycle = 1;
    counter = 0;
    while(1);
    return;
}