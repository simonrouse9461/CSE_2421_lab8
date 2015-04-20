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

.inc_ptr:					; handle '>'
	inc		dword [memo_ptr]
	push	memo_ovfl.l
	push	memo_ovfl
	cmp		dword [memo_ptr], prog_ptr
	jae		error
	add		esp, 0x8

.dec_ptr:					; handle '<'
	dec		dword [memo_ptr]
	push	illg_ptr.l
	push	illg_ptr
	cmp		dword [memo_ptr], memo_arr
	jb		error
	add		esp, 0x8

.inc_val:					; handle '+'
	mov		ebx, [memo_ptr]
	inc		byte [ebx]

.dec_val:					; handle '-'
	mov		ebx, [memo_ptr]
	dec		byte [ebx]

.out_val:					; handle '.'
	push	dword [memo_ptr]
	mov		eax, 4
	mov		ebx, 1
	pop		ecx
	mov		edx, 1
	int		0x80

.in_val:					; handle ','
	mov		eax, 3			; method sys_read
	mov		ebx, 1			; file descriptor (stdin)
	mov		ecx, buffer		; read into buffer
	mov		edx, 1			; input lenth
	int		0x80			; system call
	mov		eax, buffer		; put result in eax
	mov		al, [eax]		; get value of byte
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		[ebx], al		; save byte in memory

.jmp_fwd:
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		bl, [ebx]		; get current memory value
	cmp		bl, 0			; check if 0
	jne		.continue

	call	match_forward	; move instruction pointer to matching position

.jmp_bck:
	mov		ebx, [memo_ptr]	; get memory pointer
	mov		bl, [ebx]		; get current memory value
	cmp		bl, 0			; check if 0
	je		.continue

	call	match_back		; move instruction pointer to matching position
	
	; exit program
	mov		ebx, 0
	mov		eax, 1
	int		0x80

clear_input:
	; save and set up stack frame
	push	ebp
	mov		ebp, esp
							
	; preserve ebx, esi, edi
	push	ebx
	push	esi
	push	edi
						
	; function content
.clear:
	call	read_byte		; read in redundant input characters
	cmp		byte [eax], 0xa	; check \n
	jne		.clear			; repeat if not \n

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
	mov		ebx, 1
	mov		eax, 1
	int		0x80
