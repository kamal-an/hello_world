section .data

msg db "Hello, This is my first 64 bit Assembly Language Program"
msg_len equ $-msg

section .text

global _start
_start:

mov rax, 1	;system call 1 write
mov rdi, 1	;file handle 1 STDOUT
mov rsi, msg
mov rdx, msg_len
syscall

mov rax, 60
mov rdi, 0
syscall
