List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
    
	MOVLW 0x07 ;x1
	MOVWF 0x00 ;WREG to 0x00
	MOVLW 0x08 ;x2
	MOVWF 0x01 ;WREG to 0x01
	
	ADDWF 0x00, W ;x1+x2 to WREG
	MOVWF 0x10 ;WREG to 0x10
	
	MOVLW 0x0D ;y1
	MOVWF 0x02 ;WREG to 0x02
	MOVLW 0x0C ;y2
	MOVWF 0x03 ;WREG to 0x03
	
	SUBWF 0x02, W ;y1-y2 to WREG
	MOVWF 0x11 ;WREG to 0x11
	
	CPFSEQ 0x10 ;compare 0x10 and 0x11's number is equal(skip if equal)
	    MOVLW 0x01 ;WREG = 0x01
	CPFSEQ 0x10  ;compare 0x10 and 0x11's number is equal(skip if equal)  
	    GOTO out
	MOVLW 0xFF ;WREG = 0xFF
out:
	MOVWF 0x20 ;WREG to 0x20
	 
end