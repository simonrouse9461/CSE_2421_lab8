/*
 * FILE:  compiler.c
 * NAME:  Chuhan Feng
 * DATE:  Apr 19, 2015
 * CLASS: CSE 2421, T/TH 4:10PM
 */

#include <stdio.h>
#include <stdlib.h>
#define	true 1
#define false 0

int main(void) {
	const int MAX_PROG_LEN = 500;
	int instruction[MAX_PROG_LEN];
	int counter = 0;
	int temp = 0;
	char* head = "USE32\nglobal _start\nsection .rodata\nmemo_ovfl db 'Memory array overflow!'\nmemo_ovfl.l equ $ - memo_ovfl\nillg_ptr db 'Illegal memory pointer position!'\nillg_ptr.l equ $ - illg_ptr\nno_match db 'No matching parenthese!'\nno_match.l equ $ - no_match\nsection .bss\nbuffer resb 1\nmemo_arr resb 500\nmemo_ptr resd 1\nsection .text\n_start:\nmov ebp, esp\nmov eax, memo_arr\nmov [memo_ptr], eax";
	while (temp != '#') {
		temp = getchar();
		instruction[counter] = temp;
		counter++;
	}
	
	counter = 0;
	temp = 0;
		
	while (temp != '#') {
		temp = instruction[counter];
		putchar(temp);
		counter++;
	}
	
	
	return 0;
}

char* read_program() {
	
	
}