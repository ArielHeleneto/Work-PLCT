# Arduino for Milk-V Duo

## 简介

Arduino 是一个很流行的开源硬件平台，具有简洁性、易用性和开放性等优点。它提供了丰富的库函数和示例代码，使得即使对于没有编程经验的人来说，也能够快速上手。同时，Arduino 社区非常活跃，您可以轻松地获取到各种项目教程、文档和支持。

Milk-V Duo 系列已经支持 Arduino 开发，您可以直接使用 Arduino IDE，进行简单的配置后即可使用。

Duo 系列 CPU 采用大小核设计，Arduino 固件运行在小核中，大核负责与 Arduino IDE 通讯，接收 Arduino 固件并将其加载到小核中运行。同时，大核中的 Linux 系统也是正常运行的。

## 环境配置

### 安装 Arduino IDE

在 [Software | Arduino](https://www.arduino.cc/en/software) 下载。本实例使用 `Windows Win 10 and newer, 64 bits` 版本。安装之。

见 [安装录像](./anzhuang.mkv)

### 安装固件

为 TF 卡刷写 [Release](https://github.com/milkv-duo/duo-buildroot-sdk/releases) 的固件中下载前缀为 `arduino` 的固件。本实例使用 [Duo-V1.0.9](https://github.com/milkv-duo/duo-buildroot-sdk/releases/tag/Duo-V1.0.9) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

### Arduino IDE 中添加 Duo 开发板

打开 Arduino IDE，打开 `File - Perferences` （*文件 - 首选项*），在 `Settings`（*设置*） 标签中的 `Additional boards manager URLs:`（*其他开发板管理器地址*） 内添加 Milk-V Duo 的配置文件地址 `https://github.com/milkv-duo/duo-arduino/releases/download/config/package_sg200x_index.json`。亦可在此页面将语言调整为中文。

配置好之后在左侧边栏中选择 `Boards Manager`（*开发板管理器*），搜索 `SG200X`，点击安装。本实例中安装了 `0.2.4` 版本。

见 [环境录像](./huanjing.mkv)

### 关闭 LED 闪烁

将刷写好的 TF 卡插入 Milk-V Duo。使用电缆连接电脑和 Milk-V Duo。此时电脑上出现 RNDIS 设备和串口设备。安装驱动方法见 [设置工作环境 | Milk-V](https://milkv.io/zh/docs/duo/getting-started/setup)。

[安装驱动录像](./drivers.mkv)

Duo 的默认固件大核 Linux 系统会控制板载 LED 闪烁，这个是通过开机脚本实现的，我们现在要用小核 Arduino 来点亮 LED，需要将大核 Linux 中 LED 闪烁的脚本禁用，在 Duo 的终端中执行 `mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot`。

[移除闪烁](./remove.mkv)

## 闪烁 LED 灯

在 Arduino IDE 的 文件 菜单中依次打开 示例 > 01.Basics > Blink 测试程序，该程序功能实现的是 Arduino 设备板载 LED 闪烁，Duo 中也是支持的，你也许需要安装 pyserial （**不是 serial**） 来支持上传功能，之后我们直接点 上传 按钮进行测试。

[上传](./pyserial.mkv)

[闪烁](./record.mp4)

