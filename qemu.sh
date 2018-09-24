#!/bin/bash

REPO=$1
shift;

FS_IMG=/home/dennisz/local/fs-img/test.img
NET_ROM=/home/dennisz/local/qemu-3.0.0/pc-bios/efi-e1000.rom

exec qemu-kvm -m 8192 -cpu host "$@" -smp 2 \
	--nographic -s -enable-kvm -usb \
	-kernel /home/dennisz/local/$REPO/arch/x86/boot/bzImage \
	-device e1000,netdev=net0,romfile=$NET_ROM \
	-netdev user,id=net0,ipv6-net=fec0::/64,ipv6-host=fec0::2,ipv6-dns=fec0::3,hostfwd=tcp::5555-:22 \
	-drive file=$FS_IMG,id=disk,if=none,cache=none,discard=off \
	-device ahci,id=ahci \
	-device ide-drive,drive=disk,bus=ahci.0 \
	-append "console=ttyS0 earlyprintk=ttyS0 ignore_loglevel root=/dev/sda1 \
	cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1"

# exec qemu-kvm -m 8G "$@" \
	#   	-drive file=/home/dennisz/local/fs-img/test.img,id=disk,if=none,cache=none,discard=off \
	#   	-device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 \
	#   	--nographic -smp 8 -s -enable-kvm \
	#   	-net nic,netdev=0,model=e1000 \
	#   	-net tap,netdev=0,script=no,downscript=no,ifname=tap0 -usb \
	#   	-append "console=ttyS0 earlyprintk=ttyS0 ignore_loglevel root=/dev/sda1"
