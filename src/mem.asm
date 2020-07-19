


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


