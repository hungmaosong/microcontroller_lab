#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)
  
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 * 4 cycles
; num1 = 200, num2 = 90, Total_cycles = 505442
; Total_delay ~= Total_cycles/1M = 0.5s
L1 EQU 0x14
L2 EQU 0x15
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:                 ; 7 cycles
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
	
  org 0x00
  CLRF 0x00
  GOTO initial
  ISR1:
    org 0x08
    RCALL button_event
    BCF INTCON, INT0IF		; clean up Interrupt flag bit
    RETFIE
  ISR2:
    org 0x18
    RCALL timer
    RETFIE
    
  button_event:
    INCF 0x00
    MOVLW d'6'
    CPFSGT 0x00 ;if state >6, reset state = 1
	DELAY d'200', d'18' ;delay 0.1s
    MOVLW d'6'
    CPFSGT 0x00 ;if state >6, reset state = 1
	GOTO OK
    CLRF 0x00 
    INCF 0x00 
    OK:
    RETURN
    
  timer:
    BTFSS 0x00, 0 ;if state is odd, skip next line
	DECF LATA
    BTFSC 0x00, 0 ;if state is even, skip next line
	INCF LATA
    BCF PIR1, TMR2IF        ; clean up TMR2IF(flag bit)
    RETURN
    
  initial:
    ;reset state
    MOVLW d'1'
    MOVWF 0x00

    ;setting ADCON1 is digital
    MOVLW 0x0F
    MOVWF ADCON1
    ;setting port RAx
    CLRF TRISA
    CLRF LATA
    ;setting interrupt
    BSF RCON, IPEN
    BSF INTCON, GIE
    BSF INTCON, PEIE
    BCF INTCON, INT0IF		; clean up Interrupt flag bit
    BSF INTCON, INT0IE		; open interrupt0 enable bit (INT0 and RB0's pin are the same one)
    ;setting timer2
    BCF PIR1, TMR2IF
    BCF IPR1, TMR2IP ;low priority
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; Prescale and Postscale = 1:16
    MOVWF T2CON
    MOVLW D'00100000'         ;250HZ
    MOVWF OSCCON
    main:
	MOVLW d'1'
	CPFSEQ 0x00
	    GOTO not_1
	MOVLW D'61'		;0.25s
	MOVWF PR2
	GOTO end_main
	not_1:
	MOVLW d'2'
	CPFSEQ 0x00
	    GOTO not_2
	MOVLW D'122'		;0.5s
	MOVWF PR2
	GOTO end_main
	not_2:
	MOVLW d'3'
	CPFSEQ 0x00
	    GOTO not_3
	MOVLW D'244'		;1s
	MOVWF PR2
	GOTO end_main
	not_3:
	MOVLW d'4'
	CPFSEQ 0x00
	    GOTO not_4
	MOVLW D'61'		;0.25s
	MOVWF PR2
	GOTO end_main
	not_4:
	MOVLW d'5'
	CPFSEQ 0x00
	    GOTO not_5
	MOVLW D'122'		;0.5s
	MOVWF PR2
	GOTO end_main
	not_5:
	MOVLW d'6'
	CPFSEQ 0x00
	    GOTO not_6
	MOVLW D'244'		;1s
	MOVWF PR2
	GOTO end_main
	not_6:
    end_main:
	GOTO main
  end


