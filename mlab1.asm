;***************************************************************************************************
; MLAB1.ASM - учебный пример для выполнения
; лабораторной работы N1 по машинно-ориентированному программированию
; 10.09.02: Негода В.Н.
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       Используются декларации констант и макросов
        INCLUDE MLAB1.INC
        INCLUDE MLAB1.MAC

; Декларации данных
        .DATA
X DD 0
Y DD 0
Z DD 0
INPUT_X_STR DB 'PLEASE ENTER A BINARY X', 0
INPUT_Y_STR DB 'PLEASE ENTER A BINARY Y', 0
ERROR_NUM_STR DB 'ERROR IN INPUTED NUMBER, RECHEK IT', 0
; FUNCTION DB 'f = x1x2x3 | x2!x3x4 | !x1!x2 | x1!x2x3!x4 | x3x4', 0
; Z3 DB 'z3=!z3', 0
; Z2 DB 'z2|=z19', 0
; Z7 DB 'z7&=z8', 0
; Z_STR DB 'f1 ? X/4+4*Y : X/8 - Y', 0
; Z_BEFORE_DEC DB 'Z BEFORE CHAMGES (DECIMAL):', 0
; Z_BEFORE_BIN DB 'Z BEFORE CHAMGES (BINARY):', 0
; Z_AFTER_DEC DB 'Z AFTER CHANGES (DECIAML)', 0
; Z_AFTER_BIN DB 'Z AFTER CHANGES (BINARY)', 0

SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"Фамилия И.О.: ",0FFh
MINIS	DB	"МИНИСТЕРСТВО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ",0
ULSTU	DB	"УЛЬЯНОВСКИЙ ГОСУДАРСТВЕННЫЙ ТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ",0
DEPT	DB	"Кафедра вычислительной техники",0
MOP	DB	"Машинно-ориентированное программирование",0
LABR	DB	"Лабораторная работа N 1",0
REQ1    DB      "Замедлить(-),ускорить(+),выйти(ESC), FUNC(1)? ",0FFh
TACTS   DB	"Время работы в тактах: ",0FFh
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; младшее и старшее слова задержки при выводе строки

TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; строка вывода числа тактов
                                          ; запас для разделительных "`"

MYBUF DB BUFLEN


;========================= Программа =========================
        .CODE
; Макрос заполнения строки LINE от позиции POS содержимым CNT объектов,
; адресуемых адресом ADR при ширине поля вывода WFLD
BEGIN	LABEL	NEAR
	; инициализация сегментного регистра
	MOV	AX,	@DATA
	MOV	DS,	AX
  JMP MY_PROG
	; инициализация задержки
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H

	PUTLS	REQ	; запрос имени
	; ввод имени
	LEA	DX,	BUF
	CALL	GETS

@@L:	; циклический процесс повторения вывода заставки
	; вывод заставки
	; ИЗМЕРЕНИЕ ВРЕМЕНИ НАЧАТЬ ЗДЕСЬ
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; разделительная черта
	PUTL	EMPTYS
	PUTLSC	MINIS	; первая
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  и
	PUTL	EMPTYS
	PUTLSC	DEPT	;   последующие
	PUTL	EMPTYS
	PUTLSC	MOP	;    строки
	PUTL	EMPTYS
	PUTLSC	LABR	;     заставки
	PUTL	EMPTYS
	; приветствие
	PUTLSC	SNAME   ; ФИО студента
	PUTL	EMPTYS
	; разделительная черта
	PUTL	SLINE
	; ИЗМЕРЕНИЕ ВРЕМЕНИ ЗАКОНЧИТЬ ЗДЕСЬ
	DURAT    	; подсчет затраченного времени
	; Преобразование числа тиков в строку и вывод
	LEA	DI,	TI
	CALL	UTOA10
	PUTL	TACTS
	PUTL	TI      ; вывод числа тактов
	; обработка команды
	PUTL	REQ1
	CALL	GETCH
	CMP	AL,	'-'    ; удлиннять задержку?
	JNE	CMINUS
	INC	PAUSE+2        ; добавить 65536 мкс
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; укорачивать задержку?
	JNE	CEXIT
	CMP	WORD PTR PAUSE+2, 0
	JE	BACK
	DEC	PAUSE+2        ; убавить 65536 мкс
BACK:	JMP	@@L
CEXIT:
  CMP AL, '1'
  JE MY_PROG
  CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
  CMP AL, '1'
  JE MY_PROG
  PUTLSC	SNAME   ; ФИО студента
	JNE	BACK
	CALL	GETCH
	JMP	@@L





MY_PROG:
 ;ввод числа Х
  PUTL	EMPTYS
  LEA ESI, INPUT_X_STR
  CALL PUTSS
  ;записать EAX в X переменную
  LEA EDI, X
  CALL READ_NUM
  PUTL EMPTYS

  ;ввод числа У
  ; XOR EDI, EDI
  LEA ESI, INPUT_Y_STR
  CALL PUTSS
 ;записать EAX в У переменную
  LEA EDI, Y
  CALL READ_NUM
  PUTL EMPTYS

  ; LEA ESI, FUNCTION
  ; CALL PUTSS
  ; LEA ESI, Z_STR
  ; CALL PUTSS
  ; LEA ESI, Z3
  ; CALL PUTSS
  ; LEA ESI, Z2
  ; CALL PUTSS
  ; LEA ESI, Z7
  ; CALL PUTSS

  ;-------------------------------------------------
  ; начало подсчета
  ; берем х1-х4 биты
  MOV EAX, X
  AND EAX, 11110b ;маска на х1-х4 бита

  ;СРАВНИТЬ Х1-Х4 БИТА НА СООТВЕТСТВИЕ ЛЖИ ИЗ ТАБЛИЧНЫХ
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
  ; ИНАЧЕ ПРЫЖОК НА ВЫОПЛЕНИЕ ЕСЛИ ЗНАЧЕНИЕ ИСТИНА ИЗ ТАБИЛЦЫ
  JMP TRUE

; вычисление Z если истинна или ложь соответственно
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

; LEA ESI, Z_BEFORE_DEC
; CALL PUTSS
PUTL EMPTYS
MOV EAX, Z
CALL PRINT_DEC
PUTL EMPTYS

; LEA ESI, Z_BEFORE_BIN
; CALL PUTSS
CALL PRINT_BIN
PUTL EMPTYS

CHANGE_Z:
  ; ИЗМЕНЕНИЕ 3 БИТА
  MOV EAX, Z
  XOR EAX, 1000b ; ИНВЕРСИЯ 3 БИТА
  ;----------------------------------------
  ; ИЗМЕНЕНИЕ 2 БИТА
  MOV EBX, EAX
  AND EBX, 100b  ; маска 3 бита
  SHR EBX, 2    ; В EBX ЗНАЧЕНИЕ БИТА Z2

  MOV ECX, EAX
  AND ECX, 10000000000000000000b   ; маска 19 бита
  SHR ECX, 19   ; В ECX ЗНАЧЕНИЕ БИТА Z19

  OR EBX, ECX  ; ВЫЧИСЛЕНИЕ Z2|=Z19
  SHL EBX, 2    ; ВЫДВИГАЕМ ЗНАЧЕНИЕ ОПЕРАЦИИ В ПОЗИЦИЮ Z2
  OR EAX, EBX  ; ЗАНЕСЕНИЕ РЕЗУЛЬТАТА EBX В EAX
  ;----------------------------------------
  ;ИЗМЕНЕНИЕ 7 БИТА

  MOV EBX, EAX
  AND EBX, 10000000b    ; МАСКА 7 БИТА
  SHR EBX, 7    ; В EBX ЗНАЧЕНИЕ БИТА Z7

  MOV ECX, EAX
  AND ECX, 100000000b    ; МАСКА 8 БИТА
  SHR ECX, 8    ; В EBX ЗНАЧЕНИЕ БИТА Z8

  AND EBX, ECX  ; ВЫЧИСЛЕНИЕ Z7&=Z8
  SHL EBX, 7    ; ВЫДВИГАЕМ ЗНАЧЕНИЕ ОПЕРАЦИИ В ПОЗИЦИЮ Z7
  OR EAX, EBX  ; ЗАНЕСЕНИЕ РЕЗУЛЬТАТА EBX В EAX


  ; LEA ESI, Z_AFTER_DEC
  ; CALL PUTSS
  PUTL EMPTYS
  MOV EAX, Z
  CALL PRINT_DEC
  PUTL EMPTYS

  ; LEA ESI, Z_AFTER_BIN
  CALL PRINT_BIN
  PUTL EMPTYS


JMP @@E

ERROR_NUM:
  LEA ESI, ERROR_NUM_STR
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

  ; WRITE DEC NUMBER FROM EAX
  PRINT_BIN PROC NEAR
    PUSH EAX
    PUTL EMPTYS
    POP EAX
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
    PRINT_B:
      XOR EAX, EAX
      POP EAX
      CALL PUTC
      LOOP PRINT_B
      RET
    PRINT_BIN ENDP

	; Выход из программы
@@E:	EXIT
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN
