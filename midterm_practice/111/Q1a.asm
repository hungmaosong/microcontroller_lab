List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x43
    MOVWF 0x01 ;[0x01] = 0x43
        
    CLRF 0x00
    
    BTFSC 0x01, 0 ;test each bit, skip if bit = 0
	BSF 0x00, 7
    BTFSC 0x01, 1 ;test each bit, skip if bit = 0
	BSF 0x00, 6
    BTFSC 0x01, 2 ;test each bit, skip if bit = 0
	BSF 0x00, 5
    BTFSC 0x01, 3 ;test each bit, skip if bit = 0
	BSF 0x00, 4
    BTFSC 0x01, 4 ;test each bit, skip if bit = 0
	BSF 0x00, 3
    BTFSC 0x01, 5 ;test each bit, skip if bit = 0
	BSF 0x00, 2
    BTFSC 0x01, 6 ;test each bit, skip if bit = 0
	BSF 0x00, 1
    BTFSC 0x01, 7 ;test each bit, skip if bit = 0
	BSF 0x00, 0
    end


