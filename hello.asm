USE32
global _start
section .rodata
memo_ovfl db 'Memory array overflow!'
memo_ovfl.l equ $ - memo_ovfl
illg_ptr db 'Illegal memory pointer position!'
illg_ptr.l equ $ - illg_ptr
no_match db 'No matching parenthese!'
no_match.l equ $ - no_match
section .bss
buffer resb 1
memo_arr resb 500
memo_ptr resd 1
section .text
_start:
mov ebp, esp
mov eax, memo_arr
mov [memo_ptr], eax
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx].loop_0:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_0
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
dec byte [ebx]jmp .loop_0
.end_loop_0:
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
.loop_1:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_1
mov ebx, [memo_ptr]
dec byte [ebx]jmp .loop_1
.end_loop_1:
mov ebx, [memo_ptr]
inc byte [ebx]dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
.loop_2:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_2
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
.loop_3:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_3
mov ebx, [memo_ptr]
dec byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
jmp .loop_3
.end_loop_3:
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
jmp .loop_2
.end_loop_2:
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
.loop_4:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_4
.loop_5:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_5
mov ebx, [memo_ptr]
dec byte [ebx]jmp .loop_5
.end_loop_5:
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
.loop_6:
mov ebx, [memo_ptr]
mov bl, [ebx]
cmp bl, 0
je .end_loop_6
mov ebx, [memo_ptr]
dec byte [ebx]jmp .loop_6
.end_loop_6:
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
jmp .loop_4
.end_loop_4:
dec dword [memo_ptr]
push illg_ptr.l
push illg_ptr
cmp dword [memo_ptr], memo_arr
jb error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]mov ebx, [memo_ptr]
dec byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
inc dword [memo_ptr]
push	memo_ovfl.l
push memo_ovfl
cmp dword [memo_ptr], prog_ptr
jae error
add esp, 0x8
mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]mov ebx, [memo_ptr]
inc byte [ebx]push dword [memo_ptr]
mov eax, 4
mov ebx, 1
pop ecx
mov edx, 1
int	0x80
mov ebx, 0
mov eax, 1
int 0x80
error:
mov eax, 4
mov ebx, 1
pop ecx
pop edx
int 0x80
mov ebx, 1
mov eax, 1
int 0x80
