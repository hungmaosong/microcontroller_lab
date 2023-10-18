List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    unsigned_16_add macro oper1_H,oper1_L,oper2_H,oper2_L
	MOVF oper2_L, W ;WREG = [oper2_L]
	ADDWF oper1_L, W ;WREG = [oper1_L] + [oper2_L]
	MOVWF 0x02 ;[0x02] = WREG
	
	MOVF oper2_H, W ;WREG = [oper2_H]
	ADDWFC oper1_H, W ;WREG = [oper1_H] + [oper2_H] + carry
	MOVWF 0x01 ;[0x01] = WREG
    endm
    
    MOVLW 0x07 ;n
    MOVWF 0x00 ;[0x00] = n
    
    ;0x01,0x02 is product
    CLRF 0x01
    CLRF 0x02
    
    ;0x03,0x04 is multiplicand
    CLRF 0x03
    MOVFF 0x000, 0x004 ;[0x004] = n
    
    RCALL fac ;do: n*(n-1)  (n-1)times
    GOTO finish

fac: 
    MOVFF 0x000 ,0x010 ;copy n to [0x010] for mul multiplier
    DECF 0x10 ;multiplier = n - 1
    
    MOVLW 0x04 ;count = 4
    MOVWF 0x11 ;[0x11] = count (for mul)
    
    mul_loop:
	BTFSC 0x10, 0 ;test multiplier LSB, skip LSB = 0
	    GOTO add
	GOTO end_add
	
	add:
	    unsigned_16_add 0x01,0x02,0x03,0x04 ;add product and multiplicand
	    GOTO end_add
	end_add  
	    
	;shift multiplier right 1 bit
	RRNCF 0x10, F
	BCF 0x10, 7
	
	;shift multiplicand left 1 bit
	RLCF 0x04, F
	BCF 0x04, 0
	BC if_carry
	GOTO if_no_carry
	if_carry:
	    RLNCF 0x03, F
	    BSF 0x03, 0
	    GOTO end_if
	if_no_carry:
	    RLNCF 0x03, F
	    BCF 0x03, 0
	    GOTO end_if
	end_if:
    
        DECFSZ 0x11 ;test count-1 ?= 0, skip if =
	    GOTO mul_loop
	
    ;0x03,0x04 is multiplicand(prepare next time)
    MOVFF 0x001, 0x003
    MOVFF 0x002, 0x004
    CLRF 0x01
    CLRF 0x02
    
    MOVLW 0x01 ;WREG = 0x01
    DECF 0x00 ;n = n - 1
    CPFSEQ 0x00 ;test n==1, skip if =
	GOTO fac
	
;put the answer into right address	
MOVFF 0x003,0x001
MOVFF 0x004,0x002
RETURN
finish:
    end


