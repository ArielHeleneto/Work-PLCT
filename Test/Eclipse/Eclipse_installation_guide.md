# Eclipse安装说明

## 1. 编译支持视频输出的QEMU

### 1.1 Ubuntu 20.04上基于源码安装qemu-rv64

#### 1.1.1 通过QEMU源代码构建

- 安装必要的构建工具

```bash
sudo apt install build-essential autoconf automake autotools-dev pkg-config bc curl gawk git bison flex texinfo gperf libtool patchutils mingw-w64 libmpc-dev libmpfr-dev libgmp-dev libexpat-dev libfdt-dev zlib1g-dev libglib2.0-dev libpixman-1-dev libncurses5-dev libncursesw5-dev meson libvirglrenderer-dev libsdl2-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.9 python3-pip  -y
sudo apt install -f
pip3 install meson
```

-  下载支持视频输出QEMU源码包方法1（2选1）

注：如下载连接超时请重试几遍

```bash
git clone -b display https://gitlab.com/wangjunqiang/qemu.git
```

```bash
cd qemu
git submodule init
git submodule update --recursive
mkdir build
cd build
```

- 下载支持视频输出QEMU源码包方法2（2选1）

```bash
wget https://download.qemu.org/qemu-7.0.0.tar.xz
tar xvJf qemu-7.0.0.tar.xz
cd qemu-7.0.0
mkdir build
cd build
```

- 配置riscv64-qemu

以下命令中`xbot`为用户目录名

```bash
../configure  --enable-kvm --enable-sdl --enable-gtk --enable-virglrenderer --enable-opengl --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/home/xbot/program/riscv64-qemu
```

`riscv-64-linux-user`为用户模式，可以运行基于 RISC-V 指令集编译的程序文件, `softmmu`为镜像模拟器，可以运行基于 RISC-V 指令集编译的Linux镜像，为了测试方便，可以两个都安装

- 编译

```bash
make -j $(nproc)
make install
```

如果 `--prefix` 指定的目录位于根目录下，则需要在 `./configure` 前加入 `sudo`

#### 1.1.2 配置环境变量

在环境变量PATH中添加riscv64-qemu所在目录，使相关命令可以直接使用

```bash
vim ~/.bashrc
```

`~/.bashrc`文末添加

````bash
export QEMU_HOME=/home/xbot/program/riscv64-qemu
export PATH=$QEMU_HOME/bin:$PATH
````

**注意一定要将 `QEMU_HOME` 路径替换为 `--prefix` 定义的路径**

检查是否添加成功

```bash
source ~/.bashrc
echo $PATH
```
屏幕回显包含`/home/xbot/program/riscv64-qemu`

```bash
/home/xbot/program/riscv64-qemu/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```

#### 1.1.3 验证安装是否正确

```bash
qemu-system-riscv64 --version
```

如出现类似如下输出表示 QEMU 工作正常

```bash
QEMU emulator version 6.2.90 (v7.0.0-rc0-40-g2058fdbe81)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

或

```bash
QEMU emulator version 7.0.0
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
```

### 1.2 Ubuntu 22.04直接使用apt安装qemu

```bash
sudo apt install qemu-system-riscv64 -y
```

## 2. 系统镜像的使用

### 2.1 镜像下载

#### 2.1.1 下载内容

- 下载 QEMU 目录下的[openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst)、[fw_payload_oe_qemuvirt.elf](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/fw_payload_oe_qemuvirt.elf) 和 [preview_start_vm_xfce.sh](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/preview_start_vm_xfce.sh)
- 下载地址 [https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/)

#### 2.1.2 部署和启动

- 解压 tar.zst 格式的镜像文件

注：解压需要7.4G硬盘空间

```bash
sudo apt install zstd -y
tar -I zstdmt -xvf ./openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst
```

- 执行 `bash preview_start_vm_xfce.sh`

注：QEMU下启动Xfce较慢，请耐心等待

- 输入密码完成登录，默认的用户名和密码为 `root` 和 `openEuler12#$`

## 3. 安装Eclipse

### 3.1 安装Eclipse

- 执行下列指令

```bash
dnf install eclipse
```

- 安装过程中，有些包可能会已经以依赖的形式被安装了，没关系直接跳过。

- root 默认密码为 openEuler12#$

### 3.2 启动Eclipse

- Xfce桌面下打开终端，输入`Eclipse` 启动 Eclipse。

```shell
eclipse
```

- 点击Application Finder图标,搜索Eclipse，点击Launch
