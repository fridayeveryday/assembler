;***************************************************************************************************
; MLAB1.ASM - �祡��� �ਬ�� ��� �믮������
; ��������୮� ࠡ��� N1 �� ��設��-�ਥ���஢������ �ணࠬ��஢����
; 10.09.02: ������ �.�.
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       �ᯮ�������� �������樨 ����⠭� � �����ᮢ
        INCLUDE MLAB1.INC
        INCLUDE MLAB1.MAC


; �������樨 ������
        .DATA
X DD 0
Y DD 0
Z DD 0
INPUT_X_STR DB 'PLEASE ENTER A BINARY X', 0
INPUT_Y_STR DB 'PLEASE ENTER A BINARY Y', 0
ERROR_NUM_STR DB 'ERROR IN INPUTED NUMBER, RECHEK IT', 0
FUNCTION DB 'f = x1x2x3 | x2!x3x4 | !x1!x2 | x1!x2x3!x4 | x3x4', 0
Z3 DB 'z3=!z3', 0
Z2 DB 'z2|=z19', 0
Z7 DB 'z7&=z8', 0
Z_STR DB 'f1 ? X/4+4*Y : X/8 - Y', 0
Z_BEFORE_DEC DB 'Z BEFORE CHAMGES (DECIMAL):', 0
Z_BEFORE_BIN DB 'Z BEFORE CHAMGES (BINARY):', 0
Z_AFTER_DEC DB 'Z AFTER CHANGES (DECIAML)', 0
Z_AFTER_BIN DB 'Z AFTER CHANGES (BINARY)', 0

SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"������� �.�.: ",0FFh
MINIS	DB	"������������ ����������� ���������� ���������",0
ULSTU	DB	"����������� ��������������� ����������� �����������",0
DEPT	DB	"��䥤�� ����᫨⥫쭮� ��孨��",0
MOP	DB	"��設��-�ਥ���஢����� �ணࠬ��஢����",0
LABR	DB	"��������ୠ� ࠡ��� N 1",0
REQ1    DB      "���������(-),�᪮����(+),�����(ESC), FUNC(1)? ",0FFh
TACTS   DB	"�६� ࠡ��� � ⠪���: ",0FFh
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; ����襥 � ����襥 ᫮�� ����প� ��� �뢮�� ��ப�

TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; ��ப� �뢮�� ��᫠ ⠪⮢
                                          ; ����� ��� ࠧ����⥫���� "`"

MYBUF DB BUFLEN


;========================= �ணࠬ�� =========================
        .CODE
; ������ ���������� ��ப� LINE �� ����樨 POS ᮤ�ন��� CNT ��ꥪ⮢,
; �����㥬�� ����ᮬ ADR ��� ��ਭ� ���� �뢮�� WFLD
BEGIN	LABEL	NEAR
	; ���樠������� ᥣ���⭮�� ॣ�����
	MOV	AX,	@DATA
	MOV	DS,	AX
	; ���樠������� ����প�
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H

	PUTLS	REQ	; ������ �����
	; ���� �����
	LEA	DX,	BUF
	CALL	GETS

@@L:	; 横����᪨� ������� �����७�� �뢮�� ���⠢��
	; �뢮� ���⠢��
	; ��������� ������� ������ �����
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; ࠧ����⥫쭠� �����
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
	PUTLSC	SNAME   ; ��� ��㤥���
	PUTL	EMPTYS
	; ࠧ����⥫쭠� �����
	PUTL	SLINE
	; ��������� ������� ��������� �����
	DURAT    	; ������� �����祭���� �६���
	; �८�ࠧ������ ��᫠ ⨪�� � ��ப� � �뢮�
	LEA	DI,	TI
	CALL	UTOA10
	PUTL	TACTS
	PUTL	TI      ; �뢮� ��᫠ ⠪⮢
	; ��ࠡ�⪠ �������
	PUTL	REQ1
	CALL	GETCH
	CMP	AL,	'-'    ; 㤫������ ����প�?
	JNE	CMINUS
	INC	PAUSE+2        ; �������� 65536 ���
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; 㪮��稢��� ����প�?
	JNE	CEXIT
	CMP	WORD PTR PAUSE+2, 0
	JE	BACK
	DEC	PAUSE+2        ; 㡠���� 65536 ���
BACK:	JMP	@@L
CEXIT:
  CMP AL, '1'    ;�ࠢ����� � 1 � ����室 �� ������� �㭪樨
  JE MY_PROG
  CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
  CMP AL, '1'
  JE MY_PROG
  PUTLSC	SNAME   ; ��� ��㤥���
	JNE	BACK
	CALL	GETCH
	JMP	@@L





MY_PROG:
 ;���� ��᫠ �
  PUTL	EMPTYS
  LEA ESI, INPUT_X_STR
  CALL PUTSS
  ;�������� EAX � X ��६�����
  LEA EDI, X
  CALL READ_NUM
  PUTL EMPTYS

  ;���� ��᫠ �
  ; XOR EDI, EDI
  LEA ESI, INPUT_Y_STR
  CALL PUTSS
 ;�������� EAX � � ��६�����
  LEA EDI, Y
  CALL READ_NUM
  PUTL EMPTYS

  LEA ESI, FUNCTION
  CALL PUTSS
  LEA ESI, Z_STR
  CALL PUTSS
  LEA ESI, Z3
  CALL PUTSS
  LEA ESI, Z2
  CALL PUTSS
  LEA ESI, Z7
  CALL PUTSS

  ;-------------------------------------------------
  ; ��砫� ��������
  ; ��६ �1-�4 ����
  MOV EAX, X
  AND EAX, 11110b ;��᪠ �� �1-�4 ����

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

; ����᫥��� Z �᫨ ��⨭�� ��� ���� ᮮ⢥��⢥���
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
  LEA ESI, Z_BEFORE_DEC
  CALL PUTSS
  MOV EAX, Z
  CALL PRINT_DEC
  PUTL EMPTYS
  PUTL EMPTYS


  LEA ESI, Z_BEFORE_BIN
  CALL PUTSS
  MOV EAX, Z
  CALL PRINT_BIN
  PUTL EMPTYS
  PUTL EMPTYS



  ; ��������� 3 ����
  MOV EAX, Z
  XOR EAX, 1000b ; �������� 3 ����
  ;----------------------------------------
  ; ��������� 2 ����
  MOV EBX, EAX
  AND EBX, 100b  ; ��᪠ 3 ����
  SHR EBX, 2    ; � EBX �������� ���� Z2

  MOV ECX, EAX
  AND ECX, 10000000000000000000b   ; ��᪠ 19 ����
  SHR ECX, 19   ; � ECX �������� ���� Z19

  OR EBX, ECX  ; ���������� Z2|=Z19
  SHL EBX, 2    ; ��������� �������� �������� � ������� Z2
  OR EAX, EBX  ; ��������� ���������� EBX � EAX
  ;----------------------------------------
  ;��������� 7 ����

  MOV EBX, EAX
  AND EBX, 10000000b    ; ����� 7 ����
  SHR EBX, 7    ; � EBX �������� ���� Z7

  MOV ECX, EAX
  AND ECX, 100000000b    ; ����� 8 ����
  SHR ECX, 8    ; � EBX �������� ���� Z8

  AND EBX, ECX  ; ���������� Z7&=Z8
  SHL EBX, 7    ; ��������� �������� �������� � ������� Z7
  OR EAX, EBX  ; ��������� ���������� EBX � EAX

  MOV Z, EAX

  LEA ESI, Z_AFTER_DEC
  CALL PUTSS
  MOV EAX, Z
  CALL PRINT_DEC
  PUTL EMPTYS
  PUTL EMPTYS


  LEA ESI, Z_AFTER_BIN
  CALL PUTSS
  MOV EAX, Z
  CALL PRINT_BIN
  PUTL EMPTYS
  PUTL EMPTYS


JMP @@E

ERROR_NUM:
  PUTL EMPTYS
  LEA ESI, ERROR_NUM_STR
  XOR EAX, EAX
  XOR EDX, EDX
  XOR ECX, ECX
  CALL PUTSS
  JMP @@E

; ; ESI - ADDRES OF STRING
; OUTPUT PROC NEAR
;   ; PUTL EMPTYS
;   XOR EAX, EAX
;   XOR EDX, EDX
;   XOR ECX, ECX
;   CALL PUTSS
;   ; PUTL EMPTYS
;   RET
; OUTPUT ENDP

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
  ; PUSH EAX
  ; PUTL EMPTYS
  ; POP EAX
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

  ; WRITE DEC NUMBER FROM EAX
  PRINT_BIN PROC NEAR
    ; PUSH EAX
    ; PUTL EMPTYS
    ; POP EAX
    MOV EBX, 2
    XOR ECX, ECX
    DIVISION_BIN:
      XOR EDX, EDX
      DIV EBX
      ADD EDX, 48
      push EDX
      ADD ECX, 1
      CMP EAX, 0
      JG DIVISION_BIN
    MOV EBX, ECX
    SUB EBX, 20
    PRINT_ZEROS:
      MOV AL, '0'
      CALL PUTC
      INC EBX
      CMP EBX, 0
      JL PRINT_ZEROS
    PRINT_B:
      XOR EAX, EAX
      POP EAX
      CALL PUTC
      LOOP PRINT_B
      RET
    PRINT_BIN ENDP

	; ��室 �� �ணࠬ��
@@E:	EXIT
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN
