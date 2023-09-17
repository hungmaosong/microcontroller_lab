List p=18f4520 
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	MOVLB 0x01 ;BSR = 1
	
	MOVLW 0xB5 ;WREG =  0xB5
	MOVWF 0x10, 1 ;[0x110] = 0xB5
	MOVLW 0xF8 ;WREG = 0xF8
	MOVWF 0x11, 1 ;[0x111] = 0xF8
	MOVLW 0x64 ;WREG = 0x64
	MOVWF 0x12, 1 ;[0x112] = 0x64
	MOVLW 0x7F ;WREG = 0x7F
	MOVWF 0x13, 1 ;[0x113] = 0x7F
	MOVLW 0xA8 ;WREG = 0xA8
	MOVWF 0x14, 1 ;[0x114] = 0xA8
	MOVLW 0x15 ;WREG = 0x15
	MOVWF 0x15, 1 ;[0x115] = 0x15
	
	LFSR 0, 0x110 ;FRS0 point to 0x110(left)
	LFSR 1, 0x115 ;FRS1 point to 0x115(right)
	LFSR 2, 0x110 ;FRS2 point to 0x110(i)
	
	MOVLW d'10' 
	MOVWF 0x10 ;[0x10] = 10 ;to record pointer i -> (count)
	MOVWF 0x11 ;[0x11] = 10 ;to record pointer left -> (count)
	MOVLW d'15'
	MOVWF 0x12 ;[0x12] = 15 ;to record pointer right -> (count)
	;(count) : record i,left,right's address
	
	MOVLW d'5' ;counter=5
	MOVWF 0x13 ;[0x13] = counter
	MOVLW d'0' ;counter2=0 (for i = right)
	MOVWF 0x14 ;[0x14] = counter2	
	; counter,counter2 : for setting i = right (the second loop)
while_loop:
    for_loop:
	MOVFF INDF2, 0x000 ;copy (i) to [0x000] ;point does not move
	MOVF PREINC2, W ;i = i+1 (WREG = arr[i+1])
	CPFSGT 0x00 ;if(arr[i]>arr[i+1]),skip nextline
	    GOTO end_if1
	if1:
	    MOVFF INDF2, 0x001 ;temp = arr[i+1]
	    MOVFF 0x000, POSTDEC2 ;arr[i+1] = arr[i] ;i=i-1
	    MOVFF 0x001, POSTINC2 ;arr[i] = temp ;i=i+1
	end_if1:
    
	INCF 0x10 ;i++ (count)
	MOVF 0x12, W ;right (count)
	CPFSLT 0x10 ;test i<right, skip if <
	    GOTO end_for_loop
	GOTO for_loop
    end_for_loop:
    
	MOVLW d'0'
	ADDWF POSTDEC1, F ;right--
	DECF 0x12 ;right-- (count)
	DECF 0x13 ;count-- 
	LFSR 2, 0x110 ;FRS2 point to 0x110(i) ->reset i
	
    for_loop2_initialize:
	MOVFF 0x012, 0x010 ;i=right (count)
	INCF 0x14, F ;counter2++
	MOVLW d'0'
	ADDWF POSTINC2, F ;[i] = [i] + WREG(0) ;i++
	MOVF 0x13, W ;WREG = counter 
	CPFSEQ 0x14 ;test counter2 = counter, skip if =
	    GOTO for_loop2_initialize
    for_loop2:	
	MOVFF POSTDEC2, 0x000 ;copy arr[i] to [0x000] ;i = i-1 ->trash
	MOVFF POSTINC2, 0x000 ;copy arr[i-1] to [0x000] ;i = i+1
	MOVF INDF2, W ;(WREG = arr[i])
	CPFSGT 0x00  ;if(arr[i-1]>arr[i]),skip nextline
	    GOTO end_if2
	if2:
	    MOVFF POSTDEC2, 0x001 ;temp = arr[i] ;i = i - 1
	    MOVFF 0x001, POSTINC2 ;arr[i-1] = arr[i-1] ;i=i+1
	    MOVFF 0x000, POSTDEC2 ;arr[i] = temp ;i=i-1
	    DECF 0x10, F ;i--
	end_if2:
	
	MOVF 0x11, W ;WREG = left(count)
	CPFSGT 0x10 ;test i>left (count),skip if >
	    GOTO end_for_loop2
	GOTO for_loop2
    end_for_loop2:
    
	MOVLW d'0'
	ADDWF POSTINC0, F ;left++
	INCF 0x11 ;left++ (count)
	
	MOVF 0x12, W ;WREG = right (count)
	CPFSLT 0x11 ;if(left < right),skip nextline
	    GOTO end_while_loop
	GOTO while_loop
end_while_loop:
	NOP
	end


