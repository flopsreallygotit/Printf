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

section .data

Specificator: db 'aboba%% %b', 10, 0

Buffer: db 20 dup(48)
BufferLength:   equ $ - Buffer
