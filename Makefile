

default: build



build/main.o: src/main.asm
	@mkdir -p build/
	nasm -g src/main.asm  -f elf32 -o build/main.o

build/a.out: build/main.o
	ld -m elf_i386 -o build/a.out build/main.o

run: build
	@echo == running
	@build/a.out

debug: build
	@echo == debugging
	gdb build/a.out -ex=starti

hex: build
	@echo == running and dumping output
	@build/a.out > build/hex.out
	@ghex build/hex.out

build: build/a.out

clean:
	rm -rf build/

.PHONY: build clean default run debug hex
