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
;~~~Test Data~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Specificator:   db 'aboba%% %b', 10, 0

String:         db '12345', 0

Error:          db '~~~ERROR~~~'
ErrorLength:    equ $ - Error

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text

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

                pop rdi         ;\
                pop rsi         ;|
                pop rdx         ;|
                pop rcx         ;+------> Restoring regs with arguments.
                pop r8          ;|
                pop r9          ;/

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

__printf:       push ax

.next:          mov al, [rsi]

                cmp al, 0
                je .end

                cmp al, 37  ; '%'
                je _hndl_spfr

                PUTCHAR

                inc rsi
                jmp .next

.end:           pop ax

                ret

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Processes specificator
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    RSI = Address of specificator
; Exit:     RSI = Address of first symbol after specificator
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

_hndl_spfr:     inc rsi
                mov al, [rsi]

                cmp al, 37  ; '%'
                jne .handle

                PUTCHAR
                jmp .end

.handle:        cmp al, 0
                je __printf.end        

                cmp al, 'b'
                jb __error

                cmp al, 'x'
                ja __error

                mov rax, [jump_table + (rax - 'b') * 8]
                jmp rax

.end:           inc rsi
                jmp __printf.next
                ret

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Specificators~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__binary:       
                jmp _hndl_spfr.end

__char:         
                jmp _hndl_spfr.end

__decimal:      
                jmp _hndl_spfr.end

__octal:        
                jmp _hndl_spfr.end

__string:       
                jmp _hndl_spfr.end

__hex:          
                jmp _hndl_spfr.end

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