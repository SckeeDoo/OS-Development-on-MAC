[bits 16]
mov ax, 07C0h
mov ds, ax
mov es, ax

jmp Main

Write:
  lodsb           ; ds:si -> al
  or  al, al      ; al=current character
  jz  EndWrite ; exit if null terminator found
  mov ah, 0Eh     ; print char in al in teletype mode
  int 10h 
  jmp Write
EndWrite:
  ret


Newline:
  mov al, 0Dh
  mov ah, 0Eh
  int 10h
  mov al, 0Ah
  int 10h
  ret


Writeline:
  call Write
  call Newline
  ret
  

WaitInputMessage db  "Press any key to load kernel", 0
ErrorMessage db  "Error!", 0

Main:

mov si, WaitInputMessage
call Writeline

xor ax, ax
int 16h ; wait for keypress

; set destination segment
mov   ax, 7E0h
mov   es, ax
xor   bx, bx

ReadFromFloppy:
  mov ah, 2 ; read sectors
  mov al, 3 ; number of sectors to read
  mov ch, 0 ; track number
  mov cl, 2 ; sector number (kernel is in the second sector)
  mov dh, 0 ; head number
  mov dl, 0 ; drive number
  int 13h   ; call BIOS
  jc ReadFromFloppy        ; Error, so try again


; check data integrity
mov al, byte [es:0h]
cmp al, 0B8h
je LoadKernel


; print error message and halt system
mov si, ErrorMessage
call Writeline

cli
hlt

LoadKernel:
  jmp 7E0h:0h ; jump to kernel

times 510 - ($-$$) db 0 ; pad with zeros in order to fill the 512 bytes

dw 0AA55h ;MBR signature id

