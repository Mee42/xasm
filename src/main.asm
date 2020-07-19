[bits 32]

section .text
    global _start


_start:
   mov ah, 1
   loop2:


   mov al, 0
   loop1:
   
   push eax
   mov ebx, 42 ; '*'
   call print_char
   pop eax

   add al, 1
   cmp al, ah
   jne loop1

   push eax
   call print_newline
   pop eax

   add ah, 1
   cmp ah, 10
   jne loop2


   mov ebx, 0 ; exit with code of 0
   jmp exit

print_newline:
   mov ebx, 10
   jmp print_char

; prints the character in the bl register
print_char:
   ; mov bl, bl ; bl should already be set
   mov bh, 0x0a
   push ebx
   mov eax, 0x4 ; sys_write
   mov ebx, 1 ; stdout
   mov edx, 1 ; # of bytes
   mov ecx, esp ; the buffer location - on the stack
   int 0x80 ; sys_write
   pop ebx
   ret

exit: ; exit with the code in 'ebx'
  mov eax, 1
  ;mov ebx, ebx
  int 0x80
  
section .data
  msg db 'X', 0xA
  len equ $ - msg ; len of string
