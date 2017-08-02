#!/bin/bash

REPO=$1
shift;

exec qemu-kvm -m 8G "$@" \
  -drive file=/home/dennisz/local/fs-img/test.img,id=disk,if=none,cache=none,discard=off \
  -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 \
  --nographic -smp 8 -s -enable-kvm \
  -kernel /home/dennisz/local/$REPO/arch/x86/boot/bzImage \
  -net nic,vlan=0,model=e1000 \
  -net tap,vlan=0,script=no,downscript=no,ifname=tap0 -usb \
  -append "console=ttyS0 earlyprintk=ttyS0 ignore_loglevel root=/dev/sda1"


#  -netdev user,id=vlan0 -device virtio-net,netdev=vlan0 \
#  -netdev user,id=net0,hostfwd=tcp::8022-:22 \

# Tejun stuff
# -drive file=/home/tj/qemu/test/test1.img,id=disk1,if=none,cache=none,discard=off -device ahci,id=ahci1 -device ide-drive,drive=disk1,bus=ahci.1

# -drive file=/home/tj/qemu/test/test.img,if=virtio,cache=none,discard=off

# -net nic,vlan=0,model=e1000 -net tap,vlan=0,script=no,downscript=no,ifname=tap0 -usb \
  # -drive file=/home/tj/qemu/test/test2.img,if=ide,index=3,media=disk,cache=none \
  # -append "root=/dev/sda2 console=ttyS0 console=tty0" "$@" \
  # -serial file:/home/tj/tmp/test.log \
  # -redir tcp:6970::22
