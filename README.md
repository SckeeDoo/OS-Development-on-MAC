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

