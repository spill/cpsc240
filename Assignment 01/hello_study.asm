
section .data ; declaration of data section. This is where the program is storing the static data (strings, constants)
LF		equ	10 ; LF = new line, equ = equate 10 is \n in ASCII so we're equating LF to a new line. 
NULL		equ	0 ; constant NULL equating the value to 0. NULL in ASCII marks end of a string.
SYS_exit	equ	60 ; 60 is the call number for the exit system calls, system calls request services from the operating system, each call has a unique number.
EXIT_SUCCESS	equ	0	; exit status code 0 which shows finish successfully
text		db	"Hello, World!", LF, NULL ; used for defining a string \\ text is used as a location in memory where string stored. db is the sequence of bytes in memory (eg. Hello World)

section .text ; storage of the actual instructions for the assembler
	global _start ; informs the assembler this is the entry point and is globally visible.
_start: ; the first line for the program.
	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, text
	mov 	rdx, 14
	syscall

	mov 	rax, SYS_exit
	mov 	rdi, EXIT_SUCCESS
	syscall