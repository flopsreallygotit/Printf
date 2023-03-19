%include 'macro.s'

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .data

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Jump Table~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jump_table:             dq __binary
                        dq __char
                        dq __decimal

times ('o' - 'd' - 1)   dq __error

                        dq __octal

times ('s' - 'o' - 1)   dq __error

                        dq __string

times ('x' - 's' - 1)   dq __error

                        dq __hex

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Buffer~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Buffer:         times 64 db 48
BufferLength:   equ $ - Buffer

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Error Message~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Error:          db '~~~ERROR~~~'
ErrorLength:    equ $ - Error

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Main function~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; C stdlib.h type printf() with %o, %x, %b, %d, %c, %s specificators
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    CDECL Calling convention Printf entry
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

global _printf

_printf:        push r9         ;\			
                push r8         ;|
                push rcx        ;+------> First six arguments are in these regs 
                push rdx        ;|        and other are in stack. So we push them
                push rsi	    ;+------> for comfortable use in future
                push rdi        ;/

                push rbp        ; Saving base pointer
                mov rbp, rsp    ; Putting stack pointer to base pointer
                add rbp, 16	    ; Skipping rbp and string with specificators in string

                mov rsi, rdi    ; Now RSI = Address of template string

                call __printf   ; Calling main function

                pop rbp         ; Restoring base pointer

                pop  rdi        ;\
                pop  rsi        ;|
                pop  rdx        ;|
                pop  rcx        ;+------> Restoring regs with arguments
                pop  r8         ;|
                pop  r9         ;/

                ret

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Parses specificator string and prints symbols without specificator
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    RSI = Specificator string
;           Arguments in stack
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__printf:       push rax            ; Saving RAX

.next:          mov al, [rsi]       ; Putting current template string symbol to AL

                cmp al, 0           ; If AL == 0 then it's end of template string
                je .end

                cmp al, 37  ; '%'   ; If current symbol is % then it's specificator
                je _hndl_spfr

                PUTCHAR             ; If it's ordinary symbol then output it

                inc rsi             ; Moving to address of next symbol
                jmp .next

.end:           pop  rax
                ret

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Processes specificator
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    RSI = Address of specificator
; Exit:     RSI = Address of first symbol after specificator
; Destroys: RAX
; Expects:  Labels __printf.end and __printf.next
;           Function __error
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

_hndl_spfr:     inc rsi             ; Moving to letter address
                mov al, [rsi]       ; Putting current symbol to AL

                cmp al, '%'
                jne .handle

                PUTCHAR             ; '%%' -> '%' at output
                jmp .end

.handle:        cmp al, 0
                je __printf.end        

                cmp al, 'b'         ;\
                jb __error          ;|
                                    ;+------> Checking that letter is in range 'b' - 'x'
                cmp al, 'x'         ;|
                ja __error          ;/

                mov rax, [jump_table + (rax - 'b') * 8] ; Jumping to function that handles that letter
                jmp rax

.end:           inc rsi

                jmp __printf.next

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Specificators~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes binary form of number in output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    Number in stack
; Exit:     None
; Destroys: RAX, RBX
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__binary:       mov rax, [rbp]  ; Popping out current argument
                add rbp, 8      ; Moving base pointer to next argument

                mov rbx, 2
                call Itoa

                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes char to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    Char in stack
; Exit:     None
; Destroys: RAX
; Expects:  Memory buffer 'Buffer' (1 byte at least)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__char:         mov rax, [rbp]  ; Popping out current argument
                add rbp, 8      ; Moving base pointer to next argument

                push rsi

                mov rsi, Buffer	
                mov byte [rsi], al

                PUTCHAR

                pop  rsi

                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes decimal to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    Decimal in stack
; Exit:     None
; Destroys: RAX, RBX
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__decimal:      mov rax, [rbp]  ; Popping out current argument
                add rbp, 8      ; Moving base pointer to next argument

                mov rbx, 10
                call Itoa

                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes decimal to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    Decimal in stack
; Exit:     None
; Destroys: RAX, RBX
; Expects:  Memory buffer 'Buffer' (1 byte at least)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__octal:        mov rax, [rbp]  ; Popping out current argument
                add rbp, 8      ; Moving base pointer to next argument

                mov rbx, 8
                call Itoa

                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes string to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    String address in stack
; Exit:     None
; Destroys: RAX
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__string:       push rsi

                mov rsi, [rbp]
                add rbp, 8

.next:          mov al, [rsi]
                cmp al, 0
                je .end

                PUTCHAR

                inc rsi
                jmp .next

.end:           pop rsi

                jmp _hndl_spfr.end

__hex:          mov rax, [rbp]  ; Popping out current argument
                add rbp, 8      ; Moving base pointer to next argument

                mov rbx, 16
                call Itoa

                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes error to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    None
; Exit:     None
; Destroys: None
; Expects:  Error message string 'Error'
;           Message length constant 'ErrorLength'
;           Label _hndl_spfr.end
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__error:        WRITE Error, ErrorLength
                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Translates number with given radix to string format
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    EAX = Number, EBX = Radix, RSI = Buffer
; Exit:     Reversed number in string format in buffer
; Destroys: None
; Expects:  Memory buffer 'Buffer' (20 bytes recommended or bigger)
;           Constant length of buffer 'BufferLength'
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Itoa:       push rsi
            push rcx
            push rdx

            mov rsi, Buffer + BufferLength - 1  ; Last symbol of buffer
            xor rcx, rcx

.divide:    xor edx, edx
            div ebx
            add edx, '0'

            cmp edx, '9'
            ja .letter

            jmp .continue

.letter:    add edx, 'A' - '0' - 10

.continue:  mov [rsi], dl

            dec rsi
            inc rcx

            cmp eax, 0
            jnz .divide

            inc rsi

.next:      PUTCHAR

            inc rsi
            dec rcx
            jnz .next

            pop rdx
            pop rcx
            pop rsi

            ret     

; ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ; Entry:    RSI = Address of 0-terminated string
; ; Exit:     None
; ; Destroys: None
; ; Expects:  None
; ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; __reverse_print:    push rsi
;                     push rcx
;                     push ax

;                     xor rcx, rcx

; .next1:             mov al, [rsi]

;                     cmp al, 0
;                     je .end1

;                     inc rcx
;                     inc rsi
;                     jmp .next1

; .end1:              dec rsi

; .next2:             cmp rcx, 0
;                     je .end2

;                     mov al, [rsi]

;                     PUTCHAR

;                     dec rcx
;                     dec rsi
;                     jmp .next2
                    
; .end2:              pop ax
;                     pop rcx
;                     pop rsi

;     ret