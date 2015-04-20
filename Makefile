OUTPUTS = interpreter compiler
OBJECTS = *.o
BINARYS = compile run

all: $(OUTPUTS)

interpreter: interpreter.o
	ld -melf_i386 interpreter.o -o $@

interpreter.o: interpreter.asm
	nasm -f elf interpreter.asm -Ov

compiler: compiler.c
	gcc -g -Wall compiler.c -o $@

compile: clean compiler
	compiler > $@

run: clean compile
	nasm -f elf compile -Ov
	ld -melf_i386 compile.o -o $@

clean:
	rm -f $(OBJECTS) $(OUTPUTS) $(BINARYS)
