[bits 32]

section .text

global _start
_start:
  jmp main
  handleStr:
    nop
    call print_string
    call print_newline
    ret
  main:
  mov eax, handleStr
  call repl
   
  start_exit:
      mov ebx, 0 ; exit with code of 0 
      jmp exit

exit: ; exit with the code in 'ebx'
  mov eax, 1
  ;mov ebx, ebx
  int 0x80


repl:
    ; takes in a function pointer at EAX
    ; calls the function pointer with EBX set to a string (the input)
    ; until the string returned is "quit"
    
    push eax ; push the address
    mov ebx, 0x24 ; $
    call print_char
    mov ebx, 32   ; ' '
    call print_char
    call read_line ; puts the result in EAX
    push eax ; push the input string
    
    mov ebx, eax ; store it in rbx
    mov ecx, str_quit
    call cmp_str
    cmp al, 1 ; if true
    je repl_exit
    pop ebx  ; the input string
    pop eax  ; the function call
    push eax ; store it to call it again
    call eax ; call it, lol
    pop eax
    jmp repl
    
    repl_exit:
        pop eax
        pop eax
        xor eax, eax
        ret



%include "src/mem.asm"
%include "src/io.asm"
%include "src/str.asm"

section .data
  str_quit db "quit", 0x00

