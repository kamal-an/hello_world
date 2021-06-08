section .data
	msg1 db 10,13,"Enter a string:"
	len1 equ $-msg1

section .bss
	str1 resb 200                 ;string declaration
	result resb 16
	char_ans resb 2

section .text

global _start
	_start:

;display
	mov Rax,1
	mov Rdi,1
	mov Rsi,msg1
	mov Rdx,len1
	syscall

;store string 

	mov rax,0
	mov rdi,0
	mov rsi,str1
	mov rdx,200
	syscall

call display

;exit system call
	mov Rax ,60
	mov Rdi,0
	syscall


%macro dispmsg 2
	mov Rax,1
	mov Rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro



display:
		mov rbx, 10		;denominator
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

		dispmsg char_ans, 2
		ret