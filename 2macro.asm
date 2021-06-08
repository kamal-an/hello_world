section .data

    msg db "Hello, This is my first 64 bit Assembly Language Program", 10
    msg_len equ $-msg

    msg1 db "Good day!", 10
    msg1_len equ $-msg1
    
%macro print 2
    mov rax, 1	;system call 1 write
    mov rdi, 1	;file handle 1 STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .text

    global _start
_start:

    print msg, msg_len
    print msg1, msg1_len
    
    exit
    
