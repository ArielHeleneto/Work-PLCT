# 在国内网络环境下编译 riscv-gnu-toolchain

## 简介

[OpenSBI](https://github.com/riscv-software-src/opensbi) 是 RISC-V SBI 规范的一种 C 语言参考实现。

## 准备依赖

准备 [riscv-collab/riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)，并将 `bin` 目录加入 `PATH`，编译教程请参阅 `./build-riscv-toolchain.md`。

## 下载源

```bash
git clone https://ghproxy.com/https://github.com/riscv/opensbi.git
```

## 编译

### 启动编译

```bash
make CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=generic FW_PAYLOAD_PATH=<uboot_build_directory>/u-boot.bin -j24
```

## 测试

结果为 `opensbi/build/platform/generic/firmware/fw_payload.elf`。其他组件也可以在此找到。

### 启动 qemu

```bash
riscv64-softmmu/qemu-system-riscv64 -M virt -m 256M -nographic -bios ./build/platform/generic/firmware/fw_payload.elf
```
