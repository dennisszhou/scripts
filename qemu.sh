#!/bin/bash

REPO=$1
shift;

WORKSPACE=/home/dennisz/local
FS_IMG=$WORKSPACE/fs-img/test.img
NET_ROM=$WORKSPACE/qemu-3.0.0/pc-bios/efi-e1000.rom
DEV_IMG=$WORKSPACE/fs-img/drives

exec qemu-kvm -m 8192 -cpu host "$@" -smp 1 \
	--nographic -s -enable-kvm -usb \
	-kernel /home/dennisz/local/$REPO/arch/x86/boot/bzImage \
	-device e1000,netdev=net0,romfile=$NET_ROM \
	-netdev user,id=net0,ipv6-net=fec0::/64,ipv6-host=fec0::2,ipv6-dns=fec0::3,hostfwd=tcp::5555-:22 \
	-drive file=$FS_IMG,id=disk,if=none,cache=none,discard=off \
	-device ahci,id=ahci \
	-device ide-drive,drive=disk,bus=ahci.0 \
    -drive file=$DEV_IMG/file1.img,id=disk1,if=none,discard=on -device ahci,id=ahci1 -device ide-drive,drive=disk1,bus=ahci.1 \
    -drive file=$DEV_IMG/file2.img,id=disk2,if=none,discard=on -device ahci,id=ahci2 -device ide-drive,drive=disk2,bus=ahci.2 \
    -drive file=$DEV_IMG/file3.img,id=disk3,if=none,discard=on -device ahci,id=ahci3 -device ide-drive,drive=disk3,bus=ahci.3 \
    -drive file=$DEV_IMG/file4.img,id=disk4,if=none,discard=on -device ahci,id=ahci4 -device ide-drive,drive=disk4,bus=ahci.4 \
	-append "console=ttyS0 earlyprintk=ttyS0 ignore_loglevel root=/dev/sda1 \
	cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1"

# exec qemu-kvm -m 8G "$@" \
	#   	-drive file=/home/dennisz/local/fs-img/test.img,id=disk,if=none,cache=none,discard=off \
	#   	-device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 \
	#   	--nographic -smp 8 -s -enable-kvm \
	#   	-net nic,netdev=0,model=e1000 \
	#   	-net tap,netdev=0,script=no,downscript=no,ifname=tap0 -usb \
	#   	-append "console=ttyS0 earlyprintk=ttyS0 ignore_loglevel root=/dev/sda1"

#!/bin/bash

#exec qemu-kvm -m 8192 -cpu host "$@" \
#     -device e1000,netdev=net0 -netdev user,id=net0,ipv6-net=fec0::/64,ipv6-host=fec0::2,ipv6-dns=fec0::3,hostfwd=tcp::5555-:22 -usb \
#      -drive file=/home/htejun/local/qemu/test/test.img,id=disk,if=none,cache=none,discard=off -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 \
#       -drive file=/home/htejun/local/qemu/test/test1.img,id=disk1,if=none,discard=on -device ahci,id=ahci1 -device ide-drive,drive=disk1,bus=ahci.1
# -drive file=/tmp/qemu-swap.img,id=disk1,if=none,cache=none,discard=off -device ahci,id=ahci1 -device ide-drive,drive=disk1,bus=ahci.1

# -drive file=/home/tj/qemu/test/test.img,if=virtio,cache=none,discard=off

# -drive file=/home/tj/qemu/test/test2.img,if=ide,index=3,media=disk,cache=none \
    # -append "root=/dev/sda2 console=ttyS0 console=tty0" "$@" \
    # -serial file:/home/tj/tmp/test.log \
    # -redir tcp:6970::22
