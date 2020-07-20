
; compares the string in EBX and ECX
; returns the boolean result in AL
cmp_str:
    mov al, [ebx]
    mov dl, [ecx]
    cmp al, dl
    jne cmp_str_not_eq
    cmp al, 0 ; and, if this is true, bl is also 02
    je cmp_str_eq
    add ebx, 1
    add ecx, 1
    jmp cmp_str

    cmp_str_eq:
    mov al, 1 ; true
    ret
    cmp_str_not_eq:
    mov al, 0 ; false
    ret



