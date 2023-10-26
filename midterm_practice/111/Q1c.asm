List p=18f4520
    #include<p18f4520.inC>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x05 ;n
    MOVWF 0x01 ;[0x01] = n
    MOVLW 0x03 ;m
    MOVWF 0x02 ;[0x02] = m
    SUBWF 0x01, W ;WREG = n-m
    MOVWF 0x03 ;[0x03] = n-m
    
    ;make m always < n-m
    MOVF 0x03, W
    CPFSLT 0x02 ;test m ?< n-m, skip if <
	MOVFF 0x003, 0x004 ;temp = n-m
    CPFSLT 0x02 ;test m ?< n-m, skip if <
	MOVFF 0x002, 0x003 ;n-m = m
    CPFSLT 0x02 ;test m ?< n-m, skip if <
	MOVFF 0x004, 0x002 ;m = temp
	
    ;test special case1 : m or n-m=0
    MOVLW 0x00 ;WREG = 0
    CPFSGT 0x02 ;test m ?> 0 ;skip if >
	GOTO special_case1
	
    CPFSGT 0x03 ;test n-m ?> 0 ;skip if >
	GOTO special_case1
    
    ;test special_case2 : m or n-m = 1
    MOVLW 0x01 ;WREG = 1
    CPFSEQ 0x02 ;test m ?= 1 ;skip if =
	GOTO continue1
    GOTO special_case2
continue1:	
    CPFSEQ 0x03 ;test n-m ?= 1 ;skip if =
	GOTO continue2
    GOTO special_case2
continue2:
    
    MOVFF 0x002, 0x012 ;copy m to [0x012](count)
    DECF 0x12 ;count = m - 1
    
    MOVFF 0x001, 0x011 ;;copy m to [0x011](for mul)
for_mul:
    DECF 0x11 ;n-1
    MOVF 0x11, W ;WREG = [0x11] = n-1
    MULWF 0x01 ;n * (n-1)
    MOVFF PRODL, 0x01 ;update product
    
    DECFSZ 0x12 ;count-- , skip if count = 0
	GOTO for_mul

    MOVFF 0x002, 0x022 ;copy m to [0x022](count2)
    DECF 0x22 ;count2 = m - 1
    MOVFF 0x002, 0x032 ;copy m to [0x032]
    DECF 0x32 ;m - 1
end_for_mul:   
    
for_mul2: ;calculate m!
    MOVF 0x32, W ;WREG = m-1
    MULWF 0x02 ;m * (m-1)
    MOVFF PRODL, 0x002 ;update product
    DECF 0x32 ;(m-1) - 1
    DECFSZ 0x22 ;count2-- , skip if count2 = 0
	GOTO for_mul2
end_for_mul2:
    
    CLRF 0x00
division:
     MOVF 0x02, W ;WREG = [0x02]
     SUBWF 0x01, F ;[0x01] = [0x01] - WREG
     INCF 0x00
     MOVF 0x02, W ;WREG = [0x02]
     CPFSLT 0x01 ;test [0x01] ?< [0x02], skip if <
	GOTO division
    GOTO finish
    
special_case1: ;m or n-m=0
    MOVLW 0x01
    MOVWF 0x00 ;ans = 1
    GOTO finish
    
special_case2: ;m or n-m = 1
    MOVF 0x01, W
    MOVWF 0x00 ;ans = n
    GOTO finish
finish:
    end


