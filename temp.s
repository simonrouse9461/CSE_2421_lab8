USE32
global _start
section .rodata
	memo_ovfl	db 'Memory array overflow!'
	memo_ovfl.l	equ $ - memo_ovfl
	illg_ptr	db 'Illegal memory pointer position!'
	illg_ptr.l	equ $ - illg_ptr
	no_match	db 'No matching parenthese!'
	no_match.l	equ $ - no_match
section .bss
	buffer 		resb 1
	memo_arr	resb 500
	memo_ptr	resd 1
section .text
_start:
	mov		ebp, esp
	mov		eax, memo_arr
	mov		[memo_ptr], eax

inc_ptr:					; handle '>'
	inc		dword [memo_ptr]
	push	memo_ovfl.l
	push	memo_ovfl
	cmp		dword [memo_ptr], prog_ptr
	jae		error
	add		esp, 0x8

dec_ptr:					; handle '<'
	dec		dword [memo_ptr]
	push	illg_ptr.l
	push	illg_ptr
	cmp		dword [memo_ptr], memo_arr
	jb		error
	add		esp, 0x8

inc_val:					; handle '+'
	mov		ebx, [memo_ptr]
	inc		byte [ebx]

dec_val:					; handle '-'
	mov		ebx, [memo_ptr]
	dec		byte [ebx]

out_val:					; handle '.'
	push	dword [memo_ptr]
	mov		eax, 4
	mov		ebx, 1
	pop		ecx
	mov		edx, 1
	int		0x80

in_val:						; handle ','
	mov		eax, 3			; method sys_read
	mov		ebx, 1			; file descriptor (stdin)
	mov		ecx, buffer		; read into buffer
	mov		edx, 1			; input lenth
	int		0x80			; system call
	mov		eax, buffer		; put result in eax
	mov		al, [eax]		; get value of byte
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		[ebx], al		; save byte in memory

jmp_fwd:
.loop:
	mov		ebx, [memo_ptr]
	mov		bl, [ebx]
	cmp		bl, 0
	je		.end_loop

jmp_bck:
	jmp		.loop
.end_loop:
	
	; exit program
	mov		ebx, 0
	mov		eax, 1
	int		0x80
clear_input:
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi
.clear:
	call	read_byte
	cmp		byte [eax], 0xa
	jne		.clear
	mov		edi, [ebp-0xc]
	mov		esi, [ebp-0x8]
	mov		ebx, [ebp-0x4]
	leave
	ret
error:
	mov		eax, 4
	mov		ebx, 1
	pop		ecx
	pop		edx
	int		0x80
	mov		ebx, 1
	mov		eax, 1
	int		0x80
