# Bug 名称

## 基本情况

- [ ] 我已经检查了 Issue，进行了搜索，但没有发现类似问题。
- [ ] 我正在着手修复该问题。
- [ ] 我希望接手该问题。
- 严重程度：非常严重/严重/一般/轻微/建议
- 优先级：紧急/高/中/低
- 问题类型：功能性/兼容性/安全/可靠性/易用性/性能效率/可移植性/维护性/其他
- 包名称：

## 环境信息

### 硬件/虚拟机信息

```bash
qemu-system-riscv64 -nographic -machine virt -smp 8 -m 8G -audiodev spice,id=snd0 -kernel ./u-boot.bin -bios ./fw_dynamic.elf -drive file=./oe.qcow2,format=qcow2,id=hd0 -object rng-random,filename=/dev/urandom,id=rng0 -device ich9-intel-hda -device hda-output,audiodev=snd0 -device virtio-vga -device virtio-rng-device,rng=rng0 -device virtio-blk-device,drive=hd0 -device virtio-net-device,netdev=usernet -device qemu-xhci -usb -device usb-kbd -device usb-tablet -device usb-audio,audiodev=snd0 -append 'root=/dev/vda1 rw console=ttyS0 swiotlb=1 loglevel=3 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=8192M earlycon' -netdev user,id=usernet,hostfwd=tcp::12055-:22 -vnc :6156 -device virtio-serial-pci -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent -spice port=12057,disable-ticketing
```

### 操作系统信息

openEuler testing build 20220926

## 缺陷描述

在 xfce 桌面环境中无法正确加载 docx 和 xlsx 的预览。

## 准备过程

预装。

## 操作步骤

无

## 结果

### 预期结果

展示预览图。

## 实际结果

> 请简述实际结果。建议配图配视频配日志。

![preview](./img/preview-wordexcel.png)

## 其他说明

> 其他有助于解决该问题的内容。如果你了解相关的其他信息，请在此处报告。

## 测试人员名单

- 111
