# 在国内网络环境下编译 riscv-gnu-toolchain

## 简介

[riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) 是 RISC-V 的 C 和 C++ 交叉编译器。它支持两种构建模式：通用 ELF/Newlib 工具链和更复杂的 LinuxELF / glibc 工具链。

## 准备依赖

```bash
sudo apt install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
```

## 下载源

```bash
git clone https://ghproxy.com/https://github.com/riscv/riscv-gnu-toolchain
```

## 拉取子模块

在拉取子模块之前，我们需要修改子模块的链接。

编辑 `.gitmodules` 文件。

```text
[submodule "binutils"]
        path = binutils
        url = https://mirrors.bfsu.edu.cn/git/binutils-gdb.git
        branch = binutils-2_39-branch
[submodule "gcc"]
        path = gcc
        url = https://mirrors.bfsu.edu.cn/git/gcc.git
        branch = releases/gcc-12.1.0
[submodule "glibc"]
        path = glibc
        url = https://mirrors.bfsu.edu.cn/git/glibc.git
[submodule "riscv-dejagnu"]
        path = riscv-dejagnu
        url = https://ghproxy.com/https://github.com/riscv-collab/riscv-dejagnu.git
        branch = riscv-dejagnu-1.6
[submodule "newlib"]
        path = newlib
        url = https://ghproxy.com/https://github.com/mirror/newlib-cygwin.git
        branch = master
[submodule "riscv-gdb"]
        path = riscv-gdb
        url = https://ghproxy.com/https://github.com/riscv-collab/riscv-binutils-gdb.git
        branch = fsf-gdb-10.1-with-sim
[submodule "qemu"]
        path = qemu
        url = https://mirrors.bfsu.edu.cn/git/qemu.git
[submodule "musl"]
        path = musl
        url = https://ghproxy.com/https://github.com/EOSIO/musl.git
        branch = master
[submodule "spike"]
        path = spike
        url = https://ghproxy.com/https://github.com/riscv-software-src/riscv-isa-sim.git
        branch = master
[submodule "pk"]
        path = pk
        url = https://ghproxy.com/https://github.com/riscv-software-src/riscv-pk.git
        branch = master
```

然后使用 `git submodule update --init --recursive` 下载子模块。总大小约 6.65GiB，准备足量磁盘空间。

## 编译

### 配置编译参数

- 使用 `--prefix=` 指定编译结果存放路径，例如 `--prefix=/opt/riscv`。
- 使用 `--with-arch=rv32gc --with-abi=ilp32d` 指定 RV32GC 架构。
- 使用 `--enable-multilib` 指定同时支持 32-bit 和 64-bit，这样您可以使用 `-march` 和/或 `-mabi` 选项以指定架构和位宽。该选项对 musl 不起作用。

```bash
./configure --prefix=/opt/riscv
```

### 启动编译

- 使用 `make` 编译 Newlib 工具链，获得 `riscv64-unknown-elf-*` 等工具。
- 使用 `make linux` 编译 Linux glibc-based 工具链，获得 `riscv64-unknown-linux-gnu-*` 等工具。
- 使用 `make musl` 编译 Linux musl libc-based 工具链，获得 `riscv64-unknown-linux-gnu-*` 等工具。
- 使用 `-j12` 以设定 12 线程编译，线程数建议为核心数的两倍。

## 测试

编译器存放在 `res/bin` 中，将该目录加入 `PATH` 以在任何路径使用。

```bash
./riscv64-unknown-linux-gnu-gcc -v
Using built-in specs.
COLLECT_GCC=./riscv64-unknown-linux-gnu-gcc
COLLECT_LTO_WRAPPER=/home/ariel/resgnu/libexec/gcc/riscv64-unknown-linux-gnu/12.2.0/lto-wrapper
Target: riscv64-unknown-linux-gnu
Configured with: /home/ariel/riscv-gnu-toolchain/gcc/configure --target=riscv64-unknown-linux-gnu --prefix=/home/ariel/resgnu --with-sysroot=/home/ariel/resgnu/sysroot --with-newlib --without-headers --disable-shared --disable-threads --with-system-zlib --enable-tls --enable-languages=c --disable-libatomic --disable-libmudflap --disable-libssp --disable-libquadmath --disable-libgomp --disable-nls --disable-bootstrap --src=/home/ariel/riscv-gnu-toolchain/gcc --disable-multilib --with-abi=lp64d --with-arch=rv64imafdc --with-tune=rocket --with-isa-spec=2.2 'CFLAGS_FOR_TARGET=-O2   -mcmodel=medlow' 'CXXFLAGS_FOR_TARGET=-O2   -mcmodel=medlow'
Thread model: single
Supported LTO compression algorithms: zlib
gcc version 12.2.0 (GCC)
```
