#include <p16f628a.inc>
	list p=16f628a
	__CONFIG _CP_OFF&_WDT_OFF&_PWRTE_ON&_XT_OSC
;=== Регистр для длительности импульса
Reg_1 equ 20h ;счетчик для длительности импульса
Reg_2 equ 21h
Flag equ 22h
	ORG	0x000
	GOTO MAIN
;====================================================
;				ОСНОВНАЯ ПРОГРАММА
;====================================================
MAIN
	bsf STATUS,RP0 ; Переход в 1-й банк.
	movlw b'01111010' ; RB5 работает
	movwf TRISB ; на вход остальные выход

	bcf STATUS,RP0 ; Переход в 0-й банк.
;------------------------------------------------------
;		ОЖИДАНИЕ ИНИЦИАЛИЗАЦИИ И ПОДАЧА ИМПУЛЬСА
;------------------------------------------------------
WAIT

	btfss PORTB,5 ; Если RB3 опущен, то ждем его поднятия.
	goto $-1 ; Если RB3 поднялся, то программа исполняется далее.
;----------------------------------
;	НЕОБХОДИМАЯ ЗАДЕРЖКА
;----------------------------------
	call delay
;---------------------------------
;================== ГЕНЕРАЦИЯ ИМПУЛЬСОВ
;---------------------------------
	bsf         PORTB,2     ; передача единицы
    call        Pause      
	bcf         PORTB,2     ; передача нуля


;============ ОСНОВНАЯ ЗАДЕРЖКА +79 - 74 мкс
	;decfsz Flag, F
;=================== 800 us
	btfsc 	    PORTB, 1
	call        Pause2
;================ 1920 мкс ==========
	btfsc 	    PORTB, 3
	call        Pause3
	btfsc 	    PORTB, 4
	call        Pause4
	btfsc 	    PORTB, 6
	call        Pause5
otraj	
	bsf         PORTB,2     ; передача единицы
	call        Pause      
	bcf         PORTB,2     ; передача нуля
	goto WAIT ; отпускаем и переходим на ожидание
	;==========================================
	;		РЕАЛИЗАЦИЯ ЗАДЕРЖКИ 104 МКС (9600)
	;==========================================
Pause       
	    movlw       .23
            movwf       Reg_1
            decfsz      Reg_1,F
            goto        $-1
			return

;=================== 800 ============

Pause2       
	    movlw       .253
            movwf       Reg_1
            decfsz      Reg_1,F
            goto        $-1
    	    goto otraj	
;================ 3000 мкс ============
Pause4		
	    movlw       .228
            movwf       Reg_1
            movlw       .4
            movwf       Reg_2
            decfsz      Reg_1,F
            goto        $-1
            decfsz      Reg_2,F
            goto        $-3
            nop
	    goto otraj
;================ 1920 мкс ==========
Pause3  
	    movlw       .125
            movwf       Reg_1
            movlw       .3
            movwf       Reg_2
            decfsz      Reg_1,F
            goto        $-1
            decfsz      Reg_2,F
            goto        $-3
	    movlw .2
	    movwf Flag
	    goto otraj

;=============== 4200 мкс ===========

Pause5
	    movlw       .115
            movwf       Reg_1
            movlw       .6
            movwf       Reg_2
            decfsz      Reg_1,F
            goto        $-1
            decfsz      Reg_2,F
            goto        $-3
	    return	

delay 	    movlw       .116
            movwf       Reg_1
            decfsz      Reg_1,F
            goto        $-1
            nop
	return

end 