List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x12
    MOVWF 0x02 ;high byte
    MOVLW 0x34
    MOVWF 0x03 ;low byte
    
    MOVLW 0x66
    MOVWF 0x12 ;high byte
    MOVLW 0x66
    MOVWF 0x13 ;low byte
    
    MOVF 0x13, W ;WREG = [0x13]
    ADDWF 0x03, W ;low btye add
    DAW
    MOVWF 0x01
    
    MOVF 0x12, W ;WREG = [0x12]
    ADDWFC 0x02, W ;high byte add with carry
    DAW
    MOVWF 0x00
    end


