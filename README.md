# Operation Systems Development on MacOS

###This is a short tutotial for creating very first operation system.

##1. Getting some stuff installed.

In this repository you will find a setup.sh file. It will work only on MacOS. Lets see whats in it.
~~~
brew install nasm
echo "Generating .bin files"
nasm -f bin -o boot.bin bootloader.nasm
nasm -f bin -o kernel.bin kernel.nasm
echo "Partcopy kernel to boot"
cat kernel.bin >> boot.bin

echo "Generating images for VirtualBox and Qemu"
dd conv=notrunc if=boot.bin of=images/floppy.fda
dd conv=notrunc if=boot.bin of=images/floppy.flp
qemu-system-x86_64 -fda images/floppy.fda
~~~

Before running this script make sure that:
######1. You have installed brew
######2. You have created a folder for your project
######3. You have bootloader.nasm and kernel.nasm files
######4. You have installed on your make nasm packeges
######5. You have installed qemu on you machine.

After all this is done you can run this setup.sh file

So in this tutorial we will learn some theory about kernel and will  create our first Kernel program. When we talk about Kernel there is
a think called security Rings. This Rings are levels of protection in an operation system. There are basically 4 rings: 

1. First Ring also called supervisor mode has more previlegies, this where Kernel stands, so Kernele is allowed to do pretty everything it wants
2. Next two rings are more restricted in its action. This is where drivers are located
3. Ring three also known as User Mode. This is the most restricted level. If you want to do an action you first  must to have permision from Kernel.

This is made with a system call. this means that Kernel  still has ontrol other applications. Thats why Kernel are so important.

There are two general types of Kernel:
1. In computer science, a microkernel (also known as μ-kernel) is the near-minimum amount of software that can provide the mechanisms needed to implement an operating system (OS). These mechanisms include low-level address space management, thread management, and inter-process communication (IPC).

2. A Monolithic kernel is an OS architecture where the entire operating system (which includes the device drivers, file system, and the application IPC) is working in kernel space. Monolithic kernels are able to dynamically load (and unload) executable modules at runtime.

##2. Code the bootloader.

~~~
[bits 16]
mov ax, 07C0h
mov ds, ax
mov es, ax

jmp Main

Write:
  lodsb           ; ds:si -> al
  or  al, al      ; al = current character
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
  

WaitInputMessage db  "Press any key to start kernel", 0
ErrorMessage db  "Error!", 0

Main:

mov si, WaitInputMessage
call Writeline

xor ax, ax
int 16h         ; wait for keypress

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
~~~

##### Above is our bootloader. I explained it with some comments


















