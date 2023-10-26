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
    
    MOVLB 4 ;BSR = 4
    MOVLW 0x0D ;target value
    MOVWF 0x22, 1 ;[0x422] = target value
    RCALL TWO_SUM
    GOTO finish
    
TWO_SUM:    
    LFSR 1, 0x400 ;set pointer FSR1 = 0x400, for outer loop i
    LFSR 2, 0x401 ;set pointer FSR1 = 0x401, for inner loop j
outer_loop:
    MOVF FSR1L, W ;WREG = FSR1L
    INCF WREG ;WREG++
    MOVWF FSR2L ;set j
    
    inner_loop:
    MOVF INDF1, W ;WREG = [i]
    ADDWF INDF2, W ;WREG = [i] + [j]
    CPFSEQ 0x22, 1 ;test WREG ?= [0x422],skip if =
	GOTO continue_inner_loop
    GOTO find_two_sum
    continue_inner_loop:
    INCF FSR2L ;j++
    MOVLW 0x07
    CPFSEQ FSR2L ;check j ?= 7, skip if =
	GOTO inner_loop	
    end_inner_loop:
    
    INCF FSR1L ;i++
    MOVLW 0x06
    CPFSEQ FSR1L ;check i ?= 6, skip if =
	GOTO outer_loop
end_outer_loop:
    RETURN
    
find_two_sum:
    MOVFF INDF1, 0x420
    MOVFF INDF2, 0x421
    RETURN
    
finish:
    end


