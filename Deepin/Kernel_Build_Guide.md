# 内核构建教程

## 第一步：下载并构建所需RISC-V工具链

- 先下载所需依赖，以Ubuntu为例：

```bash

```

- 从GitHub上下载RISC-V工具链源码。由于其由多个submodules组成，故需要递归克隆。

```bash
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
git submodule update --init --recursive
```

> 有时因为网络问题，中途可能会失败。这时别灰心，如果除了qemu以外其他均下载完成，则下载失败后可递归删除qemu目录（本教程面对的是包管理器完善的Linux发行版本，qemu请使用包管理器装好）

- 构建工具链
  
- Ubuntu下：

```bash
sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
```

- Fedora下：

```bash
sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel 
```

```bash
./configure --prefix=/opt/riscv --enable-multilib
sudo make linux
```

- 编译后，我们的交叉编译工具链就被安装到/opt/riscv目录下。工具链的前缀为 riscv64-unknown-linux-gnu-，能同时支持32-bit和64-bit系统。

- 将/opt/riscv加入PATH（可以打开终端时执行PATH="$PATH":/opt/riscv，也可以使用其他方法使PATH永久生效）

## 第二步：下载并构建内核

```bash
wget https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v6.x/linux-6.0.7.tar.xz
tar xvfJ linux-6.0.7.tar.xz
cd linux-6.0.7
make -j`nproc` ARCH=riscv defconfig
make -j`nproc` ARCH=riscv menuconfig
```

- 然后弹出Linux内核编译配置界面，点按右箭头，选择EXIT，确认保存后退出（使用默认选项）。

```bash
make -j`nproc` ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu-
```

- 编译完成后，在linux-6.0.7/arch/riscv/boot目录下就能找到编译后的内核镜像，分别为Image和Image.gz

## 第三步：下载并构建fw_payload.elf

- 使用OpenSBI

```bash
git clone https://github.com/riscv-software-src/opensbi
cd opensbi
export CROSS_COMPILE=riscv64-unknown-linux-gnu-
make -j`nproc` PLATFORM=generic FW_PAYLOAD_PATH=../linux-6.0.7/arch/riscv/boot/Image
```

- 完毕！您的fw_payload.elf放置在build/platform/generic/firmware/目录下，快拿去替换原来的payload吧 :)

- 此教程适用于5.2.4及以上版本的内核构建，版本不同，相应的文件及文件夹名称需要发生改变。