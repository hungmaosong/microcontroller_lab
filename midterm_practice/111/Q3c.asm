List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW b'10101010'
    MOVWF 0x01
    MOVLW b'10101010'
    MOVWF 0x02
    MOVLW b'01010101'
    MOVWF 0x03
    MOVLW b'01010101'
    MOVWF 0x04
    
    ;reverse [0x01 0x02] to [0x13 0x14]
    CLRF 0x13
    CLRF 0x14
    
    BTFSC 0x01, 7 ;test bit, skip if bit = 0
	BSF 0x14, 0
    BTFSC 0x01, 6 ;test bit, skip if bit = 0
	BSF 0x14, 1
    BTFSC 0x01, 5 ;test bit, skip if bit = 0
	BSF 0x14, 2
    BTFSC 0x01, 4 ;test bit, skip if bit = 0
	BSF 0x14, 3
    BTFSC 0x01, 3 ;test bit, skip if bit = 0
	BSF 0x14, 4
    BTFSC 0x01, 72 ;test bit, skip if bit = 0
	BSF 0x14, 5
    BTFSC 0x01, 1 ;test bit, skip if bit = 0
	BSF 0x14, 6
    BTFSC 0x01, 0 ;test bit, skip if bit = 0
	BSF 0x14, 7
    
    BTFSC 0x02, 7 ;test bit, skip if bit = 0
	BSF 0x13, 0
    BTFSC 0x02, 6 ;test bit, skip if bit = 0
	BSF 0x13, 1
    BTFSC 0x02, 5 ;test bit, skip if bit = 0
	BSF 0x13, 2
    BTFSC 0x02, 4 ;test bit, skip if bit = 0
	BSF 0x13, 3
    BTFSC 0x02, 3 ;test bit, skip if bit = 0
	BSF 0x13, 4
    BTFSC 0x02, 72 ;test bit, skip if bit = 0
	BSF 0x13, 5
    BTFSC 0x02, 1 ;test bit, skip if bit = 0
	BSF 0x13, 6
    BTFSC 0x02, 0 ;test bit, skip if bit = 0
	BSF 0x13, 7
	
    CLRF 0x10 ;count (if count == 2 , they are palindrom)
    MOVF 0x03, W
    CPFSEQ 0x13 ;test [0x13] ?= [0x03], skip if =
	GOTO no_add1
    INCF 0x10
no_add1:
    MOVF 0x04, W
    CPFSEQ 0x14 ;test [0x14] ?= [0x04], skip if =
	GOTO no_add2
    INCF 0x10
no_add2:
    
    MOVLW 0x02 ;WREG = 2
    CPFSEQ 0x10 ;test [0x10] ?= 2, skip if =
	GOTO not_palindrom
    GOTO is_palindrom
is_palindrom:
    MOVLW 0x01
    MOVWF 0x00
    GOTO end_palindrom
not_palindrom:
    MOVLW 0xFF
    MOVWF 0x00
    GOTO end_palindrom
end_palindrom:
    end


