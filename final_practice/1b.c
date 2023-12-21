#include <xc.h>
#include <stdlib.h>
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
/*
 * Timer2 test
   LED(use PORT A(RA0-PA3) as output)
 */

char str[20];
char mystring[20];
int lenStr = 0;

int count = 0;
int mode = 15; //use for timer2 loop

void timer2_initialize(){
    INTCONbits.GIE = 1; //open global interrupt
    INTCONbits.PEIE = 1; //open peripheral interrupt
    PIE1bits.TMR2IE = 1; //open timer2 enable
    PIR1bits.TMR2IF = 0; //clean flag bit
    IPR1bits.TMR2IP = 1; //timer2 is high priority
    RCONbits.IPEN = 1; //enable priority
    TMR2 = 0; //Clear TMR2 register to 0
    /*Initialize PR2 and T2CON registers with appropriate data.*/
    PR2 = 255;
    T2CONbits.T2OUTPS = 0b1111; //postscaler = 1:16
    T2CONbits.T2CKPS = 0b10; //prescaler = 1:16
    OSCCONbits.IRCF = 0b110; //Fosc = 4Mhz
    /*
     * Delay = inst.cycle * post * pre * (PR2+1) = 1us * 16 * 16 * 256 = 65.536us
     * 1s = 15 loop Delay (count = 15)
     */
    T2CONbits.TMR2ON = 1; //open timer2
}

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
    */
    
    TRISCbits.TRISC6 = 1;            
    TRISCbits.TRISC7 = 1;            
    
    //  Setting baud rate =1200
    OSCCONbits.IRCF = 110; //FOSC = 4MHZ
    TXSTAbits.SYNC = 0;           
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1;              
    PIR1bits.TXIF = 1; //will set when TXREG is empty
    PIR1bits.RCIF = 0; //will set when reception is complete
    TXSTAbits.TXEN = 1;           
    RCSTAbits.CREN = 1; //continuous receive enable bit, will be cleared when error occurred          
    PIE1bits.TXIE = 1;       
    IPR1bits.TXIP = 0; //EUSART Transmit Interrupt Priority bit           
    PIE1bits.RCIE = 1;              
    IPR1bits.RCIP = 1; //EUSART receive Interrupt Priority bit   
              
    }

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    mystring[lenStr] = RCREG;
    UART_Write(mystring[lenStr]);
    
    if(mystring[lenStr] == '\r'){
        UART_Write('\n');
    }
    
    lenStr++;
    if(lenStr >= 20){ //reset length
        lenStr = 0;
    }
    
    return ;
}

char *GetString(){
    return mystring;
}

void __interrupt(high_priority) high_interrupt(){
//    switch(RCREG){
//        case'0': mode = 15; count = 0; break;
//        case'1': mode = 7; count = 0; break;
//    }
    
        strcpy(str, GetString()); // TODO : GetString() in uart.c
        if(str[0]=='0' && str[1]=='\r'){ // Mode1
            mode = 15; //1s
            count = 0;
            ClearBuffer();
        }
        else if(str[0]=='1' && str[1]=='\r'){ // Mode2
            mode = 7; //0.5s
            count = 0;
            ClearBuffer();  
        }
        else if(str[0]=='2' && str[1]=='\r'){ // Mode2
            mode = 4; //0.25s
            count = 0;
            ClearBuffer();  
        }
    
    if(count == mode){
        count = 0;
        if(LATA == 0b00000001){
            LATA = 0b00000010;
        }
        else{
            LATA = 0b00000001;
        }
        PIR1bits.TMR2IF = 0;
    }
    else
    {
        count++;
        PIR1bits.TMR2IF = 0;
    }
}

void __interrupt(low_priority)  low_interrup(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
    }
    
}

void main(void) {
    ADCON1 = 0x0F; //post A is digital IO (only A,B,E need to set)
    TRISAbits.RA0 = 0; //output
    TRISAbits.RA1 = 0; //output
    
    LATA = 0b00000001; //initialize LED
    
    timer2_initialize() ;
    UART_Initialize();
    
    while(1)
    {
        ;
    }
           
    return;
}