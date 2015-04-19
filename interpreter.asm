; FILE:		interpreter.asm
; NAME:		Chuhan Feng
; DATE:		Apr 17, 2015
; CLASS:	CSE 2421, T/TH 4:10

USE32						; tell nasm to assemble 32-bit code

global _start				; export program start symbol

section .rodata				; read-only data section
	; instruction set
	whitespace	db 0x9, 0xa, 0xd, 0x20	; whitespaces
	inc_ptr		db '>'		; pointer increment instruction
	dec_ptr		db '<'		; pointer decrement instruction
	inc_val		db '+'		; value increment instruction
	dec_val		db '-'		; value decrement instruction
	out_val		db '.'		; output instruction
	in_val		db ','		; input instruction
	jmp_fwd		db '['		; conditional jump forward instruction
	jmp_bck		db ']'		; conditional jump backward instruction
	end_sign	db '#'		; end sign of the program

	; error messages
	unrec		db 'Unrecognized instruction!'
	unrec.l		equ $ - unrec
	prog_ovfl	db 'Program array overflow!'
	prog_ovfl.l	equ $ - prog_ovfl
	memo_ovfl	db 'Memory array overflow!'
	memo_ovfl.l	equ $ - memo_ovfl
	illg_ptr	db 'Illegal memory pointer position!'
	illg_ptr.l	equ $ - illg_ptr
	no_match	db 'No matching parenthese!'
	no_match.l	equ $ - no_match

section .data				; read-write data section

section .bss				; storage section
	buffer 		resb 1		; one byte read buffer
	prog_arr	resb 200	; reserved program array
	memo_arr	resb 200	; reserved memory array
	prog_ptr	resd 1		; program pointer
	memo_ptr	resd 1		; memory pointer

section .text				; code section

_start:						; program entry point
	; set up stack frame
	mov		ebp, esp

	call	read_program	; read program from console
	call	write_program	; write program to console
	call	execute_program	; execute program
	
	; exit program
	mov		ebx, 0
	mov		eax, 1
	int		0x80

read_byte:					; function to read byte from stdin
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
	
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
					
	; function content
	mov		eax, 3			; method sys_read
	mov		ebx, 1			; file descriptor (stdin)
	mov		ecx, buffer		; read into buffer
	mov		edx, 1			; input lenth
	int		0x80			; system call
	mov		eax, buffer		; put result in eax

	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
	
	; restore caller's stack frame and return
	leave
	ret

write_byte:					; function to write byte from stdout					
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	; output to console
	mov		eax, 4			; method sys_write
	mov		ebx, 1			; file descriptor (stdout)
	mov		ecx, [ebp+0x8]	; text to output
	mov		edx, 1			; output length
	int		0x80			; system call
							
	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

read_program:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	; initialize the program pointer
	mov		eax, prog_arr	; get address of prog_arr
	mov		[prog_ptr], eax	; store base address of prog_arr in prog_ptr

.read:
	call	read_byte		; read from stdin and save pointer in eax

	; check read byte
	push	eax
	call	instruction_checker
	
	cmp		eax, 0
	je		.read			; jump to read next if white space is found
	cmp		eax, 1
	cmp		eax, 2
	je		.done_read		; done reading if end instruction is found

	; handle error
	push	unrec.l
	push	unrec
	cmp		eax, 3
	je		error
	add		esp, 0x8


	mov		eax, [esp]		; get pointer to read-in byte
	mov		al, [eax]		; store read-in byte in al
	mov		ebx, [prog_ptr]	; get program pointer
	mov		[ebx], al		; put read-in byte in current program array position
	
	inc		dword [prog_ptr]; increase program pointer by one
	jmp		.read			; continue reading

.done_read:
	mov		ebx, [prog_ptr]	; get program pointer
	mov		al, [end_sign]	; get end sign
	mov		[ebx], al		; put end sign at the end of program array

.clear_remainder:
	call	read_byte		; read in redundant characters after end sign
	cmp		byte [eax], 0xa	; check \n
	jne		.clear_remainder; repeat if not \n

.done_clear:
	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

write_program:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	; initialize the program pointer
	mov		eax, prog_arr	; get address of prog_arr
	mov		[prog_ptr], eax	; store base address of prog_arr in prog_ptr

.write:
	mov		ebx, [prog_ptr]	; get program pointer
	push	ebx				; push program pointer
	call	write_byte		; write byte at current program array position into stdout
	mov		al, [ebx]		; get byte from program pointer
	cmp		al, [end_sign]	; compare read-in byte with end sign
	je		.done_write		; done writing if equal
	inc		dword [prog_ptr]; increase program pointer by one
	jmp		.write			; continue writing

.done_write:
	; write a new line to the end
	push	0xa
	push	esp
	call	write_byte

	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

execute_program:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	; initialize the program pointer
	mov		eax, prog_arr	; get address of prog_arr
	mov		[prog_ptr], eax	; store base address of prog_arr in prog_ptr

	; initialize the memory pointer
	mov		eax, memo_arr	; get address of memo_arr
	mov		[memo_ptr], eax	; store base address of memo_arr in memo_ptr

.execute:
	mov		ebx, [prog_ptr]	; get program pointer
	mov		al, [ebx]		; get byte from program pointer

	; identify instruction
	cmp		al, [inc_ptr]	; if instruction is '>'
	je		.inc_ptr
	cmp		al, [dec_ptr]	; if instruction is '<'
	je		.dec_ptr
	cmp		al, [inc_val]	; if instruction is '+'
	je		.inc_val
	cmp		al, [dec_val]	; if instruction is '-'
	je		.dec_val
	cmp		al, [out_val]	; if instruction is '.'
	je		.out_val
	cmp		al, [in_val]	; if instruction is ','
	je		.in_val
	cmp		al, [jmp_fwd]	; if instruction is '['
	je		.jmp_fwd
	cmp		al, [jmp_bck]	; if instruction is ']'
	je		.jmp_bck
	cmp		al, [end_sign]	; if instruction is '#'
	je		.done_execute

.inc_ptr:					; handle '>'
	inc		dword [memo_ptr]; increase memory pointer by one
	jmp		.continue

.dec_ptr:					; handle '<'
	dec		dword [memo_ptr]; decrease memory pointer by one
	jmp		.continue

.inc_val:					; handle '+'
	mov		ebx, [memo_ptr]	; get memory pointer
	inc		byte [ebx]		; increase the value by one
	jmp		.continue

.dec_val:					; handle '-'
	mov		ebx, [memo_ptr]	; get memory pointer
	dec		byte [ebx]		; decrease the value by one
	jmp		.continue

.out_val:					; handle '.'
	push	dword [memo_ptr]; get memory pointer
	call	write_byte		; write data at current memory position
	jmp		.continue

.in_val:					; handle ','
	call	read_byte		; read byte from console
	mov		al, [eax]		; get value of byte
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		[ebx], al		; save byte in memory
	jmp		.continue

.jmp_fwd:
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		bl, [ebx]		; get current memory value
	cmp		bl, 0			; check if 0
	jne		.continue

	call	match_forward	; move instruction pointer to matching position

	jmp		.continue

.jmp_bck:
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		bl, [ebx]		; get current memory value
	cmp		bl, 0			; check if 0
	je		.continue

	call	match_back		; move instruction pointer to matching position

	jmp		.continue

.continue:
	inc		dword [prog_ptr]; increase program pointer by one
	jmp		.execute		; continue executing

.done_execute:
	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

instruction_checker:		; check program instruction character
							; return 0 for whitespace
							; return 1 for normal instruction
							; return 2 for end instruction
							; return 3 for unrecognized instruction
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	mov		edx, [ebp+0x8]	; get pointer to instruction byte to be checked
	mov		dl, [edx]		; get instruction byte to be checked
	mov		ebx, whitespace	; get instruction symbol array base
	mov		ecx, 0			; set up counter

.check_whitespace:
	cmp		ecx, 3			; check if done with whitespace
	ja		.check_normal	; jump to normal instruction checking block

	mov		eax, 0			; return 0 for whitespace
	cmp		dl, [ebx+ecx]	; compare instruction byte with a whitespace
	je		.found			; result found

	inc		ecx				; increase counter
	jmp		.check_whitespace	; go back to whitespace checking block

.check_normal:
	cmp		ecx, 11			; check if done with normal instruction
	ja		.check_end		; jump to end instruciton checking block

	mov		eax, 1			; return 1 for normal instruction
	cmp		dl, [ebx+ecx]	; compare instruction byte with a normal instruction character
	je		.found			; result found

	inc		ecx				; increase counter
	jmp		.check_normal	; go back to normal instruction checking block

.check_end:
	mov		eax, 3			; return 3 for unrecognized instruction
	cmp		ecx, 12			; check if done with end instruction
	ja		.found			; unrecognized instruction found

	mov		eax, 2			; return 2 for end instruction
	cmp		dl, [ebx+ecx]	; compare instruction byte with a end instruction
	je		.found			; result found

	inc		ecx				; increase counter
	jmp		.check_end		; go back to end instruction checking block

.found:
	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

match_forward:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	mov		ecx, 1			; set up counter

.step_forward:
	; get next instruction
	inc		dword [prog_ptr]; move instruction one step forward
	mov		ebx, [prog_ptr]	; get pointer to current instruction
	mov		bl, [ebx]		; get instruction
	
	mov		dh, [jmp_fwd]	; get '['
	mov		dl, [jmp_bck]	; get ']'

	; compare instruction with '[' and ']'
	cmp		bl, dh
	je		.found_jf
	cmp		bl, dl
	je		.found_jb
	jmp		.step_forward

.found_jf:
	inc		ecx				; increase counter by one
	jmp		.check_counter

.found_jb:
	dec		ecx				; decrease counter by one
	jmp		.check_counter

.check_counter:
	test	ecx, ecx		; check is counter is zero
	jnz		.step_forward

	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

match_back:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
	mov		ecx, 1			; set up counter

.step_back:
	; get next instruction
	dec		dword [prog_ptr]; move instruction one step back
	mov		ebx, [prog_ptr]	; get pointer to current instruction
	mov		bl, [ebx]		; get instruction
	
	mov		dh, [jmp_fwd]	; get '['
	mov		dl, [jmp_bck]	; get ']'

	; compare instruction with '[' and ']'
	cmp		bl, dh
	je		.found_jf
	cmp		bl, dl
	je		.found_jb
	jmp		.step_back

.found_jf:
	dec		ecx				; decrease counter by one
	jmp		.check_counter

.found_jb:
	inc		ecx				; increase counter by one
	jmp		.check_counter

.check_counter:
	test	ecx, ecx		; check is counter is zero
	jnz		.step_back

	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret

error:
	mov		eax, 4			; method sys_write
	mov		ebx, 1			; file descriptor (stdout)
	pop		ecx				; text to output
	pop		edx				; output length
	int		0x80			; system call

	; exit program
	mov		ebx, 0
	mov		eax, 1
	int		0x80

template:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content

	; restore ebx, esi, edi
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
							
	; restore caller's stack frame and return
	leave
	ret
