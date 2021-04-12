.MODEL SMALL
.STACK 200h
.386
.data
str1 db "hello world$"
a dd 123
.code
mov eax,@data
mov ds, eax
mov ebx, 4
mov ecx, 5
add ebx, ecx
mov ah,09h
;mov dx,offset str1
mov edx, ebx
int 21h
mov eax,4c00h
int 21h
end
