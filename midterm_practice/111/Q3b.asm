List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    ;16bit*16bit = 16bit mul
    ;multiplicand
    MOVLW 0x01
    MOVWF 0x02 ;high byte
    MOVLW 0x11
    MOVWF 0x03 ;low byte
    
    ;multiplier
    MOVLW 0x00
    MOVWF 0x12 ;high byte
    MOVLW 0x07
    MOVWF 0x13 ;low byte
    
    ;product
    CLRF 0x00
    CLRF 0x01
    
    ;counter
    MOVLW d'16'
    MOVWF 0x05
    
mul_loop:
    BTFSC 0x13, 0 ;test multiplier low byte LSB, skip if LSB=0
	GOTO add
    GOTO end_add
add: ;add multipicand and product
    MOVF 0x03, W
    ADDWF 0x01, F
    
    MOVF 0x02, W
    ADDWFC 0x00, F
end_add:
    
    ;shift mulitplier right 1 bit
    BTFSC 0x12, 0 ;test multiplier high byte LSB, skip if LSB=0
	GOTO shift_with_1
    GOTO shift_with_0
    ;low byte shift
shift_with_1:
    RRNCF 0x13, F
    BSF 0x13, 7
    GOTO end_shift
shift_with_0:
    RRNCF 0x13, F
    BCF 0x13, 7
    GOTO end_shift
end_shift:
    ;high byte shift
    RRNCF 0x12, F
    BCF 0x12, 7
    
    ;shift mulitplicand left 1 bit
    BTFSC 0x03, 7 ;test multiplicand low byte MSB, skip if MSB=0
	GOTO left_shift_with_1
    GOTO left_shift_with_0
    ;high byte shift
left_shift_with_1:
    RLNCF 0x02, F
    BSF 0x02, 0
    GOTO end_left_shift
left_shift_with_0:
    RLNCF 0x02, F
    BCF 0x02, 0
    GOTO end_left_shift
end_left_shift:
    ;low byte shift
    RLNCF 0x03, F
    BCF 0x03, 0
    
    DECFSZ 0x05 ;test counter - 1, skip if = 0
	GOTO mul_loop
    end


