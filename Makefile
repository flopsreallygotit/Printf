.PHONY: all
all:
	@echo "Compiling C file;"
	@g++ -c main.cpp -o main.o -O0

	@echo "Compiling Assembler file;"
	@nasm -f elf64 -l printf.lst -o printf.o -g printf.s

	@echo "Linking files;"
	@g++ -no-pie main.o printf.o -o main

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.PHONY: clear
clear:
	@echo "Clearing object files;";
	@rm -rf *.o

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.PHONY: fclear
fclear:
	@echo "Clearing logs, object files and executable;";
	@rm -rf *.o *.lst main
