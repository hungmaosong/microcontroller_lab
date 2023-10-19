List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLF macro addr,num
	MOVLW num ;WREG = num
	MOVWF addr ;[addr] = num
    endm
    
    MOVLF 0x00, 0x05
    MOVLF 0x01, 0x04
    MOVLF 0x02, 0x02
    MOVLF 0x03, 0x07
    MOVLF 0x04, 0x08
    
    MOVLF 0x0F, 0x04 ;[0x0F] (k) = 2
    
    ;copy array for circular calculation
    MOVFF 0x000, 0x005
    MOVFF 0x001, 0x006
    MOVFF 0x002, 0x007
    MOVFF 0x003, 0x008
    MOVFF 0x004, 0x009
    
    MOVLW 0x00 ;WREG = 0
    CPFSEQ 0x0F ;test k, skip if k = 0
	GOTO if_k_is_not_0
    GOTO if_k_is_0

if_k_is_0: ;if k = 0, set the ith number of answer array is 0
    MOVLF 0x10, 0x00
    MOVLF 0x11, 0x00
    MOVLF 0x12, 0x00
    MOVLF 0x13, 0x00
    MOVLF 0x14, 0x00
    GOTO end_if
    
if_k_is_not_0:
    LFSR 0, 0x010 ;FSR0 = 0x010 ,point to answer array
    LFSR 1, 0x000 ;FSR1 = 0x000 ,point to old array
    LFSR 2, 0x001 ;FSR2 = 0x001 ,point to old array(start add position)
    
outer_for:
    ;set FSR2 ,point to old array(start add position)
    MOVFF FSR1L, FSR2L
    INCF FSR2L, F
    
    CLRF INDF0
    MOVFF 0x00F, 0x01F ;count = k
    inner_for_loop:
	MOVF POSTINC2, W ;WREG = [FSR2], FSR2++
	ADDWF INDF0, F ;[FSR0] = [FSR0] + [FSR2]
	DECFSZ 0x1F ;test counter-1 ?= 0, skip if =
	    GOTO inner_for_loop
    end_inner_for_loop:
    
    INCF FSR0L ;FSR0++
    INCF FSR1L ;FSR1++
    MOVLW 0x15
    CPFSEQ FSR0L ;test FSR0 ?= 0x15, skip if =
	GOTO outer_for
end_outer_for:
end_if:
    end


