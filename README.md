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
#1. You have installed brew
#2. You have created a folder for your project
#3. You have bootloader.nasm and kernel.nasm files
#4. You have installed on your make nasm packeges
#5. You have installed qemu on you machine.

After all this is done you can run this setup.sh file


