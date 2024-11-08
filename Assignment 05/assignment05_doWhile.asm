section .data
    array dw 12, 1003, 6543, 24680, 789, 30123, 32766  ; Define 7 elements in the array (16-bit)

section .bss
    even  resw 7                          

section .text
    global _start

_start:
    xor rsi, rsi              
    xor rdi, rdi            

doWhileLoop:

    mov ax, [array + rsi*2]   

    test ax, 1
    jnz notEven              

    mov [even + rdi*2], ax
    inc rdi          

notEven:
    inc rsi                  

    cmp rsi, 7                
    jne doWhileLoop            

endLoop:
    mov rax, 60                
    xor rdi, rdi               
    syscall
