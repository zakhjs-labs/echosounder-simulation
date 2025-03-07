#include <p16f628a.inc>
	list p=16f628a
	__CONFIG _CP_OFF&_WDT_OFF&_PWRTE_ON&_XT_OSC
;=== ������� ��� ������������ ��������
Reg_1 equ 20h ;������� ��� ������������ ��������
Reg_2 equ 21h
Flag equ 22h
	ORG	0x000
	GOTO MAIN
;====================================================
;				�������� ���������
;====================================================
MAIN
	bsf STATUS,RP0 ; ������� � 1-� ����.
	movlw b'01111010' ; RB5 ��������
	movwf TRISB ; �� ���� ��������� �����

	bcf STATUS,RP0 ; ������� � 0-� ����.
;------------------------------------------------------
;		�������� ������������� � ������ ��������
;------------------------------------------------------
WAIT

	btfss PORTB,5 ; ���� RB3 ������, �� ���� ��� ��������.
	goto $-1 ; ���� RB3 ��������, �� ��������� ����������� �����.
;----------------------------------
;	����������� ��������
;----------------------------------
	call delay
;---------------------------------
;================== ��������� ���������
;---------------------------------
	bsf         PORTB,2     ; �������� �������
    call        Pause      
	bcf         PORTB,2     ; �������� ����


;============ �������� �������� +79 - 74 ���
	;decfsz Flag, F
;=================== 800 us
	btfsc 	    PORTB, 1
	call        Pause2
;================ 1920 ��� ==========
	btfsc 	    PORTB, 3
	call        Pause3
	btfsc 	    PORTB, 4
	call        Pause4
	btfsc 	    PORTB, 6
	call        Pause5
otraj	
	bsf         PORTB,2     ; �������� �������
	call        Pause      
	bcf         PORTB,2     ; �������� ����
	goto WAIT ; ��������� � ��������� �� ��������
	;==========================================
	;		���������� �������� 104 ��� (9600)
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
;================ 3000 ��� ============
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
;================ 1920 ��� ==========
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

;=============== 4200 ��� ===========

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