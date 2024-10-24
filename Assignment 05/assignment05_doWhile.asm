section .data
    array dw 12, 1003, 6543, 24680, 789, 30123, 32766  ; Define 7 elements in the array (16-bit)

section .bss
    even  resw 7                                      ; Reserve space for 7 16-bit elements

section .text
    global _start

_start:
    xor rsi, rsi               ; rsi = 0 -- index for the array
    xor rdi, rdi               ; rdi = 0 -- index for even array

doWhileLoop:
    ; Load array[rsi] into ax (16-bit register)
    mov ax, [array + rsi*2]    ; Load 16-bit value into ax

    ; Check if ax is even (ax % 2 == 0)
    test ax, 1
    jnz notEven                ; Jump if odd

    ; If even, copy ax to even[rdi]
    mov [even + rdi*2], ax
    inc rdi                    ; Increment rdi

notEven:
    inc rsi                    ; Increment rsi

    cmp rsi, 7                 ; Compare rsi with 7
    jne doWhileLoop            ; Jump if rsi is not equal to 7

endLoop:
    mov rax, 60                ; System call for exit
    xor rdi, rdi               ; Exit code 0
    syscall
