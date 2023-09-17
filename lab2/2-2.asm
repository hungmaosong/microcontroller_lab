List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	MOVLW 0x05 ;WREG = 0x05
	MOVWF 0x00 ;[0x00] = WREG
	MOVLW 0x02 ;WREG = 0x05
	MOVWF 0x18 ;[0x00] = WREG
	
	MOVLW d'8' ;WREG = 8 ;i=8
	MOVWF 0x20 ;[0x20] = WREG
	
	;use at least one type of FSR
	LFSR 0, 0x00 ;FSR0 point to 0x00 
	LFSR 1, 0x18 ; FSR1 point to 0x018
	
loop:
	MOVF INDF1, W ;WREG = [0x18] ;FSR1 does not move
	ADDWF INDF0, W ;WREG = WREG + [0x00] ;FSR0 does not move
	MOVWF PREINC0 ;FSR0 point to 0x01; [0x01] = WREG
	
	;because no PREDEC0 instruction, I need to use POSTDEC0 to make FSR0 point to 0x00
	MOVLW d'0';WREG = 0
	ADDWF POSTDEC0, F ;[0x01] = [0x01] + 0; FSR0 point to 0x00
	
	MOVF POSTDEC1,W ;WREG = [0x18] ;FSR1 point to 0x17
	SUBWF POSTINC0, W ;WREG = 0x00 - WREG ;FSR0 point to 0x01
	MOVWF INDF1 ;[0x17] = WREG ;FSR1 does not move
	
	DECFSZ 0x20, F ;test [0x20] - 1 = 0,and store back to 0x20,(skip if 0)
	    GOTO loop
	end


