List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    LIST_INIT macro n1,n2,n3,n4,n5,n6,n7
	LFSR 0, 0x400 ;set pointer FSR0 = 0x400
	MOVLW n1
	MOVWF POSTINC0
	MOVLW n2
	MOVWF POSTINC0
	MOVLW n3
	MOVWF POSTINC0
	MOVLW n4
	MOVWF POSTINC0
	MOVLW n5
	MOVWF POSTINC0
	MOVLW n6
	MOVWF POSTINC0
	MOVLW n7
	MOVWF POSTINC0
    endm
    
    LIST_INIT  0x01, 0x03, 0x05, 0x07, 0x06, 0x04, 0x02
    
    MOVLB 4 ;bank = 4
    CLRF 0x20, 1 ;count = 0, if count == 6, it is mountain array
    LFSR 0, 0x400 ;first pointer
    LFSR 1, 0x401 ;second pointer
    RCALL MOUNTAIN
    GOTO finish
    
MOUNTAIN:    
increase:
    MOVF INDF0, W ;WREG = [first]
    CPFSGT INDF1 ;test [second] ?> [first], skip if >
	GOTO decrease
	
    INCF 0x20, F, 1 ;count++
    INCF FSR0L ;first++
    INCF FSR1L ;second++
    
    MOVLW 0x06
    CPFSEQ FSR0L ;test first ?= 6, skip if =
	GOTO increase
    GOTO end_decrease
end_increase:
    
decrease:
    MOVF INDF0, W ;WREG = [first]
    CPFSLT INDF1 ;test [second] ?< [first], skip if <
	GOTO end_decrease
	
    INCF 0x20, F, 1 ;count++
    INCF FSR0L ;first++
    INCF FSR1L ;second++
    
    MOVLW 0x06
    CPFSEQ FSR0L ;test first ?= 6, skip if =
	GOTO decrease
    GOTO end_decrease
end_decrease:
    
    MOVLW 0xFF
    MOVWF 0x10, 1 ;[0x410] = 0xFF
    
    MOVLW 0x06
    CPFSEQ 0x20, 1 ;test [0x420] ?= 6, skip if =
	RETURN
    
    MOVLW 0x01
    MOVWF 0x10, 1 ;[0x410] = 0x01
    RETURN
finish:    
    end


