section .data
    num1 dd 300000
    num2 dd 400000
    product dq 0

section .text
    global _start

_start:
    mov eax, [num1]

    mov ebx, [num2]
    mul ebx

    mov [product], eax
    mov [product+4], edx

    mov eax, 60
    xor edi, edi
    syscall