# Deepin RISC-V

## 安装手册

- 戳这里 -> [安装手册链接](./Installation_Guide.md)

## Linux 6.0.7 Kernel

- 戳这里 -> [Kernel构建手册链接](./Kernel_Build_Guide.md)

- 见fw_payload.elf

## deepin_setup

- 注意：请保证在脚本同目录下有本文件夹的[fw_payload.elf](./fw_payload.elf)文件！

<!-- - 注意：此脚本为半成品，攻城狮正在加紧赶工中（ -->

- 用法：```bash ./deepin_setup.sh [虚拟机线程数] [虚拟机运行内存大小]```

- 例如，如果指定线程数为8,内存大小为8G，那么使用```bash ./deepin_setup.sh 8 8```

- 功能：启动虚拟机，若有缺失文件可下载并现场构建