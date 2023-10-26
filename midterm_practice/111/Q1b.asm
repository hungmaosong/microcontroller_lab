List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW b'01011011'
    MOVWF 0x01 ;[0x01] = 01011011
    
    ;0x02 for odd bit
    CLRF 0x02
    BTFSC 0x01 ,7 ;test bit, skip if 0
	BSF 0x02, 3
    BTFSC 0x01 ,5 ;test bit, skip if 0
	BSF 0x02, 2
    BTFSC 0x01 ,3 ;test bit, skip if 0
	BSF 0x02, 1
    BTFSC 0x01 ,1 ;test bit, skip if 0
	BSF 0x02, 0
	
    ;0x03 for even bit
    CLRF 0x03
    BTFSC 0x01 ,6 ;test bit, skip if 0
	BSF 0x03, 3
    BTFSC 0x01 ,4 ;test bit, skip if 0
	BSF 0x03, 2
    BTFSC 0x01 ,2 ;test bit, skip if 0
	BSF 0x03, 1
    BTFSC 0x01 ,0 ;test bit, skip if 0
	BSF 0x03, 0
	
    MOVF 0x02, W
    MULWF 0x03 ;[0x02]*[0x03]
    
    MOVFF PRODL, 0x000
    end


