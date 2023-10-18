List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    LIST_INIT macro addr,n1,n2,n3,n4,n5
	LFSR 0, addr ;FSR0 = addr
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
    endm
    
    LIST_INIT 0x000,0x01,0x03,0x06,0x0B,0x0F
    LIST_INIT 0x005,0x03,0x05,0x0c,0x10,0xBA
    
    MOVLW 0x00 ;WREG = 0x00
    MOVWF FSR0L ;FSR0 = 0x00
    LFSR 1, 0x005 ;FSR1 = 0x005
    LFSR 2, 0x010 ;FSR2 = 0x010
    RCALL MERGE_LIST
    GOTO finish
    
    MERGE_LIST: ;compare [FSR0] and [FSR1], push smaller into INDF2
    
    MOVLW 0x1A ;WREG = 0x1A
    CPFSEQ FSR2L ;test FSR2 == 0x1A, skip if =
	GOTO continue_MERGE_LIST
    GOTO end_MERGE_LIST
    
    continue_MERGE_LIST:
    
    MOVLW 0x05 ;WREG = 0x05
    CPFSEQ FSR0L ;test FSR0 == 0x05, skip if = (first array is over)
	GOTO continue_compare_FSR1
    GOTO indf1_is_small
	
    continue_compare_FSR1:
    MOVLW 0x0A ;WREG = 0x0A
    CPFSEQ FSR1L ;test FSR1 == 0x0A, skip if = (second array is over)
	GOTO continue_compare
    GOTO indf0_is_small
    
    continue_compare:
    MOVF INDF1, W ;WREG = [FSR1]
    CPFSGT INDF0 ;test [FSR0] > [FSR1], skip if >
	GOTO indf0_is_small
    GOTO indf1_is_small    
    indf0_is_small:
	MOVFF POSTINC0, POSTINC2
	GOTO end_compare
    indf1_is_small:
	MOVFF POSTINC1, POSTINC2
	GOTO end_compare 
    end_compare:
   
    GOTO MERGE_LIST
    
    end_MERGE_LIST:
    RETURN
    
    finish:
    end


