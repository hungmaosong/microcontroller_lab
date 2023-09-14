List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	MOVLW b'00001010' ;WREG load
	MOVWF 0x00 ;WREG to 0x00
	MOVLW d'8' ;loop i=8
	MOVWF 0x01 ;WREG to 0x01
	MOVLW 0x10 ;WREG load
	MOVWF 0x02 ;WREG to 0x02
loop:	
	BTFSS 0x00, 0 ;test the rightmost bit whether it is 1(skip if 1)
	    GOTO is_even
	GOTO is_odd
is_even:
	INCF 0x02, F ;add 1 
	GOTO enen_odd_end
is_odd:
	DECF 0x02, F ;sub 1 
enen_odd_end:	
	RRNCF 0x00, F ;rotata right 0x00's number
	DECFSZ 0x01, F ;test 0x01's number - 1 = 0,(skip if 0)
	    GOTO loop
	end





