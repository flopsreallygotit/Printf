;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Saves RAX, RCX, R11 and calls system
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    None
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro SAVE_SYSTEMCALL 0
    nop
    push rax
    push rcx
    push r11

    syscall

    pop  r11
    pop  rcx
    pop  rax
    nop
%endmacro

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Outputs char to console
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    [RSI] = Char to output
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro PUTCHAR 0
    nop
    push rdi
    push rdx
    push rax

    mov rax, 1
    mov rdi, 1
    mov rdx, 1

    SAVE_SYSTEMCALL

    pop  rax
    pop  rdx
    pop  rdi 
    nop
%endmacro

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes string to console 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    String, String length
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro WRITE 2
    nop
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2

    SAVE_SYSTEMCALL

    pop  rdx
    pop  rsi
    pop  rdi
    pop  rax   
    nop
%endmacro

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    None
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro EXIT 1
    nop

    mov rax, 60
    mov rdi, %1

    syscall

    nop
%endmacro
