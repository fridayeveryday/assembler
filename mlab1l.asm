;*********************************************************
; ��楤��� ��� �祡���� �ਬ�� ������୮� ࠡ��� N 1  *
; �� ���. 10.09.02: ������ �.�.                           *
;*********************************************************

.MODEL SMALL
.CODE
.386
 INCLUDE MLAB1.INC
 LOCALS
;=====================================================
; ����ணࠬ�� �뢮�� �� �࠭ ��ப�, ����㥬�� SI, 
; � ����প�� �६��� ����� ᨬ������ � <CX,DX> mcs.
; ������⥫ﬨ ��ப� ����� ����� 0 ��� 0FFh.
; ���� ��ப� �����稢����� ���⮬ 0,
;   �� ���������� ���室 � ��砫� ����� ��ப�
; 
;=====================================================
PUTSS   PROC	NEAR
@@L:    MOV	AL,	[SI]
        CMP	AL,	0FFH
        JE	@@R
        CMP	AL,	0
        JZ	@@E
        CALL	PUTC
        INC	SI
	CALL	DILAY
        JMP	SHORT @@L
        ; ���室 �� ᫥������ ��ப�
@@E:    MOV	AL, CHCR
        CALL	PUTC
        MOV	AL, CHLF
        CALL	PUTC
@@R:    RET
PUTSS	ENDP

;==============================================
; ����ணࠬ�� �뢮�� AL �� �ନ���
;==============================================
PUTC	PROC	NEAR
        PUSH	DX
        MOV	DL,   AL
        MOV	AH,   FUPUTC
        INT	DOSFU
        POP	DX
        RET
PUTC	ENDP

;==============================================
; ����ணࠬ�� ����� ᨬ���� � AL � �ନ����
;==============================================
GETCH	PROC	NEAR
        MOV	AH,   FUGETCH
        INT	DOSFU
        RET
GETCH	ENDP

;=================================================
; ����ணࠬ�� ����� ��ப� � ����, ����㥬� DX
;   � ����騩 ��������: 
;    { char size; // ࠧ��� ���� 
;      char len;  // ॠ�쭮 �������
;      char str[size]; // ᨬ���� ��ப� }
;=================================================
GETS	PROC	NEAR
	PUSH	SI
	MOV	SI,	DX
        MOV	AH,	FUGETS
        INT	DOSFU
	; �ய���� ���� 0 � ����� ��ப�
	XOR	AH,	AH
	MOV	AL,	[SI+1]
	ADD	SI,	AX
	MOV	BYTE PTR [SI+2], 0
	POP	SI
        RET
GETS	ENDP

;==============================================
; ����ணࠬ�� ������ �᫠ ᨬ����� � ��ப�,
; ����㥬�� SI. ������⥫� ��ப�: 0 � 0FFh
; ������� �����頥��� � AX
;==============================================
SLEN	PROC	NEAR
	XOR     AX,   AX
LSLEN:  CMP     BYTE PTR [SI], 0
	JE	RSLEN
        CMP     BYTE PTR [SI], 0FFh
	JE	RSLEN
	INC	AX
	INC	SI
	JMP	SHORT	LSLEN
RSLEN:  RET
SLEN 	ENDP

;====================================================
; ����ணࠬ�� �८�ࠧ������ <EDX,EAX> � ����������� 
; �����筮�, ࠧ��頥��� �� ����� DI
;==============================================
	.DATA
UBINARY	DQ	0  ; ��室��� ����筮� 64-ࠧ�來��
UPACK	DT	0  ; ���������� 18 �������� ���	
	.CODE
UTOA10	PROC	NEAR
	PUSH	CX
	PUSH	DI
	MOV	DWORD PTR [UBINARY],   EAX
	MOV	DWORD PTR [UBINARY+4], EDX
	FINIT			; ���樠������ ᮯ�����
	FILD	UBINARY		; �����뢠��� � ���� ����୮��
	FBSTP	UPACK		; �����祭�� 㯠��������� �����筮��
	MOV	CX,	LENPACK	; ����祭� 9 ��� ���
	PUSH	DS		; ����� 
	POP	ES 		;   �㤥�
	CLD     		;     �१ stosw
	LEA	SI,	UPACK   ;     � ���� 
	ADD	SI,	LENPACK	;     ���� upack        
	; ���� �८�ࠧ������ ��� ���㡠�⮢ � ASCII-���� ���
@@L:	XOR	AX,	AX
	DEC	SI
	MOV	AL,	[SI]
	SHL	AX,	4
	SHR	AL,	4	
	ADD	AX,	3030h
	XCHG	AL,	AH
	STOSW		
	LOOP	@@L
	; ������ ���� ��ப�
	XOR	AL, 	AL
	STOSB
	; ����訬 �⠡��쭮��� ᫨誮� �������� �᫠
	CLD
	MOV	AX,	LENNUM-4	
@@L1:	MOV	CX,	AX
	POP	DI	   ; ��⠥� �� ��砫� ��ப�
	PUSH	DI	
	MOV	SI,	DI
	INC	SI
	REP	MOVSB
	MOV	BYTE PTR [DI], CHCOMMA ; ��⠢��� ࠧ����⥫� �஥� ���
	SUB	AX,	4  ;     3 ���� + ࠧ����⥫� ��ࠡ�⠭�
	JS	@@E        ; �४����, �᫨ ��⠫��� �� ����� 3-� ���
	JMP	SHORT	@@L1
@@E:	POP	SI
	PUSH	SI
	XOR	CX,	CX
	; �ꥤ��� ���� �㫨
	;   ᭠砫� ������뢠��
@@L2:	CMP	BYTE PTR [SI], '0'
	JE	@@N
	CMP	BYTE PTR [SI], CHCOMMA		
	JNE	@@N1
@@N:	INC	CX
	INC	SI
	JMP	SHORT	@@L2
@@N1:	;   � ⥯��� �ꥤ���
	POP	DI
	SUB	CX, LENNUM+1
	NEG	CX
	REP	MOVSB
	POP	CX
        RET
UTOA10	ENDP

;==============================================
; ����ணࠬ�� ����প� �믮������ �ணࠬ�� 
; �� <CX,DX> ����ᥪ㭤 
;==============================================
DILAY	PROC	NEAR
	MOV	AH,	86h
        INT	15h
        RET
DILAY	ENDP

        PUBLIC	PUTSS, PUTC, GETCH, GETS, DILAY, SLEN, UTOA10

        END
