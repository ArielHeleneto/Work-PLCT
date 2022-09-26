#!/bin/bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters

## Configuration
vcpu=8
memory=8
memory_append=`expr $memory \* 1024`
drive="./ubuntu-k8s.qcow2"
kernel=u-boot.bin
bios=fw_jump.elf
ssh_port=12055
vnc_port=12056
spice_port=12057
remoteip=localhost
[[ $spice_port ]] && audiobackend="spice" || audiobackend="none"
sleeptime=0

cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -audiodev "$audiobackend",id=snd0 \
  -kernel "$kernel" \
  -bios "$bios" \
  -drive file="$drive",format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device ich9-intel-hda \
  -device hda-output,audiodev=snd0 \
  -device virtio-vga \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -device qemu-xhci -usb -device usb-kbd -device usb-tablet -device usb-audio,audiodev=snd0 \
  -append 'root=/dev/vda1 rw console=ttyS0 swiotlb=1 loglevel=3 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem="$memory_append"M earlycon' "

echo -e "\033[37mUsing the following configuration: \033[0m"
echo ""
echo -e "\033[37mvCPU Cores:      \033[0m \033[34m"$vcpu"\033[0m"
echo -e "\033[37mMemory:          \033[0m \033[34m"$memory"\033[0m"
echo -e "\033[37mDisk Path:       \033[0m \033[34m"$drive"\033[0m"
echo -e "\033[37mKernal Path:     \033[0m \033[34m"$kernel"\033[0m"
echo -e "\033[37mBIOS Path:       \033[0m \033[34m"$bios"\033[0m"
if [ $ssh_port ]
then
echo -e "\033[37mSSH Port:        \033[0m \033[34m"$ssh_port"\033[0m"
cmd="${cmd} -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 "
else
cmd="${cmd} -netdev user,id=usernet "
fi
if [ $vnc_port ]
then
echo -e "\033[37mVNC Port:        \033[0m \033[34m"$vnc_port"\033[0m"
cmd="${cmd} -vnc :"$((vnc_port-5900))
fi
if [ $spice_port ]
then
echo -e "\033[37mSPICE Port:      \033[0m \033[34m"$spice_port"\033[0m"
cmd="${cmd} -device virtio-serial-pci \
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
-chardev spicevmc,id=spicechannel0,name=vdagent \
-spice port=${spice_port}"
fi
echo ""
if [ $ssh_port ]
then
echo -e "\033[37mUse the following command to connect SSH server:\0\033[0m\033[34m ssh root@"$remoteip" -p "$ssh_port"\033[0m"
fi
if [ $vnc_port ]
then
echo -e "\033[37mUse the following address to connect VNC server:\0\033[0m\033[34m "$remoteip":"$vnc_port"\033[0m"
fi
if [ $spice_port ]
then
echo -e "\033[37mUse the following address to connect SPICE server:\0\033[0m\033[34m spice://"$remoteip":"$spice_port"\033[0m"
fi
echo ""
echo -e "\033[37mUsing the following command to start VM: \033[0m"
echo ""
echo $cmd
echo ""
sleep $sleeptime
echo -e "\033[37mStarting VM... \033[0m"
eval $cmd
echo -e "Exit."
