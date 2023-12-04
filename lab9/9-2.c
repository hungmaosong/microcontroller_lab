#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#define _XTAL_FREQ 4000000

#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// My studentID is 44091196
int value;
void __interrupt(high_priority)H_ISR(){
    
    //step4   
    value = ADRESL + (ADRESH * 256);
    
    if(value >= 0 && value <= 127)//4
    {
        LATA = 0b00001000;
    }
    else if(value >= 128 && value <= 255)//4
    {
        LATA = 0b00001000;
    }
    else if(value >= 256 && value <= 383)//0
    {
        LATA = 0b00000000;
    }
    else if(value >= 384 && value <= 511)//9
    {
        LATA = 0b00010010;
    }
    else if(value >= 512 && value <= 639)//1
    {
        LATA = 0b00000010;
    }
    else if(value >= 640 && value <= 767)//1
    {
        LATA = 0b00000010;
    }
    else if(value >= 768 && value <= 895)//9
    {
        LATA = 0b00010010;
    }
    else //6
    {
        LATA = 0b00001100;
    }
    
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    
    //delay at least 2tad
     __delay_us(3);
    ADCON0bits.GO = 1;
    
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; //4MHz
    TRISAbits.RA0 = 1;       //analog input port
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 is analog input,other are digital
    ADCON0bits.CHS = 0b0000;  //AN0 is analog input
    ADCON2bits.ADCS = 0b000;  //check table => 000(1Mhz < 2.86Mhz)
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
    
    while(1);
    
    return;
}