%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	mov rdi, 1
	syscall
%endmacro

section .bss
	char_ans resb 2

section .text
	global _start
_start:
	
	mov rax, 20
	call display
	exit

	display:
		mov rbx, 16		;denominator
		mov rcx, 2		;number of time loop is run and also no of cha
		mov rsi, char_ans+1	; start filling from lsb
		
		back:
		mov rdx, 0
		div rbx			;rax/rbx => rdx --> remainder and rax--> quotient
		
		cmp dl, 09h		;dl--> lower byte of dx and to conv no to ascii
		jbe add30		;if no is less than 9 add 30
		add dl, 7h		;else add 37 i.e. 7+30

		add30:
		add dl, 30h

		mov [rsi], dl		; refer rsi as value
		dec rsi
		dec rcx
		jnz back

		print char_ans, 2
		ret
