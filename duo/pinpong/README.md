# pinpong for Milk-V Duo

## 简介

pinpong 库是一套控制开源硬件主控板的 Python 库，基于 Firmata 协议并兼容 MicroPython 语法，借助于 pinpong 库，直接用 Python 代码就能给各种常见的开源硬件编程

## 环境配置

### 构建镜像

因为有一部分 RAM 被分配绐了 ION，是在使用摄像头跑算法时需要占用的内存。如果不使用摄像头，您可以修改这个 [ION_SIZE](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/build/boards/cv180x/cv1800b_milkv_duo_sd/memmap.py#L43) 的值为 0 然后重新编译生成固件。

编译镜像请参阅 [二、使用 Docker 编译](https://github.com/milkv-duo/duo-buildroot-sdk/blob/develop/README-zh.md#%E4%BA%8C%E4%BD%BF%E7%94%A8-docker-%E7%BC%96%E8%AF%91).

### 安装固件

为 TF 卡刷写固件。本实例使用 [4a3e9b2](https://github.com/milkv-duo/duo-buildroot-sdk/commit/4a3e9b2c16285511198dda619f33e2474aa6bf48) 版本。刷写可使用 [Rufus](https://rufus.ie/zh/)

见 [刷写录像](./shuaxie.mkv)

### 关闭 LED 闪烁

将刷写好的 TF 卡插入 Milk-V Duo。使用电缆连接电脑和 Milk-V Duo。此时电脑上出现 RNDIS 设备和串口设备。安装驱动方法见 [设置工作环境 | Milk-V](https://milkv.io/zh/docs/duo/getting-started/setup)。

[安装驱动录像](./cnc.mp4)

Duo 的默认固件大核 Linux 系统会控制板载 LED 闪烁，这个是通过开机脚本实现的，我们现在要用小核 Arduino 来点亮 LED，需要将大核 Linux 中 LED 闪烁的脚本禁用，在 Duo 的终端中执行 `mv /mnt/system/blink.sh /mnt/system/blink.sh_backup && sync && reboot`。

[移除闪烁](./remove.mkv)

## Demo

### LED 闪烁

该代码可以使板载的**蓝色** LED 灯以 1s 的周期闪烁。

```python
# -*- coding: utf-8 -*-

# 实验效果：控制 Milk-V Duo 板载 LED 灯一秒闪烁一次

import time
import os
from pinpong.board import Board, Pin

# 检查引脚功能
nowtime = os.popen('duo-pinmux -w GP25/GP25')
print(nowtime.read())

Board("MILKV-DUO").begin()  # 初始化，选择板型，不输入板型则进行自动识别
led = Pin(Pin.D25, Pin.OUT)  # 引脚初始化为电平输出

while True:
    led.value(1)  # 输出高电平
    print("1")  # 终端打印信息
    time.sleep(1)  # 等待1秒 保持状态

    led.value(0)  # 输出低电平
    print("0")  # 终端打印信息
    time.sleep(1)  # 等待1秒 保持状态
```


### GPIO

```python
# -*- coding: utf-8 -*-

# 实验效果：控制 Milk-V Duo GPIO PIN6 每秒切换一次电平

import time
import os
from pinpong.board import Board, Pin

# 检查引脚功能
nowtime = os.popen('duo-pinmux -w GP4/GP4')
print(nowtime.read())

Board("MILKV-DUO").begin()  # 初始化，选择板型，不输入板型则进行自动识别
led = Pin(Pin.D4, Pin.OUT)  # 引脚初始化为电平输出

while True:
    led.value(1)  # 输出高电平
    print("1")  # 终端打印信息
    time.sleep(1)  # 等待1秒 保持状态

    led.value(0)  # 输出低电平
    print("0")  # 终端打印信息
    time.sleep(1)  # 等待1秒 保持状态
```

### PWM

```python
# -*- coding: utf-8 -*-

#实验效果：使用按钮控制LED呼吸灯
#接线：使用windows或linux电脑连接一块arduino主控板，主控板D6接一个LED灯模块
import time
from pinpong.board import Board,Pin,PWM #导入PWM类实现模拟输出

Board().begin()  #初始化，选择板型，不输入板型则进行自动识别
#P0 P2 P3 P8 P9 P10 P16 P21 P22 P23
pwm0 = PWM(Pin(Pin.P3)) #将Pin传入PWM中实现模拟输出
#PWM支持0-1023范围

while True:
  for i in range(100): #从0到1023循环
    pwm0.duty(i)  #设置模拟输出值
    print(i)
    time.sleep(0.05)

```

## 未测试

### ADC

TODO: 修改代码和测试

```python
# -*- coding: utf-8 -*-
#实验效果：打印UNIHIKER板所有模拟口的值
#接线：使用windows或linux电脑连接一块UNIHIKER主控板
import time
from pinpong.board import Board,Pin,ADC  #导入ADC类实现模拟输入

Board("milkv-duo").begin()  #初始化，选择板型，不输入板型则进行自动识别

#�模�引� ADC0 ADC1
adc0 = ADC(Pin(Pin.A0)) #将Pin传入ADC中实现模拟输入

while True:
  print("P0=", adc0.read())
  print("------------------")
  time.sleep(0.5)
```

### 蜂鸣器

```python
# -*- coding: utf-8 -*-
#接线：使用windows电脑连接一块PinPong主控板，主控板D5引脚的蜂鸣器
import time
from pinpong.board import Board,Pin,Tone

ip =  "192.168.31.128" #网络配置中OLEB屏上显示的ip
port = 8081    #网络配置中OLEB屏上显示的port
Board(ip, port)

sound = Tone(Pin(Pin.D5)) #将Pin传入Tone中实现模拟输出
sound.freq(200) #按照设置的频率播放

while True:

   for my_variable in range(200, 5001, 1):
       sound.freq(my_variable)
       sound.on()  #打开蜂鸣器
       time.sleep(0.001)
   pass
   for my_variable in range(5001, 199, -1):
       sound.freq(my_variable)
       sound.on()  #打开蜂鸣器
       time.sleep(0.001)
   pass
```