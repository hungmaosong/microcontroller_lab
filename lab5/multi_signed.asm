#include"xc.inc"
GLOBAL _multi_signed
    
PSECT mytext, local, class=CODE, reloc=2
 
_multi_signed:
    MOVWF 0x03 ;multiplicand
    ;test multiplicand >= 0 or not
    MOVLW 0x7F ;WREG = 127
    CPFSGT 0x03 ;test multiplicand > 127 (negative),skip if >
	GOTO if_multiplicand_positive
    GOTO if_multiplicand_negative
if_multiplicand_positive:
    ;set sign bit 0
    MOVLW 0x00 
    MOVWF 0x11 ;[0x11] = 0 
    MOVFF 0x003, 0x012
    GOTO end_if_multiplicand
if_multiplicand_negative:
    ;set sign bit 1
    MOVLW 0x01 
    MOVWF 0x11 ;[0x11] = 1
    ;make two's complement
    MOVLW 0xFF ;WREG = 11111111
    XORWF 0x03, W ;WREG = ~[0x03]
    INCF WREG ;WREG = WREG + 1
    MOVWF 0x12 ;[0x12] = [0x03]'s two's complement
end_if_multiplicand:
    
    ;test multiplier >= 0 or not
    MOVLW 0x07 ;WREG = 7
    CPFSGT 0x01 ;test multiplier > 7 (negative),skip if >
	GOTO if_multiplier_positive
    GOTO if_multiplier_negative
if_multiplier_positive:
    ;set sign bit 0
    MOVLW 0x00 
    MOVWF 0x13 ;[0x13] = 0 
    MOVFF 0x001, 0x014
    GOTO end_if_multiplier
if_multiplier_negative:
    ;set sign bit 1
    MOVLW 0x01 
    MOVWF 0x13 ;[0x13] = 1
    ;make two's complement
    MOVLW 0xFF ;WREG = 11111111
    XORWF 0x01, W ;WREG = ~[0x01]
    INCF WREG ;WREG = WREG + 1
    MOVWF 0x14 ;[0x14] = [0x01]'s two's complement
end_if_multiplier:
    
    CLRF 0x05
    CLRF 0x06
    CLRF 0x22 ;[0x22] = Multiplicand high byte ; [0x12] = Multiplicand low byte
mul: ;0x05 & 0x06 save the unsigned mul result
    MOVLW 0x04 
    MOVWF 0x00 ;i = 4
    CLRF WREG
for:
    MOVF 0x06 , W ;WREG = [0x06](Product low byte)
    BTFSC 0x14 ,0 ;test Multiplier's LSB, skip if 0
	GOTO add
    GOTO end_add
add: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ADDWF 0x12 , W ;WREG = WREG + Multiplicand
    BC if_carry
    GOTO if_nocarry
    if_carry:
	MOVWF 0x06 ;[0x06] = WREG
	INCF 0x05 ;carry
	MOVF 0x22, W 
	ADDWF 0x05, F
	GOTO end_if_carry
    if_nocarry:
	MOVWF 0x06 ;[0x06] = WREG
	MOVF 0x22, W 
	ADDWF 0x05, F
    end_if_carry:
end_add:

    ;shift Multiplier right 1bit
    RRNCF 0x14
    BCF 0x14, 7 
    
    ;shift Multiplicand left 1bit
    RLNCF 0x22
    BTFSS 0x12, 7 ;test [0x12] MSB, skip if MSB =1
	GOTO if_MSB_0
    GOTO if_MSB_1
    if_MSB_1:
	BSF 0x22, 0 ;[0x22] LSB = 1
	GOTO end_if_MSB
    if_MSB_0:
	BCF  0x22, 0 ;[0x22] LSB = 0
    end_if_MSB:
    RLNCF 0x12
    BCF 0x12, 0
    
    DECFSZ 0x00, F ;(i=i-1) test i-1 = 0; skip if = 
	GOTO for	
end_for:
    
    MOVF 0x11, W
    XORWF 0x13, W ;WREG = [0x11] xor [0x13]
    MOVWF 0x10 ;[0x10] = [0x11] xor [0x13]
    
    MOVLW 0x00 ;WREG = 0
    CPFSEQ 0x10 ;test [0x11] xor [0x13], skip if 0 (sign bit are the same)
	GOTO if_result_is_neg
    GOTO end_if_result
if_result_is_neg: ;2's complement
    MOVLW 0xFF ;WREG = 11111111
    XORWF 0x06, F
    XORWF 0x05, F
    
    MOVLW 0x01 ;WREG = 1
    ADDWF 0x06, F ;[0x06] = [0x06] + 1
    BC if_result_carry
    GOTO if_result_nocarry
    if_result_carry:
	INCF 0x05
    if_result_nocarry:    
end_if_result:
    
    MOVFF 0x005,0x002
    MOVFF 0x006,0x001
    RETURN

