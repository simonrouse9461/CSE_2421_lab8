OUTPUTS = interpreter compiler
OBJECTS = *.o
BINARYS = compile run

all: $(OUTPUTS)

interpreter: interpreter.o
	ld -melf_i386 interpreter.o -o $@

interpreter.o: interpreter.s
	nasm -f elf interpreter.s

compiler: compiler.c
	gcc -g -Wall compiler.c -o $@

compile: compiler
	compiler > $@

run: compile
	nasm -f elf compile
	ld -melf_i386 compile.o -o $@
	./run

clean:
	rm -f $(OBJECTS) $(OUTPUTS) $(BINARYS)
