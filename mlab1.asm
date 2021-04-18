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
STR_ARR	DB 750 DUP (0)
WORD_LEN DD 30
COUNTER DD 0
COUNTER2 DD 2
MYBUF DB 70
A DB 'ABCD', 0
B DB 70 DUP (0)
EMPTYS	DB	0
EM DB 'QWE$RTY$',0
;========================= Программа =========================
        .CODE
        BEGIN	LABEL	NEAR

	; инициализация сегментного регистра
	MOV	AX,	@DATA
	MOV	DS,	AX

  XOR ECX, ECX
  XOR EDX, EDX

  LEA ESI, EM
  CALL PUTSS
  XOR EAX, EAX
  MOV AL, A
  MOV BX, 2
  ADD BX, 0
  MOV B[BX], AL
  INC AL

  ; lea bx, B
  ; INC BX
  ; MOV [BX], AL
  ; ; MOV B + 1, AL
  ; MOV AL, B
  ; CALL PUTC
  PUTL EMPTYS
  MOV BX, 2
  MOV AL, B[BX]
  ; INC AL
  CALL PUTC
  ;
  PUTL EMPTYS
  LEA EDX, [MYBUF]
  CALL GETS
  PUTL EMPTYS
  MOV AL, MYBUF[1]
  ADD AL, 48
  CALL PUTC
  PUTL EMPTYS
  MOV EAX, 4
  ADD EAX, COUNTER2
  ADD EAX, 48
  CALL PUTC

  XOR ECX, ECX

  CMP AL, CHCR
  JNE @@E
  PUTL A
  JMP @@E

  TREAT_STR PROC NEAR
    XOR ECX, ECX
    XOR EAX, EAX
    XOR EBX, EBX
    XOR EDI, EDI
    INC EDX
    MOV CL, MYBUF[1]
    TREAT_CHAR:
      MOV DL, MYBUF[EBX]
      CMP BL, CL
      JGE GET_OUT

      CMP DL, ' '
      JE NEW_WORD

      CMP DL, '!' ; TO EXIT
      JE @@E

      ;ESI - INDEX OFARRAY, EDI - INDEX OF CHAR
      MOV ESI, COUNTER

      PUSH EAX
      PUSH EDX
      MOV EAX, WORD_LEN
      MOV ESI, COUNTER
      MUL ESI
      MOV ESI, EAX
      POP EDX
      POP EAX

      ADD ESI, EDI
      MOV STR_ARR[ESI], DL ;ЗАПИСАТЬ СИМВОЛ
      INC EDI

      INCREAMENTING:
        INC EBX
        JMP TREAT_CHAR

      NEW_WORD:
        MOV ESI, COUNTER
        INC ESI
        MOV COUNTER, ESI

        XOR EDI, EDI

    GET_OUT:



  TREAT_STR  ENDP

  PRINT_ARR PROC NEAR
    MOV ECX, COUNTER
    
  PRINT_ARR ENDP

 ;ввод числа Х
;   PUTL	EMPTYS
;   LEA ESI, INPUT_X_STR
;   CALL PUTSS
;
;   ;записать EAX в X переменную
;   LEA EDI, X
;   CALL READ_NUM
;   PUTL EMPTYS
;   ; ВЫВОД В 10 ЧНОЙ ВИДЕ ЧИСЛА
;   MOV EAX, X
;   CALL PRINT_DEC
;   PUTL EMPTYS
;
;   ;ввод числа У
;   ; XOR EDI, EDI
;   LEA ESI, INPUT_Y_STR
;   CALL PUTSS
;  ;записать EAX в У переменную
;   LEA EDI, Y
;   CALL READ_NUM
;   PUTL EMPTYS
;
;   ; ВЫВОД В 10 ЧНОЙ ВИДЕ ЧИСЛА
;   MOV EAX, Y
;   CALL PRINT_DEC
;   PUTL EMPTYS
;
;   LEA ESI, FUNCTION
;   CALL PUTSS
;   LEA ESI, Z_STR
;   CALL PUTSS
;   LEA ESI, Z3
;   CALL PUTSS
;   LEA ESI, Z2
;   CALL PUTSS
;   LEA ESI, Z7
;   CALL PUTSS
;
;   ;-------------------------------------------------
;   ; начало подсчета
;   ; берем х1-х4 биты
;   MOV EAX, X
;   AND EAX, 11110b ;маска на х1-х4 бита
;
;   ;СРАВНИТЬ Х1-Х4 БИТА НА СООТВЕТСТВИЕ ЛЖИ ИЗ ТАБЛИЧНЫХ
;   CMP EAX, 100b
;   JE FALSE
;   CMP EAX, 1100b
;   JE FALSE
;   CMP EAX, 10b
;   JE FALSE
;   CMP EAX, 10010b
;   JE FALSE
;   CMP EAX, 110b
;   JE FALSE
;   ; ИНАЧЕ ПРЫЖОК НА ВЫОПЛЕНИЕ ЕСЛИ ЗНАЧЕНИЕ ИСТИНА ИЗ ТАБИЛЦЫ
;   JMP TRUE
;
; ; вычисление Z если истинна или ложь соответственно
; TRUE:
;   LEA ESI, F1
;   CALL PUTSS
;   MOV EAX, X
;   SHR EAX, 2
;   MOV EBX, Y
;   SHL EBX, 2
;   ADD EAX, EBX
;   MOV Z, EAX
;   JMP CHANGE_Z
; FALSE:
;   LEA ESI, F0
;   CALL PUTSS
;   MOV EAX, X
;   SHR EAX, 3
;   MOV EBX, Y
;   SUB EAX, EBX
;   MOV Z, EAX
;
;
;
; CHANGE_Z:
;   XOR ECX, ECX
;   XOR EDX, EDX
;   LEA ESI, Z_BEFORE_DEC
;   CALL PUTSS
;   MOV EAX, Z
;   CALL PRINT_DEC
;   PUTL EMPTYS
;   PUTL EMPTYS
;
;   XOR ECX, ECX
;   XOR EDX, EDX
;   LEA ESI, Z_BEFORE_BIN
;   CALL PUTSS
;   MOV EAX, Z
;   CALL PRINT_BIN
;   PUTL EMPTYS
;   PUTL EMPTYS
;
;
;
;   ; ИЗМЕНЕНИЕ 3 БИТА
;   MOV EAX, Z
;   XOR EAX, 1000b ; ИНВЕРСИЯ 3 БИТА
;
;   ;----------------------------------------
;   ;ИЗМЕНЕНИЕ 7 БИТА
;
;   MOV EBX, EAX
;   AND EBX, 10000000b    ; МАСКА 7 БИТА
;   SHR EBX, 7    ; В EBX ЗНАЧЕНИЕ БИТА Z7
;
;   MOV ECX, EAX
;   AND ECX, 100000000b    ; МАСКА 8 БИТА
;   SHR ECX, 8    ; В EBX ЗНАЧЕНИЕ БИТА Z8
;
;   AND EBX, ECX  ; ВЫЧИСЛЕНИЕ Z7&=Z8
;   SHL EBX, 7    ; ВЫДВИГАЕМ ЗНАЧЕНИЕ ОПЕРАЦИИ В ПОЗИЦИЮ Z7
;   CMP EBX, 0
;   JE WRITE_0_Z7
;   WRITE_1_Z7:
;   OR EAX, EBX  ; ЗАНЕСЕНИЕ РЕЗУЛЬТАТА EBX В EAX
;   JMP CNT
;   WRITE_0_Z7:
;   OR EBX, 10000000b  ; СТАВИМ В EBX НА 7 БИТ ЕДИНИЦУ
;   NOT EBX
;   AND EAX, EBX ; ЗАНЕСЕНИЕ РЕЗУЛЬТАТА EBX В EAX
;
;   CNT:
;
;   ;----------------------------------------
;   ; ИЗМЕНЕНИЕ 2 БИТА
;   MOV EBX, EAX
;   AND EBX, 100b  ; маска 2 бита
;   SHR EBX, 2    ; В EBX ЗНАЧЕНИЕ БИТА Z2
;
;   MOV ECX, EAX
;   AND ECX, 10000000000000000000b   ; маска 19 бита
;   SHR ECX, 19   ; В ECX ЗНАЧЕНИЕ БИТА Z19
;
;   OR EBX, ECX  ; ВЫЧИСЛЕНИЕ Z2|=Z19
;   SHL EBX, 2    ; ВЫДВИГАЕМ ЗНАЧЕНИЕ ОПЕРАЦИИ В ПОЗИЦИЮ Z2
;   OR EAX, EBX  ; ЗАНЕСЕНИЕ РЕЗУЛЬТАТА EBX В EAX
;
;
;   MOV Z, EAX
;
;   XOR ECX, ECX
;   XOR EDX, EDX
;   LEA ESI, Z_AFTER_DEC
;   CALL PUTSS
;   MOV EAX, Z
;   CALL PRINT_DEC
;   PUTL EMPTYS
;   PUTL EMPTYS
;
;
;   XOR ECX, ECX
;   XOR EDX, EDX
;   LEA ESI, Z_AFTER_BIN
;   CALL PUTSS
;   MOV EAX, Z
;   CALL PRINT_BIN
;   PUTL EMPTYS
;   PUTL EMPTYS
;
;
; JMP @@E
;
; ERROR_NUM:
;   PUTL EMPTYS
;   LEA ESI, ERROR_NUM_STR
;   XOR EAX, EAX
;   XOR EDX, EDX
;   XOR ECX, ECX
;   CALL PUTSS
;   JMP @@E
;
; ; RESULT IN EAX , STRING WITH BINARY NUMBER IN MYBUFF
; READ_NUM PROC NEAR
;   LEA EDX, [MYBUF]
;   CALL GETS
;   xor eax, eax
;   xor ebx, ebx
;   ADD EDX, 1
;   MOV CL, [EDX]
;   ADD EDX, 1
;   l1:
;      mov bl, [EDX]
;      sub bl, 48
;      CMP BL, 0
;      JE CONTINUE
;      CMP BL, 1
;      JNE ERROR_NUM
;      CONTINUE:
;        add EAX, EBX
;        shl EAX, 1
;        inc EDX
;       LOOP L1
;   shr EAX,1
; ; PUT EAX VALUE INTO VARIABLE WITH EDI ADDRESS
;   MOV [EDI], EAX
;   RET
; READ_NUM ENDP
;
; ; WRITE DEC NUMBER FROM EAX
; PRINT_DEC PROC NEAR
;   ; PUSH EAX
;   ; PUTL EMPTYS
;   ; POP EAX
;   MOV EBX, 10
;   XOR ECX, ECX
;   DIVISION:
;     XOR EDX, EDX
;     DIV EBX
;     ADD EDX, 48
;     push EDX
;     ADD ECX, 1
;     CMP EAX, 0
;     JG DIVISION
;   PRINT:
;     XOR EAX, EAX
;     POP EAX
;     CALL PUTC
;     LOOP PRINT
;     RET
;   PRINT_DEC ENDP
;
;   ; WRITE DEC NUMBER FROM EAX
;   PRINT_BIN PROC NEAR
;     ; PUSH EAX
;     ; PUTL EMPTYS
;     ; POP EAX
;     MOV EBX, 2
;     XOR ECX, ECX
;     DIVISION_BIN:
;       XOR EDX, EDX
;       DIV EBX
;       ADD EDX, 48
;       push EDX
;       ADD ECX, 1
;       CMP EAX, 0
;       JG DIVISION_BIN
;     MOV EBX, ECX
;     SUB EBX, 20
;     PRINT_ZEROS:
;       MOV AL, '0'
;       CALL PUTC
;       INC EBX
;       CMP EBX, 0
;       JL PRINT_ZEROS
;     PRINT_B:
;       XOR EAX, EAX
;       POP EAX
;       CALL PUTC
;       LOOP PRINT_B
;       RET
;     PRINT_BIN ENDP

	; Выход из программы
@@E:	EXIT
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN
