List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    Add_Mul macro xh, xl, yh, yl
	MOVLW xh
	MOVWF 0x20 ;[0x20] = xh
	MOVLW xl
	MOVWF 0x21 ;[0x21] = xl
	MOVLW yh
	MOVWF 0x30 ;[0x30] = yh
	MOVLW yl
	MOVWF 0x31 ;[0x31] = yl
	
	;Add
	MOVF 0x31, W ;WREG = yl
	ADDWF 0x21, W ;WREG = xl + WREG(yl)
	MOVWF 0x01 ;  [0x001] = Low byte result
	BC if_carry
	GOTO if_no_carry
    if_carry:
	MOVF 0x30 , W ;WREG = yh
	ADDLW 0x01 ;WREG(yh) = WREG(yh) + 1
	GOTO end_if
    if_no_carry:
	MOVF 0x30 , W ;WREG = yh
    end_if:
	ADDWF 0x20, W ;WREG = xh + WREG(yh)
	MOVWF 0x00 ;  [0x000] = high byte result
	
    ;Mul
    step1:
	MOVF 0x01, W ;WREG = [0x01]
	MULWF 0x00, W ;WREG = [0x00] * WREG([0x01])
    step2:
	MOVF 0x01, W ;WREG = [0x01]
	BTFSC 0x00, 7 ;bit test MSB, skip if MSB=0
	    SUBWF PRODH, F ;PRODH = PRODH - [0x01]
    step3:
	MOVF 0x00, W ;WREG = [0x00]
	BTFSC 0x01, 7 ;bit test MSB, skip if MSB=0
	    SUBWF PRODH, F ;PRODH = PRODH - [0x00]
	    
	MOVFF PRODL ,0x011 ;[0x011] = Low byte 
	MOVFF PRODH ,0x010 ;[0x010] = High byte
	endm
    
    ;Add_Mul 0x04, 0x02, 0x0A, 0x04
    ;Add_Mul 0x00, 0xFF, 0x02, 0x0C
    ;Add_Mul 0xFF, 0xFF, 0xFF, 0xFE ;-1,-2
    ;Add_Mul 0xFF, 0xFF, 0x00, 0x02 ;-1,2
    ;Add_Mul 0x00, 0x01, 0xFF, 0xFE ;1,-2
    Add_Mul 0xFF, 0xFE, 0xFF, 0xFE ;-2,-2
    end


