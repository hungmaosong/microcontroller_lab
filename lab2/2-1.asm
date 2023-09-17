List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	MOVLW 0x03 ;WREG = 0x03
	MOVLB 0x01 ;BSR = 1
	MOVWF 0x00, 1 ;WREG to 0x100
	
	MOVLW 0x08 ;WREG = 0x08
	MOVWF 0x01, 1 ;WREG to 0x101
	
	;Use at least one type of indirect addressing register.
	LFSR 0, 0x100 ;FSR0 point to 0x100
	LFSR 1, 0x101 ; FSR1 point to 0x101
	
	MOVLW d'7' ;WREG = 7 , i=7 initialize i=7(even)
	MOVWF 0x00 ;WREG to 0x000
	
loop:
	BTFSS 0x00, 0 ;test the rightmost bit whether it is 1(skip if 1)
	    GOTO is_odd ;i=6,4,2
	GOTO is_even ;i=7,5,3,1
is_even:
	MOVF POSTINC1, W  ;WREG = [0x101]; FSR1 point to 0x102
	ADDWF POSTINC0, W ;WREG = WREG + [0x100]; FSR0 point to 0x101
	MOVWF INDF1 ;WREG to 0x102; FRS1 does not move
	GOTO even_odd_end
is_odd:
	MOVF POSTINC0, W  ;WREG = [0x101]; FSR0 point to 0x102
	SUBWF POSTINC1, W ;WREG = [0x102] - WREG; FSR1 point to 0x103
	MOVWF INDF1 ;WREG to 0x103; FRS1 does not move
	GOTO even_odd_end
even_odd_end:
	DECFSZ 0x00, F ;test [0x00] - 1 = 0,and store back to 0x00,(skip if 0)
	    GOTO loop
	end


