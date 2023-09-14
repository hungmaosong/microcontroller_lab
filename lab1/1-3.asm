List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	MOVLW b'11111111' ;WREG = binary you want to change
	MOVWF 0x00 ;WREG to 0x00 (A)
	CLRF 0x01 ;clear 0x01

	;use and,or,not to replace xor
	RRNCF 0x00, W ;rotate right 0x00 and sava back to WREG (B)
	MOVWF 0x02 ;WREG to 0x02 (B)
	IORWF 0x00, W ;A or B
	MOVWF 0x04 ;WREG to 0x04 (A or B) 
	MOVF 0x02, W ;load 0x02(B) to WREG
	ANDWF 0x00, W ;A and B
	MOVWF 0x05 ;WREG to 0x05 (A and B)
	COMF 0x05, W ;not (A and B)
	ANDWF 0x04, W ;(A or B) and ~(A and B)
	MOVWF 0x01 ;WREG to 0x01
	
	BTFSS 0x00, 7 ;test MSB (skip if 1)
	    GOTO MSB_is_zero
	GOTO MSB_is_one
MSB_is_one:
	BSF 0x01, 7 ;set MSB=1
	GOTO end_MSB
MSB_is_zero:	
	BCF 0x01, 7 ;set MSB=0
	GOTO end_MSB
end_MSB:
	end

	;https://bbs.huaweicloud.com/blogs/283443
	;http://sullystationtechnologies.com/npnxorgate.html

