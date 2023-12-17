#include <xc.h>
#include <string.h>
    //setting TX/RX

char mystring[20];
int lenStr = 0;

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
    PIE1bits.TXIE = 0;       
    IPR1bits.TXIP = 0; //EUSART Transmit Interrupt Priority bit           
    PIE1bits.RCIE = 1;              
    IPR1bits.RCIP = 0; //EUSART receive Interrupt Priority bit   
              
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


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
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
    
   // process other interrupt sources here, if required
    return;
}