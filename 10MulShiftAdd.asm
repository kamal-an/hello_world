section .data
    n1msg db 10, "Enter First number: "
    n1msg_len equ $-n1msg

    n2msg db 10, "Enter second number: "
    n2msg_len equ $-n2msg

    shmsg db 10, "Multiplication by Shift and Addition: "
    shmsg_len equ $-shmsg

    ermsg db 10, "Invalid input", 10
    ermsg_len equ $-ermsg

;------------------------------------------

section .bss
    buf resb 5
    buf_len equ $-buf

    char_ans resb 4

    n1 resw 1
    n2 resw 1

    ans resd 1  ; size is 32 bit because of multiplication of 2 16 bit numbers

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
    call Shift_Add

    Exit

Shift_Add:

    Print n1msg, n1msg_len
    call accept16
    mov [n1], bx

    Print n2msg, n2msg_len
    call accept16
    mov [n2], bx

    xor rax, rax
    xor rbx, rbx

    mov ax, [n1]
    mov bx, [n2]

    mov cx, 16  ; beacuse of 16 bit number
    mov ebp, 0  ; used to store the ans

    back1:
        shl ebp, 1
        shl ax, 1
        jnc next1
        add ebp, ebx
        next1:
            loop back1

    mov [ans], ebp
    Print shmsg, shmsg_len

    mov eax, [ans]
    call display_32

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

display_32:
    mov rsi, char_ans+7
    mov rcx, 8
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

        Print char_ans, 8
    ret
