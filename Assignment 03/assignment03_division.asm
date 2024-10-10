section .data  
    num1 dq 50000000000    ; 64-bit value
    num2 dd 3333333        ; 32-bit value
    quotient dd 0          ; 32-bit quotient
    remainder dd 0         ; 32-bit remainder

section .text  
    global _start

_start:

    mov eax, dword [num1]     
    mov edx, dword [num1 + 4] 


    mov ebx, [num2]


    div ebx


    mov [quotient], eax
    mov [remainder], edx

    mov eax, 60       
    xor edi, edi  
    syscall
