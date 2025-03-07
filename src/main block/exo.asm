#include <p16f628a.inc>
	list p=16f628a
	__CONFIG _CP_OFF&_WDT_OFF&_PWRTE_ON&_XT_OSC

dlit1_h equ 20h ;������������
dlit1_l equ 21h	;��� 1-� �������
dlit2_h equ 22h ;������������
dlit2_l equ 23h ;��� 2-� �������
BitZ equ 24h	;������� ��� ����������� �����
Flag equ 25h	;���� ��� ���������� � ��������� ���-���
Mnoj equ 26h ;��������� 72
del_l equ 27h ;�������� 1000
del_h equ 31h ;��������
dlit2_hh equ 28h ;������� ���� ���������
Rez_LL equ 29h ;������� ���� ����������
Rez_LH equ 30h 
Drob_L equ 32h
Drob_H equ 33h
;===== ���������� ��� ������ �� ������� =======
Sot equ 44h
Dec equ 35h
Edin equ 36h
drob equ 37h
del_100 equ 38h
del_10 equ 39h
Sot_h equ 3Ah
Prom_h equ 45h
Prom_l equ 46h




	ORG	0x000
	GOTO MAIN
	ORG 0x04
	;======================================================
	;			�������� �� ����� ����������
 	;======================================================
	;---------------------------------------

	decfsz Flag,F ; Flag-1 ��������� ����������� � Flag.
	goto WRITE_1 ; ���� ��������� �� 0, �� ������������ 1-� ����������.
	; ���� ��������� =0, �� ������������ 2-� ����������.
	
	;--------------------------------------------------------------
	;			 2-� ���������� (�����������).
	;--------------------------------------------------------------
	movf CCPR1L,W ; ���������� �������� CCPR1L
	movwf dlit2_l ; ���������� � ������� dlit2_l.
	movf CCPR1H,W ; ���������� �������� CCPR1H
	movwf dlit2_h ; ���������� � ������� dlit2_h.
	bsf STATUS,Z ; ��������� �������� ����� ������ �������.
	bcf PIR1,CCP1IF ; ����� ����� CCP1IF.
	retfie ; ������� �� ����������.

	;--------------------------------------------------------------
	; 			1-� ���������� (�����������).
	;--------------------------------------------------------------
WRITE_1 
	movf CCPR1L,W ; ���������� �������� CCPR1L
	movwf dlit1_l ; ���������� � ������� dlit1_l.
	movf CCPR1H,W ; ���������� �������� CCPR1H
	movwf dlit1_h ; ���������� � ������� dlit1_h.
	bcf STATUS,Z ; ��������� �������� ����������� ������ �������.
	bcf PIR1,CCP1IF ; ����� ����� CCP1IF.
	retfie ; ������� �� ����������.
	;****************************************************************

	;================================================
	;				�������� ���������
	;================================================

MAIN
	bsf STATUS,RP0 ; ������� � 1-� ����.
	movlw b'00001000' ; RB3 ��������
	movwf TRISB ; �� ���� ��������� �����
	bsf OPTION_REG,7 ; ���������� �� ����� ������ ������������� ���������� ����� �.
	bcf STATUS,RP0 ; ������� � 0-� ����.
	bsf PORTB,2 ; ��������� 1 - "����� ��������"
	movlw .2 ; ������, � ��������� ����� ������ �������,
	movwf Flag ; ���������� "������" � ����������.
	;--------------------------------------
	; 		 ��������� ������ TMR1.
	;--------------------------------------
	movlw b'00000001' ; TMR1 �������, ���������� ����,
	movwf T1CON ; ����. ������������ = 1 1���.
	clrf TMR1L
	clrf TMR1H
	;--------------------------------------
	;		 ��������� ������ CCP.
	;--------------------------------------
	clrf CCP1CON ; ���������� ������ CCP
	movlw b'00000101' ;������ �� ������� ��������� ������
	movwf CCP1CON ; ������ ������� �� ������ RB3.
	;--------------------------------------
	; 	����� ����� �������� ����������
	; 	� ����� ���������� �� ������ CCP.
	;--------------------------------------
	bcf STATUS,Z ; ���������� ����� Z � ������.
	bcf PIR1,CCP1IF ; ����� ����� CCP1IF.
	;-----------------------------------------------------------------
	; 			���������� ���������� �� ������ CCP,
	; 		� ������������� �������� ����� ������ CCP.
	;-----------------------------------------------------------------
	movlw b'11000000' ; ���������� ���������� ���������� �
	movwf INTCON ; ���������� ���������� �� ������������ �������.
	bsf STATUS,RP0 ; ������� � 1-� ����.
	movlw b'00000100' ; ���������� ����������
	movwf PIE1 ; �� ������ CCP.	
	bcf STATUS,RP0 ; ������� � 0-� ����.

	;------------------------------------------------------------------	
	;			������������� ������ PIC (��� ��������� ���������)
	;------------------------------------------------------------------
	bsf PORTB, 5 ;������ 1 �� ����� RB5
	nop			 ;� ����� ���������
	nop
	nop
	nop
	bcf PORTB, 5 ;����� ���������, ��� ���� � ������� PIC �������� ������� � ����-��� 5-10 ���
	;--------------------------------------------------------------------------------
	; "���������" �������� � ������� �� ��� ����� 2 ���������� �� ������ CCP.
	;--------------------------------------------------------------------------------
	btfss STATUS,Z ; ���� ���� Z ������, �� ���� ��� ��������.
	goto $-1 ; ���� ���� Z ��������, �� ��������� ����������� �����(��������� �����).
	;--------------------------------------------------------------------------------
	; ������ ���������� � ���������� �������� ����� ������ CCP.
	;--------------------------------------------------------------------------------
	clrf INTCON  ; ������ ����������.
	bsf STATUS,RP0 ; ������� � 1-� ����.
	bcf OPTION_REG,7 ; ��������� ������������� ���������� ����� �.
	bcf STATUS,RP0 ; ������� � 0-� ����.
	;---------------------------------------------------------
	; � dlit1_h/dlit1_l ��������� 1-�� ������,
	; � dlit2_h/dlit2_h ��������� 2-�� ������.
	;================================================================================
	; ��������� ����������� ��������.
	;================================================================================
	; ���������, �� ������, Temp1_H/Temp1_L �� Temp2_H/Temp2_L.
	;---------------------------------------------------------------------
	bcf BitZ,0 ; ������� �������� �������� ���� C.
	movf dlit1_l,W ; dlit2_L - dlit1_L = ...
	subwf dlit2_l,F ; ��������� - � dlit2_L.
	btfss STATUS,C ; ��������� "+" ��� "-" ?
	bsf BitZ,0 ; ���� "-", �� � BitC,0 ������������ 1.
	movf dlit1_h,W ; ���� "+", �� � BitC,0 "�����" �����
	;����������������� 0 � Temp1_H --> W.
	subwf dlit2_h,F ; dlit2_H - dlit1_H ��������� - � dlit2_H.
	btfsc BitZ,0 ; � ���� �0 �������� BitC 0 ��� 1 ?
	decf dlit2_h,F ; ���� 1, �� ���������� dlit2_H
	; ����������������.
	; ���� 0, �� ���������� Temp2_H �� ����������������.
	;====������������� ��������� �������� �������� � dlit2_h dlit2_l====
	;======================================================

	;=================  ������ ������� ======================
	; dlit2_l dlit2_h - increment, mnoj - �������, Rez_L Rez_H - ���������
	;
			 movlw		  .75
			 movwf        Mnoj
			 movlw		  b'11101000'
			 movwf        del_l
			 movlw		  b'00000011'
			 movwf        del_h
;===================== �������� ��������� =====================
axb          clrf         dlit2_hh           ;������� �������� dlit2_hh (������������ ������ ����)
             movlw        .0              ;�������� ����������� "���" ����� ���� � ����� �������� �  
             xorwf        dlit2_l,W         ;�������� dlit2_l: ��� �������� ��������� ���� ����� ��������
             btfss        STATUS,Z        ;� �������� dli2t_l
             goto         a1              ;����� � �������� dlit2_l �� ����� ����: ������� �� ����� a1
             movlw        .0              ;����� � �������� dlit2_l ����� ����: �������� ���������  
             xorwf        dlit2_h,W         ;���� ����� �������� � �������� dlit2_h
             btfsc        STATUS,Z        ;
             return                       ;����� � �������� dlit2_h ����� ����: ����� �� ������������
a1           movlw        .0              ;����� � �������� dlit2_h �� ����� ����: �������� ���������
             xorwf        Mnoj,W         ;���� ����� �������� � �������� Mnoj
             btfsc        STATUS,Z        ;
             goto         a2              ;����� � �������� Mnoj ����� ����: ������� �� ����� a2
             movf         dlit2_l,W         ;����� � �������� Mnoj �� ����� ����: ����������� ����� ��
             movwf        Rez_LL           ;�� ��������� dlit2_l, dlit2_h � �������� Rez_LL, Reg_LH �
             movf         dlit2_h,W         ;�������� ��������� ��� ����������� ��������
             movwf        Rez_LH
a4           decfsz       Mnoj,F         ;��������� (� ��������) �������� Mnoj, ������� Mnoj
                                          ;��������� � �������� �������� ��������                        
             goto         a3              ;������� Mnoj �� ����� ����: ������� �� ����� a3
             goto del                       ;������� Mnoj ����� ����: ����� �� ������������
                                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
a3           movf         Rez_LL,W         ;
             addwf        dlit2_l,F         ;
             btfss        STATUS,C        ;
             goto         a5              ;
             incfsz       dlit2_h,F         ;����������� ������������ ����� (regLH, regLL) � ������������
             goto         a5              ;����� � ��������� varHL, varLH, varLL, �� ���� ��� ��������
             incf         dlit2_hh,F         ;�������� ������������ � ������������ �����
a5           movf         Rez_LH,W         ;
             addwf        dlit2_h,F         ;
             btfsc        STATUS,C        ;
             incf         dlit2_h,F         ;
                                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             goto         a4              ;������� �� ����� a4
a2           clrf         dlit2_l           ;������� ��������� varLL, varLH (������������ ������ ����)
             clrf         dlit2_h
             goto del                       ;����� �� ������������
                                          ;

;==================�������� �������======================
;��������� � ��� ������������ ������� 400 �� = 4 � ���������� ����� 2 �����
;del_l del_h = 1000; dlit2_l dlit2_h - ��������� ��������� �� 75
		;clrf dlit2_l
			;clrf dlit2_h
			;clrf dlit2_hh
			;movlw b'10111110'
		;	movwf dlit2_l	
		;	movlw b'11101100'
		;	movwf dlit2_h
		;	movlw b'00000001'
		;	movwf dlit2_hh

del	         clrf         Rez_LL           ;������� ��������� Rez_LL, Rez_LH (������������ ������ ����)
             clrf         Rez_LH           ;
             movlw        .0              ;�������� ��������� ���� ����� �������� � �������� tmpLL
             xorwf        del_l,W         ;
             btfss        STATUS,Z        ;
             goto         d1              ;����� � �������� del_l �� ����� ����: ������� �� ����� d1
             movlw        .0              ;����� � �������� del_l ����� ����: �������� ��������� ����
             xorwf        del_h,W         ;����� �������� � �������� tmpLH
             btfsc        STATUS,Z        ;
             return                       ;����� � �������� del_h ����� ����: ����� �� ������������
                                          ;(�� ���� ������ ������)
                                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
d1           movf 		  dlit2_l, W
			 movwf		  Drob_L
			 movf 		  dlit2_h, W
			 movwf		  Drob_H
			 movf         del_l,W         ;����� � del_h �� ����� ����: �������� ����� ������� � ���������
             subwf        dlit2_l,F         ;del_h, del_l �� ����� � ��������� dlit2_h, dlit_l: ��� ��������
             btfsc        STATUS,C        ;��������� ����������� �����
             goto         d2              ;��� ������������� ���������� ���������� ����� �� ������������
             movlw        .1              ;��� ������������� ���������� �������������� ������� ���������
             subwf        dlit2_h,F         ;rezLL, rezLH
             btfss        STATUS,C        ;
			 goto		  d3                     ;          
d2           movf         del_h,W         ;
             subwf        dlit2_h,F         ;
             btfss        STATUS,C        ;
			 goto 		  d3
			 goto 		  inc                                    ;
d3 			 movlw        .1
			 subwf		  dlit2_hh
             btfss        STATUS,C        ;
             goto delSot
			 goto inc
		         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inc          incfsz       Rez_LL,F         ;��������� rezLL � ��������� �� ������������      
             goto         d1              ;��� ������������ rezLL: ������� �� ����� d1
             incf         Rez_LH,F         ;������������ rezLL: ��������� �������� rezLH (�������� rezLL, rezLH  
                                          ;��������� � �������� �������� ��������� � �������� ��������� �������)
             goto         d1              ;������� �� ����� d1 ��� ���������� ���������, �������� �������
                                          ;������������ ����� ������������ ���������                                         ;
;========= ��������� � ������� ��������� � Rez_H � Rez_L - ����� ����� � 
;========= Drob_H Drob_L - ������� �����


;====================  ���������� �����, ������� � ����. ================
delSot 		 
		
			movlw		.100
			movwf       del_100
			movlw		 .10
			movwf       del_10
			clrf Sot  
			clrf         Edin           ;������� �������� rezLL (������������ ������ ����)
            clrf  		  Dec    
d12			 movf Rez_LL,W
			 movwf Prom_l			 
			 movf Rez_LH,W
			 movwf Prom_h			 		 
			 movf         del_100,W         ;����� � tmpLL �� ����� ����: �������� ����� ������� � ��������
             subwf        Rez_LL,F         ;tmpLL �� ����� � ��������� varLH, varLL: ��� �������� ���������
             btfsc        STATUS,C        ;������������ ����� �� ������������
             goto         d22              ;��� ������������� ���������� ���������� ����� �� ������������
             movlw        .1              ;��� ������������� ���������� �������������� ������� ���������
             subwf        Rez_LH,F         ;�������� �� ����� d2
             btfss        STATUS,C        ;
             goto delDec                       ;
                                          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
d22          incfsz       Sot,F         ;��������� rezLL � ��������� �� ������������      
             goto         d12              ;��� ������������ rezLL: ������� �� ����� d1
             incf         Sot_h,F         ;������������ rezLL: ��������� �������� rezLH (�������� rezLL, rezLH  
                                          ;��������� � �������� �������� ��������� � �������� ��������� �������)
             goto         d12              ;������� �� ����� d1 ��� ���������� ���������, �������� �������
                                          ;������������ ����� ������������ ���������   	

delDec  	 clrf         Edin           ;������� �������� rezLL (������������ ������ ����)
             clrf  		  Dec
			 
			                     
dec1         movf		  Prom_l, W
			 movwf		  Edin
			 movf         del_10,W         ;����� � tmpLL �� ����� ����: �������� ����� ������� � ��������
             subwf        Prom_l,F         ;tmpLL �� ����� � �������� varLL
             btfss        STATUS,C        ;�������� �� ���� �����
             return                       ;������ ���� �����: ����� �� ������������
             incf         Dec,F         ;��� �����: ��������� �������� rezLL (������� rezLL ��������� �
                                          ;�������� �������� ��������� � �������� ��������� �������)      
             goto         dec1              ;������� �� ����� d1 ��� ���������� ���������, �������� �������
                                          ;������������ ����� ������������ ���������

;=================== ����� Sot Dec Edin ========================



    goto MAIN

	end;
