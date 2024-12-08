section .data
    prompt db "Enter a one-digit equation (e.g., 2+3*4/1-5): ", 0
    result_msg db "Result: ", 0
    error_msg db "Invalid input or division by zero.", 10, 0
    newline db 10, 0

section .bss
    input resb 50          ; Reserve space for user input
    result resd 1          ; Reserve space for the result

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, prompt
    mov edx, 44            ; Length of the prompt
    int 0x80

    ; Read user input
    mov eax, 3             ; sys_read
    mov ebx, 0             ; stdin
    mov ecx, input
    mov edx, 50            ; Max input size
    int 0x80

    ; Process input
    mov rsi, input         ; Set RSI to the start of the input buffer
    call parse_input       ; Parse and evaluate the input

    ; Display result
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, result_msg
    mov edx, 8             ; Length of result_msg
    int 0x80

    mov eax, [result]      ; Load the result
    call print_number      ; Print the result as a number

    ; Print newline
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; Exit code 0
    int 0x80

; -----------------------------------
; Subroutine: parse_input
; Parses and evaluates the input equation
; RSI: pointer to the input buffer
; Result stored in [result]
; -----------------------------------
parse_input:
    ; Initialize result
    xor eax, eax           ; Clear EAX
    movzx eax, byte [rsi]  ; Load the first digit (ASCII)
    sub eax, '0'           ; Convert ASCII to integer
    cmp eax, 9             ; Check if it's a valid digit
    ja invalid_input
    mov [result], eax      ; Store in result
    inc rsi                ; Move to next character

    ; Loop through the rest of the equation
parse_loop:
    mov al, [rsi]          ; Load next character
    cmp al, 0              ; End of input?
    je parse_done          ; If null terminator, exit loop

    ; Check for operator
    cmp al, '+'            ; Addition
    je parse_add
    cmp al, '-'            ; Subtraction
    je parse_sub
    cmp al, '*'            ; Multiplication
    je parse_mul
    cmp al, '/'            ; Division
    je parse_div

    ; Invalid input
    jmp invalid_input

parse_add:
    inc rsi                ; Move to the next character (operand)
    movzx rbx, byte [rsi]  ; Load the next digit (ASCII)
    sub rbx, '0'           ; Convert to integer
    cmp rbx, 9             ; Validate digit
    ja invalid_input
    mov rax, [result]      ; Load current result
    add rax, rbx           ; Perform addition
    mov [result], rax      ; Store result
    inc rsi                ; Move to the next character
    jmp parse_loop

parse_sub:
    inc rsi
    movzx rbx, byte [rsi]
    sub rbx, '0'
    cmp rbx, 9
    ja invalid_input
    mov rax, [result]
    sub rax, rbx           ; Perform subtraction
    mov [result], rax
    inc rsi
    jmp parse_loop

parse_mul:
    inc rsi
    movzx rbx, byte [rsi]
    sub rbx, '0'
    cmp rbx, 9
    ja invalid_input
    mov rax, [result]
    imul rax, rbx          ; Perform multiplication
    mov [result], rax
    inc rsi
    jmp parse_loop

parse_div:
    inc rsi
    movzx rbx, byte [rsi]
    sub rbx, '0'
    cmp rbx, 9
    ja invalid_input
    cmp rbx, 0             ; Check for division by zero
    je invalid_input
    mov rax, [result]
    xor rdx, rdx           ; Clear RDX for division
    div rbx                ; Perform division
    mov [result], rax
    inc rsi
    jmp parse_loop

parse_done:
    ret

invalid_input:
    ; Display error message
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, error_msg
    mov edx, 30            ; Length of error_msg
    int 0x80
    ; Exit program
    mov eax, 1             ; sys_exit
    xor ebx, ebx
    int 0x80

; -----------------------------------
; Subroutine: print_number
; Prints a signed integer stored in RAX
; RAX: Number to print
; -----------------------------------
print_number:
    cmp rax, 0             ; Check if the number is negative
    jge print_positive
    ; Handle negative number
    neg rax                ; Make the number positive
    mov al, '-'            ; Print the minus sign
    push rax
    mov eax, 4
    mov ebx, 1
    lea rcx, [rsp]
    mov edx, 1
    int 0x80
    pop rax

print_positive:
    xor rcx, rcx           ; Clear RCX (digit count)
    mov rbx, 10            ; Divisor for base 10

print_loop:
    xor rdx, rdx           ; Clear RDX for division
    div rbx                ; Divide RAX by 10
    add dl, '0'            ; Convert remainder to ASCII
    push rdx               ; Push the digit on stack
    inc rcx                ; Increment digit count
    test rax, rax          ; Check if RAX is zero
    jnz print_loop         ; If not, continue

print_digits:
    pop rdx                ; Pop the digit from stack
    mov al, dl             ; Load digit into AL
    mov rsi, rsp           ; Use stack for temporary storage
    mov [rsi], al          ; Write to memory
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    lea rcx, [rsp]         ; Address of character to print
    mov edx, 1             ; Print 1 byte
    int 0x80
    loop print_digits
    ret
