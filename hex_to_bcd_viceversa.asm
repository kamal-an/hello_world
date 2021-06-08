section .data
	msg1 db 10,10,'###### Menu for Code Conversion ######'
	db 10,'1: Hex to BCD'
	db 10,'2: BCD to Hex'
	db 10,'3: Exit'
	db 10,10,'Enter Choice:'
	msg1length  equ $-msg1
		
	hmsg db 10,10,'Enter 4 digit hex number::'
	hmsg_len equ $-hmsg

	ebmsg db 10,10,'BCD Equivalent:'
	ebmsg_len  equ $-ebmsg

	bmsg db  10,10,'Enter 5 digit BCD number::'
	bmsg_len  equ $-bmsg

	ermsg db 10,10,'Wrong Choice Entered....Please try again!!!',10,10
	ermsg_len  equ $-ermsg

	ehmsg db 10,10,'Hex Equivalent::'
	ehmsg_len equ $-ehmsg
	cnt db  0   

section .bss
	arr resb   06	;common buffer for choice, hex and bcd input
	dispbuff resb   08
	;ans resb   01
	buf resb 6  ; 5 digit BCD + enter
   	char_answer resb 4
    	ans resw 1
    	char_ans resb 1


%macro Print 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro Read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .text
	global _start
_start:
menu:

	Print msg1,msg1length
	Read arr,2  ;        choice either 1,2,3 + enter   

	cmp byte [arr],'1'
	jne l1
	call HEX_BCD

	jmp menu

l1:	cmp byte [arr],'2'
	jne l2
	call BCD_HEX
	jmp menu

l2:	cmp byte [arr],'3'
	je Exit
	Print ermsg,ermsg_len
	jmp menu

Exit:
	mov rax,60
	mov rbx,0
	syscall

BCD_HEX:
    Print bmsg, bmsg_len
    Read buf, 6

    mov rsi, buf
    xor rax, rax    ; fromula rax*rbx + cl
    mov rbp, 5
    mov rbx, 10

    next:
        xor cx, cx
        mul bx
        mov cl, [rsi]
        sub cl, 30h     ;ASCII to bcd
        add ax, cx

        inc rsi
        dec rbp
        jnz next

    mov [ans], ax

    Print ehmsg, ehmsg_len

    mov ax, [ans]
    call display

    ret

;-------------------------------------------
display:
    MOV RSI, char_answer+3
    MOV RCX, 4
    MOV RBX, 16

    next_digit:
        XOR RDX, RDX
        DIV RBX

        CMP DL, 9
        JBE add30
        ADD DL, 07h

    add30:
        ADD DL, 30h
        MOV [RSI], DL

        DEC RSI
        DEC RCX
        JNZ next_digit

        Print char_answer, 4

    ret


HEX_BCD:

    Print hmsg, hmsg_len
    call accept

    mov ax, bx
    mov bx, 10

    xor bp, bp

    back:
        xor dx, dx
        div bx

        push dx
        inc bp

        cmp ax, 0
        jne back

    Print ebmsg, ebmsg_len
    back1:
        pop dx
        add dl, 30h
        mov [char_ans], dl
        Print char_ans, 1

        dec bp
        jnz back1
    ret


accept:

    Read buf, 5

    mov rcx, 4
    mov rsi, buf
    xor bx, bx

    next_byte:
        shl bx, 4
        mov al, [rsi]

        cmp al, '0'
        jb error
        cmp al, '9'
        jbe sub30

        cmp al, 'A'
        jb error
        cmp al, 'F'
        jbe sub37

        cmp al, 'a'
        jb error
        cmp al, 'f'
        jbe sub57


        sub57: sub al, 20h
        sub37: sub al, 07h
        sub30: sub al, 30h

        add bx, ax
        inc rsi
        dec rcx
        jnz next_byte
    ret

error:
    Print ermsg, ermsg_len