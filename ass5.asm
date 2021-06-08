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

section .data
    array dq -1h, 74h, 24h, -45h, 20h   ;dq is define quadword 64 bit (8 byte)
    n equ 5

    pmsg db 10, "The no of +ve elements from array is: "
    pmsg_len equ $-pmsg

    nmsg db 10, "The no of -ve elements from array is: "
    nmsg_len equ $-nmsg


section .bss
    p_count resq 1  ;reserve quad word
    n_count resq 1
	char_ans resb 2 ;reserve byte

;------------------------------------------------------------------------
section .text
	global _start
_start:
	
	mov rsi, array
    mov rcx, n

    mov rbx, 0  ;positive count
    mov rdx, 0  ;negative count

    back:
    mov rax, [rsi]
    shl rax, 1
    jc negative

    positive:
    inc rbx
    jmp next

    negative:
    inc rdx

    next:
    add rsi, 8  ;increment by 1 number i.e. next 64bit no (8 bytes)
    dec rcx
    jnz back

    mov [p_count], rbx
    mov [n_count], rdx

    print pmsg, pmsg_len
    mov rax, [p_count]
    call display

    print nmsg, nmsg_len
    mov rax, [n_count]
    call display

    exit

;------------------------------------------------------------------------
display:
    mov rbx, 16		;denominator
    mov rcx, 2		;number of time loop is run and also no of cha
    mov rsi, char_ans+1	; start filling from lsb
    
    cnt:
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
    jnz cnt

    print char_ans, 2
    ret
