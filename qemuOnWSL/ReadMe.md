# 在 WSL 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

> 修订日期 2022-08-05

## 安装必要环境

### 安装 WSL

略。笔者使用的是 `Ubuntu 20.04.4 LTS` 。

### 安装 VNC Viewer

点击 [此处](https://www.realvnc.com/en/connect/download/viewer/) 前往下载地址。如果速度较慢请考虑科学上网。该软件只有英文，请勿惊慌。

## 安装支持 RISC-V 架构的 QEMU 模拟器

### 使用发行版提供的预编译软件包

```bash
sudo apt install qemu-system-misc
qemu-system-riscv64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.3)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
```

## 下载 openEuler RISC-V 系统镜像

- 下载说明: 至少应当下载启动 payload (`fw_payload_oe_qemuvirt.elf`)，GUI 和 headless 中一种镜像和对应的启动脚本
- 下载目录: [openEuler-RISC-V/testing/*DATE*/*VER*/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/)
- 版本说明: 构建日期 `DATE` 形如 `20220622` ，当日构建版本 `VER` 形如 `v0.2`
  - 如 20220622 的 v0.2 版本 QEMU 镜像文件位于 [openEuler-RISC-V/testing/20220622/v0.2/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20220622/v0.2/QEMU/)
- 内容说明:
  - `fw_payload_oe_qemuvirt.elf`: 利用 openSBI 将 kernel-5.10 的 image 作为 payload 所制作的 QEMU 启动所需文件
  - `openeuler-qemu-xfce.raw.tar.zst`: openEuler RISC-V QEMU GUI 镜像压缩包
  - `start_vm_xfce.sh`: GUI 虚拟机启动脚本
  - `openeuler-qemu.raw.tar.zst`: openEuler RISC-V QEMU headless 镜像压缩包
  - `start_vm.sh`: headless 虚拟机启动脚本

## 启动 openEuler RISC-V 虚拟机

### headless 虚拟机

- 确认当前目录内包含 `fw_payload_oe_qemuvirt.elf`, `openeuler-qemu.raw.tar.zst` 和 `start_vm.sh`
- 解压镜像压缩包 `$ tar -I 'zstdmt' -xvf ./openeuler-qemu.raw.tar.zst` 或使用解压工具解压。
- 执行启动脚本 `$ bash start_vm.sh`

### xfce 虚拟机

- 确认当前目录内包含 `fw_payload_oe_qemuvirt.elf`, `openeuler-qemu-xfce.raw.tar.zst`
- 下载教程目录下的 `start_vm_xfce.sh` 并放置在同目录下，并视情况调整设置
- 解压镜像压缩包 `$ tar -I 'zstdmt' -xvf ./openeuler-qemu.raw.tar.zst` 或使用解压工具解压
- 执行启动脚本 `$ bash start_vm_xfce.sh`
- 根据脚本提示信息连接虚拟机的 SSH Server
- 启动 VNC Viewer ，在地址栏内输入脚本信息回显的地址按回车连接。如果提示未加密请忽略。

### [可选] 启动参数调整

- `vcpu` 为 qemu 运行线程数，与 CPU 核数没有严格对应，建议维持为 8 不变
- `memory` 为虚拟机内存数目，可随需要调整
- `drive` 为虚拟磁盘路径，可随需要调整
- `fw` 为启动 payload
- `ssh_port` 为转发的 SSH 端口，默认为 12055，可随需要调整。
- `vnc_port` 为转发的 VNC 端口，默认为 12056，可随需要调整。

## 登录虚拟机

> 建议在登录成功之后立即修改 root 用户密码
>
> 在 console 直接登录可能出现输入异常

- 用户名: `root`
- 默认密码: `openEuler12#$`

- 登录方式: 命令行 `ssh -p 12055 root@localhost` (或使用您偏好的 ssh 客户端)

登录成功之后，可以看到如下的信息：

```bash
Last login: Mon Jun 27 15:08:35 2022


Welcome to 5.10.0

System information as of time:  Mon Jun 27 07:11:54 PM CST 2022

System load:    0.08
Processes:      130
Memory used:    1.3%
Swap used:      0.0%
Usage On:       23%
IP address:     10.0.2.15
Users online:   2


[root@openEuler-riscv64 ~]#
```

## 参考文献

- [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)
