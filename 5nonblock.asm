section .data

    sblock db 10h, 20h, 30h, 40h, 50h, 60h, 70h
    dblock times 7 db 0

    smsg db 10, "Source block is: "
    smsg_len equ $-smsg

    dmsg db 10, "Destination block is: "
    dmsg_len equ $-dmsg

    space db " "
;------------------------------------------

section .bss
    char_ans resB 2

;------------------------------------------

%macro Print 2
	mov rax, 1
	mov rdi, 1
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
    Print smsg, smsg_len
    mov rsi, sblock
    call block_display

    Print dmsg, dmsg_len
    mov rsi, dblock
    call block_display

    call block_transfer

    Print smsg, smsg_len
    mov rsi, sblock
    call block_display

    Print dmsg, dmsg_len
    mov rsi, dblock
    call block_display

    Exit

;-------------------------------------------
block_transfer:

    mov rsi, sblock
    mov rdi, dblock
    mov rcx, 7

    back:
    ; 1. Without string instruction---------
        ; mov al, [rsi]
        ; mov [rdi], al

        ; inc rsi
        ; inc rdi

        ; dec rcx
        ; jnz back
        ; ret

    ; 2. With string instructions-----------
        cld ;clear direction flag will inc rsi and rdi
        rep movsb   ; dec rcx and check jnz automatically
    ret

;-------------------------------------------
block_display:
    mov rbp, 7

    next_num:
        mov al, [rsi]
        push rsi

        call display
        Print space, 1
        pop rsi
        inc rsi

        dec rbp
        jnz next_num
    ret
    
;-------------------------------------------
display:
    MOV RSI, char_ans+1
    MOV RCX, 2
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

        Print char_ans, 2

    ret