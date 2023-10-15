#include"xc.inc"
GLOBAL _lcm
    
PSECT mytext, local, class=CODE, reloc=2
 
_lcm:
    MOVFF 0x001, 0x011 ;copy a
    MOVFF 0x003, 0x013 ;copy b
    MOVFF 0x001, 0x021 ;copy a
    MOVFF 0x003, 0x023 ;copy b
    MOVFF 0x001, 0x031 ;copy a
    MOVFF 0x003, 0x033 ;copy b
    
    ;find max (max = [0x011], min = [0x013]
    MOVF 0x13, W ;WREG = [0x13]
    CPFSLT 0x11 ;test [0x11] < [0x13], skip if <
	GOTO if_big
    GOTO if_small    
if_small: ;if a < b, swap
    MOVFF 0x011, 0x012
    MOVFF 0x013, 0x011
    MOVFF 0x012, 0x013
if_big: ;if a >= b, do nothing
    
while:
    ;[0x11] = a % b
    for:
	MOVF 0x13, W ;WREG = b
	CPFSLT 0x11 ;test [0x11] < [0x13], skip if <
	    GOTO continue_for
	GOTO end_for
    continue_for:
	SUBWF 0x11, F ;a = a - b
	GOTO for
    end_for:
    
    MOVLW 0x00 ;WREG = 0
    CPFSEQ 0x11 ;test a%b == 0? ,skip if =
	GOTO continue_while
    GOTO end_while
continue_while:
    MOVFF 0x013, 0x012 ;temp = b
    MOVFF 0x011, 0x013 ;b = a%b
    MOVFF 0x012, 0x011 ;a = temp
    GOTO while
end_while:
    
    ;now [0x013] (b) is the GCD
    MOVFF 0x013, 0x040;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;lcm = a*b/GCD = (a or b)/GCD * (b or a)
    
    ;test a%GCD ?= 0, by the way [0x20] is quotient
    CLRF 0x20
for2:
    MOVF 0x13, W ;WREG = GCD
    CPFSLT 0x21 ;test [0x21] < [0x13], skip if <
	GOTO continue_for2
    GOTO end_for2
continue_for2:
    SUBWF 0x21, F ;a = a - GCD
    INCF 0x20; Q++
    GOTO for2
end_for2:
    
    MOVLW 0x00 ;WREG = 0
    CPFSEQ 0x21 ;test remainder ?= 0, skip if =
	GOTO remainder_not0
    GOTO remainder_is0
remainder_is0:
    MOVF 0x23, W ;WREG = b
    MULWF 0x20 ;WREG = a/GCD * b
    MOVFF PRODH, 0x002
    MOVFF PRODL, 0x001
    GOTO end_remainder
    
remainder_not0:
    ;calculate b%GCD, by the way [0x30] is quotient
    CLRF 0x30
    for3:
	MOVF 0x13, W ;WREG = GCD
	CPFSLT 0x33 ;test [0x33] < [0x13], skip if <
	    GOTO continue_for3
	GOTO end_for3
    continue_for3:
	SUBWF 0x33, F ;b = b - GCD
	INCF 0x30; Q++
	GOTO for3
    end_for3:
    
    MOVF 0x31, W ;WREG = a
    MULWF 0x30 ;WREG = b/GCD * a
    MOVFF PRODH, 0x002
    MOVFF PRODL, 0x001
    GOTO end_remainder
    
end_remainder:
    RETURN


