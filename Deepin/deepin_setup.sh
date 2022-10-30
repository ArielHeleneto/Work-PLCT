#!/bin/bash
build_vm() {

    echo "Starting Building The VM!!!"
    wget https://mirror.iscas.ac.cn/deepin-riscv/deepin-stage1/deepin-beige-stage1-dde.tar.gz
    while shasum ./rootfs.dde.ext4 | grep 89c3b0361f161d4eba74e546a171a94b9facb194 &> /dev/null
    do

        printf "Download Failed!!! Do you Want To Download Again? [y/n] "
        read -r INPUT

        if [[ $INPUT != "Y" && $INPUT != "y" ]]
        then
            break
        fi
        wget https://mirror.iscas.ac.cn/deepin-riscv/deepin-stage1/deepin-beige-stage1-dde.tar.gz
        
    done

    printf "Now We Are Going To Create An Image, Type In The Size (For Example, 8G) >"
    read -r SIZE

    if ! qemu-img create -f raw deepin.raw "$SIZE"
    then
        echo -e "\e[31m Failed!!! \e[0m"
        echo "You should make qemu-img available in your PATH!!!"
        echo "Try to install qemu-utils or qemu-img with your package manager!!!"
        exit 1
    fi

    LOOP=$(sudo losetup -f)
    sudo losetup -P "$LOOP" deepin.raw

    sudo fdisk "$LOOP"

    if ! sudo parted -s "$LOOP" mklabel gpt
    then
        echo -e "\e[31m Failed!!! \e[0m"
        echo "You should make parted available in your PATH!!!"
        echo "Try to install parted with your package manager!!!"
        sudo losetup -D
        exit 1
    fi

    sudo parted -s "$LOOP" mkpart primary 0 100%

    if ! sudo mkfs.ext4 "$LOOP"p1
    then
        echo -e "\e[31m Failed!!! \e[0m"
        echo "You should make mkfs.ext4 available in your PATH!!!"
        echo "Try to install util-linux with your package manager!!!"
        sudo losetup -D
        exit 1
    fi

    sudo mkdir /mnt/deepin
    sudo mount "$LOOP"p1 /mnt/deepin

    tar zxvf ./deepin-beige-stage1-dde.tar.gz

    sudo cp -r ./deepin-beige-stage1-dde/* /mnt/deepin/

    sudo sed "1c root::19292:0:99999:7:::" /mnt/deepin/etc/shadow

    echo "deb [trusted=yes] https://mirror.iscas.ac.cn/deepin-riscv/deepin-stage1/ beige main" | sudo tee /mnt/deepin/etc/apt/source.list &> /dev/null

    sudo umount "$LOOP"p1
    sudo umount rootfs.dde.ext4
    sudo losetup -D

}

start_vm() {
    
    if ! ls ./fw_payload_oe.elf &> /dev/null
    then
        if ! wget https://repo.openeuler.org/openEuler-preview/RISC-V/Image/fw_payload_oe.elf
        then 
            echo -e "\e[31m Failed!!! \e[0m"
            echo "You should make wget available in your PATH!!!"
            echo "Try to install wget with your package manager!!!"
            exit 1
        fi
    fi

    while ! shasum ./fw_payload_oe.elf | grep d2097a5f5c0c9aa4ded9b80136355f81bf96d029 &> /dev/null
    do

        printf "Download Failed!!! Do you Want To Download Again? [y/n] "
        read -r INPUT

        if [[ $INPUT != "Y" && $INPUT != "y" ]]
        then
            break
        fi

        if ! wget https://repo.openeuler.org/openEuler-preview/RISC-V/Image/fw_payload_oe.elf
        then 
            echo -e "\e[31m Failed \e[0m"
            echo "You should make wget available in your PATH!!!"
            echo "Try to install wget with your package manager!!!"
            exit 1
        fi
        
    done

    

    if ls ./deepin.raw &> /dev/null
    then
        build_vm
    fi

    THREADS=$1 # 虚拟机线程数
    MEMORY=$2 # 虚拟机RAM大小
    if ! qemu-system-riscv64 \
        -nographic -machine virt \
        -smp "$THREADS" -m "$MEMORY"G \
        -device virtio-vga \
        -kernel fw_payload_oe.elf \
        -drive file=deepin.raw,if=none,id=hd0 \
        -object rng-random,filename=/dev/urandom,id=rng0 \
        -device virtio-rng-device,rng=rng0 \
        -device virtio-blk-device,drive=hd0 \
        -device virtio-net-device,netdev=usernet \
        -netdev user,id=usernet \
        -bios none \
        -device qemu-xhci -usb -device usb-kbd -device usb-tablet \
        -append "root=/dev/vda1 rw console=ttyS0"
    then
        echo -e "\e[31m Failed!! \e[0m"
        echo "You should make qemu-system-riscv64 available in your PATH!!!"
        echo "Try to install qemu-system-misc or qemu-system-riscv with your package manager!!!"
        exit 1
    fi

}

expr $1 + 0 &> /dev/null

if [ $? -eq 0 ]
then
    expr $2 + 0 &> /dev/null
    if [ $? -eq 0 ]
    then
        start_vm $1 $2
    else
        start_vm 8 8
    fi
else
    start_vm 8 8
fi