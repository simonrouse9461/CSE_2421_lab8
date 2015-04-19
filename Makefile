OUTPUTS = interpreter
OBJECTS = interpreter.o

all: $(OUTPUTS)

interpreter: $(OBJECTS)
	ld -melf_i386 interpreter.o -o $@

interpreter.o: interpreter.asm
	nasm -f elf interpreter.asm

clean:
	rm -f $(OBJECTS) $(OUTPUTS)
