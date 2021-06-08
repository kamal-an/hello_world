section .data
    hmsg db 10, "Please enter the 4 digit HEX number :"
    hmsg_len equ $-hmsg

    ebmsg db 10, "Equivalent BCD number is :"
    ebmsg_len equ $-ebmsg

    ermsg db 10,"Please enter a valid HEX number"
    ermsg_len equ $-ermsg
;------------------------------------------

section .bss
    buf resb 5
    char_ans resb 1

;------------------------------------------

%macro Print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro Read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro Exit 0
	mov rax, 60
	mov rdi, 1
	syscall
%endmacro

;-------------------------------------------
section .text
    global _start

_start:
    call HEX_BCD

    Exit

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

    Exit