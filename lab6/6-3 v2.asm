LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
    
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
; num1 = 200, num2 = 360, Total_cycles = 505442
; Total_delay ~= Total_cycles/1M = 0.5s
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm

	
start:
    int:
    ; let pin can receive digital signal 
    MOVLW 0x0f
    MOVWF ADCON1            ;set digital IO
    CLRF PORTB
    BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
    CLRF LATA
    CLRF TRISA
    
    MOVLW b'10000000'
    MOVWF 0x01 ;[0x01] = 10000000
    MOVLW b'00010000'
    MOVWF 0x11 ;[0x11] = 00010000
    
lightoff:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'360' ;delay 0.5s
; ckeck button
check_process:          
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA check_process ;no press button
    
	MOVLW b'10000000'
	MOVWF LATA ;[LATA] = 10000000
	
lightup1:
    RLNCF LATA ;left shift
    DELAY d'200', d'360' ;delay 0.5s
    
    MOVLW b'00001000'
    CPFSLT LATA ;test if LATA < 00001000, skip if <
	MOVFF 0x001, LATA ;reset LATA
	
    ; ckeck button
check_process1:          
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	GOTO lightup1
	
    MOVLW b'00010000'
    MOVWF LATA ;[LATA] = 00010000
    
   
lightup2:
    RRNCF LATA ;right shift
    DELAY d'200', d'360' ;delay 0.5s
    
    MOVLW b'00000001'
    CPFSGT LATA ;test if LATA > 00000001, skip if >
	MOVFF 0x011, LATA ;reset LATA
	
    ; ckeck button
check_process2:          
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	GOTO lightup2
	
    CLRF LATA
    GOTO lightoff
    end







