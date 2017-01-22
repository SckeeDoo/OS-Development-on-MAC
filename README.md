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
Running this file will make all the work for you. All you have to have is a folder where you will have a bootloader.nasm file, kernel.nasm file, an empty folder called images

##2. Lets write some code in assembly.

~~~
mov ax, 9ch
mov ss, ax
mov sp, 4096d
mov ax, 7c0h
mov ds, ax

mov  dx, msg
mov al, 37h
int 10h
jmp $

times 510-($-$$) db 0
dw 0xAA55
~~~

3. Lets move deeper.
After compile this code in the same directory where you saved you .asm file, automatically will be created a .bin file. One important thing is to convert this .bin file into Image so we can boot it to our machine. To do this write this command in cmd:
~~~
copy bootLoader.bin /b bootLoader.img
~~~
After this in the same directory will be created a image file.

##3. Creating Virtual Machine and boot the image.


![imag](http://i.imgur.com/wkTv1cy.png)
![imag](http://i.imgur.com/3tbFF1z.png)
![imag](http://i.imgur.com/EfKPiwr.png)


It's done! Run your virtual machine and see the `goodest` OS eveeeeeeer!


