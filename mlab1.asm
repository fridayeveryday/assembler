;***************************************************************************************************
; MLAB1.ASM - �祡�� �ਬ�� ��� �믮������
; ������୮� ࠡ��� N1 �� ��設��-�ਥ��஢������ �ணࠬ��஢����
; 10.09.02: ������ �.�.
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       �ᯮ������� ������樨 ����⠭� � ����ᮢ
        INCLUDE MLAB1.INC
        INCLUDE MLAB1.MAC

; ������樨 ������
        .DATA
X DD 0
Y DD 0
Z DD 0
SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"������� �.�.: ",0FFh
MINIS	DB	"������������ ����������� ���������� ���������",0
ULSTU	DB	"����������� ��������������� ����������� �����������",0
DEPT	DB	"��䥤� ���᫨⥫쭮� �孨��",0
MOP	DB	"��設��-�ਥ��஢����� �ணࠬ��஢����",0
LABR	DB	"������ୠ� ࠡ�� N 1",0
REQ1    DB      "���������(-),�᪮���(+),���(ESC), FUNC(1)? ",0FFh
TACTS   DB	"�६� ࠡ��� � ⠪��: ",0FFh
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; ����襥 � ���襥 ᫮�� ����প� �� �뢮�� ��ப�

TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; ��ப� �뢮�� �᫠ ⠪⮢
                                          ; ����� ��� ࠧ����⥫��� "`"

MYBUF DB BUFLEN
D DB '---------------------------------', 0
INPUT_X_STR DB 'PLEASE ENTER A BINARY X', 0
INPUT_Y_STR DB 'PLEASE ENTER A BINARY Y', 0
ERROR_NUM_STR DB 'ERROR IN INPUTED NUMBER, RECHEK IT', 0


;========================= �ணࠬ�� =========================
        .CODE
; ����� ���������� ��ப� LINE �� ����樨 POS ᮤ�ন�� CNT ��ꥪ⮢,
; ����㥬�� ���ᮬ ADR �� �ਭ� ���� �뢮�� WFLD
BEGIN	LABEL	NEAR
	; ���樠������ ᥣ���⭮�� ॣ����
	MOV	AX,	@DATA
	MOV	DS,	AX
	; ���樠������ ����প�
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H
  JMP MY_PROG

	PUTLS	REQ	; ����� �����
	; ���� �����
	LEA	DX,	MYBUF
	CALL	GETS
  XOR ECX,ECX
  XOR EAX,EAX
  MOV CL, MYBUF[1]
  MOV AL, CL
  ADD AL, 48
  CALL PUTC


@@L:	; 横���᪨� ����� ����७�� �뢮�� ���⠢��
	; �뢮� ���⠢��
	; ��������� ������� ������ �����
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; ࠧ����⥫쭠� ���
	PUTL	EMPTYS
	PUTLSC	MINIS	; ��ࢠ�
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  �
	PUTL	EMPTYS
	PUTLSC	DEPT	;   ��᫥���騥
	PUTL	EMPTYS
	PUTLSC	MOP	;    ��ப�
	PUTL	EMPTYS
	PUTLSC	LABR	;     ���⠢��
	PUTL	EMPTYS
	; �ਢ���⢨�
	PUTLSC	SNAME   ; ��� ��㤥��
	PUTL	EMPTYS
	; ࠧ����⥫쭠� ���
	PUTL	SLINE
	; ��������� ������� ��������� �����
	DURAT    	; ������ ����祭���� �६���
	; �८�ࠧ������ �᫠ ⨪�� � ��ப� � �뢮�
	LEA	DI,	TI
	CALL	UTOA10
	PUTL	TACTS
	PUTL	TI      ; �뢮� �᫠ ⠪⮢
	; ��ࠡ�⪠ �������
	PUTL	REQ1
	CALL	GETCH
	CMP	AL,	'-'    ; 㤫������ ����প�?
	JNE	CMINUS
	INC	PAUSE+2        ; �������� 65536 ���
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; 㪮�稢��� ����প�?
	JNE	CEXIT
	CMP	WORD PTR PAUSE+2, 0
	JE	BACK
	DEC	PAUSE+2        ; 㡠���� 65536 ���
BACK:	JMP	@@L
CEXIT:	CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
  CMP AL, '1'
  JE MY_PROG
  PUTLSC	SNAME   ; ��� ��㤥��
	JNE	BACK
	CALL	GETCH
	JMP	@@L





MY_PROG:
 ;���� �᫠ �
  PUTL	EMPTYS
  LEA ESI, INPUT_X_STR
  CALL PUTSS
  ;������� EAX � X ��६�����
  LEA EDI, X
  CALL READ_NUM
  PUTL EMPTYS

  ;���� �᫠ �
  XOR EDI, EDI
  LEA ESI, INPUT_Y_STR
  CALL PUTSS
 ;������� EAX � � ��६�����
  LEA EDI, Y
  CALL READ_NUM
  PUTL EMPTYS

  MOV EAX, X
  AND EAX, 11110b ;��᪠ �� �1-�4 ���

  ;�������� �1-�4 ���� �� ������������ ��� �� ���������
  CMP EAX, 100b
  JE FALSE
  CMP EAX, 1100b
  JE FALSE
  CMP EAX, 10b
  JE FALSE
  CMP EAX, 10010b
  JE FALSE
  CMP EAX, 110b
  JE FALSE
  ; ����� ������ �� ��������� ���� �������� ������ �� �������
  JMP TRUE




TRUE:
  MOV EAX, X
  SHR EAX, 2
  MOV EBX, Y
  SHL EBX, 2
  ADD EAX, EBX
  MOV Z, EAX
  JMP CHANGE_Z
FALSE:
  MOV EAX, X
  SHR EAX, 3
  MOV EBX, Y
  SUB EAX, EBX
  MOV Z, EAX

CHANGE_Z:
  MOV EAX, Z
  MOV EBX, EAX
  AND EAX, 1000b
  CMP EAX, 0
  



JMP @@E

ERROR_NUM:
  LEA ESI, ERROR_NUM_STR
  CALL OUTPUT
  JMP @@E


; ESI - ADDRES OF STRING
OUTPUT PROC NEAR
  ; PUTL EMPTYS
  XOR EAX, EAX
  XOR EDX, EDX
  XOR ECX, ECX
  CALL PUTSS
  ; PUTL EMPTYS
  RET
OUTPUT ENDP

; RESULT IN EAX , STRING WITH BINARY NUMBER IN MYBUFF
READ_NUM PROC NEAR
  LEA EDX, [MYBUF]
  CALL GETS
  xor eax, eax
  xor ebx, ebx
  ADD EDX, 1
  MOV CL, [EDX]
  ADD EDX, 1
  l1:
     mov bl, [EDX]
     sub bl, 48
     CMP BL, 0
     JE CONTINUE
     CMP BL, 1
     JNE ERROR_NUM
     CONTINUE:
       add al, bl
       ; CALL PUTC
       shl al, 1
       inc EDX
       loop l1
  shr al,1
; PUT EAX VALUE INTO VARIABLE WITH EDI ADDRESS
  MOV [EDI], EAX
  RET
READ_NUM ENDP

; WRITE DEC NUMBER FROM EAX
PRINT_DEC PROC NEAR
  PUSH EAX
  PUTL EMPTYS
  POP EAX
  MOV EBX, 10
  XOR ECX, ECX
  DIVISION:
    XOR EDX, EDX
    DIV EBX
    ADD EDX, 48
    push EDX
    ADD ECX, 1
    CMP EAX, 0
    JG DIVISION
  PRINT:
    XOR EAX, EAX
    POP EAX
    CALL PUTC
    LOOP PRINT
    RET
  PRINT_DEC ENDP

	; ��室 �� �ணࠬ��
@@E:	EXIT
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN
