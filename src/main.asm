[bits 32]

section .text

global _start
_start: 
  call repl
   
  start_exit:
      mov ebx, 0 ; exit with code of 0 
      jmp exit


; takes in the input string in 'ebx'
; doesn't return anything
r:
    mov ecx, str_hello
    call cmp_str_ez
    je r_hello
    mov ecx, str_t
    call cmp_str_ez
    je r_triangle
    jmp r_unknown_command
    r_hello:
        mov ebx, 42 ; *
        call print_char
        call print_newline
        ; TODO
        jmp r_exit
    r_triangle:
        call triangle
        jmp r_exit
    r_unknown_command:
        mov ebx, str_unknown_command
        call print_string
        call print_newline
        jmp r_exit

    r_exit:
    ret 


triangle:
    mov al, 1 ; outer loop variable
    triangle_l1:
        mov ah, 0 ; inner loop variable
        triangle_l2:
            mov ebx, 42
            push eax
            call print_char
            pop eax
            add ah, 1
            cmp ah, al
            jne triangle_l2
        push eax
        call print_newline
        pop eax
        add al, 1
        cmp al, 10
        jne triangle_l1
    ret
; takes in a string in 'ebx' and 'ecx'
; sets the register flags
; so it can be used with je/jne
cmp_str_ez:
   call cmp_str
   cmp al, 1 ; 1 = true
   ret
   ; je will jump if equal
   ; jne will jump if not equal

exit: ; exit with the code in 'ebx'
  mov eax, 1 ; sys_exit
  int 0x80



repl:
    ; calls r: with EBX set to a string (the input)
    ; until the string returned is "quit"
    
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
    call r ; call it
    jmp repl
    
    repl_exit:
        pop eax
        ret



%include "src/mem.asm"
%include "src/io.asm"
%include "src/str.asm"

section .data
  str_quit  db "quit" , 0x00
  str_hello db "hello", 0x00
  str_t     db "t"    , 0x00
  str_unknown_command db "Unknown Command.", 0x00

