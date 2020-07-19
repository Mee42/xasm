
; compares the string in EBX and ECX
; returns the boolean result in AL
cmp_str:
    mov al, [ebx]
    mov dl, [ecx]
    cmp al, dl
    jne cmp_str_not_eq
    cmp al, 0
    jne cmp_str_exit
    add ebx, 1
    add ecx, 1
    jmp cmp_str

    cmp_str_exit:
    mov al, 1 ; true
    ret
    cmp_str_not_eq:
    mov al, 0 ; false
    ret



