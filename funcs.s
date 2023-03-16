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

                cmp al, 37  ; '%'
                jne .handle

                PUTCHAR
                jmp .end

.handle:        

.end:           inc rsi
                jmp _printf.next
                ret
