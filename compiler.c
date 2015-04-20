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
	int p_array[500];
	int p_pointer = 0;
	int p_counter = 0;
	int temp = 0;
	char* head = "USE32\nglobal _start\nsection .rodata\nmemo_ovfl db 'Memory array overflow!'\nmemo_ovfl.l equ $ - memo_ovfl\nillg_ptr db 'Illegal memory pointer position!'\nillg_ptr.l equ $ - illg_ptr\nno_match db 'No matching parenthese!'\nno_match.l equ $ - no_match\nsection .bss\nbuffer resb 1\nmemo_arr resb 500\nmemo_ptr resd 1\nsection .text\n_start:\nmov ebp, esp\nmov eax, memo_arr\nmov [memo_ptr], eax\n";
	char* foot = "mov ebx, 0\nmov eax, 1\nint 0x80\nerror:\nmov eax, 4\nmov ebx, 1\npop ecx\npop edx\nint 0x80\nmov ebx, 1\nmov eax, 1\nint 0x80\n";
	char* inc_ptr = "inc dword [memo_ptr]\npush	memo_ovfl.l\npush memo_ovfl\ncmp dword [memo_ptr], prog_ptr\njae error\nadd esp, 0x8\n";
	char* dec_ptr = "dec dword [memo_ptr]\npush illg_ptr.l\npush illg_ptr\ncmp dword [memo_ptr], memo_arr\njb error\nadd esp, 0x8\n";
	char* inc_val = "mov ebx, [memo_ptr]\ninc byte [ebx]";
	char* dec_val = "mov ebx, [memo_ptr]\ndec byte [ebx]";
	char* out_val = "push dword [memo_ptr]\nmov eax, 4\nmov ebx, 1\npop ecx\nmov edx, 1\nint	0x80\n";
	char* in_val = "mov eax, 3\nmov ebx, 1\nmov ecx, buffer\nmov edx, 1\nint 0x80\nmov eax, buffer\nmov al, [eax]\nmov ebx, [memo_ptr]\nmov [ebx], al";
	char* jmp_fwd_0 = ".loop_";
	char* jmp_fwd_1 = ":\nmov ebx, [memo_ptr]\nmov bl, [ebx]\ncmp bl, 0\nje .end_loop_";
	char* jmp_fwd_2 = "\n";
	char* jmp_bck_0 = "jmp .loop_";
	char* jmp_bck_1 = "\n.end_loop_";
	char* jmp_bck_2 = ":\n";
	
	while (temp != '#') {
		temp = getchar();
		if (temp != 0x9 && temp != 0xa && temp != 0xd && temp != 0x20) {
			instruction[counter] = temp;
			counter++;
		}
	}
	
	printf(head);
	counter = 0;
	temp = 0;
	while (temp != '#') {
		temp = instruction[counter];
		int mark;
		switch (temp) {
			case '>':
				printf(inc_ptr);
				break;
			case '<':
				printf(dec_ptr);
				break;
			case '+':
				printf(inc_val);
				break;
			case '-':
				printf(dec_val);
				break;
			case '.':
				printf(out_val);
				break;
			case ',':
				printf(in_val);
				break;
			case '[':
				p_array[p_pointer] = p_counter;
				mark = p_array[p_pointer];
				printf("%s%d%s%d%s", jmp_fwd_0, mark, jmp_fwd_1, mark, jmp_fwd_2);
				p_pointer++;
				p_counter++;
				break;
			case ']':
				p_pointer--;
				mark = p_array[p_pointer];
				printf("%s%d%s%d%s", jmp_bck_0, mark, jmp_bck_1, mark, jmp_bck_2);
				break;
			default:
				break;
		}
		counter++;
	}
	printf(foot);
	
	return 0;
}
