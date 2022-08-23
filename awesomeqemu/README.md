# 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

> 修订日期 2022-08-22

## 安装 QEMU

### 系统环境

目前该方案测试过的环境包括 WSL1(Ubuntu 20.04.4 LTS and Ubuntu 22.04.1 LTS) 和 Ubuntu 22.04.1 live-server LTS。

### 安装 VNC Viewer

点击 [此处](https://www.realvnc.com/en/connect/download/viewer/) 前往下载地址。如果速度较慢请考虑科学上网。该软件只有英文，请勿惊慌。

## 安装支持 RISC-V 架构的 QEMU 模拟器

### 使用发行版提供的预编译软件包

以 Ubuntu 22.04 为例。

```bash
sudo apt install qemu-system-misc
qemu-system-riscv64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.3)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
```

### 手动编译安装

> 以下内容引用自 [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)，直接编译可能导致部分功能不可用，作者尚未确认该方案的可用性。
> 修订者注: 建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，**不鼓励** 非必要情况的编译安装。
>
> 下述内容以 Ubuntu 为例

- 安装必要的构建工具

  `$ sudo apt install build-essential git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build`
- 创建 /usr/local 下的目标目录 `$ sudo mkdir -p /usr/local/bin/qemu-riscv64`
- 下载最新的 QEMU 源码包 (修订时为 7.0.0 版本) `$ wget https://download.qemu.org/qemu-7.0.0.tar.xz`
- 解压源码包并切换目录 `$ tar xvJf qemu-7.0.0.tar.xz && cd qemu-7.0.0`
- 配置编译选项 `$ sudo ./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/usr/local/bin/qemu-riscv64`
  > `riscv64-softmmu` 为系统模式，`riscv64-linux-user` 为用户模式。为了测试方便，可以两个都安装
- 编译安装 `$ sudo make && sudo make install`
- 执行 `$ qemu-system-riscv64 --version`，如出现类似如下输出表示 QEMU 成功安装并正常工作。

```` bash
QEMU emulator version 7.0.0
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
````

## 准备 openEuler RISC-V 磁盘映像

### 下载磁盘映像

说明: 至少应当下载启动 payload (`fw_payload_oe_qemuvirt.elf`)，GUI 和 headless 中一种镜像和对应的启动脚本
- 下载目录: [openEuler-RISC-V/testing/*DATE*/*VER*/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/)
- 版本说明: 构建日期 `DATE` 形如 `20220622` ，当日构建版本 `VER` 形如 `v0.2`
  - 如 20220622 的 v0.2 版本 QEMU 镜像文件位于 [openEuler-RISC-V/testing/20220622/v0.2/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20220622/v0.2/QEMU/)

### 内容说明

- `fw_payload_oe_qemuvirt.elf`: 利用 openSBI 将 kernel-5.10 的 image 作为 payload 所制作的 QEMU 的启动内核
- `openeuler-qemu-xfce.raw.tar.zst`: openEuler RISC-V Qemu GUI 磁盘映像压缩包
- `openeuler-qemu.raw.tar.zst`: openEuler RISC-V Qemu headless 磁盘映像压缩包
- `start_vm_xfce.sh`: GUI 虚拟机启动脚本
- `start_vm.sh`: headless 虚拟机启动脚本

## 启动 openEuler RISC-V 虚拟机

### headless 虚拟机

- 确认当前目录内包含 `fw_payload_oe_qemuvirt.elf`, `openeuler-qemu.raw.tar.zst` 和 `start_vm.sh`
- 解压镜像压缩包 `$ tar -I 'zstdmt' -xvf ./openeuler-qemu.raw.tar.zst` 或使用解压工具解压。
- 执行启动脚本 `$ bash start_vm.sh`

### xfce 虚拟机

- 确认当前目录内包含 `fw_payload_oe_qemuvirt.elf`, `openeuler-qemu-xfce.raw.tar.zst`
- 下载教程目录下的 `start_vm_xfce.sh` 并放置在同目录下，并视情况调整设置
- 解压镜像压缩包 `$ tar -I 'zstdmt' -xvf ./openeuler-qemu-xfce.raw.tar.zst` 或使用解压工具解压
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
