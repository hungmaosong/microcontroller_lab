List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x0A ;n
    MOVWF 0x01 ;[0x01] = n
    MOVLW 0x05 ;k
    MOVWF 0x02 ;[0x02] =k
    
    MOVLW 0x00 ;i
    MOVWF 0x03 ;[0x03] = i
    MOVLW 0x00 ;j
    MOVWF 0x04 ;[0x04] =j
    
    LFSR 0, 0x000
    
    RCALL Fact
    GOTO finish
Fact:
OuterLoop:
    
    MOVLW 0x00
    MOVWF 0x04 ;initialize j
    InnerLoop:
	MOVLW 0x10 ;WREG = 16
	MULWF 0x03, W ;WREG = 16*i
	MOVF PRODL, W
	ADDWF 0x04, W ;WREG = 16*i+j
	MOVWF 0x05
	MOVFF 0x005, FSR0L
	CLRF INDF0
        ; inner code
	if1:
	    MOVLW 0x00
	    CPFSEQ 0x04 ;if j=0,skip next
		GOTO not_0
	    GOTO is_0
	is_0:
	    INCF INDF0
	    GOTO end_if
	not_0:
    
	if2:
	    MOVF 0x03, W ;WREG = i
	    SUBWF 0x04, W ;j-i
	    BTFSS  STATUS, Z
		GOTO not_same
	    GOTO is_same
	is_same:
	    INCF INDF0
	    GOTO end_if
	not_same:
	
	if3:
	    ;up_left ([0x06]) ,use  FSR1 to point
	    DECF 0x03, W ;WREG = i-1
	    MOVWF 0x06    
	    MOVLW 0x10 ;WREG = 16
	    MULWF 0x06, W ;WREG = 16*i
	    MOVF PRODL, W
	    ADDWF 0x04, W ;WREG = 16*i+j
	    MOVWF 0x06
	    DECF 0x06, F
	    MOVFF 0x006, FSR1L
	    ;up ([0x07]) ,use  FSR2 to point
	    DECF 0x03, W ;i-1
	    MOVWF 0x07
	    MOVLW 0x10 ;WREG = 16
	    MULWF 0x07, W ;WREG = 16*(i-1)
	    MOVF PRODL, W
	    ADDWF 0x04, W ;WREG = 16*i+j
	    MOVWF 0x07
	    MOVFF 0x007, FSR2L
	    
	    MOVF INDF1, W
	    ADDWF INDF2, W
	    MOVWF INDF0
	    
	end_if:
        INCF 0x04       ;j++
	DECF 0x04, W
        SUBWF 0x03, W  ; compare j and i 
        BTFSS STATUS, Z  ;if j <= i,GOTO InnerLoop
	    GOTO InnerLoop

    ;end inner loop

    INCF 0x03       ;i++
    MOVLW 0x0B ;WREG = 11
    SUBWF 0x03, W ; compare i and 11
    BTFSS STATUS, Z  ; compare i <= 10,GOTO OuterLoop
	GOTO OuterLoop

; end outer loop
	RETURN
finish:
    
    ;find answer
    MOVLW 0x10 ;WREG = 16
    MULWF 0x01, W ;WREG = 16*n
    MOVF PRODL, W
    ADDWF 0x02, W ;WREG = 16*n+k
    MOVWF 0x08
    MOVFF 0x008, FSR0L
    
    ;MOVFF INDF0, 0x00A
    MOVFF INDF0, 0x000 ;put answer on the correct address
    end
    


