section .data
	array db 11h, 55h, 33h, 22h,44h
	msg1 db 10,13,"Largest no in an array is:"
	len1 equ $-msg1

section .bss
	cnt resb 1
	result resb 16
	char_ans resb 2
	
		%macro dispmsg 2
		mov Rax,1
		mov Rdi,1
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

section .text
	global _start
	_start:
		mov byte[cnt],5
		mov rsi,array
		mov al,0
	LP: cmp al,[rsi]
		jg skip
		xchg al ,[rsi]
		skip: inc rsi
		dec byte[cnt]
		jnz LP


	;display al

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

		dispmsg char_ans, 2
		ret