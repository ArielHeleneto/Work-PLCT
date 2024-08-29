# pinpong for Milk-V Duo

## 简介

pinpong 库是一套控制开源硬件主控板的 Python 库，基于 Firmata 协议并兼容 MicroPython 语法，借助于 pinpong 库，直接用 Python 代码就能给各种常见的开源硬件编程

## 环境配置

### 安装固件

为 TF 卡刷写 [Release](https://github.com/milkv-duo/duo-buildroot-sdk/releases) 的固件中下载前缀为 `arduino` 的固件。本实例使用 [Duo-V1.1.2](https://github.com/milkv-duo/duo-buildroot-sdk/releases/tag/Duo-V1.1.2) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

### 关闭 LED 闪烁

将刷写好的 TF 卡插入 Milk-V Duo。使用电缆连接电脑和 Milk-V Duo。此时电脑上出现 RNDIS 设备和串口设备。安装驱动方法见 [设置工作环境 | Milk-V](https://milkv.io/zh/docs/duo/getting-started/setup)。

[安装驱动录像](./cnc.mp4)

Duo 的默认固件大核 Linux 系统会控制板载 LED 闪烁，这个是通过开机脚本实现的，我们现在要用小核 Arduino 来点亮 LED，需要将大核 Linux 中 LED 闪烁的脚本禁用，在 Duo 的终端中执行 `mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot`。

[移除闪烁](./remove.mkv)

## Demo

See 