List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x0F ;WREG = 0xD7
    MOVWF 0x00 ;[0x00] = WREG
    
    RRCF 0x00, W ;WREG = right shift(with carry) [0x00]
    MOVWF 0x01 ;[0x01] = WREG
    
    BTFSS 0x00, 7 ;test [0x00] MSB,skip if 1
	BCF 0x01, 7 ;clear [0x01] MSB
    BTFSC 0x00, 7 ;test [0x00] MSB,skip if 0
	BSF 0x01, 7 ;set [0x01] MSB

    RRNCF 0x01, W ;WREG = right shift [0x01]
    MOVWF 0x02 ;[0x02] = WREG
    BCF 0x02, 7 ;clear [0x02]'s 8th bit
    MOVFF 0x002 ,TRISA ;TRISA = [0x002]
    
    end

