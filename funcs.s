section .text

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    RSI = Specificator string
;           Arguments in stack
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

_printf:        push rsi
                push ax

.next:          mov al, [rsi]

                cmp al, 0
                je .end

                cmp al, 37  ; '%'
                je _hndl_spfr

                PUTCHAR

                inc rsi
                jmp .next

.end:           pop ax
                pop rsi

                ret

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
                je _printf.end        

                cmp al, 'b'
                jb __error

                cmp al, 'x'
                ja __error

                mov rax, [jump_table + (rax - 'b') * 8]
                jmp rax

.end:           inc rsi
                jmp _printf.next
                ret

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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Entry:    RSI = Address of 0-terminated string
; Exit:     None
; Destroys: None
; Expects:  None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__reverse_print:    push rsi
                    push rcx
                    push ax

                    xor rcx, rcx

.next1:             mov al, [rsi]

                    cmp al, 0
                    je .end1

                    inc rcx
                    inc rsi
                    jmp .next1

.end1:              dec rsi

.next2:             cmp rcx, 0
                    je .end2

                    mov al, [rsi]

                    PUTCHAR

                    dec rcx
                    dec rsi
                    jmp .next2
                    
.end2:              pop ax
                    pop rcx
                    pop rsi

    ret