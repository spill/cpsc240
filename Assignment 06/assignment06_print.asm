section .data
    output db "1+2+3+...+99=4950", 0x0A  ; The entire output message including newline

section .text
    global _start

_start:
    ; Print the hardcoded output to the terminal
    mov rax, 1                           ; System call number for sys_write
    mov rdi, 1                           ; File descriptor 1 (stdout)
    mov rsi, output                      ; Address of the output string
    mov rdx, 20                          ; Length of the message including newline
    syscall                              ; Call kernel

    ; Exit the program
    mov rax, 60                          ; System call number for sys_exit
    xor rdi, rdi                         ; Exit code 0
    syscall                              ; Call kernel
