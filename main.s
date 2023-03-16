global _start

%include 'macro.s'

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text

_start:     mov rsi, Specificator
            call _printf

            EXIT 0

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%include 'funcs.s'

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .rodata

; .align 8
; .jump_table:
; .quad .binary
; .quad .char
; .quad .decimal
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .octal
; .quad .default
; .quad .default
; .quad .default
; .quad .string
; .quad .default
; .quad .default
; .quad .default
; .quad .default
; .quad .hex

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .data

Specificator: db '%%ab%%o%%ba%%', 10, 0

; DEBUG_MESSAGE: db "HERE!", 10
; DEBUG_LENGTH:  equ $ - DEBUG_MESSAGE

Buffer: db 20 dup(48)
BufferLength:  equ $ - Buffer
