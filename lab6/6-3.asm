LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
    
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 *4 cycles
; num1 = 200, num2 = 90, Total_cycles = 505442
; Total_delay ~= Total_cycles/1M = 0.5s
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:                ; 7 cycles
	NOP
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
    BCF TRISA, 0            ;set RA0 as output TRISA = 0000 0000
    BCF TRISA, 1            ;set RA1 as output TRISA = 0000 0000
    BCF TRISA, 2            ;set RA2 as output TRISA = 0000 0000
    BCF TRISA, 3            ;set RA3 as output TRISA = 0000 0000
    
    CLRF 0x01 ;[0x00] = button state counter
; ckeck button
check_process:          
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA check_process ;no press button
check_process2:
    INCF 0x01 ;button state counter++
    
    MOVLW 0x03 ;WREG = 3
    CPFSEQ 0x01 ;test button state counter ?= 3; skip if =
	GOTO continue
    GOTO reset_button_state_counter
reset_button_state_counter:
    CLRF 0x01 ;reset button state counter = 0
continue:
    
    ;test button state counter = 0,1,2
    MOVLW 0x00 ;WREG = 0
    CPFSEQ 0x01 ;test button state counter ?= 0; skip if =
	GOTO continue1
    BRA lightoff
continue1:
    
    MOVLW 0x01 ;WREG = 1
    CPFSEQ 0x01 ;test button state counter ?= 1; skip if =
	GOTO continue2
    BRA lightup1
continue2:
    
    MOVLW 0x02 ;WREG = 2
    CPFSEQ 0x01 ;test button state counter ?= 2; skip if =
	GOTO continue3
    BRA lightup2
continue3:
    BRA check_process

lightoff:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BRA check_process
    
lightup1:
state1:
    BSF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_state1 ;no press button
    BRA check_process2 ;press button
end_state1:    

state2:
    BSF LATA, 1
    BCF LATA, 0
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_state2 ;no press button
    BRA check_process2 ;press button
end_state2:   
    
state3:
    BSF LATA, 2
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_state3 ;no press button
    BRA check_process2 ;press button
end_state3:  
    
state4:
    BSF LATA, 3
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_state4 ;no press button
    BRA check_process2 ;press button
end_state4:       
    BRA lightup1

lightup2:
sec_state1:
    BSF LATA, 3
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_sec_state1 ;no press button
    BRA check_process2 ;press button
end_sec_state1:    

sec_state2:
    BSF LATA, 2
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_sec_state2 ;no press button
    BRA check_process2 ;press button
end_sec_state2:   
    
sec_state3:
    BSF LATA, 1
    BCF LATA, 0
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_sec_state3 ;no press button
    BRA check_process2 ;press button
end_sec_state3:  
    
sec_state4:
    BSF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    DELAY d'200', d'90' ;delay 0.5s
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA end_sec_state4 ;no press button
    BRA check_process2 ;press button
end_sec_state4:       
    BRA lightup2
    
    
    end







