List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x08 ;Multiplicand
    MOVWF TRISA ;TRISA = WREG
    MOVLW 0x0B ;Multiplier
    MOVWF TRISB ;TRISB = WREG
    
    ;////////////1st////////////
    MOVLW 0x00 ;WREG = 0 (initialize Product)
    MOVWF 0x01  ;initialize 0x01
    MOVF 0x01 , W ;WREG = [0x01](Product)
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	ADDWF TRISA , W ;WREG = WREG + TRISA
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	MOVWF 0x01 ;[0x01] = WREG
	
    ;shift Multiplier right 1bit
    RRNCF TRISB
    BCF TRISB, 7 
    
    ;shift Multiplicand left 1bit
    RLNCF TRISA
    BCF TRISA, 0
    
    ;////////////2nd////////////
    MOVF 0x01 , W ;WREG = [0x01](Product)
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	ADDWF TRISA , W ;WREG = WREG + TRISA
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	MOVWF 0x01 ;[0x01] = WREG
	
    ;shift Multiplier right 1bit
    RRNCF TRISB
    BCF TRISB, 7 
    
    ;shift Multiplicand left 1bit
    RLNCF TRISA
    BCF TRISA, 0
    
    ;////////////3rd////////////
    MOVF 0x01 , W ;WREG = [0x01](Product)
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	ADDWF TRISA , W ;WREG = WREG + TRISA
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	MOVWF 0x01 ;[0x01] = WREG
	
    ;shift Multiplier right 1bit
    RRNCF TRISB
    BCF TRISB, 7 
    
    ;shift Multiplicand left 1bit
    RLNCF TRISA
    BCF TRISA, 0
    
    ;////////////4th////////////
    MOVF 0x01 , W ;WREG = [0x01](Product)
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	ADDWF TRISA , W ;WREG = WREG + TRISA
    BTFSC TRISB ,0 ;test Multiplier's LSB, skip if 0
	MOVWF 0x01 ;[0x01] = WREG
	
    ;shift Multiplier right 1bit
    RRNCF TRISB
    BCF TRISB, 7 
    
    ;shift Multiplicand left 1bit
    RLNCF TRISA
    BCF TRISA, 0
    
    MOVFF 0x001, TRISC
    end
