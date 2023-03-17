;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    AL = Char
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro PUTCHAR 0
    push rdi
    push rsi
    push rdx
    ; push r11
    ; push rcx

    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall

    ; pop rcx
    ; pop r11
    pop rdx
    pop rsi
    pop rdi 
%endmacro

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    String, String length
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro WRITE 2
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax   
%endmacro

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    None
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%macro EXIT 1
    mov rax, 60
    mov rdi, %1
    syscall
%endmacro
