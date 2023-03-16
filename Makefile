.PHONY: all
all:
	@echo "Compiling file;"
	@nasm -f elf64 -l main.lst -o main.o main.s

	@echo "Linking files;"
	@ld -o main main.o

.PHONY: clear
clear:
	@echo "Clearing object files and executable;";
	@rm -rf main.o main.lst main
