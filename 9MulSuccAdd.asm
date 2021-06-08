section .data
    n1msg db 10, "Enter First number: "
    n1msg_len equ $-n1msg

    n2msg db 10, "Enter second number: "
    n2msg_len equ $-n2msg

    samsg db 10, "Multiplication by Successive Addition: "
    samsg_len equ $-samsg

    ermsg db 10, "Invalid input", 10
    ermsg_len equ $-ermsg

;------------------------------------------

section .bss
    buf resb 5
    buf_len equ $-buf

    char_ans resb 4

    n1 resw 1
    n2 resw 1

    ansl resw 1
    ansh resw 1

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
    call SA

    Exit

SA:
    mov word[ansl], 0   ; additon of 16 bit can generate results in 32 bits therefore lower and upper word are req 
    mov word[ansh], 0

    Print n1msg, n1msg_len
    call accept16
    mov [n1], bx

    Print n2msg, n2msg_len
    call accept16
    mov [n2], bx
    
    mov ax, [n1]
    mov cx, [n2]

    cmp cx, 0   ; cheking if any no is zero to avoid infinite loop
    je final

    cmp ax, 0
    je final

    back:
        add [ansl], ax
        jnc next
        inc word[ansh]

        next: dec cx
        jnz back

    final:
        Print samsg, samsg_len
        mov ax, [ansh]
        call display_16

        mov ax, [ansl]
        call display_16

    ret


accept16:

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

display_16:
    mov rsi, char_ans+3
    mov rcx, 4
    mov rbx, 16

    next_digit:
    xor rdx, rdx
    div rbx

    cmp dl, 9
    jbe add30
    add dl, 07h

    add30:
        add dl, 30h
        mov [rsi], dl

        dec rsi
        dec rcx
        jnz next_digit

        Print char_ans, 4
    ret
