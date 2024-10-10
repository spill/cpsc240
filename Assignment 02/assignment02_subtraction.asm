section .data
    num1 dw 0x1234         ; Declare num1 as a 16-bit signed integer
    num2 dw 0xFEDC         ; Declare num2 as a 16-bit signed integer
    sum  dd 0              ; Declare sum as a 32-bit signed integer

section .text
    global _start

extern ExitProcess        ; Import the ExitProcess function from Windows DLL

_start:
; Load num1 and num2 into registers for addition
    mov ax, [num1]         ; load num1 into the AX register
    mov bx, [num2]         ; load num2 into the BX register

; Perform the addition
    add ax, bx             ; AX = AX + BX

; Extend AX into EAX to store 32-bit result
    cwde                   ; convert word to double word (sign-extend AX to EAX)

; Store the result in sum
    mov [sum], eax         ; move result into sum

; Call ExitProcess to exit the program
    mov eax, 0             ; exit code 0
    push eax
    call ExitProcess
