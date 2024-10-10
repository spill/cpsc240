section .data
    num dw 65535 ; 16-bit variable
    mul_3 dw 0 ; 16-bit variable
    other dw 0 ; 16 bit variable

section .text
    global _start

_start:
    mov ax, [num]  ; load the num into ax


    mov dx, 0 ; clear dx for the divison process
    mov bx, 3 ; set the divisor to 3
    div bx
    test dx, dx
    jnz else_part ; if the remainder is not 0, jump to else part

    mov ax, [num] ; reload num to ax
    mov dx, 0 ; clear dx for division 
    mov bx, 5 ; set the divisor to 3
    div bx ; divide ax by bx 
    test dx, dx
    jz else_part

else_part
    mov ax, [other] ; load other into ax
    inc ax ; increment the ax by 1
    mov [other], ax

end_if:
    mov eax, 60 ; system call for exit
    xor edi, edi
    syscall