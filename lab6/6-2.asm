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
    BCF TRISA, 0            ;set RA0 as output TRISA = 0000 0000
    BCF TRISA, 1            ;set RA1 as output TRISA = 0000 0000
    BCF TRISA, 2            ;set RA2 as output TRISA = 0000 0000
    BCF TRISA, 3            ;set RA3 as output TRISA = 0000 0000
    
    CLRF 0x00 ;[0x00] = state counter
    INCF 0x00 ;initialize state counter = 1
; ckeck button
check_process:          
    BTFSC PORTB, 0 ;check PORTB bit0,skip if bit0=0 ;pull-up resistor
	BRA check_process ;no press button
    INCF 0x00 ;state counter++	
    BRA lightup
    
lightup:
    ;test state counter
    MOVLW 0x02 ;WREG = 2
    CPFSEQ 0x00 ;test state counter ?= 2, skip if =
	GOTO end_state2
    GOTO state2
state2:
    BSF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    INCF 0x00 ;state counter ++
    DELAY d'200', d'360' ;delay 0.5s
end_state2:    
    
    ;test state counter
    MOVLW 0x03 ;WREG = 3
    CPFSEQ 0x00 ;test state counter ?= 3, skip if =
	GOTO end_state3
    GOTO state3
state3:
    BSF LATA, 1
    BCF LATA, 0
    BCF LATA, 2
    BCF LATA, 3
    INCF 0x00 ;state counter ++
    DELAY d'200', d'360' ;delay 0.5s
end_state3:   
    
    ;test state counter
    MOVLW 0x04 ;WREG = 4
    CPFSEQ 0x00 ;test state counter ?= 4, skip if =
	GOTO end_state4
    GOTO state4
state4:
    BSF LATA, 2
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 3
    INCF 0x00 ;state counter ++
    DELAY d'200', d'360' ;delay 0.5s
end_state4:  
    
    ;test state counter
    MOVLW 0x05 ;WREG = 5
    CPFSEQ 0x00 ;test state counter ?= 5, skip if =
	GOTO end_state5
    GOTO state5
state5:
    BSF LATA, 3
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    INCF 0x00 ;state counter ++
    DELAY d'200', d'360' ;delay 0.5s
end_state5:   
    
    ;test state counter
    MOVLW 0x06 ;WREG = 6
    CPFSEQ 0x00 ;test state counter ?= 6, skip if =
	GOTO end_state1
    GOTO state1
state1:
    BCF LATA, 0
    BCF LATA, 1
    BCF LATA, 2
    BCF LATA, 3
    
    ;reset state counter
    CLRF 0x00
    INCF 0x00 
    
    BRA check_process
end_state1:   
    end




