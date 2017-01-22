[bits 16]
mov ax, 07E0h
mov ds, ax
mov es, ax

jmp KernelLoaded

Write:
  lodsb           ; move byte [DS:SI] into AL
  or  al, al      ; al=current character
  jz  EndWrite    ; exit if null terminator found
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


moldova: 
  call cls
  mov ax,012h ;VGA mode
 int 10h ;640 x 480 16 colors.
  mov al, 00000001b ; blue color
  stosb
  mov cx, 20  ;col
  mov dx, 20  ;row
  mov ah, 0ch ; put pixel


  colcount:
  inc cx
  int 10h
  cmp cx, 170
  JNE colcount

  mov cx, 20  ; reset to start of col
  inc dx      ;next row
  cmp dx, 280
  JNE colcount


  ; Draw Yellow part
  mov al, 00001110b ; yellow color
  stosb
  mov cx, 170  ;col
  mov dx, 20  ;row
  mov ah, 0ch ; put pixel


  colcount2:
  inc cx
  int 10h
  cmp cx, 320
  JNE colcount2

  mov cx, 170  ; reset to start of col
  inc dx      ;next row
  cmp dx, 280
  JNE colcount2


; Draw RED part
  mov al, 0000100b ; red color
  stosb
  mov cx, 320  ;col
  mov dx, 20  ;row
  mov ah, 0ch ; put pixel


  colcount3:
  inc cx
  int 10h
  cmp cx, 470
  JNE colcount3

  mov cx, 320  ; reset to start of col
  inc dx      ;next row
  cmp dx, 280
  JNE colcount3
  int 10h
ret


help:

  mov si, HelpMessage0
  call Writeline
  mov si, HelpMessage1
  call Writeline
  mov si, HelpMessage2
  call Writeline
  mov si, HelpMessage3
  call Writeline
  mov si, HelpMessage4
  call Writeline
  mov si, HelpMessage5
  call Writeline
  mov si, HelpMessage6
  call Writeline
  mov si, HelpMessage7
  call Writeline
  mov si, HelpMessage8
  call Writeline
ret


bgcolor:
  add bl, 10h
  call cls
ret


fgcolor:
  add bl, 1h
  call cls
ret


cls:
  mov dx, 0 ; Set cursor to top left-most corner of screen
  mov bh, 0
  mov ah, 02h
  int 10h
  mov cx, 2000 ; print 2000 chars
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 09h
  int 10h
ret


cpuinfo:
  xor eax, eax
  cpuid
  mov [CpuidBuffer], ebx
  mov [CpuidBuffer+4], edx
  mov [CpuidBuffer+8], ecx
  
  mov si, CpuidMessage1 
  call Write
  
  mov si, CpuidBuffer       ;"GenuineIntel"
  call Write
  
  mov si, CpuidMessage2
  call Writeline
ret
  
random:
    mov ah, 00h  ; interrupts to get system time        
    int 1ah      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
    xor  dx, dx
    mov  cx, 10    
    div  cx       ; here dx contains the remainder of the division - from 0 to 9

    mov ah, 0Eh
    mov al, ' '
    int 10h
    mov al, ' '
    int 10h
    mov al, ' '
    int 10h
    add  dl, '0'  ; to ascii from '0' to '9' 
    mov al, dl
    int 10h
ret



time:
    mov ah, 02h         ;Rom-Bios interrupt func. for getting cur. time
    int 1Ah             ;ch = hours; cl = minutes; dh = seconds (BCD)
    ;now time will be converted from BCD to ASCII
    ;working with hours
    mov bh, ch          ;bh = hours (BCD)
    shr bh, 4           ;bh = first digit of hours (BCD)
    add bh, 30h         ;bh = first digit of hours (ASCII)
    mov [TimeMessage + 23], bh
    mov bh, ch          ;bh = hours (BCD)
    and bh, 0fh         ;bh = second digit of hours (BCD)
    add bh, 30h         ;bh = second digit of hours (ASCII)
    mov [TimeMessage + 24], bh
    ;working with minutes
    mov bh, cl          ;bh = minutes (BCD)
    shr bh, 4           ;bh = first digit of minutes (BCD)
    add bh, 30h         ;bh = first digit of minutes (ASCII)
    mov [TimeMessage + 26], bh
    mov bh, cl          ;bh = minutes (BCD)
    and bh, 0fh         ;bh = second digit of minutes (BCD)
    add bh, 30h         ;bh = second digit of minutes (ASCII)
    mov [TimeMessage + 27], bh
    ;working with seconds
    mov bh, dh          ;bh = seconds (BCD)
    shr bh, 4           ;bh = first digit of seconds (BCD)
    add bh, 30h         ;bh = first digit of seconds (ASCII)
    mov [TimeMessage + 29], bh
    mov bh, dh          ;bh = seconds (BCD)
    and bh, 0fh         ;bh = second digit of seconds (BCD)
    add bh, 30h         ;bh = second digit of seconds (ASCII)
    mov [TimeMessage + 30], bh
    ;print time
    mov si, TimeMessage
    call Writeline       
ret

;function for comparing strings
%macro Compare 1
  mov si, 0
  %%Loop:
    mov al, byte[%1 + si]
    cmp byte[InputString + si], al
    jnz %%Different
    inc si
    loop %%Loop
    inc si
    mov al, ' '
    cmp byte[InputString + si], al
    jnz %%Different   
    mov al, 1
    %%Different: nop
%endmacro

Color db 0Fh
KernelMessage db "Kernel loaded!", 0
CpuidMessage1 db "You have an ", 0
CpuidMessage2 db " Computer", 0
Moldovamsg   db "Schidu Vasile", 0
TimeMessage  DB  "Current System Time is   :  :  ", 0
HelpMessage0  db "Available Commands : ", 0
HelpMessage1  db "cls  - Clear screen", 0 
HelpMessage2  db "cpuinfo - Output CpuID", 0 
HelpMessage3  db "bgcolor - Change background color", 0 
HelpMessage4  db "fgcolor - Change text color", 0 
HelpMessage5  db "moldova - Draw the Moldova Flag", 0 
HelpMessage6  db "help - Print help menu", 0 
HelpMessage7  db "random - Generate a random number", 0 
HelpMessage8 db "time - get current time", 0 
ErrorMessage db "Command not found!", 0
CpuidBuffer times 14 db 0
ConsoleMessage db " > ", 0
InputString times 15 db ' '


KernelLoaded:
  mov si, KernelMessage
  call Writeline
  mov bl, 0Fh
  call help

ConsoleInput:
  mov si, ConsoleMessage
  call Write
  
  mov si, 15
  mov cx, 15
  Erase:
    mov byte [InputString + si], ' '
    dec si
    loop Erase
  
  Input:
  mov ah, 00h
  int 16h
  
  cmp ax, 1C0Dh
  jz EnterPressed
  
  mov byte [InputString + si], al
  inc si
  mov ah, 0Eh
  int 10h
  
  jmp Input 
  
  EnterPressed:
     
      mov cx, 3
      Compare ClearCommand
      cmp al, 1
      jnz Help
      call Newline
      call cls
      jmp ConsoleInput
    
    Help: 
      mov cx, 4
      Compare HelpCommand
      cmp al, 1
      jnz BGColor
      call Newline
      call help
      jmp ConsoleInput
    
    BGColor:
      mov cx, 7
      Compare BGColorCommand
      cmp al, 1
      jnz FGColor
      call Newline
      call bgcolor
      jmp ConsoleInput
    
    FGColor:
      mov cx, 7
      Compare FGColorCommand
      cmp al, 1
      jnz Moldova
      call Newline
      call fgcolor
      jmp ConsoleInput
    
    Moldova:
      mov cx, 7
      Compare MoldovaCommand
      cmp al, 1
      jnz CPUInfo
      call Newline
      call moldova
      jmp ConsoleInput
    
    CPUInfo:
      mov cx, 7
      Compare CpuCommand
      cmp al, 1
      jnz Random
      call Newline
      call cpuinfo
      jmp ConsoleInput
      
    Random:
      mov cx, 6
      Compare RandomCommand
      cmp al, 1
      jnz Time
      call Newline
      call random
      call Newline
      jmp ConsoleInput
      
     Time:
      mov cx, 4 
      Compare TimeCommand
      cmp al, 1
      jnz Error
      call Newline     
      call time
      jmp ConsoleInput
    
    Error:
      call Newline
      mov si, ErrorMessage
      call Writeline
      
jmp ConsoleInput

ClearCommand db "cls", 0
CpuCommand db "cpuinfo", 0
BGColorCommand db "bgcolor", 0
FGColorCommand db "fgcolor", 0
MoldovaCommand db "moldova", 0
RandomCommand db "random", 0
TimeCommand db "time", 0
HelpCommand db "help", 0
    

cli  ;clear the interrupt flag (disable interrupts)
hlt  ;halt

times 1536 - ($-$$) db 0 ; pad with zeros in order to fill the 512 bytes