# wiringX for Milk-V Duo

## 简介

TODO: 简介

## 环境配置

使用 Ubuntu 24.04 测试。

```bash
sudo apt install wget git make -y
git clone https://github.com/milkv-duo/duo-examples.git --depth=1
cd duo-examples
source envsetup.sh
```

运行后会自动加载工具链。

## Demo

### hello-world

位于 [hello-world](https://github.com/milkv-duo/duo-examples/tree/main/hello-world) 中。使用 `make` 编译获得产物 `helloworld` 上传至 Milk-V Duo 上运行。

运行后输出如下。

```
Hello, World!
```

### blink

首先禁用自带的闪烁脚本。

```bash
mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot
```

位于 [blink](https://github.com/milkv-duo/duo-examples/tree/main/blink) 中。使用 `make` 编译获得产物 `blink` 上传至 Milk-V Duo 上运行。

运行后输出如下。

```
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
Duo LED GPIO (wiringX) 25: High
Duo LED GPIO (wiringX) 25: Low
```

当电平为高时 LED 灯亮起，电平低时 LED 熄灭。见 [blink.mp4](./blink.mp4)

### PWM

位于 [pwm](https://github.com/milkv-duo/duo-examples/tree/main/pwm) 中。使用 `make` 编译获得产物 `pwm` 上传至 Milk-V Duo 上运行。

运行后，输入 `3:500` 输出如下。

```
./pwm 
PWM Period fixed to 1000ns, please set Duty in range of 0-1000.
Enter -> Pin:Duty
3:500
ERROR: The milkv_duo256m does not support the pwmEnable functionality
ERROR: The milkv_duo256m does not support the pwmSetPolarity functionality
ERROR: The milkv_duo256m does not support the pwmSetPeriod functionality
ERROR: The milkv_duo256m does not support the pwmSetDuty functionality
pin 3 -> duty 500
```

TODO: 测试未通过

### ADC

将电位器的左右两脚连接到 3.3V 和 GND。中间脚位连接到 PIN31。

位于 [adc](https://github.com/milkv-duo/duo-examples/tree/main/adc) 中。使用 `make` 编译获得产物 `adcRead` 上传至 Milk-V Duo 上运行。

运行后，输入 `1` 输出如下。

```
BusyBox v1.34.0 (2024-05-28 20:37:57 CST) multi-call binary.

Usage: insmod FILE [SYMBOL=VALUE]...

Load kernel module
SARADC module loaded.
Define the ADC channel: 
 1: ADC1 (GP26|PIN31)
 2: ADC2 (GP27|PIN32)
 3: ???
 4: VDDC_RTC
 5: PWR_GPIO1
 6: PWR_VBAT_V
1
ADC1 value is 0
ADC1 value is 0
ADC1 value is 75
ADC1 value is 0
ADC1 value is 1
ADC1 value is 1267
ADC1 value is 0
ADC1 value is 0
ADC1 value is 1704
ADC1 value is 4035
ADC1 value is 3984
ADC1 value is 3992
ADC1 value is 4001
ADC1 value is 3978
ADC1 value is 4000
ADC1 value is 3744
ADC1 value is 2968
ADC1 value is 2144
ADC1 value is 1670
ADC1 value is 0
ADC1 value is 2
ADC1 value is 4
ADC1 value is 0
ADC1 value is 8
ADC1 value is 0
ADC1 value is 3
ADC1 value is 0
ADC1 value is 0
ADC1 value is 14
ADC1 value is 0
ADC1 value is 3
ADC1 value is 0
ADC1 value is 5
ADC1 value is 3724
ADC1 value is 3688
ADC1 value is 4048
ADC1 value is 4000
ADC1 value is 0
ADC1 value is 0
ADC1 value is 0
ADC1 value is 1353
ADC1 value is 1360
ADC1 value is 3596
ADC1 value is 4016
ADC1 value is 3984
ADC1 value is 4018
ADC1 value is 4040
ADC1 value is 4016
ADC1 value is 4032
ADC1 value is 4000
ADC1 value is 4016
```

随着电位器旋转，数值发生变化。

### SSD1306

I2C1_SDA 接 SDA，I2C1_SCL 接 SCL，3.3v 接 VCC，GND 接 GND。

位于 [ssd1306_i2c](https://github.com/milkv-duo/duo-examples/tree/main/i2c/ssd1306_i2c) 中。使用 `make` 编译获得产物 `ssd1306_i2c` 上传至 Milk-V Duo 上运行。

运行无输出。

波形如 [ssd1306wave](ssd1306wave.png)。

显示屏如 [ssd1306](ssd1306.jpg)。

### LCM1602

I2C1_SDA 接 SDA，I2C1_SCL 接 SCL，3.3v 接 VCC，GND 接 GND。

位于 [lcm1602_i2c](https://github.com/milkv-duo/duo-examples/blob/main/i2c/lcm1602_i2c) 中。修改 41 行 `0x27` 为 `0x3F`，使用 `make` 编译获得产物 `lcm1602_i2c` 上传至 Milk-V Duo 上运行。

运行无输出。

波形如 [lcm1602wave](lcm1602wave.png)。

显示屏如 [lcm16026](lcm1602.jpg)。