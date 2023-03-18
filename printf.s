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
;~~~Buffers~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Buffer: times 32 db 48

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Error Message~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Error:          db '~~~ERROR~~~'
ErrorLength:    equ $ - Error

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Test Data~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Specificator:   db 'aboba%% %b', 10, 0

String:         db '12345', 0

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
                push rsi	    ;+------> for comfortable use in future.
                push rdi        ;/

                push rbp        ; Saving base pointer.
                mov rbp, rsp    ; Putting stack pointer to base pointer.
                add rbp, 16	    ; Skipping rbp and string with specificators in string.

                mov rsi, rdi    ; Now RSI = Address of template string.

                call __printf   ; Calling main function.

                pop rbp         ; Restoring base pointer.

                pop  rdi        ;\
                pop  rsi        ;|
                pop  rdx        ;|
                pop  rcx        ;+------> Restoring regs with arguments.
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

.next:          mov al, [rsi]       ; Putting current template string symbol to AL.

                cmp al, 0           ; If AL == 0 then it's end of template string.
                je .end

                cmp al, 37  ; '%'   ; If current symbol is % then it's specificator.
                je _hndl_spfr

                PUTCHAR             ; If it's ordinary symbol then output it.

                inc rsi             ; Moving to address of next symbol.
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

_hndl_spfr:     inc rsi             ; Moving to letter address.
                mov al, [rsi]       ; Putting current symbol to AL.

                cmp al, '%'
                jne .handle

                PUTCHAR             ; '%%' -> '%' at output.
                jmp .end

.handle:        cmp al, 0
                je __printf.end        

                cmp al, 'b'         ;\
                jb __error          ;|
                                    ;+------> Checking that letter is in range 'b' - 'x'.
                cmp al, 'x'         ;|
                ja __error          ;/

                mov rax, [jump_table + (rax - 'b') * 8] ; Jumping to function that handles that letter.
                jmp rax

.end:           inc rsi

                jmp __printf.next

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Specificators~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__binary:       ; TODO
                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes char to output
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    Char in stack
; Exit:     None
; Destroys: RAX
; Expects:  Memory buffer 'Buffer' (1 byte at least)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__char:         push rsi

                mov rax, [rbp]  ; Popping out current argument.
                add rbp, 8      ; Moving base pointer to next argument.

                mov rsi, Buffer	
                mov byte [rsi], al

                PUTCHAR

                pop  rsi

                jmp _hndl_spfr.end

__decimal:      
                jmp _hndl_spfr.end

__octal:        
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

__hex:          
                jmp _hndl_spfr.end

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Writes error to output.
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