#!/bin/bash

basedrive=openeuler-qemu.qcow2
fw=fw_payload_oe_qemuvirt.elf
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`

if [ ! -d "controller" ]
then
mkdir controller
fi
if [ ! -d "drive" ]
then
mkdir drive
fi
while [ ! -f "controller/stop-"$1 ]
do
echo -e "\033[37mStarting VM "$1"... \033[0m"
rm -f "./drive/$1.qcow2"
qemu-img create -o backing_file=../${basedrive},backing_fmt=qcow2 -f qcow2 drive/$1.qcow2
cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -audiodev none,id=snd0 \
  -device ich9-intel-hda \
  -device hda-output,audiodev=snd0 \
  -kernel "$fw" \
  -bios none \
  -drive file=drive/$1.qcow2,format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -device qemu-xhci \
  -append 'root=/dev/vda1 rw console=ttyS0 swiotlb=1 loglevel=3 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem="$memory_append"M earlycon' \
  -netdev user,id=usernet,hostfwd=tcp::"$1"-:22 "
eval $cmd
done
rm -f "controller/stop-"$1
echo "Exit."