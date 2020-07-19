[bits 32]

section .text
    global _start


_start:
   
   call read_line
   mov ebx, eax
   call print_string
   call print_newline
   mov ebx, 0 ; exit with code of 0
   jmp exit

; takes in N, the number of bytes to malloc, in EBX
; returns a pointer to that memory in EAX
; you must free this memory before exiting the program
; avoid calling this in a loop as it is the most inefficence malloc implementation probably possible
malloc: ; taken from asm/unist_32.h
    push ebp
    mov ecx, ebx  ; length - in bytes
    mov ebx, 0x0  ; address - NULL so the kernel can just pick where ever
    mov edx, 0x3  ; PROT_READ(0x1) | PROT_WRITE(0x2)
    mov eax, 192  ; sys_mmap2
    mov esi, 0x22 ; MAP_ANONYMOUS | MAP_PRIVATE
    mov edi, -1   ; the fd, -1 when using anon mapping
    mov ebp, 0    ; this needs to be zero'd
    int 0x80
    pop ebp
    ret ; TODO write custom memory allocator for OS

free:
    ret ; TODO actually free the memory
        ; note: linux will free the memory for us so we can just treat everything malloc'd as
        ; an arena allocator over the lifespan of the program
        ; this function is left here as some may want to use it 


; takes in the pointer in EBX to a zero-terminated string
print_string:
    mov al, [ebx]
    cmp al, 0
    je print_string_exit
    push ebx
    mov bl, al
    call print_char
    pop ebx
    add ebx, 1
    jmp print_string

    print_string_exit:
        ret


; this reads in a line from stdin
; and puts it into a buffer (ret eax)

; the string is zero-terminated and *must* be freed when not needed
read_line:
    ; max line length: 512 characters
    mov ebx, 520 ; pad our 512 limit a bit
    call malloc
    mov ebx, [eax] ; segfault if malloc returns NULL
    mov ebx, 0 ; character counter
    read_line_loop1:
    ; ok time to read a single character
    push eax ; push these to preserve them
    push ebx 
      push eax   ; use ESP as a place to store the character temporarilly
      mov eax, 0x3 ; sys_read
      mov ebx, 0   ; stdin
      mov ecx, esp ; the buffer
      mov edx, 1   ; 1 byte
      int 0x80
    pop ecx  ; CL  the character just read in
    pop ebx  ; EBX the character counter
    pop eax  ; EAX the char pointer
    ; check to see if it's a newline
    ; if it is, just return EAX
    cmp cl, 0x0A ; newline char
    je read_line_return
    cmp cl, 0x00 ; EOL
    je read_line_return
    ; else, lets stick it on the buffer
    mov [eax + ebx], cl
    add ebx, 1
    ; ok lets check our buffer size
    cmp ebx, 512; jump if greater 
    jg read_line_buffer_overflow
    ; ok, looks... good?
    ; jump back to the begining
    jmp read_line_loop1

    read_line_return:
      ret
    read_line_buffer_overflow:
      mov ebx, 2
      jmp exit


      


; takes in no arguments
; returns a single character
read_char:
    push eax ; this is where we are going to store the character, so push garbage to hte }(=
    mov ebx, 0 ; stdin
    mov edx, 1 ; 1 byte
    mov ecx, esp ; the buffer
    mov eax, 0x3 ; sys_read
    int 0x80
    pop eax
    cmp al, 0x0a
    jne handleNewline
    ret

    handleNewline:
    ; ok now we need to consume the \n
    push eax
    push eax ; scratch buffer space, again
    mov ebx, 0
    mov edx, 1
    mov ecx, esp
    mov eax, 0x3
    int 0x80
    pop eax
    pop eax
    ret


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
