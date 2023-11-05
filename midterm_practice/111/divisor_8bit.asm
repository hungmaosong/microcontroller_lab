List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    ;4bit dividend
    MOVLW d'7'
    MOVWF 0x00
    
    ;4bit divisor
    MOVLW d'4'
    MOVWF 0x01
    SWAPF 0x01, F ;initial divisor in the left half
    
    ;8bit remainder
    CLRF 0x02
    MOVFF 0x000, WREG
    ADDWF 0x02, F ;initial dividend in the right half side of remainder
    
    ;4bit quotient (bit of Q = bit of sivisor)
    CLRF 0x03
    
    ;count = bit of Q + 1 = bit of sivisor + 1
    MOVLW d'5'
    MOVWF 0x04
    
loop:
    ;step 1: remainder - divisor
    MOVFF 0x001, WREG
    SUBWF 0x02, W
    
    BTFSS WREG, 7 ;test remainder - divisor ?<0 ,skip if <0 (MSB=1)
	GOTO positive
    GOTO negative
    
    positive:
    MOVWF 0x02
    
    ;shfit Q left and then set rightmost bit 1
    RLNCF 0x03, F
    BSF 0x03, 0
    
    GOTO end_positive_negative
    
    negative:
    ;shfit Q left and then set rightmost bit 0
    RLNCF 0x03, F
    BCF 0x03, 0
    
    GOTO end_positive_negative
    
    end_positive_negative:
    
    ;shift divisor right
    RRNCF 0x01, F
    BCF 0x01, 7
    
    DECFSZ 0x04, F
	GOTO loop
    end


