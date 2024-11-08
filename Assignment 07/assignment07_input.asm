section .data
    msg1 db "Input a number (1~9): ", 0
    newline db 10, 0
    msg2 db " is multiple of 3.", 10, 0
    buffer db 0
    ascii times 9 db 0  ; storage for input ASCII values

section .bss
    num resb 1          ; buffer for converted number

section .text
    global _start

_start:
    ; Initialize r10 for input counting
    mov r10, 0

input_loop:
    ; Display message: "Input a number (1~9): "
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; file descriptor (stdout)
    mov rsi, msg1
    mov rdx, 20                 ; length of msg1
    syscall

    ; Read single character input into buffer
    mov rax, 0                  ; sys_read
    mov rdi, 0                  ; file descriptor (stdin)
    mov rsi, buffer
    mov rdx, 1
    syscall

    ; Store ASCII value in ascii array if within bounds
    cmp r10, 9                  ; ensure index is within bounds
    jge end_input_loop          ; if not, exit input loop
    mov al, [buffer]            ; get input character from buffer
    mov rcx, ascii              ; load base address of ascii array
    add rcx, r10                ; calculate offset in array
    mov [rcx], al               ; store it in ascii[r10]

    ; Display newline after input to separate inputs visually
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; file descriptor (stdout)
    mov rsi, newline            ; print a newline for clarity
    mov rdx, 1
    syscall

    inc r10                     ; increment counter
    cmp r10, 9                  ; check if we've read 9 values
    jl input_loop               ; if not, repeat

end_input_loop:
    ; Reset r10 for processing multiples of 3
    mov r10, 0

process_loop:
    ; Ensure r10 is within bounds before accessing ascii array
    cmp r10, 9
    jge end_process_loop        ; if out of bounds, exit process loop

    ; Convert ASCII to integer
    mov rcx, ascii              ; load base address of ascii array
    add rcx, r10                ; calculate offset in array
    movzx rax, byte [rcx]       ; load ASCII character from ascii[r10]
    sub rax, '0'                ; convert ASCII to integer
    mov [num], al               ; store integer in num

    ; Check if integer is multiple of 3
    mov rax, [num]
    mov rdx, 0
    mov rcx, 3
    div rcx                      ; divide by 3
    test rdx, rdx                ; check remainder
    jnz not_multiple             ; if not zero, not a multiple

    ; Display number and "is Multiple of 3"
    mov rcx, ascii              ; load base address of ascii array
    add rcx, r10                ; calculate offset in array
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, rcx                ; address of character
    mov rdx, 1                  ; print one character
    syscall

    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, msg2               ; "is Multiple of 3."
    mov rdx, 18                 ; length of msg2
    syscall

not_multiple:
    inc r10                     ; move to next element
    cmp r10, 9                  ; check if all elements are processed
    jl process_loop             ; if not, repeat

end_process_loop:
    ; Exit program
    mov rax, 60                 ; sys_exit
    xor rdi, rdi                ; status 0
    syscall
