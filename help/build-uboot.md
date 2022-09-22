# 在国内网络环境下编译 riscv-gnu-toolchain

## 简介

[U-Boot](https://www.denx.de/wiki/U-Boot)  是一个主要用于嵌入式系统的引导加载程序，可以支持多种不同的计算机系统结构，包括PPC、ARM、AVR32、MIPS、x86、68k、Nios与MicroBlaze。这也是一套在GNU通用公共许可证之下发布的自由软件。

## 准备依赖

准备 [riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)，并将 `bin` 目录加入 `PATH`，编译教程请参阅 `./build-riscv-toolchain.md`。

## 下载源

```bash
git clone https://ghproxy.com/https://github.com/u-boot/u-boot
```

## 编译

### 配置编译参数

```bash
make CROSS_COMPILE=riscv64-unknown-linux-gnu- qemu-riscv64_smode_defconfig
```

### 启动编译

```bash
make CROSS_COMPILE=riscv64-unknown-linux-gnu- -j24
```

## 测试

结果为 `u-boot.bin` 。
