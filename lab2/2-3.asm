List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLB 0x01 ;BSR = 1
    
    MOVLW 0xB5 
    MOVWF 0x10,1 ;WREG to 0x110
    MOVLW 0xF8
    MOVWF 0x11,1 ;WREG to 0x111
    MOVLW 0x64
    MOVWF 0x12,1 ;WREG to 0x112
    MOVLW 0x7F
    MOVWF 0x13,1 ;WREG to 0x113
    MOVLW 0xA8
    MOVWF 0x14,1 ;WREG to 0x114
    MOVLW 0x15
    MOVWF 0x15,1 ;WREG to 0x115
    
    LFSR 0, 0x110 ;left
    LFSR 1, 0x115 ;right
    LFSR 2, 0x110 ; i (initialize i = left)
    ;be aware of shifting i, when use arr[i-1] ,remember to shift i back!!!! 
while_loop:
    MOVF FSR1L, W ;WREG = right
    CPFSLT FSR0L ;if left < right, skip nextline
	GOTO end_while_loop
    
    MOVFF FSR0L, FSR2L ;i = left
for1:
    MOVF FSR1L, W ;WREG = right
    CPFSLT FSR2L ;if i < right, skip nextline
	GOTO end_for1
    
    MOVF PREINC2, W ;WREG = arr[i+1] 
    DECF FSR2L, F ;i = i-1
if1:
    CPFSGT INDF2 ;if arr[i] > arr[i+1], skip nextline
	GOTO end_if1
    MOVFF INDF2, 0x00 ;temp = arr[i] 
    MOVWF POSTINC2 ;arr[i] = WREG(arr[i+1]) ;i = i+1
    MOVFF 0x000, POSTDEC2; ;arr[i+1] = temp ;i = i-1
end_if1:
    INCF FSR2L ;i++
    GOTO for1
end_for1:
   
    DECF FSR1L ;right--
    
    MOVFF FSR1L, FSR2L ;i = right
for2:
    MOVF FSR0L, W ;WREG = left
    CPFSGT FSR2L ;if i > left, skip nextline
	GOTO end_for2
	
    MOVF POSTDEC2, W ;WREG = arr[i] ;i=i-1
if2:
    CPFSGT POSTINC2 ;if arr[i-1] > WREG(arr[i]); skip nextline ;i=i+1
	GOTO end_if2
    MOVWF 0x00 ;WREG(arr[i]) to temp
    DECF FSR2L ;i=i-1
    MOVF POSTINC2, W ;WREG = arr[i-1] ; i=i+1
    MOVWF POSTDEC2 ;arr[i] = WREG(arr[i-1]) ;i=i-1
    MOVFF 0x000, POSTINC2 ;arr[i-1] = temp(arr[i]) ;i=i+1
end_if2:
    DECF FSR2L ;i--
    GOTO for2
end_for2:
    
    INCF FSR0L ;left++
    GOTO while_loop
end_while_loop:
    end