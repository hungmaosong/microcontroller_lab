List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x74 ;
    MOVWF 0x00 ;[0x00] = WREG
    MOVLW 0x08 ;
    MOVWF 0x01 ;[0x01] = WREG
    MOVLW 0x40 ;
    MOVWF 0x10 ;[0x10] = WREG
    MOVLW 0x46 ;
    MOVWF 0x11 ;[0x11] = WREG
    
    MOVF 0x01, W ;WREG = [0x01]
    ADDWF 0x11, W ;WREG = WREG([0x01]) + [0x11]
    HERE: BNC if_no_carry
        
if_carry:
    MOVWF 0x21 ;[0x21] = WREG
    MOVLW 0x01 ;WREG = 1
    ADDWF 0x00, W ;WREG = WREG(1) + [0x00]
    ADDWF 0x10, W ;WREG = WREG + [0x10]
    GOTO end_if
if_no_carry:
    MOVWF 0x21 ;[0x21] = WREG
    MOVF 0x00, W ;WREG = [0x00]
    ADDWF 0x10, W ;WREG = WREG + [0x10]
end_if:
    MOVWF 0x20 ;[0x20] = WREG
    end


