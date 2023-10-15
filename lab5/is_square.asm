#include"xc.inc"
GLOBAL _is_square
    
PSECT mytext, local, class=CODE, reloc=2

_is_square:
    MOVFF 0x001, LATD ;n
    
    MOVLW 0x01
    MOVWF 0x00 ;[0x00](i) = 1
    
for:
    MOVF 0x00, W ;WREG = i
    CPFSGT 0x01 ;test n>i ,skip if n>i
	GOTO end_for
    	
    SUBWF 0x01, F ;n = n - i
    
    ;i = i + 2
    INCF 0x00
    INCF 0x00
    GOTO for
end_for:
    
    MOVF 0x00, W ;WREG = i
    CPFSEQ 0x01 ;test n=i, skip if n==i
	GOTO if_not_square
    GOTO if_square
    
if_not_square:
    MOVLW 0xFF ;WREG = 0xFF
    MOVWF 0x01 ;[0x01] = 0xFF
    GOTO end_if
if_square:
    MOVLW 0x01 ;WREG = 0x01
    MOVWF 0x01 ;[0x01] = 0x01
end_if:
    RETURN
