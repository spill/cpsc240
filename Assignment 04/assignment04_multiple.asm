section .data
    num dw 65535
    mul_3 dw 0
    other dw 0

section .text
    global _start

_start:
    mov ax, [num]


    mov dx, 0
    mov bx, 3
    div bx
    test dx, dx
    jnz else_part

    mov ax, [num]
    mov dx, 0
    mov bx, 5
    div bx
    test dx, dx
    jz else_part

else_part
    mov ax, [other]
    inc ax
    mov [other], ax

end_if:
    mov eax, 60
    xor edi, edi
    syscall