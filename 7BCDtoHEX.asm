section .data
    bmsg db 10, "Please enter the 5 digit BCD number :"
    bmsg_len equ $-bmsg

    ehmsg db 10, "Equivalent HEX number is :"
    ehmsg_len equ $-ehmsg
;------------------------------------------

section .bss
    buf resb 6  ; 5 digit BCD + enter
    char_ans resb 4
    ans resw 1

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
    call BCD_HEX

    Exit
;-------------------------------------------
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
    MOV RSI, char_ans+3
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

        Print char_ans, 4

    ret