OUTPUTS = interpreter
OBJECTS = interpreter.o

all: $(OUTPUTS)

interpreter: $(OBJECTS)
	ld -melf_i386 interpreter.o -o $@

interpreter.o: interpreter.s
	nasm -f elf interpreter.s

clean:
	rm -f $(OBJECTS) $(OUTPUTS)
