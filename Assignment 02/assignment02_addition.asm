section .data
SYS_exit      equ 60
EXIT_SUCCESS  equ 0

num1          dw 0xFEDC           ; Declare num1 as a 16-bit variable
num2          dw 0x1234           ; Declare num2 as a 16-bit variable
sum           dd 0                ; Declare sum as a 32-bit variable

section .text
    global _start
_start:
    ; Clear carry flag before the addition
    clc                             ; Clear the carry flag to ensure it's not set

    ; Load num1 into AX (16-bit register)
    mov     ax, word [num1]         ; AX = num1 (0xFEDC)

    ; Add num2 to AX
    add     ax, word [num2]         ; AX = AX + num2 (0x1234)
                                    ; Result is in AX, and carry flag is set if overflow occurs

    ; Move the lower 16 bits (AX) to the lower part of sum
    mov     word [sum], ax          ; Store lower 16 bits in sum

    ; Now handle the overflow/carry, if any, by using ADC
    ; Use DX for the upper 16 bits
    mov     dx, 0                   ; Clear DX (without affecting the flags)
    adc     dx, 0                   ; Add the carry flag (if set) to DX

    ; Store the result (higher bits) in the upper part of sum
    mov     word [sum+2], dx        ; Store upper 16 bits of the sum in sum[2:4]

    ; Exit the program
    mov     rax, SYS_exit           ; Load the system call for exit
    mov     rdi, EXIT_SUCCESS       ; Load the exit status (success)
    syscall                         ; Make the system call
